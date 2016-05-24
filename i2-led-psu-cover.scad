// Cover for 12V 240W LED PSU with only 2 sides open
// Copyright (C) 2016 Miroslav Hradílek
// i2 mod and few minor updates by Jaroslav Škarvada <jskarvad@redhat.com>
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

wt = 2.5; // Wall thickness
vent_t = 3; // Vent hole thickness

psu_w = 49.0;  // PSU Width
psu_h = 99.5;  // PSU Height
cover_l = 30;  // Cover Length
cover_ml = 20; // Mount length. Length of a psu to disappear in cover
connector_l = 22; // Length of a connector compartment

module psu_connector(){
  difference(){
    cube([27.8,19.8,10],center=true);
    translate([8.5,19.8/2,-10]) rotate([0,0,-45]) cube([20,20,20]);
        translate([-8.5,19.8/2,-10]) rotate([0,0,135]) cube([20,20,20]);
  }
  // Screw holes
  translate([20,0,0]) cylinder(r=1.2,h=20,$fn=16,center=true);
  translate([-20,0,0]) cylinder(r=1.2,h=20,$fn=16,center=true);
}

module switch(){
    cube([19.2,13,20],center=true);
}

module box_cuts() {
    difference() {
        // Outside cuboid
        cube(size = [psu_h + 2*wt, cover_l, psu_w + 2*wt], center = false);
        // PSU sized cuboid
        translate([wt, -0.1, wt])
            cube(size = [psu_h, cover_ml+0.1, psu_w], center = false);
        // Inside compartment cuboid
        translate([wt + 1, -0.1, wt+1])
            cube(size = [psu_h - 2, cover_l - wt + 0.1, psu_w - 2], center = false);
        // Vent holes
        for (a =[0: (psu_h - wt - 2)/(2*vent_t)]){
            translate([3*wt + 1 + a * 2 * vent_t , 0, 5*wt])
                cube(size = [vent_t / 3, cover_l + 0.1 , psu_w - 8 * wt], center = false);
        };
        // Connector box hole
        translate([wt, wt, psu_w])
            cube(size = [55 - 2 * wt, cover_l - 5 * wt, connector_l]);

        // Switch hole
        translate([2*wt+70, cover_l-15, psu_w]) rotate([0,0,0]) switch();
    }
}

module connector_box() {
    difference() {
        translate([0, 0, psu_w + 2 * wt])
            cube(size = [55, cover_l, connector_l + wt]);
        translate([wt, wt, psu_w + 1 * wt])
            cube(size = [55 - 2 * wt, cover_l - 2* wt, connector_l + wt]);
        // PSU Connector
        translate([2 * wt + 22, cover_l, psu_w + 15])
            rotate(a=[90,0,0])
                psu_connector();
    }
}

module psu_cover() {
    box_cuts();
    connector_box();
}

translate([0, 0, cover_l]) rotate([-90,0,0])
    psu_cover();
