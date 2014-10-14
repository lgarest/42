

// simple geometry shader
// these lines enable the geometry shader support.
#version 120
#extension GL_EXT_geometry_shader4 : enable

varying in vec4 pos[3];
varying in vec4 posicio[3];
varying in vec3 normal[3];
float steps = 0.25;
uniform float time;
const float speed = 0.0;
void main( void )
{
	vec4 n;

	vec3 bariscentre = vec3(((pos[0]+pos[1]+pos[2])/3).xyz);
	bariscentre.x /= steps;
	if(fract(bariscentre.x) >= 0.5) bariscentre.x += 1.0;
	bariscentre.x -= fract(bariscentre.x);
	bariscentre.x *= steps;
	bariscentre.x += steps/2;
	bariscentre.y /= steps;
	if(fract(bariscentre.y) >= 0.5) bariscentre.y += 1.0;
	bariscentre.y -= fract(bariscentre.y);
	bariscentre.y *= steps;
	bariscentre.y += steps/2;
	bariscentre.z /= steps;
	if(fract(bariscentre.z) >= 0.5) bariscentre.z += 1.0;
	bariscentre.z -= fract(bariscentre.z);
	bariscentre.z *=steps;
	bariscentre.z -= steps/2;


vec4 R = vec4(1.0, 0.0, 0.0, 1.0);
vec4 G = vec4(0.0, 1.0, 0.0, 1.0);
vec4 B = vec4(0.0, 0.0, 1.0, 1.0);
vec4 W = vec4(1.0, 1.0, 1.0, 1.0);

for(int i = 0; i < 1;++i){
		n = vec4(0.0, -1.0, 0.0, 0.0);
		//1
		gl_FrontColor  = B;
		gl_Position    = vec4(bariscentre.x + 0,
 							  bariscentre.y + 0, 
							  bariscentre.z + steps, 1.0);
		gl_Position    = gl_ModelViewProjectionMatrix*
		(gl_Position+time*n*speed);
		//gl_TexCoord[0] = vec4(0.0, 0.0, 0.0, 0.0);
		if(i == 1){
			gl_Position.y = -2;
			gl_FrontColor = vec4(0.0, 0.0, 0.0, 0.0);
		}
		EmitVertex();

		//2
		gl_FrontColor  = R;
		gl_Position    = vec4(bariscentre.x + 0,
 							  bariscentre.y + 0, 
							  bariscentre.z + 0, 1.0);
		gl_Position    = gl_ModelViewProjectionMatrix*
		(gl_Position+time*n*speed);
		//gl_TexCoord[0] = vec4(0.0, -1.0, 0.0, 0.0);
		if(i == 1){
			gl_Position.y = -2;
			gl_FrontColor = vec4(0.0, 0.0, 0.0, 0.0);
		}
		EmitVertex();

		//3 
	
		gl_FrontColor  = B;
		gl_Position    = vec4(bariscentre.x + steps,
 							  bariscentre.y + 0, 
							  bariscentre.z + steps, 1.0);
		//gl_Position    = gl_ModelViewProjectionMatrix * gl_Position;
		gl_Position    = gl_ModelViewProjectionMatrix*
		(gl_Position+time*n*speed);
		//gl_TexCoord[0] = vec4(1.0, 0.0, 0.0, 0.0);
		if(i == 1){
			gl_Position.y = -2;
			gl_FrontColor = vec4(0.0, 0.0, 0.0, 0.0);
		}
		EmitVertex();
		
		//4

		gl_FrontColor  = B;
		gl_Position    = vec4(bariscentre.x + steps,
 							  bariscentre.y + 0, 
							  bariscentre.z + 0, 1.0);
		//gl_Position    = gl_ModelViewProjectionMatrix * gl_Position;
		gl_Position    = gl_ModelViewProjectionMatrix*
		(gl_Position+time*n*speed);
		//gl_TexCoord[0] = vec4(0.0, 0.0, 0.0, 0.0);
		if(i == 1){
			gl_Position.y = -2;
			gl_FrontColor = vec4(0.0, 0.0, 0.0, 0.0);
		}
		EmitVertex();
		


		//n = vec4(0.0, 1.0, 0.0, 0.0);
		//5
		gl_FrontColor  = B;
		gl_Position    = vec4(bariscentre.x + steps,
 							  bariscentre.y + steps, 
							  bariscentre.z + 0, 1.0);
		gl_Position    = gl_ModelViewProjectionMatrix * gl_Position;
		//gl_TexCoord[0] = gl_TexCoordIn  [ 0 ][ 0 ];
		if(i == 1){
			gl_Position.y = -2;
			gl_FrontColor = vec4(0.0, 0.0, 0.0, 0.0);
		}
		EmitVertex();
		//6

		gl_FrontColor  = B;
		gl_Position    = vec4(bariscentre.x + 0,
 							  bariscentre.y + 0, 
							  bariscentre.z + 0, 1.0);
		gl_Position    = gl_ModelViewProjectionMatrix * gl_Position;
		//gl_TexCoord[0] = gl_TexCoordIn  [ 0 ][ 0 ];
		if(i == 1){
			gl_Position.y = -2;
			gl_FrontColor = vec4(0.0, 0.0, 0.0, 0.0);
		}
		EmitVertex();
		//7
	
		gl_FrontColor  = B;
		gl_Position    = vec4(bariscentre.x + 0,
 							  bariscentre.y + steps, 
							  bariscentre.z + 0, 1.0);
		gl_Position    = gl_ModelViewProjectionMatrix * gl_Position;
		//gl_TexCoord[0] = gl_TexCoordIn  [ 0 ][ 0 ];
		if(i == 1){
			gl_Position.y = -2;
			gl_FrontColor = vec4(0.0, 0.0, 0.0, 0.0);
		}
		EmitVertex();

		//8
		gl_FrontColor  = G;
		gl_Position    = vec4(bariscentre.x + 0,
 							  bariscentre.y + 0, 
							  bariscentre.z + steps, 1.0);
		gl_Position    = gl_ModelViewProjectionMatrix * gl_Position;
		//gl_TexCoord[0] = gl_TexCoordIn  [ 0 ][ 0 ];
		if(i == 1){
			gl_Position.y = -2;
			gl_FrontColor = vec4(0.0, 0.0, 0.0, 0.0);
		}
		EmitVertex();
		

		//9
		gl_FrontColor  = B;
		gl_Position    = vec4(bariscentre.x + 0,
 							  bariscentre.y + steps,
							  bariscentre.z + steps, 1.0);
		gl_Position    = gl_ModelViewProjectionMatrix * gl_Position;
		//gl_TexCoord[0] = gl_TexCoordIn  [ 0 ][ 0 ];
		EmitVertex();
		
		//10
		gl_FrontColor  = B;
		gl_Position    = vec4(bariscentre.x + steps,
 							  bariscentre.y + 0,
							  bariscentre.z + steps, 1.0);
		gl_Position    = gl_ModelViewProjectionMatrix * gl_Position;
		//gl_TexCoord[0] = gl_TexCoordIn  [ 0 ][ 0 ];
		EmitVertex();
		
		//11
		gl_FrontColor  = B;
		gl_Position    = vec4(bariscentre.x + steps,
 							  bariscentre.y + steps, 
							  bariscentre.z + steps, 1.0);
		gl_Position    = gl_ModelViewProjectionMatrix * gl_Position;
		gl_TexCoord[0] = vec4(0.0, 0.0, 0.0, 0.0);
		EmitVertex();
		
		//12
		gl_FrontColor  = G;
		gl_Position    = vec4(bariscentre.x + steps,
 							  bariscentre.y + steps, 
							  bariscentre.z + 0, 1.0);
		gl_Position    = gl_ModelViewProjectionMatrix * gl_Position;
		gl_TexCoord[0] =vec4(0.0, 1.0, 0.0, 0.0);
		EmitVertex();
		
		//13
		gl_FrontColor  = B;
		gl_Position    = vec4(bariscentre.x + 0,
 							  bariscentre.y + steps, 
							  bariscentre.z + steps, 1.0);
		gl_Position    = gl_ModelViewProjectionMatrix * gl_Position;
		gl_TexCoord[0] =vec4(1.0, 0.0, 0.0, 0.0);
		EmitVertex();

		//14
		gl_FrontColor  = B;
		gl_Position    = vec4(bariscentre.x + 0,
 							  bariscentre.y + steps, 
							  bariscentre.z + 0, 1.0);
		gl_Position    = gl_ModelViewProjectionMatrix * gl_Position;
		gl_TexCoord[0] =vec4(0.0, 0.0, 0.0, 0.0);
		EmitVertex();

	EndPrimitive();
	}
}
