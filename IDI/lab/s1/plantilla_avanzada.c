#include <stdio.h>

#include <GL/gl.h>
#include <GL/freeglut.h>

void displayHelp(){
    printf("%s \n", "help text");
}

void refresh(void){
    glClear(GL_COLOR_BUFFER_BIT | GL_DEPTH_BUFFER_BIT);

    // glBegin(GL_TRIANGLES);
    //     glVertex3f(-0.25,0.0,0.0);
    //     glVertex3f(0.25,0.0,0.0);
    //     glVertex3f(0.0,0.5,0.0);
    // glEnd();

    glutSwapBuffers();
}

void resize(int w, int h){
    // glViewport();

    glutPostRedisplay();
}

void mousePressCtrl(int button, int state, int x, int y){

    glutPostRedisplay();
}

void mouseMotionCtrl(int x, int y){

    glutPostRedisplay();
}

void keyboardCtrl(unsigned char key, int x, int y){
    if (key == 'h') displayHelp();
    glutPostRedisplay();
}


int main(int argc, char const *argv[]){

    //inicializaciones
    glutInit(&argc, (char **) argv);
    glutInitDisplayMode(GLUT_DEPTH | GLUT_DOUBLE | GLUT_RGBA);
    glutInitWindowSize(600,600);

    glutCreateWindow("plantilla avanzada");

    //callbacks
    glutDisplayFunc(refresh);
    // glutReshapeFunc(resize);
    glutMouseFunc(mousePressCtrl);
    glutMotionFunc(mouseMotionCtrl);
    glutKeyboardFunc(keyboardCtrl);

    //bucle, procesamiento de eventos
    glutMainLoop();
    return 0;
}


