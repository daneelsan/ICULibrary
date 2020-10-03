#!/usr/bin/env wolframscript

$successQ = True;

(* If any messages are produced, fail with non-zero exit code. *)
Check[
	$repoRoot = DirectoryName[$InputFileName];
	$latestPacletFiles = MaximalBy[
		FileNames[FileNameJoin[{$repoRoot, "ICULibrary-*.paclet"}]],
		FileInformation[#, "LastModificationDate"] &
	];

	If[Length[$latestPacletFiles] == 0,
		Print[
			"No paclet files ICULibrary-*.paclet were found. ",
			"Run ./build.wls."
		];
		Exit[1];
	];

	previousPaclets = PacletFind["ICULibrary"];
	If[previousPaclets =!= {},
		Print["Uninstalling previous ICULibrary at ", First[previousPaclets]["Location"]];
		PacletUninstall["ICULibrary"];
	];

	(* This works in both 12.0 and 12.1. *)
	pacletObjectQ[p_] := PacletObjectQ[p] || Head[p] === PacletManager`Paclet;

	installedPaclet = PacletInstall[First[$latestPacletFiles], "IgnoreVersion" -> True];
	If[pacletObjectQ[installedPaclet],
		Print["Installed to ", installedPaclet["Location"]];
		Print["Restart running kernels to complete installation."]
		,
		Print["Install failed."];
		$successQ = False;
	];,

	$successQ = False;
];

Exit[If[$successQ, 0, 1]]

