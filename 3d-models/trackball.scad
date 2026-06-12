$fn=64;


R = 60; // radious of the trackball
r = 4; // radious of roller

// trackball
% sphere(R);


// rollers
angle = 15;

difference(){
translate([0,0,-35])
linear_extrude(5) difference() {
offset(5) offset(-5)    hull() projection(cut=true) translate([0,0,30])
for(i=[0:90:360])
rotate([0,angle,i]) translate([R+r,0]) rotate([90,180-angle]) bar();


for(i=[0:90:360]) rotate(i) {
translate([63,28]) circle(d=4.2);
translate([63,-28]) circle(d=4.2);
translate([115,0]) circle(d=100);
translate([60,60]) circle(d=4.2);
}


}
sphere(R+2);

}

difference(){
    for(i=[0:90:360])
rotate([0,angle,i]) translate([R+r,0]) rotate([90,180-angle]) bar();

sphere(R+2);

}

module bar(){
    translate([0,0,-R/1.4]) {
       % bearing();
        bearing_base();       
    }
    
    translate([0,0,R/1.4]) {
      %  bearing();
        mirror([0,0,1]) bearing_base();       
    }
    
   % cylinder(h=2*R/1.6+10, r=r, center=true);    
    
}

module bearing(){
        linear_extrude(7,center=true) difference() {
            circle(d=22);
            circle(d=8);
        }
}



module bearing_base(){
        linear_extrude(12,center=true) {
            difference() {
            hull() {
                circle(d=30);
                translate([0,13]) square([25,1],center=true);
            }
            circle(d=22);
            translate([0,-15]) square([10,30],center=true);
        }
        translate([0,13]) square([35,3],center=true);
    }


translate([0,0,-6])        linear_extrude(2,center=true) {
            difference() {
            hull() {
                circle(d=30);
                translate([0,13]) square([25,1],center=true);
            }
            circle(d=20);
            translate([0,-15]) square([10,30],center=true);
        }
        translate([0,13]) square([35,3],center=true);
    }

}
