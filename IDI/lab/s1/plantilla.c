#include <GL/gl.h>
#include <GL/freeglut.h>

void refresh(void){
    glClear(GL_COLOR_BUFFER_BIT | GL_DEPTH_BUFFER_BIT);
    /*

    */
    glutSwapBuffers();
}

void resize(int w, int h){
    /*                */
    glutPostRedisplay();
}

int main(int argc, char const *argv[]){

    //inicializaciones
    glutInit(&argc, (char **) argv);
    glutInitDisplayMode(GLUT_DEPTH | GLUT_DOUBLE | GLUT_RGBA);
    glutInitWindowSize(600,600);

    glutCreateWindow("titulo");

    //callbacks
    glutDisplayFunc(refresh);
    // glutReshapeFunc(resize);

    //bucle, procesamiento de eventos
    glutMainLoop();
    return 0;
}


