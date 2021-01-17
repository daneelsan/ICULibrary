Package["ICULibraryDevUtils`"]

PackageImport["GeneralUtilities`"]

PackageExport["PackICULibrary"]

Options[PackICULibrary] = {
  "RepositoryDirectory" :> $ICULibraryRoot, (* for Git SHAs etc *)
  "SourceDirectory" -> Automatic, (* for WL sources *)
  "LibraryDirectory" -> Automatic, (* for libICULibrary *)
  "MasterBranch" -> "master", (* for calculating the minor version *)
  "OutputDirectory" -> Automatic,
  "Verbose" -> False
};

PackICULibrary::nosources = "There were no .m files in ``.";
PackICULibrary::nolibraries = "There were no library files in ``.";
PackICULibrary::packfailed = "Could not pack paclet from `` into ``.";
PackICULibrary::nopacletinfo = "Paclet info file was not present at ``.";
PackICULibrary::nobuildinfo = "Build info file was not present at ``.";
PackICULibrary::nogitlink = "GitLink is not installed, so the built paclet version cannot be correctly \
calculated. Proceed with caution, and consider installing GitLink by running InstallGitLink[].";

SetUsage @ "
PackICULibrary[] creates a PacletObject containing the local source and last built library.
* Note that PackICULibrary[] does *not* call BuildLibICULibrary[], unlike the command line scripts.
* The PacletObject represents a .paclet file created on disk.
* 'RepositoryDirectory' defaults to the repository containing DevUtils, but can be set to another directory.
* 'RepositoryDirectory' must be a Git repo, and will be used to obtain the Git SHA hash and minor version number.
* The default location of the .paclet file is within the BuiltPaclets subdirectory of the 'RepositoryDirectory', \
but that can be overriden with the 'OutputDirectory' option.
* The Wolfram Language sources for the paclet are taken from the Kernel subdirectory of 'SourceDirectory'.
* The built libICULibrary libraries are taken from the LibraryResources subdirectory of 'LibraryDirectory'.
* 'SourceDirectory' and 'LibraryDirectory' default to the value of 'RepositoryDirectory'.
* The minor version is derived from the number of commits between the last checkpoint and the 'master' branch,
which can be overriden with the 'MasterBranch' option. The checkpoint is defined in `scripts/version.wl`. The \
git repo is assumed to live at 'RepositoryDirectory'.
* Setting 'Verbose' to True will Print information about the progress of the pack.
";

PackICULibrary[OptionsPattern[]] := ModuleScope[
  UnpackOptions[sourceDirectory, libraryDirectory, repositoryDirectory, masterBranch, outputDirectory, verbose];
  SetAutomatic[outputDirectory, FileNameJoin[{repositoryDirectory, "BuiltPaclets"}]];
  SetAutomatic[libraryDirectory, repositoryDirectory];
  SetAutomatic[sourceDirectory, repositoryDirectory];
  EnsureDirectory[outputDirectory];

  If[$GitLinkAvailableQ,
    minorVersionNumber = CalculateMinorVersionNumber[repositoryDirectory, masterBranch];
    pacletInfoFile = createUpdatedPacletInfo[FileNameJoin[{sourceDirectory, "PacletInfo.m"}], minorVersionNumber];
    gitSHA = GitSHAWithDirtyStar[repositoryDirectory];
  ,
    Message[PackICULibrary::nogitlink];
    pacletInfoFile = FileNameJoin[{sourceDirectory, "PacletInfo.m"}];
    gitSHA = Missing["GitLinkNotAvailable"];
  ];

  buildInfo = <|"GitSHA" -> gitSHA, "BuildTime" -> Round[DateList[TimeZone -> "UTC"]]|>;
  tempBuildInfoFile = FileNameJoin[{$DevUtilsTemporaryDirectory, "PacletBuildInfo.json"}];
  Developer`WriteRawJSONFile[tempBuildInfoFile, buildInfo];

  kernelDir = FileNameJoin[{sourceDirectory, "Kernel"}];
  libraryDir = FileNameJoin[{libraryDirectory, "LibraryResources"}];
  If[Length[FileNames["*.m", kernelDir]] == 0, ReturnFailed["nosources", kernelDir]];
  If[Length[FileNames[All, libraryDir, 2]] == 0, ReturnFailed["nolibraries", libraryDir]];
  If[!FileExistsQ[pacletInfoFile], ReturnFailed["nopacletinfo", pacletInfoFile]];
  If[!FileExistsQ[tempBuildInfoFile], ReturnFailed["nobuildinfo", tempBuildInfoFile]];

  fileInputs = {kernelDir, libraryDir, pacletInfoFile, tempBuildInfoFile};

  pacletCreatorFunction = If[$VersionNumber >= 12.1,
    Symbol["System`CreatePacletArchive"],
    Symbol["PacletManager`PackPaclet"]];
  pacletFileName = pacletCreatorFunction[fileInputs, outputDirectory];

  If[StringQ[pacletFileName],
    If[verbose,
      Print["Paclet file written to ", pacletFileName]];
    Return @ If[$VersionNumber >= 12.1,
      PacletObject[File[pacletFileName]],
      <|"Location" -> pacletFileName|>
    ]
  ,
    If[verbose, Print["Pack failed."]];
    ReturnFailed["packfailed", sourceDirectory, outputDirectory]
  ]
];

createUpdatedPacletInfo[pacletInfoFilename_, minorVersionNumber_] := ModuleScope[
  pacletInfo = Association @@ Import[pacletInfoFilename];
  versionString = pacletInfo[Version] <> "." <> ToString[minorVersionNumber];
  tempFilename = FileNameJoin[{$DevUtilsTemporaryDirectory, "PacletInfo.m"}];
  AppendTo[pacletInfo, Version -> versionString];
  Block[{$ContextPath = {"System`", "PacletManager`"}},
    Export[tempFilename, PacletManager`Paclet @@ Normal[pacletInfo]]
  ];
  tempFilename
];
