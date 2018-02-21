#define size 2.0
#define spirals 1.0
#define time iTime/4.0

#define blue vec4(172, 218, 205, 255)/255.0
#define pink vec4(240, 180, 180, 255)/255.0
#define white vec4(1,1,1,1);

void mainImage(out vec4 fragColor, in vec2 fragCoord) {
    
    vec2 uv = (fragCoord-iResolution.xy*.5) / iResolution.y; // UV 0 to 1
   
    float d = length(uv)*size; // Distance fom center
    float a = atan(uv.x, uv.y)/3.141592*spirals; // Angle from center
    
    float v = fract(d + a - time); // Spirals!
    
    fragColor =
        v<.25 ? blue :
    	v>.5 && v<.75 ? pink :
    	white;
}
