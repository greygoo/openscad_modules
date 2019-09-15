// Glasses connector
//
// Object is modelled for specific glasses.
// Adjust connector_shape for other shapes.
//

use <Helper.scad>;

$fn=32;


// Render object with example values when run standalone
Glasses_Connector(connector_shape=[[0,0.6],
                                           [4,1],
                                           [14,1.5],
                                           [30,0.5],
                                           [30,2.5],
                                           [14,3.8],
                                           [0,4]],
                  connector_height1=4,
                  connector_height2=3.3,
                  connector_length=30,
                  connector_screw_diameter=2,
                  connector_slider_height=2,
                  connector_slider_width=4,
                  wall=0.5,
                  output=true
                  );


module Glasses_Connector(connector_shape,
                         connector_height1,
                         connector_height2,
                         connector_length,
                         connector_screw_diameter,
                         connector_slider_height,
                         connector_slider_width,
                         wall,
                         output=true)
{

    ///////////////////// internal variables ///////////////////////


    ///////////////////// calculated variables //////////////////////
    connector_height        = max(connector_height1,
                                          connector_height2);
    connector_case_height   = connector_height
                                      + connector_screw_diameter
                                      + 2 * wall;
    connector_case_width    = max(connector_shape[1])+2*wall;
    screw_distance                  = connector_length
                                      - connector_screw_diameter
                                      - 2 * wall;
    cutout_length                   = screw_distance
                                      - connector_screw_diameter
                                      - 2 * wall;
    cutout_height                   = connector_case_height
                                      - connector_height
                                      - wall;

    //////////////////// parts to be rendered //////////////////////

    if(output) output();

    object();
    

    //////////////////////////// modules ///////////////////////////
    
    // main object
    module object(){
        difference()
        {
            // main connector shape
            linear_extrude(height=connector_case_height)
                offset(r=wall)
                    polygon(connector_shape);

            union()
            {
                // main connector cutout
                translate([0,0,wall])
                    linear_extrude(height=connector_case_height-wall)
                        polygon(connector_shape);
                
                // front/back connector cutoff
                for(offset_x=[-wall,connector_length])
                {
                    translate([offset_x,0,0])
                        cube([wall,
                              connector_case_width,
                              connector_case_height]);
                }    
                
                // front screw holes
                    translate([connector_screw_diameter/2+wall,
                               0,
                               connector_screw_diameter/2
                              +connector_height1 + wall])
                        rotate([270,0,0])
                            cylinder(d=connector_screw_diameter,
                                     h=connector_case_width+2*wall);
                // back screw holes
                    translate([connector_length
                              -connector_screw_diameter/2-wall,
                               0,
                               connector_screw_diameter/2
                              +connector_height2 + wall])
                        rotate([270,0,0])
                            cylinder(d=connector_screw_diameter,
                                     h=connector_case_width+2*wall);
                
                
                // middle cutout
                translate([connector_screw_diameter+2*wall,
                            0,
                            connector_height+wall])
                    cube([cutout_length,
                          connector_case_width,
                          cutout_height]);
            }
        }
    }
    
    module slider_case()
    {
        //cube([connector_case_width, glasses_connector_])
    }
    
    module output()
    {
        echo("Glasses connector height",connector_height);
        echo("Glasses connector case height",connector_case_height);
        echo("Glasses connector case width",connector_case_width);
        echo("Screw distance", screw_distance);
        echo("Cutout height", cutout_height);
    }
}
