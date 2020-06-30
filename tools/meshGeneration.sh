#!/bin/bash
curDir=$(pwd)
# Generating mesh
gmsh -3 $curDir/$1.geo -o $curDir/$1.msh

gmshToFoam -case ../ mesh.msh

# Changing types
foamDictionary -entry "entry0.cylinder.type" -set "wall"  ../constant/polyMesh/boundary    
foamDictionary -entry "entry0.walls.type" -set "wall"  ../constant/polyMesh/boundary    
foamDictionary -entry "entry0.frontAndBack.type" -set "empty"  ../constant/polyMesh/boundary    