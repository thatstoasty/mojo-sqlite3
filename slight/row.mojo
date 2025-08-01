from memory import Pointer
from slight.statement import Statement, InvalidColumnIndexError
from slight.types.value_ref import SQLite3Blob, SQLite3Integer, SQLite3Null, SQLite3Real, SQLite3Text, InvalidColumnTypeError
from slight.types.from_sql import FromSQL, String, Int, Bool, SIMD


trait RowIndex:
    fn idx(self, stmt: Statement) raises -> UInt:
        ...


__extension Int(RowIndex):
    fn idx(self, stmt: Statement) raises -> UInt:
        if self < 0 or UInt(self) >= stmt.column_count():
            raise InvalidColumnIndexError
        
        return UInt(self)


__extension UInt(RowIndex):
    fn idx(self, stmt: Statement) raises -> UInt:
        if self >= stmt.column_count():
            raise InvalidColumnIndexError
        
        return self


__extension String(RowIndex):
    fn idx(self, stmt: Statement) raises -> UInt:
        return stmt.column_index(self)


__extension StringSlice(RowIndex):
    fn idx(self, stmt: Statement) raises -> UInt:
        return stmt.column_index(self)


@fieldwise_init
struct Row[statement: Origin, ptr: Origin](Copyable, Movable):
    """Represents a single row in the result set of a SQL query."""

    var stmt: Pointer[Statement[statement], ptr]
    """A pointer to the statement that produced this row."""

    fn get_int64(self, idx: Some[RowIndex]) raises -> Optional[Int]:
        """Gets an Int64 value from the specified column.

        Args:
            idx: The column index (0-based).

        Returns:
            An Optional 2taining the Int value, or None if the column is NULL.

        Raises:
            InvalidColumnIndexError: If the column index is out of bounds.
            InvalidColumnTypeError: If the column does not contain an integer.
        """
        var i = idx.idx(self.stmt[])
        if i >= self.stmt[].column_count():
            raise InvalidColumnIndexError

        var value = self.stmt[].value_ref(i)
        if value.isa[SQLite3Null]():
            return None
        elif value.isa[SQLite3Integer]():
            return Int(value[SQLite3Integer].value)
        else:
            raise InvalidColumnTypeError

    fn get_int(self, idx: Some[RowIndex]) raises -> Optional[Int]:
        """Gets an Int value from the specified column.

        Args:
            idx: The column index (0-based).

        Returns:
            An Optional containing the Int value, or None if the column is NULL.

        Raises:
            InvalidColumnIndexError: If the column index is out of bounds.
            InvalidColumnTypeError: If the column does not contain an integer.
        """
        var result = self.get_int64(idx)
        if result:
            return Int(result.value())
        return None

    fn get_bool(self, idx: Some[RowIndex]) raises -> Optional[Bool]:
        """Gets a UInt value from the specified column.

        Args:
            idx: The column index (0-based).

        Returns:
            An Optional containing the UInt value, or None if the column is NULL.

        Raises:
            InvalidColumnIndexError: If the column index is out of bounds.
            InvalidColumnTypeError: If the column does not contain an integer.
        """
        var result = self.get_int64(idx)
        if result:
            return True if result.value() == 1 else False
        return None

    fn get_float64(self, idx: Some[RowIndex]) raises -> Optional[Float64]:
        """Gets a Float64 value from the specified column.

        Args:
            idx: The column index (0-based).

        Returns:
            An Optional containing the Float64 value, or None if the column is NULL.

        Raises:
            InvalidColumnIndexError: If the column index is out of bounds.
            InvalidColumnTypeError: If the column does not contain a real number.
        """
        var i = idx.idx(self.stmt[])
        if i >= self.stmt[].column_count():
            raise InvalidColumnIndexError
        var value = self.stmt[].value_ref(i)

        if value.isa[SQLite3Null]():
            return None
        elif value.isa[SQLite3Real]():
            return Float64(value[SQLite3Real].value)
        else:
            raise InvalidColumnTypeError

    fn get_string_slice(self, idx: Some[RowIndex]) raises -> Optional[StringSlice[statement]]:
        """Gets a StringSlice value from the specified column.

        Args:
            idx: The column index (0-based).

        Returns:
            An Optional containing the StringSlice value, or None if the column is NULL.

        Raises:
            InvalidColumnIndexError: If the column index is out of bounds.
            InvalidColumnTypeError: If the column does not contain text.
        """
        var i = idx.idx(self.stmt[])
        if i >= self.stmt[].column_count():
            raise InvalidColumnIndexError
        var value = self.stmt[].value_ref(i)

        if value.isa[SQLite3Null]():
            return None
        elif value.isa[SQLite3Text[statement]]():
            return value[SQLite3Text[statement]].value
        else:
            raise InvalidColumnTypeError

    fn get[S: FromSQL](self, idx: Some[RowIndex]) raises -> S:
        """Gets a value of type S from the specified column using generic type conversion.
        
        This is a generic method that can retrieve values of any supported type,
        making the API more ergonomic by eliminating the need for type-specific methods.
        
        Parameters:
            S: The type to convert the column value to. Supported types are:
               Int, Float64, String, and Bool.
        
        Args:
            idx: The column index (0-based).

        Returns:
            An Optional containing the value of type T, or None if the column is NULL.
            
        Raises:
            InvalidColumnIndexError: If the column index is out of bounds.
            Error: If the column value cannot be converted to type T.
        """
        var i = idx.idx(self.stmt[])
        return S(self.stmt[].value_ref(i))


struct Rows[statement: Origin, ptr: Origin](Copyable, Iterator, Movable):
    """An iterator over rows returned by a SQL query."""

    alias Element = Row[statement, ptr]

    var stmt: Pointer[Statement[statement], ptr]
    """A pointer to the statement that produces rows."""

    fn __init__(out self, stmt: Pointer[Statement[statement], ptr]):
        """Initializes a new Rows iterator.

        Args:
            stmt: A pointer to the statement that will produce rows.
        """
        self.stmt = stmt

    fn __has_next__(self) -> Bool:
        """Checks if there are more rows available.

        Returns:
            True if there are more rows to iterate over, False otherwise.
        """
        try:
            if self.stmt[].step():
                return True
            else:
                self.reset()
                return False
        except:
            return False

    fn __next__(mut self) -> Self.Element:
        """Returns the next row in the result set.

        Returns:
            The next Row object.
        """
        return Row(self.stmt)

    fn __iter__(self) -> Self:
        """Returns an iterator over the rows.

        Returns:
            Self as an iterator.
        """
        return self.copy()

    fn reset(self) -> None:
        """Resets the statement to allow re-iteration.

        This method resets the underlying statement so that iteration
        can begin again from the first row.
        """
        try:
            self.stmt[].reset()
        except e:
            print("Error resetting statement:", e)
            # TODO: come back to resetting this to avoid infinite loops
            # raise


struct MappedRows[
    T: Copyable & Movable,
    //,
    statement: Origin,
    ptr: Origin,
    transform: fn (Row) -> T](
    Copyable, Iterator, Movable
):
    """An iterator that transforms rows using a mapping function."""

    alias Element = T

    var rows: Rows[statement, ptr]
    """The underlying rows iterator."""

    fn __init__(out self, rows: Rows[statement, ptr]):
        """Initializes a new MappedRows iterator.

        Args:
            rows: The underlying rows iterator to transform.
        """
        self.rows = rows.copy()

    fn __has_next__(self) -> Bool:
        """Checks if there are more transformed rows available.

        Returns:
            True if there are more rows to iterate over, False otherwise.
        """
        return self.rows.__has_next__()

    fn __next__(mut self) -> T:
        """Returns the next transformed row.

        Returns:
            The next row transformed by the mapping function.
        """
        return transform(self.rows.__next__())

    fn __iter__(self) -> Self:
        """Returns an iterator over the transformed rows.

        Returns:
            Self as an iterator.
        """
        return self.copy()

    fn reset(self) -> None:
        """Resets the underlying rows iterator.

        This method resets the underlying rows iterator so that iteration
        can begin again from the first row.
        """
        self.rows.reset()
