from sys.ffi import c_char
from slight.c.api import get_sqlite3_handle
from slight.c.types import MutExternalPointer


@fieldwise_init
struct SQLiteMallocString(Copyable, Movable):
    """A string we own that's allocated on the SQLite heap. Automatically calls `sqlite3_free` when deleted."""

    var ptr: MutExternalPointer[c_char]
    """A pointer to the C string allocated by SQLite."""

    fn __del__(deinit self):
        if self.ptr:
            get_sqlite3_handle()[].free(self.ptr.bitcast[NoneType]())

    fn as_string_slice(mut self) -> StringSlice[origin_of(self)]:
        """Converts the C string to a Mojo StringSlice.

        Returns:
            A StringSlice representing the C string.
        """
        return StringSlice(unsafe_from_utf8_ptr=self.ptr.unsafe_origin_cast[origin_of(self)]())
