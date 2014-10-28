uniform float time;
varying vec3 pos;

void main(){
	if (pos.x < time - 1.0)
		gl_FragColor = vec4(0.0,0.0,1.0,0.0);
	else discard;
}
