
// simple fragment shader

// 'time' contains seconds since the program was linked.
uniform sampler2D sampler;
varying float s, t;

void main()
{
	gl_FragColor = gl_Color * texture2D(sampler, vec2(s, t));
}