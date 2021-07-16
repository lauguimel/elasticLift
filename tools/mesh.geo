// Gmsh project created on Wed Apr 29 12:02:20 2020
SetFactory("OpenCASCADE");

Nhup=65; Rhup=0.95;
Nvup=50; Rvup=1.00;
Nhdown=Nhup; Rhdown=Rhup;
Nvdown=Nvup; Rvdown=Rvup;
Nhleft=Nvup; Rhleft=1.00;
Nhright=Nvup; Rhright=Rhleft;
Nvfirstblock=45; Rvfirstblock=0.95;
Nvlastblock=75; Rvlastblock=0.95;

cx=20;
cy=2.4;

upperVerticalDivision = (2-(cy/2))*Nhleft*2.2;
lowerVerticalDivision =  (cy/2)*Nhleft*2.2;


rad=0.20;          // particle radius rad=0.5 reduction to the half
r=rad*0.7071;	// particle factor
red=cy+0.5;           // reduction factor red=2 reduction to the half

//+ Part one channel
Point(1) = {0, red-1, 0, 1.0};
Point(2) = {cx-2, red-1, 0, 1.0};
Point(3) = {cx-2, red, 0, 1.0};
Point(4) = {0, red, 0, 1.0};
//Below and above part one
Point(17) = {0, 0, 0, 1.0}; 
Point(18) = {cx-2, 0, 0, 1.0};
Point(19) = {cx-2, 4, 0, 1.0};
Point(20) = {0, 4, 0, 1.0};

Line(19) = {1, 17}; Transfinite Line {19} = lowerVerticalDivision Using Progression Rhleft;  
Line(20) = {17, 18}; Transfinite Line {20} = Nvfirstblock Using Progression Rvfirstblock; 
Line(21) = {18, 2}; Transfinite Line {21} = lowerVerticalDivision Using Progression Rhleft; 

Line(22) = {20, 4}; Transfinite Line {22} = upperVerticalDivision Using Progression Rhleft;  
Line(23) = {20, 19}; Transfinite Line {23} = Nvfirstblock Using Progression Rvfirstblock; 
Line(24) = {19, 3}; Transfinite Line {24} = upperVerticalDivision Using Progression Rhleft;

//+ Part square frame cylinder
Point(5) = {cx+2, red-1, 0, 1.0};
Point(6) = {cx+2, red, 0, 1.0};
//+ Part two channel
Point(7) = {80, red-1, 0, 1.0};
Point(8) = {80, red, 0, 1.0};
//Below and above second part
Point(21) = {cx+2, 0, 0, 1.0};
Point(22) = {80, 0, 0, 1.0};
Point(23) = {80, 4, 0, 1.0};
Point(24) = {cx+2, 4, 0, 1.0};

Line(25) = {5, 21}; Transfinite Line {25} = lowerVerticalDivision Using Progression Rhleft;  
Line(26) = {22, 21}; Transfinite Line {26} = Nvlastblock Using Progression Rvlastblock; 
Line(27) = {22, 7}; Transfinite Line {27} = lowerVerticalDivision Using Progression Rhleft; 
 
Line(28) = {24, 6}; Transfinite Line {28} = upperVerticalDivision Using Progression Rhleft;  
Line(29) = {23, 24}; Transfinite Line {29} = Nvlastblock Using Progression Rvlastblock; 
Line(30) = {23, 8}; Transfinite Line {30} = upperVerticalDivision Using Progression Rhleft; 

//+ cylinder
Point(9) = {cx, cy, 0, 1.0};
Point(10) = {(cx-r), (cy+r), 0, 1.0}; //extremo arriba izquierda
Point(11) = {(cx+r), (cy+r), 0, 1.0}; //extremo arriba derecha
Point(12) = {(cx-r), (cy-r), 0, 1.0}; //extremo abajo izquierda
Point(13) = {(cx+r), (cy-r), 0, 1.0}; //extremo abajo derecha
Point(14) = {(cx-rad), (cy), 0, 1.0}; //extremo abajo derecha
Point(15) = {(cx+rad), (cy), 0, 1.0}; //extremo abajo derecha
Point(16) = {cx, cy, 0, 1.0};

//+ cylinder contour
Circle(1) = {10, 9, 11}; Transfinite Line {1} = Nvup Using Progression Rvup; //+ Upper contour cylinder
Circle(2) = {11, 9, 13}; Transfinite Line {2} = Nhright Using Progression Rhright; //+ Down contour cylinder
Circle(3) = {13, 9, 12}; Transfinite Line {3} = Nvdown Using Progression Rvdown; //+ Down contour cylinder
Circle(4) = {12, 9, 10}; Transfinite Line {4} = Nhleft Using Progression Rhleft; //+ Left contour cylinder


//+ External channel
Line(5) = {1, 2}; Transfinite Line {5} = Nvfirstblock Using Progression Rvfirstblock;
Line(6) = {2, 5}; Transfinite Line {6} = Nvdown Using Progression Rvdown;
Line(7) = {7, 5}; Transfinite Line {7} = Nvlastblock Using Progression Rvlastblock;
Line(8) = {7, 8}; Transfinite Line {8} = Nhright Using Progression Rhright;
Line(9) = {8, 6}; Transfinite Line {9} = Nvlastblock Using Progression Rvlastblock;
Line(10) = {6, 3}; Transfinite Line {10} = Nvup Using Progression Rvup;
Line(11) = {4, 3}; Transfinite Line {11} = Nvfirstblock Using Progression Rvfirstblock;
Line(12) = {4, 1}; Transfinite Line {12} = Nhleft Using Progression Rhleft; 


//+ Lines to frames up and down
Line(13) = {3, 10}; Transfinite Line {13} = Nhup Using Progression Rhup;
Line(14) = {6, 11}; Transfinite Line {14} = Nhup Using Progression Rhup;
Line(15) = {2, 12}; Transfinite Line {15} = Nhdown Using Progression Rhdown;
Line(16) = {5, 13}; Transfinite Line {16} = Nhdown Using Progression Rhdown;

//+ Circle arcs to lines up and down
Circle(17) = {3, 16, 2}; Transfinite Line {17} = Nhleft Using Progression Rhleft;
Circle(18) = {6, 16, 5}; Transfinite Line {18} = Nhright Using Progression Rhright;

//+ Top and bottom Region of interest
Line(31) = {19, 24}; Transfinite Line {31} = Nvup Using Progression Rvup;
Line(32) = {18, 21}; Transfinite Line {32} = Nvup Using Progression Rvup; 


//+ surfaces cylinder to up and down left and right
Line Loop(1) = {10, 13, 1, -14};
Plane Surface(1) = {1};
Line Loop(2) = {3, 15, 6, 16};
Plane Surface(2) = {2};
Line Loop(3) = {17, 15, 4, -13};
Plane Surface(3) = {3};
Line Loop(4) = {14, 2, -16, -18};
Plane Surface(4) = {4};
Line Loop(5) = {11, 12, 5, 17};
Plane Surface(5) = {5};
Line Loop(7) = {9, 18, 7, -8};
Plane Surface(7) = {7};

Line Loop(32) = {20, 21, -5, 19};
Plane Surface(32) = {32};

Line Loop(61) = {23, 24, -11, -22};
Plane Surface(61) = {61};


Line Loop(94) = {29, 30, 9, -28};
Plane Surface(94) = {94};

Line Loop(96) = {7, 25, 26, 27};
Plane Surface(96) = {96};

Line Loop(137) = {31, 28, 10, -24};
Plane Surface(137) = {137};

Line Loop(138) = {6, 25, -32, 21};
Plane Surface(138) = {138};

//+ Transfiniting and recombining surfaces
Transfinite Surface {1};
Recombine Surface {1};
Transfinite Surface {2};
Recombine Surface {2};
Transfinite Surface {3};
Recombine Surface {3};
Transfinite Surface {4};
Recombine Surface {4};
Transfinite Surface {5};
Recombine Surface {5};
Transfinite Surface {7};
Recombine Surface {7};
Transfinite Surface {32};
Recombine Surface {32};
Transfinite Surface {61};
Recombine Surface {61};
Transfinite Surface {94};
Recombine Surface {94};
Transfinite Surface {96};
Recombine Surface {96};
Transfinite Surface {137};
Recombine Surface {137};
Transfinite Surface {138};
Recombine Surface {138};

//+ extruding
Extrude {0, 0, 1} {
  Surface{1}; Surface{2}; Surface{3}; Surface{4}; Surface{5}; Surface{7}; Surface{32}; Surface{61}; Surface{94}; Surface{96}; Surface{137}; Surface{138};
Layers{1};
    Recombine;
}


//+ Definition of Physical Groups

Physical Surface("inlet") = {169, 157, 165};
Physical Surface("outlet") = {173, 161, 177};
Physical Surface("walls") = {171, 179, 167, 163, 181, 176};
Physical Surface("frontAndBack") = {61, 5, 32, 137, 1, 2, 3, 4, 138, 94, 96, 162, 174, 178, 180, 154, 151, 148, 182, 170, 166, 7, 158, 143};
Physical Surface("cylinder") = {144, 150, 141, 152};
Physical Volume("internal") = {1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12};


// //+
// Show "*";
// //+
// Show "*";
// //+
// Hide {
// Surface{1,2,3,4,5,7,32,61,94,96,137,138,139,140,141,142,143,144,145,146,147,148,149,150,151,152,153,154,155,156,157,158,159,160,161,162,163,164,165,166,167,168,169,170,171,172,173,174,175,176,177,178,179,180,181,182};
// Volume{1,2,3,4,5,6,7,8,9,10,11,12};
// }

// //+
// Show "*";
// //+
// Hide {
// Surface{1,2,3,4,5,7,32,61,94,96,137,138,139,140,141,142,143,144,145,146,147,148,149,150,151,152,153,154,155,156,157,158,159,160,161,162,163,164,165,166,167,168,169,170,171,172,173,174,175,176,177,178,179,180,181,182};
// Volume{1,2,3,4,5,6,7,8,9,10,11,12};
// }

