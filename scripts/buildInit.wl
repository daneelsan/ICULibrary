(* ::Package:: *)

Needs["CCompilerDriver`"];
Needs["PacletManager`"];

$internalBuildQ = AntProperty["build_target"] === "internal";

If[PacletFind["GitLink", "Internal" -> All] === {},
	If[$internalBuildQ,
		PacletInstall["GitLink", "Site" -> "http://paclet-int.wolfram.com:8080/PacletServerInternal"],
		PacletInstall["https://www.wolframcloud.com/obj/maxp1/GitLink-2019.11.26.01.paclet"]
	];
];
Needs["GitLink`"];

$repoRoot = FileNameJoin[{DirectoryName[$InputFileName], ".."}];
$buildDirectory = If[$internalBuildQ,
	FileNameJoin[{AntProperty["files_directory"], AntProperty["component"]}],
	FileNameJoin[{$repoRoot, "Build"}]
];

tryEnvironment[var_, default_] := If[# === $Failed, default, #] & @ Environment[var];

buildLibICULibrary::fail = "Compilation failed. Paclet will be created without low level implementation.";

$warningsFlags = {
	"-Wall", "-Wpedantic", "-pedantic-errors", "-Waggregate-return",
	"-Wbad-function-cast", "-Wcast-align", "-Wcast-qual", "-Wfloat-equal",
	"-Wformat=2", "-Wlogical-op", "-Wmissing-include-dirs", "-Wnested-externs",
	"-Wpointer-arith", "-Wredundant-decls", "-Wsequence-point", "-Wshadow",
	"-Wstrict-prototypes", "-Wswitch", "-Wundef", "-Wunreachable-code",
	"-Wunused-but-set-parameter", "-Wwrite-strings"
	(*,"-DU_USING_ICU_NAMESPACE=1"*)
};

buildLibICULibrary[] := With[{
	libICULibrarySource = FileNameJoin[{$repoRoot, "libICULibrary"}],
	systemID = If[$internalBuildQ, AntProperty["system_id"], $SystemID]
	},
	If[$internalBuildQ, Off[CreateLibrary::wddirty]];
	If[!StringQ[CreateLibrary[
			FileNames["*.c", {libICULibrarySource}],
			"libICULibrary",
			"CleanIntermediate" -> True,
			"CompileOptions" -> Switch[$OperatingSystem,
				"Windows", {"/std:c11", "/EHsc"},
				"MacOSX", Join[{"-std=c11"}, $warningsFlags],
				"Unix", Join[{"-std=c11"}, $warningsFlags]
			],
			"Compiler" -> ToExpression @ tryEnvironment["COMPILER", Automatic],
			"CompilerInstallation" -> tryEnvironment["COMPILER_INSTALLATION", Automatic],
			"Language" -> "C",
			"ShellCommandFunction" -> If[$internalBuildQ, Global`AntLog, None],
			"ShellOutputFunction" -> If[$internalBuildQ, Global`AntLog, None],
			"TargetDirectory" -> FileNameJoin[{$buildDirectory, "LibraryResources", systemID}],
			"TargetSystemID" -> systemID,
			"WorkingDirectory" -> If[$internalBuildQ, AntProperty["scratch_directory"], Automatic]
		]],
		If[$internalBuildQ, AntFail, Message][buildLibICULibrary::fail];
	];
];

deleteBuildDirectory[] /; !$internalBuildQ :=
	If[FileExistsQ[$buildDirectory], DeleteDirectory[$buildDirectory, DeleteContents -> True]];

copyWLSourceToBuildDirectory[] /; !$internalBuildQ := With[{
	files = Append[Import[FileNameJoin[{$repoRoot, "Kernel"}]], FileNameJoin[{"..", "PacletInfo.m"}]]
	},
	If[!FileExistsQ[#], CreateDirectory[#]] & /@ {$buildDirectory, FileNameJoin[{$buildDirectory, "Kernel"}]};
	CopyFile[FileNameJoin[{$repoRoot, "Kernel", #}], FileNameJoin[{$buildDirectory, "Kernel", #}]] & /@ files;
];

fileStringReplace[file_, rules_] := Export[file, StringReplace[Import[file, "Text"], rules], "Text"]

renameContext[Automatic, version_] := Module[{context},
	context = Replace[
		If[$internalBuildQ, AntProperty["context"], tryEnvironment["CONTEXT", "ICULibrary"]],
		"Version" -> "ICULibrary$" <> StringReplace[version, "." -> "$"]
	] <> "`";
	If[context =!= "ICULibrary`",
		Print["Building with context ", context];
		renameContext[context];
	];
	context
];

renameContext[newContext_] :=
	fileStringReplace[#, "ICULibrary`" -> newContext] & /@
		(FileNameJoin[{$buildDirectory, #}] &) /@
			Select[MatchQ[FileExtension[#], "m" | "wl"] &] @ Import[$buildDirectory]

$baseVersionPacletMessage = "Will create paclet with the base version number.";
updateVersion::noGitLink = "Could not find GitLink. " <> $baseVersionPacletMessage;

updateVersion[] /; Names["GitLink`*"] =!= {} := Module[{
	versionInformation, gitRepo, minorVersionNumber, versionString, pacletInfoFilename, pacletInfo
	},
	Check[
		versionInformation = Import[FileNameJoin[{$repoRoot, "scripts", "version.wl"}]];
		gitRepo = GitOpen[$repoRoot];
		If[$internalBuildQ, GitFetch[gitRepo, "origin"]];
		minorVersionNumber = Max[0,
			Length@GitRange[gitRepo,
				Except[versionInformation["Checkpoint"]],
				GitMergeBase[gitRepo, "HEAD", If[$internalBuildQ, "origin/main", "main"]]
			] - 1
		];
		pacletInfoFilename = FileNameJoin[{$buildDirectory, "PacletInfo.m"}];
		pacletInfo = Association @@ Import[pacletInfoFilename];
		versionString = pacletInfo[Version] <> "." <> ToString[minorVersionNumber];,
		Return[]
	];
	Export[pacletInfoFilename, Paclet @@ Normal[Join[pacletInfo, <|Version -> versionString|>]]];
	versionString
];

updateVersion[] /; Names["GitLink`*"] === {} := Message[updateVersion::noGitLink];

gitSHA[] /; Names["GitLink`*"] =!= {} := Module[{gitRepo, sha, cleanQ},
	gitRepo = GitOpen[$repoRoot];
	sha = GitSHA[gitRepo, gitRepo["HEAD"]];
	cleanQ = AllTrue[# === {} &]@GitStatus[gitRepo];
	If[cleanQ, sha, sha <> "*"]
];

gitSHA::noGitLink = "Could not find GitLink. $ICULibraryGitSHA will not be available.";

gitSHA[] /; Names["GitLink`*"] === {} := (
	Message[gitSHA::noGitLink];
	Missing["NotAvailable"]
);

updateBuildData[] := With[{
	buildDataFile = File[FileNameJoin[{$buildDirectory, "Kernel", "buildData.m"}]]
	},
	FileTemplateApply[buildDataFile, buildDataFile];
];

addModifiedContextFlag[fileName_] := FileNameJoin[Append[
	Most[FileNameSplit[fileName]],
	StringJoin[StringRiffle[Most@StringSplit[Last[FileNameSplit@fileName], "."], "."], "-C.paclet"]
]];

packPaclet[context_] := Module[{pacletFileName},
	If[$internalBuildQ,
		Print["$Version: ", $Version];
		Print["$InstallationDirectory: ", $InstallationDirectory];
		Unset[$MessagePrePrint];
	];
	pacletFileName = PackPaclet[$buildDirectory, If[$internalBuildQ, AntProperty["output_directory"], $repoRoot]];
	If[context =!= "ICULibrary`", RenameFile[pacletFileName, addModifiedContextFlag[pacletFileName]]];
	If[$internalBuildQ,
		SetDirectory[AntProperty["output_directory"]];
		If[TrueQ[FileExistsQ[FileNames["ICULibrary*.paclet"][[1]]]],
			Print[FileNames["ICULibrary*.paclet"][[1]] <> " ... OK"],
			AntFail["Paclet not produced"]
		];
	];
];

