<|
  "CharacterData" -> <|
    "init" -> (
      Attributes[Global`testUnevaluated] = Attributes[Global`testSymbolLeak] = {HoldAll};
      Global`testUnevaluated[args___] := ICULibrary`PackageScope`testUnevaluated[VerificationTest, args];
      Global`testSymbolLeak[args___] := ICULibrary`PackageScope`testSymbolLeak[VerificationTest, args];
    ),
    "tests" -> {
      (* Argument count *)

      testUnevaluated[
        CharacterData[],
        {CharacterData::argt}
      ],

      testUnevaluated[
        CharacterData[0],
        {CharacterData::argtu}
      ],

      testUnevaluated[
        CharacterData[0, "ExtendedName", Automatic, 0],
        {CharacterData::argt}
      ],

      (* Argument checks *)

      testUnevaluated[
        CharacterData[-1, "ExtendedName"],
        {CharacterData::errchar}
      ],

      testUnevaluated[
        CharacterData[{-1, 0}, "ExtendedName"],
        {CharacterData::errchar}
      ],

      testUnevaluated[
        CharacterData[{"a", "aa"}, "ExtendedName"],
        {CharacterData::errchar}
      ],

      testUnevaluated[
        CharacterData[-1, 0],
        {CharacterData::errchar}
      ],

      testUnevaluated[
        CharacterData[0, 0],
        {CharacterData::errprop}
      ],

      testUnevaluated[
        CharacterData[0, {0}],
        {CharacterData::errprop}
      ],

      testUnevaluated[
        CharacterData[0, {"Name", 0}],
        {CharacterData::errprop}
      ],

      testUnevaluated[
        CharacterData[0, {{"Name"}}],
        {CharacterData::errprop}
      ],

      testUnevaluated[
        CharacterData[0, "ExtendedName", 0],
        {CharacterData::errsprop}
      ],

      (** First argument / character code **)

      VerificationTest[
        CharacterData[0, "Name"],
        Missing["NotAvailable"]
      ],

      VerificationTest[
        CharacterData[65, "Name"],
        "LATIN CAPITAL LETTER A"
      ],

      VerificationTest[
        CharacterData[65, "Name", Automatic],
        "LATIN CAPITAL LETTER A"
      ],

      VerificationTest[
        CharacterData[65, "LetterQ", Automatic],
        True
      ],

      VerificationTest[
        CharacterData[65, "ExtendedName", "Date"],
        Missing["NotAvailable"]
      ],

      (** First argument / character **)

      VerificationTest[
        CharacterData["\.10", "Name"],
        Missing["NotAvailable"]
      ],

      VerificationTest[
        CharacterData["A", "Name"],
        "LATIN CAPITAL LETTER A"
      ],

      VerificationTest[
        CharacterData["A", "Name", Automatic],
        "LATIN CAPITAL LETTER A"
      ],

      VerificationTest[
        CharacterData["A", "LetterQ", Automatic],
        True
      ],

      VerificationTest[
        CharacterData["A", "ExtendedName", "Date"],
        Missing["NotAvailable"]
      ],

      (** First argument / list **)

      VerificationTest[
        CharacterData[Range[1000, 1005], "LetterQ"],
        {True, True, True, True, True, True}
      ],

      VerificationTest[
        CharacterData[Range[1000, 1005], "LetterQ", Automatic],
        {True, True, True, True, True, True}
      ],

      VerificationTest[
        CharacterData[CharacterRange[1000, 1014], "LetterQ"],
        {True, True, True, True, True, True, True, True, True, True, True, True, True, True, False}
      ],

      VerificationTest[
        CharacterData[Range[1000, 1014], "LetterQ", Automatic],
        {True, True, True, True, True, True, True, True, True, True, True, True, True, True, False}
      ],

      VerificationTest[
        CharacterData[CharacterRange[1000, 1005], "ExtendedName", "Date"],
        {Missing["NotAvailable"], Missing["NotAvailable"],  Missing["NotAvailable"], \
	Missing["NotAvailable"], Missing["NotAvailable"], Missing["NotAvailable"]}
      ],

      (** List of properties **)

      VerificationTest[
        CharacterData[65, {{"LetterQ", Automatic}, "LetterQ", "LowerCase"}],
        {True, True, "a"}
      ],

      VerificationTest[
        CharacterData["A", {{"LetterQ", Automatic}, "LetterQ", "LowerCase"}],
        {True, True, "a"}
      ],

      VerificationTest[
        CharacterData[CharacterRange["a", "c"], {{"LetterQ", Automatic}, "LetterQ", "UpperCase"}],
        {{True, True, True}, {True, True, True}, {"A", "B", "C"}}
      ],

      (* Properties *)

      VerificationTest[
        CharacterData[All, "Properties"],
        {"BaseCharQ", "Block", "BMPCharQ", "CombiningClass", "DefinedQ", "DigitQ",
        "Direction", "ExtendedName", "FoldCase", "GeneralCategory", "IlegalQ", "ISOControlQ",
        "LetterDigitQ", "LetterQ", "LowerCase", "LowerCaseQ", "Mirror", "MirroredQ",
        "Name", "NameAlias", "NumericValue", "PairedBracket", "PrintableQ", "Script",
        "SupplementaryCharQ", "TitleCase", "TitleCaseQ", "UnicodeAlphabeticQ", "UnicodeLowerCaseQ", "UnicodeUpperCaseQ",
        "UnicodeVersion", "UpperCase", "UpperCaseQ", "WhiteSpaceQ"}
      ],

      (** BaseCharQ **)
      VerificationTest[
        CharacterData[{"a", "="}, "BaseCharQ"],
        {True, False}
      ],

      (** Block **)
      VerificationTest[
        CharacterData[{"\[Alpha]", "\[Beta]", "\[Gamma]"}, "Block"],
        {"Greek_And_Coptic", "Greek_And_Coptic", "Greek_And_Coptic"}
      ],

      VerificationTest[
        CharacterData[{"\[Alpha]", "\[Beta]", "\[Gamma]"}, "Block", "ShortName"],
        {"Greek", "Greek", "Greek"}
      ],

      (** BMPCharQ **)
      VerificationTest[
        CharacterData[{16^^ffff, 16^^ffff + 1}, "BMPCharQ"],
        {True, False}
      ],

      (** CombiningClass **)
      VerificationTest[
        CharacterData["六", "CombiningClass"],
        "Not_Reordered"
      ],

      VerificationTest[
        CharacterData["六", "CombiningClass", "ShortName"],
        "NR"
      ],

      (** DefinedQ **)
      VerificationTest[
        CharacterData[0, "DefinedQ"],
        True
      ],

      VerificationTest[
        CharacterData[{16^^d800, 16^^ffff}, "DefinedQ"],
        {True, False}
      ],

      (** DigitQ **)
      VerificationTest[
        CharacterData["߄", "DigitQ"],
        True
      ],

      (** Direction **)
      VerificationTest[
        CharacterData["ع", "Direction"],
        "Arabic_Letter"
      ],

      VerificationTest[
        CharacterData["ع", "Direction", "ShortName"],
        "AL"
      ],

      (** ExtendedName **)
      VerificationTest[
        CharacterData[#, "ExtendedName"] & /@ {31, "ع"},
        {"<control-001F>", "ARABIC LETTER AIN"}
      ],

      (** FoldCase **)
      VerificationTest[
        CharacterData["Ⓘ", "FoldCase"],
        "ⓘ"
      ],

      VerificationTest[
        CharacterData["a", "FoldCase"],
        "a"
      ],

      (** GeneralCategory **)
      VerificationTest[
        Table[{i, CharacterData[i, "GeneralCategory"]}, {i, 28, 38}],
        {{28, "Control"}, {29, "Control"}, {30, "Control"}, {31, "Control"},
        {32, "Space_Separator"}, {33, "Other_Punctuation"}, {34, "Other_Punctuation"}, {35, "Other_Punctuation"},
        {36, "Currency_Symbol"}, {37, "Other_Punctuation"}, {38, "Other_Punctuation"}}
      ],

      VerificationTest[
        CharacterData[" ", "GeneralCategory", "ShortName"],
        "Zs"
      ],

      (** IlegalQ **)
      VerificationTest[
        Transpose[{Range[0, 65535], CharacterData[Range[0, 65535], "IlegalQ"]}] // Select[TrueQ@*Last],
        {{64976, True}, {64977, True}, {64978, True}, {64979, True}, {64980, True},
        {64981, True}, {64982, True}, {64983, True}, {64984, True}, {64985, True},
        {64986, True}, {64987, True}, {64988, True}, {64989, True}, {64990, True},
        {64991, True}, {64992, True}, {64993, True}, {64994, True}, {64995, True},
        {64996, True}, {64997, True}, {64998, True}, {64999, True}, {65000, True},
        {65001, True}, {65002, True}, {65003, True}, {65004, True}, {65005, True},
        {65006, True}, {65007, True}, {65534, True}, {65535, True}}
      ],

      (** ISOControlQ **)
      VerificationTest[
        CharacterData[Range[0, 32], "ISOControlQ"],
        {True, True, True, True, True, True, True, True, True, True, True, True,
        True, True, True, True, True, True, True, True, True, True, True, True,
        True, True, True, True, True, True, True, True, False}
      ],

      (** LetterDigitQ **)
      VerificationTest[
        CharacterData[{"㵨", "蚐", "嬭", "뎷", "-"}, "LetterDigitQ"],
        {True, True, True, True, False}
      ],

      (** LetterQ **)
      VerificationTest[
        CharacterData[{"䩁", "轡", "ẹ", "橀", "Ñ", "-"}, "LetterQ"],
        {True, True, True, True, True, False}
      ],

      (** LowerCase **)
      VerificationTest[
        CharacterData[{"Ǌ", "Ֆ"}, "LowerCase"],
        {"ǌ", "ֆ"}
      ],

      VerificationTest[
        CharacterData["\[Alpha]", "LowerCase"],
        "\[Alpha]"
      ],

      (** LowerCaseQ **)
      VerificationTest[
        CharacterData[{"ǌ", "ֆ"}, "LowerCaseQ"],
        {True, True}
      ],

      VerificationTest[
        CharacterData["ⓖ", {"LowerCaseQ", "UnicodeLowerCaseQ"}],
        {False, True}
      ],

      (** Mirror **)
      VerificationTest[
        CharacterData[{"⟆", "⟅"}, "Mirror"],
        {"⟅", "⟆"}
      ],

      VerificationTest[
        CharacterData["-", "Mirror"],
        "-"
      ],

      (** MirrorQ **)
      VerificationTest[
        CharacterData[{"⟆", "⟅"}, "MirroredQ"],
        {True, True}
      ],

      (** Name **)
      VerificationTest[
        CharacterData[#, "Name"] & /@ {31, "ع"},
        {Missing["NotAvailable"], "ARABIC LETTER AIN"}
      ],

      (** NameAlias **)
      VerificationTest[
        CharacterData[{"Ƣ", "ᇭ", "\[WeierstrassP]"}, "NameAlias"],
        {"LATIN CAPITAL LETTER GHA", "HANGUL JONGSEONG YESIEUNG-SSANGKIYEOK", "WEIERSTRASS ELLIPTIC FUNCTION"}
      ],

      (** NumericValue **)
      VerificationTest[
        CharacterData[{"ⅰ", "ⅱ", "ⅲ", "ⅳ", "ⅴ", "ⅵ", "ⅶ", "ⅷ", "ⅸ", "ⅹ", "ⅺ", "ⅻ"}, "NumericValue"],
        {1., 2., 3., 4., 5., 6., 7., 8., 9., 10., 11., 12.}
      ],

      VerificationTest[
        CharacterData[{
          "〇", "零", "一", "壹", "二", "貳", "三", "參", "四", "肆",
          "五", "伍", "六", "陸", "七", "柒", "八", "捌", "九", "玖",
          "十", "拾", "佰", "百", "仟", "千", "艌", "億"}, "NumericValue"],
        {0., 0., 1., 1., 2., 2., 3., 3., 4., 4.,
        5., 5., 6., 6., 7., 7., 8., 8., 9., 9.,
        10., 10., 100., 100., 1000., 1000., Missing["NotApplicable"], 1.*10^8}
      ],

      (** PairedBracket **)
      VerificationTest[
        CharacterData["᚜", "PairedBracket"],
        "᚛"
      ],

      (** PrintableQ **)
      VerificationTest[
        CharacterData[Range[0, 32], "PrintableQ"],
        {False, False, False, False, False, False, False, False, False,
        False, False, False, False, False, False, False, False, False,
        False, False, False, False, False, False, False, False, False,
        False, False, False, False, False, True}
      ],

      (** Script **)
      VerificationTest[
        CharacterData[Alphabet["Katakana"], "Script"][[1 ;; 2]],
        {"Katakana", "Katakana"}
      ],

      VerificationTest[
        CharacterData["\[ForAll]", "Script", "ShortName"],
        "Zyyy"
      ],

      (** SupplementaryCharQ **)
      VerificationTest[
        CharacterData[{16^^ffff, 16^^ffff + 1}, "SupplementaryCharQ"],
        {False, True}
      ],

      (** TitleCase **)
      VerificationTest[
        CharacterData[{"Ǆ", "ǆ", "Ǉ", "ǉ", "Ǌ", "ǌ", "Ǳ", "ǳ"}, "TitleCase"],
        {"ǅ", "ǅ", "ǈ", "ǈ", "ǋ", "ǋ", "ǲ", "ǲ"}
      ],

      VerificationTest[
        CharacterData["A", "TitleCase"],
        "A"
      ],

      (** TitleCaseQ **)
      VerificationTest[
        CharacterData[{"Ǆ", "ǆ", "Ǉ", "ǉ", "Ǌ", "ǌ", "Ǳ", "ǳ"}, "TitleCaseQ"],
        {True, True, True, True, True, True, True, True}
      ],

      (** UnicodeAlphabeticQ **)
      VerificationTest[
        CharacterData["ↀ", "UnicodeAlphabeticQ"],
        True
      ],

      VerificationTest[
        CharacterData["ↀ", {"UnicodeAlphabeticQ", "LetterQ"}],
        {True, False}
      ],

      (** UnicodeLowerCaseQ **)
      VerificationTest[
        CharacterData["ⓖ", "UnicodeLowerCaseQ"],
        True
      ],

      VerificationTest[
        CharacterData["ⓖ", {"UnicodeLowerCaseQ", "LowerCaseQ"}],
        {True, False}
      ],

      (** UnicodeUpperCaseQ **)
      VerificationTest[
        CharacterData["Ⅷ", "UnicodeUpperCaseQ"],
        True
      ],

      VerificationTest[
        CharacterData["Ⅷ", {"UnicodeUpperCaseQ", "UpperCaseQ"}],
        {True, False}
      ],

      (** UnicodeVersion **)
      VerificationTest[
        CharacterData["㉊", "UnicodeVersion"],
        {5, 2, 0, 0}
      ],

      VerificationTest[
        CharacterData["㉊", "UnicodeVersion", "Date"],
        DateObject[{2009, 10, 1}, "Day", "Gregorian", -5.]
      ],

      (** UpperCase **)
      VerificationTest[
        CharacterData[{"а", "ф"}, "UpperCase"],
        {"А", "Ф"}
      ],

      VerificationTest[
        CharacterData["A", "UpperCase"],
        "A"
      ],

      (** UpperCaseQ **)
      VerificationTest[
        CharacterData[{"А", "Ф"}, "UpperCaseQ"],
        {True, True}
      ],

      VerificationTest[
        CharacterData["Ⅷ", {"UpperCaseQ", "UnicodeUpperCaseQ"}],
        {False, True}
      ],

      (** WhiteSpaceQ **)
      VerificationTest[
        CharacterData[32, "WhiteSpaceQ"],
        True
      ]

    }
  |>
|>;
