uniform float time;

void main(){
	gl_FragDepth = -gl_FragCoord.z + 1.0;
	gl_FragColor = gl_Color;
}
