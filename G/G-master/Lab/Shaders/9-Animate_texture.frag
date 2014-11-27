// simple fragment shader

// 'time' contains seconds since the program was linked.
uniform float time;
uniform float speed; 
varying vec2 textCoord;
uniform sampler2D sampler;

void main()
{
	gl_FragColor = gl_Color * texture2D(sampler, textCoord);
}
