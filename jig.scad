
wing_height = 70;
sep = 10;

jig_color = [0.5,0.3,0.2];
wing_color = [0.4,0.4,0.6];

color(jig_color){
import("inner_panel_jig.stl",convexity= 5);
}
color(wing_color){
translate([0,0,wing_height]){
  import("inner.stl",convexity = 5);
}
}

translate([0,500 + sep,0]){
color(jig_color){
 import("mid_panel_jig.stl",convexity= 5);
}
color(wing_color){
   translate([0,0,wing_height]){
     import("mid.stl",convexity = 5);
   }
}
}
translate([0,900 + 2 * sep,0]){
color(jig_color){
 import("outer_panel_jig.stl",convexity= 5);
}
color(wing_color){
  translate([0,0,wing_height]){
     import("outer.stl",convexity = 5);
   }
}
}