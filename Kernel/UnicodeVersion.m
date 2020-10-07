(* ::Package:: *)

Package["ICULibrary`"]


PackageScope["$UnicodeVersionMap"]


PackageScope["CurrentUnicodeVersion"]


(* ::Subsubsection:: *)
(*$UnicodeVersionMap*)


$UnicodeVersionMap = MapAt[DateObject, {
	{ 0, 0, 0, 0} -> {1991, 10},
	{ 1, 1, 0, 0} -> {1993, 6},
	{ 2, 0, 0, 0} -> {1996, 7},
	{ 2, 1, 0, 0} -> {1998, 5},
	{ 3, 0, 0, 0} -> {1999, 9},
	{ 3, 1, 0, 0} -> {2001, 3},
	{ 3, 2, 0, 0} -> {2002, 3},
	{ 4, 0, 0, 0} -> {2003, 4},
	{ 4, 1, 0, 0} -> {2005, 3, 31},
	{ 5, 0, 0, 0} -> {2006, 7, 14},
	{ 5, 1, 0, 0} -> {2008, 4, 4},
	{ 5, 2, 0, 0} -> {2009, 10, 1},
	{ 6, 0, 0, 0} -> {2010, 10, 11},
	{ 6, 1, 0, 0} -> {2012, 1, 31},
	{ 6, 2, 0, 0} -> {2012, 9, 26},
	{ 6, 3, 0, 0} -> {2013, 9, 30},
	{ 7, 0, 0, 0} -> {2014, 6, 16},
	{ 8, 0, 0, 0} -> {2015, 6, 17},
	{ 9, 0, 0, 0} -> {2016, 6, 21},
	{10, 0, 0, 0} -> {2017, 6, 20},
	{11, 0, 0, 0} -> {2018, 6, 5},
	{12, 0, 0, 0} -> {2019, 3, 5},
	{12, 1, 0, 0} -> {2019, 5, 7},
	{13, 0, 0, 0} -> {2020, 3, 10}}, {All, 2}];


(* ::Subsubsection:: *)
(*CurrentUnicodeVersion*)


$libraryFile = FindLibrary["libICULibrary"];


$c$getUnicodeVersion = If[$libraryFile =!= $Failed,
	LibraryFunctionLoad[
		$libraryFile,
		"$getUnicodeVersion",
		{},
		{Integer, 1}], (* version *)
	$Failed];


CurrentUnicodeVersion[] := $c$getUnicodeVersion[];
CurrentUnicodeVersion["Date"] := CurrentUnicodeVersion[] /. $UnicodeVersionMap;
