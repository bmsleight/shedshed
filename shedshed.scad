
shed_length = 5184;
shed_width = 1829+305/2;
shed_front_height = 2350;
shed_front_back = 2135;
base_timber = 47;
timber_construct_w = 38;
timber_construct_h = 63;
base_sheet_t = 18;



module cubeI(size,center=false)
{
    echo("Dim: ",size);
    cube(size, center=center);
}


module shedBaseSection(x,y,timber_width=75,timber_length=47, braces=0)
{
    echo("shedBaseSection: x,y,timber_width,timber_length, braces ", x,y,timber_width,timber_length, braces);
    echo("http://www.wickes.co.uk/Wickes-Sawn-Kiln-Dried-47X75-x-3000mm-Single/p/107186#tab-DynamicDeliveryWebTab_content");
    cubeI([x,timber_width,timber_length]);
    translate([0,y-timber_width,0]) cubeI([x,timber_width,timber_length]);
    translate([0,timber_width,0]) cubeI([timber_width,y-timber_width*2,timber_length]);
    translate([x-timber_width,timber_width,0]) cubeI([timber_width,y-timber_width*2,timber_length]);
    if(braces > 0)
    {
        middle_y = y - timber_width*2;
        part_y = middle_y/(braces+1);
        for(loop=[1 : braces ])
        {
                translate([timber_width,timber_width/(braces+1) + (loop*part_y),0]) cubeI([x-timber_width*2, timber_width,timber_length]);            
        }            
    }
}


module shedBase(x,y,number_x,number_y, braces=1)
{
    for(base_y = [0 : number_y-1])
    {
        for(base_x = [0 : number_x-1])
            {
                translate([base_x*(x/number_x),base_y*(y/number_y),0]) shedBaseSection(x/number_x,y/number_y, braces = braces);
            }
    }
}


module floorMembrane(x,y,thickness,color="Black", overlap=10)
{
    echo("x,y,thickness=1,color, overlap=1",x,y,thickness,color, overlap);
    echo("http://www.screwfix.com/p/dmp-damp-proof-membrane-black-1000ga-3-x-4m/50464#product_additional_details_container");
    translate([-overlap,-overlap,0]) color(color, 0.5) cube([x+overlap*2,y+overlap*2, thickness]);
}

module breatherMembrane(x,y, thickness=0.5)
{
    // google timber frame breather membrane
    rotate([90,0,0])  floorMembrane(x,y,thickness=thickness,color="Black", overlap=thickness);
}

module breatherMembraneSide(x,y, thickness=0.5)
{
    // google timber frame breather membrane

    opp = y-shed_front_back;
    adj = x - base_timber;
    hyp = sqrt(opp*opp+adj*adj);
    theta = atan(opp/adj);
    echo("Degrees: ", theta);
    translate([0,0,0]) rotate([90,0,90]) difference()
    {
        floorMembrane(x,y,thickness=thickness,color="Black", overlap=thickness);
        translate([0,y,-opp/2]) rotate([0,0,-theta]) cube([x+10,opp*2,opp]);
    }    
}

module breatherMembraneFront(x,y, thickness, space_to_window_w, space_to_window_h, window_w, window_h, door_w, door_h)
{
    echo ("lll", x,y, thickness, space_to_window_w, space_to_window_h, window_w, window_h, door_w, door_h);
    translate([0,0,0]) rotate([90,0,0]) difference()
    {
        floorMembrane(x,y,thickness=thickness,color="Black", overlap=thickness);
        translate([space_to_window_w,space_to_window_h,-100]) rotate([0,0,0]) cube([window_w,window_h,200]);
        translate([space_to_window_w*2+window_w,0,-100]) cube([door_w,door_h,200]);
    }    
}


module sheetFramed(size,center=false, f_timber_width=0, f_timber_length=0, f_offset_w_l=0, f_offset_w_r=0, f_offset_l=0)
{
    cubeI(size, center=center);
    if(f_timber_width>0) // Panel is Not longer than width
    {
        translate([f_offset_w_l,f_offset_l,-f_timber_length]) cubeI([size[0]-f_offset_w_l-f_offset_w_r, f_timber_width, f_timber_length]);
        translate([f_offset_w_l,size[1]-f_timber_width-f_offset_l,-f_timber_length]) cubeI([size[0]-f_offset_w_l-f_offset_w_r, f_timber_width, f_timber_length]);
        translate([f_offset_w_l,f_offset_l+f_timber_width,-f_timber_length]) cubeI([f_timber_width, size[1]-f_offset_l*2-f_timber_width*2, f_timber_length]);
      translate([size[0]-f_timber_width-f_offset_w_r,f_offset_l+f_timber_width,-f_timber_length]) cubeI([f_timber_width, size[1]-f_offset_l*2-f_timber_width*2, f_timber_length]);
        }
}


module shedLowerFloor(x,y, panel_slf_w = 1220, panel_slf_l = 2440, panel_slf_t = base_sheet_t, panel_min_dimentions = 100, f_timber_width=0,f_timber_length=0, f_offset_l=0)
{
//    echo("http://www.wickes.co.uk/Wickes-Non-Structural-Hardwood-Plywood-5-5x607x1829mm/p/111196");
    echo("http://www.wickes.co.uk/Wickes-General-Purpose-OSB3-Board-18x1220x2440mm/p/110517");
    x_panels = round(-0.5+x/panel_slf_w);
    y_panels = round(-0.5+y/panel_slf_l);
    echo(y_panels);
    if(y_panels>0) // Panel is Not longer than width
    {
        for(base_y = [0 : y_panels-1]) //Truncate not round
        {
            for(base_x = [0 : x_panels-1])
            {
                // f_offset_w_l=0, f_offset_w_r=0
                 f_offset_w_l_ =   base_x==0 ? f_offset_l +timber_construct_w/2+3: 0;
                translate([base_x*panel_slf_w,base_y*panel_slf_l,0]) sheetFramed([panel_slf_w, panel_slf_l,panel_slf_t], f_timber_width=f_timber_width, f_timber_length=f_timber_length, f_offset_l=f_offset_l, f_offset_w_l=f_offset_w_l_);
                if(y-(panel_slf_l*y_panels) > panel_min_dimentions)
                translate([base_x*panel_slf_w,y_panels*panel_slf_l,0]) sheetFramed([panel_slf_w, y-(panel_slf_l*y_panels),panel_slf_t]);
            }
            if(x-(panel_slf_w*x_panels) > panel_min_dimentions)
                translate([(x_panels)*panel_slf_w,(y_panels-1)*panel_slf_l,0]) sheetFramed([x-(panel_slf_w*x_panels), panel_slf_l,panel_slf_t], f_timber_width=f_timber_width, f_timber_length=f_timber_length, f_offset_l=f_offset_l, f_offset_w_r=f_offset_l +timber_construct_w/2+3); 
            if(y-(panel_slf_l*y_panels) > panel_min_dimentions)
                translate([(x_panels)*panel_slf_w,y_panels*panel_slf_l,0]) sheetFramed([x-(panel_slf_w*x_panels), y-(panel_slf_l*y_panels),panel_slf_t]);
        }
    }
    else // Panel is longer than width
    {
     for(base_x = [0 : x_panels-1])
     {
        translate([base_x*panel_slf_w,0,0]) sheetFramed([panel_slf_w, y,panel_slf_t]);       
     }
     if(x-(panel_slf_w*x_panels) > panel_min_dimentions)
                translate([(x_panels)*panel_slf_w,0,0]) sheetFramed([x-(panel_slf_w*x_panels), y,panel_slf_t]); 
    }
}


module verticalStruts(x,z,timber_width=timber_construct_w,timber_length=timber_construct_h, braces=0, beams=0)
{
//    echo("shedBaseSection(x,z,timber_width,timber_length, braces",x,z,timber_width,timber_length, braces);
    echo("Struts - http://www.wickes.co.uk/Wickes-Studwork-%28CLS%29-38x63x2400mm-Single/p/107177");
    cubeI([x,timber_length,timber_width]);
    translate([0,0,z-timber_width]) cubeI([x,timber_length,timber_width]);
    translate([0,0,timber_width]) cubeI([timber_width,timber_length,z-timber_width*2]);
    translate([x-timber_width,0,timber_width]) cubeI([timber_width,timber_length,z-timber_width*2]);
    if(braces > 0)
    {
        middle_z = z - timber_width*2;
        part_z = middle_z/(braces+1);
        for(loop=[1 : braces ])
        {
                translate([timber_width,0,timber_width/(braces+1) + (loop*part_z)]) cubeI([x-timber_width*2,timber_length, timber_width]);            
        }
    }
    if(beams> 0)
    {
        middle_x = x - timber_length*2;
        part_x = middle_x/(beams+1);
        for(loop=[1 : beams ])
        {
            translate([timber_length/(beams+1) + (loop*part_x),0,timber_width]) cubeI([timber_width,timber_length,z-timber_width*2]);            
        }  
    }
}


module backWallStruts(x,z,number_x, braces=1)
{
    echo("backWallStruts(x,z,number_x, braces)",x,z,number_x, braces);
        for(base_x = [0 : number_x-1])
            {
                translate([base_x*(x/number_x),0,0]) verticalStruts(x/number_x,z, braces = braces);
            }
}

module sideWallStruts(x,z,number_x, braces=1)
{
    echo("sideWallStruts(x,z,number_x, braces)",x,z,number_x, braces);
    rotate([0,0,90]) backWallStruts(x,z,number_x, braces);
}


module prism(l, w, h)
{
    polyhedron(
        points=[[0,0,0], [l,0,0], [l,w,0], [0,w,0], [0,w,h], [l,w,h]],
        faces=[[0,1,2,3],[5,4,3,2],[0,4,5,1],[0,3,4],[5,2,1]]
        );
}


module cadding(x, board_height, board_width_b, board_width_s, degrees)
{
    echo("Cladding: ", board_height, x); 
    translate([0, -board_width_b, 0]) color("Peru",0.6) rotate([-degrees,0,0])
    {
        cube([x, board_width_b - board_width_s, board_height]);
        translate([0,- board_width_s,0]) prism(x, board_width_s, board_height);
    }
}


module caddings(x, z, board_height = 150, board_width_b = 11, board_width_s = 6, overlap = 34, degrees=3)
{
    echo("Cladding Total:", x, z);
    panel_uplift = board_height - overlap;
    panels = round(-0.5+z/panel_uplift);
    for(p = [0 : panels-1])
    {
        translate([0,0,panel_uplift * p]) 
         cadding(x, board_height, board_width_b, board_width_s, degrees);
    }
}


module claddingBackWall(x,z)
{
    translate([x,0,0]) rotate([0,0,180]) caddings(x, z);
}

module claddingLeftSideWall(x,z)
{
    opp = z-shed_front_back;
    adj = x - base_timber;
    hyp = sqrt(opp*opp+adj*adj);
    theta = atan(opp/adj);
    echo("Degrees: ", theta);
    translate([0,x,0]) rotate([0,0,270]) difference()
    {
        caddings(x, z);
      translate([0,-opp/2,z-opp]) rotate([0,-theta,0]) cube([x+10,opp,opp*2]);
    }
}

module claddingRightSideWall(x,z)
{
    opp = z-shed_front_back;
    adj = x - base_timber;
    hyp = sqrt(opp*opp+adj*adj);
    theta = atan(opp/adj);
    echo("Degrees: ", theta);
    translate([0,0,0]) rotate([0,0,90]) difference()
    {
        caddings(x, z);
        translate([0,-opp/2,z]) rotate([0,theta,0]) cube([x+10,opp,opp*2]);
    }
}

module claddingFrontWall(x,z, space_to_window_w, space_to_window_h, window_w, window_h, door_w, door_h)
{
    translate([0,0,0]) rotate([0,0,0]) difference()
    {
        caddings(x, z);
        translate([space_to_window_w,-100,space_to_window_h]) rotate([0,0,0]) cube([window_w,200,window_h]);
        translate([space_to_window_w*2+window_w,-100,0]) rotate([0,0,0]) cube([door_w,200,door_h]);
    }
}



module frontWallStruts(x,z, space_to_window_w, space_to_window_h, window_w, window_h, door_w, door_h, braces)
{
    echo("frontWallStruts(x,z,space_to_window_w, space_to_window_h, window_w, window_h, door_w, braces)", x,z, space_to_window_w, space_to_window_h, window_w, window_h, door_w, door_h, braces);
    translate([0,0,0]) verticalStruts(space_to_window_w,space_to_window_h+window_h, braces = braces);
    translate([space_to_window_w,0,0]) verticalStruts(window_w,space_to_window_h, braces = braces, beams=1);
    translate([0,0,space_to_window_h+window_h]) verticalStruts(space_to_window_w/2,z-(space_to_window_h+window_h), braces = braces);
    translate([space_to_window_w/2,0,space_to_window_h+window_h]) verticalStruts(window_w+space_to_window_w,z-(space_to_window_h+window_h), braces = braces, beams=2);
    translate([space_to_window_w+window_w,0,0]) verticalStruts(space_to_window_w,space_to_window_h+window_h, braces = braces);
    if(door_h-(space_to_window_h+window_h>0))  translate([space_to_window_w/2+window_w+space_to_window_w,0,space_to_window_h+window_h]) verticalStruts(space_to_window_w/2,door_h-(space_to_window_h+window_h), braces = braces);
    translate([space_to_window_w/2+window_w+space_to_window_w,0,door_h]) verticalStruts(x-(space_to_window_w/2+window_w+space_to_window_w),z-door_h, braces = braces, beams=2);
    translate([space_to_window_w+window_w+space_to_window_w+door_w,0,0]) verticalStruts(x-(space_to_window_w+window_w+space_to_window_w+door_w),door_h, braces = braces);
}

module roofJoist(y,timber_width=75,timber_length=47)
{
    cubeI([timber_width,y,timber_length]);
}

module roofJoists(x,y,number_x,timber_width=75,timber_length=47)
{
    x_inside = x - timber_length*2 - timber_width;
    x_inside_part = x_inside / number_x; 
    for(base_x = [0 : number_x])
       {
        translate([timber_length+(x_inside_part*base_x),0,-timber_length])  roofJoist(y);
       }
}

module roof(x,y,z_front,z_back, panel_slf_w = 1220, panel_slf_l = 2440, panel_slf_t = base_sheet_t)
{
    opp = z_front-z_back;
    adj = y - base_timber;
    hyp = sqrt(opp*opp+adj*adj);
    theta = atan(opp/adj);
    overhang = (panel_slf_l-hyp)/2;
    overhang_flat = cos(theta) * overhang;
    overhang_up = sin(theta) * overhang;
    
    // Want it to line up with front of timber truct not back
    height_adjust = base_timber * tan(theta);
    echo("overhang", overhang, opp, hyp, theta, height_adjust, overhang_flat, overhang_up);
    translate([-overhang_flat,-overhang_flat,z_front+base_timber+panel_slf_t+height_adjust+overhang_up]) rotate([-theta,0,0]) 
    {
        translate([0,timber_construct_h/2,0]) shedLowerFloor(x+overhang_flat*2,panel_slf_l, f_timber_width=75, f_timber_length=47, f_offset_l=overhang_flat-base_timber/2); 
//        translate([overhang,overhang,0]) roofJoists(x,y+17.5,7 );
    }
}

module insulate(space_to_window_w, space_to_window_h, window_w, window_h, door_w, door_h, thickness=50, colour="White", off=0)
{
    translate([thickness,shed_width-thickness-off,0]) color(colour,0.5) cube([shed_length-thickness*2, thickness, shed_front_back]);

    opp = shed_front_height-shed_front_back;
    adj = shed_width - base_timber;
    hyp = sqrt(opp*opp+adj*adj);
    theta = atan(opp/adj);
    echo("Degrees: ", theta);
    translate([0,0,0]) rotate([0,0,90]) difference()
    {
        translate([thickness,-thickness-off,0]) color(colour,0.5) cube([shed_width-thickness*2, thickness, shed_front_height]);        
        translate([0,-opp/2-off,shed_front_height]) rotate([0,theta,0]) cube([shed_width+10,opp,opp*2]);
    }
    translate([shed_length-thickness-off,0,0]) rotate([0,0,90]) difference()
    {
        translate([thickness,-thickness,0]) color(colour,0.5) cube([shed_width-thickness*2, thickness, shed_front_height]);        
        translate([0,-opp/2,shed_front_height]) rotate([0,theta,0]) cube([shed_width+10,opp,opp*2]);
    }

    translate([0,off,0]) rotate([0,0,0]) difference()
    {
    translate([thickness,0,0]) color(colour,0.5) cube([shed_length-thickness*2, thickness, shed_front_height]);
        translate([space_to_window_w,-100,space_to_window_h]) rotate([0,0,0]) cube([window_w,200,window_h]);
        translate([space_to_window_w*2+window_w,-100,0]) rotate([0,0,0]) cube([door_w,200,door_h]);
    }

    
    
    
}

module restOfGarden(offset_x=-381, offset_y=+381 + shed_width)
{
    garden_width= 5947.4;
    garden_length_shed_space = 2440;
    translate([offset_x, offset_y,0])
    {
        color("Green") cube([garden_width, 10, 1830]);
        translate([0,-garden_length_shed_space-381,0]) color("Green") cube([10, garden_length_shed_space+381, 1830]);
        translate([garden_width,-garden_length_shed_space,0]) color("Green") cube([10, garden_length_shed_space, 1830]);
    }
    translate([-381,-3507.5-2592.5-381,0]) color("Green") cube([10, +3507.5+2592.5+381, 1830]);
//    translate([garden_width-381,-3507.5-2592.5-381,0]) color("Green") cube([10, +3507.5+2592.5+381, 1830]);

    translate([-381+0.1,-3507.5-381,0]) color("red") cube([3202.5, 3507.5, 400]);
    translate([-381+0.1,-3507.5-2592.5-381,0]) color("red") cube([4727.5,2592.5, 400]);

    }


annimate_step = 1/20;

//rotate([6.34182+180,0,0])
//    {

if($t>annimate_step*1) 
    shedBase(shed_length, shed_width, number_x=5,number_y=1, braces=1);

if($t>annimate_step*2) 
    translate([0,0,base_timber]) floorMembrane(shed_length, shed_width, thickness = 1);

if($t>annimate_step*3) 
    translate([0,0,base_timber+1]) shedLowerFloor(shed_length, shed_width);


if($t>annimate_step*4) 
    translate([0,shed_width-timber_construct_h,base_timber+1+base_sheet_t])  backWallStruts(shed_length, shed_front_back-base_timber-1, 5);
if($t>annimate_step*5) 
    translate([timber_construct_h,timber_construct_h,base_timber+1+base_sheet_t])  sideWallStruts(shed_width-timber_construct_h*2,shed_front_back-base_timber-3,2, braces=1);

if($t>annimate_step*6) 
    translate([shed_length,timber_construct_h,base_timber+1+base_sheet_t])  sideWallStruts(shed_width-timber_construct_h*2,shed_front_back-base_timber-3,2, braces=1);

if($t>annimate_step*7) 
    translate([0,0,base_timber+1+base_sheet_t])  frontWallStruts(shed_length,shed_front_height-base_timber-3, space_to_window_w=1830/2, space_to_window_h=2030-610, window_w=1830, window_h=610, door_w=870, door_h=2030, braces=0);

if($t>annimate_step*8) 
    roof(shed_length, shed_width,shed_front_height,shed_front_back);

if($t>annimate_step*9) 
    translate([0,shed_width+0.51,base_timber])
        breatherMembrane(shed_length, shed_front_back);

if($t>annimate_step*10) 
    translate([-0.51,0,base_timber])
        breatherMembraneSide(shed_width, shed_front_height);

if($t>annimate_step*11) 
    translate([shed_length+0.5,0,base_timber])
        breatherMembraneSide(shed_width, shed_front_height);

if($t>annimate_step*12) 
    translate([0,-0.5,timber_construct_h])
        breatherMembraneFront(shed_length,shed_front_height, thickness=0.5,  space_to_window_w=1830/2, space_to_window_h=2030-610, window_w=1830, window_h=610, door_w=870, door_h=2030);

//shedBaseSection(shed_length/6,shed_width, braces = 1);
if($t>annimate_step*13) 
    translate([0,shed_width+3,timber_construct_h])
        claddingBackWall(shed_length, shed_front_back);

if($t>annimate_step*14) 
    translate([-3,0,timber_construct_h])
        claddingLeftSideWall(shed_width, shed_front_height);

if($t>annimate_step*15) 
    translate([shed_length+3,0,timber_construct_h])
        claddingRightSideWall(shed_width, shed_front_height);

if($t>annimate_step*16) 
    translate([-3,0,timber_construct_h])
        claddingFrontWall(shed_length,shed_front_height,  space_to_window_w=1830/2, space_to_window_h=2030-610, window_w=1830, window_h=610, door_w=870, door_h=2030);

if($t>annimate_step*17) 
    translate([0,0,timber_construct_h])
        insulate(space_to_window_w=1830/2, space_to_window_h=2030-610, window_w=1830, window_h=610, door_w=870, door_h=2030);

if($t>annimate_step*18) 
    translate([0,0,timber_construct_h])
        insulate(space_to_window_w=1830/2, space_to_window_h=2030-610, window_w=1830, window_h=610, door_w=870, door_h=2030, thickness=5, colour="Black", off=timber_construct_h);


//restOfGarden();