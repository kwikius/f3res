
include <wing_utils.scad>

panel_dihedral = [1.35,9,12];

panel_halfspan =[500,400,115];

show_main_spar = true;
show_wing_joining_pegs = true;
show_panel = [true,false, false];

// y pos of centre, thickness of rib, angle rel straight fore and aft
rib_list = [
[ 3,6,0],
[ 25,3,0],
[ 60,1.6,0],
[ 100,1.6,0],
[ 150,1.6,0],
[ 200,1.6,0],
[ 250,1.6,0],
[ 300,1.6,0],
[ 350,1.6,0],
[ 400,1.6,0],
[ 450,1.6,0],
[ 499.2,1.6,0]
];

module panel0()
{
   import("inner.stl", convexity = 10);
}

module panel1()
{
   import("mid.stl", convexity = 10);
}

module panel2()
{
      import("outer.stl", convexity = 10);
}

module wing(){

   rotate([panel_dihedral[0],0,0]){
      if ( show_panel[0] ){
       panel0();
      }
      translate([0,panel_halfspan[0],0]){
         rotate([panel_dihedral[1],0,0]){
            if (show_panel[1]){
              panel1();
            }
            translate([0,panel_halfspan[1],0]){
               rotate([panel_dihedral[2],0,0]){
                  if(show_panel[2]){
                     panel2();
                  }
               }
            }
         }
      }
   }
}


module main_spar()
{
   joiner_pos = 0.2312 * 210;
   joiner_radius = 5;
   joiner_length = 1000;
   intersection(){
      translate([joiner_pos,panel_halfspan[0], 5]){
         rotate([90,0,0]){
            cylinder(r = joiner_radius, h = panel_halfspan[0] , $fn = 20);
         }
      }
     translate([0,0,0.8]){
        wing();
     }
   }
    translate([joiner_pos,10, 5]){
         rotate([90,0,0]){
            cylinder(r = joiner_radius, h = 20 , $fn = 20);
         }
      }
}

module front_joiner()
{
   joiner_pos = 0.05 * 210;
   joiner_radius = 1.5;
   joiner_length = 20;
   translate([joiner_pos,joiner_length/ 2, 1]){
      rotate([90,0,0]){
         cylinder(r = joiner_radius, h = joiner_length, $fn = 10);
      }
   }
}

module rear_joiner()
{
   joiner_pos = 0.8 * 210;
   joiner_radius = 1.5;
   joiner_length = 20;
   translate([joiner_pos,joiner_length/ 2, 2.2]){
      rotate([90,0,0]){
         cylinder(r = joiner_radius, h = joiner_length, $fn = 10);
      }
   }
}

module wing_lower_skin(){
   difference(){
      panel0();
      union(){
      translate([0,0.1,0.8]){
         panel0();
      }
      translate([0,-0.10,0.8]){
         panel0();
      }
      }
   }
}

module wing_upper_skin(){
   difference(){
      panel0();
      union(){
      translate([0,0.1,-0.8]){
         panel0();
      }
      translate([0,-0.10,-0.8]){
         panel0();
      }
      }
   }
}
module wing_unskinned(){
   difference(){
   panel0();
   union(){
   wing_lower_skin();
   wing_upper_skin();
   }
   }
}

module wing_with_ribs(){
 rotate([panel_dihedral[0],0,0]){
intersection(){
   difference(){
      wing_unskinned();
      rotate([-panel_dihedral[0],0,0]){
         union() {
           main_spar();
         }
      }
   }
   for ( i = [0:len(rib_list)-1]){
      pos = rib_list[i][0];
      rib_thickness = rib_list[i][1];
      // ignore angle for now
      translate( [0,pos-rib_thickness/2,-10]){
         cube([220,rib_thickness,25]);
      }
   }
}

 rotate([-panel_dihedral[0],0,0]){
         union() {
           main_spar();
         }
      }

wing_lower_skin();
}
}

wing_with_ribs();
mirror([0,1,0])
{
wing_with_ribs();
}

//%panel0();











