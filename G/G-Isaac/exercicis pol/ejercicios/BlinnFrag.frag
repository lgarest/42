// simple fragment shader

// 'time' contains seconds since the program was linked.
uniform float time;

vec3 emissionMat;
	vec3 ambientMat;
	vec3 specMat;
	vec3 diffMat;
	float NMat;

	vec3 ambLuz0;
	vec3 diffLuz0;
	vec3 specLuz0;

	vec3 H;

	varying vec3 N;
	varying vec3 Vobs;

void main()
{


//componentes material
	emissionMat = gl_FrontMaterial.emission.xyz;
	ambientMat = gl_FrontMaterial.ambient.xyz;
	specMat = gl_FrontMaterial.specular.xyz;
	diffMat = gl_FrontMaterial.diffuse.xyz;
	NMat = gl_FrontMaterial.shininess;	

//	componentes luz 0
	ambLuz0 = gl_LightSource[0].ambient.xyz;
	diffLuz0 = gl_LightSource[0].diffuse.xyz;
	specLuz0 = gl_LightSource[0].specular.xyz;

//calculo de L
	
	vec3 L = gl_LightSource[0].position.xyz-Vobs;
	L = normalize(L);

	//calculo de V
	vec3 V = normalize(-Vobs);

//calculo de H
	H = V + L;
	H = normalize(H);

//se procede a calcularlo todo
	//calculo luz ambiente
	vec3 Ambient = (gl_LightModel.ambient.xyz+ambLuz0);
	Ambient *= ambientMat;

	//calculo luz difusa
	vec3 diffuse = diffLuz0;
	diffuse = diffuse*max(0.0, dot(N,L));
	diffuse *= diffMat;

	//calculo luz especular
	vec3 specular = specLuz0;
	specular = specular * pow(max(0.0, dot(N,H)), NMat);
	specular *= specMat;

	vec3 FinalLuz = emissionMat + Ambient + diffuse + specular;

	gl_FragColor = vec4(FinalLuz,1);
}
