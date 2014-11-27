// simple fragment shader

// 'time' contains seconds since the program was linked.
uniform float time;
uniform sampler2D sampler; // "guarda" la textura

uniform float speed; 
varying vec2 new_textureCoords;

void main()
{
//	gl_FragColor = gl_Color;
// el color del fragmento será el color de la textura sampler con las coords
// de la textura
gl_FragColor = gl_Color * texture2D(sampler, new_textureCoords);
}
