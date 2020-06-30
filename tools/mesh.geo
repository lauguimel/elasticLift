// Gmsh project created on Wed Apr 29 12:02:20 2020
SetFactory("OpenCASCADE");

Nx1=5; Rx1=1.00;
Nx2=5; Rx2=1.00;
Nx3=5; Rx3=1.00;
Nb=5; Rb=1.00;
Nc=5; Rc=0.9;


cx=20;
cy=2.1;

//+ Part one channel
Point(1) = {0, 0, 0, 1.0};
Point(2) = {cx-9, 0, 0, 1.0};
Point(3) = {cx-9, 4, 0, 1.0};
Point(4) = {0, 4, 0, 1.0};
//+ Part square frame cylinder
Point(5) = {cx+9, 0, 0, 1.0};
Point(6) = {cx+9, 4, 0, 1.0};
//+ Part two channel
Point(7) = {80, 0, 0, 1.0};
Point(8) = {80, 4, 0, 1.0};
//+ cylinder
Point(9) = {cx, cy, 0, 1.0};
Point(10) = {cx-0.7, cy+0.7, 0, 1.0}; //extremo arriba izquierda
Point(11) = {cx+0.7, cy+0.7, 0, 1.0}; //extremo arriba derecha
Point(12) = {cx-0.7, cy-0.7, 0, 1.0}; //extremo abajo izquierda
Point(13) = {cx+0.7, cy-0.7, 0, 1.0}; //extremo abajo derecha


//+ Part one channel lines
Line(1) = {1, 2}; Transfinite Line {1} = Nx1 Using Progression Rx1;
Line(2) = {2, 3}; Transfinite Line {2} = Nx1 Using Progression Rx1;
Line(3) = {3, 4}; Transfinite Line {3} = Nx1 Using Progression Rx1;
Line(4) = {4, 1}; Transfinite Line {4} = Nx1 Using Progression Rx1;
//+ Part square frame cylinder lines
Line(5) = {2, 5}; Transfinite Line {5} = Nx2 Using Progression Rx2;
Line(6) = {5, 6}; Transfinite Line {6} = Nx2 Using Progression Rx2;
Line(7) = {6, 3}; Transfinite Line {7} = Nx2 Using Progression Rx2;
//Line(19) = {2, 3}; Transfinite Line {19} = Nx2 Using Progression Rx2;
//+ Part two channel lines
Line(8) = {5, 7}; Transfinite Line {8} = Nx3 Using Progression Rx3;
Line(9) = {7, 8}; Transfinite Line {9} = Nx3 Using Progression Rx3;
Line(10) = {8, 6}; Transfinite Line {10} = Nx3 Using Progression Rx3;
//Line(20) = {5, 6}; Transfinite Line {20} = Nx3 Using Progression Rx3;
//+ cylinder lines
Circle(11) = {10, 9, 11}; Transfinite Line {11} = Nb Using Progression Rb;
Circle(12) = {11, 9, 13}; Transfinite Line {12} = Nb Using Progression Rb;
Circle(13) = {13, 9, 12}; Transfinite Line {13} = Nb Using Progression Rb;
Circle(14) = {12, 9, 10}; Transfinite Line {14} = Nb Using Progression Rb;
//+ frame to cylinder lines
Line(15) = {2, 12}; Transfinite Line {15} = Nc Using Progression Rc;
Line(16) = {5, 13}; Transfinite Line {16} = Nc Using Progression Rc;
Line(17) = {6, 11}; Transfinite Line {17} = Nc Using Progression Rc;
Line(18) = {3, 10}; Transfinite Line {18} = Nc Using Progression Rc;



//+ surfaces cylinder and block
Line Loop(1) = {15, -13, -16, -5};
Plane Surface(1) = {1};
Line Loop(2) = {16, -12, -17, -6};
Plane Surface(2) = {2};
Line Loop(3) = {11, -17, 7, 18};
Plane Surface(3) = {3};
Line Loop(4) = {2, 18, -14, -15};
Plane Surface(4) = {4};
//+ surfaces part one channel
Line Loop(5) = {1, 2, 3, 4};
Plane Surface(5) = {5};
//+ surfaces part two channel
Line Loop(6) = {6, -10, -9, -8};
Plane Surface(6) = {6};
//+ Transfiniting and recombining surfaces
Transfinite Surface {1};
Transfinite Surface {2};
Transfinite Surface {3};
Transfinite Surface {4};
Transfinite Surface {5};
Transfinite Surface {6};
Recombine Surface {1};
Recombine Surface {2};
Recombine Surface {3};
Recombine Surface {4};
Recombine Surface {5};
Recombine Surface {6};


//+ extruding
Extrude {0, 0, 1} {
  Surface{1}; Surface{2}; Surface{3}; Surface{4}; Surface{5}; Surface{6}; 
Layers{1};
    Recombine;
}



//+ physical boundaries
Physical Surface("inlet") = {25};
Physical Surface("outlet") = {28};
Physical Surface("walls") = {24, 17, 27, 23, 10, 29};
Physical Surface("frontAndBack") = {5, 26, 4, 22, 15, 2, 6, 30, 3, 19, 1, 11};
Physical Surface("cylinder") = {21, 16, 12, 8};
Physical Volume("internal") = {5, 4, 3, 2, 1, 6};
