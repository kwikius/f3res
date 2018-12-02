
include <wing_utils.scad>

panel_dihedral = [1.35,9,12];

panel_halfspan =[500,400,107];

panel_chord = [210,190,130,100];
panel_offset = [0.0,6.7,26.67,40];

show_main_spar = true;
show_wing_joining_pegs = true;
show_panel = [true,false, false];

// y pos of centre, thickness of rib, angle rel straight fore and aft
rib_list = [
[ 3.01,6,0],
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
[ 499.19,1.6,0]
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



//rotated
//module panel0_lower_skin_0_8()
//{
//   import("panel0_lower_skin_0.8.stl",convexity = 10);
//}

//rotated
//module panel0_upper_skin_0_8()
//{
//   import("panel0_upper_skin_0.8.stl",convexity = 10);
//}

module wing_upper_skin(thickness){
   difference(){
      panel0();
      translate([0,0,-thickness]){
         panel0();
      }
   }
}

module wing_lower_skin(thickness){
   difference(){
      panel0();
      translate([0,0,thickness]){
         panel0();
      }
   }
}

module wing_unskinned(thickness){

   difference(){
      panel0();
      union(){
         wing_lower_skin(thickness);
         wing_upper_skin(thickness);
      }
   }
}

module main_spar()
{
   joiner_pos = 0.2312 * panel_chord[0];
   joiner_radius = 5;
   web_thickness = 1.6;

   rotate([-panel_dihedral[0],0,0]){
      intersection(){
         union(){
            translate([joiner_pos,panel_halfspan[0], 5]){
               rotate([90,0,0]){
                  cylinder(r = joiner_radius, h = panel_halfspan[0] , $fn = 20);
               }
            }
            translate([joiner_pos -web_thickness/2,-1,-10]){
               cube([web_thickness,panel_halfspan[0]+2,30]);
            }
         }
         rotate([panel_dihedral[0],0,0]){
            wing_unskinned(0.8);
         }
      }
   }
}

// rotated
//module panel0_unskinned_0_8()
//{
//   import("panel0_unskinned_0_8.stl", convexity = 10);
//}

module rib_blanks()
{
   for ( i = [0:len(rib_list)-1]){
      pos = rib_list[i][0];
      rib_thickness = rib_list[i][1];
      // ignore angle for now
      translate( [0,pos-rib_thickness/2,-10]){
         cube([220,rib_thickness,25]);
      }
   }
}

module upper_rib_cap_blanks()
{
   cap_width = 6;
   for ( i = [0:len(rib_list)-1]){
      pos = rib_list[i][0];
      //rib_thickness = rib_list[i][1];
      
      // ignore angle for now
      translate( [64,pos-cap_width/2,-10]){
         cube([220 - 65,cap_width,25]);
      }
   }
}

module lower_rib_cap_blanks()
{
   cap_width = 6;
   for ( i = [0:len(rib_list)-1]){
      pos = rib_list[i][0];
      translate( [54,pos-cap_width/2,-10]){
         cube([220 - 55,cap_width,25]);
      }
   }
}

module wing_ribs_stl()
{
   import("wing_ribs.stl",convexity = 10);
}

module upper_skin(){
   difference(){
      //panel0_lower_skin_0_8();
      wing_upper_skin(0.8);
      union(){
         translate([65,-10,-10]){
            cube([200,520,30]);
         }
      rotate([0,0,-0.7]){
         translate([-1,-10,-10]){
            cube([7,520,30]);
         }
   }
      }
   }
   intersection(){
      upper_rib_cap_blanks();
      wing_upper_skin(0.8);
   };
}


module wing_ribs(){
   intersection(){
      rib_blanks();
      wing_unskinned(0.8);
   }
}




module lower_skin(){
   difference(){
      wing_lower_skin(0.8);
      union(){
         translate([55,-10,-10]){
            cube([200,520,30]);
         }
         rotate([0,0,-0.7]){
            translate([-1,-10,-10]){
               cube([7,520,30]);
            }
         }
      }
   }
   intersection(){
      lower_rib_cap_blanks();
      wing_lower_skin(0.8);
   }
}

wing_ribs();
main_spar();
upper_skin();
lower_skin();






















