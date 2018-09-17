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

screwHoleRadius = 1.5;

cameraCaseWidth = 28.8;
cameraCaseDepth = 29.8;
cameraCaseHeight = 10;

cameraHoleDiameter = 8.5;
cameraScrewHole = 2.2;
sunny = 12;

ridgeOffset = 0;

offsetX = (cameraCaseWidth/2)-5;
offsetY = cameraCaseDepth/2-5;
hole1x = 60;
hole1y = 40;
piWidth = 58.5;
piDepth = 49.5;

railWidth = 20;
sideWallWidth = 2;
allowance = 1;
slitDepth = 10;
camH = 5;
piHoleRadius = 4;

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


module addPi() {
    // Add holes for RPI3
    translate([hole1x,hole1y-ridgeOffset,-10])
    cylinder(r1=screwHoleRadius,r2=screwHoleRadius,h=rigWallWidth+15,$fn=50,center = false);
    translate([hole1x+piWidth,hole1y-ridgeOffset,-10])
    cylinder(r1=screwHoleRadius,r2=screwHoleRadius,h=rigWallWidth+15,$fn=50,center = false);
    translate([hole1x,hole1y+piDepth-ridgeOffset,-10])
    cylinder(r1=screwHoleRadius,r2=screwHoleRadius,h=rigWallWidth+15,$fn=50,center = false);
    translate([hole1x+piWidth,hole1y+piDepth-ridgeOffset,-10])
    cylinder(r1=screwHoleRadius,r2=screwHoleRadius,h=rigWallWidth+15,$fn=50,center = false);

    // Add indents so that the screws fit the feet, radius of 4 mm
    translate([hole1x,hole1y-ridgeOffset,rigWallWidth/3])
    cylinder(r1=piHoleRadius,r2=piHoleRadius,h=rigWallWidth,$fn=50,center = false);
    translate([hole1x+piWidth,hole1y-ridgeOffset,rigWallWidth/3])
    cylinder(r1=piHoleRadius,r2=piHoleRadius,h=rigWallWidth,$fn=50,center = false);
    translate([hole1x,hole1y+piDepth-ridgeOffset,rigWallWidth/3])
    cylinder(r1=piHoleRadius,r2=piHoleRadius,h=rigWallWidth,$fn=50,center = false);
    translate([hole1x+piWidth,hole1y+piDepth-ridgeOffset,rigWallWidth/3])
    cylinder(r1=piHoleRadius,r2=piHoleRadius,h=rigWallWidth,$fn=50,center = false);
    
    // Draw ghost RPI3
    translate([hole1x,hole1y-ridgeOffset,rigWallWidth])
    %cylinder(h=18.5,r1=3.2,r2=3.2);
    translate([hole1x+piWidth,hole1y-ridgeOffset,rigWallWidth])
    %cylinder(h=18.5,r1=3.2,r2=3.2);
    translate([hole1x,hole1y+piDepth-ridgeOffset,rigWallWidth])
    %cylinder(h=18.5,r1=3.2,r2=3.2);   
    translate([hole1x+piWidth,hole1y+piDepth-ridgeOffset,rigWallWidth])
    %cylinder(h=18.5,r1=3.2,r2=3.2);
    translate([hole1x-3.2,hole1y-3.2-ridgeOffset,rigWallWidth+18.5])
    %cube(size=[85,56.1,1.35],center=false);
    translate([65.84+hole1x-screwHoleRadius,hole1y+2.45-screwHoleRadius,rigWallWidth+18.5+1.35])
    %cube(size=[21.2,16,13.8],center=false);
    translate([hole1x-20,hole1y-10-ridgeOffset,-3])
    %cube(size=[110,76,3],center=false);
}

// Then the transilluminator walls 
module drawTrans() {
    union() {
        cube(size = [transWallWidth, transDepth, transHeight/2], center = false);
        translate([(transWidth-transWallWidth),0,0]) cube(size = [transWallWidth, transDepth, transHeight/2], center = false);
        cube(size = [transWidth,transWallWidth,transHeight/2], center = false);
        translate([0,(transDepth-transWallWidth),0]) cube(size = [transWidth,transWallWidth,transHeight/2], center = false);
    }
    // Draw the ridges along the walls
    translate([-(railWidth*3/4)-transWallWidth-(allowance/2),0,0]) cube(size = [transWallWidth, transDepth, transHeight/4], center = false);
    translate([(transWidth+(railWidth*3/4)+(allowance/2)),0,0]) cube(size = [transWallWidth, transDepth, transHeight/4], center = false);
    translate([0,-(railWidth*3/4)-transWallWidth-(allowance/2),0]) cube(size = [transWidth,transWallWidth,transHeight/4], center = false);
    translate([0,(transDepth+(railWidth*3/4)+(allowance/2)),0]) cube(size = [transWidth,transWallWidth,transHeight/4], center = false);
}

// Draw everything including the holes for the cords
difference() {
    union() {
        drawRig();
        drawTrans();
        difference() {
            translate([(rigWidth/2)-1,(rigDepth/2)-1.5,rigWallWidth]) cube(size=[66,56,camH],center=true);
            translate([(rigWidth/2)-1,(rigDepth/2)-1.5,rigWallWidth]) cube(size=[54,44,camH],center=true);
        }
    }
    translate([170,0,rigWallWidth]) rotate([0,180,0]) addPi();

    // Add camera hole now
    translate([rigWidth/2,rigDepth/2,0]) cube(size=[cameraHoleDiameter,cameraHoleDiameter,20],center=true);
    translate([rigWidth/2,rigDepth/2-sunny+3.5,0]) cube(size=[cameraHoleDiameter,sunny,4],center=true);
    translate([rigWidth/2-8,rigDepth/2-sunny+5,0]) cube(size=[cameraHoleDiameter,sunny-3,4],center=true);

    // Camera screw holes
    translate([rigWidth/2-10.5,(rigDepth/2),-5]) cylinder(r1=cameraScrewHole/2,r2=cameraScrewHole/2,h=20,$fn=50,center = false);
    translate([rigWidth/2+10.5,(rigDepth/2),-5]) cylinder(r1=cameraScrewHole/2,r2=cameraScrewHole/2,h=20,$fn=50,center = false);
    translate([(rigWidth/2)-10.5,(rigDepth/2)-12.5,-5]) cylinder(r1=cameraScrewHole/2,r2=cameraScrewHole/2,h=20,$fn=50,center = false);
    translate([(rigWidth/2)+10.5,(rigDepth/2)-12.5,-5]) cylinder(r1=cameraScrewHole/2,r2=cameraScrewHole/2,h=20,$fn=50,center = false);

    
    // Then a gap for the side wall
    translate([transWidth+(railWidth*3/4)-(allowance/2)-sideWallWidth,-(railWidth*3/4)-(allowance/2),0]) cube(size=[sideWallWidth+allowance,transDepth+allowance+(railWidth*6/4),20],center=false);
}
