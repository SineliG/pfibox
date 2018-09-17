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

difference() {
    translate([-(157/2),-(126.5/2),0]) cube(size=[157,126.5,2],center=false);
    rotate(a=-1.5,v=[0,0,1]) {
        // This will be camera dependent
        translate([1.095,-3.25,0])
        union() {
            translate([-(123/2),-(86/2),-1]) cube(size=[123,86,4],center=false);
            translate([-(123/2),(86/2)-11,-1]) cylinder(r1=4,r2=4,h=4,$fn=50,center=false);
            translate([(123/2),(86/2)-11,-1]) cylinder(r1=4,r2=4,h=4,$fn=50,center=false);
        }
    }
}
