from memory import UnsafeMutPointer
from slight.c.api import get_sqlite3_handle
from slight.bindings import sqlite3_connection
from slight.result import SQLite3Result


fn error_msg(db: ExternalMutPointer[sqlite3_connection], code: SQLite3Result) -> Optional[StringSlice[ImmutableAnyOrigin]]:
    """Checks for the error message set in sqlite3, or what the description of the provided code is.

    Args:
        db: The raw sqlite3 database connection pointer.
        code: The SQLite error code.

    Returns:
        An optional string slice containing the error message, or None if not found.
    """
    if not db or get_sqlite3_handle()[].errcode(db) != code:
        return get_sqlite3_handle()[].errstr(code.value)

    return get_sqlite3_handle()[].errmsg(db)


fn raise_if_error(db: ExternalMutPointer[sqlite3_connection], code: SQLite3Result) raises:
    """Raises if the SQLite error code is not `SQLITE_OK`.

    Args:
        db: The raw sqlite3 database connection pointer.
        code: The SQLite error code.

    Raises:
        Error: If the SQLite error code is not `SQLITE_OK`.
    """
    if SQLite3Result.SQLITE_OK == code:
        return

    raise Error(error_from_sqlite_code(code, error_msg(db, code)))


fn decode_error(db: ExternalMutPointer[sqlite3_connection], code: SQLite3Result) -> Error:
    """Returns an Error if the SQLite error code is not `SQLITE_OK`.

    Args:
        db: The raw sqlite3 database connection pointer.
        code: The SQLite error code.

    Returns:
        Error: If the SQLite error code is not `SQLITE_OK`.
    """
    return Error(error_from_sqlite_code(code, error_msg(db, code)))


fn error_from_sqlite_code(code: SQLite3Result, msg: Optional[StringSlice[ImmutableAnyOrigin]]) -> String:
    """Constructs an error message from the SQLite error code and message.

    Args:
        code: The SQLite error code.
        msg: An optional string slice containing the error message.

    Returns:
        A string containing the formatted error message.
    """
    if msg:
        return String("sqlite3 Error (", code.value, "): ", msg.value())
    return String(
        "sqlite3 Error (",
        code.value,
        "): Unknown error has occurred. The provided code was invalid and could not get the error via sqlite3 handle.",
    )
