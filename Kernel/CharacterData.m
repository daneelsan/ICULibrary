(* ::Package:: *)

Package["ICULibrary`"]


PackageExport["CharacterData"]


(* ::Subsubsection:: *)
(*CharacterData*)


CharacterData::usage = usageString[
	"CharacterData[`char`, `prop`] selects hyperedges from `h` that are subsets of `vertices`.",
	"\n",
	"CharacterData[`prop`] represents the operator form for a hypergraph."];


SyntaxInformation[CharacterData] = {
	"ArgumentsPattern" -> {_, _., _.}};


CharacterData[args___] := 0 /;
	!Developer`CheckArgumentCount[CharacterData[args], 1, 3] && False


expr : CharacterData[args__] := With[{res = Catch[iCharacterData[HoldForm@expr, args], $tag]},
	res /; res =!= $unevaluated];


(* ::Subsubsection::Closed:: *)
(*tags*)


$tag = "CharacterDataCatchThrowTag";
$unevaluated = "CharacterDataUnevaluatedTag";


(* ::Subsubsection:: *)
(*$characterProperties*)


$characterProperties = {
	"BaseCharQ",
	"Block",
	"BMPCharQ",
	"CombiningClass",
	"DefinedQ",
	"DigitQ",
	"Direction",
	"ExtendedName",
	"FoldCase",
	"GeneralCategory",
	"IlegalQ",
	"ISOControlQ",
	"LetterDigitQ",
	"LetterQ",
	"LowerCase",
	"LowerCaseQ",
	"Mirror",
	"MirroredQ",
	"Name",
	"NameAlias",
	"NumericValue",
	"PairedBracket",
	"PrintableQ",
	"Script",
	"SupplementaryCharQ",
	"TitleCase",
	"TitleCaseQ",
	"UnicodeAlphabeticQ",
	"UnicodeLowerCaseQ",
	"UnicodeUpperCaseQ",
	"UnicodeVersion",
	"UpperCase",
	"UpperCaseQ",
	"WhitespaceQ"};

$characterPropertiesPattern := $characterPropertiesPattern = Alternatives @@ $characterProperties;


(*$characterExtraPropertiesPattern = "ICUVersion" | "UnicodeVersion" | "UnicodeVersions" | "Properties";*)


(* ::Subsubsection::Closed:: *)
(*Messages*)


CharacterData::arg1 = "The argument at position 1 in `1` should be an integer between 0 and 1114111 or a string of length 1.";
CharacterData::errprop = "The property or properties at position 2 in `1` should be in CharacterData[\"Properties\"].";


(* ::Subsubsection:: *)
(*iCharacterData*)


iCharacterData[_, "UnicodeVersion"] :=
	CurrentUnicodeVersion[];

iCharacterData[_, "ICUVersion"] :=
	"67.1";

iCharacterData["Properties"] :=
	Sort@$characterProperties;

iCharacterData["UnicodeVersions"] :=
	Dataset[<|"Version" -> #1, "Date" -> #2|> &@@@ $UnicodeVersionMap];


iCharacterData[h_, x_, props : {$characterPropertiesPattern..}] :=
	iCharacterData[h, x, #] &/@ props;

iCharacterData[h_, x_, props_List] :=
	(Message[CharacterData::errprop, h];
	Throw[$unevaluated, $tag]);


iCharacterData[h_, cp_Integer, prop : $characterPropertiesPattern, args___] :=
	If[0 <= cp <= 16^^10FFFF,
		characterData$c[cp, prop, args],
		Message[CharacterData::arg1, h];
		Throw[$unevaluated, $tag]
	];


iCharacterData[h_, ch_String, prop : $characterPropertiesPattern, args___] :=
	If[StringLength[ch] === 1,
		characterData$c[First@ToCharacterCode[ch], prop, args],
		Message[CharacterData::arg1, h];
		Throw[$unevaluated, $tag]
	];


iCharacterData[h_, _, prop_] := 
	(Message[CharacterData::errprop, h];
	Throw[$unevaluated, $tag]);


iICUCharacterData[args___] :=
	(Throw[$unevaluated, $tag]);
