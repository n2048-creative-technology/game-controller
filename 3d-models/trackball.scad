$fn=64;


R = 60; // radious of the trackball
r = 4; // radious of roller

// trackball
sphere(R);


// rollers
angle = 15;
rotate([0,angle]) translate([R+r,0]) rotate([90,180-angle]) bar();
rotate([0,-angle]) translate(-[R+r,0]) rotate([90,180+angle]) bar();
rotate(90){
rotate([0,angle]) translate([R+r,0]) rotate([90,180-angle]) bar();
rotate([0,-angle]) translate(-[R+r,0]) rotate([90,180+angle]) bar();
}

module bar(){
    translate([0,0,-R/1.6]) {
        bearing();
        bearing_base();       
    }
    
    translate([0,0,R/1.6]) {
        bearing();
        bearing_base();       
    }
    
    cylinder(h=2*R/1.6+10, r=r, center=true);
    
    
}

module bearing(){
        linear_extrude(7,center=true) difference() {
            circle(d=22);
            circle(d=8);
        }
}



module bearing_base(){
        linear_extrude(11,center=true) {
            difference() {
            hull() {
                circle(d=25);
                translate([0,13]) square([25,1],center=true);
            }
            circle(d=22);
        }
        translate([0,13]) square([35,3],center=true);
    }
}
