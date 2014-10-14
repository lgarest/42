// simple fragment shader

// 'time' contains seconds since the program was linked.
uniform float time;
uniform sampler2D sampler;


void main()
{
	float speed = 0.1*time;
	vec2 text = gl_TexCoord[0].st*speed;
	gl_FragColor = texture2D(sampler, text);
}
