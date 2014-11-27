// simple geometry shader
// these lines enable the geometry shader support.
#version 120
#extension GL_EXT_geometry_shader4 : enable

varying in vec4 pos[3];
uniform float step;
uniform bool improved;
void main( void )
{
    vec4 R = vec4(1.0, 0.0, 0.0, 1.0);
	vec4 G = vec4(0.0, 1.0, 0.0, 1.0);
	vec4 B = vec4(0.0, 0.0, 1.0, 1.0);	
	vec4 W = vec4(1.0, 1.0, 1.0, 1.0);	
	vec4 Y = vec4(1.0,1.0,0.0,1.0);
	vec4 n;
	
	vec3 bari = vec3(((pos[0]+pos[1]+pos[2])/3).xyz);
	bari.x /= step;
	float fracx = fract(bari.x);
	if(fracx >= 0.5) {
		float auxx = 1.0 - fracx;
		bari.x += auxx;
	}
	else bari.x -= fracx;
	bari.x*=step;
	bari.y /= step;
	float fracy = fract(bari.y);
	if(fracy >= 0.5) {
		float auxy = 1.0 - fracy;
		bari.y += auxy;
	}
	else bari.y -= fracy;
	bari.y*=step;
	bari.z /= step;
	float fracz = fract(bari.z);
	if(fracz >= 0.5) {
		float auxz = 1.0 - fracz;
		bari.z += auxz;
	}
	else bari.z -= fracz;
	bari.z*=step;

	if((mod (pos[0].y, 4)) < 0.4) gl_FrontColor = W; 
	else if((mod (pos[0].y, 4)) < 0.8)gl_FrontColor = Y;
	else if((mod (pos[0].y, 4)) < 1.2)gl_FrontColor = R;
	else if((mod (pos[0].y, 4)) < 1.6)gl_FrontColor = G;
	else gl_FrontColor = B;	

		n = vec4(0.0, -1.0, 0.0, 0.0);
		//Cara de abajo 
		//vertice 1
		gl_Position = vec4(bari.x, bari.y, bari.z+step,1.0);
		gl_Position = gl_ModelViewProjectionMatrix * gl_Position;
		gl_TexCoord[0] = vec4(0.0,0.0,0.0,0.0);
		EmitVertex();
		//vertice2
		gl_Position = vec4(bari.x, bari.y, bari.z,1.0);
		gl_Position = gl_ModelViewProjectionMatrix * gl_Position;
		gl_TexCoord[0] = vec4(0.0,0.0,0.0,0.0);
		EmitVertex();
		//vertice3
		gl_Position = vec4(bari.x+step, bari.y, bari.z+step, 1.0);
		gl_Position = gl_ModelViewProjectionMatrix * gl_Position;
		gl_TexCoord[0] = vec4(0.0,0.0,0.0,0.0);
		EmitVertex();
		//fin del primer triangul
		//vertice4
		gl_Position = vec4(bari.x+step, bari.y, bari.z, 1.0);
		gl_Position = gl_ModelViewProjectionMatrix * gl_Position;
		gl_TexCoord[0] = vec4(0.0,0.0,0.0,0.0);
		EmitVertex();

		EndPrimitive();
		//cara fondo 
		//vertice 1
		gl_Position = vec4(bari.x,bari.y, bari.z, 1.0);
		gl_Position = gl_ModelViewProjectionMatrix * gl_Position;
		gl_TexCoord[0] = vec4(0.0,0.0,0.0,0.0);
		EmitVertex();
		
		//vertice2
		gl_Position = vec4(bari.x+step,bari.y, bari.z,1.0);
		gl_Position = gl_ModelViewProjectionMatrix * gl_Position;
		gl_TexCoord[0] = vec4(0.0,0.0,0.0,0.0);
		EmitVertex();

		//vertice3
		gl_Position = vec4(bari.x, bari.y+step, bari.z,1.0);
		gl_Position = gl_ModelViewProjectionMatrix * gl_Position;
		gl_TexCoord[0] = vec4(0.0,0.0,0.0,0.0);
		EmitVertex();

		//vertice4
		gl_Position = vec4(bari.x+step, bari.y+step, bari.z,1.0);
		gl_Position = gl_ModelViewProjectionMatrix * gl_Position;
		gl_TexCoord[0] = vec4(0.0,0.0,0.0,0.0);
		EmitVertex();
		EndPrimitive();		

		//cara arriba 
		//vertice1
		gl_Position = vec4(bari.x+step, bari.y+step, bari.z+step,1.0);
		gl_Position = gl_ModelViewProjectionMatrix * gl_Position;
		gl_TexCoord[0] = vec4(0.0,0.0,0.0,0.0);
		EmitVertex();
		//vertice3
		gl_Position = vec4(bari.x+step, bari.y+step, bari.z, 1.0);
		gl_Position = gl_ModelViewProjectionMatrix * gl_Position;
		gl_TexCoord[0] = vec4(0.0,1.0,0.0,0.0);
		EmitVertex();
		
		//vertice2
		gl_Position = vec4(bari.x, bari.y+step, bari.z+step,1.0);
		gl_Position = gl_ModelViewProjectionMatrix * gl_Position;
		gl_TexCoord[0] = vec4(1.0,0.0,0.0,0.0);
		EmitVertex();
		EndPrimitive();


		//vertice4
		gl_Position = vec4 (bari.x, bari.y+step, bari.z,1.0);
		gl_Position = gl_ModelViewProjectionMatrix * gl_Position;
		gl_TexCoord[0] = vec4(1.0,1.0,0.0,0.0);
		EmitVertex();
		//vertice2
		gl_Position = vec4(bari.x, bari.y+step, bari.z+step,1.0);
		gl_Position = gl_ModelViewProjectionMatrix * gl_Position;;
		gl_TexCoord[0] = vec4(1.0,0.0,0.0,0.0);
		EmitVertex();
		//vertice3
		gl_Position = vec4(bari.x+step, bari.y+step, bari.z, 1.0);
		gl_Position = gl_ModelViewProjectionMatrix * gl_Position;
		gl_TexCoord[0] = vec4(0.0,1.0,0.0,0.0);
		EmitVertex();
		
		EndPrimitive();

		//caralateral 
		//vertice1
		gl_Position = vec4(bari.x+step, bari.y, bari.z,1.0);
		gl_Position = gl_ModelViewProjectionMatrix * gl_Position;
		gl_TexCoord[0] = vec4(0.0,0.0,0.0,0.0);
		EmitVertex();
		
		//vertice2
		gl_Position = vec4(bari.x+step, bari.y+step, bari.z, 1.0);
		gl_Position = gl_ModelViewProjectionMatrix * gl_Position;
		gl_TexCoord[0] = vec4(0.0,0.0,0.0,0.0);
		EmitVertex();
		
		//vertice3 
		gl_Position = vec4(bari.x+step, bari.y, bari.z+step, 1.0);
		gl_Position = gl_ModelViewProjectionMatrix * gl_Position;
		gl_TexCoord[0] = vec4(0.0,0.0,0.0,0.0);
		EmitVertex();

		//vertice4
		gl_Position = vec4(bari.x+step, bari.y+step, bari.z+step,1.0);
		gl_Position = gl_ModelViewProjectionMatrix * gl_Position;
		gl_TexCoord[0] = vec4(0.0,0.0,0.0,0.0);
		EmitVertex();
		
		EndPrimitive();

		//la otra cara lateral 
		//vertice1
		gl_Position = vec4(bari.x, bari.y+step, bari.z,1.0);
		gl_Position = gl_ModelViewProjectionMatrix * gl_Position;
		gl_TexCoord[0] = vec4(0.0,0.0,0.0,0.0);
		EmitVertex();
		
		//vertice2
		gl_Position = vec4(bari.x, bari.y, bari.z, 1.0);
		gl_Position = gl_ModelViewProjectionMatrix * gl_Position;
		gl_TexCoord[0] = vec4(0.0,0.0,0.0,0.0);
		EmitVertex();
		
		//vertice3 
		gl_Position = vec4(bari.x, bari.y+step, bari.z+step, 1.0);
		gl_Position = gl_ModelViewProjectionMatrix * gl_Position;
		gl_TexCoord[0] = vec4(0.0,0.0,0.0,0.0);
		EmitVertex();

		//vertice4
		gl_Position = vec4(bari.x, bari.y, bari.z+step,1.0);
		gl_Position = gl_ModelViewProjectionMatrix * gl_Position;
		gl_TexCoord[0] = vec4(0.0,0.0,0.0,0.0);
		EmitVertex();
		EndPrimitive();

		//ultima cara
		//caralateral 
		//vertice1
		gl_Position = vec4(bari.x, bari.y+step, bari.z+step,1.0);
		gl_Position = gl_ModelViewProjectionMatrix * gl_Position;
		gl_TexCoord[0] = vec4(0.0,0.0,0.0,0.0);
		EmitVertex();
		
		//vertice2
		gl_Position = vec4(bari.x, bari.y, bari.z+step, 1.0);
		gl_Position = gl_ModelViewProjectionMatrix * gl_Position;
		gl_TexCoord[0] = vec4(0.0,0.0,0.0,0.0);
		EmitVertex();
		
		//vertice3 
		gl_Position = vec4(bari.x+step, bari.y+step, bari.z+step, 1.0);
		gl_Position = gl_ModelViewProjectionMatrix * gl_Position;
		gl_TexCoord[0] = vec4(0.0,0.0,0.0,0.0);
		
		EmitVertex();

		//vertice4
		gl_Position = vec4(bari.x+step, bari.y, bari.z+step,1.0);
		gl_Position = gl_ModelViewProjectionMatrix * gl_Position;
		gl_TexCoord[0] = vec4(0.0,0.0,0.0,0.0);
		EmitVertex();
		EndPrimitive();
		



	if(improved){
		//Parte de sombra 

		gl_Position = vec4(bari.x, bari.y, bari.z+step,1.0);
		gl_Position = gl_ModelViewProjectionMatrix * gl_Position;

		gl_Position.y -=4;
		gl_FrontColor = vec4(0.0,0.0,0.0,0.0);
		gl_TexCoord[0] = vec4(0.0,0.0,0.0,0.0);
		EmitVertex();
		//vertice2
		gl_Position = vec4(bari.x, bari.y, bari.z,1.0);
		gl_Position = gl_ModelViewProjectionMatrix * gl_Position;
		gl_Position.y -= 4;
		
		gl_FrontColor = vec4(0.0,0.0,0.0,0.0);
		gl_TexCoord[0] = vec4(0.0,0.0,0.0,0.0);
		EmitVertex();
		//vertice3
		gl_Position = vec4(bari.x+step, bari.y, bari.z+step, 1.0);
		gl_Position = gl_ModelViewProjectionMatrix * gl_Position;
		gl_Position.y -= 4;
		gl_FrontColor = vec4(0.0,0.0,0.0,0.0);
		gl_TexCoord[0] = vec4(0.0,0.0,0.0,0.0);
		EmitVertex();

		//vertice4
		gl_Position = vec4(bari.x+step, bari.y, bari.z, 1.0);
		gl_Position = gl_ModelViewProjectionMatrix * gl_Position;
		gl_Position.y -= 4;
		gl_FrontColor = vec4(0.0,0.0,0.0,0.0);
		gl_TexCoord[0] = vec4(0.0,0.0,0.0,0.0);
		EmitVertex();

		EndPrimitive();
		//cara fondo 
		//vertice 1
		gl_Position = vec4(bari.x,bari.y, bari.z, 1.0);
		gl_Position = gl_ModelViewProjectionMatrix * gl_Position;
		gl_Position.y -= 4;
		gl_FrontColor = vec4(0.0,0.0,0.0,0.0);
		gl_TexCoord[0] = vec4(0.0,0.0,0.0,0.0);
		EmitVertex();
		
		//vertice2
		gl_Position = vec4(bari.x+step,bari.y, bari.z,1.0);
		gl_Position = gl_ModelViewProjectionMatrix * gl_Position;
		gl_Position.y -= 4;
		gl_FrontColor = vec4(0.0,0.0,0.0,0.0);
		gl_TexCoord[0] = vec4(0.0,0.0,0.0,0.0);
		EmitVertex();

		//vertice3
		gl_Position = vec4(bari.x, bari.y+step, bari.z,1.0);
		gl_Position = gl_ModelViewProjectionMatrix * gl_Position;
		gl_Position.y -= 4;
		gl_FrontColor = vec4(0.0,0.0,0.0,0.0);
		gl_TexCoord[0] = vec4(0.0,0.0,0.0,0.0);
		EmitVertex();

		//vertice4
		gl_Position = vec4(bari.x+step, bari.y+step, bari.z,1.0);
		gl_Position = gl_ModelViewProjectionMatrix * gl_Position;
		gl_Position.y -= 4;
		gl_FrontColor = vec4(0.0,0.0,0.0,0.0);
		gl_TexCoord[0] = vec4(0.0,0.0,0.0,0.0);
		EmitVertex();
		EndPrimitive();		

		//cara arriba 
		//vertice1
		gl_Position = vec4(bari.x+step, bari.y+step, bari.z+step,1.0);
		gl_Position = gl_ModelViewProjectionMatrix * gl_Position;
		gl_Position.y -= 4;
		gl_FrontColor = vec4(0.0,0.0,0.0,0.0);
		gl_TexCoord[0] = vec4(0.0,0.0,0.0,0.0);
		EmitVertex();
		
		//vertice3
		gl_Position = vec4(bari.x, bari.y+step, bari.z+step,1.0);
		gl_Position = gl_ModelViewProjectionMatrix * gl_Position;
		gl_Position.y -= 4;
		gl_FrontColor = vec4(0.0,0.0,0.0,0.0);
		gl_TexCoord[0] = vec4(1.0,0.0,0.0,0.0);
		EmitVertex();
		//vertice2
		gl_Position = vec4(bari.x+step, bari.y+step, bari.z, 1.0);
		gl_Position = gl_ModelViewProjectionMatrix * gl_Position;
		gl_Position.y -= 4;
		gl_FrontColor = vec4(0.0,0.0,0.0,0.0);
		gl_TexCoord[0] = vec4(0.0,1.0,0.0,0.0);
		EmitVertex();

		//vertice4
		gl_Position = vec4 (bari.x, bari.y+step, bari.z,1.0);
		gl_Position = gl_ModelViewProjectionMatrix * gl_Position;
		gl_Position.y -= 4;
		gl_FrontColor = vec4(0.0,0.0,0.0,0.0);
		gl_TexCoord[0] = vec4(0.0,0.0,0.0,0.0);
		EmitVertex();
		
		EndPrimitive();

		//caralateral 
		//vertice1
		gl_Position = vec4(bari.x+step, bari.y, bari.z,1.0);
		gl_Position = gl_ModelViewProjectionMatrix * gl_Position;
		gl_Position.y -= 4;
		gl_FrontColor = vec4(0.0,0.0,0.0,0.0);
		gl_TexCoord[0] = vec4(0.0,0.0,0.0,0.0);
		EmitVertex();
		
		//vertice2
		gl_Position = vec4(bari.x+step, bari.y+step, bari.z, 1.0);
		gl_Position = gl_ModelViewProjectionMatrix * gl_Position;
		gl_Position.y -= 4;
		gl_FrontColor = vec4(0.0,0.0,0.0,0.0);
		gl_TexCoord[0] = vec4(0.0,0.0,0.0,0.0);
		EmitVertex();
		
		//vertice3 
		gl_Position = vec4(bari.x+step, bari.y, bari.z+step, 1.0);
		gl_Position = gl_ModelViewProjectionMatrix * gl_Position;
		gl_Position.y -= 4;
		gl_FrontColor = vec4(0.0,0.0,0.0,0.0);
		gl_TexCoord[0] = vec4(0.0,0.0,0.0,0.0);
		EmitVertex();

		//vertice4
		gl_Position = vec4(bari.x+step, bari.y+step, bari.z+step,1.0);
		gl_Position = gl_ModelViewProjectionMatrix * gl_Position;
		gl_Position.y -= 4;
		gl_FrontColor = vec4(0.0,0.0,0.0,0.0);
		gl_TexCoord[0] = vec4(0.0,0.0,0.0,0.0);
		EmitVertex();
		
		EndPrimitive();

		//la otra cara lateral 
		//vertice1
		gl_Position = vec4(bari.x, bari.y+step, bari.z,1.0);
		gl_Position = gl_ModelViewProjectionMatrix * gl_Position;
		gl_Position.y -= 4;
		gl_FrontColor = vec4(0.0,0.0,0.0,0.0);
		gl_TexCoord[0] = vec4(0.0,0.0,0.0,0.0);
		EmitVertex();
		
		//vertice2
		gl_Position = vec4(bari.x, bari.y, bari.z, 1.0);
		gl_Position = gl_ModelViewProjectionMatrix * gl_Position;
		gl_Position.y -= 4;
		gl_FrontColor = vec4(0.0,0.0,0.0,0.0);
		gl_TexCoord[0] = vec4(0.0,0.0,0.0,0.0);
		EmitVertex();
		
		//vertice3 
		gl_Position = vec4(bari.x, bari.y+step, bari.z+step, 1.0);
		gl_Position = gl_ModelViewProjectionMatrix * gl_Position;
		gl_Position.y -= 4;
		gl_FrontColor = vec4(0.0,0.0,0.0,0.0);
		gl_TexCoord[0] = vec4(0.0,0.0,0.0,0.0);
		EmitVertex();

		//vertice4
		gl_Position = vec4(bari.x, bari.y, bari.z+step,1.0);
		gl_Position = gl_ModelViewProjectionMatrix * gl_Position;
		gl_Position.y -= 4;
		gl_FrontColor = vec4(0.0,0.0,0.0,0.0);
		gl_TexCoord[0] = vec4(0.0,0.0,0.0,0.0);
		EmitVertex();
		EndPrimitive();

		//ultima cara
		//caralateral 
		//vertice1
		gl_Position = vec4(bari.x, bari.y+step, bari.z+step,1.0);
		gl_Position = gl_ModelViewProjectionMatrix * gl_Position;
		gl_Position.y -= 4;
		gl_FrontColor = vec4(0.0,0.0,0.0,0.0);
		gl_TexCoord[0] = vec4(0.0,0.0,0.0,0.0);
		EmitVertex();
		
		//vertice2
		gl_Position = vec4(bari.x, bari.y, bari.z+step, 1.0);
		gl_Position = gl_ModelViewProjectionMatrix * gl_Position;
		gl_Position.y -= 4;
		gl_FrontColor = vec4(0.0,0.0,0.0,0.0);
		gl_TexCoord[0] = vec4(0.0,0.0,0.0,0.0);
		EmitVertex();
		
		//vertice3 
		gl_Position = vec4(bari.x+step, bari.y+step, bari.z+step, 1.0);
		gl_Position = gl_ModelViewProjectionMatrix * gl_Position;
		gl_Position.y -= 4;
		gl_FrontColor = vec4(0.0,0.0,0.0,0.0);
		gl_TexCoord[0] = vec4(0.0,0.0,0.0,0.0);
		EmitVertex();

		//vertice4
		gl_Position = vec4(bari.x+step, bari.y, bari.z+step,1.0);
		gl_Position = gl_ModelViewProjectionMatrix * gl_Position;
		gl_Position.y -= 4;
		gl_FrontColor = vec4(0.0,0.0,0.0,0.0);
		gl_TexCoord[0] = vec4(0.0,0.0,0.0,0.0);
		EmitVertex();
		
		EndPrimitive();
	}
}
