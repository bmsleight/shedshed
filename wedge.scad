theta = 6.54339;

timber_construct_w = 37;
timber_construct_h = 63;
base_sheet_t = 18;
d_hole = 5;

$fn=60;

module fullSize()
{
difference()
{
    cube([timber_construct_h+base_sheet_t,timber_construct_h,timber_construct_h]);
    rotate([0, -theta,0]) translate([-timber_construct_h,-timber_construct_h,0]) cube([timber_construct_h*2,timber_construct_h*3,timber_construct_h*2]);
    rotate([0, -theta,0])   translate([-timber_construct_h,-timber_construct_h,base_sheet_t]) cube([timber_construct_h*3,timber_construct_h*3,timber_construct_h]);
    translate([0,timber_construct_h*1/4,base_sheet_t/2]) rotate([0, 90-theta,0])  cylinder(d=d_hole,h=200);
    translate([0,timber_construct_h*3/4,base_sheet_t/2]) rotate([0, 90-theta,0])  cylinder(d=d_hole,h=200);
    translate([timber_construct_h/2,timber_construct_h*1/4,-timber_construct_h]) rotate([0, 0,0])  cylinder(d=d_hole,h=200);
    translate([timber_construct_h/2,timber_construct_h*3/4,-timber_construct_h]) rotate([0, 0,0])  cylinder(d=d_hole,h=200);

}
}

module slim()
{
difference()
{
    union()
    {
        cube([timber_construct_h+d_hole+2,d_hole*3,timber_construct_h]);
        hull()
        {
            translate([0,-d_hole*3,0]) translate([timber_construct_h/2,d_hole*1.5,0]) rotate([0, 0,0])  cylinder(d=d_hole*3,h=timber_construct_h);
            translate([0,0,0]) translate([timber_construct_h/2-(d_hole*3.5),0,0]) cube([d_hole*7,d_hole*3,d_hole*3]);
 *           translate([0,d_hole*3,0]) translate([timber_construct_h/2,d_hole*1.5,0]) rotate([0, 0,0])  cylinder(d=d_hole*3,h=timber_construct_h);
        }
    }
    rotate([0, -theta,0]) translate([-timber_construct_h,-timber_construct_h,0]) cube([timber_construct_h*2,timber_construct_h*3,timber_construct_h*2]);
    rotate([0, -theta,0])   translate([-timber_construct_h,-timber_construct_h,timber_construct_w]) cube([timber_construct_h*3,timber_construct_h*3,timber_construct_h]);
    translate([0,d_hole*1.5,timber_construct_w/2]) rotate([0, 90-theta,0])  cylinder(d=d_hole,h=200);
    rotate([0, -theta,0]) translate([timber_construct_h/2,d_hole*1.5,-timber_construct_h]) rotate([0, 0,0])  cylinder(d=d_hole,h=200);
    translate([timber_construct_h/2,d_hole*1.5-d_hole*3,-timber_construct_h]) rotate([0, 0,0])  cylinder(d=d_hole,h=200);    
    translate([timber_construct_h/2,d_hole*1.5+d_hole*3,-timber_construct_h]) rotate([0, 0,0])  cylinder(d=d_hole,h=200);
    
    // Countersink form above
    translate([timber_construct_h/2,d_hole*1.5-d_hole*3,-1]) rotate([0, 0, 0])  cylinder(d1=d_hole, d2=10,h=3.2);
    translate([timber_construct_h/2,d_hole*1.5-d_hole*3,0.7+2.45-1]) rotate([0, 0, 0])  cylinder(d=10,h=3);
    translate([timber_construct_h/2,d_hole*1.5+d_hole*3,-1]) rotate([0, 0,0])  cylinder(d1=d_hole, d2=10,h=3.2);
    translate([timber_construct_h/2,d_hole*1.5+d_hole*3,0.7+2.45-1]) rotate([0, 0, 0])  cylinder(d=10,h=3);

    // COuntersink side
    rotate([0, 90-theta,0])  translate([-timber_construct_w/2,d_hole*1.5,timber_construct_h+5]) cylinder(d1=d_hole, d2=10,h=3.2);
    rotate([0, 90-theta,0])  translate([-timber_construct_w/2,d_hole*1.5,timber_construct_h+8.1]) cylinder(d=10,h=8);    
}
}

*translate([142,0,0]) mirror([1,0,0]) slim();
slim();