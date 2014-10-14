// simple geometry shader

// these lines enable the geometry shader support.
#version 120
#extension GL_EXT_geometry_shader4 : enable

varying in vec4 pos[3];
varying in vec3 normal[3];
uniform float step;
uniform sampler2D sampler;

void main( void )
{
	vec4 center = vec4(((pos[0]+pos[1]+pos[2])/3.0).xyz,0.0);
	center.x = int(center.x/step)*step;
	center.y = int(center.y/step)*step;
	center.z = int(center.z/step)*step;
	vec4 vaux;
	float offset = 0.5*step;
	float i,j,k;
	vec4 color;
	if ((mod (pos[0].y, 4)) < 0.4) color = vec4(1.0,1.0,1.0,0.0);
	else if ((mod (pos[0].y, 4)) < 0.8) color = vec4(1.0,1.0,0.0,0.0);
	else if ((mod (pos[0].y, 4)) < 1.2) color = vec4(1.0,0.0,0.0,0.0);
	else if ((mod (pos[0].y, 4)) < 1.6) color = vec4(0.0,1.0,0.0,0.0);
	else color = vec4(0.0,0.0,1.0,0.0);
	//	X static
	gl_FrontColor = color;
	i = float(center.x+offset);
	j = float(center.y-offset);
	k = float(center.z-offset);
	vaux = vec4(i,j,k,1.0);
	gl_TexCoord[0] = vec4(0.0,0.0,0.0,0.0);
	gl_Position    = gl_ModelViewProjectionMatrix*vaux;
	EmitVertex();
	i = float(center.x+offset);
	j = float(center.y+offset);
	k = float(center.z-offset);
	vaux = vec4(i,j,k,1.0);
	gl_TexCoord[0] = vec4(0.0,0.0,0.0,0.0);
	gl_Position    = gl_ModelViewProjectionMatrix*vaux;
	EmitVertex();
	i = float(center.x+offset);
	j = float(center.y-offset);
	k = float(center.z+offset);
	vaux = vec4(i,j,k,1.0);
	gl_TexCoord[0] = vec4(0.0,0.0,0.0,0.0);
	gl_Position    = gl_ModelViewProjectionMatrix*vaux;
	EmitVertex();
	i = float(center.x+offset);
	j = float(center.y+offset);
	k = float(center.z+offset);
	vaux = vec4(i,j,k,1.0);
	gl_TexCoord[0] = vec4(0.0,0.0,0.0,0.0);
	gl_Position    = gl_ModelViewProjectionMatrix*vaux;
	EmitVertex();
	EndPrimitive();

	gl_FrontColor = color*normal[0].z;
	i = float(center.x-offset);
	j = float(center.y-offset);
	k = float(center.z-offset);
	vaux = vec4(i,j,k,1.0);
	gl_TexCoord[0] = vec4(0.0,0.0,0.0,0.0);
	gl_Position    = gl_ModelViewProjectionMatrix*vaux;
	EmitVertex();
	i = float(center.x-offset);
	j = float(center.y+offset);
	k = float(center.z-offset);
	vaux = vec4(i,j,k,1.0);
	gl_TexCoord[0] = vec4(0.0,0.0,0.0,0.0);
	gl_Position    = gl_ModelViewProjectionMatrix*vaux;
	EmitVertex();
	i = float(center.x-offset);
	j = float(center.y-offset);
	k = float(center.z+offset);
	vaux = vec4(i,j,k,1.0);
	gl_TexCoord[0] = vec4(0.0,0.0,0.0,0.0);
	gl_Position    = gl_ModelViewProjectionMatrix*vaux;
	EmitVertex();
	i = float(center.x-offset);
	j = float(center.y+offset);
	k = float(center.z+offset);
	vaux = vec4(i,j,k,1.0);
	gl_TexCoord[0] = vec4(0.0,0.0,0.0,0.0);
	gl_Position    = gl_ModelViewProjectionMatrix*vaux;
	EmitVertex();
	EndPrimitive();

	//    Y STATIC
	i = float(center.x-offset);
	j = float(center.y+offset);
	k = float(center.z-offset);
	vaux = vec4(i,j,k,1.0);
	gl_TexCoord[0] = vec4(0.0,0.0,0.0,0.0);
	gl_Position    = gl_ModelViewProjectionMatrix*vaux;
	EmitVertex();
	i = float(center.x+offset);
	j = float(center.y+offset);
	k = float(center.z-offset);
	vaux = vec4(i,j,k,1.0);
	gl_TexCoord[0] = vec4(0.0,1.0,0.0,0.0);
	gl_Position    = gl_ModelViewProjectionMatrix*vaux;
	EmitVertex();
	i = float(center.x-offset);
	j = float(center.y+offset);
	k = float(center.z+offset);
	vaux = vec4(i,j,k,1.0);
	gl_TexCoord[0] = vec4(1.0,0.0,0.0,0.0);
	gl_Position    = gl_ModelViewProjectionMatrix*vaux;
	EmitVertex();
	i = float(center.x+offset);
	j = float(center.y+offset);
	k = float(center.z+offset);
	vaux = vec4(i,j,k,1.0);
	gl_TexCoord[0] = vec4(0.0,0.0,0.0,0.0);
	gl_Position    = gl_ModelViewProjectionMatrix*vaux;
	EmitVertex();
	EndPrimitive();

	i = float(center.x-offset);
	j = float(center.y-offset);
	k = float(center.z-offset);
	vaux = vec4(i,j,k,1.0);
	gl_TexCoord[0] = vec4(0.0,0.0,0.0,0.0);
	gl_Position    = gl_ModelViewProjectionMatrix*vaux;
	EmitVertex();
	i = float(center.x+offset);
	j = float(center.y-offset);
	k = float(center.z-offset);
	vaux = vec4(i,j,k,1.0);
	gl_TexCoord[0] = vec4(0.0,0.0,0.0,0.0);
	gl_Position    = gl_ModelViewProjectionMatrix*vaux;
	EmitVertex();
	i = float(center.x-offset);
	j = float(center.y-offset);
	k = float(center.z+offset);
	vaux = vec4(i,j,k,1.0);
	gl_TexCoord[0] = vec4(0.0,0.0,0.0,0.0);
	gl_Position    = gl_ModelViewProjectionMatrix*vaux;
	EmitVertex();
	i = float(center.x+offset);
	j = float(center.y-offset);
	k = float(center.z+offset);
	vaux = vec4(i,j,k,1.0);
	gl_TexCoord[0] = vec4(0.0,0.0,0.0,0.0);
	gl_Position    = gl_ModelViewProjectionMatrix*vaux;
	EmitVertex();
	EndPrimitive();

	//    Z STATIC
	i = float(center.x-offset);
	j = float(center.y-offset);
	k = float(center.z+offset);
	vaux = vec4(i,j,k,1.0);
	gl_TexCoord[0] = vec4(0.0,0.0,0.0,0.0);
	gl_Position    = gl_ModelViewProjectionMatrix*vaux;
	EmitVertex();
	i = float(center.x+offset);
	j = float(center.y-offset);
	k = float(center.z+offset);
	vaux = vec4(i,j,k,1.0);
	gl_TexCoord[0] = vec4(0.0,0.0,0.0,0.0);
	gl_Position    = gl_ModelViewProjectionMatrix*vaux;
	EmitVertex();
	i = float(center.x-offset);
	j = float(center.y+offset);
	k = float(center.z+offset);
	vaux = vec4(i,j,k,1.0);
	gl_TexCoord[0] = vec4(0.0,0.0,0.0,0.0);
	gl_Position    = gl_ModelViewProjectionMatrix*vaux;
	EmitVertex();
	i = float(center.x+offset);
	j = float(center.y+offset);
	k = float(center.z+offset);
	vaux = vec4(i,j,k,1.0);
	gl_TexCoord[0] = vec4(0.0,0.0,0.0,0.0);
	gl_Position    = gl_ModelViewProjectionMatrix*vaux;
	EmitVertex();
	EndPrimitive();

	i = float(center.x-offset);
	j = float(center.y-offset);
	k = float(center.z-offset);
	vaux = vec4(i,j,k,1.0);
	gl_TexCoord[0] = vec4(0.0,0.0,0.0,0.0);
	gl_Position    = gl_ModelViewProjectionMatrix*vaux;
	EmitVertex();
	i = float(center.x+offset);
	j = float(center.y-offset);
	k = float(center.z-offset);
	vaux = vec4(i,j,k,1.0);
	gl_TexCoord[0] = vec4(0.0,0.0,0.0,0.0);
	gl_Position    = gl_ModelViewProjectionMatrix*vaux;
	EmitVertex();
	i = float(center.x-offset);
	j = float(center.y+offset);
	k = float(center.z-offset);
	vaux = vec4(i,j,k,1.0);
	gl_TexCoord[0] = vec4(0.0,0.0,0.0,0.0);
	gl_Position    = gl_ModelViewProjectionMatrix*vaux;
	EmitVertex();
	i = float(center.x+offset);
	j = float(center.y+offset);
	k = float(center.z-offset);
	vaux = vec4(i,j,k,1.0);
	gl_TexCoord[0] = vec4(0.0,0.0,0.0,0.0);
	gl_Position    = gl_ModelViewProjectionMatrix*vaux;
	EmitVertex();
	EndPrimitive();

	/*
	offsety = 0.5*step;
	for( int a = 0 ; a < 4 ; a++ )
	{
		if (a < 2) offsetz = 0.5*step;
		else offsetz = -0.5*step;
		if (a == 0 || a == 2) offsetx = -0.5*step;
		else offsetx = 0.5*step;
		i = float(center.x+offsetx);
		j = float(center.y+offsety);
		k = float(center.z+offsetz);
		vaux = vec4(i,j,k,1.0);
		gl_Position    = gl_ModelViewProjectionMatrix*vaux;
		if (a == 3) gl_FrontColor = color*texture2D(sampler, gl_TexCoordIn[0][0].st);
		else gl_FrontColor = color*normal[0].z*texture2D(sampler, gl_TexCoordIn[0][0].st);
		EmitVertex();
	}*/
}

