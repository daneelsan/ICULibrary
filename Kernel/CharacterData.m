(* ::Package:: *)

Package["ICULibrary`"]

PackageExport["CharacterData"]


(* CharacterData *)

(** usage string **)
CharacterData::usage = usageString[
	"CharacterData[`char`, `property`] gives the value of the specified ICU/Unicode `property` for the character specified by `char`.",
	"\n",
	"CharacterData[`char`, `property`, `subproperty`] gives the `subproperty` for a given `property`."];

(** syntax information **)
SyntaxInformation[CharacterData] = {
	"ArgumentsPattern" -> {_, _, _.}};

(** argument count check **)
CharacterData[args___] := 0 /;
	!Developer`CheckArgumentCount[CharacterData[args], 2, 3] && False

(** main **)
expr : CharacterData[args__] := With[{res = Catch[iCharacterData[HoldForm @ expr, args], $$tag]},
	res /; res =!= $$unevaluated]

(** Catch/Throw tags **)
$$tag = "CharacterDataCatchThrowTag";
$$unevaluated = "CharacterDataUnevaluatedTag";

(** error messages **)
CharacterData::errchar = "The argument at position 1 in `1` should either be an integer between 0 and 1114111, \
a character (string of length 1) or a list of these values.";
CharacterData::errprop = "The argument at position 2 in `1` is not a member of CharacterData[All, \"Properties\"].";
CharacterData::errsprop = "The argument at position 3 in `1` is neither Automatic, \"Date\", \"Name\" nor \"ShortName\".";

(** constants **)
$CharacterCodeMinValue = 0;
$CharacterCodeMaxValue = 16^^10ffff;

(** valid character **)
characterCodeQ = ($CharacterCodeMinValue <= # <= $CharacterCodeMaxValue &);
$characterCodePattern = _Integer ? characterCodeQ;
$characterCodeListPattern = {___Integer} ? (AllTrue[#, characterCodeQ] &);
characterQ = (StringQ[#] && StringLength[#] === 1) &;
$characterPattern = _String ? characterQ;
$characterListPattern = {___String} ? (AllTrue[#, characterQ] &);
$validFirstArgumentPattern = Alternatives[
	$characterCodePattern,
	$characterCodeListPattern,
	$characterPattern,
	$characterListPattern];

(** valid property **)
(* character properties *)
$c$characterProperties = {
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
	"WhiteSpaceQ"};

$characterProperties = Join[$c$characterProperties, {}];
$characterPropertyPattern := $characterPropertyPattern = Alternatives @@ $characterProperties;

(** valid sub-property **)
$characterSubProperties = {Automatic, "Date", "Name", "ShortName"};
$characterSubPropertyPattern := $characterSubPropertyPattern = Alternatives @@ $characterSubProperties;

(* iCharacterData *)
(** Extra functionality **)
iCharacterData[h_, All, "Properties"] :=
	Sort @ $characterProperties

(** character code **)
iCharacterData[
	h_,
	cp : $characterCodePattern,
	prop : $characterPropertyPattern] :=
	characterData$c[cp, {prop, Automatic}]

iCharacterData[
	h_,
	cp : $characterCodePattern,
	prop : $characterPropertyPattern,
	sub : $characterSubPropertyPattern] :=
	characterData$c[cp, {prop, sub}]

(** list of character codes **)
iCharacterData[
	h_,
	cps : $characterCodeListPattern,
	prop : $characterPropertyPattern] :=
	characterData$c[#, {prop, Automatic}] & /@ cps

iCharacterData[
	h_,
	cps : $characterCodeListPattern,
	prop : $characterPropertyPattern,
	sub : $characterSubPropertyPattern] :=
	characterData$c[#, {prop, sub}] & /@ cps

(** character string **)
iCharacterData[
	h_,
	ch : $characterPattern,
	prop : $characterPropertyPattern] :=
	characterData$c[First@ToCharacterCode[ch], {prop, Automatic}]

iCharacterData[
	h_,
	ch : $characterPattern,
	prop : $characterPropertyPattern,
	sub : $characterSubPropertyPattern] :=
	characterData$c[First@ToCharacterCode[ch], {prop, sub}]

(** list of character strings **)
iCharacterData[
	h_,
	ch : $characterListPattern,
	prop : $characterPropertyPattern] :=
	characterData$c[#, {prop, Automatic}] & /@ Flatten[ToCharacterCode[ch]]

iCharacterData[
	h_,
	ch : $characterListPattern,
	prop : $characterPropertyPattern,
	sub : $characterSubPropertyPattern] :=
	characterData$c[#, {prop, sub}] & /@ Flatten[ToCharacterCode[ch]]

(** List of properties **)
iCharacterData[
	h_,
	chr : $validFirstArgumentPattern,
	props : {Alternatives[
		$characterPropertyPattern,
		{$characterPropertyPattern,
		_}] ..}] :=
	iCharacterData[Unevaluated @ h, chr, Replace[#, {x_, y_} :> Sequence[x, y]]] & /@ props

(** Unevaluated messages **)
iCharacterData[h_, ch_ , args___] /; !MatchQ[ch, $validFirstArgumentPattern]:=
	(Message[CharacterData::errchar, h];
	Throw[$$unevaluated, $$tag])

iCharacterData[h_, _ , prop_, args___] /; !MatchQ[prop, $characterPropertyPattern]:=
	(Message[CharacterData::errprop, h];
	Throw[$$unevaluated, $$tag])

iCharacterData[h_, _ , _, sprop_] /; !MatchQ[sprop, $characterSubPropertyPattern]:=
	(Message[CharacterData::errsprop, h];
	Throw[$$unevaluated, $$tag])

iCharacterData[args___] :=
	Throw[$$unevaluated, $$tag]
