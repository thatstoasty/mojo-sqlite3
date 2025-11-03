from slight.c.raw_bindings import (
    SQLITE_OK,
    SQLITE_ERROR,
    SQLITE_ROW,
    SQLITE_INTERNAL,
    SQLITE_PERM,
    SQLITE_ABORT,
    SQLITE_BUSY,
    SQLITE_LOCKED,
    SQLITE_NOMEM,
    SQLITE_READONLY,
    SQLITE_INTERRUPT,
    SQLITE_IOERR,
    SQLITE_CORRUPT,
    SQLITE_NOTFOUND,
    SQLITE_FULL,
    SQLITE_CANTOPEN,
    SQLITE_PROTOCOL,
    SQLITE_EMPTY,
    SQLITE_SCHEMA,
    SQLITE_TOOBIG,
    SQLITE_CONSTRAINT,
    SQLITE_MISMATCH,
    SQLITE_MISUSE,
    SQLITE_NOLFS,
    SQLITE_AUTH,
    SQLITE_FORMAT,
    SQLITE_RANGE,
    SQLITE_NOTADB,
    SQLITE_NOTICE,
    SQLITE_WARNING,
    SQLITE_DONE,
)


@register_passable("trivial")
struct SQLite3Result(Copyable, EqualityComparable, ImplicitlyCopyable, Intable, Movable, Writable):
    var value: Int32
    alias SQLITE_OK: Self = SQLITE_OK
    alias SQLITE_ERROR: Self = SQLITE_ERROR
    alias SQLITE_INTERNAL: Self = SQLITE_INTERNAL
    alias SQLITE_PERM: Self = SQLITE_PERM
    alias SQLITE_ABORT: Self = SQLITE_ABORT
    alias SQLITE_BUSY: Self = SQLITE_BUSY
    alias SQLITE_LOCKED: Self = SQLITE_LOCKED
    alias SQLITE_NOMEM: Self = SQLITE_NOMEM
    alias SQLITE_READONLY: Self = SQLITE_READONLY
    alias SQLITE_INTERRUPT: Self = SQLITE_INTERRUPT
    alias SQLITE_IOERR: Self = SQLITE_IOERR
    alias SQLITE_CORRUPT: Self = SQLITE_CORRUPT
    alias SQLITE_NOTFOUND: Self = SQLITE_NOTFOUND
    alias SQLITE_FULL: Self = SQLITE_FULL
    alias SQLITE_CANTOPEN: Self = SQLITE_CANTOPEN
    alias SQLITE_PROTOCOL: Self = SQLITE_PROTOCOL
    alias SQLITE_EMPTY: Self = SQLITE_EMPTY
    alias SQLITE_SCHEMA: Self = SQLITE_SCHEMA
    alias SQLITE_TOOBIG: Self = SQLITE_TOOBIG
    alias SQLITE_CONSTRAINT: Self = SQLITE_CONSTRAINT
    alias SQLITE_MISMATCH: Self = SQLITE_MISMATCH
    alias SQLITE_MISUSE: Self = SQLITE_MISUSE
    alias SQLITE_NOLFS: Self = SQLITE_NOLFS
    alias SQLITE_AUTH: Self = SQLITE_AUTH
    alias SQLITE_FORMAT: Self = SQLITE_FORMAT
    alias SQLITE_RANGE: Self = SQLITE_RANGE
    alias SQLITE_NOTADB: Self = SQLITE_NOTADB
    alias SQLITE_NOTICE: Self = SQLITE_NOTICE
    alias SQLITE_WARNING: Self = SQLITE_WARNING
    alias SQLITE_ROW: Self = SQLITE_ROW
    alias SQLITE_DONE: Self = SQLITE_DONE

    @implicit
    fn __init__(out self, value: Int32):
        self.value = value

    @implicit
    fn __init__(out self, value: Int):
        self.value = value

    fn __int__(self) -> Int:
        return Int(self.value)

    fn __eq__(self, other: Self) -> Bool:
        return self.value == other.value

    fn __eq__(self, other: Int32) -> Bool:
        return self.value == other

    fn write_to[W: Writer](self, mut writer: W):
        writer.write(self.value)
