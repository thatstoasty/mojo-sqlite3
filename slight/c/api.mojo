from sys.ffi import _get_global, _Global

from memory import UnsafeMutPointer
from slight.bindings import sqlite3
from slight.c.raw_bindings import _sqlite3


fn _init_global() -> OpaquePointer:
    var ptr = UnsafePointer[sqlite3].alloc(1)
    ptr[] = sqlite3()
    return ptr.bitcast[NoneType]()


fn _destroy_global(lib: OpaquePointer):
    var p = lib.bitcast[sqlite3]()
    p[].lib.lib.close()
    lib.free()


@always_inline
fn get_sqlite3_handle() -> UnsafePointer[sqlite3]:
    """Initializes or gets the global sqlite3 handle.

    DO NOT FREE THE POINTER MANUALLY. It will be freed automatically on program exit.

    Returns:
        A pointer to the global sqlite3 handle.
    """
    return _get_global["sqlite3", _init_global, _destroy_global]().bitcast[sqlite3]()
