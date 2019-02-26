#!lua

printf("Generating GPUTerrainProject")

workspace "GPUTerrainProject"
	architecture "x64"
	startproject "GPUTerrainDemo"

  configurations
	{
		"Debug",
		"Release"
  }

builddir = "D:/MyProjects/GPUEngine_all/_build/GPUTerrainProject/"
basedir(builddir)

include "GPUTerrainDemo"
include "libs/GPUTerrain"
