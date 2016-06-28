
timber_construct_w = 37;
timber_construct_h = 63;
base_sheet_t = 18;
d_hole = 5;


hyp = sqrt(((timber_construct_w/2)*(timber_construct_w/2))+((timber_construct_w/2)*(timber_construct_w/2)));
$fn=60;

module prism(l, w, h)
{
    polyhedron(
        points=[[0,0,0], [l,0,0], [l,w,0], [0,w,0], [0,w,h], [l,w,h]],
        faces=[[0,1,2,3],[5,4,3,2],[0,4,5,1],[0,3,4],[5,2,1]]
        );
}


difference()
{
    union()
    {
        cube([timber_construct_w,d_hole,d_hole*3]);
        cube([d_hole,timber_construct_w,d_hole*3]);
      translate([d_hole,timber_construct_w/2+d_hole,0]) rotate([90,-90,90])  prism(d_hole*3,timber_construct_w/2,timber_construct_w/2);
    }
    translate([timber_construct_w*3/4, d_hole*2, d_hole*1.5]) rotate([90,0,0]) cylinder(h=5*d_hole, d=d_hole);
    translate([-d_hole*2, timber_construct_w*3/4, d_hole*1.5]) rotate([0,90,0]) cylinder(h=5*d_hole, d=d_hole);

  translate([-2.5, 0, -d_hole*1.5]) rotate([30,0,0]) cube([timber_construct_w+2.5+2.5,d_hole,d_hole*3]);
  translate([0, -2.5, -d_hole*1.5]) rotate([0,-30,0]) cube([d_hole,timber_construct_w+2.5+2.5,d_hole*3]);

  translate([-2.5, d_hole, d_hole*4.25]) rotate([-30,180,180]) cube([timber_construct_w+2.5+2.5,d_hole,d_hole*3]);
  translate([d_hole, -2.5, d_hole*4.25]) rotate([180,-30,180]) cube([d_hole,timber_construct_w+2.5+2.5,d_hole*3]);
    
}
