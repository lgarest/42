#include <stdio.h>

#include <GL/gl.h>
#include <GL/freeglut.h>
#include "../models/model.h"
#include <cmath>
#include <vector>

using namespace std;


GLfloat ASPECT_RATIO = 1.0;
GLint WindowSize[2]   = {600, 600};
GLint currViewportSize[2] = {600, 600};
GLfloat rad_xyz[3] = {0.0, 330.0, 38.0};
GLint lastClick[2];

GLfloat bckgrndColor[3] = {0.0, 0.0, 0.0};
bool verbose=0, axis=0, l_click=0, r_click=0, euler_look=1, b_sceneSphere=0, walls=1, first_person=0;
// ORTO == AXONOMETRICA != PERSPECTIVE
bool ortho_camera=0;
float zoom_factor = 0.0;

struct ModelBox {
    float xmax;
    float xmin;
    float ymax;
    float ymin;
    float zmax;
    float zmin;
    vector<float> center;
    float scale;
};
struct FloorLimits{
    float xmax;
    float xmin;
    float zmax;
    float zmin;
};

struct SceneSphere {
    float xmax;
    float xmin;
    float ymax;
    float ymin;
    float zmax;
    float zmin;
    float radius;
    float diameter;
};

struct Camera {
    GLfloat VRP[3] = {0.0, 0.0, 0.0};
    GLfloat OBS[3] = {0.0, 0.0, 0.0};
    GLfloat UP[3] = {0.0, 1.0, 0.0};
};

struct MovableObject{
    GLfloat p[3];
    GLfloat r[3];
    GLfloat rotSpeed;
    GLfloat speed;
    GLfloat rotTaf;
};

Model m;
MovableObject patrick;
ModelBox mb;
SceneSphere ss;
Camera cam;
FloorLimits fl;

void configCamera();


/*************************************************************************/
/* Auxiliar functions  */
/*************************************************************************/

float capNum(float min, float max, float n){
    if (n>=max) n = max;
    if (n<=min) n = min;
    return n;
}

float toRads(float alpha){ return (alpha+90.0) * (M_PI/180.0); }

void rotateX(GLfloat* v, float angle){
    float phi = toRads(angle-90.0);
    vector<float> ret (3, 0.0);
    ret[0] = v[0];
    ret[1] = cos(phi)*v[1] - sin(phi)*v[2];
    ret[2] = sin(phi)*v[1] + cos(phi)*v[2];
    v[0] = ret[0];
    v[1] = ret[1];
    v[2] = ret[2];
}

void rotateY(GLfloat* v, float angle){
    float phi = toRads(angle-90.0);
    vector<float> ret (3, 0.0);
    ret[0] = cos(phi)*v[0] + sin(phi)*v[2];
    ret[1] = v[1];
    ret[2] = -sin(phi)*v[0] + cos(phi)*v[2];
    v[0] = ret[0];
    v[1] = ret[1];
    v[2] = ret[2];
}

void rotateZ(GLfloat* v, float angle){
    float phi = toRads(angle-90.0);
    vector<float> ret (3, 0.0);
    ret[0] = cos(phi)*v[0] -sin(phi)*v[1];
    ret[1] = sin(phi)*v[0] + cos(phi)*v[1];
    ret[2] = v[2];
    v[0] = ret[0];
    v[1] = ret[1];
    v[2] = ret[2];
}

void displayHelp(){
    printf("**************************************************************\n");
    printf("**************************** HELP ****************************\n");
    printf("* %s \n", "Bloque 3 Luis Garcia Estrades grupo:13");
    printf("* %s \n", "'p' para cambiar entre perspectiva/axonometrica");
    printf("* %s \n", "'c' para cambiar entre euler/gluLookAt");
    printf("* %s \n", "'t' para des/habilitar entre 1ª vista");
    printf("* %s \n", "'r' para resetear la escena");
    printf("* %s \n\n", "'v' para mostrar/ocultar las paredes");

    printf("* %s \n", "'w', 'a', 's', 'd' para mover a patrick");
    printf("* %s \n", "'n' para mostrar/ocultar la esfera de la escena");
    printf("* %s \n", "'x' para mostrar/ocultar los ejes");
    printf("* %s \n", "'q' o 'esc' para cerrar el programa");
    printf("* %s \n", "'h' para mostrar esta ayuda");
    printf("* %s \n", "'b' para habilitar / deshabilitar el modo debug o verbose");
    printf("**************************************************************\n");
}

void drawAxis(float distance, float intensity){
    // needs axis variable declared previously
    glBegin(GL_LINES);
        // x axis blue
        glColor4f(0.0, 0.0, intensity, 1.0);
        glVertex3f(-distance, 0.0, 0.0);
        glVertex3f(distance, 0.0, 0.0);

        // y axis green
        glColor4f(0.0, intensity, 0.0, 1.0);
        glVertex3f(0.0, -distance, 0.0);
        glVertex3f(0.0, distance, 0.0);

        // z axis red
        glColor4f(intensity, 0.0, 0.0, 1.0);
        glVertex3f(0.0, 0.0, -distance);
        glVertex3f(0.0, 0.0, distance);
    glEnd();
}

void showVariables(){
    printf("******************** VERBOSE MODE ****************************\n");
    if (euler_look) printf(" +Euler angles Positioning+ \n");
    else {
        printf(" +gluLookAt Positioning+ \n");
        printf(" +%s: (%f,%f,%f) ", "OBS",cam.OBS[0], cam.OBS[1], cam.OBS[2]);
        printf("%s: (%f,%f,%f)+ \n", "VRP",cam.VRP[0], cam.VRP[1], cam.VRP[2]);
    }
    if (ortho_camera) printf(" +Axonometric Camera+ \n");
    else printf(" +Perspective Camera+ \n");

    printf(" +%s: (%f,%f,%f)+ \n", "rad_xyz",rad_xyz[0], rad_xyz[1], rad_xyz[2]);
    printf(" +%s %f\n", "zoom_factor", zoom_factor);
    printf("**************************************************************\n\n");
}

void displayFloor(){
    glBegin(GL_QUADS);
        glColor4f(0.298,0.6,0.0,1.0);
        glVertex3f(-5, 0.0, -5);
        glVertex3f(-5, 0.0, 5);
        glVertex3f(5, 0.0, 5);
        glVertex3f(5, 0.0, -5);
    glEnd();
}

void calculateSceneSphere(){
    ss.xmin = ss.zmin = fl.xmin = fl.zmin = -5.0;
    ss.xmax = ss.zmax = fl.xmax = fl.zmax = 5.0;
    ss.ymin = 0.0;
    ss.ymax = 2.25;
    ss.diameter = sqrt(pow((ss.xmax-ss.xmin), 2.0) +
                       pow((ss.ymax-ss.ymin), 2.0) +
                       pow((ss.zmax-ss.zmin), 2.0));
    ss.radius = ss.diameter / 2.0;
    cam.OBS[2] = -ss.diameter;
}

void calculateModelBox(Model &m){
    mb.xmin = mb.xmax = m.vertices()[0];
    mb.ymin = mb.ymax = m.vertices()[1];
    mb.zmin = mb.zmax = m.vertices()[2];
    for (int i = 0; i < m.vertices().size(); i+=3) {
        if(mb.xmin>m.vertices()[i]) mb.xmin = m.vertices()[i];
        if(mb.xmax<m.vertices()[i]) mb.xmax = m.vertices()[i];

        if(mb.ymin>m.vertices()[i+1]) mb.ymin = m.vertices()[i+1];
        if(mb.ymax<m.vertices()[i+1]) mb.ymax = m.vertices()[i+1];

        if(mb.zmin>m.vertices()[i+2]) mb.zmin = m.vertices()[i+2];
        if(mb.zmax<m.vertices()[i+2]) mb.zmax = m.vertices()[i+2];
    }
    // we set the central point for each model axis
    mb.center = vector<float> (3, 0.0);
    mb.center[0] = (mb.xmin + mb.xmax)/2;
    mb.center[1] = (mb.ymin + mb.ymax)/2;
    mb.center[2] = (mb.zmin + mb.zmax)/2;
}

GLfloat calculateScaleFactor(GLfloat size){
    GLfloat scalemodel = abs(abs(mb.xmax) - abs(mb.xmin));
    if (scalemodel < abs(mb.ymax - mb.ymin)) scalemodel = abs(mb.ymax - mb.ymin);
    if (scalemodel < abs(mb.zmax - mb.zmin)) scalemodel = abs(mb.zmax - mb.zmin);
    return size/scalemodel;
}

void displayModel(Model a, GLfloat size, GLfloat x, GLfloat y, GLfloat z, GLfloat phi, GLfloat psi, GLfloat theta){
    mb.scale = calculateScaleFactor(size);

    glPushMatrix();
        // we scale model to the desired total size

        glTranslatef(x,y,z);
        // rotations applied to the model
        glRotatef(phi,1.0,0.0,0.0);
        glRotatef(psi,0.0,1.0,0.0);
        glRotatef(theta,0.0,0.0,0.0);

        glScalef(mb.scale,mb.scale,mb.scale);
        // we translate the model to be drawn in the (0,0,0)
        glTranslatef(-mb.center[0],-mb.center[1],-mb.center[2]);
        // now we draw the vertexs and the normals
        glBegin(GL_TRIANGLES);
            for(int i = 0; i < a.faces().size(); ++i){
                const Face &f = a.faces()[i];
                // glMaterialfv(GL_FRONT, GL_AMBIENT, (GLfloat*) &Materials[f.mat].ambient);
                // glMaterialfv(GL_FRONT, GL_DIFFUSE, (GLfloat*) &Materials[f.mat].diffuse);
                // glMaterialfv(GL_FRONT, GL_SPECULAR, (GLfloat*) &Materials[f.mat].specular);
                // glMaterialfv(GL_FRONT, GL_SHININESS, (GLfloat*) &Materials[f.mat].shininess);

                glColor4fv (Materials[f.mat].diffuse);

                if(f.n.size() == 0) {
                    glNormal3dv(a.faces()[i].normalC);
                    glVertex3dv(&a.vertices()[f.v[0]]);
                    glVertex3dv(&a.vertices()[f.v[1]]);
                    glVertex3dv(&a.vertices()[f.v[2]]);
                }
                // Otherwise we render the normals from each vertex.
                else{
                    glNormal3dv(&a.normals()[f.n[0]]);
                    glVertex3dv(&a.vertices()[f.v[0]]);

                    glNormal3dv(&a.normals()[f.n[1]]);
                    glVertex3dv(&a.vertices()[f.v[1]]);

                    glNormal3dv(&a.normals()[f.n[2]]);
                    glVertex3dv(&a.vertices()[f.v[2]]);
                }
            }
        glEnd();
    glPopMatrix();
}

void displayCone(GLfloat radius, GLfloat height, GLfloat x, GLfloat y, GLfloat z){
    glPushMatrix();
        glTranslatef(x,y,z);
        glRotatef( 90.0, 0.0, 1.0, 0.0 );
        glColor4f(1.0, 0.47, 0.12, 1.0);
        glutSolidCone(radius,height,48,48);
    glPopMatrix();
}

void displaySnowMan(float x, float y, float z){
    glPushMatrix();
        glTranslatef(x,y,z);
        glColor4f(1.0, 1.0, 1.0, 1.0);
        glutSolidSphere(0.4, 40, 40); // body
        glRotatef(-90.0, 0.0, 1.0, 0.0);
        glPushMatrix(); // head
            glTranslatef(0.0,0.6,0.0);
            glutSolidSphere(0.2, 40, 40);
        glPopMatrix();
        displayCone(0.1, 0.2, 0.1,0.6,0.0); // nose
        glColor4f(0.0, 0.0, 0.0, 1.0);
        glPushMatrix(); //eyes
            glTranslatef(0.15,0.70,-0.1);
            glutSolidSphere(0.025, 40, 40);
            glTranslatef(0.0,0.0,0.2);
            glutSolidSphere(0.025, 40, 40);
        glPopMatrix();
    glPopMatrix();
}

void displayWall(float x, float y, float z, float w, float h, float d){
    glPushMatrix();
        glColor4f(0.6, 0.298, 0.0, 1.0);
        glTranslatef(x, y + h/2.0, z);
        glScalef(w/10.0, h/10.0, d/10.0);
        glutSolidCube(10.0);
    glPopMatrix();
}

/***************************************************************************/
/* Controller functions  */
/***************************************************************************/

void mousePressCtrl(int button, int state, int x, int y){
    l_click = button == GLUT_LEFT_BUTTON && state == GLUT_DOWN;
    r_click = button == GLUT_RIGHT_BUTTON && state == GLUT_DOWN;
    if(state == GLUT_DOWN){
        lastClick[0] = y;
        lastClick[1] = x;
    }
    glutPostRedisplay();
}

void mouseMotionCtrl(int x, int y){
    if (l_click and !first_person){
        rad_xyz[2] = capNum(-89.0, 89.0, rad_xyz[2] + float(y - lastClick[0]));
        rad_xyz[1] = capNum(0.0, 360.0, rad_xyz[1] + float(x - lastClick[1]));
        if (rad_xyz[1] == 360.0) rad_xyz[1] = 0.0;
        else if (rad_xyz[1] == 0.0) rad_xyz[1] = 360.0;
    }
    if (r_click and !first_person)
        zoom_factor = capNum(-40., 40., zoom_factor + float(y-lastClick[0]));
    lastClick[0] = y;
    lastClick[1] = x;
    configCamera();
}

void movePatrick(string s){
    if (s == "forward"){
        float auxx = patrick.p[0] + sin(patrick.r[1]*M_PI/180.0) * patrick.speed;
        float auxz = patrick.p[2]+cos(patrick.r[1]*M_PI/180.0) * patrick.speed;
        patrick.p[0] = capNum(fl.xmin+0.1, fl.xmax-0.1, auxx);
        patrick.p[2] = capNum(fl.zmin+0.1, fl.zmax-0.1, auxz);
    }
    else if (s == "backwards"){
        float auxx = patrick.p[0]-sin(patrick.r[1]*M_PI/180.0) * patrick.speed;
        float auxz = patrick.p[2]-cos(patrick.r[1]*M_PI/180.0) * patrick.speed;
        patrick.p[0] = capNum(fl.xmin+0.1, fl.xmax-0.1, auxx);
        patrick.p[2] = capNum(fl.zmin+0.1, fl.zmax-0.1, auxz);
    }
    else if (s == "left"){
        patrick.r[1] = capNum(0.0, 360.0,patrick.r[1] + patrick.rotSpeed);
        if (patrick.r[1] == 360.0) patrick.r[1] = 0.0;
        else if (patrick.r[1] == 0.0) patrick.r[1] = 360.0;
    }
    else if (s == "right"){
        patrick.r[1] = capNum(0.0, 360.0,patrick.r[1] - patrick.rotSpeed);
        if (patrick.r[1] == 360.0) patrick.r[1] = 0.0;
        else if (patrick.r[1] == 0.0) patrick.r[1] = 360.0;
    }
}

void keyboardCtrl(unsigned char key, int x, int y){
    if (verbose) printf("**** %s: %c \n", "key", key);
    switch (key){
        case 'h': displayHelp(); break;
        case 27: case 'q': exit(0); break;
        case 'b': verbose = !verbose; break;
        case 'v': walls = !walls; break;
        case 'n': b_sceneSphere = !b_sceneSphere; break;
        case 'x': axis = !axis; break;
        case 'p':  ortho_camera = !ortho_camera; first_person=0; configCamera(); break;
        case 'c': first_person=0; euler_look = !euler_look; configCamera(); break;
        case 'r':
            ortho_camera = 0;
            rad_xyz[0] = zoom_factor = 0.0;
            rad_xyz[1] = 330.0;
            rad_xyz[2] = 38.0;
            cam.VRP[0] = cam.VRP[1] = cam.VRP[2] = 0.0;
            patrick.p[0] = patrick.p[2] = patrick.r[0] = patrick.r[2] = 0.0;
            patrick.p[1] = 0.5;
            patrick.r[1] = 270.0;
            patrick.speed = 0.2;
            patrick.rotSpeed = patrick.rotTaf = 6.0;
            euler_look = true;
            configCamera();
            break;
        case 'w': movePatrick("forward"); configCamera(); break;
        case 'a': movePatrick("left"); configCamera(); break;
        case 's': movePatrick("backwards"); configCamera(); break;
        case 'd': movePatrick("right"); configCamera(); break;
        case 't': first_person = !first_person; euler_look=0; ortho_camera=0; configCamera(); break;
    }
    glutPostRedisplay();
}

void configEuler(){
    glTranslatef(0.0,0.0,-ss.diameter);
    glRotatef(rad_xyz[2], 1, 0, 0);
    glRotatef(rad_xyz[1], 0, 1, 0);
    glRotatef(rad_xyz[0], 0, 0, 1);
}

void configLookAt(){
    if (first_person and !euler_look){
        gluLookAt(patrick.p[0], 1, patrick.p[2], patrick.p[0] + sin(patrick.r[1]*M_PI/180.0), 1, patrick.p[2] + cos(patrick.r[1]*M_PI/180.0), cam.UP[0], cam.UP[1], cam.UP[2]);
    }
    else{
        cam.OBS[0] = cam.VRP[2] + ss.diameter
                * sin(toRads(rad_xyz[2])) * cos(toRads(rad_xyz[1]));
        cam.OBS[1] = cam.VRP[1] + ss.diameter
            * -cos(toRads(rad_xyz[2]));
        cam.OBS[2] = cam.VRP[0] + ss.diameter
            * sin(toRads(rad_xyz[2])) * sin(toRads(rad_xyz[1]));
        gluLookAt(cam.OBS[0],cam.OBS[1],cam.OBS[2],
                  cam.VRP[0],cam.VRP[1],cam.VRP[2],
                  cam.UP[0],cam.UP[1],cam.UP[2]);
    }
}

void configCameraPosition(){
    glMatrixMode(GL_MODELVIEW);
    glLoadIdentity();
    if(euler_look) configEuler();
    else if(!euler_look) configLookAt();
}

void configCamera(){
    glMatrixMode(GL_PROJECTION);
    glLoadIdentity();
    ASPECT_RATIO = (float) WindowSize[0] / (float) WindowSize[1];
    float zNear = ss.diameter - ss.radius;
    float zFar = ss.diameter + ss.radius;

    if(ortho_camera){
        // axonometric/ortogonal camera
        float width = ss.radius, height = ss.radius;
        width += (zoom_factor*0.025);
        height += (zoom_factor*0.025);
        if (ASPECT_RATIO >= 1) width *= ASPECT_RATIO;
        else height /= ASPECT_RATIO;
        glOrtho(-width, width, -height, height, zNear, zFar);
    } else {
        // perspective camera
        float angle = asin(ss.radius / ss.diameter);
        if (ASPECT_RATIO < 1.0) angle = atan(tan(angle) / ASPECT_RATIO);
        angle = (angle * 180) / M_PI;
        if(first_person) gluPerspective(2 * angle, ASPECT_RATIO, 0.1, zFar);
        else gluPerspective(2 * angle + zoom_factor, ASPECT_RATIO, zNear, zFar);
    }

    configCameraPosition();

    glutPostRedisplay();
}

void resize(int w, int h){
    WindowSize[0] = w;
    WindowSize[1] = h;
    configCamera();
    glViewport(0, 0, WindowSize[0], WindowSize[1]);
    glutPostRedisplay();
}

void displayScene(){
    if (b_sceneSphere){
        glColor4f(0.05, 0.05, 0.05, 1.0);
        glutWireSphere(ss.radius,50,50);
    }
    displayModel(m, 1.5, 2.5, 0.75, 2.5, 0.0, 0.0, 0.0);

    displayModel(m, 1.0, patrick.p[0], patrick.p[1], patrick.p[2],
        patrick.r[0], patrick.r[1], patrick.r[2]);

    displaySnowMan(2.5,0.4,-2.5);
    displaySnowMan(-2.5,0.4,2.5);
    displaySnowMan(-2.5,0.4,-2.5);
    if (walls){
        displayWall(0.0,0.0,-4.9,10.0,1.5,0.2);
        displayWall(1.5,0.0,2.5,0.2,1.5,4);
    }
    // GLfloat aux[3] = {0.,0.,-2.};
    // rotateX(aux, 45.0);
    // printf("%s: (%f,%f,%f)+ \n", "aux",aux[0], aux[1], aux[2]);

    glColor4f(1.0, 1.0, 1.0, 1.0);
    displayFloor();
}

void refresh(void){
    glClearColor(0.0,0.0,0.0,1.0);
    glClear(GL_COLOR_BUFFER_BIT | GL_DEPTH_BUFFER_BIT);

    displayScene();

    if (axis) drawAxis(100.0, 1.0);
    if (verbose) showVariables();
    glDepthMask(GL_TRUE);
    glutSwapBuffers();
}

void iniGL(int argc, char const *argv[]){

    // inicializations
    glutInit(&argc, (char **) argv);
    glutInitDisplayMode(GLUT_DEPTH | GLUT_DOUBLE | GLUT_RGBA);
    glutInitWindowSize(WindowSize[0],WindowSize[1]);
    glutCreateWindow("Bloque 3 sesion 2: Luis García Estrades Grupo: 13");
    displayHelp();

    // Set up depth testing.
    glEnable(GL_DEPTH_TEST);
    m.load("../models/Patricio.obj");
    patrick.p[0] = patrick.p[2] = 0.0;
    patrick.p[1] = 0.5;

    patrick.r[0] = patrick.r[2] = 0.0;
    patrick.r[1] = 270.0;
    patrick.speed = 0.2;
    patrick.rotSpeed = patrick.rotTaf = 6.0;

    calculateModelBox(m);
    calculateSceneSphere();

    // glEnable(GL_NORMALIZE);
}

int main(int argc, char const *argv[]){

    iniGL(argc, argv);

    //callbacks
    glutDisplayFunc(refresh);
    glutMotionFunc(mouseMotionCtrl);
    glutMouseFunc(mousePressCtrl);
    glutKeyboardFunc(keyboardCtrl);
    glutReshapeFunc(resize);

    glutMainLoop();
    return 0;
}


