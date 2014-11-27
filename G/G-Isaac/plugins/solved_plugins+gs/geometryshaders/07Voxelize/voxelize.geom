// simple geometry shader

// these lines enable the geometry shader support.
#version 120
#extension GL_EXT_geometry_shader4 : enable

varying in vec4 pos[3];
uniform float step;

void main( void )
{
	vec4 center = vec4(((pos[0]+pos[1]+pos[2])/3.0).xyz,0.0);
	center.x = int(center.x/step)*step;
	center.y = int(center.y/step)*step;
	center.z = int(center.z/step)*step;
	vec4 vaux;
	float offsetx,offsety,offsetz;
	offsetz = 0.5*step;
	float i,j,k;
	for( int a = 0 ; a < 4 ; a++ )
	{
		if (a < 3) gl_FrontColor  = vec4(0.5,0.5,0.5,0.0);
		else gl_FrontColor = vec4(0.0,0.0,0.0,0.0);
		if (a < 2) offsety = 0.5*step;
		else offsety = -0.5*step;
		if (a == 0 || a == 2) offsetx = 0.5*step;
		else offsetx = -0.5*step;
		i = (center.x+offsetx);
		j = (center.y+offsety);
		k = (center.z+offsetz);
		vaux = vec4(i,j,k,1.0);
		gl_Position    = gl_ModelViewProjectionMatrix*vaux;
		gl_TexCoord[0] = gl_TexCoordIn  [ a ][ 0 ];
		EmitVertex();
	}
	EndPrimitive();
	offsetx = -0.5*step;
	for( int a = 0 ; a < 4 ; a++ )
	{
		if (a < 3) gl_FrontColor  = vec4(0.5,0.5,0.5,0.0);
		else gl_FrontColor = vec4(0.0,0.0,0.0,0.0);
		if (a < 2) offsetz = 0.5*step;
		else offsetz = -0.5*step;
		if (a == 0 || a == 2) offsety = -0.5*step;
		else offsety = 0.5*step;
		i = float(center.x+offsetx);
		j = float(center.y+offsety);
		k = float(center.z+offsetz);
		vaux = vec4(i,j,k,1.0);
		gl_Position    = gl_ModelViewProjectionMatrix*vaux;
		gl_TexCoord[0] = gl_TexCoordIn  [ a ][ 0 ];
		EmitVertex();
	}
	EndPrimitive();
	offsetz = -0.5*step;
	for( int a = 0 ; a < 4 ; a++ )
	{
		if (a < 3) gl_FrontColor  = vec4(0.5,0.5,0.5,0.0);
		else gl_FrontColor = vec4(0.0,0.0,0.0,0.0);
		if (a < 2) offsety = 0.5*step;
		else offsety = -0.5*step;
		if (a == 0 || a == 2) offsetx = 0.5*step;
		else offsetx = -0.5*step;
		i = float(center.x+offsetx);
		j = float(center.y+offsety);
		k = float(center.z+offsetz);
		vaux = vec4(i,j,k,1.0);
		gl_Position    = gl_ModelViewProjectionMatrix*vaux;
		gl_TexCoord[0] = gl_TexCoordIn  [ a ][ 0 ];
		EmitVertex();
	}
	EndPrimitive();
	offsetx = 0.5*step;
	for( int a = 0 ; a < 4 ; a++ )
	{
		if (a < 3) gl_FrontColor  = vec4(0.5,0.5,0.5,0.0);
		else gl_FrontColor = vec4(0.0,0.0,0.0,0.0);
		if (a < 2) offsetz = 0.5*step;
		else offsetz = -0.5*step;
		if (a == 0 || a == 2) offsety = -0.5*step;
		else offsety = 0.5*step;
		i = float(center.x+offsetx);
		j = float(center.y+offsety);
		k = float(center.z+offsetz);
		vaux = vec4(i,j,k,1.0);
		gl_Position    = gl_ModelViewProjectionMatrix*vaux;
		gl_TexCoord[0] = gl_TexCoordIn  [ a ][ 0 ];
		EmitVertex();
	}
	EndPrimitive();
	offsety = 0.5*step;
	for( int a = 0 ; a < 4 ; a++ )
	{
		if (a < 3) gl_FrontColor  = vec4(0.5,0.5,0.5,0.0);
		else gl_FrontColor = vec4(0.0,0.0,0.0,0.0);
		if (a < 2) offsetz = 0.5*step;
		else offsetz = -0.5*step;
		if (a == 0 || a == 2) offsetx = -0.5*step;
		else offsetx = 0.5*step;
		i = float(center.x+offsetx);
		j = float(center.y+offsety);
		k = float(center.z+offsetz);
		vaux = vec4(i,j,k,1.0);
		gl_Position    = gl_ModelViewProjectionMatrix*vaux;
		gl_TexCoord[0] = gl_TexCoordIn  [ a ][ 0 ];
		EmitVertex();
	}
	EndPrimitive();
	offsety = -0.5*step;
	for( int a = 0 ; a < 4 ; a++ )
	{
		if (a < 3) gl_FrontColor  = vec4(0.5,0.5,0.5,0.0);
		else gl_FrontColor = vec4(0.0,0.0,0.0,0.0);
		if (a < 2) offsetz = 0.5*step;
		else offsetz = -0.5*step;
		if (a == 0 || a == 2) offsetx = -0.5*step;
		else offsetx = 0.5*step;
		i = float(center.x+offsetx);
		j = float(center.y+offsety);
		k = float(center.z+offsetz);
		vaux = vec4(i,j,k,1.0);
		gl_Position    = gl_ModelViewProjectionMatrix*vaux;
		gl_TexCoord[0] = gl_TexCoordIn  [ a ][ 0 ];
		EmitVertex();
	}
}
