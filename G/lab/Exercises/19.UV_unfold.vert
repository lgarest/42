// simple vertex shader

uniform vec2 Min;
uniform vec2 Max;

void main()
{
	gl_TexCoord[0] = gl_MultiTexCoord0;
	float s = gl_TexCoord[0].s;
	float t = gl_TexCoord[0].t;
	s = (s-Min.x)/(Max.x-Min.x)*2.0;
	t = (t-Min.y)/(Max.y-Min.y)*2.0;
	gl_Position    = gl_ModelViewProjectionMatrix*vec4(s-1.0,t-1.0,0.0,1.0);
	//gl_Position    = vec4(s-1.0,t-1.0,0.0,1.0);
	gl_FrontColor  = gl_Color;
}
