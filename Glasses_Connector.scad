// Glasses connector
//
// Object is modelled for specific glasses.
// Adjust the xyshape array for other shapes.
// WARNING: this file is WIP and should not yet be used
//

use <Helper.scad>;

$fn=32;


// Render object with example values when run standalone
Glasses_Connector();


module Glasses_Connector()
{

    ///////////////////// internal variables ///////////////////////

    // shape definition of the glasses arm
    xyshape=[
        [0,0.6],
        [4,1],
        [14,1.5],
        [30,0.5],
        [30,2.5],
        [14,3.8],
        [0,4],
    ];

    ///////////////////// calculate variables //////////////////////


    //////////////////// parts to be rendered //////////////////////

    object();
    

    //////////////////////////// modules ///////////////////////////
    
    // main object
    module object()
    {
        difference(){
            difference(){
                linear_extrude(height=10)
                    offset(r=1.2)
                        polygon(xyshape);
                union(){
                    linear_extrude(height=8)
                        polygon(xyshape);
                    translate([7.5,-1,0])
                        cube([15,7,5]);
                }
            }

            // front and back cutoff
            translate([-2,-1,0])
                cube([2,7,10]);
                translate([30,-1,0])
                    cube([1.2,5,10]);
            
            // holes
            translate([4,6,4.2-0.3])
                rotate([90,0,0])
                    cylinder(d=2.2,h=7);

            translate([26,6,4.4+0.2])
                rotate([90,0,0])
                    cylinder(d=2.2,h=7);
        }
        translate([-21-1,-0.4,8])
            cube([21+1,3.6,2]);
    }
}
