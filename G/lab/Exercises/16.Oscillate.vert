// simple vertex shader
uniform float time;
uniform bool eyespace;
//Escriu un vertex shader que pertorbi cada vèrtex del model en la 
//direcció de la seva normal, desplaçant-lo una distància d que 
//variï sinusoidalment amb amplitud igual a la component y del
//vèrtex i període 2π segons. Per calcular la amplitud s'agafarà la
// component y en eye space si el uniform bool eyespace és cert;
//altrament s’agafarà la component y en object space.

void main() {
	//float pi = 3.141592654;
	if (eyespace) {
		float d = gl_Vertex.y * sin(time);
		vec3 trans = gl_Normal * d + vec3(gl_Vertex);
		gl_Position    = gl_ModelViewProjectionMatrix * vec4(trans,1.0);
	}
	else {
		vec4 poseye = gl_ModelViewMatrix*gl_Vertex;
		float d = poseye.y * sin(time);
		vec3 trans = gl_Normal * d + vec3(poseye);
		gl_Position    = gl_ProjectionMatrix * vec4(trans,1.0);
	}
	gl_FrontColor  = gl_Color;
	gl_TexCoord[0] = gl_MultiTexCoord0;
}
