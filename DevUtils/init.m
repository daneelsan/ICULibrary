Package["ICULibraryDevUtils`"]

(* ICULibraryDevUtils is *not* included in paclet builds, so is not visible to users,
but is available for developer workflow purposes, and is used by the build scripts *)

PackageImport["GeneralUtilities`"]

PackageExport["$ICULibraryRoot"]
PackageExport["$DevUtilsRoot"]
PackageExport["$DevUtilsTemporaryDirectory"]

$ICULibraryRoot = FileNameDrop[$InputFileName, -2];
$DevUtilsRoot = FileNameDrop[$InputFileName, -1];
$DevUtilsTemporaryDirectory := EnsureDirectory @ FileNameJoin[{$TemporaryDirectory, "ICULibrary"}];
