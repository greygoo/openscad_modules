use <Helper.scad>;

$fn=32;

// render with example values
Endcaps(length=4,
        wall=0.8,
        hole_distance=6,
        hole_diameter=3,
        screw_diameter=1.5);


module Endcaps(length,
               wall,
               hole_distance,
               hole_diameter,
               screw_diameter)
{
    
    
    //////////////// Variables ////////////////////////
    height  = hole_diameter + 2 * wall;
    width   = hole_distance + hole_diameter + 4 * wall;
    
    
    //////////////// Rendering ////////////////////////
    object();
    
    
    //////////////// Modules //////////////////////////
    module object()
    {
        difference(){
            cube([length,width,height], center = true);
            holes();
        }
    }

    module holes(){
        // holes for rods
        for (y=[-hole_distance/2,hole_distance/2]){
            mkhole(diameter=hole_diameter,
                   depth=length,
                   plane="yz",
                   x=-length/2,
                   y=y);
        }
        
        // holes for screws
        for (y=[-width/2,width/2-3*wall]){
            #mkhole(diameter=screw_diameter,
                   depth=3*wall,
                   plane="xz",
                   y=y);
        }
    }
}