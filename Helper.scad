// collection of helper functions and modules

$fn=32;


/////////////////////// Functions ///////////////////////////
function defined(variable) = str(variable) != "undef"; 



/////////////////////// Objects /////////////////////////////

// creates a hole on with given depth and diameter 
// with its center at x,y,z 
// of the given plane
module mkhole(diameter,depth,plane="xy",x=0,y=0,z=0)
{
        if(plane=="xy")
            translate([x,y,z])
                translate([0,0,depth/2])
                    cylinder(d=diameter,h=depth, center=true);
      
        if(plane=="xz")
            translate([x,y,z])
                translate([0,depth/2,0])
                    rotate([90,0,0])
                        cylinder(d=diameter,h=depth, center=true);
        
        if(plane=="yz")
            translate([x,y,z])
                translate([depth/2,0,0])
                    rotate([0,90,0])
                        cylinder(d=diameter,h=depth, center=true);
}


// create a foot for objects starting at z with given height
module mkfoot(height,z){
    translate([0,0,z])
        linear_extrude(height=height)
            projection() children();
}


// create a length indicator with text - l=length, t=text
module Spacer(l,t){
    // move with beginning to zero on x axis
    translate([l/2,0,0]){
        linear_extrude(height=0.1){
            // create spacer line
            square([l,0.1],center=true);

            // create end caps
            translate([-l/2,0,0])
                square([0.1,1],center=true);
            translate([l/2,0,0])
                square([0.1,1],center=true);

            // add text
            text(text = str(t,": ",l),
                 size=1,
                 halign="center",
                 valign="bottom");
        }
    }
}
