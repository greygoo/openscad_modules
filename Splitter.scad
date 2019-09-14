// Splitter holding module
//
// Object is centered and zeroed with splitter center on the x axis

use <Helper.scad>;

$fn=32;


// Render object with example values when run standalone

Splitter(splitter_angle     = 45,
         splitter_width     = 15,
         splitter_height    = 12,
         splitter_thickness = 3,
         wall               = 0.5,
         ground_distance    = 12,
         holes              = true,
         hole_distance      = 6,
         hole_diameter      = 3,
         screw_diameter     = 1.5,
         foot               = true,
         render_dimensions  = true
         );


module Splitter(splitter_angle,
                splitter_width,
                splitter_height,
                splitter_thickness,
                wall,
                ground_distance,
                holes,
                hole_distance,
                hole_diameter,
                screw_diameter,
                foot,
                render_dimensions)
{

    ///////////////////// calculate variables //////////////////////
    splitter_length = splitter_width / sin(splitter_angle);
    splitter_depth  = splitter_length * cos(splitter_angle);
    splitter_case_length    = splitter_length + 2 * wall;
    splitter_case_depth     = splitter_case_length * cos(splitter_angle);
    splitter_case_width     = tan(splitter_angle) * splitter_case_depth;
    splitter_case_height    = splitter_height + 2 * wall;

    // calculate splitter case overhang in x and y direction
    splitter_helper_1           = splitter_thickness/tan(splitter_angle);
    splitter_case_overhang_y    = sin(splitter_angle) * splitter_helper_1;
    splitter_case_overhang_x    = sin(splitter_angle) * splitter_thickness;

    // calculate hole positions
    hole_offset_x   = - splitter_case_depth;
    hole_offset_y   = - hole_distance/2;
    hole_offset_z   = - ground_distance + hole_diameter/2 + 2 * wall;

    //////////////////// parts to be rendered //////////////////////

    // render object
    color("lightgrey") object();

    // render dimensions if enabled
    if(render_dimensions) color("red") dimensions();

    // render foot with optional holes if enabled
    if(foot) color("grey") foot();


    //////////////////////////// modules ///////////////////////////

    // main object
    module object(){                        
        rotate([0,0,270 + splitter_angle]){
            translate([splitter_thickness/2,0,0])
                difference(){
                    cube([splitter_thickness,
                          splitter_length,
                          splitter_height]+[0,2 * wall,2 * wall],
                          center=true);
                    cube([splitter_thickness,
                          splitter_length,
                          splitter_height],center=true);
            }
        }
    }


    module foot()
    {
        if(holes) {
            difference()
            {
                item();
                holes();
            }
        }
        else
        {
            item();
        }


        module item(){
            mkfoot(height=ground_distance
                         -splitter_case_height/2,
                   z=-ground_distance){
                object();
            }
        }
    }


    module holes()
    {
        // make two holes for bars to mount object on
        for(y=[-hole_offset_y,hole_offset_y])
        {
            mkhole(diameter=hole_diameter,
                   depth=splitter_case_length+0.2,
                   plane="yz",
                   x=-splitter_case_length/2-0.1,
                   y=y,
                   z=hole_offset_z);
        }

        // make a small hole cutting the mount holes to fixate with screws
        rotate([0,0,splitter_angle+90])
        translate([-splitter_thickness/2,0,0])
            mkhole(diameter=screw_diameter,
                    depth=splitter_case_length,
                    plane="xz",
                    x=0,
                    y=-splitter_case_length/2,
                    z=hole_offset_z);
    }


    module dimensions(){
        dist=2; // distance between spacers

        color("black"){
            translate([0,0,splitter_height/2+dist]){
                translate([-splitter_case_depth/2,-splitter_case_width/2,0])
                    Spacer(l=splitter_case_depth,t="Splitter case depth");

                translate([-splitter_depth/2,-splitter_width/2-dist,0])
                    Spacer(l=splitter_depth,t="Splitter depth");

                translate([splitter_case_depth/2,splitter_case_width/2+dist,0])
                    Spacer(l=splitter_case_overhang_x,t="Splitter case overhang_x");

                rotate([0,0,splitter_angle]){
                    translate([-splitter_length/2,dist,0])
                        Spacer(l=splitter_length,t="splitter_length");

                    translate([-splitter_case_length/2,0,0])
                        Spacer(l=splitter_case_length,t="splitter case length");

                    translate([-splitter_case_length/2,-splitter_thickness,0])
                        Spacer(l=splitter_helper_1,t="splitter_helper_1");
                }

                translate([splitter_depth/2+dist,0,0])
                    rotate([0,0,270])
                        translate([-splitter_width/2,0,0])
                            Spacer(l=splitter_width,t="splitter_width");

                translate([splitter_case_depth/2,0,0])
                    rotate([0,0,270])
                        translate([-splitter_case_width/2,0,0])
                            Spacer(l=splitter_case_width,t="splitter_case_width");

                translate([-splitter_case_depth/2,
                           -splitter_case_width/2-splitter_case_overhang_y,
                           0])
                    rotate([0,0,90])
                        Spacer(l=splitter_case_overhang_y,t="splitter_case_overhang_y");
            }
        }
    }
}