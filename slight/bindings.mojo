from slight.c.raw_bindings import _sqlite3, ExecCallbackFn
from slight.result import SQLite3Result
from pathlib import Path
from sys.ffi import DLHandle, c_char, c_int, c_uint

from memory import OpaquePointer, UnsafePointer
from slight.c.types import (
    sqlite3_backup,
    sqlite3_blob,
    sqlite3_connection,
    sqlite3_context,
    sqlite3_destructor_type,
    sqlite3_file,
    sqlite3_filename,
    sqlite3_index_info,
    sqlite3_int64,
    sqlite3_mutex,
    sqlite3_snapshot,
    sqlite3_stmt,
    sqlite3_str,
    sqlite3_uint64,
    sqlite3_value,
    sqlite3_vfs,
)
from slight.c.sqlite_string import SQLiteMallocString


@fieldwise_init
struct sqlite3:
    """SQLite3 C API binding struct.

    This struct provides a high-level interface to the SQLite3 C library
    by dynamically loading the shared library and exposing the C functions
    as Mojo methods. It handles the FFI (Foreign Function Interface) calls
    to the underlying SQLite3 C implementation.
    """

    var lib: _sqlite3

    fn __init__(out self):
        self.lib = _sqlite3()

    fn open(self, var path: String, out_database: UnsafePointer[sqlite3_connection]) -> SQLite3Result:
        """Open a connection to a SQLite database file.

        This method opens a database connection to a SQLite database file.
        It's a direct binding to the sqlite3_open() C function.

        Args:
            path: Path to the database file to open or create.
            out_database: Output pointer that will be set to point to the database connection.

        Returns:
            SQLITE_OK on success, or an error code on failure.
        """
        return self.lib.open(path, out_database)

    fn version(self) -> StringSlice[ImmutableAnyOrigin]:
        """Get the SQLite library version string.

        Returns a pointer to a string containing the version of the SQLite
        library that is running. This corresponds to the SQLITE_VERSION
        string.

        Returns:
            StringSlice containing the SQLite version.
        """
        return StringSlice(unsafe_from_utf8_ptr=self.lib.sqlite3_libversion())

    fn source_id(self) -> StringSlice[ImmutableAnyOrigin]:
        """Get the SQLite source ID.

        Returns a pointer to a string containing the date and time of
        the check-in (UTC) and a SHA1 hash of the entire source tree.

        Returns:
            StringSlice containing the SQLite source identifier.
        """
        return StringSlice(unsafe_from_utf8_ptr=self.lib.sqlite3_sourceid())

    fn library_version_number(self) -> SQLite3Result:
        """Get the SQLite library version number.

        Returns an integer equal to SQLITE_VERSION_NUMBER. The version
        number is in the format (X*1000000 + Y*1000 + Z) where X, Y, and Z
        are the major, minor, and release numbers respectively.

        Returns:
            The SQLite library version as an integer.
        """
        return self.lib.sqlite3_libversion_number()

    fn test_compilation_option(self, zOptName: UnsafePointer[c_char, mut=False]) -> SQLite3Result:
        """Test whether a compile-time option was used.

        Returns 0 or 1 indicating whether the specified option was defined
        at compile time. The SQLITE_ prefix may be omitted from the option
        name passed to this function.

        Args:
            zOptName: Name of the compile-time option to check.

        Returns:
            1 if the option was used, 0 otherwise.
        """
        return self.lib.sqlite3_compileoption_used(zOptName)

    fn get_compilation_option(self, N: c_int) -> UnsafePointer[c_char, mut=False]:
        """Get the N-th compile-time option.

        Allows iterating over the list of options that were defined at
        compile time. If N is out of range, returns a NULL pointer.
        The SQLITE_ prefix is omitted from any strings returned.

        Args:
            N: Index of the compile-time option to retrieve (0-based).

        Returns:
            Pointer to the N-th compile option string, or NULL if N is out of range.
        """
        return self.lib.sqlite3_compileoption_get(N)

    fn test_thread_safety(self) -> SQLite3Result:
        """Test if the library is threadsafe.

        Returns zero if and only if SQLite was compiled with mutexing code
        omitted due to the SQLITE_THREADSAFE compile-time option being set to 0.

        Returns:
            Non-zero if SQLite is threadsafe, 0 if not threadsafe.
        """
        return self.lib.sqlite3_threadsafe()

    fn close(self, connection: UnsafePointer[sqlite3_connection]) -> SQLite3Result:
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
        from [sqlite3_open()], [sqlite3_open16()], or
        [sqlite3_open_v2()], and not previously closed.
        ^Calling `sqlite3_close()` or `sqlite3_close_v2()` with a NULL pointer
        argument is a harmless no-op.
        """
        return self.lib.sqlite3_close(connection)

    fn close_v2(self, connection: UnsafePointer[sqlite3_connection]) -> SQLite3Result:
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
        from [sqlite3_open()], [sqlite3_open16()], or
        [sqlite3_open_v2()], and not previously closed.
        ^Calling `sqlite3_close()` or `sqlite3_close_v2()` with a NULL pointer
        argument is a harmless no-op.
        """
        return self.lib.sqlite3_close_v2(connection)

    fn exec(
        self,
        db: UnsafePointer[sqlite3_connection],
        sql: UnsafePointer[c_char, mut=False],
        callback: UnsafePointer[ExecCallbackFn],
        pArg: OpaquePointer,
        pErrMsg: UnsafePointer[UnsafePointer[c_char]],
    ) -> SQLite3Result:
        """One-Step Query Execution Interface.

        The sqlite3_exec() interface is a convenience wrapper around
        sqlite3_prepare_v2(), sqlite3_step(), and sqlite3_finalize(),
        that allows an application to run multiple statements of SQL
        without having to use a lot of C code.

        Args:
            db: An open database connection.
            sql: UTF-8 encoded, semicolon-separate SQL statements.
            callback: Callback function for each result row (can be NULL).
            pArg: First argument to callback function.
            pErrMsg: Error message written here if not NULL.

        Returns:
            SQLITE_OK on success, or an error code on failure.
        """
        return self.lib.sqlite3_exec(db, sql, callback, pArg, pErrMsg)

    fn initialize(self) -> SQLite3Result:
        """Initialize The SQLite Library.

        The sqlite3_initialize() routine initializes the SQLite library.
        This routine is called automatically by many SQLite interfaces
        so this routine is usually not necessary. For maximum portability,
        it is recommended that applications call sqlite3_initialize() directly.

        Returns:
            SQLITE_OK on success, or an error code on failure.
        """
        return self.lib.sqlite3_initialize()

    fn shutdown(self) -> SQLite3Result:
        """Shutdown The SQLite Library.

        The sqlite3_shutdown() routine deallocates any resources that were
        allocated by sqlite3_initialize(). This routine is a no-op except
        on the first call. Applications normally do not need to invoke this
        routine, as it is called automatically when the process terminates.

        Returns:
            SQLITE_OK on success, or an error code on failure.
        """
        return self.lib.sqlite3_shutdown()

    fn os_init(self) -> SQLite3Result:
        """Initialize The Operating System Interface.

        The sqlite3_os_init() interface initializes the operating system
        interface. This routine registers all VFS objects used by SQLite,
        including the default VFS. Applications that customize the VFS
        should call sqlite3_vfs_register() before calling this routine.

        This routine is automatically called by sqlite3_initialize() and
        therefore applications do not normally need to invoke it directly.
        For maximum portability, it is recommended that applications call
        sqlite3_initialize() instead of calling this routine directly.

        Returns:
            SQLITE_OK on success, or an error code on failure.
        """
        return self.lib.sqlite3_os_init()

    fn os_end(self) -> SQLite3Result:
        """Finalize The Operating System Interface.

        The sqlite3_os_end() interface finalizes and cleans up the
        operating system interface. This routine undoes the work of
        sqlite3_os_init() and unregisters all VFS objects.

        This routine is automatically called by sqlite3_shutdown() and
        therefore applications do not normally need to invoke it directly.
        The sqlite3_os_end() interface is intended to be idempotent.

        Returns:
            SQLITE_OK on success, or an error code on failure.
        """
        return self.lib.sqlite3_os_end()

    fn configure_sqlite(self, op: c_int) -> SQLite3Result:
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
        return self.lib.sqlite3_config(op)

    fn configure_database_connection(self, db: UnsafePointer[sqlite3_connection], op: c_int) -> SQLite3Result:
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
        return self.lib.sqlite3_db_config(db, op)

    fn extended_result_codes(self, db: UnsafePointer[sqlite3_connection], onoff: c_int) -> SQLite3Result:
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
        return self.lib.sqlite3_extended_result_codes(db, onoff)

    fn last_insert_rowid(self, db: UnsafePointer[sqlite3_connection]) -> sqlite3_int64:
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
        return self.lib.sqlite3_last_insert_rowid(db)

    fn set_last_insert_rowid(self, db: UnsafePointer[sqlite3_connection], rowid: sqlite3_int64):
        """Set The Last Insert Rowid.

        The sqlite3_set_last_insert_rowid() interface allows the application
        to set the value returned by sqlite3_last_insert_rowid(). This can
        be useful when implementing virtual tables or when loading data.

        The sqlite3_set_last_insert_rowid() routine works only on the
        specified database connection. It does not set the last insert
        rowid for any other database connection.

        Args:
            db: Database connection handle.
            rowid: The rowid value to set as the last insert rowid.
        """
        self.lib.sqlite3_set_last_insert_rowid(db, rowid)

    fn changes(self, db: UnsafePointer[sqlite3_connection]) -> Int32:
        """Count The Number of Rows Modified.

        This function returns the number of rows modified, inserted or deleted
        by the most recently completed INSERT, UPDATE, or DELETE statement on
        the database connection specified in the first argument.

        Args:
            db: Database connection handle.

        Returns:
            Number of rows changed by the most recent INSERT, UPDATE, or DELETE.
        """
        return self.lib.sqlite3_changes(db)

    fn changes64(self, db: UnsafePointer[sqlite3_connection]) -> sqlite3_int64:
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
        return self.lib.sqlite3_changes64(db)

    fn total_changes(self, db: UnsafePointer[sqlite3_connection]) -> SQLite3Result:
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
        return self.lib.sqlite3_total_changes(db)

    fn total_changes64(self, db: UnsafePointer[sqlite3_connection]) -> sqlite3_int64:
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
        return self.lib.sqlite3_total_changes64(db)

    fn interrupt(self, db: UnsafePointer[sqlite3_connection]) -> None:
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
        self.lib.sqlite3_interrupt(db)

    fn is_interrupted(self, db: UnsafePointer[sqlite3_connection]) -> SQLite3Result:
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
        return self.lib.sqlite3_is_interrupted(db)

    fn complete(self, sql: UnsafePointer[c_char, mut=False]) -> SQLite3Result:
        """Determine If An SQL Statement Is Complete.

        These routines are useful during command-line input to determine if the
        currently entered text seems to form a complete SQL statement or if
        additional input is needed before sending the text into SQLite for parsing.

        The algorithm is simple. If the last token other than spaces and comments
        is a semicolon, then return true. Otherwise return false. This routine
        does not parse the SQL statements but only examines tokens to determine
        whether statements are complete.

        Args:
            sql: A null-terminated UTF-8 string containing an SQL statement.

        Returns:
            Non-zero if the SQL statement is complete, zero if incomplete.
        """
        return self.lib.sqlite3_complete(sql)

    fn complete16(self, sql: OpaquePointer) -> SQLite3Result:
        return self.lib.sqlite3_complete16(sql)

    fn busy_handler(
        self, db: UnsafePointer[sqlite3_connection], callback: fn (OpaquePointer, c_int) -> c_int, arg: OpaquePointer
    ) -> SQLite3Result:
        return self.lib.sqlite3_busy_handler(db, callback, arg)

    fn busy_timeout(self, db: UnsafePointer[sqlite3_connection], ms: c_int) -> SQLite3Result:
        return self.lib.sqlite3_busy_timeout(db, ms)

    fn setlk_timeout(self, db: UnsafePointer[sqlite3_connection], ms: c_int, flags: c_int) -> SQLite3Result:
        return self.lib.sqlite3_setlk_timeout(db, ms, flags)

    fn get_table(
        self,
        db: UnsafePointer[sqlite3_connection],
        sql: UnsafePointer[c_char, mut=False],
        pazResult: UnsafePointer[UnsafePointer[UnsafePointer[c_char]]],
        pnRow: UnsafePointer[c_int],
        pnColumn: UnsafePointer[c_int],
        pzErrmsg: UnsafePointer[UnsafePointer[c_char]],
    ) -> SQLite3Result:
        return self.lib.sqlite3_get_table(db, sql, pazResult, pnRow, pnColumn, pzErrmsg)

    fn free_table(self, result: UnsafePointer[UnsafePointer[c_char]]):
        self.lib.sqlite3_free_table(result)

    fn mprintf(self, format: UnsafePointer[c_char, mut=False]) -> StringSlice[ImmutableAnyOrigin]:
        return StringSlice(unsafe_from_utf8_ptr=self.lib.sqlite3_mprintf(format))

    fn snprintf(
        self, n: c_int, str: UnsafePointer[c_char], format: UnsafePointer[c_char, mut=False]
    ) -> StringSlice[ImmutableAnyOrigin]:
        return StringSlice(unsafe_from_utf8_ptr=self.lib.sqlite3_snprintf(n, str, format))

    # fn vmprintf(self):
    #     return self.lib.[fn(UnsafePointer[c_char, mut=False], va_list) -> UnsafePointer[c_char]]sqlite3_vmprintf()

    # fn vsnprintf(self):
    #     return self.lib.[fn(c_int, UnsafePointer[c_char], UnsafePointer[c_char, mut=False], va_list) -> UnsafePointer[c_char]]sqlite3_vsnprintf()

    fn malloc(self, size: c_int) -> OpaquePointer:
        return self.lib.sqlite3_malloc(size)

    fn malloc64(self, size: sqlite3_uint64) -> OpaquePointer:
        return self.lib.sqlite3_malloc64(size)

    fn realloc(self, ptr: OpaquePointer, size: c_int) -> OpaquePointer:
        return self.lib.sqlite3_realloc(ptr, size)

    fn realloc64(self, ptr: OpaquePointer, size: sqlite3_uint64) -> OpaquePointer:
        return self.lib.sqlite3_realloc64(ptr, size)

    fn free(self, ptr: OpaquePointer):
        self.lib.sqlite3_free(ptr)

    fn msize(self, ptr: OpaquePointer) -> sqlite3_uint64:
        return self.lib.sqlite3_msize(ptr)

    fn memory_used(self) -> sqlite3_int64:
        return self.lib.sqlite3_memory_used()

    fn memory_highwater(self, resetFlag: c_int) -> sqlite3_int64:
        return self.lib.sqlite3_memory_highwater(resetFlag)

    fn randomness(self, N: c_int, P: OpaquePointer):
        self.lib.sqlite3_randomness(N, P)

    fn set_authorizer(
        self,
        db: UnsafePointer[sqlite3_connection],
        xAuth: fn (
            OpaquePointer,
            c_int,
            UnsafePointer[c_char, mut=False],
            UnsafePointer[c_char, mut=False],
            UnsafePointer[c_char, mut=False],
            UnsafePointer[c_char, mut=False],
        ) -> c_int,
        pUserData: OpaquePointer,
    ) -> SQLite3Result:
        return self.lib.sqlite3_set_authorizer(db, xAuth, pUserData)

    fn trace(
        self,
        db: UnsafePointer[sqlite3_connection],
        xTrace: fn (OpaquePointer, UnsafePointer[c_char, mut=False]) -> NoneType,
        pArg: OpaquePointer,
    ) -> OpaquePointer:
        return self.lib.sqlite3_trace(db, xTrace, pArg)

    fn profile(
        self,
        db: UnsafePointer[sqlite3_connection],
        xProfile: fn (OpaquePointer, UnsafePointer[c_char, mut=False], sqlite3_uint64) -> NoneType,
        pArg: OpaquePointer,
    ) -> OpaquePointer:
        return self.lib.sqlite3_profile(db, xProfile, pArg)

    fn trace_v2(
        self,
        db: UnsafePointer[sqlite3_connection],
        uMask: UInt32,
        xCallback: fn (UInt32, OpaquePointer, OpaquePointer, OpaquePointer) -> c_int,
        pCtx: OpaquePointer,
    ) -> SQLite3Result:
        return self.lib.sqlite3_trace_v2(db, uMask, xCallback, pCtx)

    fn progress_handler(
        self,
        db: UnsafePointer[sqlite3_connection],
        nOps: c_int,
        xProgress: fn (OpaquePointer) -> c_int,
        pArg: OpaquePointer,
    ):
        self.lib.sqlite3_progress_handler(db, nOps, xProgress, pArg)

    fn open(
        self, filename: UnsafePointer[c_char, mut=False], ppDb: UnsafePointer[UnsafePointer[sqlite3_connection]]
    ) -> SQLite3Result:
        """Open A Database Connection.

        This routine opens a connection to an SQLite database file and returns
        a database connection object to be used by other SQLite routines.

        The database is opened with UTF-8 text encoding. If the filename is ":memory:",
        then a private, temporary in-memory database is created for the connection.
        This in-memory database will vanish when the database connection is closed.

        Whether or not an error occurs when it is opened, resources associated with
        the database connection handle should be released by passing it to
        sqlite3_close() when it is no longer required.

        Args:
            filename: Database filename (UTF-8 encoded).
            ppDb: OUT: SQLite db handle.

        Returns:
            SQLITE_OK on success, or an error code on failure.
        """
        return self.lib.sqlite3_open(filename, ppDb)

    fn open16(
        self, filename: UnsafePointer[NoneType, mut=False], ppDb: UnsafePointer[UnsafePointer[sqlite3_connection]]
    ) -> SQLite3Result:
        """Open A Database Connection (UTF-16).

        This routine opens a connection to an SQLite database file and returns
        a database connection object to be used by other SQLite routines.

        This works like sqlite3_open() except that the database filename is
        interpreted as UTF-16 native byte order instead of UTF-8. The
        sqlite3_open16() interface is provided for legacy compatibility.
        New applications should use sqlite3_open_v2() instead.

        Args:
            filename: Database filename (UTF-16 encoded).
            ppDb: OUT: SQLite db handle.

        Returns:
            SQLITE_OK on success, or an error code on failure.
        """
        return self.lib.sqlite3_open16(filename, ppDb)

    fn open_v2(
        self,
        filename: UnsafePointer[c_char, mut=False],
        ppDb: UnsafePointer[UnsafePointer[sqlite3_connection]],
        flags: c_int,
        zVfs: UnsafePointer[c_char, mut=False],
    ) -> SQLite3Result:
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
        return self.lib.sqlite3_open_v2(filename, ppDb, flags, zVfs)

    fn uri_parameter(
        self, z: sqlite3_filename, zParam: UnsafePointer[c_char, mut=False]
    ) -> UnsafePointer[c_char, mut=False]:
        return self.lib.sqlite3_uri_parameter(z, zParam)

    fn uri_boolean(
        self, z: sqlite3_filename, zParam: UnsafePointer[c_char, mut=False], bDefault: c_int
    ) -> SQLite3Result:
        return self.lib.sqlite3_uri_boolean(z, zParam, bDefault)

    fn uri_int64(
        self, z: sqlite3_filename, zParam: UnsafePointer[c_char, mut=False], dflt: sqlite3_int64
    ) -> sqlite3_int64:
        return self.lib.sqlite3_uri_int64(z, zParam, dflt)

    fn uri_key(self, z: sqlite3_filename, N: c_int) -> UnsafePointer[c_char, mut=False]:
        return self.lib.sqlite3_uri_key(z, N)

    fn filename_database(self, z: sqlite3_filename) -> UnsafePointer[c_char, mut=False]:
        return self.lib.sqlite3_filename_database(z)

    fn filename_journal(self, z: sqlite3_filename) -> UnsafePointer[c_char, mut=False]:
        return self.lib.sqlite3_filename_journal(z)

    fn filename_wal(self, z: sqlite3_filename) -> UnsafePointer[c_char, mut=False]:
        return self.lib.sqlite3_filename_wal(z)

    fn database_file_object(self, z: UnsafePointer[c_char, mut=False]) -> UnsafePointer[sqlite3_file]:
        return self.lib.sqlite3_database_file_object(z)

    fn create_filename(
        self,
        zDatabase: UnsafePointer[c_char, mut=False],
        zJournal: UnsafePointer[c_char, mut=False],
        zWal: UnsafePointer[c_char, mut=False],
        nParam: c_int,
        azParam: UnsafePointer[UnsafePointer[c_char, mut=False]],
    ) -> sqlite3_filename:
        return self.lib.sqlite3_create_filename(zDatabase, zJournal, zWal, nParam, azParam)

    fn free_filename(self, z: sqlite3_filename):
        self.lib.sqlite3_free_filename(z)

    fn errcode(self, db: UnsafePointer[sqlite3_connection]) -> SQLite3Result:
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
        return self.lib.sqlite3_errcode(db)

    fn extended_errcode(self, db: UnsafePointer[sqlite3_connection]) -> SQLite3Result:
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
        return self.lib.sqlite3_extended_errcode(db)

    fn errmsg(self, db: UnsafePointer[sqlite3_connection]) -> UnsafePointer[c_char, mut=False]:
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
        return self.lib.sqlite3_errmsg(db)

    fn errmsg16(self, db: UnsafePointer[sqlite3_connection]) -> UnsafePointer[NoneType, mut=False]:
        """Retrieve the UTF-16 encoded error message for the most recent error.

        This function returns a pointer to a UTF-16 native byte order encoded
        error message describing the most recent failed SQLite call associated
        with a database connection. The error string persists until the next
        SQLite call. This function is provided for legacy compatibility;
        new applications should use sqlite3_errmsg() instead.

        Args:
            db: Database connection handle.

        Returns:
            Pointer to UTF-16 encoded error message string.
        """
        return self.lib.sqlite3_errmsg16(db)

    fn errstr(self, e: c_int) -> UnsafePointer[c_char, mut=False]:
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
        return self.lib.sqlite3_errstr(e)

    fn error_offset(self, db: UnsafePointer[sqlite3_connection]) -> SQLite3Result:
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
        return self.lib.sqlite3_error_offset(db)

    fn limit(self, db: UnsafePointer[sqlite3_connection], id: c_int, newVal: c_int) -> SQLite3Result:
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
        return self.lib.sqlite3_limit(db, id, newVal)

    fn prepare(
        self,
        db: UnsafePointer[sqlite3_connection],
        zSql: UnsafePointer[c_char, mut=False],
        nByte: c_int,
        ppStmt: UnsafePointer[UnsafePointer[sqlite3_stmt]],
        pzTail: UnsafePointer[UnsafePointer[c_char, mut=False]],
    ) -> SQLite3Result:
        """Compile an SQL statement into a prepared statement object.

        This function compiles SQL text into a prepared statement object that
        can be executed using sqlite3_step() and other prepared statement APIs.
        This is the original version; new applications should use sqlite3_prepare_v2()
        or sqlite3_prepare_v3() instead.

        Args:
            db: Database connection handle.
            zSql: UTF-8 encoded SQL statement text.
            nByte: Maximum length of zSql in bytes (or -1 for null-terminated).
            ppStmt: OUT: Compiled prepared statement object.
            pzTail: OUT: Pointer to unused portion of zSql (or NULL).

        Returns:
            SQLITE_OK on success, or an error code on failure.
        """
        return self.lib.sqlite3_prepare(db, zSql, nByte, ppStmt, pzTail)

    fn prepare_v2(
        self,
        db: UnsafePointer[sqlite3_connection],
        zSql: UnsafePointer[c_char, mut=False],
        nByte: c_int,
        ppStmt: UnsafePointer[UnsafePointer[sqlite3_stmt]],
        pzTail: UnsafePointer[UnsafePointer[c_char, mut=False]],
    ) -> SQLite3Result:
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
        return self.lib.sqlite3_prepare_v2(db, zSql, nByte, ppStmt, pzTail)

    fn prepare_v3[sql: ImmutableOrigin, tail: MutableOrigin](
        self,
        db: UnsafePointer[sqlite3_connection],
        zSql: UnsafePointer[c_char, mut=False, origin=sql],
        nByte: c_int,
        prepFlags: UInt32,
        ppStmt: UnsafePointer[UnsafePointer[sqlite3_stmt]],
        pzTail: UnsafePointer[UnsafePointer[c_char, mut=False, origin=sql], origin=tail],
    ) -> SQLite3Result:
        return self.lib.sqlite3_prepare_v3(db, zSql, nByte, prepFlags, ppStmt, pzTail)

    fn prepare16(
        self,
        db: UnsafePointer[sqlite3_connection],
        zSql: UnsafePointer[NoneType, mut=False],
        nByte: c_int,
        ppStmt: UnsafePointer[UnsafePointer[sqlite3_stmt]],
        pzTail: UnsafePointer[OpaquePointer, mut=False],
    ) -> SQLite3Result:
        return self.lib.sqlite3_prepare16(db, zSql, nByte, ppStmt, pzTail)

    fn prepare16_v2(
        self,
        db: UnsafePointer[sqlite3_connection],
        zSql: UnsafePointer[NoneType, mut=False],
        nByte: c_int,
        ppStmt: UnsafePointer[UnsafePointer[sqlite3_stmt]],
        pzTail: UnsafePointer[OpaquePointer, mut=False],
    ) -> SQLite3Result:
        return self.lib.sqlite3_prepare16_v2(db, zSql, nByte, ppStmt, pzTail)

    fn prepare16_v3(
        self,
        db: UnsafePointer[sqlite3_connection],
        zSql: UnsafePointer[NoneType, mut=False],
        nByte: c_int,
        prepFlags: UInt32,
        ppStmt: UnsafePointer[UnsafePointer[sqlite3_stmt]],
        pzTail: UnsafePointer[OpaquePointer, mut=False],
    ) -> SQLite3Result:
        return self.lib.sqlite3_prepare16_v3(db, zSql, nByte, prepFlags, ppStmt, pzTail)

    fn sql(self, pStmt: UnsafePointer[sqlite3_stmt]) -> UnsafePointer[c_char, mut=False]:
        """Retrieve the SQL text of a prepared statement.

        Returns a pointer to a copy of the UTF-8 SQL text used to create the
        prepared statement if that statement was compiled using sqlite3_prepare_v2()
        or its variants.

        Args:
            pStmt: Pointer to the prepared statement.

        Returns:
            Pointer to the SQL text used to create the statement.
        """
        return self.lib.sqlite3_sql(pStmt)

    fn expanded_sql(self, pStmt: UnsafePointer[sqlite3_stmt]) -> SQLiteMallocString:
        """Retrieve SQL with bound parameters expanded.

        Returns a pointer to a UTF-8 string containing the SQL text of the
        prepared statement with bound parameters expanded inline. This is useful
        for debugging and logging purposes.

        Args:
            pStmt: Pointer to the prepared statement.

        Returns:
            Pointer to the expanded SQL text, or NULL if out of memory.
        """
        return SQLiteMallocString(self.lib.sqlite3_expanded_sql(pStmt))

    fn stmt_readonly(self, pStmt: UnsafePointer[sqlite3_stmt]) -> SQLite3Result:
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
        return self.lib.sqlite3_stmt_readonly(pStmt)

    fn stmt_isexplain(self, pStmt: UnsafePointer[sqlite3_stmt]) -> c_int:
        return self.lib.sqlite3_stmt_isexplain(pStmt)

    fn stmt_explain(self, pStmt: UnsafePointer[sqlite3_stmt], eMode: c_int) -> SQLite3Result:
        return self.lib.sqlite3_stmt_explain(pStmt, eMode)

    fn stmt_busy(self, pStmt: UnsafePointer[sqlite3_stmt]) -> SQLite3Result:
        return self.lib.sqlite3_stmt_busy(pStmt)

    fn bind_blob(
        self,
        pStmt: UnsafePointer[sqlite3_stmt],
        idx: c_int,
        value: UnsafePointer[NoneType, mut=False],
        n: c_int,
        destructor: fn (OpaquePointer) -> NoneType,
    ) -> SQLite3Result:
        """Binding Values To Prepared Statements - BLOB.

        This routine binds a BLOB value to a parameter in a prepared statement.
        The parameter is identified by its index (1-based). The BLOB data is
        copied or a reference is held depending on the destructor function.

        Args:
            pStmt: Prepared statement.
            idx: Index of the parameter (1-based).
            value: Pointer to the BLOB data.
            n: Number of bytes in the BLOB.
            destructor: Function called to dispose of the BLOB data.

        Returns:
            SQLITE_OK on success, or an error code on failure.
        """
        return self.lib.sqlite3_bind_blob(pStmt, idx, value, n, destructor)

    fn bind_blob64(
        self,
        pStmt: UnsafePointer[sqlite3_stmt],
        idx: c_int,
        value: UnsafePointer[NoneType, mut=False],
        n: sqlite3_uint64,
        destructor: fn (OpaquePointer) -> NoneType,
    ) -> SQLite3Result:
        return self.lib.sqlite3_bind_blob64(pStmt, idx, value, n, destructor)

    fn bind_double(self, pStmt: UnsafePointer[sqlite3_stmt], idx: c_int, value: Float64) -> SQLite3Result:
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
        return self.lib.sqlite3_bind_double(pStmt, idx, value)

    fn bind_int(self, pStmt: UnsafePointer[sqlite3_stmt], idx: c_int, value: c_int) -> SQLite3Result:
        return self.lib.sqlite3_bind_int(pStmt, idx, value)

    fn bind_int64(self, pStmt: UnsafePointer[sqlite3_stmt], idx: c_int, value: sqlite3_int64) -> SQLite3Result:
        return self.lib.sqlite3_bind_int64(pStmt, idx, value)

    fn bind_null(self, pStmt: UnsafePointer[sqlite3_stmt], idx: c_int) -> SQLite3Result:
        """Binding Values To Prepared Statements - NULL.

        This routine binds a NULL value to a parameter in a prepared statement.
        The parameter is identified by its index (1-based).

        Args:
            pStmt: Prepared statement.
            idx: Index of the parameter (1-based).

        Returns:
            SQLITE_OK on success, or an error code on failure.
        """
        return self.lib.sqlite3_bind_null(pStmt, idx)

    fn bind_text(
        self,
        pStmt: UnsafePointer[sqlite3_stmt],
        idx: c_int,
        value: UnsafePointer[c_char, mut=False],
        n: c_int,
        destructor: sqlite3_destructor_type,
    ) -> SQLite3Result:
        return self.lib.sqlite3_bind_text(pStmt, idx, value, n, destructor)

    fn bind_text16(
        self,
        pStmt: UnsafePointer[sqlite3_stmt],
        idx: c_int,
        value: UnsafePointer[NoneType, mut=False],
        n: c_int,
        destructor: fn (OpaquePointer) -> NoneType,
    ) -> SQLite3Result:
        return self.lib.sqlite3_bind_text16(pStmt, idx, value, n, destructor)

    fn bind_text64(
        self,
        pStmt: UnsafePointer[sqlite3_stmt],
        idx: c_int,
        value: UnsafePointer[c_char, mut=False],
        n: sqlite3_uint64,
        destructor: fn (OpaquePointer) -> NoneType,
        encoding: UInt8,
    ) -> SQLite3Result:
        return self.lib.sqlite3_bind_text64(pStmt, idx, value, n, destructor, encoding)

    fn bind_value(
        self, pStmt: UnsafePointer[sqlite3_stmt], idx: c_int, value: UnsafePointer[sqlite3_value, mut=False]
    ) -> SQLite3Result:
        return self.lib.sqlite3_bind_value(pStmt, idx, value)

    fn bind_pointer(
        self,
        pStmt: UnsafePointer[sqlite3_stmt],
        idx: c_int,
        value: OpaquePointer,
        typeStr: UnsafePointer[c_char, mut=False],
        destructor: fn (OpaquePointer) -> NoneType,
    ) -> SQLite3Result:
        return self.lib.sqlite3_bind_pointer(pStmt, idx, value, typeStr, destructor)

    fn bind_zeroblob(self, pStmt: UnsafePointer[sqlite3_stmt], idx: c_int, n: c_int) -> SQLite3Result:
        return self.lib.sqlite3_bind_zeroblob(pStmt, idx, n)

    fn bind_zeroblob64(self, pStmt: UnsafePointer[sqlite3_stmt], idx: c_int, n: sqlite3_uint64) -> SQLite3Result:
        return self.lib.sqlite3_bind_zeroblob64(pStmt, idx, n)

    fn bind_parameter_count(self, pStmt: UnsafePointer[sqlite3_stmt]) -> c_int:
        """Return the number of parameters in a prepared statement.

        This function returns the number of SQL parameters in the prepared
        statement. SQL parameters are tokens such as "?" or ":name" or "$var"
        that are used to substitute values at runtime.

        Args:
            pStmt: Pointer to the prepared statement.

        Returns:
            The number of SQL parameters in the prepared statement.
        """
        return self.lib.sqlite3_bind_parameter_count(pStmt)

    fn bind_parameter_name(self, pStmt: UnsafePointer[sqlite3_stmt], idx: c_int) -> UnsafePointer[c_char, mut=False]:
        return self.lib.sqlite3_bind_parameter_name(pStmt, idx)

    fn bind_parameter_index(
        self, pStmt: UnsafePointer[sqlite3_stmt], zName: UnsafePointer[c_char, mut=False]
    ) -> c_int:
        return self.lib.sqlite3_bind_parameter_index(pStmt, zName)

    fn clear_bindings(self, pStmt: UnsafePointer[sqlite3_stmt]) -> SQLite3Result:
        """Reset All Bindings On A Prepared Statement.

        Contrary to the intuition of many, sqlite3_reset() does not reset
        the bindings on a prepared statement. This routine resets all
        parameters to NULL.

        Args:
            pStmt: Prepared statement.

        Returns:
            SQLITE_OK on success, or an error code on failure.
        """
        return self.lib.sqlite3_clear_bindings(pStmt)

    fn column_count(self, pStmt: UnsafePointer[sqlite3_stmt]) -> c_int:
        """Return the number of columns in a result set.

        This function returns the number of columns in the result set returned
        by the prepared statement. This value does not change from one execution
        of the prepared statement to the next.

        Args:
            pStmt: Pointer to the prepared statement.

        Returns:
            The number of columns in the result set.
        """
        return self.lib.sqlite3_column_count(pStmt)

    fn column_name(self, pStmt: UnsafePointer[sqlite3_stmt], N: c_int) -> UnsafePointer[c_char, mut=False]:
        return self.lib.sqlite3_column_name(pStmt, N)

    fn column_name16(self, pStmt: UnsafePointer[sqlite3_stmt], N: c_int) -> UnsafePointer[NoneType, mut=False]:
        return self.lib.sqlite3_column_name16(pStmt, N)

    fn column_database_name(self, pStmt: UnsafePointer[sqlite3_stmt], idx: c_int) -> UnsafePointer[c_char, mut=False]:
        return self.lib.sqlite3_column_database_name(pStmt, idx)

    fn column_database_name16(
        self, pStmt: UnsafePointer[sqlite3_stmt], idx: c_int
    ) -> UnsafePointer[NoneType, mut=False]:
        return self.lib.sqlite3_column_database_name16(pStmt, idx)

    fn column_table_name(self, pStmt: UnsafePointer[sqlite3_stmt], idx: c_int) -> UnsafePointer[c_char, mut=False]:
        return self.lib.sqlite3_column_table_name(pStmt, idx)

    fn column_table_name16(self, pStmt: UnsafePointer[sqlite3_stmt], idx: c_int) -> UnsafePointer[NoneType, mut=False]:
        return self.lib.sqlite3_column_table_name16(pStmt, idx)

    fn column_origin_name(self, pStmt: UnsafePointer[sqlite3_stmt], idx: c_int) -> UnsafePointer[c_char, mut=False]:
        return self.lib.sqlite3_column_origin_name(pStmt, idx)

    fn column_origin_name16(self, pStmt: UnsafePointer[sqlite3_stmt], idx: c_int) -> UnsafePointer[NoneType, mut=False]:
        return self.lib.sqlite3_column_origin_name16(pStmt, idx)

    fn column_decltype(self, pStmt: UnsafePointer[sqlite3_stmt], idx: c_int) -> UnsafePointer[c_char, mut=False]:
        return self.lib.sqlite3_column_decltype(pStmt, idx)

    fn column_decltype16(self, pStmt: UnsafePointer[sqlite3_stmt], idx: c_int) -> UnsafePointer[NoneType, mut=False]:
        return self.lib.sqlite3_column_decltype16(pStmt, idx)

    fn step(self, pStmt: UnsafePointer[sqlite3_stmt]) -> SQLite3Result:
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
        return self.lib.sqlite3_step(pStmt)

    fn data_count(self, pStmt: UnsafePointer[sqlite3_stmt]) -> SQLite3Result:
        """Number Of Columns In A Result Set.

        The sqlite3_data_count() routine returns the number of columns in the
        current row of the result set of prepared statement. This routine returns
        0 if pStmt is a NULL pointer or if the most recent call to sqlite3_step()
        returned SQLITE_DONE.

        Args:
            pStmt: Prepared statement.

        Returns:
            Number of columns in the current row, or 0 if no current row.
        """
        return self.lib.sqlite3_data_count(pStmt)

    fn column_blob(self, pStmt: UnsafePointer[sqlite3_stmt], iCol: c_int) -> OpaquePointer:
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
        return self.lib.sqlite3_column_blob(pStmt, iCol)

    fn column_double(self, pStmt: UnsafePointer[sqlite3_stmt], iCol: c_int) -> Float64:
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
        return self.lib.sqlite3_column_double(pStmt, iCol)

    fn column_int(self, pStmt: UnsafePointer[sqlite3_stmt], iCol: c_int) -> SQLite3Result:
        """Result Values From A Query - INTEGER.

        This routine returns the value of the specified column as a 32-bit
        signed integer. If the column contains a NULL value or cannot be
        converted to an integer, it returns 0.

        Args:
            pStmt: Prepared statement being evaluated.
            iCol: Index of the column (leftmost column is 0).

        Returns:
            The column value as a 32-bit signed integer.
        """
        return self.lib.sqlite3_column_int(pStmt, iCol)

    fn column_int64(self, pStmt: UnsafePointer[sqlite3_stmt], iCol: c_int) -> sqlite3_int64:
        return self.lib.sqlite3_column_int64(pStmt, iCol)

    fn column_text(self, pStmt: UnsafePointer[sqlite3_stmt], iCol: c_int) -> UnsafePointer[UInt8]:
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
        return self.lib.sqlite3_column_text(pStmt, iCol)

    fn column_text16(self, pStmt: UnsafePointer[sqlite3_stmt], iCol: c_int) -> OpaquePointer:
        return self.lib.sqlite3_column_text16(pStmt, iCol)

    fn column_value(self, pStmt: UnsafePointer[sqlite3_stmt], iCol: c_int) -> UnsafePointer[sqlite3_value]:
        return self.lib.sqlite3_column_value(pStmt, iCol)

    fn column_bytes(self, pStmt: UnsafePointer[sqlite3_stmt], iCol: c_int) -> c_int:
        return self.lib.sqlite3_column_bytes(pStmt, iCol)

    fn column_bytes16(self, pStmt: UnsafePointer[sqlite3_stmt], iCol: c_int) -> c_int:
        return self.lib.sqlite3_column_bytes16(pStmt, iCol)

    fn column_type(self, pStmt: UnsafePointer[sqlite3_stmt], iCol: c_int) -> c_int:
        return self.lib.sqlite3_column_type(pStmt, iCol)

    fn finalize(self, pStmt: UnsafePointer[sqlite3_stmt]) -> SQLite3Result:
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
        return self.lib.sqlite3_finalize(pStmt)

    fn reset(self, pStmt: UnsafePointer[sqlite3_stmt]) -> SQLite3Result:
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
        return self.lib.sqlite3_reset(pStmt)

    fn create_function(
        self,
        db: UnsafePointer[sqlite3_connection],
        zFunctionName: UnsafePointer[c_char, mut=False],
        nArg: c_int,
        eTextRep: c_int,
        pApp: OpaquePointer,
        xFunc: fn (UnsafePointer[sqlite3_context], c_int, UnsafePointer[UnsafePointer[sqlite3_value]]) -> NoneType,
        xStep: fn (UnsafePointer[sqlite3_context], c_int, UnsafePointer[UnsafePointer[sqlite3_value]]) -> NoneType,
        xFinal: fn (UnsafePointer[sqlite3_context]) -> NoneType,
    ) -> SQLite3Result:
        return self.lib.sqlite3_create_function(db, zFunctionName, nArg, eTextRep, pApp, xFunc, xStep, xFinal)

    fn create_function16(
        self,
        db: UnsafePointer[sqlite3_connection],
        zFunctionName: UnsafePointer[c_char, mut=False],
        nArg: c_int,
        eTextRep: c_int,
        pApp: OpaquePointer,
        xFunc: fn (UnsafePointer[sqlite3_context], c_int, UnsafePointer[UnsafePointer[sqlite3_value]]) -> NoneType,
        xStep: fn (UnsafePointer[sqlite3_context], c_int, UnsafePointer[UnsafePointer[sqlite3_value]]) -> NoneType,
        xFinal: fn (UnsafePointer[sqlite3_context]) -> NoneType,
    ) -> SQLite3Result:
        return self.lib.sqlite3_create_function16(db, zFunctionName, nArg, eTextRep, pApp, xFunc, xStep, xFinal)

    fn create_function_v2(
        self,
        db: UnsafePointer[sqlite3_connection],
        zFunctionName: UnsafePointer[c_char, mut=False],
        nArg: c_int,
        eTextRep: c_int,
        pApp: OpaquePointer,
        xFunc: fn (UnsafePointer[sqlite3_context], c_int, UnsafePointer[UnsafePointer[sqlite3_value]]) -> NoneType,
        xStep: fn (UnsafePointer[sqlite3_context], c_int, UnsafePointer[UnsafePointer[sqlite3_value]]) -> NoneType,
        xFinal: fn (UnsafePointer[sqlite3_context]) -> NoneType,
        xDestroy: fn (OpaquePointer) -> NoneType,
    ) -> SQLite3Result:
        return self.lib.sqlite3_create_function_v2(
            db, zFunctionName, nArg, eTextRep, pApp, xFunc, xStep, xFinal, xDestroy
        )

    fn create_window_function(
        self,
        db: UnsafePointer[sqlite3_connection],
        zFunctionName: UnsafePointer[c_char, mut=False],
        nArg: c_int,
        eTextRep: c_int,
        pApp: OpaquePointer,
        xStep: fn (UnsafePointer[sqlite3_context], c_int, UnsafePointer[UnsafePointer[sqlite3_value]]) -> NoneType,
        xFinal: fn (UnsafePointer[sqlite3_context]) -> NoneType,
        xValue: fn (UnsafePointer[sqlite3_context]) -> NoneType,
        xInverse: fn (UnsafePointer[sqlite3_context], c_int, UnsafePointer[UnsafePointer[sqlite3_value]]) -> NoneType,
        xDestroy: fn (OpaquePointer) -> NoneType,
    ) -> SQLite3Result:
        return self.lib.sqlite3_create_window_function(
            db, zFunctionName, nArg, eTextRep, pApp, xStep, xFinal, xValue, xInverse, xDestroy
        )

    fn aggregate_count(self, ctx: UnsafePointer[sqlite3_context]) -> SQLite3Result:
        return self.lib.sqlite3_aggregate_count(ctx)

    fn expired(self, pStmt: UnsafePointer[sqlite3_stmt]) -> SQLite3Result:
        return self.lib.sqlite3_expired(pStmt)

    fn transfer_bindings(
        self, fromStmt: UnsafePointer[sqlite3_stmt], toStmt: UnsafePointer[sqlite3_stmt]
    ) -> SQLite3Result:
        return self.lib.sqlite3_transfer_bindings(fromStmt, toStmt)

    fn global_recover(self) -> SQLite3Result:
        return self.lib.sqlite3_global_recover()

    fn thread_cleanup(self):
        self.lib.sqlite3_thread_cleanup()

    fn memory_alarm(
        self, callback: fn (OpaquePointer, sqlite3_int64, c_int) -> NoneType, arg: OpaquePointer, n: sqlite3_int64
    ) -> SQLite3Result:
        return self.lib.sqlite3_memory_alarm(callback, arg, n)

    fn value_blob(self, value: UnsafePointer[sqlite3_value]) -> OpaquePointer:
        return self.lib.sqlite3_value_blob(value)

    fn value_double(self, value: UnsafePointer[sqlite3_value]) -> Float64:
        return self.lib.sqlite3_value_double(value)

    fn value_int(self, value: UnsafePointer[sqlite3_value]) -> SQLite3Result:
        return self.lib.sqlite3_value_int(value)

    fn value_int64(self, value: UnsafePointer[sqlite3_value]) -> sqlite3_int64:
        return self.lib.sqlite3_value_int64(value)

    fn value_pointer(
        self, value: UnsafePointer[sqlite3_value], typeStr: UnsafePointer[c_char, mut=False]
    ) -> OpaquePointer:
        return self.lib.sqlite3_value_pointer(value, typeStr)

    fn value_text(self, value: UnsafePointer[sqlite3_value]) -> UnsafePointer[UInt8]:
        return self.lib.sqlite3_value_text(value)

    fn value_text16(self, value: UnsafePointer[sqlite3_value]) -> OpaquePointer:
        return self.lib.sqlite3_value_text16(value)

    fn value_text16le(self, value: UnsafePointer[sqlite3_value]) -> OpaquePointer:
        return self.lib.sqlite3_value_text16le(value)

    fn value_text16be(self, value: UnsafePointer[sqlite3_value]) -> OpaquePointer:
        return self.lib.sqlite3_value_text16be(value)

    fn value_bytes(self, value: UnsafePointer[sqlite3_value]) -> SQLite3Result:
        return self.lib.sqlite3_value_bytes(value)

    fn value_bytes16(self, value: UnsafePointer[sqlite3_value]) -> SQLite3Result:
        return self.lib.sqlite3_value_bytes16(value)

    fn value_type(self, value: UnsafePointer[sqlite3_value]) -> SQLite3Result:
        return self.lib.sqlite3_value_type(value)

    fn value_numeric_type(self, value: UnsafePointer[sqlite3_value]) -> SQLite3Result:
        return self.lib.sqlite3_value_numeric_type(value)

    fn value_nochange(self, value: UnsafePointer[sqlite3_value]) -> SQLite3Result:
        return self.lib.sqlite3_value_nochange(value)

    fn value_frombind(self, value: UnsafePointer[sqlite3_value]) -> SQLite3Result:
        return self.lib.sqlite3_value_frombind(value)

    fn value_encoding(self, value: UnsafePointer[sqlite3_value]) -> SQLite3Result:
        return self.lib.sqlite3_value_encoding(value)

    fn value_subtype(self, value: UnsafePointer[sqlite3_value]) -> UInt32:
        return self.lib.sqlite3_value_subtype(value)

    fn value_dup(self, value: UnsafePointer[sqlite3_value, mut=False]) -> UnsafePointer[sqlite3_value]:
        return self.lib.sqlite3_value_dup(value)

    fn value_free(self, value: UnsafePointer[sqlite3_value]):
        self.lib.sqlite3_value_free(value)

    fn aggregate_context(self, ctx: UnsafePointer[sqlite3_context], nBytes: c_int) -> OpaquePointer:
        return self.lib.sqlite3_aggregate_context(ctx, nBytes)

    fn user_data(self, ctx: UnsafePointer[sqlite3_context]) -> OpaquePointer:
        return self.lib.sqlite3_user_data(ctx)

    fn context_db_handle(self, ctx: UnsafePointer[sqlite3_context]) -> UnsafePointer[sqlite3_connection]:
        return self.lib.sqlite3_context_db_handle(ctx)

    fn get_auxdata(self, ctx: UnsafePointer[sqlite3_context], N: c_int) -> OpaquePointer:
        return self.lib.sqlite3_get_auxdata(ctx, N)

    fn set_auxdata(
        self,
        ctx: UnsafePointer[sqlite3_context],
        N: c_int,
        data: OpaquePointer,
        destructor: fn (OpaquePointer) -> NoneType,
    ):
        self.lib.sqlite3_set_auxdata(ctx, N, data, destructor)

    fn get_clientdata(
        self, db: UnsafePointer[sqlite3_connection], key: UnsafePointer[c_char, mut=False]
    ) -> OpaquePointer:
        return self.lib.sqlite3_get_clientdata(db, key)

    fn set_clientdata(
        self,
        db: UnsafePointer[sqlite3_connection],
        key: UnsafePointer[c_char, mut=False],
        data: OpaquePointer,
        destructor: fn (OpaquePointer) -> NoneType,
    ) -> SQLite3Result:
        return self.lib.sqlite3_set_clientdata(db, key, data, destructor)

    fn result_blob(
        self,
        ctx: UnsafePointer[sqlite3_context],
        value: OpaquePointer,
        n: c_int,
        destructor: fn (OpaquePointer) -> NoneType,
    ):
        self.lib.sqlite3_result_blob(ctx, value, n, destructor)

    fn result_blob64(
        self,
        ctx: UnsafePointer[sqlite3_context],
        value: OpaquePointer,
        n: sqlite3_uint64,
        destructor: fn (OpaquePointer) -> NoneType,
    ):
        self.lib.sqlite3_result_blob64(ctx, value, n, destructor)

    fn result_double(self, ctx: UnsafePointer[sqlite3_context], value: Float64):
        self.lib.sqlite3_result_double(ctx, value)

    fn result_error(self, ctx: UnsafePointer[sqlite3_context], msg: UnsafePointer[c_char, mut=False], n: c_int):
        self.lib.sqlite3_result_error(ctx, msg, n)

    fn result_error16(self, ctx: UnsafePointer[sqlite3_context], msg: UnsafePointer[NoneType, mut=False], n: c_int):
        self.lib.sqlite3_result_error16(ctx, msg, n)

    fn result_error_toobig(self, ctx: UnsafePointer[sqlite3_context]):
        self.lib.sqlite3_result_error_toobig(ctx)

    fn result_error_nomem(self, ctx: UnsafePointer[sqlite3_context]):
        self.lib.sqlite3_result_error_nomem(ctx)

    fn result_error_code(self, ctx: UnsafePointer[sqlite3_context], code: c_int):
        self.lib.sqlite3_result_error_code(ctx, code)

    fn result_int(self, ctx: UnsafePointer[sqlite3_context], value: c_int):
        self.lib.sqlite3_result_int(ctx, value)

    fn result_int64(self, ctx: UnsafePointer[sqlite3_context], value: sqlite3_int64):
        self.lib.sqlite3_result_int64(ctx, value)

    fn result_null(self, ctx: UnsafePointer[sqlite3_context]):
        self.lib.sqlite3_result_null(ctx)

    fn result_text(
        self,
        ctx: UnsafePointer[sqlite3_context],
        value: UnsafePointer[c_char, mut=False],
        n: c_int,
        destructor: fn (OpaquePointer) -> NoneType,
    ):
        self.lib.sqlite3_result_text(ctx, value, n, destructor)

    fn result_text64(
        self,
        ctx: UnsafePointer[sqlite3_context],
        value: UnsafePointer[c_char, mut=False],
        n: sqlite3_uint64,
        destructor: fn (OpaquePointer) -> NoneType,
        encoding: UInt8,
    ):
        self.lib.sqlite3_result_text64(ctx, value, n, destructor, encoding)

    fn result_text16(
        self,
        ctx: UnsafePointer[sqlite3_context],
        value: UnsafePointer[NoneType, mut=False],
        n: c_int,
        destructor: fn (OpaquePointer) -> NoneType,
    ):
        self.lib.sqlite3_result_text16(ctx, value, n, destructor)

    fn result_text16le(
        self,
        ctx: UnsafePointer[sqlite3_context],
        value: UnsafePointer[NoneType, mut=False],
        n: c_int,
        destructor: fn (OpaquePointer) -> NoneType,
    ):
        self.lib.sqlite3_result_text16le(ctx, value, n, destructor)

    fn result_text16be(
        self,
        ctx: UnsafePointer[sqlite3_context],
        value: UnsafePointer[NoneType, mut=False],
        n: c_int,
        destructor: fn (OpaquePointer) -> NoneType,
    ):
        self.lib.sqlite3_result_text16be(ctx, value, n, destructor)

    fn result_value(self, ctx: UnsafePointer[sqlite3_context], value: UnsafePointer[sqlite3_value]):
        self.lib.sqlite3_result_value(ctx, value)

    fn result_pointer(
        self,
        ctx: UnsafePointer[sqlite3_context],
        ptr: OpaquePointer,
        typeStr: UnsafePointer[c_char, mut=False],
        destructor: fn (OpaquePointer) -> NoneType,
    ):
        self.lib.sqlite3_result_pointer(ctx, ptr, typeStr, destructor)

    fn result_zeroblob(self, ctx: UnsafePointer[sqlite3_context], n: c_int):
        self.lib.sqlite3_result_zeroblob(ctx, n)

    fn result_zeroblob64(self, ctx: UnsafePointer[sqlite3_context], n: sqlite3_uint64) -> SQLite3Result:
        return self.lib.sqlite3_result_zeroblob64(ctx, n)

    fn result_subtype(self, ctx: UnsafePointer[sqlite3_context], subtype: UInt32):
        self.lib.sqlite3_result_subtype(ctx, subtype)

    fn create_collation(
        self,
        db: UnsafePointer[sqlite3_connection],
        zName: UnsafePointer[c_char, mut=False],
        eTextRep: c_int,
        pArg: OpaquePointer,
        xCompare: fn (
            OpaquePointer, c_int, UnsafePointer[NoneType, mut=False], c_int, UnsafePointer[NoneType, mut=False]
        ) -> c_int,
    ) -> SQLite3Result:
        return self.lib.sqlite3_create_collation(db, zName, eTextRep, pArg, xCompare)

    fn create_collation_v2(
        self,
        db: UnsafePointer[sqlite3_connection],
        zName: UnsafePointer[c_char, mut=False],
        eTextRep: c_int,
        pArg: OpaquePointer,
        xCompare: fn (
            OpaquePointer, c_int, UnsafePointer[NoneType, mut=False], c_int, UnsafePointer[NoneType, mut=False]
        ) -> c_int,
        xDestroy: fn (OpaquePointer) -> NoneType,
    ) -> SQLite3Result:
        return self.lib.sqlite3_create_collation_v2(db, zName, eTextRep, pArg, xCompare, xDestroy)

    fn create_collation16(
        self,
        db: UnsafePointer[sqlite3_connection],
        zName: UnsafePointer[NoneType, mut=False],
        eTextRep: c_int,
        pArg: OpaquePointer,
        xCompare: fn (
            OpaquePointer, c_int, UnsafePointer[NoneType, mut=False], c_int, UnsafePointer[NoneType, mut=False]
        ) -> c_int,
    ) -> SQLite3Result:
        return self.lib.sqlite3_create_collation16(db, zName, eTextRep, pArg, xCompare)

    fn collation_needed(
        self,
        db: UnsafePointer[sqlite3_connection],
        pArg: OpaquePointer,
        callback: fn (
            OpaquePointer, UnsafePointer[sqlite3_connection], c_int, UnsafePointer[c_char, mut=False]
        ) -> NoneType,
    ) -> SQLite3Result:
        return self.lib.sqlite3_collation_needed(db, pArg, callback)

    fn collation_needed16(
        self,
        db: UnsafePointer[sqlite3_connection],
        pArg: OpaquePointer,
        callback: fn (
            OpaquePointer, UnsafePointer[sqlite3_connection], c_int, UnsafePointer[NoneType, mut=False]
        ) -> NoneType,
    ) -> SQLite3Result:
        return self.lib.sqlite3_collation_needed16(db, pArg, callback)

    fn sleep(self, ms: c_int) -> SQLite3Result:
        return self.lib.sqlite3_sleep(ms)

    fn soft_heap_limit(self, n: c_int) -> SQLite3Result:
        return self.lib.sqlite3_soft_heap_limit(n)

    fn soft_heap_limit64(self, n: sqlite3_int64) -> sqlite3_int64:
        return self.lib.sqlite3_soft_heap_limit64(n)

    fn status(
        self, op: c_int, pCurrent: UnsafePointer[c_int], pHighwater: UnsafePointer[c_int], resetFlag: c_int
    ) -> SQLite3Result:
        return self.lib.sqlite3_status(op, pCurrent, pHighwater, resetFlag)

    fn status64(
        self,
        op: c_int,
        pCurrent: UnsafePointer[sqlite3_int64],
        pHighwater: UnsafePointer[sqlite3_int64],
        resetFlag: c_int,
    ) -> SQLite3Result:
        return self.lib.sqlite3_status64(op, pCurrent, pHighwater, resetFlag)

    fn db_status(
        self,
        db: UnsafePointer[sqlite3_connection],
        op: c_int,
        pCurrent: UnsafePointer[c_int],
        pHighwater: UnsafePointer[c_int],
        resetFlag: c_int,
    ) -> SQLite3Result:
        return self.lib.sqlite3_db_status(db, op, pCurrent, pHighwater, resetFlag)

    fn stmt_status(self, pStmt: UnsafePointer[sqlite3_stmt], op: c_int, resetFlg: c_int) -> SQLite3Result:
        return self.lib.sqlite3_stmt_status(pStmt, op, resetFlg)

    fn stmt_scanstatus(
        self,
        pStmt: UnsafePointer[sqlite3_stmt],
        idx: c_int,
        what: c_int,
        out_ptr: UnsafePointer[OpaquePointer],
    ) -> SQLite3Result:
        return self.lib.sqlite3_stmt_scanstatus(pStmt, idx, what, out_ptr)

    fn stmt_scanstatus_reset(self, pStmt: UnsafePointer[sqlite3_stmt]):
        self.lib.sqlite3_stmt_scanstatus_reset(pStmt)

    fn table_column_metadata(
        self,
        db: UnsafePointer[sqlite3_connection],
        zDbName: UnsafePointer[c_char, mut=False],
        zTableName: UnsafePointer[c_char, mut=False],
        zColumnName: UnsafePointer[c_char, mut=False],
        pzDataType: UnsafePointer[UnsafePointer[c_char, mut=False]],
        pzCollSeq: UnsafePointer[UnsafePointer[c_char, mut=False]],
        pNotNull: UnsafePointer[c_int],
        pPrimaryKey: UnsafePointer[c_int],
        pAutoinc: UnsafePointer[c_int],
    ) -> SQLite3Result:
        return self.lib.sqlite3_table_column_metadata(
            db, zDbName, zTableName, zColumnName, pzDataType, pzCollSeq, pNotNull, pPrimaryKey, pAutoinc
        )

    fn load_extension(
        self,
        db: UnsafePointer[sqlite3_connection],
        zFile: UnsafePointer[c_char, mut=False],
        zProc: UnsafePointer[c_char, mut=False],
        pzErrMsg: UnsafePointer[UnsafePointer[c_char]],
    ) -> SQLite3Result:
        return self.lib.sqlite3_load_extension(db, zFile, zProc, pzErrMsg)

    fn enable_load_extension(self, db: UnsafePointer[sqlite3_connection], onoff: c_int) -> SQLite3Result:
        return self.lib.sqlite3_enable_load_extension(db, onoff)

    fn win32_set_directory(self, type_: UInt64, zValue: OpaquePointer) -> SQLite3Result:
        return self.lib.sqlite3_win32_set_directory(type_, zValue)

    fn win32_set_directory8(self, type_: UInt64, zValue: UnsafePointer[c_char, mut=False]) -> SQLite3Result:
        return self.lib.sqlite3_win32_set_directory8(type_, zValue)

    fn win32_set_directory16(self, type_: UInt64, read zValue: OpaquePointer) -> SQLite3Result:
        return self.lib.sqlite3_win32_set_directory16(type_, zValue)

    fn get_autocommit(self, db: UnsafePointer[sqlite3_connection]) -> Bool:
        return self.lib.sqlite3_get_autocommit(db) != 0

    fn db_handle(self, pStmt: UnsafePointer[sqlite3_stmt]) -> UnsafePointer[sqlite3_connection]:
        return self.lib.sqlite3_db_handle(pStmt)

    fn db_name(self, db: UnsafePointer[sqlite3_connection], N: c_int) -> UnsafePointer[c_char, mut=False]:
        return self.lib.sqlite3_db_name(db, N)

    fn db_filename(
        self, db: UnsafePointer[sqlite3_connection], zDbName: UnsafePointer[c_char, mut=False]
    ) -> sqlite3_filename:
        return self.lib.sqlite3_db_filename(db, zDbName)

    fn db_readonly(
        self, db: UnsafePointer[sqlite3_connection], zDbName: UnsafePointer[c_char, mut=False]
    ) -> SQLite3Result:
        return self.lib.sqlite3_db_readonly(db, zDbName)

    fn txn_state(
        self, db: UnsafePointer[sqlite3_connection], /, zSchema: UnsafePointer[c_char, mut=False]
    ) -> SQLite3Result:
        return self.lib.sqlite3_txn_state(db, zSchema)

    fn next_stmt(
        self, pDb: UnsafePointer[sqlite3_connection], pStmt: UnsafePointer[sqlite3_stmt]
    ) -> UnsafePointer[sqlite3_stmt]:
        return self.lib.sqlite3_next_stmt(pDb, pStmt)

    fn update_hook(
        self,
        db: UnsafePointer[sqlite3_connection],
        xCallback: UnsafePointer[
            fn (UnsafePointer[NoneType], c_int, UnsafePointer[c_char], UnsafePointer[c_char], Int64)
        ],
        pArg: UnsafePointer[NoneType],
    ) -> None:
        self.lib.sqlite3_update_hook(db, xCallback, pArg)

    fn commit_hook(
        self,
        db: UnsafePointer[sqlite3_connection],
        xCallback: UnsafePointer[fn (UnsafePointer[NoneType]) -> c_int],
        pArg: UnsafePointer[NoneType],
    ) -> UnsafePointer[NoneType]:
        return self.lib.sqlite3_commit_hook(db, xCallback, pArg)

    fn rollback_hook(
        self,
        db: UnsafePointer[sqlite3_connection],
        xCallback: UnsafePointer[fn (UnsafePointer[NoneType])],
        pArg: UnsafePointer[NoneType],
    ) -> UnsafePointer[NoneType]:
        return self.lib.sqlite3_rollback_hook(db, xCallback, pArg)

    fn autovacuum_pages(
        self,
        db: UnsafePointer[sqlite3_connection],
        xCallback: UnsafePointer[
            fn (UnsafePointer[NoneType], UnsafePointer[c_char, mut=False], c_uint, c_uint, c_uint) -> c_int
        ],
        pArg: UnsafePointer[NoneType],
        eMode: c_int,
    ) -> SQLite3Result:
        return self.lib.sqlite3_autovacuum_pages(db, xCallback, pArg, eMode)

    # sqlite3_auto_extension
    fn auto_extension(self, xEntryPoint: UnsafePointer[fn () -> c_int]) -> SQLite3Result:
        return self.lib.sqlite3_auto_extension(xEntryPoint)

    # sqlite3_enable_shared_cache
    fn enable_shared_cache(self, enable: c_int) -> SQLite3Result:
        return self.lib.sqlite3_enable_shared_cache(enable)

    # sqlite3_release_memory
    fn release_memory(self, bytes: c_int) -> SQLite3Result:
        return self.lib.sqlite3_release_memory(bytes)

    # sqlite3_db_release_memory
    fn db_release_memory(self, db: UnsafePointer[sqlite3_connection]) -> SQLite3Result:
        return self.lib.sqlite3_db_release_memory(db)

    # sqlite3_hard_heap_limit64
    fn hard_heap_limit64(self, n: Int64) -> Int64:
        return self.lib.sqlite3_hard_heap_limit64(n)

    # sqlite3_cancel_auto_extension
    fn cancel_auto_extension(self, xEntryPoint: UnsafePointer[fn () -> c_int]) -> SQLite3Result:
        return self.lib.sqlite3_cancel_auto_extension(xEntryPoint)

    fn reset_auto_extension(self) -> SQLite3Result:
        return self.lib.sqlite3_reset_auto_extension()

    fn blob_open(
        self,
        db: UnsafePointer[sqlite3_connection],
        zDb: UnsafePointer[c_char, mut=False],
        zTable: UnsafePointer[c_char, mut=False],
        zColumn: UnsafePointer[c_char, mut=False],
        iRow: sqlite3_int64,
        flags: c_int,
        ppBlob: UnsafePointer[UnsafePointer[sqlite3_blob]],
    ) -> SQLite3Result:
        return self.lib.sqlite3_blob_open(db, zDb, zTable, zColumn, iRow, flags, ppBlob)

    fn blob_reopen(self, pBlob: UnsafePointer[sqlite3_blob], iRow: sqlite3_int64) -> SQLite3Result:
        return self.lib.sqlite3_blob_reopen(pBlob, iRow)

    fn blob_close(self, pBlob: UnsafePointer[sqlite3_blob]) -> SQLite3Result:
        return self.lib.sqlite3_blob_close(pBlob)

    fn blob_bytes(self, pBlob: UnsafePointer[sqlite3_blob]) -> SQLite3Result:
        return self.lib.sqlite3_blob_bytes(pBlob)

    fn blob_read(self, pBlob: UnsafePointer[sqlite3_blob], Z: OpaquePointer, N: c_int, iOffset: c_int) -> SQLite3Result:
        return self.lib.sqlite3_blob_read(pBlob, Z, N, iOffset)

    fn blob_write(
        self, pBlob: UnsafePointer[sqlite3_blob], z: OpaquePointer, n: c_int, iOffset: c_int
    ) -> SQLite3Result:
        return self.lib.sqlite3_blob_write(pBlob, z, n, iOffset)

    fn vfs_find(self, zVfsName: UnsafePointer[c_char, mut=False]) -> UnsafePointer[sqlite3_vfs]:
        return self.lib.sqlite3_vfs_find(zVfsName)

    fn vfs_register(self, pVfs: UnsafePointer[sqlite3_vfs], makeDflt: c_int) -> SQLite3Result:
        return self.lib.sqlite3_vfs_register(pVfs, makeDflt)

    fn vfs_unregister(self, pVfs: UnsafePointer[sqlite3_vfs]) -> SQLite3Result:
        return self.lib.sqlite3_vfs_unregister(pVfs)

    fn mutex_alloc(self, id: c_int) -> UnsafePointer[sqlite3_mutex]:
        return self.lib.sqlite3_mutex_alloc(id)

    fn mutex_free(self, pMutex: UnsafePointer[sqlite3_mutex]):
        self.lib.sqlite3_mutex_free(pMutex)

    fn mutex_enter(self, pMutex: UnsafePointer[sqlite3_mutex]):
        self.lib.sqlite3_mutex_enter(pMutex)

    fn mutex_try(self, pMutex: UnsafePointer[sqlite3_mutex]) -> SQLite3Result:
        return self.lib.sqlite3_mutex_try(pMutex)

    fn mutex_leave(self, pMutex: UnsafePointer[sqlite3_mutex]):
        self.lib.sqlite3_mutex_leave(pMutex)

    fn mutex_held(self, pMutex: UnsafePointer[sqlite3_mutex]) -> SQLite3Result:
        return self.lib.sqlite3_mutex_held(pMutex)

    fn mutex_notheld(self, pMutex: UnsafePointer[sqlite3_mutex]) -> SQLite3Result:
        return self.lib.sqlite3_mutex_notheld(pMutex)

    fn db_mutex(self, db: UnsafePointer[sqlite3_connection]) -> UnsafePointer[sqlite3_mutex]:
        return self.lib.sqlite3_db_mutex(db)

    fn file_control(
        self,
        db: UnsafePointer[sqlite3_connection],
        zDbName: UnsafePointer[c_char, mut=False],
        op: c_int,
        pArg: OpaquePointer,
    ) -> SQLite3Result:
        return self.lib.sqlite3_file_control(db, zDbName, op, pArg)

    fn test_control(self, op: c_int) -> SQLite3Result:
        return self.lib.sqlite3_test_control(op)

    fn keyword_count(self) -> SQLite3Result:
        return self.lib.sqlite3_keyword_count()

    fn keyword_name(
        self, idx: c_int, pzName: UnsafePointer[UnsafePointer[c_char, mut=False]], pnName: UnsafePointer[c_int]
    ) -> SQLite3Result:
        return self.lib.sqlite3_keyword_name(idx, pzName, pnName)

    fn keyword_check(self, zName: UnsafePointer[c_char, mut=False], nName: c_int) -> SQLite3Result:
        return self.lib.sqlite3_keyword_check(zName, nName)

    fn str_new(self, db: UnsafePointer[sqlite3_connection]) -> UnsafePointer[sqlite3_str]:
        return self.lib.sqlite3_str_new(db)

    fn str_finish(self, pStr: UnsafePointer[sqlite3_str]) -> StringSlice[ImmutableAnyOrigin]:
        return StringSlice(unsafe_from_utf8_ptr=self.lib.sqlite3_str_finish(pStr))

    fn str_appendf(self, pStr: UnsafePointer[sqlite3_str], zFormat: UnsafePointer[c_char, mut=False]):
        self.lib.sqlite3_str_appendf(pStr, zFormat)

    fn str_append(self, pStr: UnsafePointer[sqlite3_str], zIn: UnsafePointer[c_char, mut=False], N: c_int):
        self.lib.sqlite3_str_append(pStr, zIn, N)

    fn str_appendall(self, pStr: UnsafePointer[sqlite3_str], zIn: UnsafePointer[c_char, mut=False]):
        self.lib.sqlite3_str_appendall(pStr, zIn)

    fn str_appendchar(self, pStr: UnsafePointer[sqlite3_str], N: c_int, C: Int8):
        self.lib.sqlite3_str_appendchar(pStr, N, C)

    fn str_reset(self, pStr: UnsafePointer[sqlite3_str]):
        self.lib.sqlite3_str_reset(pStr)

    fn str_errcode(self, pStr: UnsafePointer[sqlite3_str]) -> SQLite3Result:
        return self.lib.sqlite3_str_errcode(pStr)

    fn str_length(self, pStr: UnsafePointer[sqlite3_str]) -> SQLite3Result:
        return self.lib.sqlite3_str_length(pStr)

    fn str_value(self, pStr: UnsafePointer[sqlite3_str]) -> StringSlice[ImmutableAnyOrigin]:
        return StringSlice(unsafe_from_utf8_ptr=self.lib.sqlite3_str_value(pStr))

    fn backup_init(
        self,
        pDest: UnsafePointer[sqlite3_connection],
        zDestName: UnsafePointer[c_char, mut=False],
        pSource: UnsafePointer[sqlite3_connection],
        zSourceName: UnsafePointer[c_char, mut=False],
    ) -> UnsafePointer[sqlite3_backup]:
        return self.lib.sqlite3_backup_init(pDest, zDestName, pSource, zSourceName)

    fn backup_step(self, p: UnsafePointer[sqlite3_backup], nPage: c_int) -> SQLite3Result:
        return self.lib.sqlite3_backup_step(p, nPage)

    fn backup_finish(self, p: UnsafePointer[sqlite3_backup]) -> SQLite3Result:
        return self.lib.sqlite3_backup_finish(p)

    fn backup_remaining(self, p: UnsafePointer[sqlite3_backup]) -> SQLite3Result:
        return self.lib.sqlite3_backup_remaining(p)

    fn backup_pagecount(self, p: UnsafePointer[sqlite3_backup]) -> SQLite3Result:
        return self.lib.sqlite3_backup_pagecount(p)

    fn unlock_notify(
        self,
        pBlocked: UnsafePointer[sqlite3_connection],
        xNotify: fn (UnsafePointer[OpaquePointer], c_int) -> NoneType,
        pNotifyArg: OpaquePointer,
    ) -> SQLite3Result:
        return self.lib.sqlite3_unlock_notify(pBlocked, xNotify, pNotifyArg)

    fn stricmp(self, str1: UnsafePointer[c_char, mut=False], str2: UnsafePointer[c_char, mut=False]) -> SQLite3Result:
        return self.lib.sqlite3_stricmp(str1, str2)

    fn strnicmp(
        self, str1: UnsafePointer[c_char, mut=False], str2: UnsafePointer[c_char, mut=False], n: c_int
    ) -> SQLite3Result:
        return self.lib.sqlite3_strnicmp(str1, str2, n)

    fn strglob(self, zGlob: UnsafePointer[c_char, mut=False], zStr: UnsafePointer[c_char, mut=False]) -> SQLite3Result:
        return self.lib.sqlite3_strglob(zGlob, zStr)

    fn strlike(
        self, zGlob: UnsafePointer[c_char, mut=False], zStr: UnsafePointer[c_char, mut=False], cEsc: UInt32
    ) -> SQLite3Result:
        return self.lib.sqlite3_strlike(zGlob, zStr, cEsc)

    fn log(self, iErrCode: c_int, zFormat: UnsafePointer[c_char, mut=False]):
        self.lib.sqlite3_log(iErrCode, zFormat)

    fn wal_hook(
        self,
        db: UnsafePointer[sqlite3_connection],
        xCallback: fn (OpaquePointer, UnsafePointer[sqlite3_connection], UnsafePointer[c_char], c_int) -> c_int,
        pArg: OpaquePointer,
    ) -> OpaquePointer:
        return self.lib.sqlite3_wal_hook(db, xCallback, pArg)

    fn wal_autocheckpoint(self, db: UnsafePointer[sqlite3_connection], N: c_int) -> SQLite3Result:
        return self.lib.sqlite3_wal_autocheckpoint(db, N)

    fn wal_checkpoint(
        self, db: UnsafePointer[sqlite3_connection], zDb: UnsafePointer[c_char, mut=False]
    ) -> SQLite3Result:
        return self.lib.sqlite3_wal_checkpoint(db, zDb)

    fn wal_checkpoint_v2(
        self,
        db: UnsafePointer[sqlite3_connection],
        zDb: UnsafePointer[c_char, mut=False],
        eMode: c_int,
        pnLog: UnsafePointer[c_int],
        pnCkpt: UnsafePointer[c_int],
    ) -> SQLite3Result:
        return self.lib.sqlite3_wal_checkpoint_v2(db, zDb, eMode, pnLog, pnCkpt)

    fn vtab_config(self, db: UnsafePointer[sqlite3_connection], op: c_int) -> SQLite3Result:
        return self.lib.sqlite3_vtab_config(db, op)

    fn vtab_on_conflict(self, db: UnsafePointer[sqlite3_connection]) -> SQLite3Result:
        return self.lib.sqlite3_vtab_on_conflict(db)

    fn vtab_nochange(self, ctx: UnsafePointer[sqlite3_context]) -> SQLite3Result:
        return self.lib.sqlite3_vtab_nochange(ctx)

    fn vtab_collation(
        self, pIdxInfo: UnsafePointer[sqlite3_index_info], iCons: c_int
    ) -> UnsafePointer[c_char, mut=False]:
        return self.lib.sqlite3_vtab_collation(pIdxInfo, iCons)

    fn vtab_distinct(self, pIdxInfo: UnsafePointer[sqlite3_index_info]) -> SQLite3Result:
        return self.lib.sqlite3_vtab_distinct(pIdxInfo)

    fn vtab_in(self, pIdxInfo: UnsafePointer[sqlite3_index_info], iCons: c_int, bHandle: c_int) -> SQLite3Result:
        return self.lib.sqlite3_vtab_in(pIdxInfo, iCons, bHandle)

    fn vtab_in_first(
        self, pVal: UnsafePointer[sqlite3_value], ppOut: UnsafePointer[UnsafePointer[sqlite3_value]]
    ) -> SQLite3Result:
        return self.lib.sqlite3_vtab_in_first(pVal, ppOut)

    fn vtab_in_next(
        self, pVal: UnsafePointer[sqlite3_value], ppOut: UnsafePointer[UnsafePointer[sqlite3_value]]
    ) -> SQLite3Result:
        return self.lib.sqlite3_vtab_in_next(pVal, ppOut)

    fn vtab_rhs_value(
        self,
        pIdxInfo: UnsafePointer[sqlite3_index_info],
        iCons: c_int,
        ppVal: UnsafePointer[UnsafePointer[sqlite3_value]],
    ) -> SQLite3Result:
        return self.lib.sqlite3_vtab_rhs_value(pIdxInfo, iCons, ppVal)

    fn stmt_scanstatus_v2(
        self, pStmt: UnsafePointer[sqlite3_stmt], idx: c_int, iScanStatusOp: c_int, flags: c_int, pOut: OpaquePointer
    ) -> SQLite3Result:
        return self.lib.sqlite3_stmt_scanstatus_v2(pStmt, idx, iScanStatusOp, flags, pOut)

    fn db_cacheflush(self, db: UnsafePointer[sqlite3_connection]) -> SQLite3Result:
        return self.lib.sqlite3_db_cacheflush(db)

    fn system_errno(self, db: UnsafePointer[sqlite3_connection]) -> SQLite3Result:
        return self.lib.sqlite3_system_errno(db)

    fn snapshot_get(
        self,
        db: UnsafePointer[sqlite3_connection],
        zSchema: UnsafePointer[c_char, mut=False],
        ppSnapshot: UnsafePointer[UnsafePointer[sqlite3_snapshot]],
    ) -> SQLite3Result:
        return self.lib.sqlite3_snapshot_get(db, zSchema, ppSnapshot)

    fn snapshot_open(
        self,
        db: UnsafePointer[sqlite3_connection],
        zSchema: UnsafePointer[c_char, mut=False],
        pSnapshot: UnsafePointer[sqlite3_snapshot],
    ) -> SQLite3Result:
        return self.lib.sqlite3_snapshot_open(db, zSchema, pSnapshot)

    fn snapshot_free(self, pSnapshot: UnsafePointer[sqlite3_snapshot]):
        self.lib.sqlite3_snapshot_free(pSnapshot)

    fn snapshot_cmp(self, p1: UnsafePointer[sqlite3_snapshot], p2: UnsafePointer[sqlite3_snapshot]) -> SQLite3Result:
        return self.lib.sqlite3_snapshot_cmp(p1, p2)

    fn snapshot_recover(
        self, db: UnsafePointer[sqlite3_connection], zDb: UnsafePointer[c_char, mut=False]
    ) -> SQLite3Result:
        return self.lib.sqlite3_snapshot_recover(db, zDb)

    fn serialize(
        self,
        db: UnsafePointer[sqlite3_connection],
        zSchema: UnsafePointer[c_char, mut=False],
        piSize: UnsafePointer[sqlite3_int64],
        mFlags: UInt32,
    ) -> UnsafePointer[UInt8]:
        return self.lib.sqlite3_serialize(db, zSchema, piSize, mFlags)

    fn deserialize(
        self,
        db: UnsafePointer[sqlite3_connection],
        zSchema: UnsafePointer[c_char, mut=False],
        pData: UnsafePointer[UInt8],
        szDb: sqlite3_int64,
        szBuf: sqlite3_int64,
        mFlags: UInt32,
    ) -> SQLite3Result:
        return self.lib.sqlite3_deserialize(db, zSchema, pData, szDb, szBuf, mFlags)
