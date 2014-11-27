#include <stdio.h>

#include <GL/gl.h>
#include <GL/freeglut.h>
#include "../models/model.h"
#include <cmath>
#include <vector>

using namespace std;


GLfloat ASPECT_RATIO = 1.0;
GLint currWindowSize[2]   = { 600, 600 };
GLint currViewportSize[2] = { 600, 600 };
GLfloat rad_xyz[3] = { 22.0, 188.0, 0.0};
GLint lastClick[2];

GLint currViewportStartPos[2] = { 0, 0 };
GLfloat bckgrndColor[3] = {0.0, 0.0, 0.0};
bool verbose = false, axis = false, left_pressed = false, euler_look = true;
// ORTO == AXONOMETRICA != PERSPECTIVE
bool camara_ortho = false;

GLfloat trans_lego_x = -0.60;
GLfloat trans_lego_y = -0.15;

struct ModelBox {
    double xmax;
    double xmin;
    double ymax;
    double ymin;
    double zmax;
    double zmin;
    vector<double> center;
    double scale;
};

struct SceneSphere {
    double xmax;
    double xmin;
    double ymax;
    double ymin;
    double zmax;
    double zmin;
    float radius;
    float diameter;
};

struct Camera {
    GLfloat VRP[3] = {0.0, 0.0, 0.0};
    GLfloat OBS[3] = {0.0, 0.0, 0.0};
    GLfloat UP[3] = {0.0, 1.0, 0.0};
};

Model legoman;
ModelBox mb;
SceneSphere ss;
Camera cam;

void configCamera();


/***********************/
/* Auxiliar functions  */
/***********************/

float capNum(float min, float max, float n){
    if (n>=max) n = max;
    if (n<=min) n = min;
    return n;
}

void displayHelp(){
    printf("**************************************************************\n");
    printf("* %s \n", "Bloque 3 Luis Garcia Estrades grupo:13");
    printf("* %s \n", "'x' para mostrar/ocultar los ejes");
    printf("* %s \n", "'p' para cambiar entre perspectiva/axonometrica");

    printf("* %s \n", "'r' para resetear");
    printf("* %s \n", "'q' o 'esc' para cerrar el programa");
    printf("* %s \n", "'h' para mostrar esta ayuda");
    printf("* %s \n", "'v' para habilitar / deshabilitar el modo debug o verbose");
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
    printf("\n**** %s: %d ", "left_pressed", left_pressed);
    printf(" %s: %d ", "show_axis", axis);
    printf("%s %d \n", "camara_ortho", camara_ortho);
    printf("%s: %f,%f,%f ", "OBS",cam.OBS[0], cam.OBS[1], cam.OBS[2]);
    printf("%s: %f,%f,%f\n", "VRP",cam.VRP[0], cam.VRP[1], cam.VRP[2]);
    printf("%s: %f,%f,%f\n", "rad_xyz",rad_xyz[0], rad_xyz[1], rad_xyz[2]);
}

void displayFloor(){
    glBegin(GL_QUADS);
        glColor4f(0.44,0.95,0.46,1.0);
        glVertex3f(-0.75, -0.4, -0.75);
        glVertex3f(-0.75, -0.4, 0.75);
        glVertex3f(0.75, -0.4, 0.75);
        glVertex3f(0.75, -0.4, -0.75);
    glEnd();
}

void calculateSceneSphere(){
    ss.xmin = ss.zmin = -0.75;
    ss.xmax = ss.zmax = 0.75;
    ss.ymin = -0.4;
    ss.ymax = 0.8;
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
    mb.center = vector<double> (3, 0.0);
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

void displayModel(Model a, GLfloat size, GLfloat x, GLfloat y, GLfloat z){
    mb.scale = calculateScaleFactor(size);

    glPushMatrix();
        // we scale model to the desired total size

        glTranslatef(x,y,z);
        // rotations applied to the model
        glRotatef(180.,0.0,1.0,0.0);
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

void displaySnowMan(){
    glPushMatrix();
        glColor4f(1.0, 1.0, 1.0, 1.0);
        glutSolidSphere(0.4, 40, 40);
        glPushMatrix();
            glTranslatef(0.0,0.6,0.0);
            glutSolidSphere(0.2, 40, 40);
        glPopMatrix();
        displayCone(0.1, 0.2, 0.1,0.6,0.0);
    glPopMatrix();
}

/*************************/
/* Controller functions  */
/*************************/

void mousePressCtrl(int button, int state, int x, int y){
    left_pressed = button == GLUT_LEFT_BUTTON && state == GLUT_DOWN;
    if(left_pressed){
        lastClick[0] = y;
        lastClick[1] = x;
    }
    glutPostRedisplay();
}

void mouseMotionCtrl(int x, int y){
    if (left_pressed){
        rad_xyz[0] = capNum(-90.0, 90.0, rad_xyz[0] + float(y - lastClick[0]));
        rad_xyz[1] = capNum(0.0, 360.0, rad_xyz[1] + float(x - lastClick[1]));
        if (rad_xyz[1] == 360.0) rad_xyz[1] = 0.0;
        else if (rad_xyz[1] == 0.0) rad_xyz[1] = 360.0;
        lastClick[0] = y;
        lastClick[1] = x;
    }
    configCamera();
}

void keyboardCtrl(unsigned char key, int x, int y){
    if (verbose) printf("**** %s: %c \n", "key", key);
    switch (key){
        case 'h':
            displayHelp();
            break;
        case 'v':
            verbose = !verbose;
            break;
        case 'p':
            camara_ortho = !camara_ortho;
            configCamera();
            break;
        case 'r':
            camara_ortho = 0;
            rad_xyz[0] = 22.0;
            rad_xyz[1] = 188.0;
            rad_xyz[2] = 0.0;
            euler_look = true;
            configCamera();
            break;
        case 'x':
            axis = !axis;
            break;
        case 27:
        case 'q':
            exit(0);
        break;
    }
    glutPostRedisplay();
}

void configCameraPosition(){
    glMatrixMode(GL_MODELVIEW);
    glLoadIdentity();
    if(euler_look){
        glTranslatef(cam.OBS[0],cam.OBS[1],cam.OBS[2]);
        glRotatef(rad_xyz[0], 1, 0, 0);
        glRotatef(rad_xyz[1], 0, 1, 0);
        glRotatef(rad_xyz[2], 0, 0, 1);
        glTranslatef(cam.VRP[0],cam.VRP[1],cam.VRP[2]);
    }
    else if(!euler_look){
        cam.OBS[0] = cam.VRP[0] + ss.diameter * sin(rad_xyz[0]) * sin(rad_xyz[1]);
        cam.OBS[1] = cam.VRP[1] + ss.diameter * cos(rad_xyz[0]);
        cam.OBS[2] = cam.VRP[2] + ss.diameter * sin(rad_xyz[0]) * cos(rad_xyz[1]);
    }
}

void configCamera(){
    glMatrixMode(GL_PROJECTION);
    glLoadIdentity();
    ASPECT_RATIO = (float) currWindowSize[0] / (float) currWindowSize[1];
    float zNear = ss.diameter - ss.radius;
    float zFar = ss.diameter + ss.radius;
    if(camara_ortho){
        // camara axonometrica o ortogonal
        float width = ss.radius, height = ss.radius;
        if (ASPECT_RATIO >= 1) width *= ASPECT_RATIO;
        else height /= ASPECT_RATIO;
        glOrtho(-width, width, -height, height, zNear, zFar);
    }
    else{
        // camara perspectiva
        float angle = asin(ss.radius / ss.diameter);
        if (ASPECT_RATIO < 1.0) angle = atan(tan(angle) / ASPECT_RATIO);
        angle = (angle * 180) / M_PI;
        gluPerspective(2 * angle, ASPECT_RATIO, zNear, zFar);
    }

    configCameraPosition();

    glutPostRedisplay();
}

void resize(int w, int h){
    currWindowSize[0] = w;
    currWindowSize[1] = h;

    configCamera();
    glViewport(0, 0, currWindowSize[0], currWindowSize[1]);
    glutPostRedisplay();
}

void displayScene(){
    glPushMatrix();
        displayModel(legoman, 0.5, trans_lego_x, trans_lego_y, -0.67);
    glPopMatrix();

    glPushMatrix();
        displaySnowMan();
    glPopMatrix();
}

void refresh(void){
    glClearColor(0.0,0.0,0.0,1.0);

    glClear(GL_COLOR_BUFFER_BIT | GL_DEPTH_BUFFER_BIT);

    glColor4f(0.5, 0.5, 0.5, 1.0);
    glutWireSphere(ss.radius,50,50);
    displayScene();

    glColor4f(1.0, 1.0, 1.0, 1.0);
    displayFloor();

    if (axis) drawAxis(100.0, 1.0);
    if (verbose) showVariables();
    glDepthMask(GL_TRUE);
    glutSwapBuffers();
}

void iniGL(int argc, char const *argv[]){

    //inicializaciones
    glutInit(&argc, (char **) argv);
    glutInitDisplayMode(GLUT_DEPTH | GLUT_DOUBLE | GLUT_RGBA);
    glutInitWindowSize(currWindowSize[0],currWindowSize[1]);

    glutCreateWindow("Bloque 3 sesion 1: Luis García Estrades Grupo: 13");

    displayHelp();
    // Set up depth testing.
    glMatrixMode(GL_PROJECTION);
    glEnable(GL_DEPTH_TEST);
    glLoadIdentity();
    glOrtho(-1, 1, -1, 1, -1, 1);
    glMatrixMode(GL_MODELVIEW);
    legoman.load("../models/legoman.obj");

    calculateModelBox(legoman);
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


