// Cover for 12V 240W LED PSU with only 2 sides open
// Copyright (C) 2016 Miroslav Hradílek
// Connector code by Martin Neruda <neruda@reprap4u.cz> taken from
// project https://github.com/RepRap4U/RebeliX

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

wt = 2; // Wall thickness
vent_t = 3; // Vent hole thickness

psu_w = 48.5;  // PSU Width
psu_h = 99.5;  // PSU Height 
cover_l = 30;  // Cover Length
cover_ml = 20; // Mount length. Length of a psu to disappear in cover
connector_l = 22; // Length of a connector compartment
connector_w = 50; // Width of a connector compartment (length of the l part)


module psu_connector(){
  difference(){
    cube([27.8,19.8,10],center=true);
    translate([7.5,19.8/2,-10]) rotate([0,0,-45]) cube([20,20,20]);
        translate([-7.5,19.8/2,-10]) rotate([0,0,135]) cube([20,20,20]);
  }
  // Screw holes
  translate([20,0,0]) cylinder(r=1.2,h=20,$fn=16,center=true);
  translate([-20,0,0]) cylinder(r=1.2,h=20,$fn=16,center=true);
}

module switch(){
    cube([19.2,13,10],center=true);
}

module box_cuts() {
    difference() {
        // Outside L shape
        union() {
            // Outside cuboid
            cube(size = [psu_h + 2*wt + connector_l, cover_l, psu_w + 2*wt], center = false);
            // Switch compartent cuboid
            translate([0,-(connector_w-cover_l),0]) cube(size = [connector_l+wt, connector_w - cover_l, psu_w + 2*wt], center = false);
        }
        // PSU sized cuboid
        translate([wt + connector_l, -0.1, wt])
            cube(size = [psu_h, cover_ml+0.1, psu_w], center = false);
        // Inside compartment cuboid
        translate([wt + connector_l + 1, -0.1, wt+1])
            cube(size = [psu_h - 2, cover_l - wt + 0.1, psu_w - 2], center = false);
        // Inside compartment for connector
        translate([wt, -(connector_w-cover_l+wt), wt]) {
            // Cuboid cutting compartment in L part
            cube(size = [connector_l - 2, connector_w, psu_w], center = false);
            // Cuboid opening one side in overhanging L part
            cube(size = [connector_l + 0.1, connector_w - cover_l +wt, psu_w], center = false);
        }
        // Hole between compartments
        translate([connector_l - wt/2, -0.1, wt + 3])
            cube(size = [2*wt, cover_ml+0.1, psu_w - 6], center = false);
        // Vent holes
        for (a =[0: (psu_h - wt - 2 - connector_l)/(2*vent_t)]){
            translate([ connector_l + 3*wt + 1 + a * 2 * vent_t , 0, 5*wt])
                cube(size = [vent_t / 3, cover_l + 0.1 , psu_w - 8 * wt], center = false);

        };

        // PSU Connector
        translate([0, connector_w/2-(connector_w - cover_l), wt+10])
            rotate(a=[90,0,90])
                psu_connector();

        // Switch hole
        translate([connector_l+2*wt+12,cover_l-15,psu_w]) rotate([0,0,0]) switch();
    }
}

module psu_cover() {
    box_cuts();
}

// Opening cover
module compartment_cover() {
    union() {
        // Front plate
        cube(size = [wt + connector_l, wt, psu_w + 2*wt], center = false);
        // Inserts
        translate([wt, wt, wt])
            cube(size = [connector_l-wt, 5, wt], center = false);
        translate([wt, wt, psu_w - wt])
            cube(size = [connector_l-wt, 5, wt], center = false);
    }
}

translate([0, 0, cover_l]) rotate([-90,0,0])
    psu_cover();

translate([0, -(connector_w-cover_l+wt+5), 0]) rotate([90,0,90])
    compartment_cover();
