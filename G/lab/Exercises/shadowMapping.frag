// simple fragment shader

// 'time' contains seconds since the program was linked.
uniform float time;
uniform sampler2D sampler;
varying Pos;

void main()
{
	vec4 color1 = (1.0, 0.0, 0.0, 1.0);
	vec4 color2 = (0.5, 0.0, 0.0, 1.0);
	if ( (1 + (Pos.z/Pos.w)/2) < texture2D(sampler, gl_TexCoord[0].st)) {
		gl_FragColor = color1;	
	}
	else gl_FragColor = color2;
}
