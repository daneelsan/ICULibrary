<|
  "$ICULibraryRootDirectory" -> <|
    "tests" -> {
      VerificationTest[
        FileExistsQ @ $ICULibraryRootDirectory
      ]
    }
  |>,

  "$ICULibraryGitSHA" -> <|
    "tests" -> {
      VerificationTest[
        StringMatchQ[$ICULibraryGitSHA, Repeated[HexadecimalCharacter, 40] ~~ Repeated["*", {0, 1}]]
      ]
    }
  |>,

  "$ICULibraryBuildTime" -> <|
    "tests" -> {
      VerificationTest[
        DateObjectQ @ $ICULibraryBuildTime
      ],

      VerificationTest[
        $ICULibraryBuildTime["TimeZone"],
        "UTC"
      ],

      (* could not be built in the future *)
      VerificationTest[
        $ICULibraryBuildTime < Now
      ],

      (* could not be built before $ICULibraryBuildTime was implemented *)
      VerificationTest[
        DateObject[{2020, 6, 1, 0, 0, 0}, TimeZone -> "UTC"] < $ICULibraryBuildTime
      ]
    }
  |>,

  "$ICULibraryLibraryPath" -> <|
    "tests" -> {
      VerificationTest[
        StringQ @ $ICULibraryLibraryPath
      ],

      VerificationTest[
        FileExistsQ @ $ICULibraryLibraryPath
      ]
    }
  |>,

  "$ICULibraryLibraryBuildTime" -> <|
    "tests" -> {
      VerificationTest[
        DateObjectQ @ $ICULibraryLibraryBuildTime
      ],

      VerificationTest[
        $ICULibraryLibraryBuildTime["TimeZone"],
        "UTC"
      ],

      (* could not be built in the future *)
      VerificationTest[
        $ICULibraryLibraryBuildTime < Now
      ],

      (* could not be built before $ICULibraryLibraryBuildTime was implemented *)
      VerificationTest[
        DateObject[{2020, 11, 22, 0, 0, 0}, TimeZone -> "UTC"] < $ICULibraryLibraryBuildTime
      ]
    }
  |>
|>
