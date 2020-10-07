(* ::Package:: *)

Package["ICULibrary`"]


PackageScope["characterData$c"]


(* ::Subsubsection::Closed:: *)
(*LibraryFunctionLoad*)


$libraryFile = FindLibrary["libICULibrary"];


$c$characterName = If[$libraryFile =!= $Failed,
	LibraryFunctionLoad[
		$libraryFile,
		"characterName",
		{Integer, (* character code *)
		Integer}, (* name choice *)
		"UTF8String"], (* name *)
	$Failed];

$c$characterAge = If[$libraryFile =!= $Failed,
	LibraryFunctionLoad[
		$libraryFile,
		"characterAge",
		{Integer}, (* character code *)
		{Integer, 1}], (* version *)
	$Failed];

$c$characterNumericValue = If[$libraryFile =!= $Failed,
	LibraryFunctionLoad[
		$libraryFile,
		"characterNumericValue",
		{Integer}, (* character code *)
		Real], (* numeric value *)
	$Failed];

$c$characterBinaryProperty = If[$libraryFile =!= $Failed,
	LibraryFunctionLoad[
		$libraryFile,
		"characterBinaryProperty",
		{Integer, (* character code *)
		Integer}, (* property code *)
		"Boolean"], (* True if the character has said property *)
	$Failed];

$c$characterIntPropertyValueName = If[$libraryFile =!= $Failed,
	LibraryFunctionLoad[
		$libraryFile,
		"characterIntPropertyValueName",
		{Integer, (* character code *)
		Integer, (* property code *)
		Integer}, (* name choice code *)
		"UTF8String"], (* name value *)
	$Failed];

$c$characterCharProperty = If[$libraryFile =!= $Failed,
	LibraryFunctionLoad[
		$libraryFile,
		"characterCharProperty",
		{Integer, (* character code *)
		Integer}, (* property code *)
		Integer], (* character code *)
	$Failed];

$c$characterJavaTestProperty = If[$libraryFile =!= $Failed,
	LibraryFunctionLoad[
		$libraryFile,
		"characterJavaTestProperty",
		{Integer, (* character code *)
		Integer}, (* property code *)
		"Boolean"], (* test *)
	$Failed];

$c$characterCPOSIXTestProperty = If[$libraryFile =!= $Failed,
	LibraryFunctionLoad[
		$libraryFile,
		"characterCPOSIXTestProperty",
		{Integer, (* character code *)
		Integer}, (* property code *)
		"Boolean"], (* test *)
	$Failed];

$c$characterWhitespaceTestProperty = If[$libraryFile =!= $Failed,
	LibraryFunctionLoad[
		$libraryFile,
		"characterWhitespaceTestProperty",
		{Integer, (* character code *)
		Integer}, (* property code *)
		"Boolean"], (* test *)
	$Failed];

$c$characterICUTestProperty = If[$libraryFile =!= $Failed,
	LibraryFunctionLoad[
		$libraryFile,
		"characterICUTestProperty",
		{Integer, (* character code *)
		Integer}, (* property code *)
		"Boolean"], (* test *)
	$Failed];


(* ::Subsubsection::Closed:: *)
(*ICU Enum*)


(*
	Source: "https://unicode-org.github.io/icu-docs/apidoc/dev/icu4c/uchar_8h.html#ae40d616419e74ecc7c80a9febab03199"
*)
	
$c$CharacterPropertiesEnum = <|
	(* BinaryPropertiesEnum *)
	<|
	"BINARY_START" -> 0,
	"ALPHABETIC" -> 0,
	"ASCII_HEX_DIGIT" -> 1,
	"BIDI_CONTROL" -> 2,
	"BIDI_MIRRORED" -> 3,
	"DASH" -> 4,
	"DEFAULT_IGNORABLE_CODE_POINT" -> 5,
	"DEPRECATED" -> 6,
	"DIACRITIC" -> 7,
	"EXTENDER" -> 8,
	"FULL_COMPOSITION_EXCLUSION" -> 9,
	"GRAPHEME_BASE" -> 10,
	"GRAPHEME_EXTEND" -> 11,
	"GRAPHEME_LINK" -> 12,
	"HEX_DIGIT" -> 13,
	"HYPHEN" -> 14,
	"ID_CONTINUE" -> 15,
	"ID_START" -> 16,
	"IDEOGRAPHIC" -> 17,
	"IDS_BINARY_OPERATOR" -> 18,
	"IDS_TRINARY_OPERATOR" -> 19,
	"JOIN_CONTROL" -> 20,
	"LOGICAL_ORDER_EXCEPTION" -> 21,
	"LOWERCASE" -> 22,
	"MATH" -> 23,
	"NONCHARACTER_CODE_POINT" -> 24,
	"QUOTATION_MARK" -> 25,
	"RADICAL" -> 26,
	"SOFT_DOTTED" -> 27,
	"TERMINAL_PUNCTUATION" -> 28,
	"UNIFIED_IDEOGRAPH" -> 29,
	"UPPERCASE" -> 30,
	"WHITE_SPACE" -> 31,
	"XID_CONTINUE" -> 32,
	"XID_START" -> 33,
	"CASE_SENSITIVE" -> 34,
	"S_TERM" -> 35,
	"VARIATION_SELECTOR" -> 36,
	"NFD_INERT" -> 37,
	"NFKD_INERT" -> 38,
	"NFC_INERT" -> 39,
	"NFKC_INERT" -> 40,
	"SEGMENT_STARTER" -> 41,
	"PATTERN_SYNTAX" -> 42,
	"PATTERN_WHITE_SPACE" -> 43,
	"POSIX_ALNUM" -> 44,
	"POSIX_BLANK" -> 45,
	"POSIX_GRAPH" -> 46,
	"POSIX_PRINT" -> 47,
	"POSIX_XDIGIT" -> 48,
	"CASED" -> 49,
	"CASE_IGNORABLE" -> 50,
	"CHANGES_WHEN_LOWERCASED" -> 51,
	"CHANGES_WHEN_UPPERCASED" -> 52,
	"CHANGES_WHEN_TITLECASED" -> 53,
	"CHANGES_WHEN_CASEFOLDED" -> 54,
	"CHANGES_WHEN_CASEMAPPED" -> 55,
	"CHANGES_WHEN_NFKC_CASEFOLDED" -> 56,
	"EMOJI" -> 57,
	"EMOJI_PRESENTATION" -> 58,
	"EMOJI_MODIFIER" -> 59,
	"EMOJI_MODIFIER_BASE" -> 60,
	"EMOJI_COMPONENT" -> 61,
	"REGIONAL_INDICATOR" -> 62,
	"PREPENDED_CONCATENATION_MARK" -> 63,
	"EXTENDED_PICTOGRAPHIC" -> 64,
	"BINARY_LIMIT" -> 65|>,
	
	(* IntegerPropertiesEnum *)
	<|
	"INT_START" -> 4096,
	"BIDI_CLASS" -> 4096,
	"BLOCK" -> 4097,
	"CANONICAL_COMBINING_CLASS" -> 4098,
	"DECOMPOSITION_TYPE" -> 4099,
	"EAST_ASIAN_WIDTH" -> 4100,
	"GENERAL_CATEGORY" -> 4101,
	"JOINING_GROUP" -> 4102,
	"JOINING_TYPE" -> 4103,
	"LINE_BREAK" -> 4104,
	"NUMERIC_TYPE" -> 4105,
	"SCRIPT" -> 4106,
	"HANGUL_SYLLABLE_TYPE" -> 4107,
	"NFD_QUICK_CHECK" -> 4108,
	"NFKD_QUICK_CHECK" -> 4109,
	"NFC_QUICK_CHECK" -> 4110,
	"NFKC_QUICK_CHECK" -> 4111,
	"LEAD_CANONICAL_COMBINING_CLASS" -> 4112,
	"TRAIL_CANONICAL_COMBINING_CLASS" -> 4113,
	"GRAPHEME_CLUSTER_BREAK" -> 4114,
	"SENTENCE_BREAK" -> 4115,
	"WORD_BREAK" -> 4116,
	"BIDI_PAIRED_BRACKET_TYPE" -> 4117,
	"INDIC_POSITIONAL_CATEGORY" -> 4118,
	"INDIC_SYLLABIC_CATEGORY" -> 4119,
	"VERTICAL_ORIENTATION" -> 4120,
	"INT_LIMIT" -> 4121|>,
	
	(* MaskPropertiesEnum *)
	<|
	"MASK_START" -> 8192,
	"GENERAL_CATEGORY_MASK" -> 8192,
	"MASK_LIMIT" -> 8193|>,
	
	(* DoublePropertiesEnum *)
	<|
	"DOUBLE_START" -> 12288,
	"NUMERIC_VALUE" -> 12288,
	"DOUBLE_LIMIT" -> 12289|>,
	
	(* StringPropertiesEnum *)
	<|
	"STRING_START" -> 16384,
	"AGE" -> 16384,
	"BIDI_MIRRORING_GLYPH" -> 16385,
	"CASE_FOLDING" -> 16386,
	"ISO_COMMENT" -> 16387,
	"LOWERCASE_MAPPING" -> 16388,
	"NAME" -> 16389,
	"SIMPLE_CASE_FOLDING" -> 16390,
	"SIMPLE_LOWERCASE_MAPPING" -> 16391,
	"SIMPLE_TITLECASE_MAPPING" -> 16392,
	"SIMPLE_UPPERCASE_MAPPING" -> 16393,
	"TITLECASE_MAPPING" -> 16394,
	"UNICODE_1_NAME" -> 16395,
	"UPPERCASE_MAPPING" -> 16396,
	"BIDI_PAIRED_BRACKET" -> 16397,
	"STRING_LIMIT" -> 16398|>,
	
	(* OtherPropertiesEnum *)
	<|
	"OTHER_PROPERTY_START" -> 28672,
	"SCRIPT_EXTENSIONS" -> 28672,
	"OTHER_PROPERTY_LIMIT" -> 28673|>|>;


(* ::Subsubsection::Closed:: *)
(*utilities*)


nameChoice["ShortName"] = 0;
nameChoice["Name"] = 1;
nameChoice[_] := 1;


cleanResult[""] = Missing["NotAvailable"];
cleanResult[-1.23456789`*^8] = Missing["NotApplicable"];
cleanResult[x_] := x;


(* ::Subsubsection:: *)
(*characterData$c*)


characterData$c[ch_, "BaseCharQ", ___] :=
	$c$characterICUTestProperty[ch, 2];
	
characterData$c[ch_, "Block", name_ : "Name"] :=
	$c$characterIntPropertyValueName[ch, $c$CharacterPropertiesEnum["BLOCK"], nameChoice[name]];
	
characterData$c[ch_, "BMPCharQ", ___] :=
	0 <= ch <= 16^^FFFF;

characterData$c[ch_, "CombiningClass", name_ : "Name"] :=
	$c$characterIntPropertyValueName[ch, $c$CharacterPropertiesEnum["CANONICAL_COMBINING_CLASS"], nameChoice[name]];

characterData$c[ch_, "DefinedQ", ___] :=
	$c$characterJavaTestProperty[ch, 2];

characterData$c[ch_, "DigitQ", ___] :=
	$c$characterJavaTestProperty[ch, 3];

characterData$c[ch_, "Direction", name_ : "Name"] :=
	$c$characterIntPropertyValueName[ch, $c$CharacterPropertiesEnum["BIDI_CLASS"], nameChoice[name]];

characterData$c[ch_, "ExtendedName", ___] :=
	$c$characterName[ch, 2];

characterData$c[ch_, "FoldCase", ___] :=
	FromCharacterCode[$c$characterCharProperty[ch, $c$CharacterPropertiesEnum["SIMPLE_CASE_FOLDING"]]];

characterData$c[ch_, "GeneralCategory", name_ : "Name"] :=
	$c$characterIntPropertyValueName[ch, $c$CharacterPropertiesEnum["GENERAL_CATEGORY"], nameChoice[name]];

characterData$c[ch_, "IlegalQ", ___] :=
	$c$characterBinaryProperty[ch, $c$CharacterPropertiesEnum["NONCHARACTER_CODE_POINT"]];

characterData$c[ch_ ,"ISOControlQ", ___] :=
	$c$characterJavaTestProperty[ch, 7];

characterData$c[ch_, "LetterDigitQ", ___] :=
	$c$characterJavaTestProperty[ch,0];

characterData$c[ch_, "LetterQ", ___] :=
	$c$characterJavaTestProperty[ch, 1];

characterData$c[ch_, "LowerCase", ___] :=
	FromCharacterCode[$c$characterCharProperty[ch, $c$CharacterPropertiesEnum["SIMPLE_LOWERCASE_MAPPING"]]];

characterData$c[ch_, "LowerCaseQ", ___] :=
	$c$characterJavaTestProperty[ch, 11];

characterData$c[ch_, "Mirror", ___] :=
	FromCharacterCode[$c$characterCharProperty[ch, $c$CharacterPropertiesEnum["BIDI_MIRRORING_GLYPH"]]];

characterData$c[ch_,"MirroredQ", ___] :=
	$c$characterJavaTestProperty[ch, 12];

characterData$c[ch_, "Name", ___] :=
	cleanResult[$c$characterName[ch, 0]];

characterData$c[ch_, "NameAlias", ___] :=
	cleanResult[$c$characterName[ch, 3]];

characterData$c[ch_, "NumericValue", ___] :=
	cleanResult[$c$characterNumericValue[ch]];

characterData$c[ch_, "PairedBracket", ___] :=
	FromCharacterCode[$c$characterCharProperty[ch, $c$CharacterPropertiesEnum["BIDI_PAIRED_BRACKET"]]];

characterData$c[ch_, "PrintableQ", ___] :=
	$c$characterCPOSIXTestProperty[ch, 7];

characterData$c[ch_, "Script", name_ : "Name"] :=
	$c$characterIntPropertyValueName[ch, $c$CharacterPropertiesEnum["SCRIPT"], nameChoice[name]];

characterData$c[ch_, "SupplementaryCharQ", ___] :=
	16^^00FFFF < ch <= 16^^10FFFF;

characterData$c[ch_, "TitleCase", ___] :=
	FromCharacterCode[$c$characterCharProperty[ch, $c$CharacterPropertiesEnum["SIMPLE_TITLECASE_MAPPING"]]];

characterData$c[ch_, "TitleCaseQ", ___] :=
	$c$characterJavaTestProperty[ch, 2];

characterData$c[ch_, "UnicodeAlphabeticQ", ___] :=
	$c$characterBinaryProperty[ch, $c$CharacterPropertiesEnum["ALPHABETIC"]];

characterData$c[ch_, "UnicodeLowerCaseQ", ___] :=
	$c$characterBinaryProperty[ch, $c$CharacterPropertiesEnum["LOWERCASE"]];

characterData$c[ch_, "UnicodeUpperCaseQ", ___] :=
	$c$characterBinaryProperty[ch, $c$CharacterPropertiesEnum["UPPERCASE"]];

characterData$c[ch_, "UnicodeVersion", ___] :=
	$c$characterAge[ch];

characterData$c[ch_, "UnicodeVersion", "Date", ___] :=
	Replace[$c$characterAge[ch], $UnicodeVersionMap];

characterData$c[ch_, "UpperCase", ___] :=
	FromCharacterCode[$c$characterCharProperty[ch, $c$CharacterPropertiesEnum["SIMPLE_UPPERCASE_MAPPING"]]];

characterData$c[ch_, "UpperCaseQ", ___] :=
	$c$characterJavaTestProperty[ch, 14];
	
(*
characterData$c[ch_, "WhiteSpaceQ", t : ("CPOSIX" | "ICU" | "Java" | "Unicode") : "ICU"] :=
	$c$characterWhitespaceTestProperty[ch, Switch[t, "CPOSIX", 4, "ICU", 1, "Java", 2, "Unicode", 0]];
*)
characterData$c[ch_, "WhiteSpaceQ", ___] :=
	$c$characterWhitespaceTestProperty[ch, 1]

characterData$c[___] :=
	Missing["NotAvailable"];
