shed_length = 5184;
shed_width = 1981;
shed_front_height = 2250;
//shed_back_height = 2030;

window_w=1830;
window_h=920; 
door_w=858; // 1981 x 838mm + 20
door_h=1991; // 1981 x 838mm + 20
shed_back_height = door_h;

space_to_window_w=window_w/2;
space_to_window_h=door_h-window_h;
space_to_door_w=window_w + 2*space_to_window_w;



base_timber_w = 47;
base_timber_h = 75;
timber_construct_w = 38;
timber_construct_h = 63;
timber_length_unit=2400;
base_sheet_t = 18;
sheet_width = 1220;
sheet_length = 2440;

wrap_t = 1;

first_layer = base_timber_h+wrap_t+base_sheet_t;


opp = shed_front_height-shed_back_height;
adj = shed_width -timber_construct_h;
hyp = sqrt(opp*opp+adj*adj);
theta = atan(opp/adj);
thin_opp = tan(theta) * timber_construct_h;

echo("Theta ", theta);

module cubeI(size,comment="//", center=false)
{
    if (comment != "//")
        echo(comment);
    // Cube - but will echo dimensions in order of size
    if( (size[0]>size[1]) && (size[1]>=size[2]) )
       echo( size[0], size[1], size[2]);
    if( (size[0]>size[2]) && (size[2]>size[1]) )
       echo( size[0], size[2], size[1]);
    
    if( (size[1]>size[0]) && (size[0]>=size[2]) )
       echo( size[1], size[0], size[2]);
    if( (size[1]>size[2]) && (size[2]>size[0]) )
       echo( size[1], size[2], size[0]);
    
    if( (size[2]>size[0]) && (size[0]>=size[1]) )
       echo( size[2], size[0], size[1]);
    if( (size[2]>size[1]) && (size[1]>size[0]) )
       echo( size[2], size[1], size[0]);

    cube(size, center=center);
}

module houseWrapLayer(width,length, overlap=100)
{
    echo("House Wrap",width+overlap,length+overlap);
    color("Black",0.75)
    {
        cube([width, length, wrap_t]);
        cube([width, wrap_t, overlap]);
        translate([0,length-wrap_t,0]) cube([width, wrap_t, overlap]);
        cube([wrap_t, length, overlap]);
        translate([width-wrap_t,0,0]) cube([wrap_t, length, overlap]);
    }
}


module beamsWrap()
{
    
    translate([0,shed_width,first_layer])  rotate([90,0,0]) houseWrapLayer(shed_length,shed_back_height, overlap=100);

    translate([0,-1,first_layer])  rotate([90,0,90]) difference() 
        {
        houseWrapLayer(shed_width,shed_front_height+timber_construct_h, overlap=100);
        translate([-opp,shed_front_height+timber_construct_h,-opp]) rotate([0,0,-theta]) cube([shed_width*2,opp*2, opp*2]);
        }

     translate([shed_length,shed_width-1,first_layer])  rotate([90,0,-90]) difference() 
        {
        houseWrapLayer(shed_width,shed_front_height+timber_construct_h, overlap=100);
        translate([-opp,shed_front_height-opp,-opp]) rotate([0,0,theta]) cube([shed_width*2,opp*2, opp*2]);
        }
    difference() 
        {
            translate([shed_length,-2,first_layer])  rotate([90,0,180]) houseWrapLayer(shed_length,shed_front_height, overlap=100);
           translate([space_to_window_w, -50, space_to_window_h+first_layer]) cube([window_w, 100, window_h]);
           translate([space_to_door_w, -50, first_layer]) cube([door_w, 100, door_h]);
        }

        
}


module OSB(size,center=false)
{
    echo("OSB");
    cubeI(size,center=center);
}


module floorPanel(width,length)
{
/*
    echo("Timber");
    //Timber supporting base along left side
    cubeI([base_timber_w, length, base_timber_h]);
    //Timber supporting base along right side
    translate([width-base_timber_w,0,0])  cubeI([base_timber_w, length, base_timber_h]);
    //Timber supporting base Middle of I
    translate([base_timber_w,(length-base_timber_h)/2,base_timber_h-base_timber_w])  cubeI([width-base_timber_w*2, base_timber_h, base_timber_w]);
*/
    //DuPont Tyvek Housewrap - 100m 1.4m
    translate([0,0,base_timber_h]) houseWrapLayer(width,length,overlap=25);

    //OSB Board - although the board is not cut by 1 mm (wrap_t) in each
    //              direction for drawing purposes it is shaved
    translate([wrap_t,wrap_t,base_timber_h+wrap_t]) OSB([width-wrap_t*2,length-wrap_t*2,base_sheet_t]);        
}

module floorBeams(width = shed_width, length = shed_length, overlap = 150, cross_beams=5)
{
    echo("floorBeams");
    // from one end along the front
    translate([0,0,0]) cubeI([timber_length_unit, base_timber_w, base_timber_h]);
    // from oother end along the front
    translate([length-timber_length_unit, 0, 0]) cubeI([timber_length_unit, base_timber_w, base_timber_h]);
    translate([timber_length_unit-overlap, base_timber_w, 0]) cubeI([length-2*(timber_length_unit-overlap), base_timber_w, base_timber_h]);

    //Again at the back
    // from one end along the front
    translate([0,width-base_timber_w,0]) cubeI([timber_length_unit, base_timber_w, base_timber_h]);
    // from oother end along the front
    translate([length-timber_length_unit, width-base_timber_w, 0]) cubeI([timber_length_unit, base_timber_w, base_timber_h]);
    translate([timber_length_unit-overlap, width-base_timber_w*2, 0]) cubeI([length-2*(timber_length_unit-overlap), base_timber_w, base_timber_h]);

    //Each end of shed
    translate([0, base_timber_w, base_timber_h-base_timber_w]) cubeI([base_timber_h, width-base_timber_w*2, base_timber_w]);
    translate([length-base_timber_h, base_timber_w, base_timber_h-base_timber_w]) cubeI([base_timber_h, width-base_timber_w*2, base_timber_w]);

    // Middle suport
    translate([base_timber_h, (width-base_timber_w)/2, 0]) cubeI([timber_length_unit, base_timber_w, base_timber_h]);
    translate([length-base_timber_h-timber_length_unit, (width-base_timber_w)/2, 0]) cubeI([timber_length_unit, base_timber_w, base_timber_h]);
    translate([timber_length_unit+base_timber_h-overlap, (width-base_timber_w)/2+base_timber_w, 0]) cubeI([length-2*timber_length_unit+overlap, base_timber_w, base_timber_h]);

   // Middle Cross beams0
   translate([(length-base_timber_w)/2-base_timber_h/2, base_timber_w*2, base_timber_h-base_timber_w]) cubeI([base_timber_h, (width-3*base_timber_w)/2, base_timber_w]);
    translate([(length-base_timber_w)/2+base_timber_h/2, base_timber_w*3+(width-3*base_timber_w)/2, base_timber_h-base_timber_w]) cubeI([base_timber_h, (width-3*base_timber_w)/2-2*base_timber_w, base_timber_w]);
    
}


module floorPanels(width = shed_width, length = shed_length)
{
    echo("floorPanels");
    sheet_width_inc_wrap = sheet_width + 2*wrap_t;
    num_width_panels = round(-0.5+length/sheet_width_inc_wrap);
    for(base_x = [0 : num_width_panels-1])
    {
        translate([base_x*sheet_width_inc_wrap, 0, 0]) floorPanel(sheet_width_inc_wrap,width);
    }
    full_panels_width = sheet_width_inc_wrap*num_width_panels;
    translate([full_panels_width, 0, 0]) floorPanel(length-full_panels_width,width);
}

module verticalStruts(width, height, beams=0, extra_struct=0)
{
    cubeI([width,timber_construct_h,timber_construct_w]);
    translate([0,0,height-timber_construct_w]) cubeI([width,timber_construct_h,timber_construct_w]);
    translate([0,0,timber_construct_w]) cubeI([timber_construct_w,timber_construct_h,height-timber_construct_w*2]);
    translate([width-timber_construct_w,0,timber_construct_w]) cubeI([timber_construct_w,timber_construct_h,height-timber_construct_w*2]);

    if(beams>0 && extra_struct==0)
    {
        middle_height = height-timber_construct_w*2;
        beam_spacing = middle_height/(beams+1);
        for(loop=[1:beams])
        {
            translate([timber_construct_w, 0, beam_spacing*loop]) cubeI([width-timber_construct_w*2,timber_construct_h,timber_construct_w]);
        }
    }
    if(beams==0 && extra_struct>0)
    {
        middle_width = width-timber_construct_w*1;
        beam_spacing = middle_width/(extra_struct+1);
        for(loop=[1:extra_struct])
        {
            translate([beam_spacing*loop, 0, timber_construct_w]) cubeI([timber_construct_w,timber_construct_h,height-2*timber_construct_w]);
        }
    }
    if(beams>0 && extra_struct>0)
    {
        middle_height = height-timber_construct_w*2;
        beam_spacing_h = middle_height/(beams+1);
        middle_width = width-timber_construct_w*1;
        beam_spacing_w = middle_width/(extra_struct+1);

        // Wee need to off set, so we divide by mod 2
        // move the all the beams down by timber_construct_w
        // but add loop mod 2 * timber_construct_w 
        // (hence odd move up, even remain down
        
        for(loop=[0:extra_struct])
        {
            if (loop>0)
                translate([beam_spacing_w*loop, 0, timber_construct_w]) cubeI([timber_construct_w,timber_construct_h,height-2*timber_construct_w]);
            for(loop_b=[1:beams])
            {
                offset = - timber_construct_w + (timber_construct_w * (loop%2));
                translate([timber_construct_w+beam_spacing_w*loop, 0, beam_spacing_h*loop_b+offset]) cubeI([beam_spacing_w-timber_construct_w,timber_construct_h,timber_construct_w]);
            }
        }        
    }
}

module backStructs(width = shed_length, height = shed_back_height, structs_sets=3, beams=2, extra_struct=1)
{
    echo("backStructs");
    translate([wrap_t,shed_width-timber_construct_h-wrap_t,first_layer])     
    {
        struct_set_w = (width-wrap_t*2)/structs_sets;
        for(structs=[0:structs_sets-1])
        {
            echo("backStructs - Section");
            translate([structs*struct_set_w,0,0]) verticalStruts(struct_set_w, height, beams=beams, extra_struct=extra_struct);
        }
    }
    
}

module sideStructs(width = shed_width, height = shed_back_height, beams=2, extra_struct=2)
{
    echo("SideStructs");
    translate([timber_construct_h+wrap_t,timber_construct_h,first_layer])
    {
        rotate([0,0,90]) verticalStruts(width-timber_construct_h*2, height, beams=beams, extra_struct=extra_struct);
    }    
}


module leftSideStructs()
{
    echo("leftSideStructs");
    sideStructs();
}


module rightSideStructs()
{
    echo("rightSideStructs");
    translate([shed_length-timber_construct_h-wrap_t*2,0,0]) sideStructs();
}


module frontStructs()
{
    echo("frontStructs");
    translate([wrap_t,-wrap_t,first_layer+1])     
    {
        verticalStruts(space_to_window_w, door_h, beams=2, extra_struct=0);
        translate([space_to_window_w,0,0]) verticalStruts(window_w, space_to_window_h, beams=1, extra_struct=2);
        translate([space_to_window_w+window_w,0,0])  verticalStruts(space_to_window_w, door_h, beams=2, extra_struct=0);
        translate([space_to_door_w+door_w,0,0])  verticalStruts(shed_length-(space_to_door_w+door_w), door_h, beams=3, extra_struct=1);
        // top part, which is longer than a standard timber_length_unit 
        gap = (space_to_door_w - timber_length_unit)/2;
        remainder = shed_length - timber_length_unit - gap;
        translate([0,0,door_h])  verticalStruts(gap, shed_front_height-door_h, beams=0, extra_struct=0);
        translate([gap,0,door_h])  verticalStruts(timber_length_unit, shed_front_height-door_h, beams=0, extra_struct=2);
        translate([timber_length_unit + gap,0,door_h])  verticalStruts(remainder, shed_front_height-door_h, beams=0, extra_struct=2);
    }
}

module roof()
{
    echo("roof");
    // hyp
    inner_width = hyp+timber_construct_h;
    flat_offset = (sheet_length - inner_width)/2;

    translate([-flat_offset,-wrap_t,shed_front_height+ first_layer +1 +thin_opp ]) rotate([-theta,0,0]) 
    {
        frameSheet( sheet_front_offset=-flat_offset*1.5, front_offset=0, back_offset=flat_offset*2, left_offset=flat_offset);
        translate([sheet_width*4,0,0]) frameSheet( sheet_front_offset=-flat_offset*1.5, front_offset=0, back_offset=flat_offset*2, right_offset=flat_offset, sw= shed_length - sheet_width*4+flat_offset*2);

        translate([sheet_width,0,0]) frameSheet( sheet_front_offset=-flat_offset*1.5, front_offset=0, back_offset=flat_offset*2);
        translate([sheet_width*2,0,0]) frameSheet( sheet_front_offset=-flat_offset*1.5, front_offset=0, back_offset=flat_offset*2);
        translate([sheet_width*3,0,0]) frameSheet( sheet_front_offset=-flat_offset*1.5, front_offset=0, back_offset=flat_offset*2);
    }
}

module frameSheet(left_offset=0, right_offset=0, front_offset=0, back_offset=0, sheet_left_offset=0, sheet_right_offset=0, sheet_front_offset=0, sheet_back_offset=0, sw=sheet_width, sl = sheet_length)
{
    translate([left_offset, front_offset, 0]) cubeI([timber_construct_h, sl-front_offset-back_offset, timber_construct_w]);
    translate([sw-right_offset-timber_construct_h, front_offset, 0]) cubeI([timber_construct_h, sl-front_offset-back_offset, timber_construct_w]);

   beam_l = (sw-left_offset-right_offset-3*timber_construct_h)/2;
   
    translate([left_offset+beam_l+timber_construct_h, front_offset, 0]) cubeI([timber_construct_h, sl-front_offset-back_offset, timber_construct_w]);
    
   translate([left_offset+timber_construct_h, front_offset, 0]) cubeI([beam_l, timber_construct_h, timber_construct_w]);
   translate([left_offset+timber_construct_h+beam_l+timber_construct_h, front_offset, 0]) cubeI([beam_l, timber_construct_h, timber_construct_w]);
    
    translate([left_offset+timber_construct_h, sl - back_offset-timber_construct_h, 0]) cubeI([beam_l, timber_construct_h, timber_construct_w]);
    translate([left_offset+timber_construct_h+beam_l+timber_construct_h, sl - back_offset-timber_construct_h, 0]) cubeI([beam_l, timber_construct_h, timber_construct_w]);

    translate([sheet_left_offset, sheet_front_offset, timber_construct_w]) OSB([sw-sheet_back_offset,sl-sheet_right_offset, base_sheet_t]);
    mirror([0,0,1]) translate([sheet_left_offset, sheet_front_offset, -timber_construct_w-base_sheet_t-wrap_t]) 
        houseWrapLayer(sw-sheet_back_offset+2*wrap_t,sl-sheet_right_offset+2*wrap_t, overlap=25);
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
    echo("Cladding: ",  x, board_height); 
    translate([0, -board_width_b, 0]) color("Peru",0.6) rotate([-degrees,0,0])
    {
        cube([x, board_width_b - board_width_s, board_height]);
        translate([0,- board_width_s,0]) prism(x, board_width_s, board_height);
    }
}


module caddings(x, z, board_height = 150, board_width_b = 11, board_width_s = 6, overlap = 34, degrees=3)
{
    panel_uplift = board_height - overlap;
    panels = round(-0.5+z/panel_uplift);
    for(p = [0 : panels-1])
    {
        translate([0,0,panel_uplift * p]) 
         cadding(x, board_height, board_width_b, board_width_s, degrees);
    }
}


module claddingBackWall()
{
    translate([shed_length,shed_width,first_layer]) rotate([0,0,180]) caddings(shed_length, shed_back_height);
}

module claddingLeftWall()
{
    translate([0,shed_width,first_layer]) rotate([0,0,180+90]) 
    difference()
    {
        caddings(shed_width, shed_front_height);
        translate([-opp,-opp,shed_front_height-opp]) rotate([0,-theta,0]) cube([shed_width*2,opp*2, opp*2]);
    }
}

module claddingRightWall()
{
    translate([shed_length,0,first_layer]) rotate([0,0,180-90]) 
    difference()
    {
        caddings(shed_width, shed_front_height);
        translate([-opp,-opp,shed_back_height+opp+base_timber_h]) rotate([0,theta,0]) cube([shed_width*2,opp*2, opp*2]);
    }
}

module claddingFrontWall()
{
    translate([0,0,first_layer]) rotate([0,0,0]) 
        difference()
    {
        caddings(shed_length, shed_front_height);
           translate([space_to_window_w, -50, space_to_window_h]) cube([window_w, 100, window_h]);
           translate([space_to_door_w, -50, 0]) cube([door_w, 100, door_h]);
    }
}

module innerInsulation()
{
    echo("Insulation");
    insulation_t = 50;
    translate([0,0,first_layer]) 
    {
    translate([0,shed_width-insulation_t,0]) 
        cube([shed_length, insulation_t, shed_back_height]);

    translate([0,insulation_t,0]) difference()
        {
            cube([insulation_t, shed_width-2*insulation_t, shed_front_height]);
            translate([-insulation_t,0,shed_front_height]) rotate([-theta,0,0]) cube([3*insulation_t,shed_width+2*insulation_t, opp*2]);
        }
    translate([shed_length-insulation_t,insulation_t,0]) difference()
        {
            cube([insulation_t, shed_width-2*insulation_t, shed_front_height]);
            translate([-insulation_t,0,shed_front_height]) rotate([-theta,0,0]) cube([3*insulation_t,shed_width+2*insulation_t, opp*2]);
        }

        
        
    translate([0,0,0])  difference()
        {
            cube([shed_length, insulation_t, shed_front_height]);
            translate([space_to_window_w, -insulation_t, space_to_window_h]) cube([window_w, 3*insulation_t, window_h]);
            translate([space_to_door_w, -insulation_t, 0]) cube([door_w, 3*insulation_t, door_h]);
        }
        
    translate([0,insulation_t,shed_front_height+60]) rotate([-theta-90,0,0])  cube([shed_length, insulation_t, hyp]);

        
    }
}


annimate_step = 1/20;

if($t>annimate_step*2) 
    floorBeams();

if($t>annimate_step*3) 
    floorPanels();

if($t>annimate_step*4) 
    backStructs();
if($t>annimate_step*5) 
    leftSideStructs();
if($t>annimate_step*6) 
    rightSideStructs();

if($t>annimate_step*7) 
    frontStructs();
if($t>annimate_step*8) 
    roof();
if($t>annimate_step*9) 
    beamsWrap();

if($t>annimate_step*10) 
    claddingBackWall();
if($t>annimate_step*11) 
    claddingLeftWall();
if($t>annimate_step*12) 
    claddingRightWall();
if($t>annimate_step*13) 
    claddingFrontWall();

if($t>annimate_step*14) 
    innerInsulation();
