
loose_fitting = 0;
timber_w = 47;
timber_h = 75;

timber_construct_w = timber_w+loose_fitting;
timber_construct_h = timber_h+loose_fitting;


hole_size = 5;
parameter = 2.5;
$fn=60;


difference()
{
    cube([timber_construct_w+1*parameter,timber_construct_h+1*parameter,+2*parameter]);
    translate([parameter,parameter,parameter]) cube([timber_construct_w+2*parameter,timber_construct_h+2*parameter,+2*parameter]);
    translate([parameter,parameter,-parameter])
    {
        translate([timber_construct_w*1/4,timber_construct_h*1/4,0]) cylinder(5*parameter, d=hole_size);
        translate([timber_construct_w*1/4,timber_construct_h*3/4,0]) cylinder(5*parameter, d=hole_size);
        translate([timber_construct_w*3/4,timber_construct_h*1/4,0]) cylinder(5*parameter, d=hole_size);
        translate([timber_construct_w*3/4,timber_construct_h*3/4,0]) cylinder(5*parameter, d=hole_size);
        translate([timber_construct_w*2/4,timber_construct_h*2/4,0]) cylinder(5*parameter, d=hole_size);
    }
    translate([timber_w/2+parameter*2,timber_h/2+parameter,parameter*3/4]) rotate([0,0,90]) linear_extrude(parameter) text(str(timber_w,"x",timber_h), size=timber_w/4, halign = "center");
}