// Glasses connector
//
// Object is modelled for specific glasses.
// Adjust glasses_connector_shape for other shapes.
//

use <Helper.scad>;

$fn=32;


// Render object with example values when run standalone
Glasses_Connector(glasses_connector_shape=[[0,0.6],
                                           [4,1],
                                           [14,1.5],
                                           [30,0.5],
                                           [30,2.5],
                                           [14,3.8],
                                           [0,4]],
                  glasses_connector_height1=4,
                  glasses_connector_height2=3.3,
                  glasses_connector_length=30,
                  glasses_connector_screw_diameter=2,
                  wall=0.5,
                  output=true
                  );


module Glasses_Connector(glasses_connector_shape,
                         glasses_connector_height1,
                         glasses_connector_height2,
                         glasses_connector_length,
                         glasses_connector_screw_diameter,
                         wall,
                         output=true)
{

    ///////////////////// internal variables ///////////////////////


    ///////////////////// calculated variables //////////////////////
    glasses_connector_height        = max(glasses_connector_height1,
                                          glasses_connector_height2);
    glasses_connector_case_height   = glasses_connector_height
                                      + glasses_connector_screw_diameter
                                      + 2 * wall;
    glasses_connector_case_width    = max(glasses_connector_shape[1])+2*wall;
    screw_distance                  = glasses_connector_length
                                      - glasses_connector_screw_diameter
                                      - 2 * wall;
    cutout_length                   = screw_distance
                                      - glasses_connector_screw_diameter
                                      - 2 * wall;
    cutout_height                   = glasses_connector_case_height
                                      - glasses_connector_height
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
            linear_extrude(height=glasses_connector_case_height)
                offset(r=wall)
                    polygon(glasses_connector_shape);

            union()
            {
                // main connector cutout
                translate([0,0,wall])
                    linear_extrude(height=glasses_connector_case_height-wall)
                        polygon(glasses_connector_shape);
                
                // front/back connector cutoff
                for(offset_x=[-wall,glasses_connector_length])
                {
                    translate([offset_x,0,0])
                        cube([wall,
                              glasses_connector_case_width,
                              glasses_connector_case_height]);
                }    
                
                // front screw holes
                    translate([glasses_connector_screw_diameter/2+wall,
                               0,
                               glasses_connector_screw_diameter/2
                              +glasses_connector_height1 + wall])
                        rotate([270,0,0])
                            cylinder(d=glasses_connector_screw_diameter,
                                     h=glasses_connector_case_width+2*wall);
                // back screw holes
                    translate([glasses_connector_length
                              -glasses_connector_screw_diameter/2-wall,
                               0,
                               glasses_connector_screw_diameter/2
                              +glasses_connector_height2 + wall])
                        rotate([270,0,0])
                            cylinder(d=glasses_connector_screw_diameter,
                                     h=glasses_connector_case_width+2*wall);
                
                
                // middle cutout
                translate([glasses_connector_screw_diameter+2*wall,
                            0,
                            glasses_connector_height+wall])
                    cube([cutout_length,
                          glasses_connector_case_width,
                          cutout_height]);
            }
        }
    }
    
    
    module output()
    {
        echo("Glasses connector height",glasses_connector_height);
        echo("Glasses connector case height",glasses_connector_case_height);
        echo("Glasses connector case width",glasses_connector_case_width);
        echo("Screw distance", screw_distance);
        echo("Cutout height", cutout_height);
    }
}
