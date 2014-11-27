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

	vec3 R;

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

	//Ma = gl_LightModel.ambient


//	componentes luz 0
	ambLuz0 = gl_LightSource[0].ambient.xyz;
	diffLuz0 = gl_LightSource[0].diffuse.xyz;
	specLuz0 = gl_LightSource[0].specular.xyz;
	

	//calculo de L
	vec3 L = gl_LightSource[0].position.xyz-Vobs;
	L = normalize(L);

	//calculo de V
	vec3 V = normalize(-Vobs);

//calculo de R
	R = N;
	R = R*max(0.0, dot(N,L));
	R = 2*R;
	//R = R*N;
	R -= L;

//se procede a calcularlo todo
	//calculo luz ambiente
	vec3 Ambient = (gl_LightModel.ambient.xyz*ambLuz0);
	Ambient *= ambientMat;

	//calculo luz difusa
	vec3 diffuse = diffLuz0;
	diffuse = diffuse*max(0.0, dot(N,L));
	diffuse *= diffMat;

	//calculo luz especular
	vec3 specular = specLuz0;
	specular = specular * pow(max(0.0, dot(R,V)), NMat);
	specular *= specMat;

	vec3 FinalLuz = emissionMat + Ambient + diffuse + specular;

	gl_FragColor = vec4(FinalLuz,1);
}
