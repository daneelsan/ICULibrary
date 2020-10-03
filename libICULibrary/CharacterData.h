#ifndef LIBICULIBRARY_ICULIBRARY_H_
#define LIBICULIBRARY_ICULIBRARY_H_

#include "WolframLibrary.h"

DLLEXPORT int icuCharacterName(WolframLibraryData libData, mint argc, MArgument *args, MArgument res);

DLLEXPORT int icuCharacter_charAge(WolframLibraryData libData, mint argc, MArgument *args, MArgument res);

DLLEXPORT int icuCharacter_getNumericValue(WolframLibraryData libData, mint argc, MArgument *args, MArgument res);

DLLEXPORT int icuUnicodeVersion(WolframLibraryData libData, mint argc, MArgument *args, MArgument res);

DLLEXPORT int icuCharacterBinaryProperty(WolframLibraryData libData, mint argc, MArgument *args, MArgument res);

DLLEXPORT int icuCharacterBoolProperty(WolframLibraryData libData, mint argc, MArgument *args, MArgument res);

DLLEXPORT int icuCharacterIntProperty(WolframLibraryData libData, mint argc, MArgument *args, MArgument res);

DLLEXPORT int icuCharacterIntNameProperty(WolframLibraryData libData, mint argc, MArgument *args, MArgument res);

DLLEXPORT int icuCharacterCharProperty(WolframLibraryData libData, mint argc, MArgument *args, MArgument res);

DLLEXPORT int icuCharacterJavaTestProperty(WolframLibraryData libData, mint argc, MArgument *args, MArgument res);

DLLEXPORT int icuCharacterCPOSIXTestProperty(WolframLibraryData libData, mint argc, MArgument *args, MArgument res);

DLLEXPORT int icuCharacterICUWhitespaceTestProperty(WolframLibraryData libData, mint argc, MArgument *args, MArgument res);

DLLEXPORT int icuCharacterICUTestProperty(WolframLibraryData libData, mint argc, MArgument *args, MArgument res);


DLLEXPORT void WolframLibrary_uninitialize(WolframLibraryData libData);

DLLEXPORT int WolframLibrary_initialize(WolframLibraryData libData);

DLLEXPORT mint WolframLibrary_getVersion(void);

#endif  // LIBICULIBRARY_ICULIBRARY_H_

