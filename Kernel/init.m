Unprotect["ICULibrary`*"];

ClearAll @@ (# <> "*" & /@ Contexts["ICULibrary`*"]);

Get["ICULibraryReplace`Kernel`usageString`"];

SetAttributes[#, {Protected, ReadProtected}] & /@ Evaluate @ Names @ "ICULibrary`*";

