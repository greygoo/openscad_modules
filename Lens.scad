// Lens holding module
//
// Object is centered and zeroed with lens center on the x axis

use <Helper.scad>;

$fn=32;


// Render object with example values when run standalone
Lens(lens_diameter   = 17,
     lens_thickness  = 3,
     wall            = 0.5,
     ground_distance = 20,
     holes           = true,
     hole_distance   = 6,
     hole_diameter   = 3,
     screw_diameter  = 1.5,
     foot            = true,
     render_dimensions      = true);


module Lens(lens_diameter,
            lens_thickness,
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
    lens_case_length     = lens_thickness;
    lens_case_width      = lens_diameter + 2 * wall;
    lens_case_height     = lens_case_width;
    hole_offset_x   = - lens_case_length;
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
        difference(){
            // main frame cube
            cube([lens_thickness,
                  lens_diameter + 2*wall,
                  lens_diameter + 2*wall],center=true);
            union(){
                
                // bigger hole containing the les
                translate([wall/2,0,0])
                    rotate([0,90,0])
                        cylinder(d=lens_diameter,
                                 h=lens_thickness - wall + 0.1,
                                 center=true);
                
                // slightly smaller hole to provide rim holding the lens
                translate([-(lens_thickness - wall)/2,-0.1,0])
                    rotate([0,90,0])
                        cylinder(d=lens_diameter - 2*wall,
                                 h=wall + 0.1,
                                 center=true);
            }
        }
    }
    
    
    module holes()
    {
        // make two holes for bars to mount object on
        for(y=[-hole_offset_y,hole_offset_y])
        {
            mkhole(diameter=hole_diameter,
                   depth=lens_case_length+0.2,
                   plane="yz",
                   x=-lens_case_length/2-0.1,
                   y=y,
                   z=hole_offset_z);
        }
        
        // make a small hole cutting the mount holes to fixate with screws
        mkhole(diameter=screw_diameter,
                depth=lens_case_width,
                plane="xz",
                x=0,
                y=-lens_case_width/2,
                z=hole_offset_z);
    }
    
    
    module dimensions(){
        dist=2; // space between Spacers
        
        color("black"){
            translate([0,0,lens_diameter/2+wall+dist]){
                translate([-lens_thickness/2,lens_diameter/2+wall,0])
                    Spacer(l=lens_thickness,t="Lens thickness");
                
                rotate([0,0,90])
                    translate([-lens_diameter/2,0,0])
                        Spacer(l=lens_diameter,t="Lens diameter");
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
                         -lens_diameter/2
                         -wall,
                   z=-ground_distance){
                object();
            }
        }
    }
}