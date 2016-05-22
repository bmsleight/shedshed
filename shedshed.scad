
shed_length = 5184;
shed_width = 1829+305/2;
shed_front_height = 2400;
shed_front_back = 2135;
base_timber = 47;




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


module floorMembrane(x,y,thickness,color="Black", overlap=1)
{
    echo("x,y,thickness=1,color, overlap=1",x,y,thickness,color, overlap);
    echo("http://www.screwfix.com/p/dmp-damp-proof-membrane-black-1000ga-3-x-4m/50464#product_additional_details_container");
    translate([-overlap,-overlap,0]) color(color, 1) cube([x+overlap*2,y+overlap*2, thickness]);
}


module shedLowerFloor(x,y, panel_slf_w = 607, panel_slf_l =   1829, panel_slf_t =   5.5, panel_min_dimentions = 100)
{
    echo("http://www.wickes.co.uk/Wickes-Non-Structural-Hardwood-Plywood-5-5x607x1829mm/p/111196");
    x_panels = round(-0.5+x/panel_slf_w);
    y_panels = round(-0.5+y/panel_slf_l);
    for(base_y = [0 : y_panels-1]) //Truncate not round
    {
        for(base_x = [0 : x_panels-1])
        {
            translate([base_x*panel_slf_w,base_y*panel_slf_l,0]) cubeI([panel_slf_w, panel_slf_l,panel_slf_t]);
            if(y-(panel_slf_l*y_panels) > panel_min_dimentions)
            translate([base_x*panel_slf_w,y_panels*panel_slf_l,0]) cubeI([panel_slf_w, y-(panel_slf_l*y_panels),panel_slf_t]);
            }
        if(x-(panel_slf_w*x_panels) > panel_min_dimentions)
            translate([(x_panels)*panel_slf_w,(y_panels-1)*panel_slf_l,0]) cubeI([x-(panel_slf_w*x_panels), panel_slf_l,panel_slf_t]); 
        if(y-(panel_slf_l*y_panels) > panel_min_dimentions)
            translate([(x_panels)*panel_slf_w,y_panels*panel_slf_l,0]) cubeI([x-(panel_slf_w*x_panels), y-(panel_slf_l*y_panels),panel_slf_t]);
    }
    
}


module verticalStruts(x,z,timber_width=47,timber_length=47, braces=0)
{
//    echo("shedBaseSection(x,z,timber_width,timber_length, braces",x,z,timber_width,timber_length, braces);
//    echo("Walls - http://www.wickes.co.uk/Wickes-Sawn-Kiln-Dried-47-x-47-x-2400mm-Pack-6/p/107114");
    cubeI([x,timber_width,timber_length]);
    translate([0,0,z-timber_width]) cubeI([x,timber_width,timber_length]);
    translate([0,0,timber_width]) cubeI([timber_width,timber_length,z-timber_width*2]);
    translate([x-timber_width,0,timber_width]) cubeI([timber_width,timber_length,z-timber_width*2]);
    if(braces > 0)
    {
        middle_z = z - timber_width*2;
        part_z = middle_z/(braces+1);
        for(loop=[1 : braces ])
        {
                translate([timber_width,0,timber_width/(braces+1) + (loop*part_z)]) cubeI([x-timber_width*2, timber_width,timber_length]);            
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


module frontWallStruts(x,z, space_to_window_w, space_to_window_h, window_w, window_h, door_w, door_h)
{
    echo("frontWallStruts(x,z,space_to_window_w, space_to_window_h, window_w, window_h, door_w)", x,z, space_to_window_w, space_to_window_h, window_w, window_h, door_w, door_h);
    translate([0,0,0]) verticalStruts(space_to_window_w,space_to_window_h+window_h, braces = braces);
    for(support_windows = [0 : 1])
    {
        translate([space_to_window_w+(support_windows*window_w/2),0,0]) verticalStruts(window_w/2,space_to_window_h, braces = braces);
    }
    translate([0,0,space_to_window_h+window_h]) verticalStruts(space_to_window_w/2,z-(space_to_window_h+window_h), braces = braces);
    translate([space_to_window_w/2,0,space_to_window_h+window_h]) verticalStruts(window_w+space_to_window_w,z-(space_to_window_h+window_h), braces = braces);
    translate([space_to_window_w+window_w,0,0]) verticalStruts(space_to_window_w,space_to_window_h+window_h, braces = braces);
    translate([space_to_window_w/2+window_w+space_to_window_w,0,space_to_window_h+window_h]) verticalStruts(space_to_window_w/2,door_h-(space_to_window_h+window_h), braces = braces);
    translate([space_to_window_w/2+window_w+space_to_window_w,0,door_h]) verticalStruts(x-(space_to_window_w/2+window_w+space_to_window_w),z-door_h, braces = braces);
    translate([space_to_window_w+window_w+space_to_window_w+door_w,0,0]) verticalStruts(x-(space_to_window_w+window_w+space_to_window_w+door_w),door_h, braces = braces);
}


shedBase(shed_length, shed_width, number_x=4,number_y=1, braces=1);
translate([0,0,base_timber]) floorMembrane(shed_length, shed_width, thickness = 1);
translate([0,0,base_timber+1]) shedLowerFloor(shed_length, shed_width);
translate([0,shed_width-base_timber,base_timber+1+5.5])  backWallStruts(shed_length, shed_front_back, 5);
translate([0,0,base_timber+1+5.5])  frontWallStruts(shed_length,shed_front_height, space_to_window_w=1830/2, space_to_window_h=shed_front_height-610-610, window_w=1830, window_h=610, door_w=870, , door_h=2030);

//shedBaseSection(shed_length/6,shed_width, braces = 1);
