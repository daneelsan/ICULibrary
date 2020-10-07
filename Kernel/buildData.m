(* The backtick magic is necessary to prevent it being interpreted as a beginning of a template argument. *)
Package["ICULibrary<*"`"*>"]

PackageExport["$ICULibraryGitSHA"]
PackageExport["$ICULibraryBuildTime"]

$ICULibraryGitSHA::usage = usageString[
  "$ICULibraryGitSHA gives the Git SHA of the repository from which ICULibrary was built."];

$ICULibraryBuildTime::usage = usageString[
  "$ICULibraryBuildTime gives the date object at which ICULibrary was built."];

(* This is a template file. Data is inserted at build time. *)

$ICULibraryGitSHA = <*ToString[gitSHA[], InputForm]*>; (* gitSHA[] is defined in buildInit.wl *)
$ICULibraryBuildTime = <*ToString[DateObject[TimeZone -> "UTC"], InputForm]*>;
