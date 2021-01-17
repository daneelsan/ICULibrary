Package["ICULibraryDevUtils`"]

PackageImport["GeneralUtilities`"]

PackageExport["BuildLibICULibrary"]

Options[BuildLibICULibrary] = {
  "RepositoryDirectory" :> $ICULibraryRoot,
  "LibrarySourceDirectory" -> Automatic,
  "LibraryTargetDirectory" -> Automatic,
  "SystemID" -> $SystemID,
  "Compiler" -> Automatic,
  "CompilerInstallation" -> Automatic,
  "WorkingDirectory" -> Automatic,
  "LoggingFunction" -> None,
  "PreBuildCallback" -> None,
  "Caching" -> True,
  "Verbose" -> False
};

SetUsage @ "
BuildLibICULibrary[] builds the libICULibrary library from source, and returns an association of metadata \
on completion, or $Failed if the library could not be built.
* By default, the resulting library is placed within the appropriate system-specific subdirectory of the \
'LibraryResources' directory of the current repo, but this location can be overriden with the \
'LibraryTargetDirectory' option.
* By default, the sources are obtained from the 'libICULibrary' subdirectory of the current repo, but this \
location can be overriden with the 'LibrarySourceDirectory' option.
* The meaning of 'current repo' for the above two options is set by the 'RepositoryDirectory' option, which \
defaults to the root of the repo containing the DevUtils package.
* Additional metadata is written to 'LibraryTargetDirectory' in a file called 'libICULibraryBuildInfo.json'.
* The library file name includes a hash based on the library and build utility sources.
* If the library target directory fills up with more than 128 files, the least recently generated files \
will be automatically deleted.
* If a library file with the appropriate hashes already exists, the build step is skipped, but the build \
metadata is still written to a json file in the 'LibraryTargetDirectory'.
* Various compiler options can be specified with 'Compiler', 'CompilerInstallation', 'WorkingDirectory', \
and 'LoggingFunction'.
* Setting 'PreBuildCallback' to a function will call this function prior to build happening, but only \
if a build is actually required. This is useful for printing a message in this case. This function is \
given the keys containing relevant build information.
* Setting 'Caching' to False can be used to prevent the caching mechanism from being applied.
* Setting 'Verbose' to True will Print information about the progress of the build.
";

BuildLibICULibrary::compfail = "Compilation of C code at `` failed.";
BuildLibICULibrary::badsourcedir = "Source directory `` did not exist.";

BuildLibICULibrary[OptionsPattern[]] := ModuleScope[
  (* options processing *)
  UnpackOptions[
    repositoryDirectory, librarySourceDirectory, libraryTargetDirectory,
    systemID, compiler, compilerInstallation, workingDirectory, loggingFunction,
    preBuildCallback, caching, verbose
  ];

  SetAutomatic[compiler, ToExpression @ ConsoleTryEnvironment["COMPILER", Automatic]];
  SetAutomatic[compilerInstallation, ConsoleTryEnvironment["COMPILER_INSTALLATION", Automatic]];
  SetAutomatic[librarySourceDirectory, FileNameJoin[{repositoryDirectory, "libICULibrary"}]];
  SetAutomatic[libraryTargetDirectory, FileNameJoin[{repositoryDirectory, "LibraryResources", systemID}]];

  (* path processing *)
  buildDataPath = FileNameJoin[{libraryTargetDirectory, "libICULibraryBuildInfo.json"}];
  librarySourceDirectory = AbsoluteFileName[librarySourceDirectory];
  If[FailureQ[librarySourceDirectory], ReturnFailed["badsourcedir", librarySourceDirectory]];

  (* derive hashes *)
  sourceHashes = Join[
    FileTreeHashes[librarySourceDirectory, {"*.c", "*.h"}, 1],
    FileTreeHashes[$DevUtilsRoot, {"*.m"}, 1]
  ];
  hashedOptions = {compiler, compilerInstallation, systemID};
  finalHash = Base36Hash[{sourceHashes, hashedOptions}];

  (* derive final paths *)
  libraryFileName = StringJoin["libICULibrary-", finalHash, ".", System`Dump`LibraryExtension[]];
  libraryPath = FileNameJoin[{libraryTargetDirectory, libraryFileName}];

  calculateBuildData[] := Association[
    "LibraryPath" -> libraryPath,
    "LibraryFileName" -> libraryFileName,
    "LibraryBuildTime" -> Round[DateList[FileDate[libraryPath], TimeZone -> "UTC"]],
    "LibrarySourceHash" -> finalHash
  ];

  (* if a cached library exists with the right name, we can skip the compilation step, and need
  only write the JSON file *)
  If[caching && FileExistsQ[libraryPath] && FileExistsQ[buildDataPath],
    buildData = readBuildData[buildDataPath];

    (* the JSON file might already be correct, in which case don't write to at all *)
    If[buildData["LibraryFileName"] === libraryFileName,
      PrependTo[buildData, "LibraryPath" -> libraryPath];
    ,
      buildData = calculateBuildData[];
      writeBuildData[buildDataPath, buildData];
    ];
    buildData["FromCache"] = True;
    If[verbose, Print["Using cached library at ", libraryPath]];
    Return[buildData];
  ];

  (* prevent too many libraries from building up in the cache *)
  If[caching, flushLibrariesIfFull[libraryTargetDirectory]];

  (* if user gave a callback, call it now with relevant info *)
  If[verbose && preBuildCallback === None, preBuildCallback = "Print"];
  If[preBuildCallback =!= None,
    If[preBuildCallback === "Print", preBuildCallback = $printPreBuildCallback];
    preBuildCallback[<|
      "LibrarySourceDirectory" -> librarySourceDirectory,
      "LibraryFileName" -> libraryFileName|>]
  ];

  fileNames = FileNames["*.c", librarySourceDirectory];
  libraryPath = wrappedCreateLibrary[
      fileNames,
      libraryFileName,
      "Libraries" -> {"icudata", "icuuc", "icui18n", "icuio", "icutu"},
      "CleanIntermediate" -> True,
      "CompileOptions" -> $compileOptions,
      "Compiler" -> compiler,
      "CompilerInstallation" -> compilerInstallation,
      "Language" -> "C",
      "ShellCommandFunction" -> loggingFunction,
      "ShellOutputFunction" -> loggingFunction,
      "TargetDirectory" -> libraryTargetDirectory,
      "TargetSystemID" -> systemID,
      "WorkingDirectory" -> workingDirectory
  ];

  If[!StringQ[libraryPath],
    Message[BuildLibICULibrary::compfail, librarySourceDirectory];
    If[verbose, Print["Build failed"]];
    ReturnFailed[];
  ];
  If[verbose,
    Print["Library compiled to ", libraryPath]];

  buildData = calculateBuildData[];
  writeBuildData[buildDataPath, buildData];
  buildData["FromCache"] = False;
  buildData
];

$printPreBuildCallback = Function[Print["Building libICULibrary from sources in ", #LibrarySourceDirectory]];

readBuildData[jsonFile_] :=
  Developer`ReadRawJSONFile[jsonFile];

writeBuildData[jsonFile_, buildData_] :=
  Developer`WriteRawJSONFile[
    jsonFile,
    KeyDrop[buildData, {"LibraryPath", "FromCache"}],
    "Compact" -> 1
  ];

(* avoids loading CCompilerDriver until it is actually used *)
wrappedCreateLibrary[args___] := Block[{$ContextPath},
  Needs["CCompilerDriver`"];
  CCompilerDriver`CreateLibrary[args]
];

$warningsFlags = {
  "-Wall", "-Wpedantic", "-pedantic-errors", "-Waggregate-return",
  "-Wbad-function-cast", "-Wcast-align", "-Wcast-qual", "-Wfloat-equal",
  "-Wformat=2", "-Wlogical-op", "-Wmissing-include-dirs", "-Wnested-externs",
  "-Wpointer-arith", "-Wredundant-decls", "-Wsequence-point", "-Wshadow",
  "-Wstrict-prototypes", "-Wswitch", "-Wundef", "-Wunreachable-code",
  "-Wunused-but-set-parameter", "-Wwrite-strings"
  (*,"-DU_USING_ICU_NAMESPACE=1"*)
};

$compileOptions = Switch[$OperatingSystem,
  "Windows",
    {"/std:c11", "/EHsc"},
  "MacOSX",
    Join[{"-std=c11"}, $warningsFlags],
  "Unix",
    Join[{"-std=c11"}, $warningsFlags]
];

flushLibrariesIfFull[libraryDirectory_] := Scope[
  files = FileNames["lib*", libraryDirectory];
  If[Length[files] > 127,
    oldestFile = MinimalBy[files, FileDate, 8];
    Scan[DeleteFile, oldestFile]
  ]
];
