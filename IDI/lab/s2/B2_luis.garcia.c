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
void display_model(Model a);

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

void display_model(Model a){
    for(int i = 0; i < a.faces().size(); ++i){
      const Face &f = a.faces()[i];
      glVertex3dv(&a.vertices()[f.v[0]]);
      glVertex3dv(&a.vertices()[f.v[1]]);
      glVertex3dv(&a.vertices()[f.v[2]]);
    }
}

void refresh(void){
    glClearColor(0.0,0.0,0.0,1.0);
    glClear(GL_COLOR_BUFFER_BIT | GL_DEPTH_BUFFER_BIT);

    glMatrixMode(GL_MODELVIEW);
    glLoadIdentity();
    glPushMatrix();
        glRotatef(anglex,0.0,1.0,0.0);
        glRotatef(angley,1.0,0.0,0.0);

        if (axis) drawAxis(0.7, 0.5);
        glColor4f(1.0, 1.0, 1.0, 1.0);

        glutWireTeapot(0.5);
        drawFloor();
    glPopMatrix();


    if (axis) drawAxis(100.0, 1.0);
    if (verbose) showVariables();
    glutSwapBuffers();
}

int main(int argc, char const *argv[]){

    //inicializaciones
    glutInit(&argc, (char **) argv);
    glutInitDisplayMode(GLUT_DEPTH | GLUT_DOUBLE | GLUT_RGBA);
    glutInitWindowSize(600,500);

    glutCreateWindow("Bloque 2: Luis García Estrades Grupo: 13");

    //callbacks
    glutDisplayFunc(refresh);
    glutReshapeFunc(resize);
    glutMouseFunc(mousePressCtrl);
    glutMotionFunc(mouseMotionCtrl);
    glutKeyboardFunc(keyboardCtrl);

    displayHelp();

    //bucle, procesamiento de eventos
    glutMainLoop();
    return 0;
}


