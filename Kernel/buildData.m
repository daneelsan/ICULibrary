Package["ICULibrary`"]

PackageImport["GeneralUtilities`"]

PackageScope["$packageRoot"]

$packageRoot = FileNameDrop[$InputFileName, -2];

ICULibrary::jitbuildfail = "Failed to (re)build libICULibrary. The existing library, if any, will be used instead.";

(* before loading build data, we check if we are running on a developer's machine, indicated by
the presence of the DevUtils sub-package, if so, we load it and do a rebuild, so that we can
get up-to-date versions of the various build properties *)
$devUtilsPath = FileNameJoin[{$packageRoot, "DevUtils", "init.m"}];
If[FileExistsQ[$devUtilsPath],
  Block[{$ContextPath = {"System`"}}, Get[$devUtilsPath]];

  (* forwarders for the functions we want from DevUtils. This is done so
  we don't create the ICULibraryDevUtils context for ordinary users (when DevUtils *isn't* available) *)
  buildLibICULibrary = Symbol["ICULibraryDevUtils`BuildLibICULibrary"];
  gitSHAWithDirtyStar = Symbol["ICULibraryDevUtils`GitSHAWithDirtyStar"];

  (* try build the C code immediately (which will most likely retrieve a cached library) *)
  (* if there is a frontend, then give a temporary progress panel, otherwise just Print *)
  If[TrueQ @ $Notebooks,
    (* WithLocalSettings will run the final 'cleanup' argument even if the evaluation of the second
    argument aborts (due to a Throw, user abort, etc.) *)
    Internal`WithLocalSettings[
      $progCell = None;
    ,
      $buildResult = buildLibICULibrary["PreBuildCallback" -> Function[
        $progCell = PrintTemporary @ Panel[
          "Building libICULibrary from sources in " <> #LibrarySourceDirectory,
          Background -> LightOrange]]];
    ,
      NotebookDelete[$progCell];
      $progCell = None;
    ];
  ,
    $buildResult = buildLibICULibrary["PreBuildCallback" -> "Print"];
  ];

  If[!AssociationQ[$buildResult],
    Message[ICULibrary::jitbuildfail];
  ];
];

readJSONFile[file_] := Quiet @ Check[Developer`ReadRawJSONFile[file], $Failed];

PackageExport["$ICULibraryLibraryBuildTime"]
PackageExport["$ICULibraryLibraryPath"]

SetUsage @ "
$ICULibraryLibraryBuildTime gives the date object at which this C libICULibrary library was built.
";

SetUsage @ "
$ICULibraryLibraryPath stores the path of the C libICULibrary library.
";

$libraryDirectory = FileNameJoin[{$packageRoot, "LibraryResources", $SystemID}];
$libraryBuildDataPath = FileNameJoin[{$libraryDirectory, "libICULibraryBuildInfo.json"}];

$buildData = readJSONFile[$libraryBuildDataPath];
If[$buildData === $Failed,
  $ICULibraryLibraryBuildTime = $ICULibraryLibraryPath = Missing["LibraryBuildDataNotFound"];
,
  $ICULibraryLibraryBuildTime = DateObject[$buildData["LibraryBuildTime"], TimeZone -> "UTC"];
  $ICULibraryLibraryPath = FileNameJoin[{$libraryDirectory, $buildData["LibraryFileName"]}];
];

PackageExport["$ICULibraryBuildTime"]
PackageExport["$ICULibraryGitSHA"]

SetUsage @ "
$ICULibraryBuildTime gives the time at which this ICULibrary paclet was built.
* When evaluated for an in-place build, this time is the time at which ICULibrary was loaded.
";

SetUsage @ "
$ICULibraryGitSHA gives the Git SHA of the repository from which this SetRepace paclet was built.
* When evaluated for an in-place build, this is simply the current HEAD of the git repository.
";

$pacletBuildInfoPath = FileNameJoin[{$packageRoot, "PacletBuildInfo.json"}];

If[FileExistsQ[$pacletBuildInfoPath] && AssociationQ[$pacletBuildInfo = readJSONFile[$pacletBuildInfoPath]],
  $ICULibraryBuildTime = DateObject[$pacletBuildInfo["BuildTime"], TimeZone -> "UTC"];
  $ICULibraryGitSHA = $pacletBuildInfo["GitSHA"];
,
  $ICULibraryGitSHA = gitSHAWithDirtyStar[$packageRoot];
  If[!StringQ[$ICULibraryGitSHA], Missing["GitLinkNotAvailable"]];
  $ICULibraryBuildTime = DateObject[TimeZone -> "UTC"];
];
