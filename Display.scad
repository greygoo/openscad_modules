// Display holding module
//
// Object is centered and zeroed with screen on the x axis

use <Helper.scad>;

$fn=32;


// Render object with example values when run standalone
Display(
    screen_width        = 7,
    screen_height       = 5,
    screen_offset_x     = 0.2,
    screen_offset_y     = 0,
    display_length      = 7,
    display_width       = 15,
    display_height      = 11,
    backplate_length    = 3.2,
    backplate_width     = 18.4,
    wall                = 0.5,
    foot                = true,
    ground_distance     = 12,
    holes               = true,
    hole_distance       = 6,
    hole_diameter       = 3,
    screw_diameter      = 1.5,
    render_dimensions   = true
);


module Display(screen_width,
               screen_height,
               screen_offset_x,
               screen_offset_y,
               display_length,
               display_width,
               display_height,
               backplate_length,
               backplate_width,
               wall,
               foot,
               ground_distance,
               holes,
               hole_distance,
               hole_diameter,
               screw_diameter,
               render_dimensions){


    ///////////////////// calculate variables //////////////////////
    display_case_length     = display_length    + wall;
    display_case_width      = display_width     + 2 * wall;
    display_case_height     = display_height    + wall;
    backplate_case_length   = backplate_length  + 2 * wall;
    backplate_case_width    = backplate_width   + 2 * wall;
    backplate_case_height   = display_case_height;
    case_length = display_length  + backplate_length + 2 * wall;
    case_width  = display_width   + backplate_width  + 2 * wall;
    case_height = display_case_height;
    hole_offset_x   = - case_length;
    hole_offset_y   = - hole_distance/2 - screen_offset_x;
    hole_offset_z   = - ground_distance + hole_diameter/2 + 2 * wall;



    //////////////////// parts to be rendered //////////////////////
    
    // render object
    color("lightgrey") object();
                      
    // render dimensions if enabled
    if(render_dimensions) color("red") dimensions();
    
    // render foot with optional holes if enabled
    if(foot) color("grey") foot();
    
    
    
    //////////////////////////// modules ///////////////////////////

    // object itself
    module object(){
        difference() {
            
            // basic shape
            union(){
                // offset to always center on the screen
                translate([0,-screen_offset_x,-screen_offset_y]){
                    // display container
                    translate([-display_case_length/2+wall,0,-wall/2])
                        cube([display_case_length,
                              display_case_width,
                              display_case_height], center=true);
                    // backplate container
                    translate([-(backplate_length/2+display_length),0,-wall/2])
                        cube([backplate_case_length,
                              backplate_case_width,
                              backplate_case_height], center=true);
                }
            }
            
            // cutouts
            union(){
                // screen cutout
                translate([wall/2,0,0])
                    cube([wall,screen_width,screen_height], center=true);
                
                // opening above screen
                cutout_height=(display_height-screen_height)/2
                              -screen_offset_y;
                
                translate([wall/2,
                           0,
                           (display_height-cutout_height)/2-screen_offset_y])
                    cube([wall,screen_width,cutout_height], center=true);
            
                // adjust screen offsets
                translate([0,-screen_offset_x,-screen_offset_y]){
                    
                    // display cutout
                    translate([-display_length/2,0,0])
                        cube([display_length,
                              display_width,
                              display_height],center=true);
                    
                    // backplate cutout
                    translate([-(backplate_length/2+display_length),0,0])
                        cube([backplate_length,
                              backplate_width,
                              display_height], center=true);
                    
                    // cable cutout
                    //translate([-backplate_length-display_length-wall/2,
                    //           0,
                    //           (display_height-wall)/2])
                    //    cube([wall,backplate_width,wall],center=true);
                }
            }
        }
    }

    module dimensions(){
        dist = 2; // space between spacers
        
        color("black") {
            translate([0,0,display_height/2+dist]){
                translate([0,backplate_width/2,0]){
                    translate([-display_length,,0])
                        Spacer(l=display_length,t="display_length");
                    translate([-display_length-backplate_length,dist,0])
                        Spacer(l=backplate_length,t="backplate_length");
                }
                
                translate([0,-screen_width/2,0])
                    rotate([0,0,90])
                        Spacer(l=screen_width,t="screen width");
                
                translate([-dist,-display_width/2-screen_offset_x,0])
                    rotate([0,0,90])
                        Spacer(l=display_width,t="display width");
                
                translate([-3*dist,-backplate_width/2-screen_offset_x,0])
                    rotate([0,0,90])
                        Spacer(l=backplate_width,t="backplate width");                
            }
            
            translate([0,backplate_width/2+dist,-screen_offset_y])
                rotate([0,90,0])
                    translate([-display_height/2,0,0])
                        Spacer(l=display_height,t="display height");

            translate([0,backplate_width/2+2*dist,0])
                rotate([0,90,0])
                    translate([-screen_height/2,0,0])
                        Spacer(l=screen_height,t="screen height");            
            
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
                         -display_height/2
                         -wall
                         -screen_offset_y,
                   z=-ground_distance){
                object();
            }
        }
    }


    module holes()
    {
        // make two holes for bars to mount object on
        mkhole(diameter=hole_diameter,
               depth=case_length,
               plane="yz",
               x=wall-case_length,
               y=hole_offset_y,
               z=hole_offset_z);
        mkhole(diameter=hole_diameter,
               depth=case_length,
               plane="yz",
               x=wall-case_length,
               y=-hole_offset_y,
               z=hole_offset_z);
        
        // make a small hole cutting the mount holes to fixate with screws
        mkhole(diameter=screw_diameter,
                depth=display_case_width,
                plane="xz",
                x=-display_length/2,
                y=-display_case_width/2-screen_offset_x,
                z=hole_offset_z);
    }
}