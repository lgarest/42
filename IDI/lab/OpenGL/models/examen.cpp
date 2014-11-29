#if defined(_WIN32)
    #include "glut.h"
    #include <windows.h>
#elif defined __APPLE__
  #include <OpenGL/OpenGL.h>
  #include <GLUT/glut.h>
#else
    #include <GL/gl.h>
    #include <GL/freeglut.h>
#endif
using namespace std;

#include <iostream>
#include <math.h>
#include "model.h"

// Angles variables.
const GLfloat PI = 3.1415926535;
const GLfloat VIEWER_ANGLE_INCREMENT = PI / 60.0;
GLfloat viewerAzimuth = 0.8;
GLfloat viewerZenith  = 1.3;
GLfloat ViewerDistance = 15;

// Viewport & window variables.
const GLfloat ASPECT_RATIO = 2;
GLint INIT_WINDOW_POSITION[2] = { 150, 150 };
GLint WindowSize[2]   = { 750, 750 / ASPECT_RATIO };
GLint ViewportSize[2] = { 750, 750 / ASPECT_RATIO };
int lastx, lasty;

// Camera position variables.
GLfloat OBS[] = { 7.0, 7.0, 7.0 };
GLfloat VRP[] = { 0.0,0.0,0.0 };
GLfloat CR[] = { 0.0, 1.0, 0.020 };

// Lights related variables.
GLint scene_camera_position = 0;
const GLfloat LIGHT_AMBIENT[]       = { 0.001, 0.001, 0.001, 1.0};
const GLfloat LIGHT_DIFFUSE[]       = { 1.0, 1.0, 1.0, 1.0};
const GLfloat LIGHT_SPECULAR[]      = { 0.8, 0.8, 0.8, 1.0};

// Scene light positions0
GLfloat LIGHT_0_POSITION_0[]  = {4.0,7.0,0.0, 1};
;

Model m;

// Program modes variables.
bool scene_light = true, help_menu = true, first = true, verbose = false, click = false;
GLfloat mz = 0;


// Functions declarations.
void Keyboard_Press(unsigned char pressedKey, int mouseX, int mouseY);
// void NonASCIIKeyboard_Press(int pressedKey, int mouseX, int mouseY);
void Resize_Window(int w, int h);
void Help_Display();
void Set_Lights();
void Update_Light();
void Config_Camera();
void Display();
void Display_Cone(GLfloat radius, GLfloat height, GLfloat x, GLfloat y, GLfloat z);
void Display_Model(Model a, GLfloat size, GLfloat x, GLfloat y, GLfloat z);
void Display_Floor(GLfloat x, GLfloat z);
void Mouse_EventHandler(int button, int event, int x, int y);
void MouseDrag_EventHandler(int x, int y);

void Keyboard_Press(unsigned char pressedKey, int mouseX, int mouseY){
    char pressedChar = char(pressedKey);
    switch(pressedKey){
        case 'd':
            //+1 z+
            mz += 1;
            break;

        case 'e':
            //+1 z-
            mz -= 1;
        break;

        case 'r':
        //reset

            break;
        case 'f':
            scene_light = !scene_light;
            break;
        case 27:
            if (verbose) cout << "Bye!" <<endl;
            exit(0);
            break;
        case 'q':
            if (verbose) cout << "Bye!" <<endl;
            exit(0);
            break;
        case 'Z':
            if (ViewerDistance > 1)
                ViewerDistance -= 1;
            break;
        case 'z':
        if (ViewerDistance < 15)
            ViewerDistance += 1;
            break;
    }
    glutPostRedisplay();
}

// void Euler(){
//     glTranslatef(0.0f, 0.0f, -EyeDist);
//     glRotatef(-phi, 0.0f, 0.0f, 1.0f);
//     glRotatef(theta, 1.0f, 0.0f, 0.0f);
//     glRotatef(-psi, 0.0f, 1.0f, 0.0f);
//     glTranslatef(-VRP.x, -VRP.y, -VRP.z);
// }

//check
void Resize_Window(int w, int h) {
    WindowSize[0] = w;
    WindowSize[1] = h;
    if (ASPECT_RATIO > w/h) {
        ViewportSize[0] = w;
        ViewportSize[1] = w / ASPECT_RATIO;
    }
    else {
        ViewportSize[0] = h * ASPECT_RATIO;
        ViewportSize[1] = h;
    }
    // x, y, GLsizei width, GLsizei height
    glViewport(0.5*(w-ViewportSize[0]), 0.5*(h-ViewportSize[1]), ViewportSize[0], ViewportSize[1]);
}

void Help_Display(){
    help_menu = false;
    cout << "-----------------ZOOM & INFO CONTROLS-----------------"<<endl;
    cout << "|'d' to move +z the dolphin and the scene light.     |"<<endl;
    cout << "|'e' to move -z the dolphin and the scene light.     |"<<endl;
    cout << "|'f' to toggle scene light.                          |"<<endl;
    cout << "| Drag the mouse to rotate.                          |"<<endl;
    cout << "------------------------------------------------------"<<endl;
}

//check
void Set_Lights(){
    glEnable(GL_LIGHTING);
    glLightfv(GL_LIGHT0, GL_AMBIENT,  LIGHT_AMBIENT);
    glLightfv(GL_LIGHT0, GL_DIFFUSE,  LIGHT_DIFFUSE);
    glLightfv(GL_LIGHT0, GL_SPECULAR, LIGHT_SPECULAR);
    glLightfv(GL_LIGHT0, GL_POSITION, LIGHT_0_POSITION_0);
}

//check
void Update_Light(){
    glPushMatrix();
        glLoadIdentity();
            LIGHT_0_POSITION_0[2] = mz; // glTranslatef(0,0,1);
            glLightfv(GL_LIGHT0, GL_POSITION, LIGHT_0_POSITION_0);
    glPopMatrix();

    if (scene_light) glEnable(GL_LIGHT0);
    else glDisable(GL_LIGHT0);
    // Draw_Light(LIGHT_0_POSITION_0[0],LIGHT_0_POSITION_0[1],LIGHT_0_POSITION_0[2]);
}

//check?
void Config_Camera(){
    // Set up the properties of the viewing camera.
    glMatrixMode(GL_PROJECTION);
    glLoadIdentity();
        // left, right, bottom, top, znear, zfar
        GLfloat aux = 1.0 * 8;
        glOrtho(-aux*ASPECT_RATIO, aux*ASPECT_RATIO, -aux, aux, 0.1, 100);

    glClear(GL_COLOR_BUFFER_BIT | GL_DEPTH_BUFFER_BIT);
    OBS[0] = VRP[0] + ViewerDistance * sin(viewerZenith) * sin(viewerAzimuth);
    OBS[1] = VRP[1] + ViewerDistance * cos(viewerZenith);
    OBS[2] = VRP[2] + ViewerDistance * sin(viewerZenith) * cos(viewerAzimuth);
    // Position and orient viewer.
    gluLookAt(
        OBS[0], OBS[1], OBS[2],
        VRP[0], VRP[1], VRP[2],
        CR[0],CR[1],CR[2]);
    glMatrixMode(GL_MODELVIEW);
}

void Display(){
    if(help_menu) Help_Display();
    glClearColor(0.0, 0.0, 0.0, 0.0);
    Config_Camera();
    glClear(GL_COLOR_BUFFER_BIT | GL_DEPTH_BUFFER_BIT);

    // Render scene.
    Update_Light();
    glLoadIdentity();
    Display_Model(m, 5, 4, 2.5, 0);

    Display_Floor(10.0,10.0);
    Display_Cone(2,6,0,0,0);

    glDepthMask(GL_TRUE);
    glutSwapBuffers();
    // glFlush();
}

//check
void Display_Cone(GLfloat radius, GLfloat height, GLfloat x, GLfloat y, GLfloat z){
    GLfloat color[] = {1.0,0.0,0.0};
    glMaterialfv(GL_FRONT_AND_BACK, GL_AMBIENT, color);
    glMaterialfv(GL_FRONT_AND_BACK, GL_DIFFUSE, color);
    glMaterialfv(GL_FRONT_AND_BACK, GL_SPECULAR, color);
    glPushMatrix();
        glTranslatef(x,y,z);
        glRotatef( -90.0, 1.0, 0.0, 0.0 );
        glScalef(radius,radius,height);
        glutSolidCone(1,1,48,48);
    glPopMatrix();
}

//check
void Display_Model(Model a, GLfloat size, GLfloat x, GLfloat y, GLfloat z){
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
        glTranslatef(0,0,mz);
        glTranslatef(x,y,z);
        glRotatef(-90, 1.0, 0.0, 0.0);
        glRotatef(90, 0.0, 0.0, 1.0);
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

//check
void Display_Floor(GLfloat x, GLfloat z){
    GLfloat color[] = {0.0,0.0,1.0};
    glMaterialfv(GL_FRONT_AND_BACK, GL_AMBIENT, color);
        glMaterialfv(GL_FRONT_AND_BACK, GL_DIFFUSE, color);
        glMaterialfv(GL_FRONT_AND_BACK, GL_SPECULAR, color);
        // glMaterialfv(GL_FRONT_AND_BACK, GL_SHININESS, (GLfloat*) &Materials[f.mat].shininess);
    // TOP
    glBegin(GL_POLYGON);
        glNormal3f(0,1,0);
        glVertex3f(x/2,0,-z/2);
        glVertex3f(x/2,0,z/2);
        glVertex3f(-x/2,0,z/2);
        glVertex3f(-x/2,0,-z/2);
    glEnd();
}

void Mouse_EventHandler(int button, int event, int x, int y){
    if (button == GLUT_LEFT_BUTTON and event == GLUT_DOWN){
        lastx = x;
        lasty = y;
        click = true;
    }
    else click = false;
}

void MouseDrag_EventHandler(int x, int y){
    if (click){
        GLfloat dragx, dragy;

        dragx = (x-lastx)*-0.01;
        dragy = (y-lasty)*-0.01;

        viewerZenith  += dragy;
        if (viewerZenith < dragy)
            viewerZenith = dragy;

        viewerAzimuth += dragx;
        if (viewerZenith > PI - dragx)
            viewerZenith = PI - dragx;



        lastx = x;
        lasty = y;
    }
    glutPostRedisplay();
}

int main(int argc, char** argv){
    glutInit (&argc, argv);
    cout << "------------------------------------------------------"<<endl;
    cout << "|   Luis Garcia Estrades Examen OpenGL.  |" << endl;

    // Set up the display window.
    glutInitDisplayMode( GLUT_DOUBLE | GLUT_RGBA | GLUT_STENCIL | GLUT_DEPTH );
    glutInitWindowPosition( INIT_WINDOW_POSITION[0]+400, INIT_WINDOW_POSITION[1]-50);
    glutInitWindowSize( WindowSize[0], WindowSize[1] );
    glutCreateWindow( "IDI: Examen OpenGL  - Luis Garcia Estrades" );

    // Load the model
    m.load("dolphin.obj");
    // m.load("../bloc4/models/HomerProves.obj");

    // Specify the resizing and refreshing routines.
    glutReshapeFunc(Resize_Window);
    glutKeyboardFunc(Keyboard_Press);
    // glutSpecialFunc(NonASCIIKeyboard_Press);
    glutDisplayFunc(Display);
    glutMouseFunc(Mouse_EventHandler);
    glutMotionFunc(MouseDrag_EventHandler);

    // Set up depth testing.
    glEnable(GL_DEPTH_TEST);
    // Configure the lights.
    Set_Lights();

    glEnable(GL_NORMALIZE);
    glutMainLoop();
    return 0;
}
