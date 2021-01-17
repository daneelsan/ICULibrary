#include "CharacterData.h"

//#include <string.h>
#include <unicode/uchar.h>
//#include <unicode/unistr.h>
#include <unicode/uversion.h>

// Gets the Unicode version information.
EXTERN_C int getUnicodeVersion(
  WolframLibraryData libData, mint argc, MArgument *args, MArgument res)
{
  UVersionInfo versionArray; // array of 4 uint8_t
  MTensor T0;
  mint i, dims[1];
  int err = LIBRARY_NO_ERROR;

  if (argc != 0) {
    return LIBRARY_FUNCTION_ERROR;
  }

  u_getUnicodeVersion(versionArray);

  dims[0] = U_MAX_VERSION_LENGTH;
  err = libData->MTensor_new(MType_Integer, 1, dims, &T0);
  for (i = 1; i <= U_MAX_VERSION_LENGTH && !err; ++i) {
    err = libData->MTensor_setInteger(T0, &i, versionArray[i - 1]);
  }
  MArgument_setMTensor(res, T0);
  return err;
}

#define MAX_ICUNAME_LEN 512
static char icuNameBuff[MAX_ICUNAME_LEN + 1] = "\0";

// Retrieve the name of a Unicode character.
EXTERN_C int characterName(
  WolframLibraryData libData, mint argc, MArgument *args, MArgument res)
{
  mint nameLen;
  UChar32 code;
  UCharNameChoice nameChoice;
  // UnicodeString charName;
  UErrorCode errorCode = U_ZERO_ERROR;

  if (argc != 2) {
    return LIBRARY_FUNCTION_ERROR;
  }
  code = MArgument_getInteger(args[0]);
  /*
    0: U_UNICODE_CHAR_NAME
    1: U_UNICODE_10_CHAR_NAME (deprecated)
    2: U_EXTENDED_CHAR_NAME
    3: U_CHAR_NAME_ALIAS
   */
  nameChoice = MArgument_getInteger(args[1]);

  nameLen = u_charName(code, nameChoice, icuNameBuff, MAX_ICUNAME_LEN, &errorCode);
  icuNameBuff[nameLen] = '\0';

  if (!U_SUCCESS(errorCode)) {
    return LIBRARY_FUNCTION_ERROR;
  }

  MArgument_setUTF8String(res, icuNameBuff);
  return LIBRARY_NO_ERROR;
}

// Get the "age" of the code point.
EXTERN_C int characterAge(
  WolframLibraryData libData, mint argc, MArgument *args, MArgument res)
{
  UChar32 c;
  UVersionInfo versionArray; // array of 4 uint8_t
  MTensor T0;
  mint i, dims[1];
  int err = LIBRARY_NO_ERROR;

  if (argc != 1) {
    return LIBRARY_FUNCTION_ERROR;
  }
  c = MArgument_getInteger(args[0]);

  u_charAge(c, versionArray);

  dims[0] = U_MAX_VERSION_LENGTH;
  err = libData->MTensor_new(MType_Integer, 1, dims, &T0);
  for (i = 1; i <= U_MAX_VERSION_LENGTH && !err; ++i) {
    err = libData->MTensor_setInteger(T0, &i, versionArray[i - 1]);
  }
  MArgument_setMTensor(res, T0);
  return err;
}

// Get the numeric value for a Unicode code point as defined in the Unicode Character Database.
EXTERN_C int characterNumericValue(
  WolframLibraryData libData, mint argc, MArgument *args, MArgument res)
{
  UChar32 c;
  double val;

  if (argc != 1) {
    return LIBRARY_FUNCTION_ERROR;
  }
  c = MArgument_getInteger(args[0]);

  val = u_getNumericValue(c);

  MArgument_setReal(res, val);
  return LIBRARY_NO_ERROR;
}

// Check a binary Unicode property for a code point.
EXTERN_C int characterBinaryProperty(
  WolframLibraryData libData, mint argc, MArgument *args, MArgument res)
{
  UChar32 c;
  UProperty which;
  UBool test;

  if (argc != 2) {
    return LIBRARY_FUNCTION_ERROR;
  }
  c = MArgument_getInteger(args[0]);
  which = MArgument_getInteger(args[1]);

  // Returns FALSE even if code point does not have data for the property.
  test = u_hasBinaryProperty(c, which);

  MArgument_setBoolean(res, test);
  return LIBRARY_NO_ERROR;
}

// Get the property value for an enumerated or integer Unicode property for a code point.
EXTERN_C int characterIntPropertyValue(
  WolframLibraryData libData, mint argc, MArgument *args, MArgument res)
{
  UChar32 c;
  UProperty which;
  mint val;

  if (argc != 2) {
    return LIBRARY_FUNCTION_ERROR;
  }
  c = MArgument_getInteger(args[0]);
  which = MArgument_getInteger(args[1]);

  val = u_getIntPropertyValue(c, which);

  MArgument_setInteger(res, val);
  return LIBRARY_NO_ERROR;
}

EXTERN_C int characterIntPropertyValueName(
  WolframLibraryData libData, mint argc, MArgument *args, MArgument res)
{
  UChar32 c;
  UProperty prop;
  mint val;
  UPropertyNameChoice nameChoice; // Short: 0, Long: 1
  const char *valName;

  if (argc != 3) {
    return LIBRARY_FUNCTION_ERROR;
  }
  c = MArgument_getInteger(args[0]);
  prop = MArgument_getInteger(args[1]);
  nameChoice = MArgument_getInteger(args[2]);

  val = u_getIntPropertyValue(c, prop);
  valName = u_getPropertyValueName(prop, val, nameChoice);

  if (valName == NULL) {
          return LIBRARY_FUNCTION_ERROR;
  }

  MArgument_setUTF8String(res, (char *)valName);
  return LIBRARY_NO_ERROR;
}

EXTERN_C int characterCharProperty(
  WolframLibraryData libData, mint argc, MArgument *args, MArgument res)
{
  UChar32 c;
  UProperty prop;
  UChar32 val;

  if (argc != 2) {
          return LIBRARY_FUNCTION_ERROR;
  }

  c = MArgument_getInteger(args[0]);
  prop = MArgument_getInteger(args[1]);

  switch (prop) {
  case UCHAR_BIDI_MIRRORING_GLYPH:
    val = u_charMirror(c);
    break;
  case UCHAR_SIMPLE_CASE_FOLDING:
    val = u_foldCase(c, U_FOLD_CASE_DEFAULT);
    break;
  case UCHAR_SIMPLE_LOWERCASE_MAPPING:
    val = u_tolower(c);
    break;
  case UCHAR_SIMPLE_UPPERCASE_MAPPING:
    val = u_toupper(c);
    break;
  case UCHAR_SIMPLE_TITLECASE_MAPPING:
    val = u_totitle(c);
    break;
  case UCHAR_BIDI_PAIRED_BRACKET:
    val = u_getBidiPairedBracket(c);
    break;
        default:
    return LIBRARY_FUNCTION_ERROR;
  }

  MArgument_setInteger(res, val);
  return LIBRARY_NO_ERROR;
}

/*
EXTERN_C int icuCharacterJavaTestProperty(
  WolframLibraryData libData, mint argc, MArgument *args, MArgument res)
{
  UChar32 c;
  mint prop;
  UBool test;

  if (argc != 2) {
    return LIBRARY_FUNCTION_ERROR;
  }
  c = MArgument_getInteger(args[0]);
  prop = MArgument_getInteger(args[1]);

  switch (prop) {
  case  0: test = u_islower(c); break;
  case  1: test = u_isupper(c); break;
  case  2: test = u_istitle(c); break;
  case  3: test = u_isdigit(c); break;
  case  4: test = u_isalpha(c); break;
  case  5: test = u_isalnum(c); break;
  case  6: test = u_isdefined(c); break;
  case  7: test = u_isJavaSpaceChar(c); break;
  case  8: test = u_isWhitespace(c); break;
  case  9: test = u_isISOControl(c); break;
  case 10: test = u_isMirrored(c); break;
  default:
    return LIBRARY_FUNCTION_ERROR;
  }

  MArgument_setBoolean(res, test);
  return LIBRARY_NO_ERROR;
}
*/

typedef UBool (*JavaTest)(UChar32 c);

static JavaTest JavaTestFunctions[15] = {
  u_isalnum, u_isalpha, u_isdefined,
  u_isdigit, u_isIDIgnorable, u_isIDPart,
  u_isIDStart, u_isISOControl, u_isJavaIDPart,
  u_isJavaIDStart, u_isJavaSpaceChar, u_islower,
  u_isMirrored, u_istitle, u_isupper
};

EXTERN_C int characterJavaTestProperty(
  WolframLibraryData libData, mint argc, MArgument *args, MArgument res)
{
  UChar32 c;
  mint prop;
  UBool test;

  if (argc != 2) {
    return LIBRARY_FUNCTION_ERROR;
  }
  c = MArgument_getInteger(args[0]);
  prop = MArgument_getInteger(args[1]);

  if ((prop >= 0) && (prop < 15)) {
    test = JavaTestFunctions[prop](c);
  } else {
    return LIBRARY_FUNCTION_ERROR;
  }

  MArgument_setBoolean(res, test);
  return LIBRARY_NO_ERROR;

}

typedef UBool (*CPOSIXTest)(UChar32 c);

static CPOSIXTest CPOSIXTestFunctions[12] = {
  u_isalnum, u_isalpha, u_isblank,
  u_iscntrl, u_isdigit, u_isgraph,
  u_islower, u_isprint, u_ispunct,
  u_isspace, u_isupper, u_isxdigit
};

EXTERN_C int characterCPOSIXTestProperty(
  WolframLibraryData libData, mint argc, MArgument *args, MArgument res)
{
  UChar32 c;
  mint prop;
  UBool test;

  if (argc != 2) {
    return LIBRARY_FUNCTION_ERROR;
  }
  c = MArgument_getInteger(args[0]);
  prop = MArgument_getInteger(args[1]);

  if ((prop >= 0) && (prop < 12)) {
    test = CPOSIXTestFunctions[prop](c);
  } else {
    return LIBRARY_FUNCTION_ERROR;
  }

  MArgument_setBoolean(res, test);
  return LIBRARY_NO_ERROR;
}

EXTERN_C int characterWhitespaceTestProperty(
  WolframLibraryData libData, mint argc, MArgument *args, MArgument res)
{
  UChar32 c;
  mint prop;
  UBool test;

  if (argc != 2) {
    return LIBRARY_FUNCTION_ERROR;
  }
  c = MArgument_getInteger(args[0]);
  prop = MArgument_getInteger(args[1]);

  switch (prop) {
  case  0: test = u_isUWhiteSpace(c); break;
  case  1: test = u_isWhitespace(c); break;
  case  2: test = u_isJavaSpaceChar(c); break;
  case  3: test = u_isspace(c); break;
  case  4: test = u_isblank(c); break;
  default:
    return LIBRARY_FUNCTION_ERROR;
  }

  MArgument_setBoolean(res, test);
  return LIBRARY_NO_ERROR;
}

typedef UBool (*ICUTest)(UChar32 c);

static ICUTest ICUTestFunctions[28] = {
  u_isalnum, u_isalpha, u_isbase, u_isblank,
  u_iscntrl, u_isdefined, u_isdigit, u_isgraph,
  u_isIDIgnorable,u_isIDPart, u_isIDStart, u_isISOControl,
  u_isJavaIDPart, u_isJavaIDStart, u_isJavaSpaceChar, u_islower,
  u_isMirrored, u_isprint, u_ispunct, u_isspace,
  u_istitle, u_isUAlphabetic, u_isULowercase, u_isupper,
  u_isUUppercase, u_isUWhiteSpace, u_isWhitespace, u_isxdigit
};

EXTERN_C int characterICUTestProperty(
  WolframLibraryData libData, mint argc, MArgument *args, MArgument res)
{
  UChar32 c;
  mint prop;
  UBool test;

  if (argc != 2) {
    return LIBRARY_FUNCTION_ERROR;
  }
  c = MArgument_getInteger(args[0]);
  prop = MArgument_getInteger(args[1]);

  if ((prop >= 0) && (prop < 28)) {
    test = ICUTestFunctions[prop](c);
  } else {
    return LIBRARY_FUNCTION_ERROR;
  }

  MArgument_setBoolean(res, test);
  return LIBRARY_NO_ERROR;
}

// Boilerplate.
EXTERN_C void WolframLibrary_uninitialize(WolframLibraryData libData)
{
  return;
}

EXTERN_C int WolframLibrary_initialize(WolframLibraryData libData)
{
  return 0;
}

EXTERN_C mint WolframLibrary_getVersion(void)
{
  return WolframLibraryVersion;
}

