// simple fragment shader

// 'time' contains seconds since the program was linked.
uniform float time;
uniform sampler2D sampler;
const float Velocitat = 50.0;
uniform bool improved;

void main()
{
	if (improved)gl_FragColor = gl_Color * texture2D(sampler, gl_TexCoord[0].st+Velocitat * time/100.0);
	else gl_FragColor = gl_Color * texture2D(sampler, gl_TexCoord[0].st);
}	
