#include "realskies.inc"
#include "functions.inc" 
#include "colors.inc"
#include "glass.inc"
#include "golds.inc"
#include "metals.inc"
#include "stones.inc"
#include "woods.inc"

global_settings {
    radiosity {}
    max_trace_level 25
}

camera {
    location  <9, 3, 5>
    look_at   <0, 1.5, 0>
}

// create a regular point light source

light_source {<7, 3, 0>*1.1 1.0}


sky_sphere { sky_realsky_07 translate -0.05*y}


plane {
    y, 0.0
    material {
        texture {
            pigment {
                color rgb <0.8, 0.9, 1>
            }
            finish {
                ambient 0.0
                diffuse 0.0

                reflection {
                    0.2, 1.0
                    fresnel on
                }

                specular 0.4
                roughness 0.003
            }
            normal {
                function {
                    f_ridged_mf(x/9, y, z/5, 0.1, 3.0, 7, 0.7, 0.7, 2)
                } 0.6
                turbulence 2.5
                scale 0.13
            }
        }
        interior { ior 1.3 }
    }
}

#macro sierpinski (s, base_center, recursion_depth)
    #if (recursion_depth > 0)
        union {
            sierpinski(s / 2, base_center + s/2*y,      recursion_depth - 1) // Top
            sierpinski(s / 2, base_center - s/2*(x+z),  recursion_depth - 1) // Base +x +z corner
            sierpinski(s / 2, base_center - s/2*(x-z),  recursion_depth - 1) // Base +x -z corner
            sierpinski(s / 2, base_center - s/2*(-x+z), recursion_depth - 1) // Base -x +z corner
            sierpinski(s / 2, base_center - s/2*(-x-z), recursion_depth - 1) // Base -x -z corner
        }
    #else
        difference{
            box { <1,1,1>, <-1,0,-1> }
            plane{ x-y,  -sqrt(2)/2}
            plane{ -x-y, -sqrt(2)/2}
            plane{ z-y,  -sqrt(2)/2}
            plane{ -z-y, -sqrt(2)/2}
            scale s*1.5
            translate base_center
        }
    #end
#end

object {
    sierpinski(4, <0, 0.5, 0>, 3)
    scale <0.8, 1, 0.8>
    texture { T_Copper_4D }
}
