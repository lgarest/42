uniform sampler2D sampler;
uniform float time;

void main()
{
	gl_FragColor = texture2D(sampler, gl_TexCoord[0].st);
}
