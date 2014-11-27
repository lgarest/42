// simple fragment shader

// 'time' contains seconds since the program was linked.
uniform float time;
uniform sampler2D sampler;

void main()
{
	gl_FragColor = vec4(1.0,1.0,0.0,0.0) * texture2D(sampler, gl_TexCoord[0].st);
}
