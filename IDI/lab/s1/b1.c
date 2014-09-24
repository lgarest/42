#include <stdio.h>

#include <GL/gl.h>
#include <GL/freeglut.h>


GLfloat ASPECT_RATIO = 1.0;
GLint currWindowSize[2]   = { 500, 500 };
GLint currViewportSize[2] = { 500, 500 };
GLint currViewportStartPos[2] = { 0, 0 };
bool verbose = false;
bool axis = false;
bool new_triangle = false;
bool button_pressed = false;
GLfloat p1[2] = {0.0, 0.0};
GLfloat p2[2] = {0.0, 0.0};
GLfloat p3[2] = {0.0, 0.0};
int triangleCounter = 0;

void displayHelp(){
    printf("********************\n");
    printf("  %s \n", "Bloque 1 Luis García");
    printf("  %s \n", "'t' para crear un nuevo triángulo");
    printf("  %s \n", "'x' para mostrar/ocultar los ejes");
    printf("  %s \n", "'r' para resetear");
    printf("  %s \n", "'q' o 'esc' para cerrar el programa");
    printf("  %s \n", "'h' para mostrar esta ayuda");
    printf("  %s \n", "'v' para habilitar / deshabilitar el modo verbose");
    printf("********************\n");
}

void drawAxis(){
    // needs axis variable declared previously
    glBegin(GL_LINES);
        // x axis blue
        glColor4f(0.0, 0.0, 1.0, 1.0);
        glVertex3f(-100.0, 0.0, 0.0);
        glVertex3f(100.0, 0.0, 0.0);

        // y axis green
        glColor4f(0.0, 1.0, 0.0, 1.0);
        glVertex3f(0.0, -100.0, 0.0);
        glVertex3f(0.0, 100.0, 0.0);

        // z axis red
        glColor4f(1.0, 0.0, 0.0, 1.0);
        glVertex3f(0.0, 0.0, -100.0);
        glVertex3f(0.0, 0.0, 100.0);
    glEnd();
}

void refresh(void){
    // glClearColor(1.0, 1.0, 1.0, 1.0); // adapt this to the color you want
    glClear(GL_COLOR_BUFFER_BIT | GL_DEPTH_BUFFER_BIT);

    // void glColor4f(GLfloat red, GLfloat green, GLfloat blue, GLfloat alpha);

    // printf("\n REFRESH");
    if (new_triangle and triangleCounter == 3){
        glBegin(GL_TRIANGLES);
            glColor4f(1.0, 0.0, 0.0, 1.0);
            glVertex3f(p1[0], p1[1], 0.0);
            glVertex3f(p2[0], p2[1], 0.0);
            glVertex3f(p3[0], p3[1], 0.0);
        glEnd();
    }
    else if (new_triangle and triangleCounter == 2){
        glBegin(GL_LINES);
            glColor4f(1.0, 0.0, 0.0, 1.0);
            glVertex3f(p1[0], p1[1], 0.0);
            glVertex3f(p2[0], p2[1], 0.0);
        glEnd();
    }
    else if (!new_triangle){
        glBegin(GL_TRIANGLES);
            glColor4f(1.0, 0.0, 0.0, 1.0);
            glVertex3f(-1.0/2.0,-1.0/3.0,0.0);
            glVertex3f(1.0/2.0,-1.0/3.0,0.0);
            glVertex3f(0.0,2.0/3.0,0.0);
        glEnd();
    }
    if (axis) drawAxis();
    glutSwapBuffers();
}

void resize(int w, int h){
    currWindowSize[0] = w;
    currWindowSize[1] = h;
    if (ASPECT_RATIO > w/h) {
        if (verbose) printf("_%s \n", "largo");
        currViewportSize[0] = w;
        currViewportSize[1] = w / ASPECT_RATIO;
    }
    else {
        if (verbose) printf("_%s \n", "ancho");
        currViewportSize[1] = h;
        currViewportSize[0] = h * ASPECT_RATIO;
    }

    if (verbose) printf("_%s: (%d-%d), %s: (%d-%d), \n", "win_h-w", h, w, "vport_h-w", currViewportSize[0], currViewportSize[1]);

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
    // entra al hacer click y al salir
    button_pressed = !button_pressed;
    if (new_triangle and button_pressed){
        if (triangleCounter == 0){
            p1[0] = (x - (currWindowSize[0]/2.0))/(currViewportSize[0]/2.0);
            p1[1] = (y - currWindowSize[1]/2.0)/-(currViewportSize[1]/2.0);
            triangleCounter++;
        }
        else if (triangleCounter == 1){
            p2[0] = (x - (currWindowSize[0]/2.0))/(currViewportSize[0]/2.0);
            p2[1] = (y - currWindowSize[1]/2.0)/-(currViewportSize[1]/2.0);
            triangleCounter++;
        }
        else if (triangleCounter == 2){
            p3[0] = (x - (currWindowSize[0]/2.0))/(currViewportSize[0]/2.0);
            p3[1] = (y - currWindowSize[1]/2.0)/-(currViewportSize[1]/2.0);
            triangleCounter++;
        }
    }
    glutPostRedisplay();
}

void mouseMotionCtrl(int x, int y){
    printf("motion \n");
    printf("x %d \n", x);
    printf("y %d \n", y);
    glutPostRedisplay();
}

void keyboardCtrl(unsigned char key, int x, int y){
    switch (key){
        case 'h':
            displayHelp();
            break;
        case 't':
            triangleCounter = 0;
            if (!new_triangle)
                new_triangle = !new_triangle;
            break;
        case 'v':
            verbose = !verbose;
            printf("_verbose mode %d \n", verbose);
            break;
        case 'r':
            triangleCounter = 0;
            new_triangle = false;
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


int main(int argc, char const *argv[]){

    //inicializaciones
    glutInit(&argc, (char **) argv);
    glutInitDisplayMode(GLUT_DEPTH | GLUT_DOUBLE | GLUT_RGBA);
    glutInitWindowSize(600,500);

    glutCreateWindow("Bloque 1: Luis García Estrades Grupo: 13");

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


