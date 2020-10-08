<|
  "$ICULibraryGitSHA" -> <|
    "tests" -> {
      VerificationTest[
        StringLength @ $ICULibraryGitSHA,
        40
      ],

      VerificationTest[
        StringMatchQ[$ICULibraryGitSHA, HexadecimalCharacter...]
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
        DateObject[{2020, 3, 17, 0, 0, 0}, TimeZone -> "UTC"] < $ICULibraryBuildTime
      ]
    }
  |>
|>
