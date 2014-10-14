// simple vertex shader

varying vec3 Nobs;
varying vec3 Vobs;
varying vec3 Lobs;

varying vec3 Nworld;
varying vec3 Vworld;
varying vec3 Lworld;

void main()
{
	Nobs = (gl_NormalMatrix * gl_Normal);
	Vobs = - (gl_ModelViewMatrix * gl_Vertex).xyz;
	Lobs = (gl_LightSource[0].position - (gl_ModelViewMatrix * gl_Vertex)).xyz;
	
	Nworld = gl_Normal;
	Vworld = (gl_ModelViewMatrixInverse * vec4(0,0,0,1)).xyz - gl_Vertex.xyz;
	Lworld = (gl_ModelViewMatrixInverse * gl_LightSource[0].position).xyz - gl_Vertex.xyz;

	gl_Position = gl_ModelViewProjectionMatrix * gl_Vertex;
	//gl_FrontColor  = gl_FrontMaterial.emission + amb;
	//gl_FrontColor  = gl_FrontMaterial.emission + (amb+diff);
	//gl_FrontColor  = (gl_FrontMaterial.emission + (amb+diff+spec));
	//gl_TexCoord[0] = gl_MultiTexCoord0;
}
