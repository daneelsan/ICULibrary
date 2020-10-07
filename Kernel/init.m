Unprotect["ICULibrary`*"];

ClearAll @@ (# <> "*" & /@ Contexts["ICULibrary`*"]);

Get["ICULibrary`Kernel`usageString`"];

SetAttributes[#, {Protected, ReadProtected}] & /@ Evaluate @ Names @ "ICULibrary`*";

