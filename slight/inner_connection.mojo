from pathlib import Path
from sys.ffi import c_char

from memory import Pointer, UnsafeMutPointer
from slight.c.api import get_sqlite3_handle
from slight.c.raw_bindings import (
    RESULT_MESSAGES,
    sqlite3_connection,
    sqlite3_stmt,
)
from slight.flags import PrepFlag, OpenFlag
from slight.result import SQLite3Result
from slight.error import error_msg, raise_if_error, decode_error


struct InnerConnection(Movable):
    """A connection to a SQLite3 database."""

    var db: ExternalMutPointer[sqlite3_connection]

    # TODO: Enable zVfs support in the future.
    fn __init__(out self, var path: String, flags: OpenFlag) raises:
        """Open a SQLite3 database connection with default flags.

        Args:
            path: The file path to the SQLite database.
            flags: The flags to use when opening the database.

        Returns:
            A new wrapper connection around an open sqlite3 connection.

        Raises:
            Will return an `Error` if the underlying SQLite open call fails.
        """
        self.db = ExternalMutPointer[sqlite3_connection]()
        var result = get_sqlite3_handle()[].open_v2(
            path, UnsafePointerV2(to=self.db), flags.value, None
        )
        if result != SQLite3Result.SQLITE_OK:
            raise Error("Could not open database: ", materialize[RESULT_MESSAGES]()[result.value])

    @doc_private
    fn __init__(out self):
        """Creates an empty InnerConnection.

        Returns:
            A new `InnerConnection` instance.
        """
        self.db = ExternalMutPointer[sqlite3_connection]()

    fn __init__(out self, db: ExternalMutPointer[sqlite3_connection]):
        """Creates a new `InnerConnection` from an existing `sqlite3_connection` pointer.

        Args:
            db: An existing `sqlite3_connection` pointer.

        Returns:
            A new `InnerConnection` instance.
        """
        self.db = db

    fn __moveinit__(out self, deinit other: Self):
        """Move-initializes a new connection from the given connection.

        Args:
            other: The connection to move from.

        Returns:
            A new `InnerConnection` instance.
        """
        self.db = other^.take_connection()
        other = InnerConnection()

    fn __bool__(self) -> Bool:
        """Returns whether the connection is open.

        Returns:
            Whether the pointer to the sqlite3 connection is valid or not.
        """
        return Bool(self.db)

    fn take_connection(var self) -> ExternalMutPointer[sqlite3_connection]:
        """Consume the connection and return the pointer to sqlite3.

        Returns:
            The pointer to the underlying sqlite3 connection.
        """
        var db = self.db
        self.db = ExternalMutPointer[sqlite3_connection]()
        return db

    fn is_autocommit(self) -> Bool:
        """Returns whether the connection is in auto-commit mode.

        Returns:
            True if the connection is in auto-commit mode, False otherwise.
        """
        return get_sqlite3_handle()[].get_autocommit(self.db)

    fn is_busy(self) -> Bool:
        """Returns whether the connection is currently busy.

        Returns:
            True if the connection is busy, False otherwise.
        """
        var stmt = get_sqlite3_handle()[].next_stmt(self.db, ExternalMutPointer[sqlite3_stmt]())
        while stmt:
            if get_sqlite3_handle()[].stmt_busy(stmt) != 0:
                return True
            stmt = get_sqlite3_handle()[].next_stmt(self.db, stmt)
        return False

    fn close(deinit self) -> SQLite3Result:
        """Closes the underlying sqlite3 connection.

        Returns:
            The SQLite3Result code from the close operation.
        """
        if not self.db:
            return SQLite3Result.SQLITE_OK

        return get_sqlite3_handle()[].close(self.db)

    fn changes(self) -> Int64:
        """Returns the number of rows changed by the last INSERT, UPDATE, or DELETE statement.

        Returns:
            The number of rows changed.
        """
        return get_sqlite3_handle()[].changes64(self.db)

    fn total_changes(self) -> Int64:
        """Returns the total number of changes made to the database.

        Returns:
            The total number of changes.
        """
        return get_sqlite3_handle()[].total_changes64(self.db)

    fn last_insert_row_id(self) -> Int64:
        """Returns the row ID of the last inserted row.

        Returns:
            The row ID of the last inserted row.
        """
        return get_sqlite3_handle()[].last_insert_rowid(self.db)

    fn prepare(
        self, var sql: String, flags: PrepFlag = PrepFlag.PREPARE_PERSISTENT
    ) raises -> Tuple[ExternalMutPointer[sqlite3_stmt], UInt]:
        """Prepares an SQL statement for execution.

        Args:
            sql: The SQL statement to prepare.
            flags: The flags to use when preparing the statement.

        Returns:
            A tuple containing a pointer to the prepared statement and the length of the remaining unused SQL text.

        Raises:
            Will return an `Error` if the underlying SQLite prepare call fails.
        """
        var stmt = ExternalMutPointer[sqlite3_stmt]()
        var str = UnsafePointerV2(sql.unsafe_cstr_ptr())
        var c_tail = UnsafePointerV2(to=str)

        try:
            self.raise_if_error(
                get_sqlite3_handle()[].prepare_v3(self.db, str, Int32(len(sql)), flags.value, stmt, c_tail),
            )
        except e:
            if stmt:
                _ = get_sqlite3_handle()[].finalize(stmt)
            raise e

        var tail: UInt = 0
        var tail_len = len(StringSlice(unsafe_from_utf8_ptr=c_tail[]))
        if tail_len > 0:
            var n = len(sql) - tail_len

            # Somehow the remaining tail is negative, or is longer than the original sql. Set to 0.
            if n <= 0 or n >= len(sql):
                tail = 0
            else:
                tail = UInt(n)
        return stmt, tail

    fn path(self) -> Optional[Path]:
        """Returns the file path of the database.

        Returns:
            The file path of the database, or None if the database is in-memory.
        """
        var db_name = String("main")
        var path = get_sqlite3_handle()[].db_filename(self.db, db_name)
        if not path:
            return None

        return Path(path.value())

    fn is_database_read_only(self, var database: String) raises -> Bool:
        """Checks if the specified database is opened in read-only mode.

        Args:
            database: The name of the database (e.g., "main", "temp").

        Returns:
            True if the database is read-only, False otherwise.
        """
        var result = get_sqlite3_handle()[].db_readonly(self.db, database)
        if result == SQLite3Result.SQLITE_OK:
            return True
        elif result == SQLite3Result.SQLITE_ERROR:
            return False
        elif result.value == -1:
            raise Error("SQLITE_MISUSE: The given database name is not valid: ", database)
        else:
            raise Error("Unexpected result from sqlite3_db_readonly: ", materialize[RESULT_MESSAGES]()[result.value])

    fn raise_if_error(self, code: SQLite3Result) raises:
        """Raises if the SQLite error code is not `SQLITE_OK`.

        Args:
            code: The SQLite error code.

        Raises:
            Error: If the SQLite error code is not `SQLITE_OK`.
        """
        raise_if_error(self.db, code)

    fn error_msg(self, code: SQLite3Result) -> Optional[StringSlice[ImmutableAnyOrigin]]:
        """Checks for the error message set in sqlite3, or what the description of the provided code is.

        Args:
            code: The SQLite error code.

        Returns:
            An optional string slice containing the error message, or None if not found.
        """
        return error_msg(self.db, code)

    fn decode_error(self, code: SQLite3Result) -> Error:
        """Raises if the SQLite error code is not `SQLITE_OK`.

        Args:
            code: The SQLite error code.

        Returns:
            Error: If the SQLite error code is not `SQLITE_OK`.
        """
        return decode_error(self.db, code)
