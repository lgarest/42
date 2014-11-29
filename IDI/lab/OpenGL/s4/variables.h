using namespace std;

// snowman materials
GLfloat snowMan_diffuse[3]   = {1.0, 1.0, 1.0};
GLfloat snowMan_ambient[3]   = {0.5, 0.5, 0.5};
GLfloat snowMan_specular[3]  = {0.0, 0.0, 0.0};
GLfloat snowMan_shininess[3] = {0.0, 0.0, 0.0};

GLfloat snowMan_eyes_diffuse[3]   = {0.0, 0.0, 0.0};
GLfloat snowMan_eyes_ambient[3]   = {0.0, 0.0, 0.0};
GLfloat snowMan_eyes_specular[3]  = {0.0, 0.0, 0.0};
GLfloat snowMan_eyes_shininess[3] = {0.0, 0.0, 0.0};

GLfloat snowMan_nose_diffuse[3]   = {1.0, 0.47, 0.12};
GLfloat snowMan_nose_ambient[3]   = {1.0, 0.47, 0.12};
GLfloat snowMan_nose_specular[3]  = {0.0, 0.0, 0.0};
GLfloat snowMan_nose_shininess[3] = {0.0, 0.0, 0.0};

// wall material
GLfloat wall_ambient[3]   = {0.05, 0.05, 0.05};
GLfloat wall_diffuse[3]   = {0.6, 0.298, 0.0};
GLfloat wall_specular[3]  = {0.0, 0.0, 0.0};
GLfloat wall_shininess[3] = {0.0, 0.0, 0.0};

// floor material
GLfloat floor_diffuse[3]   = {0.298,0.6,0.0};
GLfloat floor_ambient[3]   = {0.149,0.3,0.0};
GLfloat floor_specular[3]  = {0.0, 0.0, 0.0};
GLfloat floor_shininess[3] = {0.0, 0.0, 0.0};

// scene sphere material
GLfloat sphere_diffuse[3]   = {0.05,0.05,0.05};
GLfloat sphere_ambient[3]   = {0.05,0.05,0.05};
GLfloat sphere_specular[3]  = {0.0, 0.0, 0.0};
GLfloat sphere_shininess[3] = {0.0, 0.0, 0.0};

// light orb material
GLfloat light_sphere_ambient[3]   = {1.0, 1.0, 1.0};
GLfloat light_sphere_diffuse[3]   = {0.5, 0.5, 0.5};
GLfloat light_sphere_specular[3]  = {0.0, 0.0, 0.0};
GLfloat light_sphere_shininess[3] = {0.0, 0.0, 0.0};

// yellow scene light
GLfloat light0_ambient[]  = {0.0,0.0,0.0};
GLfloat light0_diffuse[]  = {0.8, 0.8, 0.0, 0.8};
GLfloat light0_specular[] = {0.8, 0.8, 0.0, 1.0};

// white camera light
GLfloat light1_ambient[]  = {0.0,0.0,0.0};
GLfloat light1_diffuse[]  = {0.8, 0.8, 0.8, 0.8};
GLfloat light1_specular[] = {0.8, 0.8, 0.8, 1.0};

// Scene light positions.
GLfloat light0_pos1[]  = {5, 0.1, 5, 1};
GLfloat light0_pos2[]  = {5, 0.1, -5, 1};
GLfloat light0_pos3[]  = {-5, 0.1, -5, 1};
GLfloat light0_pos4[]  = {-5, 0.1, 5, 1};

// Axis indicators material
GLfloat axis_specular[3]  = {0.0, 0.0, 0.0};
GLfloat axis_shininess[3] = {0.0, 0.0, 0.0};

GLfloat axis_red_ambient[3]   = {1.0, 0.0, 0.0};
GLfloat axis_red_diffuse[3]   = {1.0, 0.0, 0.0};

GLfloat axis_green_ambient[3]   = {0.0, 1.0, 0.0};
GLfloat axis_green_diffuse[3]   = {0.0, 1.0, 0.0};

GLfloat axis_blue_ambient[3]   = {0.0, 0.0, 1.0};
GLfloat axis_blue_diffuse[3]   = {0.0, 0.0, 1.0};
