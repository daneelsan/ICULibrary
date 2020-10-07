#!/usr/bin/env wolframscript

Check[
	Get[FileNameJoin[{DirectoryName[$InputFileName], "buildInit.wl"}]];

	buildLibICULibrary[];,

	If[$internalBuild, AntFail, Print]["Library build failed."];
	Exit[1]
];
