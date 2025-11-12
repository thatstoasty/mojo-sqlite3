from sys.ffi import _get_global, _Global

from memory import UnsafeMutPointer
from memory.legacy_unsafe_pointer import LegacyUnsafePointer
from slight.bindings import sqlite3
from slight.c.raw_bindings import _sqlite3


fn _init_global() -> LegacyUnsafePointer[NoneType]:
    var ptr = LegacyUnsafePointer[sqlite3].alloc(1)
    ptr[] = sqlite3()
    return ptr.bitcast[NoneType]()


fn _destroy_global(lib: LegacyUnsafePointer[NoneType]):
    var p = lib.bitcast[sqlite3]()
    lib.free()


@always_inline
fn get_sqlite3_handle() -> LegacyUnsafePointer[sqlite3]:
    """Initializes or gets the global sqlite3 handle.

    DO NOT FREE THE POINTER MANUALLY. It will be freed automatically on program exit.

    Returns:
        A pointer to the global sqlite3 handle.
    """
    return _get_global["sqlite3", _init_global, _destroy_global]().bitcast[sqlite3]()
