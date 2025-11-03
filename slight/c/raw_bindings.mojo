import os
import pathlib
from sys import ffi, env_get_string
from sys.ffi import DLHandle, c_char, c_uchar, c_int, c_uint, c_ulong, CompilationTarget

from slight.c.types import (
    sqlite3_backup,
    sqlite3_blob,
    sqlite3_connection,
    sqlite3_context,
    ResultDestructorFn,
    sqlite3_file,
    sqlite3_index_info,
    sqlite3_snapshot,
    sqlite3_stmt,
    sqlite3_value,
    sqlite3_module,
)


alias ExecCallbackFn = fn[argv_origin: MutOrigin, col_name_origin: MutOrigin] (
    data: OpaqueMutPointer,
    argc: Int32,
    argv: UnsafeMutPointer[UnsafeMutPointer[c_char, argv_origin]],
    azColName: UnsafeMutPointer[UnsafeMutPointer[c_char, col_name_origin]],
) -> c_int

alias AuthCallbackFn = fn[
    origin: MutOrigin, origin2: ImmutOrigin, origin3: ImmutOrigin, origin4: ImmutOrigin, origin5: ImmutOrigin
] (
    OpaqueMutPointer[origin],
    c_int,
    UnsafeImmutPointer[c_char, origin2],
    UnsafeImmutPointer[c_char, origin3],
    UnsafeImmutPointer[c_char, origin4],
    UnsafeImmutPointer[c_char, origin5],
) -> c_int

alias SQLITE_OPEN_READONLY: Int32 = 0x00000001  # Ok for sqlite3_open_v2()
alias SQLITE_OPEN_READWRITE: Int32 = 0x00000002  # Ok for sqlite3_open_v2()
alias SQLITE_OPEN_CREATE: Int32 = 0x00000004  # Ok for sqlite3_open_v2()
alias SQLITE_OPEN_DELETEONCLOSE: Int32 = 0x00000008  # VFS only
alias SQLITE_OPEN_EXCLUSIVE: Int32 = 0x00000010  # VFS only
alias SQLITE_OPEN_AUTOPROXY: Int32 = 0x00000020  # VFS only
alias SQLITE_OPEN_URI: Int32 = 0x00000040  # Ok for sqlite3_open_v2()
alias SQLITE_OPEN_MEMORY: Int32 = 0x00000080  # Ok for sqlite3_open_v2()
alias SQLITE_OPEN_MAIN_DB: Int32 = 0x00000100  # VFS only
alias SQLITE_OPEN_TEMP_DB: Int32 = 0x00000200  # VFS only
alias SQLITE_OPEN_TRANSIENT_DB: Int32 = 0x00000400  # VFS only
alias SQLITE_OPEN_MAIN_JOURNAL: Int32 = 0x00000800  # VFS only
alias SQLITE_OPEN_TEMP_JOURNAL: Int32 = 0x00001000  # VFS only
alias SQLITE_OPEN_SUBJOURNAL: Int32 = 0x00002000  # VFS only
alias SQLITE_OPEN_SUPER_JOURNAL: Int32 = 0x00004000  # VFS only
alias SQLITE_OPEN_NOMUTEX: Int32 = 0x00008000  # Ok for sqlite3_open_v2()
alias SQLITE_OPEN_FULLMUTEX: Int32 = 0x00010000  # Ok for sqlite3_open_v2()
alias SQLITE_OPEN_SHAREDCACHE: Int32 = 0x00020000  # Ok for sqlite3_open_v2()
alias SQLITE_OPEN_PRIVATECACHE: Int32 = 0x00040000  # Ok for sqlite3_open_v2()
alias SQLITE_OPEN_WAL: Int32 = 0x00080000  # VFS only
alias SQLITE_OPEN_NOFOLLOW: Int32 = 0x01000000  # Ok for sqlite3_open_v2()
alias SQLITE_OPEN_EXRESCODE: Int32 = 0x02000000  # Extended result codes

alias SQLITE_OK: Int32 = 0
alias SQLITE_ERROR: Int32 = 1
alias SQLITE_INTERNAL: Int32 = 2
alias SQLITE_PERM: Int32 = 3
alias SQLITE_ABORT: Int32 = 4
alias SQLITE_BUSY: Int32 = 5
alias SQLITE_LOCKED: Int32 = 6
alias SQLITE_NOMEM: Int32 = 7
alias SQLITE_READONLY: Int32 = 8
alias SQLITE_INTERRUPT: Int32 = 9
alias SQLITE_IOERR: Int32 = 10
alias SQLITE_CORRUPT: Int32 = 11
alias SQLITE_NOTFOUND: Int32 = 12
alias SQLITE_FULL: Int32 = 13
alias SQLITE_CANTOPEN: Int32 = 14
alias SQLITE_PROTOCOL: Int32 = 15
alias SQLITE_EMPTY: Int32 = 16
alias SQLITE_SCHEMA: Int32 = 17
alias SQLITE_TOOBIG: Int32 = 18
alias SQLITE_CONSTRAINT: Int32 = 19
alias SQLITE_MISMATCH: Int32 = 20
alias SQLITE_MISUSE: Int32 = 21
alias SQLITE_NOLFS: Int32 = 22
alias SQLITE_AUTH: Int32 = 23
alias SQLITE_FORMAT: Int32 = 24
alias SQLITE_RANGE: Int32 = 25
alias SQLITE_NOTADB: Int32 = 26
alias SQLITE_NOTICE: Int32 = 27
alias SQLITE_WARNING: Int32 = 28
alias SQLITE_ROW: Int32 = 100
alias SQLITE_DONE: Int32 = 101


alias RESULT_MESSAGES: Dict[Int32, StaticString] = {
    SQLITE_OK: "Successful result",
    SQLITE_ERROR: "Generic error",
    SQLITE_INTERNAL: "Internal logic error in SQLite",
    SQLITE_PERM: "Access permission denied",
    SQLITE_ABORT: "Callback routine requested an abort",
    SQLITE_BUSY: "The database file is locked",
    SQLITE_LOCKED: "A table in the database is locked",
    SQLITE_NOMEM: "A malloc() failed",
    SQLITE_READONLY: "Attempt to write a readonly database",
    SQLITE_INTERRUPT: "Operation terminated by sqlite3_interrupt()",
    SQLITE_IOERR: "Some kind of disk I/O error occurred",
    SQLITE_CORRUPT: "The database disk image is malformed",
    SQLITE_NOTFOUND: "Unknown opcode in sqlite3_file_control()",
    SQLITE_FULL: "Insertion failed because database is full",
    SQLITE_CANTOPEN: "Unable to open the database file",
    SQLITE_PROTOCOL: "Database lock protocol error",
    SQLITE_EMPTY: "Internal use only",
    SQLITE_SCHEMA: "The database schema changed",
    SQLITE_TOOBIG: "String or BLOB exceeds size limit",
    SQLITE_CONSTRAINT: "Abort due to constraint violation",
    SQLITE_MISMATCH: "Data type mismatch",
    SQLITE_MISUSE: "Library used incorrectly",
    SQLITE_NOLFS: "Uses OS features not supported on host",
    SQLITE_AUTH: "Authorization denied",
    SQLITE_FORMAT: "Not used",
    SQLITE_RANGE: "2nd parameter to sqlite3_bind out of range",
    SQLITE_NOTADB: "File opened that is not a database file",
    SQLITE_NOTICE: "Notifications from sqlite3_log()",
    SQLITE_WARNING: "Warnings from sqlite3_log()",
    SQLITE_ROW: "sqlite3_step() has another row ready",
    SQLITE_DONE: "sqlite3_step() has finished executing",
}


@fieldwise_init
struct _sqlite3(Movable):
    """SQLite3 C API binding struct.

    This struct provides a high-level interface to the SQLite3 C library
    by dynamically loading the shared library and exposing the C functions
    as Mojo methods. It handles the FFI (Foreign Function Interface) calls
    to the underlying SQLite3 C implementation.
    """

    var lib: DLHandle

    fn __init__(out self):
        """Initialize the SQLite3 binding by loading the dynamic library.

        This constructor attempts to load the SQLite3 shared library from
        the expected location. If loading fails, the program will abort.

        Aborts if the SQLite3 library cannot be loaded.
        """
        var path = String(env_get_string["SQLITE_LIB_PATH", ""]())

        # If the program was not compiled with a specific path, then check if it was set via environment variable.
        if path == "":
            path = os.getenv("SQLITE_LIB_PATH")

        try:
            # If its not explicitly set, then assume the program is running from the root of the project.
            if path == "":

                @parameter
                if CompilationTarget.is_macos():
                    path = String(pathlib.cwd() / ".pixi/envs/default/lib/libsqlite3.dylib")
                else:
                    path = String(pathlib.cwd() / ".pixi/envs/default/lib/libsqlite3.so")

            if not pathlib.Path(path).exists():
                os.abort(
                    "The path to the SQLite library is not set. Set the path as either a compilation variable with `-D"
                    " SQLITE_LIB_PATH=/path/to/libsqlite3.dylib` or SQLITE_LIB_PATH=/path/to/libsqlite3.so`."
                    " Or set the `SQLITE_LIB_PATH` environment variable to the path to the sqlite3 library like"
                    " `SQLITE_LIB_PATH=/path/to/libsqlite3.dylib` or `SQLITE_LIB_PATH=/path/to/libsqlite3.so`."
                    " The default path is `.pixi/envs/default/lib/libsqlite3.dylib (or .so)`, but this"
                    " error indicates that the library did not exist at that location."
                )
            self.lib = ffi.DLHandle(path, ffi.RTLD.LAZY)
        except e:
            self.lib = os.abort[ffi.DLHandle](String("Failed to load the SQLite library: ", e))

    fn sqlite3_libversion(self) -> ExternalImmutPointer[c_char]:
        """Get the SQLite library version string.

        Returns a pointer to a string containing the version of the SQLite
        library that is running. This corresponds to the SQLITE_VERSION
        string.

        Returns:
            Pointer to a null-terminated string containing the SQLite version.
        """
        return self.lib.get_function[fn () -> ExternalImmutPointer[c_char]]("sqlite3_libversion")()

    fn sqlite3_sourceid(self) -> ExternalImmutPointer[c_char]:
        """Get the SQLite source ID.

        Returns a pointer to a string containing the date and time of
        the check-in (UTC) and a SHA1 hash of the entire source tree.

        Returns:
            Pointer to a string containing the SQLite source identifier.
        """
        return self.lib.get_function[fn () -> ExternalImmutPointer[c_char]]("sqlite3_sourceid")()

    fn sqlite3_libversion_number(self) -> c_int:
        """Get the SQLite library version number.

        Returns an integer equal to SQLITE_VERSION_NUMBER. The version
        number is in the format (X*1000000 + Y*1000 + Z) where X, Y, and Z
        are the major, minor, and release numbers respectively.

        Returns:
            The SQLite library version as an integer.
        """
        return self.lib.get_function[fn () -> c_int]("sqlite3_libversion_number")()

    fn sqlite3_threadsafe(self) -> c_int:
        """Test if the library is threadsafe.

        Returns zero if and only if SQLite was compiled with mutexing code
        omitted due to the SQLITE_THREADSAFE compile-time option being set to 0.

        Returns:
            Non-zero if SQLite is threadsafe, 0 if not threadsafe.
        """
        return self.lib.get_function[fn () -> c_int]("sqlite3_threadsafe")()

    fn sqlite3_close(self, connection: ExternalMutPointer[sqlite3_connection]) -> c_int:
        """Closing A Database Connection.

        ^The `sqlite3_close()` and `sqlite3_close_v2()` routines are destructors
        for the [sqlite3] object.
        ^Calls to `sqlite3_close()` and `sqlite3_close_v2()` return [SQLITE_OK] if
        the [sqlite3] object is successfully destroyed and all associated
        resources are deallocated.

        Ideally, applications should [sqlite3_finalize | finalize] all
        [prepared statements], [sqlite3_blob_close | close] all [BLOB handles], and
        [sqlite3_backup_finish | finish] all [sqlite3_backup] objects associated
        with the [sqlite3] object prior to attempting to close the object.
        ^If the database connection is associated with unfinalized prepared
        statements, BLOB handlers, and/or unfinished sqlite3_backup objects then
        `sqlite3_close()` will leave the database connection open and return
        [SQLITE_BUSY]. ^If `sqlite3_close_v2()` is called with unfinalized prepared
        statements, unclosed BLOB handlers, and/or unfinished sqlite3_backups,
        it returns [SQLITE_OK] regardless, but instead of deallocating the database
        connection immediately, it marks the database connection as an unusable
        "zombie" and makes arrangements to automatically deallocate the database
        connection after all prepared statements are finalized, all BLOB handles
        are closed, and all backups have finished. The `sqlite3_close_v2()` interface
        is intended for use with host languages that are garbage collected, and
        where the order in which destructors are called is arbitrary.

        ^If an [sqlite3] object is destroyed while a transaction is open,
        the transaction is automatically rolled back.

        The C parameter to [sqlite3_close(C)] and [sqlite3_close_v2(C)]
        must be either a NULL
        pointer or an [sqlite3] object pointer obtained
        from [sqlite3_open()], or
        [sqlite3_open_v2()], and not previously closed.
        ^Calling `sqlite3_close()` or `sqlite3_close_v2()` with a NULL pointer
        argument is a harmless no-op.
        """
        return self.lib.get_function[fn (type_of(connection)) -> c_int]("sqlite3_close")(connection)

    fn sqlite3_config(self, op: c_int) -> c_int:
        """Configure The SQLite Library.

        The sqlite3_config() interface is used to make global configuration
        changes to SQLite in order to tune SQLite to the specific needs of
        the application. The default configuration is recommended for most
        applications, but advanced applications may wish to fine-tune SQLite.

        The sqlite3_config() interface is not threadsafe. The application
        must ensure that no other SQLite interfaces are invoked by other
        threads while sqlite3_config() is running. Furthermore, sqlite3_config()
        may only be invoked prior to library initialization using
        sqlite3_initialize() or after shutdown by sqlite3_shutdown().

        Args:
            op: Configuration option to set (e.g., SQLITE_CONFIG_SINGLETHREAD).

        Returns:
            SQLITE_OK on success, or an error code on failure.
        """
        return self.lib.get_function[fn (c_int) -> c_int]("sqlite3_config")(op)

    fn sqlite3_db_config(self, db: ExternalMutPointer[sqlite3_connection], op: c_int) -> c_int:
        """Configure Database Connection Options.

        The sqlite3_db_config() interface is used to make configuration
        changes to a database connection. The interface is similar to
        sqlite3_config() except that the changes apply to a single database
        connection specified in the first argument.

        The sqlite3_db_config() interface should only be used immediately
        after creating the database connection using sqlite3_open() or its
        variants, and before the database connection is used to prepare
        and execute SQL statements.

        Args:
            db: Database connection handle.
            op: Configuration option to set (e.g., SQLITE_DBCONFIG_ENABLE_FKEY).

        Returns:
            SQLITE_OK on success, or an error code on failure.
        """
        return self.lib.get_function[fn (type_of(db), type_of(op)) -> c_int]("sqlite3_db_config")(db, op)

    fn sqlite3_extended_result_codes(self, db: ExternalMutPointer[sqlite3_connection], onoff: c_int) -> c_int:
        """Enable Or Disable Extended Result Codes.

        The sqlite3_extended_result_codes() routine enables or disables the
        extended result codes feature of SQLite. The extended result codes
        are disabled by default for historical compatibility reasons.

        When extended result codes are enabled, SQLite will return more
        specific error codes that provide additional information about
        the nature of an error. For example, instead of just returning
        SQLITE_IOERR, SQLite might return SQLITE_IOERR_READ, SQLITE_IOERR_WRITE,
        SQLITE_IOERR_FSYNC, etc.

        Args:
            db: Database connection handle.
            onoff: Enable extended codes if non-zero, disable if zero.

        Returns:
            SQLITE_OK on success, or an error code on failure.
        """
        return self.lib.get_function[fn (type_of(db), type_of(onoff)) -> c_int]("sqlite3_extended_result_codes")(
            db, onoff
        )

    fn sqlite3_last_insert_rowid(self, db: ExternalMutPointer[sqlite3_connection]) -> Int64:
        """Last Insert Rowid.

        Each entry in most SQLite tables has a unique 64-bit signed integer key
        called the "rowid". This function returns the rowid of the most recent
        successful INSERT into the database from the database connection shown
        in the first argument.

        Args:
            db: Database connection handle.

        Returns:
            The rowid of the most recent INSERT, or 0 if no INSERTs have been performed.
        """
        return self.lib.get_function[fn (type_of(db)) -> Int64]("sqlite3_last_insert_rowid")(db)

    fn sqlite3_changes(self, db: ExternalMutPointer[sqlite3_connection]) -> c_int:
        """Count The Number of Rows Modified.

        This function returns the number of rows modified, inserted or deleted
        by the most recently completed INSERT, UPDATE, or DELETE statement on
        the database connection specified in the first argument.

        Args:
            db: Database connection handle.

        Returns:
            Number of rows changed by the most recent INSERT, UPDATE, or DELETE.
        """
        return self.lib.get_function[fn (type_of(db)) -> c_int]("sqlite3_changes")(db)

    fn sqlite3_changes64(self, db: ExternalMutPointer[sqlite3_connection]) -> Int64:
        """Count The Number of Rows Modified (64-bit).

        This function works the same as sqlite3_changes() except that it
        returns the count as a 64-bit signed integer. This routine can
        return accurate change counts even when more than 2 billion rows
        are modified.

        The sqlite3_changes64() function returns the number of rows modified,
        inserted or deleted by the most recently completed INSERT, UPDATE,
        or DELETE statement on the database connection specified in the
        first argument.

        Args:
            db: Database connection handle.

        Returns:
            Number of rows changed by the most recent INSERT, UPDATE, or DELETE
            as a 64-bit signed integer.
        """
        return self.lib.get_function[fn (type_of(db)) -> Int64]("sqlite3_changes64")(db)

    fn sqlite3_total_changes(self, db: ExternalMutPointer[sqlite3_connection]) -> c_int:
        """Count The Total Number of Rows Modified.

        This function returns the total number of rows inserted, modified or
        deleted by all INSERT, UPDATE or DELETE statements completed since
        the database connection was opened, including those executed as part
        of trigger programs.

        Changes made as part of foreign key actions are not counted separately,
        nor are changes made by executing individual SQL statements within
        a trigger program.

        Args:
            db: Database connection handle.

        Returns:
            Total number of rows changed since the database connection was opened.
        """
        return self.lib.get_function[fn (type_of(db)) -> c_int]("sqlite3_total_changes")(db)

    fn sqlite3_total_changes64(self, db: ExternalMutPointer[sqlite3_connection]) -> Int64:
        """Count The Total Number of Rows Modified (64-bit).

        This function works the same as sqlite3_total_changes() except that it
        returns the count as a 64-bit signed integer. This routine can return
        accurate change counts even when more than 2 billion rows have been
        modified in total.

        This function returns the total number of rows inserted, modified or
        deleted by all INSERT, UPDATE or DELETE statements completed since
        the database connection was opened, including those executed as part
        of trigger programs.

        Args:
            db: Database connection handle.

        Returns:
            Total number of rows changed since the database connection was opened
            as a 64-bit signed integer.
        """
        return self.lib.get_function[fn (type_of(db)) -> Int64]("sqlite3_total_changes64")(db)

    fn sqlite3_interrupt(self, db: ExternalMutPointer[sqlite3_connection]) -> None:
        """Interrupt A Long-Running Query.

        This routine causes any pending database operation to abort and
        return at its earliest opportunity. This routine is typically
        called in response to a user action such as pressing "Cancel"
        or Ctrl+C where the user wants a long query operation to halt
        immediately.

        It is safe to call this routine from a thread different from the
        thread that is currently running the database operation. But it
        is not safe to call this routine with a database connection that
        is closed or might close before sqlite3_interrupt() returns.

        Args:
            db: Database connection handle.
        """
        self.lib.get_function[fn (type_of(db)) -> None]("sqlite3_interrupt")(db)

    fn sqlite3_is_interrupted(self, db: ExternalMutPointer[sqlite3_connection]) -> c_int:
        """Test To See If An Interrupt Is Pending.

        This routine returns 1 if sqlite3_interrupt() has been called
        on the database connection and the interrupt is still pending,
        or 0 otherwise. This routine does not clear the interrupt flag.

        This routine is intended to be called from within SQL functions
        or virtual table methods to check whether the current SQL statement
        should be interrupted.

        Args:
            db: Database connection handle.

        Returns:
            1 if an interrupt is pending, 0 otherwise.
        """
        return self.lib.get_function[fn (type_of(db)) -> c_int]("sqlite3_is_interrupted")(db)

    fn sqlite3_busy_handler[
        origin: MutOrigin
    ](
        self,
        db: ExternalMutPointer[sqlite3_connection],
        callback: fn (UnsafePointerV2[NoneType, origin], c_int) -> c_int,
        arg: OpaqueMutPointer,
    ) -> c_int:
        return self.lib.get_function[fn (type_of(db), type_of(callback), type_of(arg)) -> c_int](
            "sqlite3_busy_handler"
        )(db, callback, arg)

    fn sqlite3_busy_timeout(self, db: ExternalMutPointer[sqlite3_connection], ms: c_int) -> c_int:
        return self.lib.get_function[fn (type_of(db), type_of(ms)) -> c_int]("sqlite3_busy_timeout")(db, ms)

    fn sqlite3_malloc64(self, size: UInt64) -> OpaqueMutPointer:
        return self.lib.get_function[fn (type_of(size)) -> OpaqueMutPointer]("sqlite3_malloc64")(size)

    fn sqlite3_free(self, ptr: OpaqueMutPointer) -> NoneType:
        return self.lib.get_function[fn (type_of(ptr)) -> NoneType]("sqlite3_free")(ptr)

    fn sqlite3_msize(self, ptr: OpaqueMutPointer) -> UInt64:
        return self.lib.get_function[fn (type_of(ptr)) -> UInt64]("sqlite3_msize")(ptr)

    fn sqlite3_set_authorizer[
        origin: MutOrigin, origin2: ImmutOrigin, origin3: ImmutOrigin, origin4: ImmutOrigin, origin5: ImmutOrigin
    ](
        self,
        db: ExternalMutPointer[sqlite3_connection],
        xAuth: fn (
            OpaqueMutPointer[origin],
            c_int,
            UnsafeImmutPointer[c_char, origin2],
            UnsafeImmutPointer[c_char, origin3],
            UnsafeImmutPointer[c_char, origin4],
            UnsafeImmutPointer[c_char, origin5],
        ) -> c_int,
        pUserData: OpaqueMutPointer,
    ) -> c_int:
        return self.lib.get_function[fn (type_of(db), type_of(xAuth), type_of(pUserData)) -> c_int](
            "sqlite3_set_authorizer"
        )(db, xAuth, pUserData)

    fn sqlite3_trace[
        origin: MutOrigin, origin2: ImmutOrigin
    ](
        self,
        db: ExternalMutPointer[sqlite3_connection],
        xTrace: fn (OpaqueMutPointer[origin], UnsafeImmutPointer[c_char, origin2]) -> NoneType,
        pArg: OpaqueMutPointer,
    ) -> OpaqueMutPointer:
        return self.lib.get_function[fn (type_of(db), type_of(xTrace), type_of(pArg)) -> OpaqueMutPointer](
            "sqlite3_trace"
        )(db, xTrace, pArg)

    fn sqlite3_profile[
        origin: MutOrigin, origin2: ImmutOrigin
    ](
        self,
        db: ExternalMutPointer[sqlite3_connection],
        xProfile: fn (OpaqueMutPointer[origin], UnsafeImmutPointer[c_char, origin2], UInt64) -> NoneType,
        pArg: OpaqueMutPointer,
    ) -> OpaqueMutPointer:
        return self.lib.get_function[fn (type_of(db), type_of(xProfile), type_of(pArg)) -> OpaqueMutPointer](
            "sqlite3_profile"
        )(db, xProfile, pArg)

    fn sqlite3_trace_v2[
        origin: MutOrigin, origin2: MutOrigin, origin3: MutOrigin
    ](
        self,
        db: ExternalMutPointer[sqlite3_connection],
        uMask: c_uint,
        xCallback: fn (c_uint, OpaqueMutPointer[origin], OpaqueMutPointer[origin2], OpaqueMutPointer[origin3]) -> c_int,
        pCtx: OpaqueMutPointer,
    ) -> c_int:
        return self.lib.get_function[fn (type_of(db), type_of(uMask), type_of(xCallback), type_of(pCtx)) -> c_int](
            "sqlite3_trace_v2"
        )(db, uMask, xCallback, pCtx)

    fn sqlite3_progress_handler[
        origin: MutOrigin
    ](
        self,
        db: ExternalMutPointer[sqlite3_connection],
        nOps: c_int,
        xProgress: fn (OpaqueMutPointer[origin]) -> c_int,
        pArg: OpaqueMutPointer,
    ) -> NoneType:
        return self.lib.get_function[fn (type_of(db), type_of(nOps), type_of(xProgress), type_of(pArg)) -> NoneType](
            "sqlite3_progress_handler"
        )(db, nOps, xProgress, pArg)

    fn sqlite3_open_v2[
        origin: MutOrigin
    ](
        self,
        filename: UnsafeImmutPointer[c_char],
        ppDb: UnsafeMutPointer[UnsafeMutPointer[sqlite3_connection, origin]],
        flags: c_int,
        zVfs: UnsafeImmutPointer[c_char],
    ) -> c_int:
        """Open A Database Connection with specified flags and VFS.

        This routine opens a connection to an SQLite database file and returns
        a database connection object. This is the preferred method for opening
        database connections as it allows specification of behavior flags and
        a custom VFS module.

        The flags parameter controls various aspects of database connection:
        - SQLITE_OPEN_READONLY: open read-only
        - SQLITE_OPEN_READWRITE: open for reading and writing
        - SQLITE_OPEN_CREATE: create database if it doesn't exist
        - SQLITE_OPEN_URI: interpret filename as URI
        - SQLITE_OPEN_MEMORY: open as in-memory database
        - SQLITE_OPEN_NOMUTEX: disable connection mutexing
        - SQLITE_OPEN_FULLMUTEX: enable connection mutexing
        - SQLITE_OPEN_SHAREDCACHE: enable shared cache mode
        - SQLITE_OPEN_PRIVATECACHE: disable shared cache mode

        Args:
            filename: Database filename (UTF-8 encoded).
            ppDb: OUT: SQLite db handle.
            flags: Behavior control flags.
            zVfs: Name of VFS module to use (NULL for default).

        Returns:
            SQLITE_OK on success, or an error code on failure.
        """
        return self.lib.get_function[
            fn (
                filename: type_of(filename),
                ppDb: type_of(ppDb),
                flags: type_of(flags),
                zVfs: type_of(zVfs),
            ) -> c_int
        ]("sqlite3_open_v2")(filename, ppDb, flags, zVfs)

    fn sqlite3_errcode(self, db: ExternalMutPointer[sqlite3_connection]) -> c_int:
        """Retrieve the most recent error code for a database connection.

        This function returns the numeric result code or extended result code
        for the most recent failed SQLite call associated with a database connection.
        If a prior API call failed but the most recent API call succeeded, this
        function returns SQLITE_OK.

        Args:
            db: Database connection handle.

        Returns:
            Most recent error code (SQLITE_OK if no error).
        """
        return self.lib.get_function[fn (type_of(db)) -> c_int]("sqlite3_errcode")(db)

    fn sqlite3_extended_errcode(self, db: ExternalMutPointer[sqlite3_connection]) -> c_int:
        """Retrieve the most recent extended error code for a database connection.

        This function returns the extended result code for the most recent
        failed SQLite call associated with a database connection. Extended
        result codes provide additional information about error conditions
        beyond the basic result codes.

        Args:
            db: Database connection handle.

        Returns:
            Most recent extended error code.
        """
        return self.lib.get_function[fn (type_of(db)) -> c_int]("sqlite3_extended_errcode")(db)

    fn sqlite3_errmsg(self, db: ExternalMutPointer[sqlite3_connection]) -> ExternalImmutPointer[c_char]:
        """Retrieve the English-language error message for the most recent error.

        This function returns a pointer to a UTF-8 encoded error message
        describing the most recent failed SQLite call associated with a
        database connection. The error string persists until the next
        SQLite call, at which point it may be overwritten.

        Args:
            db: Database connection handle.

        Returns:
            Pointer to UTF-8 encoded error message string.
        """
        return self.lib.get_function[fn (type_of(db)) -> ExternalImmutPointer[c_char]]("sqlite3_errmsg")(db)

    fn sqlite3_errstr(self, e: c_int) -> ExternalImmutPointer[c_char]:
        """Retrieve the English-language text for a result code.

        This function returns a pointer to a UTF-8 encoded string that
        describes the result code value passed in the argument. Unlike
        sqlite3_errmsg(), this function returns a generic description
        of the error code rather than information about a specific error
        that occurred in a database connection.

        Args:
            e: Result code value.

        Returns:
            Pointer to UTF-8 encoded descriptive text for the result code.
        """
        return self.lib.get_function[fn (type_of(e)) -> ExternalImmutPointer[c_char]]("sqlite3_errstr")(e)

    fn sqlite3_error_offset(self, db: ExternalMutPointer[sqlite3_connection]) -> c_int:
        """Get byte offset of SQL error.

        This function returns the byte offset into the SQL text of the most
        recent SQL statement that resulted in an error. The byte offset is
        measured from the beginning of the SQL statement and is zero-based.
        If there is no error, or if the error is not associated with a
        particular offset in the SQL text, this function returns -1.

        Args:
            db: Database connection handle.

        Returns:
            Byte offset of error in SQL text, or -1 if not applicable.
        """
        return self.lib.get_function[fn (type_of(db)) -> c_int]("sqlite3_error_offset")(db)

    fn sqlite3_limit(self, db: ExternalMutPointer[sqlite3_connection], id: c_int, newVal: c_int) -> c_int:
        """Set or retrieve run-time limits on database connection.

        This function allows applications to impose limits on various
        operations that can consume significant memory, time, or other
        resources. It can both set new limits and query current limits.

        Common limit categories include:
        - SQLITE_LIMIT_LENGTH: maximum length of strings or BLOB
        - SQLITE_LIMIT_SQL_LENGTH: maximum length of SQL statements
        - SQLITE_LIMIT_COLUMN: maximum number of columns in a table
        - SQLITE_LIMIT_EXPR_DEPTH: maximum depth of expression tree
        - SQLITE_LIMIT_COMPOUND_SELECT: maximum terms in compound SELECT
        - SQLITE_LIMIT_VDBE_OP: maximum number of VDBE opcodes
        - SQLITE_LIMIT_FUNCTION_ARG: maximum number of function arguments
        - SQLITE_LIMIT_ATTACHED: maximum number of attached databases
        - SQLITE_LIMIT_LIKE_PATTERN_LENGTH: maximum length of LIKE pattern
        - SQLITE_LIMIT_VARIABLE_NUMBER: maximum parameter index
        - SQLITE_LIMIT_TRIGGER_DEPTH: maximum trigger recursion depth
        - SQLITE_LIMIT_WORKER_THREADS: maximum number of worker threads

        Args:
            db: Database connection handle.
            id: Limit category identifier.
            newVal: New limit value (-1 to query current value without changing).

        Returns:
            Previous limit value.
        """
        return self.lib.get_function[fn (type_of(db), type_of(id), type_of(newVal)) -> c_int]("sqlite3_limit")(
            db, id, newVal
        )

    fn sqlite3_prepare_v2[
        origin: MutOrigin, origin2: ImmutOrigin
    ](
        self,
        db: ExternalMutPointer[sqlite3_connection],
        zSql: UnsafeImmutPointer[c_char],
        nByte: c_int,
        ppStmt: UnsafeMutPointer[UnsafeMutPointer[sqlite3_stmt, origin]],
        pzTail: UnsafeMutPointer[UnsafeImmutPointer[c_char, origin2]],
    ) -> c_int:
        """Compile an SQL statement into a prepared statement object (Version 2).

        This function compiles SQL text into a prepared statement object that
        can be executed using sqlite3_step() and other prepared statement APIs.
        This is the recommended version for most applications, as it provides
        better error handling and performance compared to the original
        sqlite3_prepare() function.

        Args:
            db: Database connection handle.
            zSql: UTF-8 encoded SQL statement text.
            nByte: Maximum length of zSql in bytes (or -1 for null-terminated).
            ppStmt: OUT: Compiled prepared statement object.
            pzTail: OUT: Pointer to unused portion of zSql (or NULL).

        Returns:
            SQLITE_OK on success, or an error code on failure.
        """
        return self.lib.get_function[
            fn (
                type_of(db),
                type_of(zSql),
                type_of(nByte),
                type_of(ppStmt),
                type_of(pzTail),
            ) -> c_int
        ]("sqlite3_prepare_v2")(db, zSql, nByte, ppStmt, pzTail)

    fn sqlite3_prepare_v3[
        sql: ImmutOrigin, tail: MutOrigin
    ](
        self,
        db: ExternalMutPointer[sqlite3_connection],
        zSql: UnsafeImmutPointer[c_char, sql],
        nByte: c_int,
        prepFlags: c_uint,
        ppStmt: UnsafeMutPointer[ExternalMutPointer[sqlite3_stmt]],
        pzTail: UnsafeMutPointer[UnsafePointer[c_char, mut=False, origin=sql], tail],
    ) -> c_int:
        return self.lib.get_function[
            fn (
                type_of(db),
                type_of(zSql),
                type_of(nByte),
                type_of(prepFlags),
                type_of(ppStmt),
                type_of(pzTail),
            ) -> c_int
        ]("sqlite3_prepare_v3")(db, zSql, nByte, prepFlags, ppStmt, pzTail)

    fn sqlite3_sql(self, pStmt: UnsafeMutPointer[sqlite3_stmt]) -> ExternalImmutPointer[c_char]:
        """Retrieve the SQL text of a prepared statement.

        Returns a pointer to a copy of the UTF-8 SQL text used to create the
        prepared statement if that statement was compiled using sqlite3_prepare_v2()
        or its variants.

        Args:
            pStmt: Pointer to the prepared statement.

        Returns:
            Pointer to the SQL text used to create the statement.
        """
        return self.lib.get_function[fn (type_of(pStmt)) -> ExternalImmutPointer[c_char]]("sqlite3_sql")(pStmt)

    fn sqlite3_expanded_sql(self, pStmt: UnsafeMutPointer[sqlite3_stmt]) -> ExternalMutPointer[c_char]:
        """Retrieve SQL with bound parameters expanded.

        Returns a pointer to a UTF-8 string containing the SQL text of the
        prepared statement with bound parameters expanded inline. This is useful
        for debugging and logging purposes.

        Args:
            pStmt: Pointer to the prepared statement.

        Returns:
            Pointer to the expanded SQL text, or NULL if out of memory.
        """
        return self.lib.get_function[fn (type_of(pStmt)) -> ExternalMutPointer[c_char]]("sqlite3_expanded_sql")(pStmt)

    fn sqlite3_stmt_readonly(self, pStmt: UnsafeMutPointer[sqlite3_stmt]) -> c_int:
        """Determine if a prepared statement is read-only.

        Returns true (non-zero) if and only if the prepared statement makes
        no direct changes to the content of the database file. Note that
        application-defined SQL functions or virtual tables might change
        the database indirectly as a side effect.

        Args:
            pStmt: Pointer to the prepared statement.

        Returns:
            Non-zero if the statement is read-only, zero if it writes.
        """
        return self.lib.get_function[fn (type_of(pStmt)) -> c_int]("sqlite3_stmt_readonly")(pStmt)

    fn sqlite3_stmt_isexplain(self, pStmt: UnsafeMutPointer[sqlite3_stmt]) -> c_int:
        return self.lib.get_function[fn (type_of(pStmt)) -> c_int]("sqlite3_stmt_isexplain")(pStmt)

    fn sqlite3_stmt_busy(self, pStmt: UnsafeMutPointer[sqlite3_stmt]) -> c_int:
        return self.lib.get_function[fn (type_of(pStmt)) -> c_int]("sqlite3_stmt_busy")(pStmt)

    fn sqlite3_bind_blob64[
        origin: MutOrigin
    ](
        self,
        pStmt: UnsafeMutPointer[sqlite3_stmt],
        idx: c_int,
        value: OpaqueImmutPointer,
        n: UInt64,
        destructor: fn (OpaqueMutPointer[origin]) -> NoneType,
    ) -> c_int:
        return self.lib.get_function[
            fn (type_of(pStmt), type_of(idx), type_of(value), type_of(n), type_of(destructor)) -> c_int
        ]("sqlite3_bind_blob64")(pStmt, idx, value, n, destructor)

    fn sqlite3_bind_double(self, pStmt: UnsafeMutPointer[sqlite3_stmt], idx: c_int, value: Float64) -> c_int:
        """Binding Values To Prepared Statements - REAL.

        This routine binds a floating point value to a parameter in a prepared statement.
        The parameter is identified by its index (1-based).

        Args:
            pStmt: Prepared statement.
            idx: Index of the parameter (1-based).
            value: The floating point value to bind.

        Returns:
            SQLITE_OK on success, or an error code on failure.
        """
        return self.lib.get_function[fn (type_of(pStmt), type_of(idx), type_of(value)) -> c_int]("sqlite3_bind_double")(
            pStmt, idx, value
        )

    fn sqlite3_bind_int64(self, pStmt: UnsafeMutPointer[sqlite3_stmt], idx: c_int, value: Int64) -> c_int:
        return self.lib.get_function[fn (type_of(pStmt), type_of(idx), type_of(value)) -> c_int]("sqlite3_bind_int64")(
            pStmt, idx, value
        )

    fn sqlite3_bind_null(self, pStmt: UnsafeMutPointer[sqlite3_stmt], idx: c_int) -> c_int:
        """Binding Values To Prepared Statements - NULL.

        This routine binds a NULL value to a parameter in a prepared statement.
        The parameter is identified by its index (1-based).

        Args:
            pStmt: Prepared statement.
            idx: Index of the parameter (1-based).

        Returns:
            SQLITE_OK on success, or an error code on failure.
        """
        return self.lib.get_function[fn (type_of(pStmt), type_of(idx)) -> c_int]("sqlite3_bind_null")(pStmt, idx)

    fn sqlite3_bind_text64[
        origin: MutOrigin
    ](
        self,
        pStmt: UnsafeMutPointer[sqlite3_stmt],
        idx: c_int,
        value: UnsafeImmutPointer[c_char],
        n: UInt64,
        destructor: fn (OpaqueMutPointer[origin]) -> NoneType,
        encoding: c_uchar,
    ) -> c_int:
        return self.lib.get_function[
            fn (
                type_of(pStmt),
                type_of(idx),
                type_of(value),
                type_of(n),
                type_of(destructor),
                type_of(encoding),
            ) -> c_int
        ]("sqlite3_bind_text64")(pStmt, idx, value, n, destructor, encoding)

    fn sqlite3_bind_pointer[
        origin: MutOrigin
    ](
        self,
        pStmt: UnsafeMutPointer[sqlite3_stmt],
        idx: c_int,
        value: OpaqueMutPointer,
        typeStr: UnsafeImmutPointer[c_char],
        destructor: fn (OpaqueMutPointer[origin]) -> NoneType,
    ) -> c_int:
        return self.lib.get_function[
            fn (
                type_of(pStmt),
                type_of(idx),
                type_of(value),
                type_of(typeStr),
                type_of(destructor),
            ) -> c_int
        ]("sqlite3_bind_pointer")(pStmt, idx, value, typeStr, destructor)

    fn sqlite3_bind_zeroblob(self, pStmt: UnsafeMutPointer[sqlite3_stmt], idx: c_int, n: c_int) -> c_int:
        return self.lib.get_function[fn (type_of(pStmt), type_of(idx), type_of(n)) -> c_int]("sqlite3_bind_zeroblob")(
            pStmt, idx, n
        )

    fn sqlite3_bind_parameter_count(self, pStmt: UnsafeMutPointer[sqlite3_stmt]) -> c_int:
        """Return the number of parameters in a prepared statement.

        This function returns the number of SQL parameters in the prepared
        statement. SQL parameters are tokens such as "?" or ":name" or "$var"
        that are used to substitute values at runtime.

        Args:
            pStmt: Pointer to the prepared statement.

        Returns:
            The number of SQL parameters in the prepared statement.
        """
        return self.lib.get_function[fn (type_of(pStmt)) -> c_int]("sqlite3_bind_parameter_count")(pStmt)

    fn sqlite3_bind_parameter_name(
        self, pStmt: UnsafeMutPointer[sqlite3_stmt], idx: c_int
    ) -> ExternalImmutPointer[c_char]:
        return self.lib.get_function[fn (type_of(pStmt), type_of(idx)) -> ExternalImmutPointer[c_char]](
            "sqlite3_bind_parameter_name"
        )(pStmt, idx)

    fn sqlite3_bind_parameter_index(
        self, pStmt: UnsafeMutPointer[sqlite3_stmt], zName: UnsafeImmutPointer[c_char]
    ) -> c_int:
        return self.lib.get_function[fn (type_of(pStmt), type_of(zName)) -> c_int]("sqlite3_bind_parameter_index")(
            pStmt, zName
        )

    fn sqlite3_clear_bindings(self, pStmt: UnsafeMutPointer[sqlite3_stmt]) -> c_int:
        """Reset All Bindings On A Prepared Statement.

        Contrary to the intuition of many, sqlite3_reset() does not reset
        the bindings on a prepared statement. This routine resets all
        parameters to NULL.

        Args:
            pStmt: Prepared statement.

        Returns:
            SQLITE_OK on success, or an error code on failure.
        """
        return self.lib.get_function[fn (type_of(pStmt)) -> c_int]("sqlite3_clear_bindings")(pStmt)

    fn sqlite3_column_count(self, pStmt: UnsafeMutPointer[sqlite3_stmt]) -> c_int:
        """Return the number of columns in a result set.

        This function returns the number of columns in the result set returned
        by the prepared statement. This value does not change from one execution
        of the prepared statement to the next.

        Args:
            pStmt: Pointer to the prepared statement.

        Returns:
            The number of columns in the result set.
        """
        return self.lib.get_function[fn (type_of(pStmt)) -> c_int]("sqlite3_column_count")(pStmt)

    fn sqlite3_column_name(self, pStmt: UnsafeMutPointer[sqlite3_stmt], N: c_int) -> ExternalImmutPointer[c_char]:
        return self.lib.get_function[fn (type_of(pStmt), type_of(N)) -> ExternalImmutPointer[c_char]](
            "sqlite3_column_name"
        )(pStmt, N)

    fn sqlite3_column_database_name(
        self, pStmt: UnsafeMutPointer[sqlite3_stmt], idx: c_int
    ) -> ExternalImmutPointer[c_char]:
        return self.lib.get_function[fn (type_of(pStmt), type_of(idx)) -> ExternalImmutPointer[c_char]](
            "sqlite3_column_database_name"
        )(pStmt, idx)

    fn sqlite3_column_table_name(
        self, pStmt: UnsafeMutPointer[sqlite3_stmt], idx: c_int
    ) -> ExternalImmutPointer[c_char]:
        return self.lib.get_function[fn (type_of(pStmt), type_of(idx)) -> ExternalImmutPointer[c_char]](
            "sqlite3_column_table_name"
        )(pStmt, idx)

    fn sqlite3_column_origin_name(
        self, pStmt: UnsafeMutPointer[sqlite3_stmt], idx: c_int
    ) -> ExternalImmutPointer[c_char]:
        return self.lib.get_function[fn (type_of(pStmt), type_of(idx)) -> ExternalImmutPointer[c_char]](
            "sqlite3_column_origin_name"
        )(pStmt, idx)

    fn sqlite3_column_decltype(self, pStmt: UnsafeMutPointer[sqlite3_stmt], idx: c_int) -> ExternalImmutPointer[c_char]:
        return self.lib.get_function[fn (type_of(pStmt), type_of(idx)) -> ExternalImmutPointer[c_char]](
            "sqlite3_column_decltype"
        )(pStmt, idx)

    fn sqlite3_step(self, pStmt: UnsafeMutPointer[sqlite3_stmt]) -> c_int:
        """Execute a prepared statement.

        This function is used to evaluate a prepared statement that has been
        previously prepared with sqlite3_prepare_v2() or one of its variants.

        The statement is executed until a row of data is ready, a call to
        sqlite3_finalize() is made, or an error occurs. When a row is ready,
        this function returns SQLITE_ROW. When the statement has been completely
        executed or an error occurs, it returns SQLITE_DONE or an error code.

        Args:
            pStmt: Pointer to the prepared statement to execute.

        Returns:
            SQLITE_ROW if a row is ready, SQLITE_DONE if execution is complete,
            or an error code if an error occurred.
        """
        return self.lib.get_function[fn (type_of(pStmt)) -> c_int]("sqlite3_step")(pStmt)

    fn sqlite3_column_blob(self, pStmt: UnsafeMutPointer[sqlite3_stmt], iCol: c_int) -> ExternalMutPointer[NoneType]:
        """Result Values From A Query - BLOB.

        These routines return information about a single column of the current
        result row of a query. This routine returns the value of the specified
        column as a BLOB (Binary Large OBject).

        Args:
            pStmt: Prepared statement being evaluated.
            iCol: Index of the column (leftmost column is 0).

        Returns:
            Pointer to the BLOB data, or NULL if the column is NULL.
        """
        return self.lib.get_function[fn (type_of(pStmt), type_of(iCol)) -> ExternalMutPointer[NoneType]](
            "sqlite3_column_blob"
        )(pStmt, iCol)

    fn sqlite3_column_double(self, pStmt: UnsafeMutPointer[sqlite3_stmt], iCol: c_int) -> Float64:
        """Result Values From A Query - REAL.

        This routine returns the value of the specified column as a floating
        point number (double precision). If the column contains a NULL value
        or cannot be converted to a floating point number, it returns 0.0.

        Args:
            pStmt: Prepared statement being evaluated.
            iCol: Index of the column (leftmost column is 0).

        Returns:
            The column value as a double precision floating point number.
        """
        return self.lib.get_function[fn (type_of(pStmt), type_of(iCol)) -> Float64]("sqlite3_column_double")(
            pStmt, iCol
        )

    fn sqlite3_column_int64(self, pStmt: UnsafeMutPointer[sqlite3_stmt], iCol: c_int) -> Int64:
        return self.lib.get_function[fn (type_of(pStmt), type_of(iCol)) -> Int64]("sqlite3_column_int64")(
            pStmt, iCol
        )

    fn sqlite3_column_text(self, pStmt: UnsafeMutPointer[sqlite3_stmt], iCol: c_int) -> ExternalImmutPointer[c_uchar]:
        """Retrieve column data as UTF-8 text.

        This function returns the value of the specified column as a UTF-8
        encoded string. The column is specified by its index (0-based) in
        the result set.

        Args:
            pStmt: Pointer to the prepared statement.
            iCol: Index of the column (0-based).

        Returns:
            Pointer to the UTF-8 encoded text value of the column.
        """
        return self.lib.get_function[fn (type_of(pStmt), type_of(iCol)) -> ExternalImmutPointer[c_uchar]](
            "sqlite3_column_text"
        )(pStmt, iCol)

    fn sqlite3_column_value(
        self, pStmt: UnsafeMutPointer[sqlite3_stmt], iCol: c_int
    ) -> ExternalMutPointer[sqlite3_value]:
        return self.lib.get_function[fn (type_of(pStmt), type_of(iCol)) -> ExternalMutPointer[sqlite3_value]](
            "sqlite3_column_value"
        )(pStmt, iCol)

    fn sqlite3_column_bytes(self, pStmt: UnsafeMutPointer[sqlite3_stmt], iCol: c_int) -> c_int:
        return self.lib.get_function[fn (type_of(pStmt), type_of(iCol)) -> c_int]("sqlite3_column_bytes")(pStmt, iCol)

    fn sqlite3_column_type(self, pStmt: UnsafeMutPointer[sqlite3_stmt], iCol: c_int) -> c_int:
        return self.lib.get_function[fn (type_of(pStmt), type_of(iCol)) -> c_int]("sqlite3_column_type")(pStmt, iCol)

    fn sqlite3_finalize(self, pStmt: UnsafeMutPointer[sqlite3_stmt]) -> c_int:
        """Finalize a prepared statement.

        This function is used to delete a prepared statement. If the most recent
        evaluation of the statement was successful, then sqlite3_finalize() returns
        SQLITE_OK. If the most recent evaluation failed, then sqlite3_finalize()
        returns the appropriate error code.

        Args:
            pStmt: Pointer to the prepared statement to finalize.

        Returns:
            SQLITE_OK on success, or an error code if the statement failed.
        """
        return self.lib.get_function[fn (type_of(pStmt)) -> c_int]("sqlite3_finalize")(pStmt)

    fn sqlite3_reset(self, pStmt: UnsafeMutPointer[sqlite3_stmt]) -> c_int:
        """Reset a prepared statement.

        This function resets a prepared statement back to its initial state,
        ready to be re-executed. Any SQL statement variables that had values
        bound to them using the sqlite3_bind_*() functions retain their values.
        Use sqlite3_clear_bindings() to reset the bindings.

        Args:
            pStmt: Pointer to the prepared statement to reset.

        Returns:
            SQLITE_OK on success, or an error code if an error occurred during
            the most recent evaluation of the statement.
        """
        return self.lib.get_function[fn (type_of(pStmt)) -> c_int]("sqlite3_reset")(pStmt)

    fn sqlite3_create_function_v2[
        origin: MutOrigin,
        origin2: MutOrigin,
        origin3: MutOrigin,
        origin4: MutOrigin,
        origin5: MutOrigin,
        origin6: MutOrigin,
        origin7: MutOrigin,
        origin8: MutOrigin,
    ](
        self,
        db: ExternalMutPointer[sqlite3_connection],
        zFunctionName: UnsafeImmutPointer[c_char],
        nArg: c_int,
        eTextRep: c_int,
        pApp: OpaqueMutPointer,
        xFunc: fn (
            UnsafeMutPointer[sqlite3_context, origin],
            c_int,
            UnsafeMutPointer[UnsafeMutPointer[sqlite3_value, origin2], origin3],
        ) -> NoneType,
        xStep: fn (
            UnsafeMutPointer[sqlite3_context, origin4],
            c_int,
            UnsafeMutPointer[UnsafeMutPointer[sqlite3_value, origin5], origin6],
        ) -> NoneType,
        xFinal: fn (UnsafeMutPointer[sqlite3_context, origin7]) -> NoneType,
        xDestroy: fn (OpaqueMutPointer[origin8]) -> NoneType,
    ) -> c_int:
        return self.lib.get_function[
            fn (
                type_of(db),
                type_of(zFunctionName),
                type_of(nArg),
                type_of(eTextRep),
                type_of(pApp),
                type_of(xFunc),
                type_of(xStep),
                type_of(xFinal),
                type_of(xDestroy),
            ) -> c_int
        ]("sqlite3_create_function_v2")(db, zFunctionName, nArg, eTextRep, pApp, xFunc, xStep, xFinal, xDestroy)

    fn sqlite3_create_window_function[
        origin: MutOrigin,
        origin2: MutOrigin,
        origin3: MutOrigin,
        origin4: MutOrigin,
        origin5: MutOrigin,
        origin6: MutOrigin,
        origin7: MutOrigin,
        origin8: MutOrigin,
        origin9: MutOrigin,
    ](
        self,
        db: ExternalMutPointer[sqlite3_connection],
        zFunctionName: UnsafeImmutPointer[c_char],
        nArg: c_int,
        eTextRep: c_int,
        pApp: OpaqueMutPointer,
        xStep: fn (
            UnsafeMutPointer[sqlite3_context, origin],
            c_int,
            UnsafeMutPointer[UnsafeMutPointer[sqlite3_value, origin2], origin3],
        ) -> NoneType,
        xFinal: fn (UnsafeMutPointer[sqlite3_context, origin4]) -> NoneType,
        xValue: fn (UnsafeMutPointer[sqlite3_context, origin5]) -> NoneType,
        xInverse: fn (
            UnsafeMutPointer[sqlite3_context, origin6],
            c_int,
            UnsafeMutPointer[UnsafeMutPointer[sqlite3_value, origin7], origin8],
        ) -> NoneType,
        xDestroy: fn (OpaqueMutPointer[origin9]) -> NoneType,
    ) -> c_int:
        return self.lib.get_function[
            fn (
                type_of(db),
                type_of(zFunctionName),
                type_of(nArg),
                type_of(eTextRep),
                type_of(pApp),
                type_of(xStep),
                type_of(xFinal),
                type_of(xValue),
                type_of(xInverse),
                type_of(xDestroy),
            ) -> c_int
        ]("sqlite3_create_window_function")(
            db, zFunctionName, nArg, eTextRep, pApp, xStep, xFinal, xValue, xInverse, xDestroy
        )

    fn sqlite3_aggregate_count(self, ctx: UnsafeMutPointer[sqlite3_context]) -> c_int:
        return self.lib.get_function[fn (type_of(ctx)) -> c_int]("sqlite3_aggregate_count")(ctx)

    fn sqlite3_expired(self, pStmt: UnsafeMutPointer[sqlite3_stmt]) -> c_int:
        return self.lib.get_function[fn (type_of(pStmt)) -> c_int]("sqlite3_expired")(pStmt)

    fn sqlite3_transfer_bindings(
        self, fromStmt: UnsafeMutPointer[sqlite3_stmt], toStmt: UnsafeMutPointer[sqlite3_stmt]
    ) -> c_int:
        return self.lib.get_function[fn (type_of(fromStmt), type_of(toStmt)) -> c_int]("sqlite3_transfer_bindings")(
            fromStmt, toStmt
        )

    fn sqlite3_global_recover(self) -> c_int:
        return self.lib.get_function[fn () -> c_int]("sqlite3_global_recover")()

    fn sqlite3_thread_cleanup(self) -> NoneType:
        return self.lib.get_function[fn () -> NoneType]("sqlite3_thread_cleanup")()

    fn sqlite3_memory_alarm[
        origin: MutOrigin
    ](
        self,
        callback: fn (OpaqueMutPointer[origin], Int64, c_int) -> NoneType,
        arg: OpaqueMutPointer,
        n: Int64,
    ) -> c_int:
        return self.lib.get_function[fn (type_of(callback), type_of(arg), type_of(n)) -> c_int]("sqlite3_memory_alarm")(
            callback, arg, n
        )

    fn sqlite3_value_blob(self, value: UnsafeMutPointer[sqlite3_value]) -> OpaqueMutPointer:
        return self.lib.get_function[fn (type_of(value)) -> OpaqueMutPointer]("sqlite3_value_blob")(value)

    fn sqlite3_value_double(self, value: UnsafeMutPointer[sqlite3_value]) -> Float64:
        return self.lib.get_function[fn (type_of(value)) -> Float64]("sqlite3_value_double")(value)

    fn sqlite3_value_int64(self, value: UnsafeMutPointer[sqlite3_value]) -> Int64:
        return self.lib.get_function[fn (type_of(value)) -> Int64]("sqlite3_value_int64")(value)

    fn sqlite3_value_pointer(
        self, value: UnsafeMutPointer[sqlite3_value], typeStr: UnsafeImmutPointer[c_char]
    ) -> OpaqueMutPointer:
        return self.lib.get_function[fn (type_of(value), type_of(typeStr)) -> OpaqueMutPointer](
            "sqlite3_value_pointer"
        )(value, typeStr)

    fn sqlite3_value_text(self, value: UnsafeMutPointer[sqlite3_value]) -> ExternalImmutPointer[c_uchar]:
        return self.lib.get_function[fn (type_of(value)) -> ExternalImmutPointer[c_uchar]]("sqlite3_value_text")(value)

    fn sqlite3_value_bytes(self, value: UnsafeMutPointer[sqlite3_value]) -> c_int:
        return self.lib.get_function[fn (type_of(value)) -> c_int]("sqlite3_value_bytes")(value)

    fn sqlite3_value_type(self, value: UnsafeMutPointer[sqlite3_value]) -> c_int:
        return self.lib.get_function[fn (type_of(value)) -> c_int]("sqlite3_value_type")(value)

    fn sqlite3_value_nochange(self, value: UnsafeMutPointer[sqlite3_value]) -> c_int:
        return self.lib.get_function[fn (type_of(value)) -> c_int]("sqlite3_value_nochange")(value)

    fn sqlite3_value_subtype(self, value: UnsafeMutPointer[sqlite3_value]) -> c_uint:
        return self.lib.get_function[fn (type_of(value)) -> c_uint]("sqlite3_value_subtype")(value)

    fn sqlite3_aggregate_context(self, ctx: UnsafeMutPointer[sqlite3_context], nBytes: c_int) -> OpaqueMutPointer:
        return self.lib.get_function[fn (type_of(ctx), /, nBytes: c_int) -> OpaqueMutPointer](
            "sqlite3_aggregate_context"
        )(ctx, nBytes)

    fn sqlite3_user_data(self, ctx: UnsafeMutPointer[sqlite3_context]) -> OpaqueMutPointer:
        return self.lib.get_function[fn (type_of(ctx)) -> OpaqueMutPointer]("sqlite3_user_data")(ctx)

    fn sqlite3_context_db_handle(
        self, ctx: UnsafeMutPointer[sqlite3_context]
    ) -> ExternalMutPointer[sqlite3_connection]:
        return self.lib.get_function[fn (type_of(ctx)) -> ExternalMutPointer[sqlite3_connection]](
            "sqlite3_context_db_handle"
        )(ctx)

    fn sqlite3_get_auxdata(self, ctx: UnsafeMutPointer[sqlite3_context], N: c_int) -> OpaqueMutPointer:
        return self.lib.get_function[fn (type_of(ctx), type_of(N)) -> OpaqueMutPointer]("sqlite3_get_auxdata")(ctx, N)

    fn sqlite3_set_auxdata[
        origin: MutOrigin
    ](
        self,
        ctx: UnsafeMutPointer[sqlite3_context],
        N: c_int,
        data: OpaqueMutPointer,
        destructor: fn (OpaqueMutPointer[origin]) -> NoneType,
    ) -> NoneType:
        return self.lib.get_function[fn (type_of(ctx), type_of(N), type_of(data), type_of(destructor)) -> NoneType](
            "sqlite3_set_auxdata"
        )(ctx, N, data, destructor)

    fn sqlite3_result_blob64[
        origin: MutOrigin
    ](
        self,
        ctx: UnsafeMutPointer[sqlite3_context],
        value: OpaqueMutPointer,
        n: UInt64,
        destructor: fn (OpaqueMutPointer[origin]) -> NoneType,
    ) -> NoneType:
        return self.lib.get_function[fn (type_of(ctx), type_of(value), type_of(n), type_of(destructor)) -> NoneType](
            "sqlite3_result_blob64"
        )(ctx, value, n, destructor)

    fn sqlite3_result_double(self, ctx: UnsafeMutPointer[sqlite3_context], value: Float64) -> NoneType:
        return self.lib.get_function[fn (type_of(ctx), type_of(value)) -> NoneType]("sqlite3_result_double")(ctx, value)

    fn sqlite3_result_error(
        self, ctx: UnsafeMutPointer[sqlite3_context], msg: UnsafeImmutPointer[c_char], n: c_int
    ) -> NoneType:
        return self.lib.get_function[fn (type_of(ctx), type_of(msg), type_of(n)) -> NoneType]("sqlite3_result_error")(
            ctx, msg, n
        )

    fn sqlite3_result_error_toobig(self, ctx: UnsafeMutPointer[sqlite3_context]) -> NoneType:
        return self.lib.get_function[fn (type_of(ctx)) -> NoneType]("sqlite3_result_error_toobig")(ctx)

    fn sqlite3_result_error_nomem(self, ctx: UnsafeMutPointer[sqlite3_context]) -> NoneType:
        return self.lib.get_function[fn (type_of(ctx)) -> NoneType]("sqlite3_result_error_nomem")(ctx)

    fn sqlite3_result_error_code(self, ctx: UnsafeMutPointer[sqlite3_context], code: c_int) -> NoneType:
        return self.lib.get_function[fn (type_of(ctx), type_of(code)) -> NoneType]("sqlite3_result_error_code")(
            ctx, code
        )

    fn sqlite3_result_int64(self, ctx: UnsafeMutPointer[sqlite3_context], value: Int64) -> NoneType:
        return self.lib.get_function[fn (type_of(ctx), type_of(value)) -> NoneType]("sqlite3_result_int64")(ctx, value)

    fn sqlite3_result_null(self, ctx: UnsafeMutPointer[sqlite3_context]) -> NoneType:
        return self.lib.get_function[fn (type_of(ctx)) -> NoneType]("sqlite3_result_null")(ctx)

    fn sqlite3_result_text64[
        origin: MutOrigin
    ](
        self,
        ctx: UnsafeMutPointer[sqlite3_context],
        value: UnsafeImmutPointer[c_char],
        n: UInt64,
        destructor: fn (OpaqueMutPointer[origin]) -> NoneType,
        encoding: c_uchar,
    ) -> NoneType:
        return self.lib.get_function[
            fn (type_of(ctx), type_of(value), type_of(n), type_of(destructor), type_of(encoding)) -> NoneType
        ]("sqlite3_result_text64")(ctx, value, n, destructor, encoding)

    fn sqlite3_result_value(
        self, ctx: UnsafeMutPointer[sqlite3_context], value: UnsafeMutPointer[sqlite3_value]
    ) -> NoneType:
        return self.lib.get_function[fn (type_of(ctx), type_of(value)) -> NoneType]("sqlite3_result_value")(ctx, value)

    fn sqlite3_result_pointer[
        origin: MutOrigin
    ](
        self,
        ctx: UnsafeMutPointer[sqlite3_context],
        ptr: OpaqueMutPointer,
        typeStr: UnsafeImmutPointer[c_char],
        destructor: fn (OpaqueMutPointer[origin]) -> NoneType,
    ) -> NoneType:
        return self.lib.get_function[
            fn (type_of(ctx), type_of(ptr), type_of(typeStr), type_of(destructor)) -> NoneType
        ]("sqlite3_result_pointer")(ctx, ptr, typeStr, destructor)

    fn sqlite3_result_zeroblob(self, ctx: UnsafeMutPointer[sqlite3_context], n: c_int) -> NoneType:
        return self.lib.get_function[fn (type_of(ctx), type_of(n)) -> NoneType]("sqlite3_result_zeroblob")(ctx, n)

    fn sqlite3_result_subtype(self, ctx: UnsafeMutPointer[sqlite3_context], subtype: c_uint) -> NoneType:
        return self.lib.get_function[fn (type_of(ctx), type_of(subtype)) -> NoneType]("sqlite3_result_subtype")(
            ctx, subtype
        )

    fn sqlite3_create_collation_v2[
        origin: MutOrigin, origin2: ImmutOrigin, origin3: ImmutOrigin, origin4: MutOrigin
    ](
        self,
        db: ExternalMutPointer[sqlite3_connection],
        zName: UnsafeImmutPointer[c_char],
        eTextRep: c_int,
        pArg: OpaqueMutPointer,
        xCompare: fn (
            OpaqueMutPointer[origin], c_int, OpaqueImmutPointer[origin2], c_int, OpaqueImmutPointer[origin3]
        ) -> c_int,
        xDestroy: fn (OpaqueMutPointer[origin4]) -> NoneType,
    ) -> c_int:
        return self.lib.get_function[
            fn (
                type_of(db), type_of(zName), type_of(eTextRep), type_of(pArg), type_of(xCompare), type_of(xDestroy)
            ) -> c_int
        ]("sqlite3_create_collation_v2")(db, zName, eTextRep, pArg, xCompare, xDestroy)

    fn sqlite3_collation_needed[
        origin: MutOrigin, origin2: MutOrigin, origin3: ImmutOrigin
    ](
        self,
        db: ExternalMutPointer[sqlite3_connection],
        pArg: OpaqueMutPointer,
        callback: fn (
            OpaqueMutPointer[origin],
            UnsafeMutPointer[sqlite3_connection, origin2],
            c_int,
            UnsafeImmutPointer[c_char, origin3],
        ) -> NoneType,
    ) -> c_int:
        return self.lib.get_function[fn (type_of(db), type_of(pArg), type_of(callback)) -> c_int](
            "sqlite3_collation_needed"
        )(db, pArg, callback)

    fn sqlite3_soft_heap_limit(self, n: c_int) -> c_int:
        return self.lib.get_function[fn (type_of(n)) -> c_int]("sqlite3_soft_heap_limit")(n)

    fn sqlite3_soft_heap_limit64(self, n: Int64) -> Int64:
        return self.lib.get_function[fn (type_of(n)) -> Int64]("sqlite3_soft_heap_limit64")(n)

    fn sqlite3_stmt_status(self, pStmt: UnsafeMutPointer[sqlite3_stmt], op: c_int, resetFlg: c_int) -> c_int:
        return self.lib.get_function[fn (type_of(pStmt), type_of(op), type_of(resetFlg)) -> c_int](
            "sqlite3_stmt_status"
        )(pStmt, op, resetFlg)

    fn sqlite3_table_column_metadata[
        origin: ImmutOrigin, origin2: ImmutOrigin
    ](
        self,
        db: ExternalMutPointer[sqlite3_connection],
        zDbName: UnsafeImmutPointer[c_char],
        zTableName: UnsafeImmutPointer[c_char],
        zColumnName: UnsafeImmutPointer[c_char],
        pzDataType: UnsafeMutPointer[UnsafeImmutPointer[c_char, origin]],
        pzCollSeq: UnsafeMutPointer[UnsafeImmutPointer[c_char, origin2]],
        pNotNull: UnsafeMutPointer[c_int],
        pPrimaryKey: UnsafeMutPointer[c_int],
        pAutoinc: UnsafeMutPointer[c_int],
    ) -> c_int:
        return self.lib.get_function[
            fn (
                type_of(db),
                type_of(zDbName),
                type_of(zTableName),
                type_of(zColumnName),
                type_of(pzDataType),
                type_of(pzCollSeq),
                type_of(pNotNull),
                type_of(pPrimaryKey),
                type_of(pAutoinc),
            ) -> c_int
        ]("sqlite3_table_column_metadata")(
            db, zDbName, zTableName, zColumnName, pzDataType, pzCollSeq, pNotNull, pPrimaryKey, pAutoinc
        )

    fn sqlite3_load_extension[
        origin: MutOrigin
    ](
        self,
        db: ExternalMutPointer[sqlite3_connection],
        zFile: UnsafeImmutPointer[c_char],
        zProc: UnsafeImmutPointer[c_char],
        pzErrMsg: UnsafeMutPointer[UnsafeMutPointer[c_char, origin]],
    ) -> c_int:
        return self.lib.get_function[fn (type_of(db), type_of(zFile), type_of(zProc), type_of(pzErrMsg)) -> c_int](
            "sqlite3_load_extension"
        )(db, zFile, zProc, pzErrMsg)

    fn sqlite3_enable_load_extension(self, db: ExternalMutPointer[sqlite3_connection], onoff: c_int) -> c_int:
        return self.lib.get_function[fn (type_of(db), c_int) -> c_int]("sqlite3_enable_load_extension")(db, onoff)

    fn sqlite3_win32_set_directory(self, type: c_ulong, zValue: OpaqueMutPointer) -> c_int:
        return self.lib.get_function[fn (type_of(type), type_of(zValue)) -> c_int]("sqlite3_win32_set_directory")(
            type, zValue
        )

    fn sqlite3_win32_set_directory8(self, type: c_ulong, zValue: UnsafeImmutPointer[c_char]) -> c_int:
        return self.lib.get_function[fn (type_of(type), type_of(zValue)) -> c_int]("sqlite3_win32_set_directory8")(
            type, zValue
        )

    fn sqlite3_get_autocommit(self, db: ExternalMutPointer[sqlite3_connection]) -> c_int:
        return self.lib.get_function[fn (type_of(db)) -> c_int]("sqlite3_get_autocommit")(db)

    fn sqlite3_db_handle(self, pStmt: UnsafeMutPointer[sqlite3_stmt]) -> ExternalMutPointer[sqlite3_connection]:
        return self.lib.get_function[fn (type_of(pStmt)) -> ExternalMutPointer[sqlite3_connection]](
            "sqlite3_db_handle"
        )(pStmt)

    fn sqlite3_db_name(self, db: ExternalMutPointer[sqlite3_connection], N: c_int) -> ExternalImmutPointer[c_char]:
        return self.lib.get_function[fn (type_of(db), type_of(N)) -> ExternalImmutPointer[c_char]]("sqlite3_db_name")(
            db, N
        )

    fn sqlite3_db_filename(
        self, db: ExternalMutPointer[sqlite3_connection], zDbName: UnsafeImmutPointer[c_char]
    ) -> ExternalImmutPointer[c_char]:
        return self.lib.get_function[fn (type_of(db), type_of(zDbName)) -> ExternalImmutPointer[c_char]]("sqlite3_db_filename")(
            db, zDbName
        )

    fn sqlite3_db_readonly(
        self, db: ExternalMutPointer[sqlite3_connection], zDbName: UnsafeImmutPointer[c_char]
    ) -> c_int:
        return self.lib.get_function[fn (type_of(db), type_of(zDbName)) -> c_int]("sqlite3_db_readonly")(db, zDbName)

    fn sqlite3_txn_state(
        self, db: ExternalMutPointer[sqlite3_connection], /, zSchema: UnsafeImmutPointer[c_char]
    ) -> c_int:
        return self.lib.get_function[fn (type_of(db), type_of(zSchema)) -> c_int]("sqlite3_txn_state")(db, zSchema)

    fn sqlite3_next_stmt(
        self, pDb: ExternalMutPointer[sqlite3_connection], pStmt: UnsafeMutPointer[sqlite3_stmt]
    ) -> ExternalMutPointer[sqlite3_stmt]:
        return self.lib.get_function[fn (type_of(pDb), type_of(pStmt)) -> ExternalMutPointer[sqlite3_stmt]](
            "sqlite3_next_stmt"
        )(pDb, pStmt)

    fn sqlite3_update_hook(
        self,
        db: ExternalMutPointer[sqlite3_connection],
        xCallback: UnsafeMutPointer[
            fn (OpaqueMutPointer, c_int, UnsafeMutPointer[c_char], UnsafeMutPointer[c_char], Int64)
        ],
        pArg: OpaqueMutPointer,
    ) -> None:
        self.lib.get_function[fn (type_of(db), type_of(xCallback), type_of(pArg)) -> None]("sqlite3_update_hook")(
            db, xCallback, pArg
        )

    fn sqlite3_commit_hook(
        self,
        db: ExternalMutPointer[sqlite3_connection],
        xCallback: UnsafeMutPointer[fn (OpaqueMutPointer) -> c_int],
        pArg: OpaqueMutPointer,
    ) -> OpaqueMutPointer:
        return self.lib.get_function[fn (type_of(db), type_of(xCallback), type_of(pArg)) -> OpaqueMutPointer](
            "sqlite3_commit_hook"
        )(db, xCallback, pArg)

    fn sqlite3_rollback_hook(
        self,
        db: ExternalMutPointer[sqlite3_connection],
        xCallback: UnsafeMutPointer[fn (OpaqueMutPointer)],
        pArg: OpaqueMutPointer,
    ) -> OpaqueMutPointer:
        return self.lib.get_function[fn (type_of(db), type_of(xCallback), type_of(pArg)) -> OpaqueMutPointer](
            "sqlite3_rollback_hook"
        )(db, xCallback, pArg)

    fn sqlite3_auto_extension(self, xEntryPoint: UnsafeMutPointer[fn () -> c_int]) -> c_int:
        return self.lib.get_function[fn (type_of(xEntryPoint)) -> c_int]("sqlite3_auto_extension")(xEntryPoint)

    fn sqlite3_db_release_memory(self, db: ExternalMutPointer[sqlite3_connection]) -> c_int:
        return self.lib.get_function[fn (type_of(db)) -> c_int]("sqlite3_db_release_memory")(db)

    fn sqlite3_cancel_auto_extension(self, xEntryPoint: UnsafeMutPointer[fn () -> c_int]) -> c_int:
        return self.lib.get_function[fn (type_of(xEntryPoint)) -> c_int]("sqlite3_cancel_auto_extension")(xEntryPoint)

    fn sqlite3_reset_auto_extension(self) -> c_int:
        return self.lib.get_function[fn () -> c_int]("sqlite3_reset_auto_extension")()
    
    fn sqlite3_create_module_v2[origin: MutOrigin](
        self,
        db: ExternalMutPointer[sqlite3_connection],
        zName: UnsafeImmutPointer[c_char],
        p: UnsafeMutPointer[sqlite3_module],
        pClientData: OpaqueMutPointer,
        xDestroy: fn (OpaqueMutPointer[origin]) -> NoneType,
    ) -> c_int:
        return self.lib.get_function[
            fn (
                type_of(db),
                type_of(zName),
                type_of(p),
                type_of(pClientData),
                type_of(xDestroy),
            ) -> c_int
        ]("sqlite3_create_module_v2")(db, zName, p, pClientData, xDestroy)

    fn sqlite3_blob_open[
        origin: MutOrigin
    ](
        self,
        db: ExternalMutPointer[sqlite3_connection],
        zDb: UnsafeImmutPointer[c_char],
        zTable: UnsafeImmutPointer[c_char],
        zColumn: UnsafeImmutPointer[c_char],
        iRow: Int64,
        flags: c_int,
        ppBlob: UnsafeMutPointer[UnsafeMutPointer[sqlite3_blob, origin]],
    ) -> c_int:
        return self.lib.get_function[
            fn (
                type_of(db),
                type_of(zDb),
                type_of(zTable),
                type_of(zColumn),
                type_of(iRow),
                type_of(flags),
                type_of(ppBlob),
            ) -> c_int
        ]("sqlite3_blob_open")(db, zDb, zTable, zColumn, iRow, flags, ppBlob)

    fn sqlite3_blob_reopen(self, pBlob: UnsafeMutPointer[sqlite3_blob], iRow: Int64) -> c_int:
        return self.lib.get_function[fn (type_of(pBlob), type_of(iRow)) -> c_int]("sqlite3_blob_reopen")(pBlob, iRow)

    fn sqlite3_blob_close(self, pBlob: UnsafeMutPointer[sqlite3_blob]) -> c_int:
        return self.lib.get_function[fn (type_of(pBlob)) -> c_int]("sqlite3_blob_close")(pBlob)

    fn sqlite3_blob_bytes(self, pBlob: UnsafeMutPointer[sqlite3_blob]) -> c_int:
        return self.lib.get_function[fn (type_of(pBlob)) -> c_int]("sqlite3_blob_bytes")(pBlob)

    fn sqlite3_blob_read(
        self, pBlob: UnsafeMutPointer[sqlite3_blob], Z: OpaqueMutPointer, N: c_int, iOffset: c_int
    ) -> c_int:
        return self.lib.get_function[fn (type_of(pBlob), type_of(Z), type_of(N), type_of(iOffset)) -> c_int](
            "sqlite3_blob_read"
        )(pBlob, Z, N, iOffset)

    fn sqlite3_blob_write(
        self, pBlob: UnsafeMutPointer[sqlite3_blob], z: OpaqueMutPointer, n: c_int, iOffset: c_int
    ) -> c_int:
        return self.lib.get_function[fn (type_of(pBlob), type_of(z), type_of(n), type_of(iOffset)) -> c_int](
            "sqlite3_blob_write"
        )(pBlob, z, n, iOffset)

    fn sqlite3_file_control(
        self,
        db: ExternalMutPointer[sqlite3_connection],
        zDbName: UnsafeImmutPointer[c_char],
        op: c_int,
        pArg: OpaqueMutPointer,
    ) -> c_int:
        return self.lib.get_function[fn (type_of(db), type_of(zDbName), type_of(op), type_of(pArg)) -> c_int](
            "sqlite3_file_control"
        )(db, zDbName, op, pArg)

    fn sqlite3_backup_init(
        self,
        pDest: ExternalMutPointer[sqlite3_connection],
        zDestName: UnsafeImmutPointer[c_char],
        pSource: ExternalMutPointer[sqlite3_connection],
        zSourceName: UnsafeImmutPointer[c_char],
    ) -> ExternalMutPointer[sqlite3_backup]:
        return self.lib.get_function[
            fn (
                type_of(pDest), type_of(zDestName), type_of(pSource), type_of(zSourceName)
            ) -> ExternalMutPointer[sqlite3_backup]
        ]("sqlite3_backup_init")(pDest, zDestName, pSource, zSourceName)

    fn sqlite3_backup_step(self, p: UnsafeMutPointer[sqlite3_backup], nPage: c_int) -> c_int:
        return self.lib.get_function[fn (type_of(p), type_of(nPage)) -> c_int]("sqlite3_backup_step")(p, nPage)

    fn sqlite3_backup_finish(self, p: UnsafeMutPointer[sqlite3_backup]) -> c_int:
        return self.lib.get_function[fn (type_of(p)) -> c_int]("sqlite3_backup_finish")(p)

    fn sqlite3_backup_remaining(self, p: UnsafeMutPointer[sqlite3_backup]) -> c_int:
        return self.lib.get_function[fn (type_of(p)) -> c_int]("sqlite3_backup_remaining")(p)

    fn sqlite3_backup_pagecount(self, p: UnsafeMutPointer[sqlite3_backup]) -> c_int:
        return self.lib.get_function[fn (type_of(p)) -> c_int]("sqlite3_backup_pagecount")(p)

    fn sqlite3_unlock_notify[
        origin: MutOrigin, origin2: MutOrigin
    ](
        self,
        pBlocked: ExternalMutPointer[sqlite3_connection],
        xNotify: fn (UnsafeMutPointer[OpaqueMutPointer[origin], origin2], c_int) -> NoneType,
        pNotifyArg: OpaqueMutPointer,
    ) -> c_int:
        return self.lib.get_function[fn (type_of(pBlocked), type_of(xNotify), type_of(pNotifyArg)) -> c_int](
            "sqlite3_unlock_notify"
        )(pBlocked, xNotify, pNotifyArg)

    fn sqlite3_log(self, iErrCode: c_int, zFormat: UnsafeImmutPointer[c_char]) -> NoneType:
        return self.lib.get_function[fn (type_of(iErrCode), type_of(zFormat)) -> NoneType]("sqlite3_log")(
            iErrCode, zFormat
        )

    fn sqlite3_wal_hook[
        origin: MutOrigin, origin2: MutOrigin, origin3: MutOrigin
    ](
        self,
        db: ExternalMutPointer[sqlite3_connection],
        xCallback: fn (
            OpaqueMutPointer[origin],
            UnsafeMutPointer[sqlite3_connection, origin2],
            UnsafeMutPointer[c_char, origin3],
            c_int,
        ) -> c_int,
        pArg: OpaqueMutPointer,
    ) -> OpaqueMutPointer:
        return self.lib.get_function[fn (type_of(db), type_of(xCallback), type_of(pArg)) -> OpaqueMutPointer](
            "sqlite3_wal_hook"
        )(db, xCallback, pArg)

    fn sqlite3_wal_autocheckpoint(self, db: ExternalMutPointer[sqlite3_connection], N: c_int) -> c_int:
        return self.lib.get_function[fn (type_of(db), type_of(N)) -> c_int]("sqlite3_wal_autocheckpoint")(db, N)

    fn sqlite3_wal_checkpoint(
        self, db: ExternalMutPointer[sqlite3_connection], zDb: UnsafeImmutPointer[c_char]
    ) -> c_int:
        return self.lib.get_function[fn (type_of(db), type_of(zDb)) -> c_int]("sqlite3_wal_checkpoint")(db, zDb)

    fn sqlite3_wal_checkpoint_v2(
        self,
        db: ExternalMutPointer[sqlite3_connection],
        zDb: UnsafeImmutPointer[c_char],
        eMode: c_int,
        pnLog: UnsafeMutPointer[c_int],
        pnCkpt: UnsafeMutPointer[c_int],
    ) -> c_int:
        return self.lib.get_function[
            fn (
                type_of(db),
                type_of(zDb),
                type_of(eMode),
                type_of(pnLog),
                type_of(pnCkpt),
            ) -> c_int
        ]("sqlite3_wal_checkpoint_v2")(db, zDb, eMode, pnLog, pnCkpt)

    fn sqlite3_vtab_config(self, db: ExternalMutPointer[sqlite3_connection], op: c_int) -> c_int:
        return self.lib.get_function[fn (type_of(db), /, op: c_int) -> c_int]("sqlite3_vtab_config")(db, op)

    fn sqlite3_vtab_on_conflict(self, db: ExternalMutPointer[sqlite3_connection]) -> c_int:
        return self.lib.get_function[fn (type_of(db)) -> c_int]("sqlite3_vtab_on_conflict")(db)

    fn sqlite3_vtab_nochange(self, ctx: UnsafeMutPointer[sqlite3_context]) -> c_int:
        return self.lib.get_function[fn (type_of(ctx)) -> c_int]("sqlite3_vtab_nochange")(ctx)

    fn sqlite3_vtab_collation(
        self, pIdxInfo: UnsafeMutPointer[sqlite3_index_info], iCons: c_int
    ) -> ExternalImmutPointer[c_char]:
        return self.lib.get_function[fn (type_of(pIdxInfo), type_of(iCons)) -> ExternalImmutPointer[c_char]](
            "sqlite3_vtab_collation"
        )(pIdxInfo, iCons)

    fn sqlite3_vtab_distinct(self, pIdxInfo: UnsafeMutPointer[sqlite3_index_info]) -> c_int:
        return self.lib.get_function[fn (type_of(pIdxInfo)) -> c_int]("sqlite3_vtab_distinct")(pIdxInfo)

    fn sqlite3_db_cacheflush(self, db: ExternalMutPointer[sqlite3_connection]) -> c_int:
        return self.lib.get_function[fn (type_of(db)) -> c_int]("sqlite3_db_cacheflush")(db)

    fn sqlite3_serialize(
        self,
        db: ExternalMutPointer[sqlite3_connection],
        zSchema: UnsafeImmutPointer[c_char],
        piSize: UnsafeMutPointer[Int64],
        mFlags: c_uint,
    ) -> ExternalMutPointer[c_uchar]:
        return self.lib.get_function[
            fn (type_of(db), type_of(zSchema), type_of(piSize), type_of(mFlags)) -> ExternalMutPointer[c_uchar]
        ]("sqlite3_serialize")(db, zSchema, piSize, mFlags)

    fn sqlite3_deserialize(
        self,
        db: ExternalMutPointer[sqlite3_connection],
        zSchema: UnsafeImmutPointer[c_char],
        pData: UnsafeMutPointer[c_uchar],
        szDb: Int64,
        szBuf: Int64,
        mFlags: c_uint,
    ) -> c_int:
        return self.lib.get_function[
            fn (
                type_of(db),
                type_of(zSchema),
                type_of(pData),
                type_of(szDb),
                type_of(szBuf),
                type_of(mFlags),
            ) -> c_int
        ]("sqlite3_deserialize")(db, zSchema, pData, szDb, szBuf, mFlags)
