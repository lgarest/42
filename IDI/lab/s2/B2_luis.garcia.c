#include <stdio.h>

#include <GL/gl.h>
#include <GL/freeglut.h>
#include "../models/model.h"


GLfloat ASPECT_RATIO = 1.0;
GLint currWindowSize[2]   = { 500, 500 };
GLint currViewportSize[2] = { 500, 500 };
GLint currViewportStartPos[2] = { 0, 0 };
GLfloat bckgrndColor[3] = {0.0, 0.0, 0.0};
bool verbose = false;
bool axis = false;
GLint lastClick[2];

bool left_pressed = false;
bool teapot = true;
bool translate = false;
GLfloat anglex = 0.0;
GLfloat angley = 0.0;
Model legoman;



/***********************/
/* Function prototypes */
/***********************/
void displayHelp();
float max(float a, float b);
float min(float a, float b);
float normalize(float a);
float normalizeAngle(float a);
void drawAxis(float distance, float intensity);
void showVariables();
void resize(int w, int h);
void mousePressCtrl(int button, int state, int x, int y);
void mouseMotionCtrl(int x, int y);
void keyboardCtrl(unsigned char key, int x, int y);
void drawFloor();
void displayModel(Model a, GLfloat size, GLfloat x, GLfloat y, GLfloat z);
void displayCone(GLfloat radius, GLfloat height, GLfloat x, GLfloat y, GLfloat z);

void displayHelp(){
    printf("**************************************************************\n");
    printf("* %s \n", "Bloque 2 Luis Garcia Estrades grupo:13");
    printf("* %s \n", "'x' para mostrar/ocultar los ejes");
    printf("* %s \n", "'r' para resetear");
    printf("* %s \n", "'q' o 'esc' para cerrar el programa");
    printf("* %s \n", "'h' para mostrar esta ayuda");
    printf("* %s \n", "'v' para habilitar / deshabilitar el modo debug o verbose");
    printf("**************************************************************\n");
}

float max(float a, float b){
    if(a >= b) return a;
    return b;
}
float min(float a, float b){
    if(a >= b) return b;
    return a;
}
float normalize(float a){
    return max(min(a, 1.0), 0.0);
}
float normalizeAngle(float a){
    return max(min(a, 360.0), 0.0);
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
    printf("\n**** %s: %d \n", "translate", translate);
    printf("**** %s: %d \n", "left_pressed", left_pressed);
    printf("**** %s: %d \n", "show_axis", axis);
    printf("**** %s: (%f,%f) \n", "angle x,y", anglex, angley);
}

void resize(int w, int h){
    currWindowSize[0] = w;
    currWindowSize[1] = h;
    if (ASPECT_RATIO > w/h) {
        currViewportSize[0] = w;
        currViewportSize[1] = w / ASPECT_RATIO;
    }
    else {
        currViewportSize[1] = h;
        currViewportSize[0] = h * ASPECT_RATIO;
    }

    if (verbose) printf("**** %s: (%d-%d), %s: (%d-%d) \n", "win_h-w", h, w, "vport_h-w", currViewportSize[0], currViewportSize[1]);

    // glViewport(GLint x, GLint y, GLsizei width, GLsizei height);
    currViewportStartPos[0] = 0.5*(w-currViewportSize[0]);
    currViewportStartPos[1] = 0.5*(h-currViewportSize[1]);
    glViewport(currViewportStartPos[0],
               currViewportStartPos[1],
               currViewportSize[0],
               currViewportSize[1]);
    glutPostRedisplay();
}

void mousePressCtrl(int button, int state, int x, int y){
    left_pressed = button == GLUT_LEFT_BUTTON && state == GLUT_DOWN;

    if(!translate and left_pressed){
        lastClick[0] = x;
        lastClick[1] = y;
    }

    glutPostRedisplay();
}

void mouseMotionCtrl(int x, int y){
    if(!translate and left_pressed){
        anglex += float(x - lastClick[0]);
        angley += float(y - lastClick[1]);
        lastClick[0] = x;
        lastClick[1] = y;
    }
    glutPostRedisplay();
}

void keyboardCtrl(unsigned char key, int x, int y){
    if (verbose) printf("**** %s: %c \n", "key", key);
    switch (key){
        case 'h':
            displayHelp();
            break;
        case 'c':
            translate = !translate;
            break;
        case 'v':
            verbose = !verbose;
            break;
        case 'r':
            axis = 0;
            anglex = angley = 0.0;
            bckgrndColor[0] = bckgrndColor[1] = bckgrndColor[2] = 0.0;
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

void drawFloor(){
    glBegin(GL_QUADS);
        glColor4f(0.44,0.95,0.46,1.0);
        glVertex3f(-0.75, -0.4, -0.75);
        glVertex3f(-0.75, -0.4, 0.75);
        glVertex3f(0.75, -0.4, 0.75);
        glVertex3f(0.75, -0.4, -0.75);
    glEnd();
}

void displayModel(Model a, GLfloat size, GLfloat x, GLfloat y, GLfloat z){
    GLfloat xmin, xmax, ymin, ymax, zmin, zmax;
    GLfloat xcentral, ycentral, zcentral;
    GLfloat scalemodel;
    xmin = xmax = a.vertices()[0];
    ymin = ymax = a.vertices()[1];
    zmin = zmax = a.vertices()[2];

    for (int i = 0; i < a.vertices().size(); i+=3) {
        if(xmin>a.vertices()[i]) xmin = a.vertices()[i];
        if(xmax<a.vertices()[i]) xmax = a.vertices()[i];

        if(ymin>a.vertices()[i+1]) ymin = a.vertices()[i+1];
        if(ymax<a.vertices()[i+1]) ymax = a.vertices()[i+1];

        if(zmin>a.vertices()[i+2]) zmin = a.vertices()[i+2];
        if(zmax<a.vertices()[i+2]) zmax = a.vertices()[i+2];
    }
    // we set the central point for each model axis
    xcentral = (xmin+xmax)/2;
    ycentral = (ymin+ymax)/2;
    zcentral = (zmin+zmax)/2;
    // if(first) mz = zcentral;

    scalemodel = abs(abs(ymax) - abs(ymin));
    // if (scalemodel < abs(xmax - xmin)) scalemodel = abs(xmax - xmin);
    if (scalemodel < abs(zmax - zmin)) scalemodel = abs(zmax - zmin);
    scalemodel = size/scalemodel;

    glPushMatrix();
        // we scale model to the desired total size
        glTranslatef(0,0,0);
        glTranslatef(x,y,z);

        // rotations applied to the model
        // glRotatef(-90, 1.0, 0.0, 0.0);
        // glRotatef(90, 0.0, 1.0, 0.0);
        // glRotatef(90, 0.0, 0.0, 1.0);

        glScalef(scalemodel,scalemodel,scalemodel);
        // we translate the model to be drawn in the (0,0,0)
        glTranslatef(-xcentral,-ycentral,-zcentral);
        // now we draw the vertexs and the normals
    glBegin(GL_TRIANGLES);
        for(int i = 0; i < a.faces().size(); ++i){
            const Face &f = a.faces()[i];
            glMaterialfv(GL_FRONT, GL_AMBIENT, (GLfloat*) &Materials[f.mat].ambient);
            glMaterialfv(GL_FRONT, GL_DIFFUSE, (GLfloat*) &Materials[f.mat].diffuse);
            glMaterialfv(GL_FRONT, GL_SPECULAR, (GLfloat*) &Materials[f.mat].specular);
            glMaterialfv(GL_FRONT, GL_SHININESS, (GLfloat*) &Materials[f.mat].shininess);

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
        glScalef(radius,radius,height);
        glColor4f(1.0, 0.47, 0.12, 1.0);
        glutSolidCone(1,1,48,48);
    glPopMatrix();
}

void displaySnowMan(){
    glPushMatrix();
        // glTranslatef(x,y,z);
        // glRotatef( -90.0, 1.0, 0.0, 0.0 );
        // glScalef(radius,radius,height);
        glColor4f(1.0, 1.0, 1.0, 1.0);
        // glutSolidCone(1,1,48,48);
        glutSolidSphere(0.4, 40, 40);
        glPushMatrix();
            glTranslatef(0.0,0.6,0.0);
            glutSolidSphere(0.2, 40, 40);
        glPopMatrix();
        displayCone(0.1, 0.6, 0.1,0.6,0.0);
    glPopMatrix();
}

void refresh(void){
    glClearColor(0.0,0.0,0.0,1.0);
    glClear(GL_COLOR_BUFFER_BIT | GL_DEPTH_BUFFER_BIT);

    glMatrixMode(GL_MODELVIEW);
    glLoadIdentity();

    // scene rotation
    glRotatef(anglex,0.0,1.0,0.0);
    glRotatef(angley,1.0,0.0,0.0);

    glColor4f(0.0, 0.0, 1.0, 1.0);
    // displayModel(legoman, 0.5, -0.75, -0.15, -0.75);
    displayModel(legoman, 0.5, -0.97, -0.15, -0.65);

    glPushMatrix();
        glRotatef(90.0,0.0,0.0,1.0);
        glTranslatef(0.0, -0.4, 0.0);
        displaySnowMan();
    glPopMatrix();

    glColor4f(1.0, 0.0, 1.0, 1.0);
    glPushMatrix();
        glTranslatef(-0.75, -0.4, -0.75);
        glutWireSphere(0.01, 40, 40);
    glPopMatrix();

    glColor4f(1.0, 1.0, 1.0, 1.0);

    // glutWireTeapot(0.5);
    drawFloor();


    if (axis) drawAxis(100.0, 1.0);
    if (verbose) showVariables();
    glDepthMask(GL_TRUE);
    glutSwapBuffers();
}

int main(int argc, char const *argv[]){

    //inicializaciones
    glutInit(&argc, (char **) argv);
    glutInitDisplayMode(GLUT_DEPTH | GLUT_DOUBLE | GLUT_RGBA);
    glutInitWindowSize(600,500);

    glutCreateWindow("Bloque 2: Luis García Estrades Grupo: 13");


    legoman.load("../models/legoman.obj");
    //callbacks
    glutDisplayFunc(refresh);
    glutReshapeFunc(resize);
    glutMouseFunc(mousePressCtrl);
    glutMotionFunc(mouseMotionCtrl);
    glutKeyboardFunc(keyboardCtrl);

    displayHelp();

    // Set up depth testing.
    glEnable(GL_DEPTH_TEST);

    glEnable(GL_NORMALIZE);

    //bucle, procesamiento de eventos
    glutMainLoop();
    return 0;
}


