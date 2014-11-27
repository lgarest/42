// simple vertex shader
//Profe: Antoni Chica. MAil: achica@gmail.com



void main()
{

	//se lo pasamos al geometry en object space
	gl_Position    = gl_Vertex;

	gl_FrontColor  = gl_Color;
	gl_TexCoord[0] = gl_MultiTexCoord0;
}
