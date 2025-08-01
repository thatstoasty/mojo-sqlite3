from sys.ffi import c_char
from slight.c.api import get_sqlite3_handle


@fieldwise_init
struct SQLiteMallocString(Copyable, Movable):
    """A string we own that's allocated on the SQLite heap. Automatically calls `sqlite3_free` when deleted."""

    var ptr: UnsafePointer[c_char]
    """A pointer to the C string allocated by SQLite."""

    fn __del__(deinit self):
        if self.ptr:
            get_sqlite3_handle()[].free(self.ptr.bitcast[NoneType]())

    fn as_string_slice(self) -> StringSlice[origin_of(self)]:
        """Converts the C string to a Mojo StringSlice.

        Returns:
            A StringSlice representing the C string.
        """
        return StringSlice[origin_of(self)](unsafe_from_utf8_ptr=self.ptr)
