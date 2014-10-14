// simple vertex shader

uniform float minY;
uniform float maxY;

//no esta terminado!!! acabalo con las instrucciones que te has puesto por aqui
	vec4 R =vec4(1.0,0.0,0.0,0.0);
	vec4 G =vec4(0.0,1.0,0.0,0.0);
	vec4 B =vec4(0.0,0.0,1.0,0.0);
	vec4 C =vec4(0.0,1.0,1.0,0.0);
	vec4 Y =vec4(1.0,1.0,0.0,0.0);



void main()
{

//entre 4, pk son 4 interpolaciones, ahora tienes que hacer el mix en funcion del factor de interpolacion entre 0 y 1
	float Partes = (maxY-(-minY))/4;



	


	if(gl_Vertex.y <= maxY && gl_Vertex.y > -minY+3*Partes){
		float dif = (gl_Vertex.y-(-minY+3*Partes))/Partes; //restas el punto actual por la posicion del cuadrante, y luego lo divides por dicha parte, para que te quede un valor entre 0 y 1
		gl_FrontColor = mix(C, B, dif);

	}else if(gl_Vertex.y < maxY-Partes && gl_Vertex.y > -minY+2*Partes){
		float dif = (gl_Vertex.y-(-minY+2*Partes))/Partes;
		gl_FrontColor = mix(G, C, dif);

	}else if(gl_Vertex.y < maxY-2*Partes && gl_Vertex.y > -minY+Partes){
		float dif = (gl_Vertex.y-(-minY+Partes))/Partes;
		gl_FrontColor = mix(Y, G, dif);

	}else if(gl_Vertex.y < maxY-3*Partes && gl_Vertex.y >= -minY){
		float dif = (gl_Vertex.y-(-minY))/Partes;
		gl_FrontColor = mix(R, Y, dif);
	}

	

	
	gl_Position = gl_ModelViewProjectionMatrix * gl_Vertex;
	gl_TexCoord[0] = gl_MultiTexCoord0;
	//gl_FrontColor  = gl_Color;
}
