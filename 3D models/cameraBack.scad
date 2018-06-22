/* This piece was designed by Shawn French (McMaster University, Ontario, Canada)
It is part of the PFIbox (Printed Fluorescence Imaging box), a small and portable 3D-printed
fluorescence imager for bacteria, yeast, or any colony-forming organism.  It works well with solid
agar medium, and can image high density samples rapidly over time.  

Details can be found at https://www.github.com/sfrench007/scificube

Copyright 2017 McMaster University

Redistribution and use in source and binary forms, with or without modification, are permitted provided that the following conditions are met:

1. Redistributions of source code must retain the above copyright notice, this list of conditions and the following disclaimer.

2. Redistributions in binary form must reproduce the above copyright notice, this list of conditions and the following disclaimer in the documentation and/or other materials provided with the distribution.

3. Neither the name of the copyright holder nor the names of its contributors may be used to endorse or promote products derived from this software without specific prior written permission.

THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.

*/

r = 0.86;
h = 10;

module pegs(x=0,y=0,z=0) {
    translate([x+4.15,y+11.65,z+0]) cylinder(h=h,r1=r,r2=r,$fn=50,center=false);
    translate([x+25.65,y+11.65,z+0]) cylinder(h=h,r1=r,r2=r,$fn=50,center=false);
    translate([x+4.15,y+24.65,z+0]) cylinder(h=h,r1=r,r2=r,$fn=50,center=false);
    translate([x+25.65,y+24.65,z+0]) cylinder(h=h,r1=r,r2=r,$fn=50,center=false);
}

module brace(x=0,y=0,z=0) {
    difference() {
        translate([x+2,y+2,z+0]) cube(size=[25.8,25,5],center=false);
        translate([x+4,y+1.75,z+0]) cube(size=[21.8,24,6],center=false);
    }
    translate([x+2,y+0,z+0]) cube(size=[25.8,27,2],center=false);
    translate([x+6.5,y+0,z+0]) cube(size=[16.8,2,3],center=false);
}

brace();
pegs();
