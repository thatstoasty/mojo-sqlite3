from memory import OpaquePointer
from utils import StaticTuple

from sys.ffi import c_char, c_int


alias SQLITE_INTEGER: Int32 = 1
alias SQLITE_FLOAT: Int32 = 2
alias SQLITE_BLOB: Int32 = 4
alias SQLITE_NULL: Int32 = 5
alias SQLITE_TEXT: Int32 = 3
alias SQLITE3_TEXT: Int32 = 3
alias SQLITE_UTF8: UInt8 = 1
alias SQLITE_UTF16LE: UInt8 = 2
alias SQLITE_UTF16BE: UInt8 = 3
alias SQLITE_UTF16: UInt8 = 4
alias SQLITE_ANY: UInt8 = 5


struct sqlite3_connection(Movable):
    """Database Connection Handle.

    Each open SQLite database is represented by a pointer to an instance of
    the opaque structure named "sqlite3".  It is useful to think of an sqlite3
    pointer as an object.  The [sqlite3_open()], [sqlite3_open16()], and
    [sqlite3_open_v2()] interfaces are its constructors, and [sqlite3_close()]
    and [sqlite3_close_v2()] are its destructors.  There are many other
    interfaces (such as
    [sqlite3_prepare_v2()], [sqlite3_create_function()], and
    [sqlite3_busy_timeout()] to name but three) that are methods on an
    sqlite3 object."""

    pass



struct sqlite3_file(Movable):
    """OS Interface Open File Handle.

    An [sqlite3_file] object represents an open file in the
    [sqlite3_vfs | OS interface layer].  Individual OS interface
    implementations will
    want to subclass this object by appending additional fields
    for their own use.  The pMethods entry is a pointer to an
    [sqlite3_io_methods] object that defines methods for performing
    I/O operations on the open file.
    """

    pass


alias ResultDestructorFn = fn (ExternalMutPointer[NoneType]) -> NoneType
"""Constants Defining Special Destructor Behavior
These are special values for the destructor that is passed in as the
final argument to routines like [sqlite3_result_blob()].  ^If the destructor
argument is SQLITE_STATIC, it means that the content pointer is constant
and will never change.  It does not need to be destroyed.  ^The
SQLITE_TRANSIENT value means that the content will likely change in
the near future and that SQLite should make its own private copy of
the content before returning.
The typedef is necessary to work around problems in certain
C++ compilers."""

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


# To use these as destructors for libsqlite3, first create a pointer to the value.
# Then bitcast it to ResultDestructorFn. Then when calling sqlite3_bind_text or
# sqlite3_result_blob, pass the dereferenced pointer as the destructor argument.
alias SQLITE_STATIC = 0
alias SQLITE_TRANSIENT = -1



struct sqlite3_backup(Movable):
    """Online Backup Object.

    The sqlite3_backup object records state information about an ongoing
    online backup operation.  ^The sqlite3_backup object is created by
    a call to [sqlite3_backup_init()] and is destroyed by a call to
    [sqlite3_backup_finish()].

    See Also: [Using the SQLite Online Backup API]"""

    pass



struct sqlite3_snapshot(Movable):
    """Database Snapshot.

    An instance of the snapshot object records the state of a [WAL mode]
    database for some specific point in history.

    In [WAL mode], multiple [database connections] that are open on the
    same database file can each be reading a different historical version
    of the database file.  When a [database connection] begins a read
    transaction, that connection sees an unchanging copy of the database
    as it existed for the point in time when the transaction first started.
    Subsequent changes to the database from other connections are not seen
    by the reader until a new read transaction is started.

    The sqlite3_snapshot object records state information about an historical
    version of the database file so that it is possible to later open a new read
    transaction that sees that historical version of the database rather than
    the most recent version.
    """

    var hidden: StaticTuple[UInt8, 48]


struct sqlite3_stmt(Movable):
    """Prepared Statement Object.

    An instance of this object represents a single SQL statement that
    has been compiled into binary form and is ready to be evaluated.
    Think of each SQL statement as a separate computer program.  The
    original SQL text is source code.  A prepared statement object
    is the compiled object code.  All SQL must be converted into a
    prepared statement before it can be run.
    The life-cycle of a prepared statement object usually goes like this:

    Create the prepared statement object using [sqlite3_prepare_v2()].
    Bind values to [parameters] using the sqlite3_bind_()
        interfaces.
    Run the SQL by calling [sqlite3_step()] one or more times.
    Reset the prepared statement using [sqlite3_reset()] then go back
        to step 2.  Do this zero or more times.
    Destroy the object using [sqlite3_finalize()].
    """

    pass



struct sqlite3_value(Movable):
    """Dynamically Typed Value Object.
    SQLite uses the sqlite3_value object to represent all values
    that can be stored in a database table. SQLite uses dynamic typing
    for the values it stores.  ^Values stored in sqlite3_value objects
    can be integers, floating point values, strings, BLOBs, or NULL.
    An sqlite3_value object may be either "protected" or "unprotected".
    Some interfaces require a protected sqlite3_value.  Other interfaces
    will accept either a protected or an unprotected sqlite3_value.
    Every interface that accepts sqlite3_value arguments specifies
    whether or not it requires a protected sqlite3_value.  The
    [sqlite3_value_dup()] interface can be used to construct a new
    protected sqlite3_value from an unprotected sqlite3_value.
    The terms "protected" and "unprotected" refer to whether or not
    a mutex is held.  An internal mutex is held for a protected
    sqlite3_value object but no mutex is held for an unprotected
    sqlite3_value object.  If SQLite is compiled to be single-threaded
    (with [SQLITE_THREADSAFE=0] and with [sqlite3_threadsafe()] returning 0)
    or if SQLite is run in one of reduced mutex modes
    [SQLITE_CONFIG_SINGLETHREAD] or [SQLITE_CONFIG_MULTITHREAD]
    then there is no distinction between protected and unprotected
    sqlite3_value objects and they can be used interchangeably.  However,
    for maximum code portability it is recommended that applications
    still make the distinction between protected and unprotected
    sqlite3_value objects even when not strictly required.
    ^The sqlite3_value objects that are passed as parameters into the
    implementation of [application-defined SQL functions] are protected.
    ^The sqlite3_value objects returned by [sqlite3_vtab_rhs_value()]
    are protected.
    ^The sqlite3_value object returned by
    [sqlite3_column_value()] is unprotected.
    Unprotected sqlite3_value objects may only be used as arguments
    to [sqlite3_result_value()], [sqlite3_bind_value()], and
    [sqlite3_value_dup()].
    The [sqlite3_value_blob | sqlite3_value_type()] family of
    interfaces require protected sqlite3_value objects."""

    pass



struct sqlite3_context(Movable):
    """SQL Function Context Object.
    The context in which an SQL function executes is stored in an
    sqlite3_context object.  ^A pointer to an sqlite3_context object
    is always first parameter to [application-defined SQL functions].
    The application-defined SQL function implementation will pass this
    pointer through into calls to [sqlite3_result_int | sqlite3_result()],
    [sqlite3_aggregate_context()], [sqlite3_user_data()],
    [sqlite3_context_db_handle()], [sqlite3_get_auxdata()],
    and/or [sqlite3_set_auxdata()]."""

    pass


struct sqlite3_module(Movable):
    var iVersion: Int32
    var xCreate: fn (
        ExternalPointer[sqlite3_connection],
        OpaquePointer,
        Int32,
        ExternalPointer[ExternalPointer[Int8]],
        ExternalPointer[ExternalPointer[sqlite3_vtab]],
        ExternalPointer[ExternalPointer[Int8]],
    ) -> Int32  # FieldDeclNode: This is a const param, but shouldn't be assigned as an alias since it doesn't have a value.
    var xConnect: fn (
        ExternalPointer[sqlite3_connection],
        OpaquePointer,
        Int32,
        ExternalPointer[ExternalPointer[Int8]],
        ExternalPointer[ExternalPointer[sqlite3_vtab]],
        ExternalPointer[ExternalPointer[Int8]],
    ) -> Int32  # FieldDeclNode: This is a const param, but shouldn't be assigned as an alias since it doesn't have a value.
    var xBestIndex: fn (ExternalPointer[sqlite3_vtab], ExternalPointer[sqlite3_index_info]) -> Int32
    var xDisconnect: fn (ExternalPointer[sqlite3_vtab]) -> Int32
    var xDestroy: fn (ExternalPointer[sqlite3_vtab]) -> Int32
    var xOpen: fn (ExternalPointer[sqlite3_vtab], ExternalPointer[ExternalPointer[sqlite3_vtab_cursor]]) -> Int32
    var xClose: fn (ExternalPointer[sqlite3_vtab_cursor]) -> Int32
    var xFilter: fn (
        ExternalPointer[sqlite3_vtab_cursor],
        Int32,
        ExternalPointer[Int8],
        Int32,
        ExternalPointer[ExternalPointer[sqlite3_value]],
    ) -> Int32  # FieldDeclNode: This is a const param, but shouldn't be assigned as an alias since it doesn't have a value.
    var xNext: fn (ExternalPointer[sqlite3_vtab_cursor]) -> Int32
    var xEof: fn (ExternalPointer[sqlite3_vtab_cursor]) -> Int32
    var xColumn: fn (ExternalPointer[sqlite3_vtab_cursor], ExternalPointer[sqlite3_context], Int32) -> Int32
    var xRowid: fn (ExternalPointer[sqlite3_vtab_cursor], ExternalPointer[Int64]) -> Int32
    var xUpdate: fn (
        ExternalPointer[sqlite3_vtab],
        Int32,
        ExternalPointer[ExternalPointer[sqlite3_value]],
        ExternalPointer[Int64],
    ) -> Int32
    var xBegin: fn (ExternalPointer[sqlite3_vtab]) -> Int32
    var xSync: fn (ExternalPointer[sqlite3_vtab]) -> Int32
    var xCommit: fn (ExternalPointer[sqlite3_vtab]) -> Int32
    var xRollback: fn (ExternalPointer[sqlite3_vtab]) -> Int32
    var xFindFunction: fn (
        ExternalPointer[sqlite3_vtab],
        Int32,
        ExternalImmutPointer[Int8],
        fn (
            ExternalPointer[sqlite3_context], Int32, ExternalPointer[ExternalPointer[sqlite3_value]]
        ) -> ExternalPointer[OpaquePointer],
        ExternalPointer[OpaquePointer],
    ) -> Int32  # FieldDeclNode: This is a const param, but shouldn't be assigned as an alias since it doesn't have a value.
    var xRename: fn (
        ExternalPointer[sqlite3_vtab], ExternalPointer[Int8]
    ) -> Int32  # FieldDeclNode: This is a const param, but shouldn't be assigned as an alias since it doesn't have a value.
    var xSavepoint: fn (ExternalPointer[sqlite3_vtab], Int32) -> Int32
    var xRelease: fn (ExternalPointer[sqlite3_vtab], Int32) -> Int32
    var xRollbackTo: fn (ExternalPointer[sqlite3_vtab], Int32) -> Int32
    var xShadowName: fn (ExternalImmutPointer[Int8]) -> Int32
    var xIntegrity: fn (
        ExternalPointer[sqlite3_vtab],
        ExternalPointer[Int8],
        ExternalPointer[Int8],
        Int32,
        ExternalPointer[ExternalPointer[Int8]],
    ) -> Int32  # FieldDeclNode: This is a const param, but shouldn't be assigned as an alias since it doesn't have a value.


struct _sqlite3_index_info_sqlite3_index_constraint_usage(Movable):
    var argvIndex: Int32
    var omit: UInt8


struct _sqlite3_index_info_sqlite3_index_orderby(Movable):
    var iColumn: Int32
    var desc: UInt8


struct _sqlite3_index_info_sqlite3_index_constraint(Movable):
    var iColumn: Int32
    var op: UInt8
    var usable: UInt8
    var iTermOffset: Int32


struct sqlite3_index_info(Movable):
    var nConstraint: Int32
    var aConstraint: ExternalPointer[_sqlite3_index_info_sqlite3_index_constraint]
    var nOrderBy: Int32
    var aOrderBy: ExternalPointer[_sqlite3_index_info_sqlite3_index_orderby]
    var aConstraintUsage: ExternalPointer[_sqlite3_index_info_sqlite3_index_constraint_usage]
    var idxNum: Int32
    var idxStr: ExternalPointer[Int8]
    var needToFreeIdxStr: Int32
    var orderByConsumed: Int32
    var estimatedCost: Float64
    var estimatedRows: Int64
    var idxFlags: Int32
    var colUsed: UInt64



struct sqlite3_vtab(Movable):
    """Structures used by the virtual table interface."""

    var pModule: ExternalPointer[
        sqlite3_module
    ]  # FieldDeclNode: This is a const param, but shouldn't be assigned as an alias since it doesn't have a value.
    var nRef: Int32
    var zErrMsg: ExternalPointer[Int8]


struct sqlite3_vtab_cursor(Movable):
    var pVtab: ExternalPointer[sqlite3_vtab]


struct sqlite3_blob(Movable):
    """A Handle To An Open BLOB.

    An instance of this object represents an open BLOB on which
    [sqlite3_blob_open | incremental BLOB I/O] can be performed.
    ^Objects of this type are created by [sqlite3_blob_open()]
    and destroyed by [sqlite3_blob_close()].
    ^The [sqlite3_blob_read()] and [sqlite3_blob_write()] interfaces
    can be used to read or write small subsections of the BLOB.
    ^The [sqlite3_blob_bytes()] interface returns the size of the BLOB in bytes."""

    pass
