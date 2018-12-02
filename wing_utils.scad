

//create a wing shape module from an stl file
// stl_file_name is a string of file name
// useage:  wing_shape("my_wing.stl");
module wing_shape(stl_file_name)
{
   import(stl_file_name,convexity = 5);
}

//create a plan view of the wing
// where children is a wing_shape
// can be exported to dxf
//useage wing_plan() {
//      wing_shape("my_wing.stl");
//}
module wing_plan()
{
   projection(cut = false){
      children();
   }
}

// create the shape of the upper surface , with a flat underside - height below
// where ckildren is a wing_shape
module wing_upper_surface_shape(height1)
{
   hull(){
      translate([0,0,-height1]){
         linear_extrude(height = 1 ){
            wing_plan() children();
         }
      }
      children();
   }
}

// create the shape of the lower surface , with a flat top side - height above
// where ckildren is a wing_shape
module wing_lower_surface_shape(height1)
{
   hull(){
      translate([0,0,height1-1]){
         linear_extrude(height = 1 ){
            wing_plan() children();
         }
      }
      children();
   }
}

// create the mould of the lower surface , with a flat under side - height above
// where children is a wing_shape
module wing_lower_surface_mould( height1){
   difference(){
      wing_upper_surface_shape(height1){
         children();
      }
       wing_lower_surface_shape(height1){
         children();
      }
   }
}

// create the mould of the upperr surface , with a flat under side - height above
// where children is a wing_shape
module wing_upper_surface_mould( height1){
   difference(){
      wing_lower_surface_shape(height1){
         children();
      }
      wing_upper_surface_shape(height1){
         children();
      }
   }
}

// create an upper skin of thickness
// Note this just subtracts the uppe skin offset by simple vertical thickness
// The le can be corrected somewhat by specifying xoffset which moves the subtracted part iin x
// the tip can similarly be corrected using yoffset
// doesnt attempt to conform to curve, so will be less accurate the less the upper surface is level at that point
// child is wing shape
module wing_upper_skin(thickness, xoffset = 0, yoffset = 0){
    difference(){
       wing_upper_surface_shape(thickness + 1){ children();}
       translate([xoffset,-yoffset,-thickness]){
          wing_upper_surface_shape(thickness + 1){ children();}
       }
    }
}

// create an lower skin of thickness
// Note this just subtracts the lower skin offset by simple vertical thickness
// The le can be corrected somewhat by specifying xoffset which moves the subtracted part iin x
// the tip can similarly be corrected using yoffset
// doesnt attempt to conform to curve, so will be less accurate the less the upper surface is level at that point
// child is wing shape
module wing_lower_skin(thickness, xoffset = 0, yoffset = 0){
    difference(){
       wing_lower_surface_shape(thickness + 1){ children();}
              translate([xoffset,-yoffset,thickness]){
          wing_lower_surface_shape(thickness + 1){ children();}
       }
    }
}













