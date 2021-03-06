#!/usr/bin/env wolframscript

(* Disable messages about outdated cloud. *)
Off[CloudConnect::clver];

$redColor = "\033[0;31m";
$greenColor = "\033[0;32m";
$orangeColor = "\033[0;33m";
$yellowColor = "\033[1;33m";
$endColor = "\033[0m";

$commandLineArgs = Rest[$ScriptCommandLine];

tryPopFlag[longFlag_String, shortFlag_String] := If[
  MemberQ[$commandLineArgs, longFlag | shortFlag],
  $commandLineArgs = DeleteCases[$commandLineArgs, longFlag | shortFlag];
  True
,
  False
];

If[tryPopFlag["--load-installed-paclet", "-lip"],
  $localICULibraryEntryPoint = "ICULibrary`";
,
  $localICULibraryEntryPoint = FileNameJoin[{FileNameDrop[$InputFileName], "Kernel", "init.m"}];
];

Print["Loading ICULibrary from ", $yellowColor, FindFile[$localICULibraryEntryPoint], $endColor];
Check[
  Get[$localICULibraryEntryPoint];
,
  Print[$redColor, "Messages occurred during loading of ICULibrary, aborting tests.", $endColor];
  Exit[1];
];

Needs["GeneralUtilities`"];

$successQ = True;

$testFiles = If[Length @ $commandLineArgs >= 1,
  Replace[$commandLineArgs, {
    args : {"-e", ___} :> Select[
      FileNames[FileNameJoin[{AbsoluteFileName["."], "Tests", "*.wlt"}]],
      !MatchQ[FileBaseName @ #, Alternatives @@ Rest[args]] &
    ],
    args_List :> (FileNameJoin[{AbsoluteFileName["."], "Tests", # <> ".wlt"}] & /@ args)}
  ],
  FileNames[FileNameJoin[{AbsoluteFileName["."], "Tests", "*.wlt"}]]
];

If[!FileExistsQ[#],
  Print["Test file ", #, " does not exist."];
  Exit[1];
] & /@ $testFiles;

(* Read tests *)

printFileLineError[FileLine[file_, line_] -> error_] :=
  Print[file <> ":" <> IntegerString[line] <> "\t" <> error];

importAsHeldExpression[file_] := Module[{exprs},
  exprs = Quiet @ ToExpression[Import[file, "Text"], InputForm, Hold];
  If[FailureQ[exprs],
    WriteString["stdout", $redColor <> "There were syntax errors in \"" <> file <> "\"" <> $endColor, ":"];
    (* this will cause a message that will print out the syntax error as Get would, but without evaluating any
       expressions. The Options override is because apparently someone changed Get in the kernel and forget to change
       FullGet, so it is missing an option! *)
    Unprotect[Language`FullGet];
    Options[Language`FullGet] = Options[Get];
    Language`FullGet[file, Null, HoldComplete];
    Exit[1];
  ];
  exprs
];

$testGroups = Join @@ (
  KeyMap[ReleaseHold, #] & /@
    ReleaseHold @ Map[Hold, importAsHeldExpression[#], {5}] & /@ $testFiles);

Attributes[test] = Attributes[constrainedTest] = {HoldAll};

$singleTestTimeConstraint = 300;
$singleTestMemoryConstraint = 1*^9;
constrainedTest[args___] := With[{
    timeConstraintOpt =
      If[FreeQ[Hold[{args}], TimeConstraint], {TimeConstraint -> $singleTestTimeConstraint}, {}],
    memoryConstraintOpt =
      If[FreeQ[Hold[{args}], MemoryConstraint], {MemoryConstraint -> $singleTestMemoryConstraint}, {}]},
  test[args, ##] & @@ Join[timeConstraintOpt, memoryConstraintOpt]
];

removeHoldFormFromInputString[input_String] := StringReplace[
  input,
  StartOfString ~~ "HoldForm[" ~~ expr__ ~~ "]" ~~ EndOfString :> expr
];

$results = Association[KeyValueMap[Function[{testGroupName, testGroup}, Module[{
    testList, testResults, testReport, options, runInit, failedTests, bodyWrapper
  },
  (* Notify the user which test group we are running *)
  WriteString["stdout",
    testGroupName,
    StringJoin[ConstantArray[" ", Max[40 - StringLength[testGroupName], 1]]]];

  (* Read options *)
  options = Association[ReleaseHold[Lookup[testGroup, "options", <||>]]];

  (
    (* Run init, changing VerificationTest to test in all definitions *)
    runInit[] := ReleaseHold[testGroup["init"] /. VerificationTest -> constrainedTest];
    runCleanup[] := ReleaseHold[testGroup["cleanup"] /. VerificationTest -> constrainedTest];
    runInit[];

    (* Make a list of tests, but don't run them yet *)
    testList = Flatten[ReleaseHold[testGroup["tests"] /. VerificationTest -> constrainedTest]];

    (* Run tests *)
    testResults = Map[# /. test -> VerificationTest &, testList];

    runCleanup[];
  );

  testReport = TestReport[testResults];

  (* Print the summary (green if ok, red if failed) *)
  WriteString[
    "stdout",
    If[testReport["AllTestsSucceeded"],
      $greenColor <> "[ok]" <> $endColor
    ,
      $successQ = False;
      StringJoin[
        $redColor <> "[",
        ToString @ testReport["TestsFailedCount"],
        "/",
        ToString @ Length @ testReport["TestResults"],
        " failed]" <> $endColor]
    ],
    "\n"];

  (* If tests failed, print why *)
  failedTests = Join @@ testReport["TestsFailed"];
  Switch[#["Outcome"],
    "Failure",
      WriteString["stdout",
        $redColor <> "Input" <> $endColor <> "\n",
        "> ", removeHoldFormFromInputString[ToString[#["Input"], InputForm]], "\n\n",
        $redColor <> "evaluated to" <> $endColor <> "\n",
        "> ", ToString[#["ActualOutput"], OutputForm], "\n\n",
        $redColor <> "instead of expected " <> $endColor <> "\n",
        "> ", ToString[#["ExpectedOutput"], OutputForm], "\n\n\n"],
    "MessagesFailure",
      WriteString["stdout",
        $orangeColor <> "Input" <> $endColor <> "\n",
        "> ", removeHoldFormFromInputString[ToString[#["Input"], InputForm]], "\n\n",
        $orangeColor <> "generated messages" <> $endColor <> "\n",
        "> ", ToString[#["ActualMessages"], OutputForm], "\n\n",
        $orangeColor <> "instead of expected" <> $endColor <> "\n",
        "> ", ToString[#["ExpectedMessages"], OutputForm], "\n\n\n"],
    "Error",
      WriteString["stdout",
        $yellowColor <> "Error while evaluating the test with input" <> $endColor <> "\n",
        "> ", removeHoldFormFromInputString[ToString[#["Input"], InputForm]], "\n\n\n"]
  ] & /@ failedTests[[1 ;; UpTo[3]]];

  (* If too many tests have failed, print how many remain *)
  If[Length[failedTests] > 3,
    WriteString["stdout",
      "Omitting remaining ",
      Length[failedTests] - 3,
      " " <> testGroupName,
      " test failures.\n\n"]
  ];

  (* Return the report, we'll need it later *)
  testGroupName -> testReport
]], $testGroups]];

(* Create a notebook with results *)

$reportFile = UsingFrontEnd[
  $NotebookInlineStorageLimit = Infinity;
  Export[
    FileNameJoin[Join[FileNameSplit[CreateDirectory[]], {"testReport.nb"}]],
    Notebook @ Catenate @ Prepend[KeyValueMap[
      {Cell[Last @ FileNameSplit @ #1, "Section"],
        Cell[
          BoxData[RowBox[{"TestReport", "[", "\"" <> #1 <> "\"", "]"}]],
          "Input"],
        Cell[BoxData[ToBoxes[#2]], "Output"]} &,
      $results], {Cell["ICULibrary Test Report", "Title"]}]
  ]
];

Print["Report file: ", $reportFile];

If[$MessageList =!= {}, $successQ = False];

If[Environment["STATUS_FILE"] === "1",
  Export["exit_status.txt", If[$successQ, 0, 1]];
];

If[$successQ,
  Print["Tests passed."];
  Exit[0]
,
  Print["Tests failed."];
  Exit[1]
];
