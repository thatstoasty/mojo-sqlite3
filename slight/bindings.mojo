from slight.c.raw_bindings import _sqlite3, ExecCallbackFn
from slight.result import SQLite3Result
from pathlib import Path
from sys.ffi import DLHandle, c_char, c_int, c_uint, c_uchar

from memory import OpaqueMutPointer, UnsafeMutPointer
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

    fn open[origin: MutOrigin](self, var path: String, out_database: ExternalMutPointer[sqlite3_connection]) -> SQLite3Result:
        """Open a connection to a SQLite database file.

        This method opens a database connection to a SQLite database file.
        It's a direct binding to the sqlite3_open() C function.

        Args:
            path: Path to the database file to open or create.
            out_database: Output pointer that will be set to point to the database connection.

        Returns:
            SQLITE_OK on success, or an error code on failure.
        """
        return self.lib.sqlite3_open(path.unsafe_cstr_ptr(), UnsafePointerV2(to=out_database))

    fn version(self) -> StringSlice[ImmutableAnyOrigin]:
        """Get the SQLite library version string.

        Returns a pointer to a string containing the version of the SQLite
        library that is running. This corresponds to the SQLITE_VERSION
        string.

        Returns:
            StringSlice containing the SQLite version.
        """
        return StringSlice(unsafe_from_utf8_ptr=self.lib.sqlite3_libversion()).get_immutable()

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

    fn test_compilation_option(self, zOptName: UnsafeImmutPointer[c_char]) -> SQLite3Result:
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

    fn get_compilation_option(self, N: c_int) -> StringSlice[ImmutableAnyOrigin]:
        """Get the N-th compile-time option.

        Allows iterating over the list of options that were defined at
        compile time. If N is out of range, returns a NULL pointer.
        The SQLITE_ prefix is omitted from any strings returned.

        Args:
            N: Index of the compile-time option to retrieve (0-based).

        Returns:
            Pointer to the N-th compile option string, or NULL if N is out of range.
        """
        return StringSlice(unsafe_from_utf8_ptr=self.lib.sqlite3_compileoption_get(N))

    fn test_thread_safety(self) -> SQLite3Result:
        """Test if the library is threadsafe.

        Returns zero if and only if SQLite was compiled with mutexing code
        omitted due to the SQLITE_THREADSAFE compile-time option being set to 0.

        Returns:
            Non-zero if SQLite is threadsafe, 0 if not threadsafe.
        """
        return self.lib.sqlite3_threadsafe()

    fn close(self, connection: ExternalMutPointer[sqlite3_connection]) -> SQLite3Result:
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

    fn close_v2(self, connection: ExternalMutPointer[sqlite3_connection]) -> SQLite3Result:
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

    fn exec[origin: MutOrigin](
        self,
        db: ExternalMutPointer[sqlite3_connection],
        sql: UnsafeImmutPointer[c_char],
        callback: UnsafeMutPointer[ExecCallbackFn],
        pArg: OpaqueMutPointer,
        pErrMsg: UnsafeMutPointer[UnsafeMutPointer[c_char, origin]],
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

    fn configure_database_connection(self, db: ExternalMutPointer[sqlite3_connection], op: c_int) -> SQLite3Result:
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

    fn extended_result_codes(self, db: ExternalMutPointer[sqlite3_connection], onoff: c_int) -> SQLite3Result:
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

    fn last_insert_rowid(self, db: ExternalMutPointer[sqlite3_connection]) -> sqlite3_int64:
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

    fn set_last_insert_rowid(self, db: ExternalMutPointer[sqlite3_connection], rowid: sqlite3_int64):
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

    fn changes(self, db: ExternalMutPointer[sqlite3_connection]) -> Int32:
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

    fn changes64(self, db: ExternalMutPointer[sqlite3_connection]) -> sqlite3_int64:
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

    fn total_changes(self, db: ExternalMutPointer[sqlite3_connection]) -> SQLite3Result:
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

    fn total_changes64(self, db: ExternalMutPointer[sqlite3_connection]) -> sqlite3_int64:
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

    fn interrupt(self, db: ExternalMutPointer[sqlite3_connection]) -> None:
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

    fn is_interrupted(self, db: ExternalMutPointer[sqlite3_connection]) -> SQLite3Result:
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

    fn complete(self, sql: UnsafeImmutPointer[c_char]) -> SQLite3Result:
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

    fn busy_handler[origin: MutOrigin](
        self, db: ExternalMutPointer[sqlite3_connection], callback: fn (OpaqueMutPointer[origin], c_int) -> c_int, arg: OpaqueMutPointer
    ) -> SQLite3Result:
        return self.lib.sqlite3_busy_handler(db, callback, arg)

    fn busy_timeout(self, db: ExternalMutPointer[sqlite3_connection], ms: c_int) -> SQLite3Result:
        return self.lib.sqlite3_busy_timeout(db, ms)

    fn setlk_timeout(self, db: ExternalMutPointer[sqlite3_connection], ms: c_int, flags: c_int) -> SQLite3Result:
        return self.lib.sqlite3_setlk_timeout(db, ms, flags)

    fn get_table[origin: MutOrigin, origin2: MutOrigin, origin3: MutOrigin](
        self,
        db: ExternalMutPointer[sqlite3_connection],
        sql: UnsafeImmutPointer[c_char],
        pazResult: UnsafeMutPointer[UnsafeMutPointer[UnsafeMutPointer[c_char, origin], origin2]],
        pnRow: UnsafeMutPointer[c_int],
        pnColumn: UnsafeMutPointer[c_int],
        pzErrmsg: UnsafeMutPointer[UnsafeMutPointer[c_char, origin3]],
    ) -> SQLite3Result:
        return self.lib.sqlite3_get_table(db, sql, pazResult, pnRow, pnColumn, pzErrmsg)

    fn free_table[origin: MutOrigin](self, result: UnsafeMutPointer[UnsafeMutPointer[c_char, origin]]):
        self.lib.sqlite3_free_table(result)

    fn mprintf(self, format: UnsafeImmutPointer[c_char]) -> StringSlice[ImmutableAnyOrigin]:
        return StringSlice(unsafe_from_utf8_ptr=self.lib.sqlite3_mprintf(format))

    fn snprintf(
        self, n: c_int, str: UnsafeMutPointer[c_char], format: UnsafeImmutPointer[c_char]
    ) -> StringSlice[ImmutableAnyOrigin]:
        return StringSlice(unsafe_from_utf8_ptr=self.lib.sqlite3_snprintf(n, str, format))

    # fn vmprintf(self):
    #     return self.lib.[fn(UnsafeImmutPointer[c_char], va_list) -> ExternalMutPointer[c_char]]sqlite3_vmprintf()

    # fn vsnprintf(self):
    #     return self.lib.[fn(c_int, UnsafeMutPointer[c_char], UnsafeImmutPointer[c_char], va_list) -> ExternalMutPointer[c_char]]sqlite3_vsnprintf()

    fn malloc(self, size: c_int) -> OpaqueMutPointer:
        return self.lib.sqlite3_malloc(size)

    fn malloc64(self, size: sqlite3_uint64) -> OpaqueMutPointer:
        return self.lib.sqlite3_malloc64(size)

    fn realloc(self, ptr: OpaqueMutPointer, size: c_int) -> OpaqueMutPointer:
        return self.lib.sqlite3_realloc(ptr, size)

    fn realloc64(self, ptr: OpaqueMutPointer, size: sqlite3_uint64) -> OpaqueMutPointer:
        return self.lib.sqlite3_realloc64(ptr, size)

    fn free(self, ptr: OpaqueMutPointer):
        self.lib.sqlite3_free(ptr)

    fn msize(self, ptr: OpaqueMutPointer) -> sqlite3_uint64:
        return self.lib.sqlite3_msize(ptr)

    fn memory_used(self) -> sqlite3_int64:
        return self.lib.sqlite3_memory_used()

    fn memory_highwater(self, resetFlag: c_int) -> sqlite3_int64:
        return self.lib.sqlite3_memory_highwater(resetFlag)

    fn randomness(self, N: c_int, P: OpaqueMutPointer):
        self.lib.sqlite3_randomness(N, P)

    fn set_authorizer[origin: MutOrigin, origin2: ImmutOrigin, origin3: ImmutOrigin, origin4: ImmutOrigin, origin5: ImmutOrigin](
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
    ) -> SQLite3Result:
        return self.lib.sqlite3_set_authorizer(db, xAuth, pUserData)

    fn trace[origin: MutOrigin, origin2: ImmutOrigin](
        self,
        db: ExternalMutPointer[sqlite3_connection],
        xTrace: fn (OpaqueMutPointer[origin], UnsafeImmutPointer[c_char, origin2]) -> NoneType,
        pArg: OpaqueMutPointer,
    ) -> OpaqueMutPointer:
        return self.lib.sqlite3_trace(db, xTrace, pArg)

    fn profile[origin: MutOrigin, origin2: ImmutOrigin](
        self,
        db: ExternalMutPointer[sqlite3_connection],
        xProfile: fn (OpaqueMutPointer[origin], UnsafeImmutPointer[c_char, origin2], sqlite3_uint64) -> NoneType,
        pArg: OpaqueMutPointer,
    ) -> OpaqueMutPointer:
        return self.lib.sqlite3_profile(db, xProfile, pArg)

    fn trace_v2[origin: MutOrigin, origin2: MutOrigin, origin3: MutOrigin](
        self,
        db: ExternalMutPointer[sqlite3_connection],
        uMask: UInt32,
        xCallback: fn (UInt32, OpaqueMutPointer[origin], OpaqueMutPointer[origin2], OpaqueMutPointer[origin3]) -> c_int,
        pCtx: OpaqueMutPointer,
    ) -> SQLite3Result:
        return self.lib.sqlite3_trace_v2(db, uMask, xCallback, pCtx)

    fn progress_handler[origin: MutOrigin](
        self,
        db: ExternalMutPointer[sqlite3_connection],
        nOps: c_int,
        xProgress: fn (OpaqueMutPointer[origin]) -> c_int,
        pArg: OpaqueMutPointer,
    ):
        self.lib.sqlite3_progress_handler(db, nOps, xProgress, pArg)

    fn open(
        self, filename: UnsafeImmutPointer[c_char], ppDb: UnsafeMutPointer[ExternalMutPointer[sqlite3_connection]]
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

    fn open_v2(
        self,
        filename: UnsafeImmutPointer[c_char],
        ppDb: UnsafeMutPointer[ExternalMutPointer[sqlite3_connection]],
        flags: c_int,
        zVfs: UnsafeImmutPointer[c_char],
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
        self, z: sqlite3_filename, zParam: UnsafeImmutPointer[c_char]
    ) -> StringSlice[ImmutableAnyOrigin]:
        return StringSlice(unsafe_from_utf8_ptr=self.lib.sqlite3_uri_parameter(z, zParam))

    fn uri_boolean(
        self, z: sqlite3_filename, zParam: UnsafeImmutPointer[c_char], bDefault: c_int
    ) -> Bool:
        return Bool(self.lib.sqlite3_uri_boolean(z, zParam, bDefault))

    fn uri_int64(
        self, z: sqlite3_filename, zParam: UnsafeImmutPointer[c_char], dflt: sqlite3_int64
    ) -> sqlite3_int64:
        return self.lib.sqlite3_uri_int64(z, zParam, dflt)

    fn uri_key(self, z: sqlite3_filename, N: c_int) -> StringSlice[ImmutableAnyOrigin]:
        return StringSlice(unsafe_from_utf8_ptr=self.lib.sqlite3_uri_key(z, N))

    fn filename_database(self, z: sqlite3_filename) -> StringSlice[ImmutableAnyOrigin]:
        return StringSlice(unsafe_from_utf8_ptr=self.lib.sqlite3_filename_database(z))

    fn filename_journal(self, z: sqlite3_filename) -> StringSlice[ImmutableAnyOrigin]:
        return StringSlice(unsafe_from_utf8_ptr=self.lib.sqlite3_filename_journal(z))

    fn filename_wal(self, z: sqlite3_filename) -> StringSlice[ImmutableAnyOrigin]:
        return StringSlice(unsafe_from_utf8_ptr=self.lib.sqlite3_filename_wal(z))

    fn database_file_object(self, z: UnsafeImmutPointer[c_char]) -> ExternalMutPointer[sqlite3_file]:
        return self.lib.sqlite3_database_file_object(z)

    fn create_filename[origin: ImmutOrigin](
        self,
        zDatabase: UnsafeImmutPointer[c_char],
        zJournal: UnsafeImmutPointer[c_char],
        zWal: UnsafeImmutPointer[c_char],
        nParam: c_int,
        azParam: UnsafeMutPointer[UnsafeImmutPointer[c_char, origin]],
    ) -> sqlite3_filename:
        return self.lib.sqlite3_create_filename(zDatabase, zJournal, zWal, nParam, azParam)

    fn free_filename(self, z: sqlite3_filename):
        self.lib.sqlite3_free_filename(z)

    fn errcode(self, db: ExternalMutPointer[sqlite3_connection]) -> SQLite3Result:
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

    fn extended_errcode(self, db: ExternalMutPointer[sqlite3_connection]) -> SQLite3Result:
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

    fn errmsg(self, db: ExternalMutPointer[sqlite3_connection]) -> Optional[StringSlice[ImmutableAnyOrigin]]:
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
        var ptr = self.lib.sqlite3_errmsg(db)
        if not ptr:
            return None
        return StringSlice(unsafe_from_utf8_ptr=ptr).get_immutable()

    fn errstr(self, e: c_int) -> Optional[StringSlice[ImmutableAnyOrigin]]:
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
        var ptr = self.lib.sqlite3_errstr(e)
        if not ptr:
            return None
        return StringSlice(unsafe_from_utf8_ptr=ptr).get_immutable()

    fn error_offset(self, db: ExternalMutPointer[sqlite3_connection]) -> SQLite3Result:
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

    fn limit(self, db: ExternalMutPointer[sqlite3_connection], id: c_int, newVal: c_int) -> SQLite3Result:
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

    fn prepare[origin: MutOrigin, origin2: ImmutOrigin](
        self,
        db: ExternalMutPointer[sqlite3_connection],
        zSql: UnsafeImmutPointer[c_char],
        nByte: c_int,
        ppStmt: UnsafeMutPointer[UnsafeMutPointer[sqlite3_stmt, origin]],
        pzTail: UnsafeMutPointer[UnsafeImmutPointer[c_char, origin2]],
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

    fn prepare_v2[origin: MutOrigin, origin2: ImmutOrigin](
        self,
        db: ExternalMutPointer[sqlite3_connection],
        zSql: UnsafeImmutPointer[c_char],
        nByte: c_int,
        ppStmt: UnsafeMutPointer[UnsafeMutPointer[sqlite3_stmt, origin]],
        pzTail: UnsafeMutPointer[UnsafeImmutPointer[c_char, origin2]],
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

    # TODO: When unsafe_cstr_ptr returns an UnsafePointerV2, update pzTail type
    fn prepare_v3[sql: ImmutOrigin, tail: MutOrigin](
        self,
        db: ExternalMutPointer[sqlite3_connection],
        zSql: UnsafeImmutPointer[c_char, sql],
        nByte: c_int,
        prepFlags: UInt32,
        mut ppStmt: ExternalMutPointer[sqlite3_stmt],
        pzTail: UnsafeMutPointer[UnsafePointer[c_char, mut=False, origin=sql], tail],
    ) -> SQLite3Result:
        return self.lib.sqlite3_prepare_v3(db, zSql, nByte, prepFlags, UnsafePointerV2(to=ppStmt), pzTail)

    fn sql(self, pStmt: UnsafeMutPointer[sqlite3_stmt]) -> StringSlice[ImmutableAnyOrigin]:
        """Retrieve the SQL text of a prepared statement.

        Returns a pointer to a copy of the UTF-8 SQL text used to create the
        prepared statement if that statement was compiled using sqlite3_prepare_v2()
        or its variants.

        Args:
            pStmt: Pointer to the prepared statement.

        Returns:
            Pointer to the SQL text used to create the statement.
        """
        return StringSlice(unsafe_from_utf8_ptr=self.lib.sqlite3_sql(pStmt))

    fn expanded_sql(self, pStmt: UnsafeMutPointer[sqlite3_stmt]) -> SQLiteMallocString:
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

    fn stmt_readonly(self, pStmt: UnsafeMutPointer[sqlite3_stmt]) -> SQLite3Result:
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

    fn stmt_isexplain(self, pStmt: UnsafeMutPointer[sqlite3_stmt]) -> c_int:
        return self.lib.sqlite3_stmt_isexplain(pStmt)

    fn stmt_explain(self, pStmt: UnsafeMutPointer[sqlite3_stmt], eMode: c_int) -> SQLite3Result:
        return self.lib.sqlite3_stmt_explain(pStmt, eMode)

    fn stmt_busy(self, pStmt: UnsafeMutPointer[sqlite3_stmt]) -> SQLite3Result:
        return self.lib.sqlite3_stmt_busy(pStmt)

    fn bind_blob[origin: MutOrigin](
        self,
        pStmt: UnsafeMutPointer[sqlite3_stmt],
        idx: c_int,
        value: OpaqueImmutPointer,
        n: c_int,
        destructor: fn (OpaqueMutPointer[origin]) -> NoneType,
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

    fn bind_blob64[origin: MutOrigin](
        self,
        pStmt: UnsafeMutPointer[sqlite3_stmt],
        idx: c_int,
        value: OpaqueImmutPointer,
        n: sqlite3_uint64,
        destructor: fn (OpaqueMutPointer[origin]) -> NoneType,
    ) -> SQLite3Result:
        return self.lib.sqlite3_bind_blob64(pStmt, idx, value, n, destructor)

    fn bind_double(self, pStmt: UnsafeMutPointer[sqlite3_stmt], idx: c_int, value: Float64) -> SQLite3Result:
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

    fn bind_int(self, pStmt: UnsafeMutPointer[sqlite3_stmt], idx: c_int, value: c_int) -> SQLite3Result:
        return self.lib.sqlite3_bind_int(pStmt, idx, value)

    fn bind_int64(self, pStmt: UnsafeMutPointer[sqlite3_stmt], idx: c_int, value: sqlite3_int64) -> SQLite3Result:
        return self.lib.sqlite3_bind_int64(pStmt, idx, value)

    fn bind_null(self, pStmt: UnsafeMutPointer[sqlite3_stmt], idx: c_int) -> SQLite3Result:
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
        pStmt: UnsafeMutPointer[sqlite3_stmt],
        idx: c_int,
        value: UnsafeImmutPointer[c_char],
        n: c_int,
        destructor: sqlite3_destructor_type,
    ) -> SQLite3Result:
        return self.lib.sqlite3_bind_text(pStmt, idx, value, n, destructor)

    fn bind_text64[origin: MutOrigin](
        self,
        pStmt: UnsafeMutPointer[sqlite3_stmt],
        idx: c_int,
        value: UnsafeImmutPointer[c_char],
        n: sqlite3_uint64,
        destructor: fn (OpaqueMutPointer[origin]) -> NoneType,
        encoding: UInt8,
    ) -> SQLite3Result:
        return self.lib.sqlite3_bind_text64(pStmt, idx, value, n, destructor, encoding)

    fn bind_value(
        self, pStmt: UnsafeMutPointer[sqlite3_stmt], idx: c_int, value: UnsafeImmutPointer[sqlite3_value]
    ) -> SQLite3Result:
        return self.lib.sqlite3_bind_value(pStmt, idx, value)

    fn bind_pointer[origin: MutOrigin](
        self,
        pStmt: UnsafeMutPointer[sqlite3_stmt],
        idx: c_int,
        value: OpaqueMutPointer,
        typeStr: UnsafeImmutPointer[c_char],
        destructor: fn (OpaqueMutPointer[origin]) -> NoneType,
    ) -> SQLite3Result:
        return self.lib.sqlite3_bind_pointer(pStmt, idx, value, typeStr, destructor)

    fn bind_zeroblob(self, pStmt: UnsafeMutPointer[sqlite3_stmt], idx: c_int, n: c_int) -> SQLite3Result:
        return self.lib.sqlite3_bind_zeroblob(pStmt, idx, n)

    fn bind_zeroblob64(self, pStmt: UnsafeMutPointer[sqlite3_stmt], idx: c_int, n: sqlite3_uint64) -> SQLite3Result:
        return self.lib.sqlite3_bind_zeroblob64(pStmt, idx, n)

    fn bind_parameter_count(self, pStmt: UnsafeMutPointer[sqlite3_stmt]) -> c_int:
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

    fn bind_parameter_name(self, pStmt: UnsafeMutPointer[sqlite3_stmt], idx: c_int) -> StringSlice[ImmutableAnyOrigin]:
        return StringSlice(unsafe_from_utf8_ptr=self.lib.sqlite3_bind_parameter_name(pStmt, idx))

    fn bind_parameter_index(
        self, pStmt: UnsafeMutPointer[sqlite3_stmt], zName: UnsafeImmutPointer[c_char]
    ) -> c_int:
        return self.lib.sqlite3_bind_parameter_index(pStmt, zName)

    fn clear_bindings(self, pStmt: UnsafeMutPointer[sqlite3_stmt]) -> SQLite3Result:
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

    fn column_count(self, pStmt: UnsafeMutPointer[sqlite3_stmt]) -> c_int:
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

    fn column_name(self, pStmt: UnsafeMutPointer[sqlite3_stmt], N: c_int) -> Optional[StringSlice[ImmutableAnyOrigin]]:
        var ptr = self.lib.sqlite3_column_name(pStmt, N)
        if not ptr:
            return None
        
        return StringSlice(unsafe_from_utf8_ptr=ptr).get_immutable()

    fn column_database_name(self, pStmt: UnsafeMutPointer[sqlite3_stmt], idx: c_int) -> Optional[StringSlice[ImmutableAnyOrigin]]:
        var ptr = self.lib.sqlite3_column_database_name(pStmt, idx)
        if not ptr:
            return None

        return StringSlice(unsafe_from_utf8_ptr=ptr).get_immutable()

    fn column_table_name(self, pStmt: UnsafeMutPointer[sqlite3_stmt], idx: c_int) -> Optional[StringSlice[ImmutableAnyOrigin]]:
        var ptr = self.lib.sqlite3_column_table_name(pStmt, idx)
        if not ptr:
            return None

        return StringSlice(unsafe_from_utf8_ptr=ptr).get_immutable()

    fn column_origin_name(self, pStmt: UnsafeMutPointer[sqlite3_stmt], idx: c_int) -> Optional[StringSlice[ImmutableAnyOrigin]]:
        var ptr = self.lib.sqlite3_column_origin_name(pStmt, idx)
        if not ptr:
            return None

        return StringSlice(unsafe_from_utf8_ptr=ptr).get_immutable()

    fn column_decltype(self, pStmt: UnsafeMutPointer[sqlite3_stmt], idx: c_int) -> Optional[StringSlice[ImmutableAnyOrigin]]:
        var ptr = self.lib.sqlite3_column_decltype(pStmt, idx)
        if not ptr:
            return None

        return StringSlice(unsafe_from_utf8_ptr=ptr).get_immutable()

    fn step(self, pStmt: UnsafeMutPointer[sqlite3_stmt]) -> SQLite3Result:
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

    fn data_count(self, pStmt: UnsafeMutPointer[sqlite3_stmt]) -> SQLite3Result:
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

    fn column_blob(self, pStmt: UnsafeMutPointer[sqlite3_stmt], iCol: c_int) -> ExternalMutPointer[NoneType]:
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

    fn column_double(self, pStmt: UnsafeMutPointer[sqlite3_stmt], iCol: c_int) -> Float64:
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

    fn column_int(self, pStmt: UnsafeMutPointer[sqlite3_stmt], iCol: c_int) -> SQLite3Result:
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

    fn column_int64(self, pStmt: UnsafeMutPointer[sqlite3_stmt], iCol: c_int) -> sqlite3_int64:
        return self.lib.sqlite3_column_int64(pStmt, iCol)

    fn column_text(self, pStmt: UnsafeMutPointer[sqlite3_stmt], iCol: c_int) -> ExternalImmutPointer[c_uchar]:
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

    fn column_value(self, pStmt: UnsafeMutPointer[sqlite3_stmt], iCol: c_int) -> ExternalMutPointer[sqlite3_value]:
        return self.lib.sqlite3_column_value(pStmt, iCol)

    fn column_bytes(self, pStmt: UnsafeMutPointer[sqlite3_stmt], iCol: c_int) -> c_int:
        return self.lib.sqlite3_column_bytes(pStmt, iCol)

    fn column_type(self, pStmt: UnsafeMutPointer[sqlite3_stmt], iCol: c_int) -> c_int:
        return self.lib.sqlite3_column_type(pStmt, iCol)

    fn finalize(self, pStmt: UnsafeMutPointer[sqlite3_stmt]) -> SQLite3Result:
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

    fn reset(self, pStmt: UnsafeMutPointer[sqlite3_stmt]) -> SQLite3Result:
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

    fn create_function[origin: MutOrigin, origin2: MutOrigin, origin3: MutOrigin, origin4: MutOrigin, origin5: MutOrigin, origin6: MutOrigin, origin7: MutOrigin](
        self,
        db: ExternalMutPointer[sqlite3_connection],
        zFunctionName: UnsafeImmutPointer[c_char],
        nArg: c_int,
        eTextRep: c_int,
        pApp: OpaqueMutPointer,
        xFunc: fn (UnsafeMutPointer[sqlite3_context, origin], c_int, UnsafeMutPointer[UnsafeMutPointer[sqlite3_value, origin2], origin3]) -> NoneType,
        xStep: fn (UnsafeMutPointer[sqlite3_context, origin4], c_int, UnsafeMutPointer[UnsafeMutPointer[sqlite3_value, origin5], origin6]) -> NoneType,
        xFinal: fn (UnsafeMutPointer[sqlite3_context, origin7]) -> NoneType,
    ) -> SQLite3Result:
        return self.lib.sqlite3_create_function(db, zFunctionName, nArg, eTextRep, pApp, xFunc, xStep, xFinal)

    fn create_function_v2[origin: MutOrigin, origin2: MutOrigin, origin3: MutOrigin, origin4: MutOrigin, origin5: MutOrigin, origin6: MutOrigin, origin7: MutOrigin, origin8: MutOrigin](
        self,
        db: ExternalMutPointer[sqlite3_connection],
        zFunctionName: UnsafeImmutPointer[c_char],
        nArg: c_int,
        eTextRep: c_int,
        pApp: OpaqueMutPointer,
        xFunc: fn (UnsafeMutPointer[sqlite3_context, origin], c_int, UnsafeMutPointer[UnsafeMutPointer[sqlite3_value, origin2], origin3]) -> NoneType,
        xStep: fn (UnsafeMutPointer[sqlite3_context, origin4], c_int, UnsafeMutPointer[UnsafeMutPointer[sqlite3_value, origin5], origin6]) -> NoneType,
        xFinal: fn (UnsafeMutPointer[sqlite3_context, origin7]) -> NoneType,
        xDestroy: fn (OpaqueMutPointer[origin8]) -> NoneType,
    ) -> SQLite3Result:
        return self.lib.sqlite3_create_function_v2(
            db, zFunctionName, nArg, eTextRep, pApp, xFunc, xStep, xFinal, xDestroy
        )

    fn create_window_function[origin: MutOrigin, origin2: MutOrigin, origin3: MutOrigin, origin4: MutOrigin, origin5: MutOrigin, origin6: MutOrigin, origin7: MutOrigin, origin8: MutOrigin, origin9: MutOrigin](
        self,
        db: ExternalMutPointer[sqlite3_connection],
        zFunctionName: UnsafeImmutPointer[c_char],
        nArg: c_int,
        eTextRep: c_int,
        pApp: OpaqueMutPointer,
        xStep: fn (UnsafeMutPointer[sqlite3_context, origin], c_int, UnsafeMutPointer[UnsafeMutPointer[sqlite3_value, origin2], origin3]) -> NoneType,
        xFinal: fn (UnsafeMutPointer[sqlite3_context, origin4]) -> NoneType,
        xValue: fn (UnsafeMutPointer[sqlite3_context, origin5]) -> NoneType,
        xInverse: fn (UnsafeMutPointer[sqlite3_context, origin6], c_int, UnsafeMutPointer[UnsafeMutPointer[sqlite3_value, origin7], origin8]) -> NoneType,
        xDestroy: fn (OpaqueMutPointer[origin9]) -> NoneType,
    ) -> SQLite3Result:
        return self.lib.sqlite3_create_window_function(
            db, zFunctionName, nArg, eTextRep, pApp, xStep, xFinal, xValue, xInverse, xDestroy
        )

    fn aggregate_count(self, ctx: UnsafeMutPointer[sqlite3_context]) -> SQLite3Result:
        return self.lib.sqlite3_aggregate_count(ctx)

    fn expired(self, pStmt: UnsafeMutPointer[sqlite3_stmt]) -> SQLite3Result:
        return self.lib.sqlite3_expired(pStmt)

    fn transfer_bindings(
        self, fromStmt: UnsafeMutPointer[sqlite3_stmt], toStmt: UnsafeMutPointer[sqlite3_stmt]
    ) -> SQLite3Result:
        return self.lib.sqlite3_transfer_bindings(fromStmt, toStmt)

    fn global_recover(self) -> SQLite3Result:
        return self.lib.sqlite3_global_recover()

    fn thread_cleanup(self):
        self.lib.sqlite3_thread_cleanup()

    fn memory_alarm[origin: MutOrigin](
        self, callback: fn (OpaqueMutPointer[origin], sqlite3_int64, c_int) -> NoneType, arg: OpaqueMutPointer[origin], n: sqlite3_int64
    ) -> SQLite3Result:
        return self.lib.sqlite3_memory_alarm(callback, arg, n)

    fn value_blob(self, value: UnsafeMutPointer[sqlite3_value]) -> OpaqueMutPointer:
        return self.lib.sqlite3_value_blob(value)

    fn value_double(self, value: UnsafeMutPointer[sqlite3_value]) -> Float64:
        return self.lib.sqlite3_value_double(value)

    fn value_int(self, value: UnsafeMutPointer[sqlite3_value]) -> SQLite3Result:
        return self.lib.sqlite3_value_int(value)

    fn value_int64(self, value: UnsafeMutPointer[sqlite3_value]) -> sqlite3_int64:
        return self.lib.sqlite3_value_int64(value)

    fn value_pointer(
        self, value: UnsafeMutPointer[sqlite3_value], typeStr: UnsafeImmutPointer[c_char]
    ) -> OpaqueMutPointer:
        return self.lib.sqlite3_value_pointer(value, typeStr)

    fn value_text(self, value: UnsafeMutPointer[sqlite3_value]) -> StringSlice[ImmutableAnyOrigin]:
        return StringSlice(unsafe_from_utf8_ptr=self.lib.sqlite3_value_text(value))

    fn value_bytes(self, value: UnsafeMutPointer[sqlite3_value]) -> SQLite3Result:
        return self.lib.sqlite3_value_bytes(value)

    fn value_type(self, value: UnsafeMutPointer[sqlite3_value]) -> SQLite3Result:
        return self.lib.sqlite3_value_type(value)

    fn value_numeric_type(self, value: UnsafeMutPointer[sqlite3_value]) -> SQLite3Result:
        return self.lib.sqlite3_value_numeric_type(value)

    fn value_nochange(self, value: UnsafeMutPointer[sqlite3_value]) -> SQLite3Result:
        return self.lib.sqlite3_value_nochange(value)

    fn value_frombind(self, value: UnsafeMutPointer[sqlite3_value]) -> SQLite3Result:
        return self.lib.sqlite3_value_frombind(value)

    fn value_encoding(self, value: UnsafeMutPointer[sqlite3_value]) -> SQLite3Result:
        return self.lib.sqlite3_value_encoding(value)

    fn value_subtype(self, value: UnsafeMutPointer[sqlite3_value]) -> UInt32:
        return self.lib.sqlite3_value_subtype(value)

    fn value_dup(self, value: UnsafeImmutPointer[sqlite3_value]) -> ExternalMutPointer[sqlite3_value]:
        return self.lib.sqlite3_value_dup(value)

    fn value_free(self, value: UnsafeMutPointer[sqlite3_value]):
        self.lib.sqlite3_value_free(value)

    fn aggregate_context(self, ctx: UnsafeMutPointer[sqlite3_context], nBytes: c_int) -> OpaqueMutPointer:
        return self.lib.sqlite3_aggregate_context(ctx, nBytes)

    fn user_data(self, ctx: UnsafeMutPointer[sqlite3_context]) -> OpaqueMutPointer:
        return self.lib.sqlite3_user_data(ctx)

    fn context_db_handle(self, ctx: UnsafeMutPointer[sqlite3_context]) -> ExternalMutPointer[sqlite3_connection]:
        return self.lib.sqlite3_context_db_handle(ctx)

    fn get_auxdata(self, ctx: UnsafeMutPointer[sqlite3_context], N: c_int) -> OpaqueMutPointer:
        return self.lib.sqlite3_get_auxdata(ctx, N)

    fn set_auxdata[origin: MutOrigin](
        self,
        ctx: UnsafeMutPointer[sqlite3_context],
        N: c_int,
        data: OpaqueMutPointer,
        destructor: fn (OpaqueMutPointer[origin]) -> NoneType,
    ):
        self.lib.sqlite3_set_auxdata(ctx, N, data, destructor)

    fn get_clientdata(
        self, db: ExternalMutPointer[sqlite3_connection], key: UnsafeImmutPointer[c_char]
    ) -> OpaqueMutPointer:
        return self.lib.sqlite3_get_clientdata(db, key)

    fn set_clientdata[origin: MutOrigin](
        self,
        db: ExternalMutPointer[sqlite3_connection],
        key: UnsafeImmutPointer[c_char],
        data: OpaqueMutPointer,
        destructor: fn (OpaqueMutPointer[origin]) -> NoneType,
    ) -> SQLite3Result:
        return self.lib.sqlite3_set_clientdata(db, key, data, destructor)

    fn result_blob[origin: MutOrigin](
        self,
        ctx: UnsafeMutPointer[sqlite3_context],
        value: OpaqueMutPointer,
        n: c_int,
        destructor: fn (OpaqueMutPointer[origin]) -> NoneType,
    ):
        self.lib.sqlite3_result_blob(ctx, value, n, destructor)

    fn result_blob64[origin: MutOrigin](
        self,
        ctx: UnsafeMutPointer[sqlite3_context],
        value: OpaqueMutPointer,
        n: sqlite3_uint64,
        destructor: fn (OpaqueMutPointer[origin]) -> NoneType,
    ):
        self.lib.sqlite3_result_blob64(ctx, value, n, destructor)

    fn result_double(self, ctx: UnsafeMutPointer[sqlite3_context], value: Float64):
        self.lib.sqlite3_result_double(ctx, value)

    fn result_error(self, ctx: UnsafeMutPointer[sqlite3_context], msg: UnsafeImmutPointer[c_char], n: c_int):
        self.lib.sqlite3_result_error(ctx, msg, n)

    fn result_error_toobig(self, ctx: UnsafeMutPointer[sqlite3_context]):
        self.lib.sqlite3_result_error_toobig(ctx)

    fn result_error_nomem(self, ctx: UnsafeMutPointer[sqlite3_context]):
        self.lib.sqlite3_result_error_nomem(ctx)

    fn result_error_code(self, ctx: UnsafeMutPointer[sqlite3_context], code: c_int):
        self.lib.sqlite3_result_error_code(ctx, code)

    fn result_int(self, ctx: UnsafeMutPointer[sqlite3_context], value: c_int):
        self.lib.sqlite3_result_int(ctx, value)

    fn result_int64(self, ctx: UnsafeMutPointer[sqlite3_context], value: sqlite3_int64):
        self.lib.sqlite3_result_int64(ctx, value)

    fn result_null(self, ctx: UnsafeMutPointer[sqlite3_context]):
        self.lib.sqlite3_result_null(ctx)

    fn result_text[origin: MutOrigin](
        self,
        ctx: UnsafeMutPointer[sqlite3_context],
        value: UnsafeImmutPointer[c_char],
        n: c_int,
        destructor: fn (OpaqueMutPointer[origin]) -> NoneType,
    ):
        self.lib.sqlite3_result_text(ctx, value, n, destructor)

    fn result_text64[origin: MutOrigin](
        self,
        ctx: UnsafeMutPointer[sqlite3_context],
        value: UnsafeImmutPointer[c_char],
        n: sqlite3_uint64,
        destructor: fn (OpaqueMutPointer[origin]) -> NoneType,
        encoding: UInt8,
    ):
        self.lib.sqlite3_result_text64(ctx, value, n, destructor, encoding)

    fn result_value(self, ctx: UnsafeMutPointer[sqlite3_context], value: UnsafeMutPointer[sqlite3_value]):
        self.lib.sqlite3_result_value(ctx, value)

    fn result_pointer[origin: MutOrigin](
        self,
        ctx: UnsafeMutPointer[sqlite3_context],
        ptr: OpaqueMutPointer,
        typeStr: UnsafeImmutPointer[c_char],
        destructor: fn (OpaqueMutPointer[origin]) -> NoneType,
    ):
        self.lib.sqlite3_result_pointer(ctx, ptr, typeStr, destructor)

    fn result_zeroblob(self, ctx: UnsafeMutPointer[sqlite3_context], n: c_int):
        self.lib.sqlite3_result_zeroblob(ctx, n)

    fn result_zeroblob64(self, ctx: UnsafeMutPointer[sqlite3_context], n: sqlite3_uint64) -> SQLite3Result:
        return self.lib.sqlite3_result_zeroblob64(ctx, n)

    fn result_subtype(self, ctx: UnsafeMutPointer[sqlite3_context], subtype: UInt32):
        self.lib.sqlite3_result_subtype(ctx, subtype)

    fn create_collation[origin: MutOrigin, origin2: ImmutOrigin, origin3: ImmutOrigin](
        self,
        db: ExternalMutPointer[sqlite3_connection],
        zName: UnsafeImmutPointer[c_char],
        eTextRep: c_int,
        pArg: OpaqueMutPointer,
        xCompare: fn (
            OpaqueMutPointer[origin], c_int, OpaqueImmutPointer[origin2], c_int, OpaqueImmutPointer[origin3]
        ) -> c_int,
    ) -> SQLite3Result:
        return self.lib.sqlite3_create_collation(db, zName, eTextRep, pArg, xCompare)

    fn create_collation_v2[origin: MutOrigin, origin2: ImmutOrigin, origin3: ImmutOrigin, origin4: MutOrigin](
        self,
        db: ExternalMutPointer[sqlite3_connection],
        zName: UnsafeImmutPointer[c_char],
        eTextRep: c_int,
        pArg: OpaqueMutPointer,
        xCompare: fn (
            OpaqueMutPointer[origin], c_int, OpaqueImmutPointer[origin2], c_int, OpaqueImmutPointer[origin3]
        ) -> c_int,
        xDestroy: fn (OpaqueMutPointer[origin4]) -> NoneType,
    ) -> SQLite3Result:
        return self.lib.sqlite3_create_collation_v2(db, zName, eTextRep, pArg, xCompare, xDestroy)

    fn collation_needed[origin: MutOrigin, origin2: MutOrigin, origin3: ImmutOrigin](
        self,
        db: ExternalMutPointer[sqlite3_connection],
        pArg: OpaqueMutPointer,
        callback: fn (
            OpaqueMutPointer[origin], UnsafeMutPointer[sqlite3_connection, origin2], c_int, UnsafeImmutPointer[c_char, origin3]
        ) -> NoneType,
    ) -> SQLite3Result:
        return self.lib.sqlite3_collation_needed(db, pArg, callback)

    fn sleep(self, ms: c_int) -> SQLite3Result:
        return self.lib.sqlite3_sleep(ms)

    fn soft_heap_limit(self, n: c_int) -> SQLite3Result:
        return self.lib.sqlite3_soft_heap_limit(n)

    fn soft_heap_limit64(self, n: sqlite3_int64) -> sqlite3_int64:
        return self.lib.sqlite3_soft_heap_limit64(n)

    fn status(
        self, op: c_int, pCurrent: UnsafeMutPointer[c_int], pHighwater: UnsafeMutPointer[c_int], resetFlag: c_int
    ) -> SQLite3Result:
        return self.lib.sqlite3_status(op, pCurrent, pHighwater, resetFlag)

    fn status64(
        self,
        op: c_int,
        pCurrent: UnsafeMutPointer[sqlite3_int64],
        pHighwater: UnsafeMutPointer[sqlite3_int64],
        resetFlag: c_int,
    ) -> SQLite3Result:
        return self.lib.sqlite3_status64(op, pCurrent, pHighwater, resetFlag)

    fn db_status(
        self,
        db: ExternalMutPointer[sqlite3_connection],
        op: c_int,
        pCurrent: UnsafeMutPointer[c_int],
        pHighwater: UnsafeMutPointer[c_int],
        resetFlag: c_int,
    ) -> SQLite3Result:
        return self.lib.sqlite3_db_status(db, op, pCurrent, pHighwater, resetFlag)

    fn stmt_status(self, pStmt: UnsafeMutPointer[sqlite3_stmt], op: c_int, resetFlg: c_int) -> SQLite3Result:
        return self.lib.sqlite3_stmt_status(pStmt, op, resetFlg)

    fn stmt_scanstatus[origin: MutOrigin](
        self,
        pStmt: UnsafeMutPointer[sqlite3_stmt],
        idx: c_int,
        what: c_int,
        out_ptr: UnsafeMutPointer[OpaqueMutPointer[origin]],
    ) -> SQLite3Result:
        return self.lib.sqlite3_stmt_scanstatus(pStmt, idx, what, out_ptr)

    fn stmt_scanstatus_reset(self, pStmt: UnsafeMutPointer[sqlite3_stmt]):
        self.lib.sqlite3_stmt_scanstatus_reset(pStmt)

    fn table_column_metadata(
        self,
        db: ExternalMutPointer[sqlite3_connection],
        zDbName: UnsafeImmutPointer[c_char],
        zTableName: UnsafeImmutPointer[c_char],
        zColumnName: UnsafeImmutPointer[c_char],
        pzDataType: UnsafeImmutPointer[c_char, ImmutableAnyOrigin],
        pzCollSeq: UnsafeImmutPointer[c_char, ImmutableAnyOrigin],
        pNotNull: UnsafeMutPointer[c_int],
        pPrimaryKey: UnsafeMutPointer[c_int],
        pAutoinc: UnsafeMutPointer[c_int],
    ) -> SQLite3Result:
        return self.lib.sqlite3_table_column_metadata(
            db, zDbName, zTableName, zColumnName, UnsafePointerV2(to=pzDataType), UnsafePointerV2(to=pzCollSeq), pNotNull, pPrimaryKey, pAutoinc
        )

    fn load_extension[origin: MutOrigin](
        self,
        db: ExternalMutPointer[sqlite3_connection],
        zFile: UnsafeImmutPointer[c_char],
        zProc: UnsafeImmutPointer[c_char],
        pzErrMsg: UnsafeMutPointer[UnsafeMutPointer[c_char, origin]],
    ) -> SQLite3Result:
        return self.lib.sqlite3_load_extension(db, zFile, zProc, pzErrMsg)

    fn enable_load_extension(self, db: ExternalMutPointer[sqlite3_connection], onoff: c_int) -> SQLite3Result:
        return self.lib.sqlite3_enable_load_extension(db, onoff)

    fn get_autocommit(self, db: ExternalMutPointer[sqlite3_connection]) -> Bool:
        return self.lib.sqlite3_get_autocommit(db) != 0

    fn db_handle(self, pStmt: UnsafeMutPointer[sqlite3_stmt]) -> ExternalMutPointer[sqlite3_connection]:
        return self.lib.sqlite3_db_handle(pStmt)

    fn db_name(self, db: ExternalMutPointer[sqlite3_connection], N: c_int) -> StringSlice[ImmutableAnyOrigin]:
        return StringSlice(unsafe_from_utf8_ptr=self.lib.sqlite3_db_name(db, N))

    fn db_filename(
        self, db: ExternalMutPointer[sqlite3_connection], zDbName: UnsafeImmutPointer[c_char]
    ) -> sqlite3_filename:
        return self.lib.sqlite3_db_filename(db, zDbName)

    fn db_readonly(
        self, db: ExternalMutPointer[sqlite3_connection], zDbName: UnsafeImmutPointer[c_char]
    ) -> SQLite3Result:
        return self.lib.sqlite3_db_readonly(db, zDbName)

    fn txn_state(
        self, db: ExternalMutPointer[sqlite3_connection], /, zSchema: UnsafeImmutPointer[c_char]
    ) -> SQLite3Result:
        return self.lib.sqlite3_txn_state(db, zSchema)

    fn next_stmt(
        self, pDb: ExternalMutPointer[sqlite3_connection], pStmt: UnsafeMutPointer[sqlite3_stmt]
    ) -> ExternalMutPointer[sqlite3_stmt]:
        return self.lib.sqlite3_next_stmt(pDb, pStmt)

    fn update_hook(
        self,
        db: ExternalMutPointer[sqlite3_connection],
        xCallback: UnsafeMutPointer[
            fn (OpaqueMutPointer, c_int, UnsafeMutPointer[c_char], UnsafeMutPointer[c_char], Int64)
        ],
        pArg: OpaqueMutPointer,
    ) -> None:
        self.lib.sqlite3_update_hook(db, xCallback, pArg)

    fn commit_hook(
        self,
        db: ExternalMutPointer[sqlite3_connection],
        xCallback: UnsafeMutPointer[fn (OpaqueMutPointer) -> c_int],
        pArg: OpaqueMutPointer,
    ) -> OpaqueMutPointer:
        return self.lib.sqlite3_commit_hook(db, xCallback, pArg)

    fn rollback_hook(
        self,
        db: ExternalMutPointer[sqlite3_connection],
        xCallback: UnsafeMutPointer[fn (OpaqueMutPointer)],
        pArg: OpaqueMutPointer,
    ) -> OpaqueMutPointer:
        return self.lib.sqlite3_rollback_hook(db, xCallback, pArg)

    fn autovacuum_pages(
        self,
        db: ExternalMutPointer[sqlite3_connection],
        xCallback: UnsafeMutPointer[
            fn (OpaqueMutPointer, UnsafeImmutPointer[c_char], c_uint, c_uint, c_uint) -> c_int
        ],
        pArg: OpaqueMutPointer,
        eMode: c_int,
    ) -> SQLite3Result:
        return self.lib.sqlite3_autovacuum_pages(db, xCallback, pArg, eMode)

    # sqlite3_auto_extension
    fn auto_extension(self, xEntryPoint: UnsafeMutPointer[fn () -> c_int]) -> SQLite3Result:
        return self.lib.sqlite3_auto_extension(xEntryPoint)

    # sqlite3_enable_shared_cache
    fn enable_shared_cache(self, enable: c_int) -> SQLite3Result:
        return self.lib.sqlite3_enable_shared_cache(enable)

    # sqlite3_release_memory
    fn release_memory(self, bytes: c_int) -> SQLite3Result:
        return self.lib.sqlite3_release_memory(bytes)

    # sqlite3_db_release_memory
    fn db_release_memory(self, db: ExternalMutPointer[sqlite3_connection]) -> SQLite3Result:
        return self.lib.sqlite3_db_release_memory(db)

    # sqlite3_hard_heap_limit64
    fn hard_heap_limit64(self, n: Int64) -> Int64:
        return self.lib.sqlite3_hard_heap_limit64(n)

    # sqlite3_cancel_auto_extension
    fn cancel_auto_extension(self, xEntryPoint: UnsafeMutPointer[fn () -> c_int]) -> SQLite3Result:
        return self.lib.sqlite3_cancel_auto_extension(xEntryPoint)

    fn reset_auto_extension(self) -> SQLite3Result:
        return self.lib.sqlite3_reset_auto_extension()

    fn blob_open[origin: MutOrigin](
        self,
        db: ExternalMutPointer[sqlite3_connection],
        zDb: UnsafeImmutPointer[c_char],
        zTable: UnsafeImmutPointer[c_char],
        zColumn: UnsafeImmutPointer[c_char],
        iRow: sqlite3_int64,
        flags: c_int,
        ppBlob: UnsafeMutPointer[UnsafeMutPointer[sqlite3_blob, origin]],
    ) -> SQLite3Result:
        return self.lib.sqlite3_blob_open(db, zDb, zTable, zColumn, iRow, flags, ppBlob)

    fn blob_reopen(self, pBlob: UnsafeMutPointer[sqlite3_blob], iRow: sqlite3_int64) -> SQLite3Result:
        return self.lib.sqlite3_blob_reopen(pBlob, iRow)

    fn blob_close(self, pBlob: UnsafeMutPointer[sqlite3_blob]) -> SQLite3Result:
        return self.lib.sqlite3_blob_close(pBlob)

    fn blob_bytes(self, pBlob: UnsafeMutPointer[sqlite3_blob]) -> SQLite3Result:
        return self.lib.sqlite3_blob_bytes(pBlob)

    fn blob_read(self, pBlob: UnsafeMutPointer[sqlite3_blob], Z: OpaqueMutPointer, N: c_int, iOffset: c_int) -> SQLite3Result:
        return self.lib.sqlite3_blob_read(pBlob, Z, N, iOffset)

    fn blob_write(
        self, pBlob: UnsafeMutPointer[sqlite3_blob], z: OpaqueMutPointer, n: c_int, iOffset: c_int
    ) -> SQLite3Result:
        return self.lib.sqlite3_blob_write(pBlob, z, n, iOffset)

    fn vfs_find(self, zVfsName: UnsafeImmutPointer[c_char]) -> ExternalMutPointer[sqlite3_vfs]:
        return self.lib.sqlite3_vfs_find(zVfsName)

    fn vfs_register(self, pVfs: UnsafeMutPointer[sqlite3_vfs], makeDflt: c_int) -> SQLite3Result:
        return self.lib.sqlite3_vfs_register(pVfs, makeDflt)

    fn vfs_unregister(self, pVfs: UnsafeMutPointer[sqlite3_vfs]) -> SQLite3Result:
        return self.lib.sqlite3_vfs_unregister(pVfs)

    fn mutex_alloc(self, id: c_int) -> ExternalMutPointer[sqlite3_mutex]:
        return self.lib.sqlite3_mutex_alloc(id)

    fn mutex_free(self, pMutex: UnsafeMutPointer[sqlite3_mutex]):
        self.lib.sqlite3_mutex_free(pMutex)

    fn mutex_enter(self, pMutex: UnsafeMutPointer[sqlite3_mutex]):
        self.lib.sqlite3_mutex_enter(pMutex)

    fn mutex_try(self, pMutex: UnsafeMutPointer[sqlite3_mutex]) -> SQLite3Result:
        return self.lib.sqlite3_mutex_try(pMutex)

    fn mutex_leave(self, pMutex: UnsafeMutPointer[sqlite3_mutex]):
        self.lib.sqlite3_mutex_leave(pMutex)

    fn mutex_held(self, pMutex: UnsafeMutPointer[sqlite3_mutex]) -> SQLite3Result:
        return self.lib.sqlite3_mutex_held(pMutex)

    fn mutex_notheld(self, pMutex: UnsafeMutPointer[sqlite3_mutex]) -> SQLite3Result:
        return self.lib.sqlite3_mutex_notheld(pMutex)

    fn db_mutex(self, db: ExternalMutPointer[sqlite3_connection]) -> ExternalMutPointer[sqlite3_mutex]:
        return self.lib.sqlite3_db_mutex(db)

    fn file_control(
        self,
        db: ExternalMutPointer[sqlite3_connection],
        zDbName: UnsafeImmutPointer[c_char],
        op: c_int,
        pArg: OpaqueMutPointer,
    ) -> SQLite3Result:
        return self.lib.sqlite3_file_control(db, zDbName, op, pArg)

    fn test_control(self, op: c_int) -> SQLite3Result:
        return self.lib.sqlite3_test_control(op)

    fn keyword_count(self) -> SQLite3Result:
        return self.lib.sqlite3_keyword_count()

    fn keyword_name[origin: ImmutOrigin, origin2: MutOrigin](
        self, idx: c_int, pzName: UnsafeMutPointer[UnsafeImmutPointer[c_char, origin]], pnName: UnsafeMutPointer[c_int, origin2]
    ) -> SQLite3Result:
        return self.lib.sqlite3_keyword_name(idx, pzName, pnName)

    fn keyword_check(self, zName: UnsafeImmutPointer[c_char], nName: c_int) -> SQLite3Result:
        return self.lib.sqlite3_keyword_check(zName, nName)

    fn str_new(self, db: ExternalMutPointer[sqlite3_connection]) -> ExternalMutPointer[sqlite3_str]:
        return self.lib.sqlite3_str_new(db)

    fn str_finish(self, pStr: UnsafeMutPointer[sqlite3_str]) -> StringSlice[ImmutableAnyOrigin]:
        return StringSlice(unsafe_from_utf8_ptr=self.lib.sqlite3_str_finish(pStr))

    fn str_appendf(self, pStr: UnsafeMutPointer[sqlite3_str], zFormat: UnsafeImmutPointer[c_char]):
        self.lib.sqlite3_str_appendf(pStr, zFormat)

    fn str_append(self, pStr: UnsafeMutPointer[sqlite3_str], zIn: UnsafeImmutPointer[c_char], N: c_int):
        self.lib.sqlite3_str_append(pStr, zIn, N)

    fn str_appendall(self, pStr: UnsafeMutPointer[sqlite3_str], zIn: UnsafeImmutPointer[c_char]):
        self.lib.sqlite3_str_appendall(pStr, zIn)

    fn str_appendchar(self, pStr: UnsafeMutPointer[sqlite3_str], N: c_int, C: Int8):
        self.lib.sqlite3_str_appendchar(pStr, N, C)

    fn str_reset(self, pStr: UnsafeMutPointer[sqlite3_str]):
        self.lib.sqlite3_str_reset(pStr)

    fn str_errcode(self, pStr: UnsafeMutPointer[sqlite3_str]) -> SQLite3Result:
        return self.lib.sqlite3_str_errcode(pStr)

    fn str_length(self, pStr: UnsafeMutPointer[sqlite3_str]) -> SQLite3Result:
        return self.lib.sqlite3_str_length(pStr)

    fn str_value(self, pStr: UnsafeMutPointer[sqlite3_str]) -> StringSlice[ImmutableAnyOrigin]:
        return StringSlice(unsafe_from_utf8_ptr=self.lib.sqlite3_str_value(pStr))

    fn backup_init(
        self,
        pDest: ExternalMutPointer[sqlite3_connection],
        zDestName: UnsafeImmutPointer[c_char],
        pSource: ExternalMutPointer[sqlite3_connection],
        zSourceName: UnsafeImmutPointer[c_char],
    ) -> ExternalMutPointer[sqlite3_backup]:
        return self.lib.sqlite3_backup_init(pDest, zDestName, pSource, zSourceName)

    fn backup_step(self, p: UnsafeMutPointer[sqlite3_backup], nPage: c_int) -> SQLite3Result:
        return self.lib.sqlite3_backup_step(p, nPage)

    fn backup_finish(self, p: UnsafeMutPointer[sqlite3_backup]) -> SQLite3Result:
        return self.lib.sqlite3_backup_finish(p)

    fn backup_remaining(self, p: UnsafeMutPointer[sqlite3_backup]) -> SQLite3Result:
        return self.lib.sqlite3_backup_remaining(p)

    fn backup_pagecount(self, p: UnsafeMutPointer[sqlite3_backup]) -> SQLite3Result:
        return self.lib.sqlite3_backup_pagecount(p)

    fn unlock_notify[origin: MutOrigin, origin2: MutOrigin](
        self,
        pBlocked: ExternalMutPointer[sqlite3_connection],
        xNotify: fn (UnsafeMutPointer[OpaqueMutPointer[origin], origin2], c_int) -> NoneType,
        pNotifyArg: OpaqueMutPointer,
    ) -> SQLite3Result:
        return self.lib.sqlite3_unlock_notify(pBlocked, xNotify, pNotifyArg)

    fn stricmp(self, str1: UnsafeImmutPointer[c_char], str2: UnsafeImmutPointer[c_char]) -> SQLite3Result:
        return self.lib.sqlite3_stricmp(str1, str2)

    fn strnicmp(
        self, str1: UnsafeImmutPointer[c_char], str2: UnsafeImmutPointer[c_char], n: c_int
    ) -> SQLite3Result:
        return self.lib.sqlite3_strnicmp(str1, str2, n)

    fn strglob(self, zGlob: UnsafeImmutPointer[c_char], zStr: UnsafeImmutPointer[c_char]) -> SQLite3Result:
        return self.lib.sqlite3_strglob(zGlob, zStr)

    fn strlike(
        self, zGlob: UnsafeImmutPointer[c_char], zStr: UnsafeImmutPointer[c_char], cEsc: UInt32
    ) -> SQLite3Result:
        return self.lib.sqlite3_strlike(zGlob, zStr, cEsc)

    fn log(self, iErrCode: c_int, zFormat: UnsafeImmutPointer[c_char]):
        self.lib.sqlite3_log(iErrCode, zFormat)

    fn wal_hook[origin: MutOrigin, origin2: MutOrigin, origin3: MutOrigin](
        self,
        db: ExternalMutPointer[sqlite3_connection],
        xCallback: fn (OpaqueMutPointer[origin], UnsafeMutPointer[sqlite3_connection, origin2], UnsafeMutPointer[c_char, origin3], c_int) -> c_int,
        pArg: OpaqueMutPointer,
    ) -> OpaqueMutPointer:
        return self.lib.sqlite3_wal_hook(db, xCallback, pArg)

    fn wal_autocheckpoint(self, db: ExternalMutPointer[sqlite3_connection], N: c_int) -> SQLite3Result:
        return self.lib.sqlite3_wal_autocheckpoint(db, N)

    fn wal_checkpoint(
        self, db: ExternalMutPointer[sqlite3_connection], zDb: UnsafeImmutPointer[c_char]
    ) -> SQLite3Result:
        return self.lib.sqlite3_wal_checkpoint(db, zDb)

    fn wal_checkpoint_v2(
        self,
        db: ExternalMutPointer[sqlite3_connection],
        zDb: UnsafeImmutPointer[c_char],
        eMode: c_int,
        pnLog: UnsafeMutPointer[c_int],
        pnCkpt: UnsafeMutPointer[c_int],
    ) -> SQLite3Result:
        return self.lib.sqlite3_wal_checkpoint_v2(db, zDb, eMode, pnLog, pnCkpt)

    fn vtab_config(self, db: ExternalMutPointer[sqlite3_connection], op: c_int) -> SQLite3Result:
        return self.lib.sqlite3_vtab_config(db, op)

    fn vtab_on_conflict(self, db: ExternalMutPointer[sqlite3_connection]) -> SQLite3Result:
        return self.lib.sqlite3_vtab_on_conflict(db)

    fn vtab_nochange(self, ctx: UnsafeMutPointer[sqlite3_context]) -> SQLite3Result:
        return self.lib.sqlite3_vtab_nochange(ctx)

    fn vtab_collation(
        self, pIdxInfo: UnsafeMutPointer[sqlite3_index_info], iCons: c_int
    ) -> StringSlice[ImmutableAnyOrigin]:
        return StringSlice(unsafe_from_utf8_ptr=self.lib.sqlite3_vtab_collation(pIdxInfo, iCons))

    fn vtab_distinct(self, pIdxInfo: UnsafeMutPointer[sqlite3_index_info]) -> SQLite3Result:
        return self.lib.sqlite3_vtab_distinct(pIdxInfo)

    fn vtab_in(self, pIdxInfo: UnsafeMutPointer[sqlite3_index_info], iCons: c_int, bHandle: c_int) -> SQLite3Result:
        return self.lib.sqlite3_vtab_in(pIdxInfo, iCons, bHandle)

    fn vtab_in_first[origin: MutOrigin](
        self, pVal: UnsafeMutPointer[sqlite3_value], ppOut: UnsafeMutPointer[UnsafeMutPointer[sqlite3_value, origin]]
    ) -> SQLite3Result:
        return self.lib.sqlite3_vtab_in_first(pVal, ppOut)

    fn vtab_in_next[origin: MutOrigin](
        self, pVal: UnsafeMutPointer[sqlite3_value], ppOut: UnsafeMutPointer[UnsafeMutPointer[sqlite3_value, origin]]
    ) -> SQLite3Result:
        return self.lib.sqlite3_vtab_in_next(pVal, ppOut)

    fn vtab_rhs_value[origin: MutOrigin](
        self,
        pIdxInfo: UnsafeMutPointer[sqlite3_index_info],
        iCons: c_int,
        ppVal: UnsafeMutPointer[UnsafeMutPointer[sqlite3_value, origin]],
    ) -> SQLite3Result:
        return self.lib.sqlite3_vtab_rhs_value(pIdxInfo, iCons, ppVal)

    fn stmt_scanstatus_v2(
        self, pStmt: UnsafeMutPointer[sqlite3_stmt], idx: c_int, iScanStatusOp: c_int, flags: c_int, pOut: OpaqueMutPointer
    ) -> SQLite3Result:
        return self.lib.sqlite3_stmt_scanstatus_v2(pStmt, idx, iScanStatusOp, flags, pOut)

    fn db_cacheflush(self, db: ExternalMutPointer[sqlite3_connection]) -> SQLite3Result:
        return self.lib.sqlite3_db_cacheflush(db)

    fn system_errno(self, db: ExternalMutPointer[sqlite3_connection]) -> SQLite3Result:
        return self.lib.sqlite3_system_errno(db)

    fn snapshot_get[origin: MutOrigin](
        self,
        db: ExternalMutPointer[sqlite3_connection],
        zSchema: UnsafeImmutPointer[c_char],
        ppSnapshot: UnsafeMutPointer[UnsafeMutPointer[sqlite3_snapshot, origin]],
    ) -> SQLite3Result:
        return self.lib.sqlite3_snapshot_get(db, zSchema, ppSnapshot)

    fn snapshot_open(
        self,
        db: ExternalMutPointer[sqlite3_connection],
        zSchema: UnsafeImmutPointer[c_char],
        pSnapshot: UnsafeMutPointer[sqlite3_snapshot],
    ) -> SQLite3Result:
        return self.lib.sqlite3_snapshot_open(db, zSchema, pSnapshot)

    fn snapshot_free(self, pSnapshot: UnsafeMutPointer[sqlite3_snapshot]):
        self.lib.sqlite3_snapshot_free(pSnapshot)

    fn snapshot_cmp(self, p1: UnsafeMutPointer[sqlite3_snapshot], p2: UnsafeMutPointer[sqlite3_snapshot]) -> SQLite3Result:
        return self.lib.sqlite3_snapshot_cmp(p1, p2)

    fn snapshot_recover(
        self, db: ExternalMutPointer[sqlite3_connection], zDb: UnsafeImmutPointer[c_char]
    ) -> SQLite3Result:
        return self.lib.sqlite3_snapshot_recover(db, zDb)

    fn serialize(
        self,
        db: ExternalMutPointer[sqlite3_connection],
        zSchema: UnsafeImmutPointer[c_char],
        piSize: UnsafeMutPointer[sqlite3_int64],
        mFlags: UInt32,
    ) -> ExternalMutPointer[UInt8]:
        return self.lib.sqlite3_serialize(db, zSchema, piSize, mFlags)

    fn deserialize(
        self,
        db: ExternalMutPointer[sqlite3_connection],
        zSchema: UnsafeImmutPointer[c_char],
        pData: UnsafeMutPointer[UInt8],
        szDb: sqlite3_int64,
        szBuf: sqlite3_int64,
        mFlags: UInt32,
    ) -> SQLite3Result:
        return self.lib.sqlite3_deserialize(db, zSchema, pData, szDb, szBuf, mFlags)
