// Holders for 12V 240W LED PSU mounting it to prusa i2
// Copyright (C) 2016 Miroslav Hradílek

// This program is  free software:  you can redistribute it and/or modify it
// under  the terms  of the  GNU General Public License  as published by the
// Free Software Foundation, version 3 of the License.
//
// This program  is  distributed  in the hope  that it will  be useful,  but
// WITHOUT  ANY WARRANTY;  without  even the implied  warranty of MERCHANTA-
// BILITY  or  FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public
// License for more details.
//
// You should have received a copy of the  GNU General Public License  along
// with this program. If not, see <http://www.gnu.org/licenses/>.

// User set parameters
part_thick = 4; // Thickness of the imaginary sheet the part could be made out of.
part_height = 10; // How wide is the imaginary sheet the part could be made out of.
hook_body_height = 50; // Height of the closed end of the hook (the side alighned with the side of the PSU)
                       // Set this to the height of the PSU (shortest side)
hook_heel_lenght = 50; // Length of the heel of the hook (the side touching the bottom of the PSU)
                       // Set this to the width of the PSU ( second longest side) 
screw_distance = 20; // Distance between centers of the two screws
                     // Measure this.
rod_center_to_screw = 10; // Distance from rod center to the center of the first screw
                          // Measure from the top of PSU.

rod_dia = 8; // Diameter of the rod 
screw_dia = 4; // Diameter of the screw
screw_head_dia = 7; // Diameter of the screw_head
screw_head_sink = 2; // Depth of the pocket for the screw head

// Calculated helper parameters
outside_dia = rod_dia+2*part_thick; 

module hook() {
    difference() {
        // Hook outside cylinder
        cylinder(h=part_height, d=outside_dia, center=false);
        // Hook inside cylinder diameter equals rod diameter
        translate([0,0,-0.05])  cylinder(h=part_height+0.1, d=rod_dia, center=false);
        // Cuboid cutting the open end of the hook a bit lower so it locks around rod
        translate([-outside_dia/2,-outside_dia-2,-0.05])  cube([outside_dia/2,outside_dia,part_height+0.1],center=false);
        // Cuboid cutting the closed end of the hook
        translate([0-0.01,-outside_dia,-0.05])  cube([outside_dia/2,outside_dia,part_height+0.1],center=false);
    }
}

module screw_pocket() {
   rotate([0,90,0]) {
       cylinder(h=part_thick+0.1, d=screw_dia, center=false);
       cylinder(h=screw_head_sink+0.1, d=screw_head_dia, center=false);
   }
}

module hook_body_holes() {
    difference () {
        // Cuboid forming the closed end of the hook = the body
        translate([outside_dia/4,-hook_body_height,0])  cube([part_thick,hook_body_height,part_height],center=false);
        //  Screw pockets
        translate([outside_dia/4-0.05,0-screw_head_dia/2-rod_center_to_screw,part_height/2]) screw_pocket();
        translate([outside_dia/4-0.05,0-screw_head_dia/2-rod_center_to_screw-screw_distance,part_height/2]) screw_pocket();
    }
}

module hook_body() {
    // Cuboid forming the closed end of the hook = the body
    translate([outside_dia/4,-hook_body_height,0])  cube([part_thick,hook_body_height,part_height],center=false);
    difference() {
        // Cuboid forming the bottom of the hook = the heel
        translate([outside_dia/4,-hook_body_height-part_thick,0]) cube([hook_heel_lenght,part_thick,part_height],center=false);
        // Cuboid cutting the channel for the screw
        translate([outside_dia/4+2*part_thick,-hook_body_height-part_thick-0.05,part_height/2-screw_dia/2]) cube([hook_heel_lenght-4*part_thick,part_thick+0.1,screw_dia],center=false);
    }
}

// Hook to be mounted to the side of the psu with screws
module side_hook() {
    union() {
        hook();
        hook_body_holes();
    }
}

// Hook to be mounted from the bottom of the psu with adjustable distance
module adjust_hook() {
    union() {
        hook();
        hook_body();
    }
}


// Parts cloned and positioned for printing
translate([-outside_dia-part_thick,0,0]) side_hook();
translate([-2*outside_dia-2*part_thick,0,0]) side_hook();
adjust_hook();
translate([outside_dia+part_thick,2*part_thick,0]) adjust_hook();