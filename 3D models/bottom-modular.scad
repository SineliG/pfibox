/* This piece was designed by Shawn French (McMaster University, Ontario, Canada)
It is part of the PFIbox (Printed Fluorescence Imaging box), a small and portable 3D-printed
fluorescence imager for bacteria, yeast, or any colony-forming organism.  It works well with solid
agar medium, and can image high density samples rapidly over time.  

Details can be found at https://www.github.com/sfrench007/pfibox

Copyright 2017 McMaster University

Redistribution and use in source and binary forms, with or without modification, are permitted provided that the following conditions are met:

1. Redistributions of source code must retain the above copyright notice, this list of conditions and the following disclaimer.

2. Redistributions in binary form must reproduce the above copyright notice, this list of conditions and the following disclaimer in the documentation and/or other materials provided with the distribution.

3. Neither the name of the copyright holder nor the names of its contributors may be used to endorse or promote products derived from this software without specific prior written permission.

THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.

*/

// Height 175 mm (camera to base)
// Width 157 mm
// Depth 134 mm
// 135 mm camera to top of transilluminator
// 40 mm transilluminator height (base height)

boardWidth = 147;
boardDepth = 115;
boardHeight = 2;
acWidth = 11.5;
acHeight = 9;
acOffset = 5;
acRad = (acHeight/2)+1;
switchWidth = 11;
switchHeight = 7;
switchOffset = 3.5;

transDepth = 126.5;
transWidth = 157.5;
transHeight = 40;
transWallWidth = (transWidth-boardWidth)/2;

rigWallWidth = 3;
rigHeight = 175;
rigWidth = transWidth + (rigWallWidth * 2);
rigDepth = transDepth + (rigWallWidth * 2);
echo(rigWidth);
echo(rigDepth);
riserHeight = 4.8;
riserWidth = 10;

railWidth = 20;
sideWallWidth = 2;
allowance = 1;
slitDepth = 10;

// The rig first
module drawRig() {
	union() {
		translate([-(railWidth+transWallWidth),-(railWidth+transWallWidth),0]) cube(size = [rigWidth+((railWidth)*2)+transWallWidth-(allowance/2)-0.25, rigDepth+((railWidth)*2)+transWallWidth-(allowance/2)-0.25, rigWallWidth], center = false);

		// Bottom left brace
		translate([-(railWidth+transWallWidth),-(railWidth+transWallWidth),0]) 
		difference() {
			cube(size=[railWidth+(transWallWidth*2),railWidth+(transWallWidth*2),transHeight/2],center=false);
			translate([transWallWidth-(allowance/2),transWallWidth-(allowance/2),0]) cube(size=[railWidth+allowance,railWidth+allowance,transHeight/2],center=false);
			// Slits for sliding walls
			translate([railWidth+transWallWidth,transWallWidth+(railWidth*1/4)-(allowance/2),0]) cube(size=[transWallWidth,sideWallWidth+allowance,transHeight/2]);
			translate([transWallWidth+(railWidth*1/4)-(allowance/2),railWidth+transWallWidth,0]) cube(size=[sideWallWidth+allowance,transWallWidth,transHeight/2]);
		}
		translate([-(railWidth+transWallWidth),-(railWidth+transWallWidth),0]) cube(size=[railWidth+(transWallWidth*2),railWidth+(transWallWidth*2),rigWallWidth],center=false);

		// Top left brace
		translate([-(railWidth+transWallWidth),transDepth-transWallWidth,0]) 
		difference() {
			cube(size=[railWidth+(transWallWidth*2),railWidth+(transWallWidth*2),transHeight/2],center=false);
			translate([transWallWidth-(allowance/2),transWallWidth-(allowance/2),0]) cube(size=[railWidth+allowance,railWidth+allowance,transHeight/2],center=false);
			// Slits for sliding walls
			translate([railWidth+transWallWidth,transWallWidth+(railWidth*3/4)-(allowance/2)-sideWallWidth,0]) cube(size=[transWallWidth,sideWallWidth+allowance,transHeight/2]);
			translate([transWallWidth+(railWidth*1/4)-(allowance/2),0,0]) cube(size=[sideWallWidth+allowance,transWallWidth,transHeight/2]);
		}
		translate([-(railWidth+transWallWidth),transDepth-transWallWidth,0]) cube(size=[railWidth+(transWallWidth*2),railWidth+(transWallWidth*2),rigWallWidth],center=false);

		// Top Right brace
		translate([transWidth-transWallWidth,transDepth-transWallWidth,0]) 
		difference() {
			cube(size=[railWidth+(transWallWidth*2),railWidth+(transWallWidth*2),transHeight/2],center=false);
			translate([transWallWidth-(allowance/2),transWallWidth-(allowance/2),0]) cube(size=[railWidth+allowance,railWidth+allowance,transHeight/2],center=false);
			// Slits for sliding walls
			translate([0,transWallWidth+(railWidth*3/4)-(allowance/2)-sideWallWidth,0]) cube(size=[transWallWidth,sideWallWidth+allowance,transHeight/2]);
			translate([transWallWidth+(railWidth*3/4)-(allowance/2)-sideWallWidth,0,0]) cube(size=[sideWallWidth+allowance,transWallWidth,transHeight/2]);
		}
		translate([transWidth-transWallWidth,transDepth-transWallWidth,0]) cube(size=[railWidth+(transWallWidth*2),railWidth+(transWallWidth*2),rigWallWidth],center=false);

		// Bottom right brace
		translate([transWidth-transWallWidth,,-(railWidth+transWallWidth),0]) 
		difference() {
			cube(size=[railWidth+(transWallWidth*2),railWidth+(transWallWidth*2),transHeight/2],center=false);
			translate([transWallWidth-(allowance/2),transWallWidth-(allowance/2),0]) cube(size=[railWidth+allowance,railWidth+allowance,transHeight/2],center=false);
			// Slits for sliding walls
			translate([0,transWallWidth+(railWidth*1/4)-(allowance/2),0]) cube(size=[transWallWidth,sideWallWidth+allowance,transHeight/2]);
			translate([transWallWidth+(railWidth*3/4)-(allowance/2)-sideWallWidth,railWidth+transWallWidth,0]) cube(size=[sideWallWidth+allowance,transWallWidth,transHeight/2]);
		}
		translate([transWidth-transWallWidth,,-(railWidth+transWallWidth),0]) cube(size=[railWidth+(transWallWidth*2),railWidth+(transWallWidth*2),rigWallWidth],center=false);
	}
}

// Then the transilluminator walls 
module drawTrans() {
    union() {
        cube(size = [transWallWidth, transDepth, transHeight], center = false);
        translate([(transWidth-transWallWidth),0,0]) cube(size = [transWallWidth, transDepth, transHeight], center = false);
        cube(size = [transWidth,transWallWidth,transHeight], center = false);
        translate([0,(transDepth-transWallWidth),0]) cube(size = [transWidth,transWallWidth,transHeight], center = false);

        // Now the little locks for the excitation filter
        translate([(allowance/2),(allowance/2)+sideWallWidth-(railWidth*3/4),transHeight/2]) cube(size=[transWallWidth-(allowance/2),railWidth*3/4-sideWallWidth-(allowance/2),(transHeight/2)+5],center=false);
        translate([transWidth-transWallWidth,(allowance/2)+sideWallWidth-(railWidth*3/4),transHeight/2]) cube(size=[transWallWidth-(allowance/2),railWidth*3/4-sideWallWidth-(allowance/2),(transHeight/2)+5],center=false);
        translate([(allowance/2),transDepth,transHeight/2]) cube(size=[transWallWidth-(allowance/2),railWidth*3/4-sideWallWidth-(allowance/2),(transHeight/2)+5],center=false);
        translate([transWidth-transWallWidth,transDepth,transHeight/2]) cube(size=[transWallWidth-(allowance/2),railWidth*3/4-sideWallWidth-(allowance/2),(transHeight/2)+5],center=false);

        translate([-(railWidth*3/4)+sideWallWidth+(allowance/2),(allowance/2),transHeight/2]) cube(size=[railWidth*3/4-sideWallWidth-(allowance/2),transWallWidth-(allowance/2),(transHeight/2)+5],center=false);
        translate([-(railWidth*3/4)+sideWallWidth+(allowance/2),transDepth-transWallWidth,transHeight/2]) cube(size=[railWidth*3/4-sideWallWidth-(allowance/2),transWallWidth-(allowance/2),(transHeight/2)+5],center=false);
        translate([transWidth,(allowance/2),transHeight/2]) cube(size=[railWidth*3/4-sideWallWidth-(allowance/2),transWallWidth-(allowance/2),(transHeight/2)+5],center=false);
        translate([transWidth,transDepth-transWallWidth,transHeight/2]) cube(size=[railWidth*3/4-sideWallWidth-(allowance/2),transWallWidth-(allowance/2),(transHeight/2)+5],center=false);

        // Extra rails to prevent gaps in the walls
        translate([-(railWidth*3/4)-transWallWidth-(allowance/2),0,0]) cube(size = [transWallWidth, transDepth, transHeight/4], center = false);
        translate([(transWidth+(railWidth*3/4)+(allowance/2)),0,0]) cube(size = [transWallWidth, transDepth, transHeight/4], center = false);
        translate([0,-(railWidth*3/4)-transWallWidth-(allowance/2),0]) cube(size = [transWidth,transWallWidth,transHeight/4], center = false);
        translate([0,(transDepth+(railWidth*3/4)+(allowance/2)),0]) cube(size = [transWidth,transWallWidth,transHeight/4], center = false);        
    }
}

// Corner risers for circuit board (4.8 mm high)
module drawRisers() {
    union() {
        translate([transWallWidth,transWallWidth,rigWallWidth]) cube(size = [riserWidth,riserWidth,riserHeight], center = false);
        translate([transWallWidth,(transWallWidth+boardDepth-riserWidth),rigWallWidth]) cube([riserWidth,riserWidth,riserHeight], center = false);
        translate([(transWallWidth+boardWidth-riserWidth),(transWallWidth+boardDepth-riserWidth),rigWallWidth]) cube([riserWidth,riserWidth,riserHeight], center = false);
        translate([(transWallWidth+boardWidth-riserWidth),transWallWidth,rigWallWidth]) cube([riserWidth,riserWidth,riserHeight], center = false);
    }
}

module prism(l, w, h){
  polyhedron(
    points=[[0,0,0], [l,0,0], [l,w,0], [0,w,0], [0,w,h], [l,w,h]],
    faces=[[0,1,2,3],[5,4,3,2],[0,4,5,1],[0,3,4],[5,2,1]]
  );
}

// Draw everything including the holes for the cords
difference() {
    union() {
        drawRig();
        drawTrans();
        drawRisers();
    }
    translate([(transWallWidth+boardWidth-25),rigWallWidth+30,(rigWallWidth+riserHeight+boardHeight+acOffset)]) rotate(a = [90,0,0]) cylinder(h=(rigWallWidth+transWallWidth+30),r1=acRad,r2=acRad,center=false);
    translate([(transWallWidth+boardWidth-60.5),-rigWallWidth,(rigWallWidth+riserHeight+boardHeight+switchOffset)]) cube(size = [switchWidth,(rigWallWidth+transWallWidth),switchHeight],center=false);

    // Triangles to aid in wall sliding
    translate([-8,8,48]) rotate([0,180,90]) prism(l=railWidth/2,w=transWallWidth,h=transHeight/3);
    translate([-8,128,48]) rotate([0,180,90]) prism(l=railWidth/2,w=transWallWidth,h=transHeight/3);
    translate([165,-2,48]) rotate([0,180,270]) prism(l=railWidth/2,w=transWallWidth,h=transHeight/3);
    translate([165,118,48]) rotate([0,180,270]) prism(l=railWidth/2,w=transWallWidth,h=transHeight/3);
}

