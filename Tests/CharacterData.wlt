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
      ]

      (* Properties *)

    }
  |>
|>
