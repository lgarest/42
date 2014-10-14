// simple vertex shader

varying vec4 Pos;
uniform mat4 ProjectiveTextureMatrix;

void main()
{
	gl_Position    = gl_ModelViewProjectionMatrix * gl_Vertex;
	gl_FrontColor  = gl_Color;
	gl_TexCoord[0] = gl_MultiTexCoord0;
	Pos = ProjectiveTextureMatrix*gl_Vertex;
	float coordX = (1 + Pos.x/Pos.w)/2;
	float coordY = (1 + Pos.y/Pos.w)/2;
	gl_TexCoord[0].s = coordX;
	gl_TexCoord[0].t = coordY;
}
