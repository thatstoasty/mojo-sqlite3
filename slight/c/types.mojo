from memory import OpaquePointer
from utils import StaticTuple


alias __SVInt8_t = Int8
alias __SVInt16_t = Int16
alias __SVInt32_t = Int32
alias __SVInt64_t = Int64
alias __SVUint8_t = UInt8
alias __SVUint16_t = UInt16
alias __SVUint32_t = UInt32
alias __SVUint64_t = UInt64
alias __SVFloat16_t = Float16
alias __SVFloat32_t = Float32
alias __SVFloat64_t = Float64
alias __SVBfloat16_t = Float16
alias __SVMfloat8_t = Float16
alias __clang_svint8x2_t = SIMD[DType.int8, 2]
alias __clang_svint16x2_t = SIMD[DType.int16, 2]
alias __clang_svint32x2_t = SIMD[DType.int32, 2]
alias __clang_svint64x2_t = SIMD[DType.int64, 2]
alias __clang_svuint8x2_t = SIMD[DType.uint8, 2]
alias __clang_svuint16x2_t = SIMD[DType.uint16, 2]
alias __clang_svuint32x2_t = SIMD[DType.uint32, 2]
alias __clang_svuint64x2_t = SIMD[DType.uint64, 2]
alias __clang_svfloat16x2_t = SIMD[DType.float16, 2]
alias __clang_svfloat32x2_t = SIMD[DType.float32, 2]
alias __clang_svfloat64x2_t = SIMD[DType.float64, 2]
alias __clang_svbfloat16x2_t = SIMD[DType.bfloat16, 2]
# alias __clang_svmfloat8x2_t = SIMD[DType.mfloat16, 2]
alias __clang_svint8x3_t = SIMD[DType.int8, 3]
alias __clang_svint16x3_t = SIMD[DType.int16, 3]
alias __clang_svint32x3_t = SIMD[DType.int32, 3]
alias __clang_svint64x3_t = SIMD[DType.int64, 3]
alias __clang_svuint8x3_t = SIMD[DType.uint8, 3]
alias __clang_svuint16x3_t = SIMD[DType.uint16, 3]
alias __clang_svuint32x3_t = SIMD[DType.uint32, 3]
alias __clang_svuint64x3_t = SIMD[DType.uint64, 3]
alias __clang_svfloat16x3_t = SIMD[DType.float16, 3]
alias __clang_svfloat32x3_t = SIMD[DType.float32, 3]
alias __clang_svfloat64x3_t = SIMD[DType.float64, 3]
alias __clang_svbfloat16x3_t = SIMD[DType.bfloat16, 3]
# alias __clang_svmfloat8x3_t = __clang_svmfloat8x3_t
alias __clang_svint8x4_t = SIMD[DType.int8, 4]
alias __clang_svint16x4_t = SIMD[DType.int16, 4]
alias __clang_svint32x4_t = SIMD[DType.int32, 4]
alias __clang_svint64x4_t = SIMD[DType.int64, 4]
alias __clang_svuint8x4_t = SIMD[DType.uint8, 4]
alias __clang_svuint16x4_t = SIMD[DType.uint16, 4]
alias __clang_svuint32x4_t = SIMD[DType.uint32, 4]
alias __clang_svuint64x4_t = SIMD[DType.uint64, 4]
alias __clang_svfloat16x4_t = SIMD[DType.float16, 4]
alias __clang_svfloat32x4_t = SIMD[DType.float32, 4]
alias __clang_svfloat64x4_t = SIMD[DType.float64, 4]
alias __clang_svbfloat16x4_t = SIMD[DType.bfloat16, 4]
# alias __clang_svmfloat8x4_t = __clang_svmfloat8x4_t
alias __SVBool_t = Bool
alias __clang_svboolx2_t = SIMD[DType.bool, 2]
alias __clang_svboolx4_t = SIMD[DType.bool, 4]
# alias __SVCount_t = __SVCount_t
# alias __mfp8 = __mfp8
alias __builtin_ms_va_list = ExternalPointer[Int8]
alias __builtin_va_list = ExternalPointer[Int8]
# alias __gnuc_va_list =
# alias va_list =
alias sqlite3_version = ExternalPointer[Int8]  # Failed to parse array size # extern
# Run-Time Library Version Numbers
# KEYWORDS: sqlite3_version sqlite3_sourceid
#
# These interfaces provide the same information as the [SQLITE_VERSION],
# [SQLITE_VERSION_NUMBER], and [SQLITE_SOURCE_ID] C preprocessor macros
# but are associated with the library instead of the header file.  ^(Cautious
# programmers might include assert() statements in their application to
# verify that values returned by these interfaces match the macros in
# the header, and thus ensure that the application is
# compiled with matching library and header files.
#
#
# assert( sqlite3_libversion_number()==SQLITE_VERSION_NUMBER );
# assert( strncmp(sqlite3_sourceid(),SQLITE_SOURCE_ID,80)==0 );
# assert( strcmp(sqlite3_libversion(),SQLITE_VERSION)==0 );
#
# )^
#
# ^The sqlite3_version[] string constant contains the text of [SQLITE_VERSION]
# macro.  ^The sqlite3_libversion() function returns a pointer to the
# to the sqlite3_version[] string constant.  The sqlite3_libversion()
# function is provided for use in DLLs since DLL users usually do not have
# direct access to string constants within the DLL.  ^The
# sqlite3_libversion_number() function returns an integer equal to
# [SQLITE_VERSION_NUMBER].  ^(The sqlite3_sourceid() function returns
# a pointer to a string constant whose value is the same as the
# [SQLITE_SOURCE_ID] C preprocessor macro.  Except if SQLite is built
# using an edited copy of [the amalgamation], then the last four characters
# of the hash might be different from [SQLITE_SOURCE_ID].)^
#
# See also: [sqlite_version()] and [sqlite_source_id()].


alias sqlite_int64 = Int64
alias sqlite_uint64 = UInt64
alias sqlite3_int64 = Int64
alias sqlite3_uint64 = UInt64
alias sqlite3_callback = fn (
    ExternalPointer[NoneType], Int32, ExternalPointer[ExternalPointer[Int8]], ExternalPointer[ExternalPointer[Int8]]
) -> Int32
"""The type for a callback function. This is legacy and deprecated.  It is included for historical compatibility and is not documented."""
alias __int128_t = Int128
alias __uint128_t = UInt128

alias SQLITE_INTEGER: Int32 = 1
alias SQLITE_FLOAT: Int32 = 2
alias SQLITE_BLOB: Int32 = 4
alias SQLITE_NULL: Int32 = 5
alias SQLITE_TEXT: Int32 = 3
alias SQLITE3_TEXT: Int32 = 3
alias SQLITE_UTF8: Int32 = 1
alias SQLITE_UTF16LE: Int32 = 2
alias SQLITE_UTF16BE: Int32 = 3
alias SQLITE_UTF16: Int32 = 4
alias SQLITE_ANY: Int32 = 5


@register_passable("trivial")
struct __NSConstantString_tag(Copyable & Movable):
    pass


alias __NSConstantString = __NSConstantString_tag

alias sqlite3_filename = ExternalPointer[Int8]
"""Used by SQLite to pass filenames to the
xOpen method of a [VFS]. It may be cast to (const char) and treated
as a normal, nul-terminated, UTF-8 buffer containing the filename, but
may also be passed to special APIs such as:

sqlite3_filename_database()
sqlite3_filename_journal()
sqlite3_filename_wal()
sqlite3_uri_parameter()
sqlite3_uri_boolean()
sqlite3_uri_int64()
sqlite3_uri_key()
"""


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


@register_passable("trivial")
struct _sqlite3_file_sqlite3_io_methods(Copyable & Movable):
    pass


@register_passable("trivial")
struct sqlite3_file(Copyable & Movable):
    """OS Interface Open File Handle.

    An [sqlite3_file] object represents an open file in the
    [sqlite3_vfs | OS interface layer].  Individual OS interface
    implementations will
    want to subclass this object by appending additional fields
    for their own use.  The pMethods entry is a pointer to an
    [sqlite3_io_methods] object that defines methods for performing
    I/O operations on the open file.
    """

    var pMethods: ExternalPointer[_sqlite3_file_sqlite3_io_methods]


@register_passable("trivial")
struct sqlite3_mutex(Copyable & Movable):
    """Mutex Handle.

    The mutex module within SQLite defines [sqlite3_mutex] to be an
    abstract type for a mutex object.  The SQLite core never looks
    at the internal representation of an [sqlite3_mutex].  It only
    deals with pointers to the [sqlite3_mutex] object.

    Mutexes are created using [sqlite3_mutex_alloc()]."""

    pass


alias sqlite3_syscall_ptr = fn () -> NoneType

alias sqlite3_destructor_type = fn (OpaquePointer) -> NoneType
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


# To use these as destructors for libsqlite3, first create a pointer to the value.
# Then bitcast it to sqlite3_destructor_type. Then when calling sqlite3_bind_text or
# sqlite3_result_blob, pass the dereferenced pointer as the destructor argument.
alias SQLITE_STATIC = 0
alias SQLITE_TRANSIENT = -1


@register_passable("trivial")
struct Fts5PhraseIter(Copyable & Movable):
    var a: ExternalPointer[
        UInt8
    ]  # FieldDeclNode: This is a const param, but shouldn't be assigned as an alias since it doesn't have a value.
    var b: ExternalPointer[
        UInt8
    ]  # FieldDeclNode: This is a const param, but shouldn't be assigned as an alias since it doesn't have a value.


@register_passable("trivial")
struct Fts5ExtensionApi(Copyable & Movable):
    """CUSTOM AUXILIARY FUNCTIONS.

    Virtual table implementations may overload SQL functions by implementing
    the sqlite3_module.xFindFunction() method."""

    var iVersion: Int32
    var xUserData: fn (ExternalPointer[Fts5Context]) -> OpaquePointer
    var xColumnCount: fn (ExternalPointer[Fts5Context]) -> Int32
    var xRowCount: fn (ExternalPointer[Fts5Context], ExternalPointer[sqlite3_int64]) -> Int32
    var xColumnTotalSize: fn (ExternalPointer[Fts5Context], Int32, ExternalPointer[sqlite3_int64]) -> Int32
    # var xTokenize: fn(OpaquePointer, Int32, ExternalPointer[Int8], Int32, Int32, Int32) -> ExternalPointer[Fts5Context], ExternalPointer[Int8], Int32, OpaquePointer, Int32 -> Int32 # FieldDeclNode: This is a const param, but shouldn't be assigned as an alias since it doesn't have a value.
    var xPhraseCount: fn (ExternalPointer[Fts5Context]) -> Int32
    var xPhraseSize: fn (ExternalPointer[Fts5Context], Int32) -> Int32
    var xInstCount: fn (ExternalPointer[Fts5Context], ExternalPointer[Int32]) -> Int32
    var xInst: fn (
        ExternalPointer[Fts5Context], Int32, ExternalPointer[Int32], ExternalPointer[Int32], ExternalPointer[Int32]
    ) -> Int32
    var xRowid: fn (ExternalPointer[Fts5Context]) -> sqlite3_int64
    var xColumnText: fn (
        ExternalPointer[Fts5Context], Int32, ExternalPointer[ExternalPointer[Int8]], ExternalPointer[Int32]
    ) -> Int32  # FieldDeclNode: This is a const param, but shouldn't be assigned as an alias since it doesn't have a value.
    var xColumnSize: fn (ExternalPointer[Fts5Context], Int32, ExternalPointer[Int32]) -> Int32
    # var xQueryPhrase: fn(read ExternalPointer[Fts5ExtensionApi], ExternalPointer[Fts5Context], void ) -> ExternalPointer[Fts5Context], Int32, OpaquePointer, Int32 -> Int32
    # var xSetAuxdata: fn(void ) -> ExternalPointer[Fts5Context], OpaquePointer, NoneType -> Int32
    var xGetAuxdata: fn (ExternalPointer[Fts5Context], Int32) -> OpaquePointer
    var xPhraseFirst: fn (
        ExternalPointer[Fts5Context], Int32, ExternalPointer[Fts5PhraseIter], ExternalPointer[Int32], ExternalPointer[Int32]
    ) -> Int32
    var xPhraseNext: fn (
        ExternalPointer[Fts5Context], ExternalPointer[Fts5PhraseIter], ExternalPointer[Int32], ExternalPointer[Int32]
    ) -> NoneType
    var xPhraseFirstColumn: fn (
        ExternalPointer[Fts5Context], Int32, ExternalPointer[Fts5PhraseIter], ExternalPointer[Int32]
    ) -> Int32
    var xPhraseNextColumn: fn (
        ExternalPointer[Fts5Context], ExternalPointer[Fts5PhraseIter], ExternalPointer[Int32]
    ) -> NoneType
    var xQueryToken: fn (
        ExternalPointer[Fts5Context], Int32, Int32, ExternalPointer[ExternalPointer[Int8]], ExternalPointer[Int32]
    ) -> Int32  # FieldDeclNode: This is a const param, but shouldn't be assigned as an alias since it doesn't have a value.
    var xInstToken: fn (
        ExternalPointer[Fts5Context], Int32, Int32, ExternalPointer[ExternalPointer[Int8]], ExternalPointer[Int32]
    ) -> Int32  # FieldDeclNode: This is a const param, but shouldn't be assigned as an alias since it doesn't have a value.
    var xColumnLocale: fn (
        ExternalPointer[Fts5Context], Int32, ExternalPointer[ExternalPointer[Int8]], ExternalPointer[Int32]
    ) -> Int32  # FieldDeclNode: This is a const param, but shouldn't be assigned as an alias since it doesn't have a value.
    # var xTokenize_v2: fn(OpaquePointer, Int32, ExternalPointer[Int8], Int32, Int32, Int32) -> ExternalPointer[Fts5Context], ExternalPointer[Int8], Int32, ExternalPointer[Int8], Int32, OpaquePointer, Int32 -> Int32 # FieldDeclNode: This is a const param, but shouldn't be assigned as an alias since it doesn't have a value.


@register_passable("trivial")
struct Fts5Tokenizer(Copyable & Movable):
    """Applications may also register custom tokenizer types.
    
    A tokenizer is registered by providing fts5 with a populated instance of the
    following structure. All structure methods must be defined, setting
    any member of the fts5_tokenizer struct to NULL leads to undefined
    behaviour. The structure methods are expected to function as follows:
    xCreate:
    This function is used to allocate and initialize a tokenizer instance.
    A tokenizer instance is required to actually tokenize text.
    The first argument passed to this function is a copy of the (void)
    pointer provided by the application when the fts5_tokenizer_v2 object
    was registered with FTS5 (the third argument to xCreateTokenizer()).
    The second and third arguments are an array of nul-terminated strings
    containing the tokenizer arguments, if any, specified following the
    tokenizer name as part of the CREATE VIRTUAL TABLE statement used
    to create the FTS5 table.
    The final argument is an output variable. If successful, (ppOut)
    should be set to point to the new tokenizer handle and SQLITE_OK
    returned. If an error occurs, some value other than SQLITE_OK should
    be returned. In this case, fts5 assumes that the final value of ppOut
    is undefined.
    xDelete:
    This function is invoked to delete a tokenizer handle previously
    allocated using xCreate(). Fts5 guarantees that this function will
    be invoked exactly once for each successful call to xCreate().
    xTokenize:
    This function is expected to tokenize the nText byte string indicated
    by argument pText. pText may or may not be nul-terminated. The first
    argument passed to this function is a pointer to an Fts5Tokenizer object
    returned by an earlier call to xCreate().
    The third argument indicates the reason that FTS5 is requesting
    tokenization of the supplied text. This is always one of the following
    four values:

    FTS5_TOKENIZE_DOCUMENT
    - A document is being inserted into
            or removed from the FTS table. The tokenizer is being invoked to
            determine the set of tokens to add to (or delete from) the
            FTS index.

    FTS5_TOKENIZE_QUERY
    - A MATCH query is being executed
            against the FTS index. The tokenizer is being called to tokenize
            a bareword or quoted string specified as part of the query.

    (FTS5_TOKENIZE_QUERY | FTS5_TOKENIZE_PREFIX)
    - Same as
            FTS5_TOKENIZE_QUERY, except that the bareword or quoted string is
            followed by a "" character, indicating that the last token
            returned by the tokenizer will be treated as a token prefix.

    FTS5_TOKENIZE_AUX
    - The tokenizer is being invoked to
            satisfy an fts5_api.xTokenize() request made by an auxiliary
            function. Or an fts5_api.xColumnSize() request made by the same
            on a columnsize=0 database.

    The sixth and seventh arguments passed to xTokenize() - pLocale and
    nLocale - are a pointer to a buffer containing the locale to use for
    tokenization (e.g. "en_US") and its size in bytes, respectively. The
    pLocale buffer is not nul-terminated. pLocale may be passed NULL (in
    which case nLocale is always 0) to indicate that the tokenizer should
    use its default locale.
    For each token in the input string, the supplied callback xToken() must
    be invoked. The first argument to it should be a copy of the pointer
    passed as the second argument to xTokenize(). The third and fourth
    arguments are a pointer to a buffer containing the token text, and the
    size of the token in bytes. The 4th and 5th arguments are the byte offsets
    of the first byte of and first byte immediately following the text from
    which the token is derived within the input.
    The second argument passed to the xToken() callback ("tflags") should
    normally be set to 0. The exception is if the tokenizer supports
    synonyms. In this case see the discussion below for details.
    FTS5 assumes the xToken() callback is invoked for each token in the
    order that they occur within the input text.
    If an xToken() callback returns any value other than SQLITE_OK, then
    the tokenization should be abandoned and the xTokenize() method should
    immediately return a copy of the xToken() return value. Or, if the
    input buffer is exhausted, xTokenize() should return SQLITE_OK. Finally,
    if an error occurs with the xTokenize() implementation itself, it
    may abandon the tokenization and return any error code other than
    SQLITE_OK or SQLITE_DONE.
    If the tokenizer is registered using an fts5_tokenizer_v2 object,
    then the xTokenize() method has two additional arguments - pLocale
    and nLocale. These specify the locale that the tokenizer should use
    for the current request. If pLocale and nLocale are both 0, then the
    tokenizer should use its default locale. Otherwise, pLocale points to
    an nLocale byte buffer containing the name of the locale to use as utf-8
    text. pLocale is not nul-terminated.
    FTS5_TOKENIZER
    There is also an fts5_tokenizer object. This is an older, deprecated,
    version of fts5_tokenizer_v2. It is similar except that:

    There is no "iVersion" field, and
    The xTokenize() method does not take a locale argument.

    Legacy fts5_tokenizer tokenizers must be registered using the
    legacy xCreateTokenizer() function, instead of xCreateTokenizer_v2().
    Tokenizer implementations registered using either API may be retrieved
    using both xFindTokenizer() and xFindTokenizer_v2().
    SYNONYM SUPPORT
    Custom tokenizers may also support synonyms. Consider a case in which a
    user wishes to query for a phrase such as "first place". Using the
    built-in tokenizers, the FTS5 query ' first + place ' will match instances
    of "first place" within the document set, but not alternative forms
    such as "1st place". In some applications, it would be better to match
    all instances of "first place" or "1st place" regardless of which form
    the user specified in the MATCH query text.
    There are several ways to approach this in FTS5:

    By mapping all synonyms to a single token. In this case, using
            the above example, this means that the tokenizer returns the
            same token for inputs "first" and "1st". Say that token is in
            fact "first", so that when the user inserts the document "I won
            1st place" entries are added to the index for tokens "i", "won",
            "first" and "place". If the user then queries for ' 1st + place ' ,
            the tokenizer substitutes "first" for "1st" and the query works
            as expected.

    By querying the index for all synonyms of each query term
            separately. In this case, when tokenizing query text, the
            tokenizer may provide multiple synonyms for a single term
            within the document. FTS5 then queries the index for each
            synonym individually. For example, faced with the query:

    <codeblock
    >
        ... MATCH ' first place '
    </codeblock
    >
            the tokenizer offers both "1st" and "first" as synonyms for the
            first token in the MATCH query and FTS5 effectively runs a query
            similar to:

    <codeblock
    >
        ... MATCH ' (first OR 1st) place '
    </codeblock
    >
            except that, for the purposes of auxiliary functions, the query
            still appears to contain just two phrases - "(first OR 1st)"
            being treated as a single phrase.

    By adding multiple synonyms for a single term to the FTS index.
            Using this method, when tokenizing document text, the tokenizer
            provides multiple synonyms for each token. So that when a
            document such as "I won first place" is tokenized, entries are
            added to the FTS index for "i", "won", "first", "1st" and
            "place".
            This way, even if the tokenizer does not provide synonyms
            when tokenizing query text (it should not - to do so would be
            inefficient), it doesn ' t matter if the user queries for
            ' first + place ' or ' 1st + place ' , as there are entries in the
            FTS index corresponding to both forms of the first token.

    Whether it is parsing document or query text, any call to xToken that
    specifies a
    tflags
    argument with the FTS5_TOKEN_COLOCATED bit
    is considered to supply a synonym for the previous token. For example,
    when parsing the document "I won first place", a tokenizer that supports
    synonyms would call xToken() 5 times, as follows:

    <codeblock
    >
        xToken(pCtx, 0, "i",                      1,  0,  1);
        xToken(pCtx, 0, "won",                    3,  2,  5);
        xToken(pCtx, 0, "first",                  5,  6, 11);
        xToken(pCtx, FTS5_TOKEN_COLOCATED, "1st", 3,  6, 11);
        xToken(pCtx, 0, "place",                  5, 12, 17);
    </codeblock
    >
    It is an error to specify the FTS5_TOKEN_COLOCATED flag the first time
    xToken() is called. Multiple synonyms may be specified for a single token
    by making multiple calls to xToken(FTS5_TOKEN_COLOCATED) in sequence.
    There is no limit to the number of synonyms that may be provided for a
    single token.
    In many cases, method (1) above is the best approach. It does not add
    extra data to the FTS index or require FTS5 to query for multiple terms,
    so it is efficient in terms of disk space and query speed. However, it
    does not support prefix queries very well. If, as suggested above, the
    token "first" is substituted for "1st" by the tokenizer, then the query:

    <codeblock
    >
        ... MATCH ' 1s'
    </codeblock
    >
    will not match documents that contain the token "1st" (as the tokenizer
    will probably not map "1s" to any prefix of "first").
    For full prefix support, method (3) may be preferred. In this case,
    because the index contains entries for both "first" and "1st", prefix
    queries such as ' fi' or ' 1s' will match correctly. However, because
    extra entries are added to the FTS index, this method uses more space
    within the database.
    Method (2) offers a midpoint between (1) and (3). Using this method,
    a query such as ' 1s' will match documents that contain the literal
    token "1st", but not "first" (assuming the tokenizer is not able to
    provide synonyms for prefixes). However, a non-prefix query like ' 1st '
    will match against "1st" and "first". This method does not require
    extra disk space, as no extra entries are added to the FTS index.
    On the other hand, it may require more CPU cycles to run MATCH queries,
    as separate queries of the FTS index are required for each synonym.
    When using methods (2) or (3), it is important that the tokenizer only
    provide synonyms when tokenizing document text (method (3)) or query
    text (method (2)), not both. Doing so will not cause any errors, but is
    inefficient."""

    pass


@register_passable("trivial")
struct fts5_tokenizer_v2(Copyable & Movable):
    """New code should use the fts5_tokenizer_v2 type to define tokenizer
    implementations. The following type is included for legacy applications
    that still use it."""

    var iVersion: Int32
    var xCreate: fn (
        OpaquePointer, ExternalPointer[ExternalPointer[Int8]], Int32, ExternalPointer[ExternalPointer[Fts5Tokenizer]]
    ) -> Int32  # FieldDeclNode: This is a const param, but shouldn't be assigned as an alias since it doesn't have a value.
    var xDelete: fn (ExternalPointer[Fts5Tokenizer]) -> NoneType
    # var xTokenize: fn(OpaquePointer, Int32, ExternalPointer[Int8], Int32, Int32, Int32) -> (ExternalPointer[Fts5Tokenizer], OpaquePointer, Int32, ExternalPointer[Int8], Int32, ExternalPointer[Int8], Int32, Int32 -> Int32) # FieldDeclNode: This is a const param, but shouldn't be assigned as an alias since it doesn't have a value.


@register_passable("trivial")
struct fts5_tokenizer(Copyable & Movable):
    var xCreate: fn (
        OpaquePointer, ExternalPointer[ExternalPointer[Int8]], Int32, ExternalPointer[ExternalPointer[Fts5Tokenizer]]
    ) -> Int32  # FieldDeclNode: This is a const param, but shouldn't be assigned as an alias since it doesn't have a value.
    var xDelete: fn (ExternalPointer[Fts5Tokenizer]) -> NoneType
    # var xTokenize: fn(OpaquePointer, Int32, ExternalPointer[Int8], Int32, Int32, Int32)) -> ExternalPointer[Fts5Tokenizer], OpaquePointer, Int32, ExternalPointer[Int8], Int32, Int32 -> Int32 # FieldDeclNode: This is a const param, but shouldn't be assigned as an alias since it doesn't have a value.


@register_passable("trivial")
struct fts5_api(Copyable & Movable):
    """FTS5 EXTENSION REGISTRATION API."""

    var iVersion: Int32
    # var xCreateTokenizer: fn(void )) -> ExternalPointer[fts5_api], ExternalPointer[Int8], OpaquePointer, ExternalPointer[fts5_tokenizer], NoneType -> Int32 # FieldDeclNode: This is a const param, but shouldn't be assigned as an alias since it doesn't have a value.
    var xFindTokenizer: fn (
        ExternalPointer[fts5_api], ExternalPointer[Int8], ExternalPointer[OpaquePointer], ExternalPointer[fts5_tokenizer]
    ) -> Int32  # FieldDeclNode: This is a const param, but shouldn't be assigned as an alias since it doesn't have a value.
    # var xCreateFunction: fn(void )) -> ExternalPointer[fts5_api], ExternalPointer[Int8], OpaquePointer, fts5_extension_function, NoneType -> Int32 # FieldDeclNode: This is a const param, but shouldn't be assigned as an alias since it doesn't have a value.
    # var xCreateTokenizer_v2: fn(void )) -> ExternalPointer[fts5_api], ExternalPointer[Int8], OpaquePointer, ExternalPointer[fts5_tokenizer_v2], NoneType -> Int32 # FieldDeclNode: This is a const param, but shouldn't be assigned as an alias since it doesn't have a value.
    var xFindTokenizer_v2: fn (
        ExternalPointer[fts5_api],
        ExternalPointer[Int8],
        ExternalPointer[OpaquePointer],
        ExternalPointer[ExternalPointer[fts5_tokenizer_v2]],
    ) -> Int32  # FieldDeclNode: This is a const param, but shouldn't be assigned as an alias since it doesn't have a value.


# alias fts5_extension_function = fn(ExternalPointer[Fts5ExtensionApi],ExternalPointer[],ExternalPointer[],Int32,ExternalPointer[ExternalPointer[]]) -> NoneType


@register_passable("trivial")
struct sqlite3_rtree_query_info(Copyable & Movable):
    var pContext: OpaquePointer
    var nParam: Int32
    var aParam: ExternalPointer[sqlite3_rtree_dbl]
    var pUser: OpaquePointer
    var xDelUser: fn (OpaquePointer) -> NoneType
    var aCoord: ExternalPointer[sqlite3_rtree_dbl]
    var anQueue: ExternalPointer[UInt32]
    var nCoord: Int32
    var iLevel: Int32
    var mxLevel: Int32
    var iRowid: sqlite3_int64
    var rParentScore: sqlite3_rtree_dbl
    var eParentWithin: Int32
    var eWithin: Int32
    var rScore: sqlite3_rtree_dbl
    var apSqlParam: ExternalPointer[ExternalPointer[sqlite3_value]]


@register_passable("trivial")
struct Fts5Context(Copyable & Movable):
    pass


@register_passable("trivial")
struct sqlite3_rtree_geometry(Copyable & Movable):
    var pContext: OpaquePointer
    var nParam: Int32
    var aParam: ExternalPointer[sqlite3_rtree_dbl]
    var pUser: OpaquePointer
    var xDelUser: fn (OpaquePointer) -> NoneType


alias sqlite3_rtree_dbl = Float64


@register_passable("trivial")
struct sqlite3_pcache_methods(Copyable & Movable):
    """This is the obsolete pcache_methods object that has now been replaced
    by sqlite3_pcache_methods2.  This object is not used by SQLite.  It is
    retained in the header file for backwards compatibility only.
    """

    var pArg: OpaquePointer
    var xInit: fn (OpaquePointer) -> Int32
    var xShutdown: fn (OpaquePointer) -> NoneType
    var xCreate: fn (Int32, Int32) -> ExternalPointer[sqlite3_pcache]
    var xCachesize: fn (ExternalPointer[sqlite3_pcache], Int32) -> NoneType
    var xPagecount: fn (ExternalPointer[sqlite3_pcache]) -> Int32
    var xFetch: fn (ExternalPointer[sqlite3_pcache], UInt32, Int32) -> OpaquePointer
    var xUnpin: fn (ExternalPointer[sqlite3_pcache], OpaquePointer, Int32) -> NoneType
    var xRekey: fn (ExternalPointer[sqlite3_pcache], OpaquePointer, UInt32, UInt32) -> NoneType
    var xTruncate: fn (ExternalPointer[sqlite3_pcache], UInt32) -> NoneType
    var xDestroy: fn (ExternalPointer[sqlite3_pcache]) -> NoneType


@register_passable("trivial")
struct sqlite3_backup(Copyable & Movable):
    """Online Backup Object.

    The sqlite3_backup object records state information about an ongoing
    online backup operation.  ^The sqlite3_backup object is created by
    a call to [sqlite3_backup_init()] and is destroyed by a call to
    [sqlite3_backup_finish()].

    See Also: [Using the SQLite Online Backup API]"""

    pass


@register_passable("trivial")
struct sqlite3_snapshot(Copyable & Movable):
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


@register_passable("trivial")
struct sqlite3_mutex_methods(Copyable & Movable):
    """Mutex Methods Object.

    An instance of this structure defines the low-level routines
    used to allocate and use mutexes.

    Usually, the default mutex implementations provided by SQLite are
    sufficient, however the application has the option of substituting a custom
    implementation for specialized deployments or systems for which SQLite
    does not provide a suitable implementation. In this case, the application
    creates and populates an instance of this structure to pass
    to sqlite3_config() along with the [SQLITE_CONFIG_MUTEX] option.
    Additionally, an instance of this structure can be used as an
    output variable when querying the system for the current mutex
    implementation, using the [SQLITE_CONFIG_GETMUTEX] option.

    ^The xMutexInit method defined by this structure is invoked as
    part of system initialization by the sqlite3_initialize() function.
    ^The xMutexInit routine is called by SQLite exactly once for each
    effective call to [sqlite3_initialize()].

    ^The xMutexEnd method defined by this structure is invoked as
    part of system shutdown by the sqlite3_shutdown() function. The
    implementation of this method is expected to release all outstanding
    resources obtained by the mutex methods implementation, especially
    those obtained by the xMutexInit method.  ^The xMutexEnd()
    interface is invoked exactly once for each call to [sqlite3_shutdown()].

    ^(The remaining seven methods defined by this structure (xMutexAlloc,
    xMutexFree, xMutexEnter, xMutexTry, xMutexLeave, xMutexHeld and
    xMutexNotheld) implement the following interfaces (respectively):



    [sqlite3_mutex_alloc()]

    [sqlite3_mutex_free()]

    [sqlite3_mutex_enter()]

    [sqlite3_mutex_try()]

    [sqlite3_mutex_leave()]

    [sqlite3_mutex_held()]

    [sqlite3_mutex_notheld()]

    )^

    The only difference is that the public sqlite3_XXX functions enumerated
    above silently ignore any invocations that pass a NULL pointer instead
    of a valid mutex handle. The implementations of the methods defined
    by this structure are not required to handle this case. The results
    of passing a NULL pointer instead of a valid mutex handle are undefined
    (i.e. it is acceptable to provide an implementation that segfaults if
    it is passed a NULL pointer).

    The xMutexInit() method must be threadsafe.  It must be harmless to
    invoke xMutexInit() multiple times within the same process and without
    intervening calls to xMutexEnd().  Second and subsequent calls to
    xMutexInit() must be no-ops.

    xMutexInit() must not use SQLite memory allocation ([sqlite3_malloc()]
    and its associates).  Similarly, xMutexAlloc() must not use SQLite memory
    allocation for a static mutex.  ^However xMutexAlloc() may use SQLite
    memory allocation for a fast or recursive mutex.

    ^SQLite will invoke the xMutexEnd() method when [sqlite3_shutdown()] is
    called, but only if the prior call to xMutexInit returned SQLITE_OK.
    If xMutexInit fails in any way, it is expected to clean up after itself
    prior to returning."""

    var xMutexInit: fn () -> Int32
    var xMutexEnd: fn () -> Int32
    var xMutexAlloc: fn (Int32) -> ExternalPointer[sqlite3_mutex]
    var xMutexFree: fn (ExternalPointer[sqlite3_mutex]) -> NoneType
    var xMutexEnter: fn (ExternalPointer[sqlite3_mutex]) -> NoneType
    var xMutexTry: fn (ExternalPointer[sqlite3_mutex]) -> Int32
    var xMutexLeave: fn (ExternalPointer[sqlite3_mutex]) -> NoneType
    var xMutexHeld: fn (ExternalPointer[sqlite3_mutex]) -> Int32
    var xMutexNotheld: fn (ExternalPointer[sqlite3_mutex]) -> Int32


@register_passable("trivial")
struct sqlite3_str(Copyable & Movable):
    """Dynamic String Object.

    An instance of the sqlite3_str object contains a dynamically-sized
    string under construction.

    The lifecycle of an sqlite3_str object is as follows:


    ^The sqlite3_str object is created using [sqlite3_str_new()].

    ^Text is appended to the sqlite3_str object using various
    methods, such as [sqlite3_str_appendf()].

    ^The sqlite3_str object is destroyed and the string it created
    is returned using the [sqlite3_str_finish()] interface."""

    pass


@register_passable("trivial")
struct sqlite3_pcache(Copyable & Movable):
    """Custom Page Cache Object.

    The sqlite3_pcache type is opaque.  It is implemented by
    the pluggable module.  The SQLite core has no knowledge of
    its size or internal structure and never deals with the
    sqlite3_pcache object except by holding and passing pointers
    to the object.

    See [sqlite3_pcache_methods2] for additional information."""

    pass


@register_passable("trivial")
struct sqlite3_pcache_page(Copyable & Movable):
    """Custom Page Cache Object.

    The sqlite3_pcache_page object represents a single page in the
    page cache.  The page cache will allocate instances of this
    object.  Various methods of the page cache use pointers to instances
    of this object as parameters or as their return value.
    See [sqlite3_pcache_methods2] for additional information."""

    var pBuf: OpaquePointer
    var pExtra: OpaquePointer


@register_passable("trivial")
struct sqlite3_pcache_methods2(Copyable & Movable):
    """Application Defined Page Cache.

    ^(The [sqlite3_config]([SQLITE_CONFIG_PCACHE2], ...) interface can
    register an alternative page cache implementation by passing in an
    instance of the sqlite3_pcache_methods2 structure.)^
    In many applications, most of the heap memory allocated by
    SQLite is used for the page cache.
    By implementing a
    custom page cache using this API, an application can better control
    the amount of memory consumed by SQLite, the way in which
    that memory is allocated and released, and the policies used to
    determine exactly which parts of a database file are cached and for
    how long.

    The alternative page cache mechanism is an
    extreme measure that is only needed by the most demanding applications.
    The built-in page cache is recommended for most uses.

    ^(The contents of the sqlite3_pcache_methods2 structure are copied to an
    internal buffer by SQLite within the call to [sqlite3_config].  Hence
    the application may discard the parameter after the call to
    [sqlite3_config()] returns.)^

    [[the xInit() page cache method]]
    ^(The xInit() method is called once for each effective
    call to [sqlite3_initialize()])^
    (usually only once during the lifetime of the process). ^(The xInit()
    method is passed a copy of the sqlite3_pcache_methods2.pArg value.)^
    The intent of the xInit() method is to set up global data structures
    required by the custom page cache implementation.
    ^(If the xInit() method is NULL, then the
    built-in default page cache is used instead of the application defined
    page cache.)^

    [[the xShutdown() page cache method]]
    ^The xShutdown() method is called by [sqlite3_shutdown()].
    It can be used to clean up
    any outstanding resources before process shutdown, if required.
    ^The xShutdown() method may be NULL.

    ^SQLite automatically serializes calls to the xInit method,
    so the xInit method need not be threadsafe.  ^The
    xShutdown method is only called from [sqlite3_shutdown()] so it does
    not need to be threadsafe either.  All other methods must be threadsafe
    in multithreaded applications.

    ^SQLite will never invoke xInit() more than once without an intervening
    call to xShutdown().

    [[the xCreate() page cache methods]]
    ^SQLite invokes the xCreate() method to construct a new cache instance.
    SQLite will typically create one cache instance for each open database file,
    though this is not guaranteed. ^The
    first parameter, szPage, is the size in bytes of the pages that must
    be allocated by the cache.  ^szPage will always be a power of two.  ^The
    second parameter szExtra is a number of bytes of extra storage
    associated with each page cache entry.  ^The szExtra parameter will be
    a number less than 250.  SQLite will use the
    extra szExtra bytes on each page to store metadata about the underlying
    database page on disk.  The value passed into szExtra depends
    on the SQLite version, the target platform, and how SQLite was compiled.
    ^The third argument to xCreate(), bPurgeable, is true if the cache being
    created will be used to cache database pages of a file stored on disk, or
    false if it is used for an in-memory database. The cache implementation
    does not have to do anything special based upon the value of bPurgeable;
    it is purely advisory.  ^On a cache where bPurgeable is false, SQLite will
    never invoke xUnpin() except to deliberately delete a page.
    ^In other words, calls to xUnpin() on a cache with bPurgeable set to
    false will always have the "discard" flag set to true.
    ^Hence, a cache created with bPurgeable set to false will
    never contain any unpinned pages.

    [[the xCachesize() page cache method]]
    ^(The xCachesize() method may be called at any time by SQLite to set the
    suggested maximum cache-size (number of pages stored) for the cache
    instance passed as the first argument. This is the value configured using
    the SQLite "[PRAGMA cache_size]" command.)^  As with the bPurgeable
    parameter, the implementation is not required to do anything with this
    value; it is advisory only.

    [[the xPagecount() page cache methods]]
    The xPagecount() method must return the number of pages currently
    stored in the cache, both pinned and unpinned.

    [[the xFetch() page cache methods]]
    The xFetch() method locates a page in the cache and returns a pointer to
    an sqlite3_pcache_page object associated with that page, or a NULL pointer.
    The pBuf element of the returned sqlite3_pcache_page object will be a
    pointer to a buffer of szPage bytes used to store the content of a
    single database page.  The pExtra element of sqlite3_pcache_page will be
    a pointer to the szExtra bytes of extra storage that SQLite has requested
    for each entry in the page cache.

    The page to be fetched is determined by the key. ^The minimum key value
    is 1.  After it has been retrieved using xFetch, the page is considered
    to be "pinned".

    If the requested page is already in the page cache, then the page cache
    implementation must return a pointer to the page buffer with its content
    intact.  If the requested page is not already in the cache, then the
    cache implementation should use the value of the createFlag
    parameter to help it determine what action to take:


    1 width=85% align=center>

    createFlag
    Behavior when page is not already in cache

    0
    Do not allocate a new page.  Return NULL.

    1
    Allocate a new page if it is easy and convenient to do so.
                    Otherwise return NULL.

    2
    Make every effort to allocate a new page.  Only return
                    NULL if allocating a new page is effectively impossible.


    ^(SQLite will normally invoke xFetch() with a createFlag of 0 or 1.  SQLite
    will only use a createFlag of 2 after a prior call with a createFlag of 1
    failed.)^  In between the xFetch() calls, SQLite may
    attempt to unpin one or more cache pages by spilling the content of
    pinned pages to disk and synching the operating system disk cache.

    [[the xUnpin() page cache method]]
    ^xUnpin() is called by SQLite with a pointer to a currently pinned page
    as its second argument.  If the third parameter, discard, is non-zero,
    then the page must be evicted from the cache.
    ^If the discard parameter is
    zero, then the page may be discarded or retained at the discretion of the
    page cache implementation. ^The page cache implementation
    may choose to evict unpinned pages at any time.

    The cache must not perform any reference counting. A single
    call to xUnpin() unpins the page regardless of the number of prior calls
    to xFetch().

    [[the xRekey() page cache methods]]
    The xRekey() method is used to change the key value associated with the
    page passed as the second argument. If the cache
    previously contains an entry associated with newKey, it must be
    discarded. ^Any prior cache entry associated with newKey is guaranteed not
    to be pinned.

    When SQLite calls the xTruncate() method, the cache must discard all
    existing cache entries with page numbers (keys) greater than or equal
    to the value of the iLimit parameter passed to xTruncate(). If any
    of these pages are pinned, they become implicitly unpinned, meaning that
    they can be safely discarded.

    [[the xDestroy() page cache method]]
    ^The xDestroy() method is used to delete a cache allocated by xCreate().
    All resources associated with the specified cache should be freed. ^After
    calling the xDestroy() method, SQLite considers the [sqlite3_pcache]
    handle invalid, and will not use it with any other sqlite3_pcache_methods2
    functions.

    [[the xShrink() page cache method]]
    ^SQLite invokes the xShrink() method when it wants the page cache to
    free up as much of heap memory as possible.  The page cache implementation
    is not obligated to free any memory, but well-behaved implementations should
    do their best."""

    var iVersion: Int32
    var pArg: OpaquePointer
    var xInit: fn (OpaquePointer) -> Int32
    var xShutdown: fn (OpaquePointer) -> NoneType
    var xCreate: fn (Int32, Int32, Int32) -> ExternalPointer[sqlite3_pcache]
    var xCachesize: fn (ExternalPointer[sqlite3_pcache], Int32) -> NoneType
    var xPagecount: fn (ExternalPointer[sqlite3_pcache]) -> Int32
    var xFetch: fn (ExternalPointer[sqlite3_pcache], UInt32, Int32) -> ExternalPointer[sqlite3_pcache_page]
    var xUnpin: fn (ExternalPointer[sqlite3_pcache], ExternalPointer[sqlite3_pcache_page], Int32) -> NoneType
    var xRekey: fn (ExternalPointer[sqlite3_pcache], ExternalPointer[sqlite3_pcache_page], UInt32, UInt32) -> NoneType
    var xTruncate: fn (ExternalPointer[sqlite3_pcache], UInt32) -> NoneType
    var xDestroy: fn (ExternalPointer[sqlite3_pcache]) -> NoneType
    var xShrink: fn (ExternalPointer[sqlite3_pcache]) -> NoneType


@register_passable("trivial")
struct sqlite3_io_methods(Copyable & Movable):
    """OS Interface File Virtual Methods Object.

    Every file opened by the [sqlite3_vfs.xOpen] method populates an
    [sqlite3_file] object (or, more commonly, a subclass of the
    [sqlite3_file] object) with a pointer to an instance of this object.
    This object defines the methods used to perform various operations
    against the open file represented by the [sqlite3_file] object.
    If the [sqlite3_vfs.xOpen] method sets the sqlite3_file.pMethods element
    to a non-NULL pointer, then the sqlite3_io_methods.xClose method
    may be invoked even if the [sqlite3_vfs.xOpen] reported that it failed.  The
    only way to prevent a call to xClose following a failed [sqlite3_vfs.xOpen]
    is for the [sqlite3_vfs.xOpen] to set the sqlite3_file.pMethods element
    to NULL.
    The flags argument to xSync may be one of [SQLITE_SYNC_NORMAL] or
    [SQLITE_SYNC_FULL].  The first choice is the normal fsync().
    The second choice is a Mac OS X style fullsync.  The [SQLITE_SYNC_DATAONLY]
    flag may be ORed in to indicate that only the data of the file
    and not its inode needs to be synced.
    The integer values to xLock() and xUnlock() are one of

    [SQLITE_LOCK_NONE],
    [SQLITE_LOCK_SHARED],
    [SQLITE_LOCK_RESERVED],
    [SQLITE_LOCK_PENDING], or
    [SQLITE_LOCK_EXCLUSIVE].
    xLock() upgrades the database file lock.  In other words, xLock() moves the
    database file lock in the direction NONE toward EXCLUSIVE. The argument to
    xLock() is always one of SHARED, RESERVED, PENDING, or EXCLUSIVE, never
    SQLITE_LOCK_NONE.  If the database file lock is already at or above the
    requested lock, then the call to xLock() is a no-op.
    xUnlock() downgrades the database file lock to either SHARED or NONE.
    If the lock is already at or below the requested lock state, then the call
    to xUnlock() is a no-op.
    The xCheckReservedLock() method checks whether any database connection,
    either in this process or in some other process, is holding a RESERVED,
    PENDING, or EXCLUSIVE lock on the file.  It returns, via its output
    pointer parameter, true if such a lock exists and false otherwise.
    The xFileControl() method is a generic interface that allows custom
    VFS implementations to directly control an open file using the
    [sqlite3_file_control()] interface.  The second "op" argument is an
    integer opcode.  The third argument is a generic pointer intended to
    point to a structure that may contain arguments or space in which to
    write return values.  Potential uses for xFileControl() might be
    functions to enable blocking locks with timeouts, to change the
    locking strategy (for example to use dot-file locks), to inquire
    about the status of a lock, or to break stale locks.  The SQLite
    core reserves all opcodes less than 100 for its own use.
    A [file control opcodes | list of opcodes] less than 100 is available.
    Applications that define a custom xFileControl method should use opcodes
    greater than 100 to avoid conflicts.  VFS implementations should
    return [SQLITE_NOTFOUND] for file control opcodes that they do not
    recognize.
    The xSectorSize() method returns the sector size of the
    device that underlies the file.  The sector size is the
    minimum write that can be performed without disturbing
    other bytes in the file.  The xDeviceCharacteristics()
    method returns a bit vector describing behaviors of the
    underlying device:
    [SQLITE_IOCAP_ATOMIC]
    [SQLITE_IOCAP_ATOMIC512]
    [SQLITE_IOCAP_ATOMIC1K]
    [SQLITE_IOCAP_ATOMIC2K]
    [SQLITE_IOCAP_ATOMIC4K]
    [SQLITE_IOCAP_ATOMIC8K]
    [SQLITE_IOCAP_ATOMIC16K]
    [SQLITE_IOCAP_ATOMIC32K]
    [SQLITE_IOCAP_ATOMIC64K]
    [SQLITE_IOCAP_SAFE_APPEND]
    [SQLITE_IOCAP_SEQUENTIAL]
    [SQLITE_IOCAP_UNDELETABLE_WHEN_OPEN]
    [SQLITE_IOCAP_POWERSAFE_OVERWRITE]
    [SQLITE_IOCAP_IMMUTABLE]
    [SQLITE_IOCAP_BATCH_ATOMIC]
    [SQLITE_IOCAP_SUBPAGE_READ]

    The SQLITE_IOCAP_ATOMIC property means that all writes of
    any size are atomic.  The SQLITE_IOCAP_ATOMICnnn values
    mean that writes of blocks that are nnn bytes in size and
    are aligned to an address which is an integer multiple of
    nnn are atomic.  The SQLITE_IOCAP_SAFE_APPEND value means
    that when data is appended to a file, the data is appended
    first then the size of the file is extended, never the other
    way around.  The SQLITE_IOCAP_SEQUENTIAL property means that
    information is written to disk in the same order as calls
    to xWrite().
    If xRead() returns SQLITE_IOERR_SHORT_READ it must also fill
    in the unread portions of the buffer with zeros.  A VFS that
    fails to zero-fill short reads might seem to work.  However,
    failure to zero-fill short reads will eventually lead to
    database corruption."""

    var iVersion: Int32
    var xClose: fn (ExternalPointer[sqlite3_file]) -> Int32
    var xRead: fn (ExternalPointer[sqlite3_file], OpaquePointer, Int32, sqlite3_int64) -> Int32
    var xWrite: fn (
        ExternalPointer[sqlite3_file], OpaquePointer, Int32, sqlite3_int64
    ) -> Int32  # FieldDeclNode: This is a const param, but shouldn't be assigned as an alias since it doesn't have a value.
    var xTruncate: fn (ExternalPointer[sqlite3_file], sqlite3_int64) -> Int32
    var xSync: fn (ExternalPointer[sqlite3_file], Int32) -> Int32
    var xFileSize: fn (ExternalPointer[sqlite3_file], ExternalPointer[sqlite3_int64]) -> Int32
    var xLock: fn (ExternalPointer[sqlite3_file], Int32) -> Int32
    var xUnlock: fn (ExternalPointer[sqlite3_file], Int32) -> Int32
    var xCheckReservedLock: fn (ExternalPointer[sqlite3_file], ExternalPointer[Int32]) -> Int32
    var xFileControl: fn (ExternalPointer[sqlite3_file], Int32, OpaquePointer) -> Int32
    var xSectorSize: fn (ExternalPointer[sqlite3_file]) -> Int32
    var xDeviceCharacteristics: fn (ExternalPointer[sqlite3_file]) -> Int32
    var xShmMap: fn (ExternalPointer[sqlite3_file], Int32, Int32, Int32, ExternalPointer[OpaquePointer]) -> Int32
    var xShmLock: fn (ExternalPointer[sqlite3_file], Int32, Int32, Int32) -> Int32
    var xShmBarrier: fn (ExternalPointer[sqlite3_file]) -> NoneType
    var xShmUnmap: fn (ExternalPointer[sqlite3_file], Int32) -> Int32
    var xFetch: fn (ExternalPointer[sqlite3_file], sqlite3_int64, Int32, ExternalPointer[OpaquePointer]) -> Int32
    var xUnfetch: fn (ExternalPointer[sqlite3_file], sqlite3_int64, OpaquePointer) -> Int32


@register_passable("trivial")
struct sqlite3_api_routines(Copyable & Movable):
    """Loadable Extension Thunk.
    A pointer to the opaque sqlite3_api_routines structure is passed as
    the third parameter to entry points of [loadable extensions].  This
    structure must be typedefed in order to work around compiler warnings
    on some platforms."""

    pass


@register_passable("trivial")
struct sqlite3_vfs(Copyable & Movable):
    """OS Interface Object.

    An instance of the sqlite3_vfs object defines the interface between
    the SQLite core and the underlying operating system.  The "vfs"
    in the name of the object stands for "virtual file system".  See
    the [VFS | VFS documentation] for further information.
    The VFS interface is sometimes extended by adding new methods onto
    the end.  Each time such an extension occurs, the iVersion field
    is incremented.  The iVersion value started out as 1 in
    SQLite [version 3.5.0] on [dateof:3.5.0], then increased to 2
    with SQLite [version 3.7.0] on [dateof:3.7.0], and then increased
    to 3 with SQLite [version 3.7.6] on [dateof:3.7.6].  Additional fields
    may be appended to the sqlite3_vfs object and the iVersion value
    may increase again in future versions of SQLite.
    Note that due to an oversight, the structure
    of the sqlite3_vfs object changed in the transition from
    SQLite [version 3.5.9] to [version 3.6.0] on [dateof:3.6.0]
    and yet the iVersion field was not increased.
    The szOsFile field is the size of the subclassed [sqlite3_file]
    structure used by this VFS.  mxPathname is the maximum length of
    a pathname in this VFS.
    Registered sqlite3_vfs objects are kept on a linked list formed by
    the pNext pointer.  The [sqlite3_vfs_register()]
    and [sqlite3_vfs_unregister()] interfaces manage this list
    in a thread-safe way.  The [sqlite3_vfs_find()] interface
    searches the list.  Neither the application code nor the VFS
    implementation should use the pNext pointer.
    The pNext field is the only field in the sqlite3_vfs
    structure that SQLite will ever modify.  SQLite will only access
    or modify this field while holding a particular static mutex.
    The application should never modify anything within the sqlite3_vfs
    object once the object has been registered.
    The zName field holds the name of the VFS module.  The name must
    be unique across all VFS modules.
    [[sqlite3_vfs.xOpen]]
    ^SQLite guarantees that the zFilename parameter to xOpen
    is either a NULL pointer or string obtained
    from xFullPathname() with an optional suffix added.
    ^If a suffix is added to the zFilename parameter, it will
    consist of a single "-" character followed by no more than
    11 alphanumeric and/or "-" characters.
    ^SQLite further guarantees that
    the string will be valid and unchanged until xClose() is
    called. Because of the previous sentence,
    the [sqlite3_file] can safely store a pointer to the
    filename if it needs to remember the filename for some reason.
    If the zFilename parameter to xOpen is a NULL pointer then xOpen
    must invent its own temporary name for the file.  ^Whenever the
    xFilename parameter is NULL it will also be the case that the
    flags parameter will include [SQLITE_OPEN_DELETEONCLOSE].
    The flags argument to xOpen() includes all bits set in
    the flags argument to [sqlite3_open_v2()].  Or if [sqlite3_open()]
    or [sqlite3_open16()] is used, then flags includes at least
    [SQLITE_OPEN_READWRITE] | [SQLITE_OPEN_CREATE].
    If xOpen() opens a file read-only then it sets pOutFlags to
    include [SQLITE_OPEN_READONLY].  Other bits in pOutFlags may be set.
    ^(SQLite will also add one of the following flags to the xOpen()
    call, depending on the object being opened:
     [SQLITE_OPEN_MAIN_DB]
     [SQLITE_OPEN_MAIN_JOURNAL]
     [SQLITE_OPEN_TEMP_DB]
     [SQLITE_OPEN_TEMP_JOURNAL]
     [SQLITE_OPEN_TRANSIENT_DB]
     [SQLITE_OPEN_SUBJOURNAL]
     [SQLITE_OPEN_SUPER_JOURNAL]
     [SQLITE_OPEN_WAL]
    )^
    The file I/O implementation can use the object type flags to
    change the way it deals with files.  For example, an application
    that does not care about crash recovery or rollback might make
    the open of a journal file a no-op.  Writes to this journal would
    also be no-ops, and any attempt to read the journal would return
    SQLITE_IOERR.  Or the implementation might recognize that a database
    file will be doing page-aligned sector reads and writes in a random
    order and set up its I/O subsystem accordingly.
    SQLite might also add one of the following flags to the xOpen method:
    [SQLITE_OPEN_DELETEONCLOSE]
    [SQLITE_OPEN_EXCLUSIVE]

    The [SQLITE_OPEN_DELETEONCLOSE] flag means the file should be
    deleted when it is closed.  ^The [SQLITE_OPEN_DELETEONCLOSE]
    will be set for TEMP databases and their journals, transient
    databases, and subjournals.
    ^The [SQLITE_OPEN_EXCLUSIVE] flag is always used in conjunction
    with the [SQLITE_OPEN_CREATE] flag, which are both directly
    analogous to the O_EXCL and O_CREAT flags of the POSIX open()
    API.  The SQLITE_OPEN_EXCLUSIVE flag, when paired with the
    SQLITE_OPEN_CREATE, is used to indicate that file should always
    be created, and that it is an error if it already exists.
    It is
    not
    used to indicate the file should be opened
    for exclusive access.
    ^At least szOsFile bytes of memory are allocated by SQLite
    to hold the [sqlite3_file] structure passed as the third
    argument to xOpen.  The xOpen method does not have to
    allocate the structure; it should just fill it in.  Note that
    the xOpen method must set the sqlite3_file.pMethods to either
    a valid [sqlite3_io_methods] object or to NULL.  xOpen must do
    this even if the open fails.  SQLite expects that the sqlite3_file.pMethods
    element will be valid after xOpen returns regardless of the success
    or failure of the xOpen call.
    [[sqlite3_vfs.xAccess]]
    ^The flags argument to xAccess() may be [SQLITE_ACCESS_EXISTS]
    to test for the existence of a file, or [SQLITE_ACCESS_READWRITE] to
    test whether a file is readable and writable, or [SQLITE_ACCESS_READ]
    to test whether a file is at least readable.  The SQLITE_ACCESS_READ
    flag is never actually used and is not implemented in the built-in
    VFSes of SQLite.  The file is named by the second argument and can be a
    directory. The xAccess method returns [SQLITE_OK] on success or some
    non-zero error code if there is an I/O error or if the name of
    the file given in the second argument is illegal.  If SQLITE_OK
    is returned, then non-zero or zero is written into pResOut to indicate
    whether or not the file is accessible.
    ^SQLite will always allocate at least mxPathname+1 bytes for the
    output buffer xFullPathname.  The exact size of the output buffer
    is also passed as a parameter to both  methods. If the output buffer
    is not large enough, [SQLITE_CANTOPEN] should be returned. Since this is
    handled as a fatal error by SQLite, vfs implementations should endeavor
    to prevent this by setting mxPathname to a sufficiently large value.
    The xRandomness(), xSleep(), xCurrentTime(), and xCurrentTimeInt64()
    interfaces are not strictly a part of the filesystem, but they are
    included in the VFS structure for completeness.
    The xRandomness() function attempts to return nBytes bytes
    of good-quality randomness into zOut.  The return value is
    the actual number of bytes of randomness obtained.
    The xSleep() method causes the calling thread to sleep for at
    least the number of microseconds given.  ^The xCurrentTime()
    method returns a Julian Day Number for the current date and time as
    a floating point value.
    ^The xCurrentTimeInt64() method returns, as an integer, the Julian
    Day Number multiplied by 86400000 (the number of milliseconds in
    a 24-hour day).
    ^SQLite will use the xCurrentTimeInt64() method to get the current
    date and time if that method is available (if iVersion is 2 or
    greater and the function pointer is not NULL) and will fall back
    to xCurrentTime() if xCurrentTimeInt64() is unavailable.
    ^The xSetSystemCall(), xGetSystemCall(), and xNestSystemCall() interfaces
    are not used by the SQLite core.  These optional interfaces are provided
    by some VFSes to facilitate testing of the VFS code. By overriding
    system calls with functions under its control, a test program can
    simulate faults and error conditions that would otherwise be difficult
    or impossible to induce.  The set of system calls that can be overridden
    varies from one VFS to another, and from one version of the same VFS to the
    next.  Applications that use these interfaces must be prepared for any
    or all of these interfaces to be NULL or for their behavior to change
    from one release to the next.  Applications must not attempt to access
    any of these methods if the iVersion of the VFS is less than 3."""

    var iVersion: Int32
    var szOsFile: Int32
    var mxPathname: Int32
    var pNext: ExternalPointer[sqlite3_vfs]
    var zName: ExternalPointer[
        Int8
    ]  # FieldDeclNode: This is a const param, but shouldn't be assigned as an alias since it doesn't have a value.
    var pAppData: OpaquePointer
    var xOpen: fn (
        ExternalPointer[sqlite3_vfs], sqlite3_filename, ExternalPointer[sqlite3_file], Int32, ExternalPointer[Int32]
    ) -> Int32
    var xDelete: fn (
        ExternalPointer[sqlite3_vfs], ExternalPointer[Int8], Int32
    ) -> Int32  # FieldDeclNode: This is a const param, but shouldn't be assigned as an alias since it doesn't have a value.
    var xAccess: fn (
        ExternalPointer[sqlite3_vfs], ExternalPointer[Int8], Int32, ExternalPointer[Int32]
    ) -> Int32  # FieldDeclNode: This is a const param, but shouldn't be assigned as an alias since it doesn't have a value.
    var xFullPathname: fn (
        ExternalPointer[sqlite3_vfs], ExternalPointer[Int8], Int32, ExternalPointer[Int8]
    ) -> Int32  # FieldDeclNode: This is a const param, but shouldn't be assigned as an alias since it doesn't have a value.
    var xDlOpen: fn (
        ExternalPointer[sqlite3_vfs], ExternalPointer[Int8]
    ) -> OpaquePointer  # FieldDeclNode: This is a const param, but shouldn't be assigned as an alias since it doesn't have a value.
    var xDlError: fn (ExternalPointer[sqlite3_vfs], Int32, ExternalPointer[Int8]) -> NoneType
    # var xDlSym: fn(ExternalPointer[sqlite3_vfs], OpaquePointer, char ))(void) -> ExternalPointer[void (] # FieldDeclNode: This is a const param, but shouldn't be assigned as an alias since it doesn't have a value.
    var xDlClose: fn (ExternalPointer[sqlite3_vfs], OpaquePointer) -> NoneType
    var xRandomness: fn (ExternalPointer[sqlite3_vfs], Int32, ExternalPointer[Int8]) -> Int32
    var xSleep: fn (ExternalPointer[sqlite3_vfs], Int32) -> Int32
    var xCurrentTime: fn (ExternalPointer[sqlite3_vfs], ExternalPointer[Float64]) -> Int32
    var xGetLastError: fn (ExternalPointer[sqlite3_vfs], Int32, ExternalPointer[Int8]) -> Int32
    var xCurrentTimeInt64: fn (ExternalPointer[sqlite3_vfs], ExternalPointer[sqlite3_int64]) -> Int32
    var xSetSystemCall: fn (
        ExternalPointer[sqlite3_vfs], ExternalPointer[Int8], sqlite3_syscall_ptr
    ) -> Int32  # FieldDeclNode: This is a const param, but shouldn't be assigned as an alias since it doesn't have a value.
    var xGetSystemCall: fn (
        ExternalPointer[sqlite3_vfs], ExternalPointer[Int8]
    ) -> sqlite3_syscall_ptr  # FieldDeclNode: This is a const param, but shouldn't be assigned as an alias since it doesn't have a value.
    var xNextSystemCall: fn (ExternalPointer[sqlite3_vfs], ExternalPointer[Int8]) -> ExternalPointer[
        Int8
    ]  # FieldDeclNode: This is a const param, but shouldn't be assigned as an alias since it doesn't have a value.


@register_passable("trivial")
struct sqlite3_mem_methods(Copyable & Movable):
    """Memory Allocation Routines.
    An instance of this object defines the interface between SQLite
    and low-level memory allocation routines.
    This object is used in only one place in the SQLite interface.
    A pointer to an instance of this object is the argument to
    [sqlite3_config()] when the configuration option is
    [SQLITE_CONFIG_MALLOC] or [SQLITE_CONFIG_GETMALLOC].
    By creating an instance of this object
    and passing it to [sqlite3_config]([SQLITE_CONFIG_MALLOC])
    during configuration, an application can specify an alternative
    memory allocation subsystem for SQLite to use for all of its
    dynamic memory needs.
    Note that SQLite comes with several [built-in memory allocators]
    that are perfectly adequate for the overwhelming majority of applications
    and that this object is only useful to a tiny minority of applications
    with specialized memory allocation requirements.  This object is
    also used during testing of SQLite in order to specify an alternative
    memory allocator that simulates memory out-of-memory conditions in
    order to verify that SQLite recovers gracefully from such
    conditions.
    The xMalloc, xRealloc, and xFree methods must work like the
    malloc(), realloc() and free() functions from the standard C library.
    ^SQLite guarantees that the second argument to
    xRealloc is always a value returned by a prior call to xRoundup.
    xSize should return the allocated size of a memory allocation
    previously obtained from xMalloc or xRealloc.  The allocated size
    is always at least as big as the requested size but may be larger.
    The xRoundup method returns what would be the allocated size of
    a memory allocation given a particular requested size.  Most memory
    allocators round up memory allocations at least to the next multiple
    of 8.  Some allocators round up to a larger multiple or to a power of 2.
    Every memory allocation request coming in through [sqlite3_malloc()]
    or [sqlite3_realloc()] first calls xRoundup.  If xRoundup returns 0,
    that causes the corresponding memory allocation to fail.
    The xInit method initializes the memory allocator.  For example,
    it might allocate any required mutexes or initialize internal data
    structures.  The xShutdown method is invoked (indirectly) by
    [sqlite3_shutdown()] and should deallocate any resources acquired
    by xInit.  The pAppData pointer is used as the only parameter to
    xInit and xShutdown.
    SQLite holds the [SQLITE_MUTEX_STATIC_MAIN] mutex when it invokes
    the xInit method, so the xInit method need not be threadsafe.  The
    xShutdown method is only called from [sqlite3_shutdown()] so it does
    not need to be threadsafe either.  For all other methods, SQLite
    holds the [SQLITE_MUTEX_STATIC_MEM] mutex as long as the
    [SQLITE_CONFIG_MEMSTATUS] configuration option is turned on (which
    it is by default) and so the methods are automatically serialized.
    However, if [SQLITE_CONFIG_MEMSTATUS] is disabled, then the other
    methods must be threadsafe or else make their own arrangements for
    serialization.
    SQLite will never invoke xInit() more than once without an intervening
    call to xShutdown()."""

    var xMalloc: fn (Int32) -> OpaquePointer
    var xFree: fn (OpaquePointer) -> NoneType
    var xRealloc: fn (OpaquePointer, Int32) -> OpaquePointer
    var xSize: fn (OpaquePointer) -> Int32
    var xRoundup: fn (Int32) -> Int32
    var xInit: fn (OpaquePointer) -> Int32
    var xShutdown: fn (OpaquePointer) -> NoneType
    var pAppData: OpaquePointer


@register_passable("trivial")
struct sqlite3_stmt(Copyable & Movable):
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


@register_passable("trivial")
struct sqlite3_value(Copyable & Movable):
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


@register_passable("trivial")
struct sqlite3_context(Copyable & Movable):
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


alias sqlite3_temp_directory = Int8
"""Name Of The Folder Holding Temporary Files
^(If this global variable is made to point to a string which is
the name of a folder (a.k.a. directory), then all temporary files
created by SQLite when using a built-in [sqlite3_vfs | VFS]
will be placed in that directory.)^  ^If this variable
is a NULL pointer, then SQLite performs a search for an appropriate
temporary file directory.
Applications are strongly discouraged from using this global variable.
It is required to set a temporary folder on Windows Runtime (WinRT).
But for all other platforms, it is highly recommended that applications
neither read nor write this variable.  This global variable is a relic
that exists for backwards compatibility of legacy applications and should
be avoided in new projects.
It is not safe to read or modify this variable in more than one
thread at a time.  It is not safe to read or modify this variable
if a [database connection] is being used at the same time in a separate
thread.
It is intended that this variable be set once
as part of process initialization and before any SQLite interface
routines have been called and that this variable remain unchanged
thereafter.
^The [temp_store_directory pragma] may modify this variable and cause
it to point to memory obtained from [sqlite3_malloc].  ^Furthermore,
the [temp_store_directory pragma] always assumes that any string
that this variable points to is held in memory obtained from
[sqlite3_malloc] and the pragma may attempt to free that memory
using [sqlite3_free].
Hence, if this variable is modified directly, either it should be
made NULL or made to point to memory obtained from [sqlite3_malloc]
or else the use of the [temp_store_directory pragma] should be avoided.
Except when requested by the [temp_store_directory pragma], SQLite
does not free the memory that sqlite3_temp_directory points to.  If
the application wants that memory to be freed, it must do
so itself, taking care to only do so after all [database connection]
objects have been destroyed.

Note to Windows Runtime users:
 The temporary directory must be set
prior to calling [sqlite3_open] or [sqlite3_open_v2].  Otherwise, various
features that require the use of temporary files may fail.  Here is an
example of how to do this using C++ with the Windows Runtime:

LPCWSTR zPath = Windows::Storage::ApplicationData::Current->

    TemporaryFolder->Path->Data();
char zPathBuf
[
MAX_PATH + 1
]
;
memset(zPathBuf, 0, sizeof(zPathBuf));
WideCharToMultiByte(CP_UTF8, 0, zPath, -1, zPathBuf, sizeof(zPathBuf),

    NULL, NULL);
sqlite3_temp_directory = sqlite3_mprintf("%s", zPathBuf);"""

alias sqlite3_data_directory = Int8
"""Name Of The Folder Holding Database Files
^(If this global variable is made to point to a string which is
the name of a folder (a.k.a. directory), then all database files
specified with a relative pathname and created or accessed by
SQLite when using a built-in windows [sqlite3_vfs | VFS] will be assumed
to be relative to that directory.)^ ^If this variable is a NULL
pointer, then SQLite assumes that all database files specified
with a relative pathname are relative to the current directory
for the process.  Only the windows VFS makes use of this global
variable; it is ignored by the unix VFS.
Changing the value of this variable while a database connection is
open can result in a corrupt database.
It is not safe to read or modify this variable in more than one
thread at a time.  It is not safe to read or modify this variable
if a [database connection] is being used at the same time in a separate
thread.
It is intended that this variable be set once
as part of process initialization and before any SQLite interface
routines have been called and that this variable remain unchanged
thereafter.
^The [data_store_directory pragma] may modify this variable and cause
it to point to memory obtained from [sqlite3_malloc].  ^Furthermore,
the [data_store_directory pragma] always assumes that any string
that this variable points to is held in memory obtained from
[sqlite3_malloc] and the pragma may attempt to free that memory
using [sqlite3_free].
Hence, if this variable is modified directly, either it should be
made NULL or made to point to memory obtained from [sqlite3_malloc]
or else the use of the [data_store_directory pragma] should be avoided."""


@register_passable("trivial")
struct sqlite3_module(Copyable & Movable):
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
    var xRowid: fn (ExternalPointer[sqlite3_vtab_cursor], ExternalPointer[sqlite3_int64]) -> Int32
    var xUpdate: fn (
        ExternalPointer[sqlite3_vtab], Int32, ExternalPointer[ExternalPointer[sqlite3_value]], ExternalPointer[sqlite3_int64]
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
        ExternalPointer[sqlite3_vtab], ExternalPointer[Int8], ExternalPointer[Int8], Int32, ExternalPointer[ExternalPointer[Int8]]
    ) -> Int32  # FieldDeclNode: This is a const param, but shouldn't be assigned as an alias since it doesn't have a value.


@register_passable("trivial")
struct _sqlite3_index_info_sqlite3_index_constraint_usage(Copyable & Movable):
    var argvIndex: Int32
    var omit: UInt8


@register_passable("trivial")
struct _sqlite3_index_info_sqlite3_index_orderby(Copyable & Movable):
    var iColumn: Int32
    var desc: UInt8


@register_passable("trivial")
struct _sqlite3_index_info_sqlite3_index_constraint(Copyable & Movable):
    var iColumn: Int32
    var op: UInt8
    var usable: UInt8
    var iTermOffset: Int32


@register_passable("trivial")
struct sqlite3_index_info(Copyable & Movable):
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
    var estimatedRows: sqlite3_int64
    var idxFlags: Int32
    var colUsed: sqlite3_uint64


@register_passable("trivial")
struct sqlite3_vtab(Copyable & Movable):
    """Structures used by the virtual table interface."""

    var pModule: ExternalPointer[
        sqlite3_module
    ]  # FieldDeclNode: This is a const param, but shouldn't be assigned as an alias since it doesn't have a value.
    var nRef: Int32
    var zErrMsg: ExternalPointer[Int8]


@register_passable("trivial")
struct sqlite3_vtab_cursor(Copyable & Movable):
    var pVtab: ExternalPointer[sqlite3_vtab]


@register_passable("trivial")
struct sqlite3_blob(Copyable & Movable):
    """A Handle To An Open BLOB.

    An instance of this object represents an open BLOB on which
    [sqlite3_blob_open | incremental BLOB I/O] can be performed.
    ^Objects of this type are created by [sqlite3_blob_open()]
    and destroyed by [sqlite3_blob_close()].
    ^The [sqlite3_blob_read()] and [sqlite3_blob_write()] interfaces
    can be used to read or write small subsections of the BLOB.
    ^The [sqlite3_blob_bytes()] interface returns the size of the BLOB in bytes."""

    pass
