shed_length = 5184;
shed_width = 1981;
shed_front_height = 2350;
shed_back_height = 2135;

window_w=1830;
window_h=610; 
door_w=870; 
door_h=2030;

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


opp = shed_front_height-shed_back_height;
adj = shed_width -timber_construct_h;
hyp = sqrt(opp*opp+adj*adj);
theta = atan(opp/adj);
thin_opp = tan(theta) * timber_construct_h;


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
    color("Black",1)
    {
        cube([width, length, wrap_t]);
        cube([width, wrap_t, overlap]);
        translate([0,length-wrap_t,0]) cube([width, wrap_t, overlap]);
        cube([wrap_t, length, overlap]);
        translate([width-wrap_t,0,0]) cube([wrap_t, length, overlap]);
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
    translate([wrap_t,shed_width-timber_construct_h-wrap_t,base_timber_h+wrap_t+base_sheet_t])     
    {
        struct_set_w = (width-wrap_t*2)/structs_sets;
        for(structs=[0:structs_sets-1])
        {
            translate([structs*struct_set_w,0,0]) verticalStruts(struct_set_w, height, beams=beams, extra_struct=extra_struct);
        }
    }
    
}

module sideStructs(width = shed_width, height = shed_back_height, beams=2, extra_struct=2)
{
    echo("SideStructs");
    translate([timber_construct_h+wrap_t,timber_construct_h,base_timber_h+wrap_t+base_sheet_t])
    {
        rotate([0,0,90]) verticalStruts(width-timber_construct_h*2, height, beams=beams, extra_struct=extra_struct);
    }    
}


module leftSideStructs()
{
    sideStructs();
}


module rightSideStructs()
{
    translate([shed_length-timber_construct_h-wrap_t*2,0,0]) sideStructs();
}


module frontStructs()
{
    translate([wrap_t,-wrap_t,base_timber_h+wrap_t+base_sheet_t+1])     
    {
        verticalStruts(space_to_window_w, door_h, beams=2, extra_struct=0);
        translate([space_to_window_w,0,0]) verticalStruts(window_w, space_to_window_h, beams=1, extra_struct=1);
        translate([space_to_window_w+window_w,0,0])  verticalStruts(space_to_window_w, door_h, beams=2, extra_struct=1);
        translate([space_to_door_w+door_w,0,0])  verticalStruts(shed_length-(space_to_door_w+door_w), door_h, beams=2, extra_struct=0);
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
    // hyp
    inner_width = hyp+timber_construct_h;
    flat_offset = (sheet_length - inner_width)/2;

    translate([-flat_offset,-wrap_t,shed_front_height+ base_timber_h+wrap_t+base_sheet_t +1 +thin_opp ]) rotate([-theta,0,0]) frameSheet( sheet_front_offset=-flat_offset*1.5, front_offset=0, back_offset=flat_offset*2, left_offset=flat_offset);
}

module frameSheet(left_offset=0, right_offset=0, front_offset=0, back_offset=0, sheet_left_offset=0, sheet_right_offset=0, sheet_front_offset=0, sheet_back_offset=0, sw=sheet_width, sl = sheet_length)
{
    translate([left_offset, front_offset, 0]) cubeI([sw-left_offset-right_offset, timber_construct_h, timber_construct_w]);
    translate([left_offset, sl - back_offset-timber_construct_h, 0]) cubeI([sw-left_offset-right_offset, timber_construct_h, timber_construct_w]);
    translate([left_offset, front_offset+timber_construct_h, 0]) cubeI([timber_construct_h, sl-front_offset-back_offset-2*timber_construct_h, timber_construct_w]);
    translate([sw-right_offset-timber_construct_h, front_offset+timber_construct_h, 0]) cubeI([timber_construct_h, sl-front_offset-back_offset-2*timber_construct_h, timber_construct_w]);
    translate([sheet_left_offset, sheet_front_offset, timber_construct_w]) cubeI([sw-sheet_back_offset,sl-sheet_right_offset, base_sheet_t]);
}


floorBeams();

floorPanels();

backStructs();

leftSideStructs();
rightSideStructs();

frontStructs();
roof();