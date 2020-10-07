#ifndef LIBICULIBRARY_ICULIBRARY_H_
#define LIBICULIBRARY_ICULIBRARY_H_

#include "WolframLibrary.h"

DLLEXPORT int getUnicodeVersion(
	WolframLibraryData libData, mint argc, MArgument *args, MArgument res);

DLLEXPORT int characterName(
	WolframLibraryData libData, mint argc, MArgument *args, MArgument res);

DLLEXPORT int characterAge(
	WolframLibraryData libData, mint argc, MArgument *args, MArgument res);

DLLEXPORT int characterNumericValue(
	WolframLibraryData libData, mint argc, MArgument *args, MArgument res);

DLLEXPORT int characterBinaryProperty(
	WolframLibraryData libData, mint argc, MArgument *args, MArgument res);

DLLEXPORT int characterIntPropertyValue(
	WolframLibraryData libData, mint argc, MArgument *args, MArgument res);

DLLEXPORT int characterIntPropertyValueName(
	WolframLibraryData libData, mint argc, MArgument *args, MArgument res);

DLLEXPORT int characterCharProperty(
	WolframLibraryData libData, mint argc, MArgument *args, MArgument res);

DLLEXPORT int characterJavaTestProperty(
	WolframLibraryData libData, mint argc, MArgument *args, MArgument res);

DLLEXPORT int characterCPOSIXTestProperty(
	WolframLibraryData libData, mint argc, MArgument *args, MArgument res);

DLLEXPORT int characterWhitespaceTestProperty(
	WolframLibraryData libData, mint argc, MArgument *args, MArgument res);

DLLEXPORT int characterICUTestProperty(
	WolframLibraryData libData, mint argc, MArgument *args, MArgument res);


DLLEXPORT void WolframLibrary_uninitialize(WolframLibraryData libData);

DLLEXPORT int WolframLibrary_initialize(WolframLibraryData libData);

DLLEXPORT mint WolframLibrary_getVersion(void);

#endif  // LIBICULIBRARY_ICULIBRARY_H_

