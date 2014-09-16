#include <stdio.h>

#include <GL/gl.h>
#include <GL/freeglut.h>


GLfloat ASPECT_RATIO = 1.0;
GLint currWindowSize[2]   = { 500, 500 };
GLint currViewportSize[2] = { 500, 500 };
bool verbose = false;

void displayHelp(){
    printf("********************\n");
    printf("  %s \n", "Bloque 1 Luis García");
    printf("  %s \n", "'t' para crear un nuevo triángulo");
    printf("  %s \n", "'h' para mostrar esta ayuda");
    printf("  %s \n", "'v' para habilitar / deshabilitar el modo verbose");
    printf("********************\n");
}

void refresh(void){
    glClearColor(1.0, 1.0, 1.0, 1.0); // adapt this to the color you want
    glClear(GL_COLOR_BUFFER_BIT | GL_DEPTH_BUFFER_BIT);

    glColor4f(1.0, 1.0, 1.0, 1.0);

    // void glColor4f(GLfloat red, GLfloat green, GLfloat blue, GLfloat alpha);
    glBegin(GL_TRIANGLES);
        glColor4f(1.0, 1.0, 0.0, 1.0);
        glVertex3f(-0.25,0.0,0.0);
        glVertex3f(0.25,0.0,0.0);
        glVertex3f(0.0,0.5,0.0);
    glEnd();

    glutSwapBuffers();
}

void resize(int w, int h){
    currWindowSize[0] = w;
    currWindowSize[1] = h;
    if (ASPECT_RATIO > w/h) {
        if (verbose) printf("_%s \n", "entra1");
        currViewportSize[0] = w;
        currViewportSize[1] = w / ASPECT_RATIO;
    }
    else {
        if (verbose) printf("_%s \n", "entra2");
        currViewportSize[1] = h;
        currViewportSize[0] = h * ASPECT_RATIO;
    }

    if (verbose)
        printf("_%s: %d, %s: %d, %s: %d, %s: %d, \n", "win_height", h, "win_width", w, "viewport_height", currViewportSize[0], "viewport_width", currViewportSize[1]);

    // glViewport(GLint x, GLint y, GLsizei width, GLsizei height);
    glViewport(0.5*(w-currViewportSize[0]),
               0.5*(h-currViewportSize[1]),
               currViewportSize[0],
               currViewportSize[1]);
    glutPostRedisplay();
}

void mousePressCtrl(int button, int state, int x, int y){

    glutPostRedisplay();
}

void mouseMotionCtrl(int x, int y){

    glutPostRedisplay();
}

void keyboardCtrl(unsigned char key, int x, int y){
    switch (key){
        case 'h':
            displayHelp();
            break;
        case 'v':
            verbose = !verbose;
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
    glutInitWindowSize(500,500);

    glutCreateWindow("Bloque 1: Luis García Estrades Grupo: 13");

    //callbacks
    glutDisplayFunc(refresh);
    glutReshapeFunc(resize);
    glutMouseFunc(mousePressCtrl);
    glutMotionFunc(mouseMotionCtrl);
    glutKeyboardFunc(keyboardCtrl);

    //bucle, procesamiento de eventos
    glutMainLoop();
    return 0;
}


