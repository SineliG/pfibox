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

extensionHeight = 20;

union(){
    cube(size=[150,rigHeight,sideWallWidth],center=false);
    translate([0,rigHeight,0]) cube(size=[150,extensionHeight,sideWallWidth],center=false);
    translate([0,rigHeight+(extensionHeight/2),0]) cube(size=[150,(extensionHeight/2),sideWallWidth*3],center=false);
}


