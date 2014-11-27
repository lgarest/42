// simple fragment shader

// 'time' contains seconds since the program was linked.
uniform float time;
uniform sampler2D colour1;
uniform sampler2D colour0;
uniform sampler2D noisemap;

void main()
{
	vec4 color1 = (texture2D(colour1, gl_TexCoord[0].st));
	vec4 color0 = (texture2D(colour0, gl_TexCoord[0].st));
	float noise = (texture2D(noisemap, gl_TexCoord[0].st)).r;
	gl_FragColor = mix(color1,color0,noise);
}
