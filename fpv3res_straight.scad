/*

Tranquility F3RES thermal soarer.

Copyright (C) 2018 Andy Little

 This program is free software: you can redistribute it and/or modify
 it under the terms of the GNU General Public License as published by
 the Free Software Foundation, either version 3 of the License or
 (at your option) any later version.

 This program is distributed in the hope that it will be useful,
 but WITHOUT ANY WARRANTY; without even the implied warranty of
 MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
 GNU General Public License for more details.

 You should have received a copy of the GNU General Public License
 along with this program. If not, see http://www.gnu.org/licenses./
*/

fuselage_width_ratio = 0.4;
fuselage_height_ratio = 0.65;

wing_incidence = 2.5;
tail_incidence = 1.5;

tail_length = 720;
wing_stretch = 840/840;

tail_stretch = 175/175;

wing_height = 8;

module measurement(dist, pos)
{
   translate(pos){
     translate([20,0,0]){
        rotate([0,-90,0]){
            cylinder(r1 = 5, r2= 1, h = 20);
        }
     }
     translate([- (dist +20),0,0]){
        rotate([0,90,0]){
            cylinder(r1 = 5, r2= 1, h = 20);
        }
     }
   }
}

module fuselage_pod()
{
   difference(){
      union(){
         scale([8.5,fuselage_width_ratio,fuselage_height_ratio]){
            sphere(d = 65, $fn = 50);
         }
         translate([-00,0,0]){
            scale ( [1,fuselage_width_ratio,fuselage_height_ratio]){
               rotate([0,-90,0]){
                  cylinder( r1=7,r2= 7, h = tail_length+85, $fn = 50);
               }
            }
         }
      }
  }
}

module tail_boom(){
  translate([-(tail_length+120),0,-10]){
     rotate([0,90,0]){
       difference(){
         cylinder (d = 8, h = tail_length, $fn = 20);
         translate([0,0,-1]){
            cylinder (d = 7, h = tail_length+2, $fn = 20);
         }
      }
    }
  }
}

module pylon_blank(){
   translate([-pylon_pos,0,-1]){
      linear_extrude(height = wing_height -2 ){
         scale([90,40,1]){
            rotate([0,0,180]){
               NACA66021();
            }
         }
      }
   }
}

module pylon(){
   pylon_blank();
}

module wing(){
   polyhedral_angle0 = 1.5;
   polyhedral_angle1 = 9;
   polyhedral_angle2 = 12;

   translate([-25,0,wing_height]){

      rotate([-polyhedral_angle0,0,0]){
         rotate([0,0,180]){
             import("inner.stl", convexity = 10);
         }
         translate([0,-500,0]){
            rotate([-polyhedral_angle1,0,0]){
               rotate([0,0,180]){
                 import("mid.stl", convexity = 10);
               }
               translate([0,-400,0]){
                  rotate([-polyhedral_angle2,0,0]){
                     scale([1,wing_stretch,1]){
                        rotate([0,0,180]){
                          import("outer.stl", convexity = 10);
       
                        }
                     }
                  }
               }
            }
         }
      }
   }
}

module tailplane_half(){
 
   size = 0.85;
   
   translate([-85,0,-30]){
      rotate([180,0,0]){
         scale([size,size,size]){
         import("tail.stl", convexity = 10);
         }
      }
   }
}

module fin()
{
   translate([30,0,0]){
      translate([0,0,-9]){
         rotate([90,0,0]){
            scale([0.9,0.55,1]){
               import("fin.stl", convexity = 10);
            }
         }
      }
      translate([0,0,-9]){
         rotate([-90,0,0]){
            scale([0.9,0.45,1]){
               import("fin.stl", convexity = 10);
            }
         }
      }
   }
}

module tailplane()
{
   tailplane_half();
   mirror([0,1,0]){
     tailplane_half();
   }
   fin();
}

module tail()
{
   translate([-(tail_length+59),0,0]){
      rotate([0,-tail_incidence,0]){
         rotate([0,0,180]){
            tailplane();
         }
      }
   }
}

wing_color = [0.7,0.6,1];
fuse_color = [1,0.6,0.7];
   module whole_plane() {
      translate([80,0,0]){
         color(fuse_color){
            translate([-30,0,-10]){
               fuselage_pod();
            }
         }
         color(wing_color){
            translate([-4,0,0]){
               rotate([0,-wing_incidence,0]){
                  wing();
                  mirror([0,1,0]){wing();}
               }
            }
         }
         color(wing_color){
            tail();
         }
      }
   }

   whole_plane();
 











