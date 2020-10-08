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
	"ArgumentsPattern" -> {_, _, _.}};


CharacterData[args___] := 0 /;
	!Developer`CheckArgumentCount[CharacterData[args], 2, 3] && False


expr : CharacterData[args__] := With[{res = Catch[iCharacterData[HoldForm @ expr, args], $$tag]},
	res /; res =!= $$unevaluated]


(* constants*)

$CharacterCodeMinValue = 0;
$CharacterCodeMaxValue = 16^^10ffff;


(* Catch/Throw tags *)

$$tag = "CharacterDataCatchThrowTag";
$$unevaluated = "CharacterDataUnevaluatedTag";


(* Error messages *)

CharacterData::errchar = "The argument at position 1 in `1` should either be an integer between 0 and 1114111, \
a character (string of length 1) or a list of these values.";

CharacterData::errprop = "The argument at position 2 in `1` is not a member of CharacterData[All, \"Properties\"].";

CharacterData::errsprop = "The argument at position 3 in `1` is neither Automatic, \"Date\", \"Name\" nor \"ShortName\".";


(* ::Subsection::Closed:: *)
(*arguments*)


(* character *)

validCharacterCodeQ = ($CharacterCodeMinValue <= # <= $CharacterCodeMaxValue &);

validCharacterCodePattern = _Integer ? validCharacterCodeQ;

validCharacterCodesPattern = {___Integer} ? (AllTrue[#, validCharacterCodeQ]&);

validCharacterQ = (StringQ[#] && StringLength[#] === 1)&;

validCharacterPattern = _String ? validCharacterQ;

validCharactersPattern = {___String} ? (AllTrue[#, validCharacterQ]&);

validFirstArgumentPattern = Alternatives[
	validCharacterCodePattern,
	validCharacterCodesPattern,
	validCharacterPattern,
	validCharactersPattern];


(* property *)

$validCharacterProperties = {
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

validCharacterPropertyPattern := validCharacterPropertyPattern = Alternatives @@ $validCharacterProperties;


(* sub-property *)

$validCharacterSubProperties = {Automatic, "Date", "Name", "ShortName"};

validCharacterSubPropertyPattern := validCharacterSubPropertyPattern = Alternatives @@ $validCharacterSubProperties;


(* ::Subsection:: *)
(*iCharacterData*)


(*iCharacterData[_, "CurrentUnicodeVersion"] :=
	CurrentUnicodeVersion[]

iCharacterData[_, "ICUVersion"] :=
	"67.1"*)

(*iCharacterData[_, "UnicodeVersions"] :=
	Dataset[<|"Version" -> #1, "Date" -> #2|> &@@@ $UnicodeVersionMap]*)

iCharacterData[h_, All, "Properties"] :=
	Sort @ $validCharacterProperties


iCharacterData[
	h_,
	cp : validCharacterCodePattern,
	prop : validCharacterPropertyPattern] :=
	characterData$c[cp, {prop, Automatic}]

iCharacterData[
	h_,
	cp : validCharacterCodePattern,
	prop : validCharacterPropertyPattern,
	sub : validCharacterSubPropertyPattern] :=
	characterData$c[cp, {prop, sub}]


iCharacterData[
	h_,
	cps : validCharacterCodesPattern,
	prop : validCharacterPropertyPattern] :=
	characterData$c[#, {prop, Automatic}] & /@ cps

iCharacterData[
	h_,
	cps : validCharacterCodesPattern,
	prop : validCharacterPropertyPattern,
	sub : validCharacterSubPropertyPattern] :=
	characterData$c[#, {prop, sub}] & /@ cps


iCharacterData[
	h_,
	ch : validCharacterPattern,
	prop : validCharacterPropertyPattern] :=
	characterData$c[First@ToCharacterCode[ch], {prop, Automatic}]

iCharacterData[
	h_,
	ch : validCharacterPattern,
	prop : validCharacterPropertyPattern,
	sub : validCharacterSubPropertyPattern] :=
	characterData$c[First@ToCharacterCode[ch], {prop, sub}]


iCharacterData[
	h_,
	ch : validCharactersPattern,
	prop : validCharacterPropertyPattern] :=
	characterData$c[#, {prop, Automatic}] & /@ Flatten[ToCharacterCode[ch]]

iCharacterData[
	h_,
	ch : validCharactersPattern,
	prop : validCharacterPropertyPattern,
	sub : validCharacterSubPropertyPattern] :=
	characterData$c[#, {prop, sub}] & /@ Flatten[ToCharacterCode[ch]]


(*iCharacterData[
	h_,
	str_String?StringQ,
	prop : validCharacterPropertyPattern] :=
	characterData$c[#, {prop, Automatic}]& /@ ToCharacterCode[str]

iCharacterData[
	h_,
	str_String?StringQ,
	prop : validCharacterPropertyPattern,
	sub : validCharacterSubPropertyPattern] :=
	characterData$c[#, {prop, sub}]& /@ ToCharacterCode[str]*)


iCharacterData[
	h_,
	chr : validFirstArgumentPattern,
	props : {Alternatives[
		validCharacterPropertyPattern,
		{validCharacterPropertyPattern,
		_}] ..}] :=
	iCharacterData[Unevaluated @ h, chr, Replace[#, {x_, y_} :> Sequence[x, y]]] & /@ props


iCharacterData[h_, ch_ , args___] /; !MatchQ[ch, validFirstArgumentPattern]:=
	(Message[CharacterData::errchar, h];
	Throw[$$unevaluated, $$tag])

iCharacterData[h_, _ , prop_, args___] /; !MatchQ[prop, validCharacterPropertyPattern]:=
	(Message[CharacterData::errprop, h];
	Throw[$$unevaluated, $$tag])

iCharacterData[h_, _ , _, sprop_] /; !MatchQ[sprop, validCharacterSubPropertyPattern]:=
	(Message[CharacterData::errsprop, h];
	Throw[$$unevaluated, $$tag])

iCharacterData[args___] :=
	Throw[$$unevaluated, $$tag]
