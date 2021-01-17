#ifndef LIBICULIBRARY_ICULIBRARY_H_
#define LIBICULIBRARY_ICULIBRARY_H_

#include "WolframLibrary.h"

EXTERN_C DLLEXPORT int getUnicodeVersion(
  WolframLibraryData libData, mint argc, MArgument *args, MArgument res);

EXTERN_C DLLEXPORT int characterName(
  WolframLibraryData libData, mint argc, MArgument *args, MArgument res);

EXTERN_C DLLEXPORT int characterAge(
  WolframLibraryData libData, mint argc, MArgument *args, MArgument res);

EXTERN_C DLLEXPORT int characterNumericValue(
  WolframLibraryData libData, mint argc, MArgument *args, MArgument res);

EXTERN_C DLLEXPORT int characterBinaryProperty(
  WolframLibraryData libData, mint argc, MArgument *args, MArgument res);

EXTERN_C DLLEXPORT int characterIntPropertyValue(
  WolframLibraryData libData, mint argc, MArgument *args, MArgument res);

EXTERN_C DLLEXPORT int characterIntPropertyValueName(
  WolframLibraryData libData, mint argc, MArgument *args, MArgument res);

EXTERN_C DLLEXPORT int characterCharProperty(
  WolframLibraryData libData, mint argc, MArgument *args, MArgument res);

EXTERN_C DLLEXPORT int characterJavaTestProperty(
  WolframLibraryData libData, mint argc, MArgument *args, MArgument res);

EXTERN_C DLLEXPORT int characterCPOSIXTestProperty(
  WolframLibraryData libData, mint argc, MArgument *args, MArgument res);

EXTERN_C DLLEXPORT int characterWhitespaceTestProperty(
  WolframLibraryData libData, mint argc, MArgument *args, MArgument res);

EXTERN_C DLLEXPORT int characterICUTestProperty(
  WolframLibraryData libData, mint argc, MArgument *args, MArgument res);


EXTERN_C DLLEXPORT void WolframLibrary_uninitialize(WolframLibraryData libData);

EXTERN_C DLLEXPORT int WolframLibrary_initialize(WolframLibraryData libData);

EXTERN_C DLLEXPORT mint WolframLibrary_getVersion(void);

#endif  // LIBICULIBRARY_ICULIBRARY_H_
