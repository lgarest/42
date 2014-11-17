#include <stdio.h>

#include <GL/gl.h>
#include <GL/freeglut.h>
#include "model.h"
#include <cmath>
#include <vector>
#include "variables.h"

using namespace std;

/*************************************************************************/
/* Global variables  */
/*************************************************************************/

GLfloat aspect_ratio = 1.0;
GLint window_size[2] = {600, 600};
GLfloat rad_xyz[3] = {0., 0., 0.0}; // camera rotation angles
GLint last_click[2];

bool verbose = 0;         // verbose or debug mode
bool axis = 0;            // axis display
bool l_click = 0;         // left click
bool r_click = 0;         // right click
bool b_sceneSphere = 0;   // display scene sphere
bool walls = 1;           // display walls

// Camera settings
bool euler_look = 1;      // 1 = euler / 0 = LookAt positioning
bool first_person = 0;    // little Patrick first person look
bool ortho_camera = 0;    // 0 = ortho = axonometric / 1 = perspective camera
float zoom_factor = 0.0;  // camera zoom factor
float pan_increment = 0.25;

// Lighting & materials settings
bool lighting = 1;        // overall lighting
bool camera_light = 1;    // camera light
bool scene_light = 0;     // scene light
GLint scene_light_position = 0; // scene light position
bool patrick_light = 0;   // little Patrick light
bool per_vertex = 1;      // rasterization of normals per vertex

// Data structures
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
    GLfloat VRP[3] = {0., 0., 0.0};
    GLfloat OBS[3] = {0., 0., 0.0};
    GLfloat UP[3] = {0., 1., 0.0};
    GLfloat visionVector[3] = {0., 0., 0.0};
    GLfloat panX[3] {0., 0., 0.0};
    GLfloat panY[3] {0., 0., 0.0};
    GLfloat panIncXY[2] = {0.,0.0};
    GLfloat panIncEulerXY[2] = {0.,0.0};
};

struct MovableObject{
    // the 4th component is used to set the movable object light to be dot type lighting
    GLfloat p[4];
    GLfloat r[3];
    GLfloat rotSpeed;
    GLfloat speed;
    GLfloat rotTaf;
};

// Initial instantiation
Model m;
MovableObject patrick;
ModelBox mb;
SceneSphere ss;
Camera cam;
FloorLimits fl;

// function prototype (needs to be defined here to be called correctly)
void configCamera();


/*************************************************************************/
/* Calculation functions  */
/*************************************************************************/

void vectorialMult(GLfloat* v, GLfloat a[], GLfloat b[]){
    v[0] = (a[1] * b[2]) - (a[2] * b[1]);
    v[1] = ((a[0] * b[2]) - (a[2] * b[0])) * -1.0;
    v[2] = (a[0] * b[1]) - (a[1] * b[0]);
}

float capNum(float min, float max, float n, bool circular){
    if (n >= max) n = max;
    if (n <= min) n = min;
    if (circular and n == max) n = min;
    else if (circular and n == min) n = max;
    return n;
}

float toRads(float alpha, float angle){return (alpha + angle) * (M_PI /180.0);}

void rotateX(GLfloat* v, float angle){
    float phi = toRads(angle,0.0);
    vector<float> ret (3, 0.0);
    ret[0] = v[0];
    ret[1] = cos(phi) * v[1] - sin(phi) * v[2];
    ret[2] = sin(phi) * v[1] + cos(phi) * v[2];
    v[0] = ret[0];
    v[1] = ret[1];
    v[2] = ret[2];
}

void rotateY(GLfloat* v, float angle){
    float phi = toRads(angle,0.0);
    vector<float> ret (3, 0.0);
    ret[0] = cos(phi) * v[0] + sin(phi) * v[2];
    ret[1] = v[1];
    ret[2] = -sin(phi) * v[0] + cos(phi) * v[2];
    v[0] = ret[0];
    v[1] = ret[1];
    v[2] = ret[2];
}

void rotateZ(GLfloat* v, float angle){
    float phi = toRads(angle,0.0);
    vector<float> ret (3, 0.0);
    ret[0] = cos(phi) * v[0] - sin(phi) * v[1];
    ret[1] = sin(phi) * v[0] + cos(phi) * v[1];
    ret[2] = v[2];
    v[0] = ret[0];
    v[1] = ret[1];
    v[2] = ret[2];
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
    if (scalemodel < abs(mb.ymax - mb.ymin))
        scalemodel = abs(mb.ymax - mb.ymin);
    if (scalemodel < abs(mb.zmax - mb.zmin))
        scalemodel = abs(mb.zmax - mb.zmin);
    return size/scalemodel;
}

void reset(){
    // camera resets
    ortho_camera = first_person = false;
    euler_look = true;
    cam.panIncXY[0] = cam.panIncXY[1] = 0.0;
    cam.panIncEulerXY[0] = cam.panIncEulerXY[1] = 0.0;
    rad_xyz[0] = 0.0;
    rad_xyz[1] = 0.0;
    rad_xyz[2] = 0.0;
    zoom_factor = 0.0;
    cam.VRP[0] = cam.VRP[1] = cam.VRP[2] = 0.0;

    // patrick resets
    patrick.p[0] = 0.0;
    patrick.p[1] = 0.5;
    patrick.p[2] = 0.0;

    patrick.r[0] = 0.0;
    patrick.r[1] = 270.0;
    patrick.r[2] = 0.0;
    patrick.speed = 0.2;
    patrick.rotSpeed = patrick.rotTaf = 6.0;

    walls = true;
    // lighting resets
    scene_light = patrick_light = scene_light_position = 0;
    camera_light = lighting = 1;
}

/*************************************************************************/
/* Output functions  */
/*************************************************************************/

void showHelp(){
    printf("**************************************************************\n");
    printf("**************************** HELP ****************************\n");
    printf("*         Bloque 4 Luis Garcia Estrades grupo:13             *\n");

    printf("  %s \n", "'w', 'a', 's', 'd' mueve a patrick");
    printf("  %s \n", "'0' habilita/deshabilita luz de escena");
    printf("  %s \n", "'1' habilita/deshabilita luz de camara");
    printf("  %s \n", "'2' habilita/deshabilita luz de patricio");
    printf("  %s \n", "'i' habilita/deshabilita la iluminación");
    printf("  %s \n\n", "'m' mueve la luz de escena");

    printf("  %s \n", "'p' cambia entre camara perspectiva/axonometrica");
    printf("  %s \n", "'c' cambia el posicinamiento de la camara\n         entre euler/gluLookAt");
    printf("  %s \n", "'t' habilita/deshabilita la 1ª vista\n         desde patricio (camara perspectiva)");
    printf("  %s \n\n", "'v' muestra/oculta las paredes");

    printf("  %s \n", "'r' resetea la escena");
    printf("  %s \n", "'N' muestra/oculta la esfera de la escena");
    printf("  %s \n", "'x' muestra/oculta los ejes");
    printf("  %s \n", "'V' habilita/deshabilita el modo debug o verbose");
    printf("  %s \n", "'h' muestra esta ayuda");
    printf("  %s \n", "'q' o 'esc' cierra el programa");
    printf("*                                                            *\n");
    printf("**************************************************************\n");
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

/*************************************************************************/
/* Scene display functions  */
/*************************************************************************/

void displayAxis(float distance, float intensity){
    // needs axis variable declared previously

    glMaterialfv(GL_FRONT, GL_SPECULAR, axis_specular);
    glMaterialfv(GL_FRONT, GL_SHININESS, axis_shininess);
    glBegin(GL_LINES);
        // x axis blue
        glMaterialfv(GL_FRONT, GL_AMBIENT, axis_blue_ambient);
        glMaterialfv(GL_FRONT, GL_DIFFUSE, axis_blue_diffuse);
        glColor4f(0., 0., intensity, 1.0);
        glVertex3f(-distance, 0., 0.0);
        glVertex3f(distance, 0., 0.0);

        // y axis green
        glMaterialfv(GL_FRONT, GL_AMBIENT, axis_green_ambient);
        glMaterialfv(GL_FRONT, GL_DIFFUSE, axis_green_diffuse);
        glColor4f(0., intensity, 0., 1.0);
        glVertex3f(0., -distance, 0.0);
        glVertex3f(0., distance, 0.0);

        // z axis red
        glMaterialfv(GL_FRONT, GL_AMBIENT, axis_red_ambient);
        glMaterialfv(GL_FRONT, GL_DIFFUSE, axis_red_diffuse);
        glColor4f(intensity, 0., 0., 1.0);
        glVertex3f(0., 0., -distance);
        glVertex3f(0., 0., distance);
    glEnd();
}

void displayFloor(){
    glBegin(GL_QUADS);
        glMaterialfv(GL_FRONT, GL_AMBIENT, floor_ambient);
        glMaterialfv(GL_FRONT, GL_DIFFUSE, floor_diffuse);
        glMaterialfv(GL_FRONT, GL_SPECULAR, floor_specular);
        glMaterialfv(GL_FRONT, GL_SHININESS, floor_shininess);
        glNormal3f(0., 1., 0.0);
        glVertex3f(-5, 0., -5);
        glVertex3f(-5, 0., 5);
        glVertex3f(5, 0., 5);
        glVertex3f(5, 0., -5);
    glEnd();
}

void displayModel(Model a, GLfloat size, GLfloat x, GLfloat y, GLfloat z, GLfloat phi, GLfloat psi, GLfloat theta){
    mb.scale = calculateScaleFactor(size);

    glPushMatrix();

        glTranslatef(x,y,z);
        // rotations applied to the model
        glRotatef(phi, 1., 0., 0.0);
        glRotatef(psi, 0., 1., 0.0);
        glRotatef(theta, 0., 0., 0.0);

        // we scale model to the desired total size
        glScalef(mb.scale, mb.scale, mb.scale);
        // we translate the model to be drawn in the (0, 0, 0)
        glTranslatef(-mb.center[0], -mb.center[1], -mb.center[2]);
        // now we draw the vertexs and the normals
        glBegin(GL_TRIANGLES);
            glPolygonMode(GL_FRONT_AND_BACK, GL_FILL);
            for(int i = 0; i < a.faces().size(); ++i){
                const Face &f = a.faces()[i];
                glMaterialfv(GL_FRONT, GL_AMBIENT, (GLfloat*) &Materials[f.mat].ambient);
                glMaterialfv(GL_FRONT, GL_DIFFUSE, (GLfloat*) &Materials[f.mat].diffuse);
                glMaterialfv(GL_FRONT, GL_SPECULAR, (GLfloat*) &Materials[f.mat].specular);
                glMaterialfv(GL_FRONT, GL_SHININESS, (GLfloat*) &Materials[f.mat].shininess);
                // If we render the normals per face
                if (f.n.size() == 0){
                    glNormal3dv(a.faces()[i].normalC);
                    glVertex3dv(&a.vertices()[f.v[0]]);
                    glVertex3dv(&a.vertices()[f.v[1]]);
                    glVertex3dv(&a.vertices()[f.v[2]]);
                }
                // Otherwise we render the normals per vertex
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
    glMaterialfv(GL_FRONT, GL_AMBIENT, snowMan_nose_ambient);
    glMaterialfv(GL_FRONT, GL_DIFFUSE, snowMan_nose_diffuse);
    glMaterialfv(GL_FRONT, GL_SPECULAR, snowMan_nose_specular);
    glMaterialfv(GL_FRONT, GL_SHININESS, snowMan_nose_shininess);
    glPushMatrix();
        glTranslatef(x, y, z);
        glRotatef(90., 0., 1., 0.0);
        glutSolidCone(radius, height, 48, 48);
    glPopMatrix();
}

void displaySnowMan(float x, float y, float z){

    glMaterialfv(GL_FRONT, GL_AMBIENT, snowMan_ambient);
    glMaterialfv(GL_FRONT, GL_DIFFUSE, snowMan_diffuse);
    glMaterialfv(GL_FRONT, GL_SPECULAR, snowMan_specular);
    glMaterialfv(GL_FRONT, GL_SHININESS, snowMan_shininess);
    glPushMatrix();
        glTranslatef(x,y,z);
        glutSolidSphere(0.4, 40, 40); // body
        glRotatef(-90., 0., 1., 0.0);
        glPushMatrix(); // head
            glTranslatef(0., 0.6, 0.0);
            glutSolidSphere(0.2, 40, 40);
        glPopMatrix();
        displayCone(0.1, 0.2, 0.1, 0.6, 0.0); // nose
        glPushMatrix(); //eyes
            glMaterialfv(GL_FRONT, GL_AMBIENT, snowMan_eyes_ambient);
            glMaterialfv(GL_FRONT, GL_DIFFUSE, snowMan_eyes_diffuse);
            glMaterialfv(GL_FRONT, GL_SPECULAR, snowMan_eyes_specular);
            glMaterialfv(GL_FRONT, GL_SHININESS, snowMan_eyes_shininess);
            glTranslatef(0.15, 0.70, -0.1);
            glutSolidSphere(0.025, 40, 40);
            glTranslatef(0., 0., 0.2);
            glutSolidSphere(0.025, 40, 40);
        glPopMatrix();
    glPopMatrix();
}

void displayWall(float x, float y, float z, float w, float h, float d){
    glPushMatrix();
        glMaterialfv(GL_FRONT, GL_AMBIENT, wall_ambient);
        glMaterialfv(GL_FRONT, GL_DIFFUSE, wall_diffuse);
        glMaterialfv(GL_FRONT, GL_SPECULAR, wall_specular);
        glMaterialfv(GL_FRONT, GL_SHININESS, wall_shininess);
        glTranslatef(x, y + h/2., z);
        glScalef(w/10., h/10., d/10.0);
        glutSolidCube(10.0);
    glPopMatrix();
}

void displayLight(GLfloat x, GLfloat y, GLfloat z){
    GLUquadricObj* quadro = gluNewQuadric();
    glPushMatrix();
        glTranslatef(x,y,z);
        glMaterialfv(GL_FRONT, GL_AMBIENT, light_sphere_ambient);
        glMaterialfv(GL_FRONT, GL_DIFFUSE, light_sphere_diffuse);
        glMaterialfv(GL_FRONT, GL_SPECULAR, light_sphere_specular);
        glMaterialfv(GL_FRONT, GL_SHININESS, light_sphere_shininess);
        gluSphere(quadro, 0.1, 48, 48);
    glPopMatrix();
}

void movePatrick(string s){
    if (s == "forward"){
        float auxx = patrick.p[0] + sin(toRads(patrick.r[1], 0.0))
                    * patrick.speed;
        float auxz = patrick.p[2] + cos(toRads(patrick.r[1], 0.0))
                    * patrick.speed;
        patrick.p[0] = capNum(fl.xmin + 0.1, fl.xmax - 0.1, auxx, 0);
        patrick.p[2] = capNum(fl.zmin + 0.1, fl.zmax - 0.1, auxz, 0);
    }
    else if (s == "backwards"){
        float auxx = patrick.p[0] - sin(toRads(patrick.r[1], 0.0))
             * patrick.speed;
        float auxz = patrick.p[2] - cos(toRads(patrick.r[1], 0.0))
             * patrick.speed;
        patrick.p[0] = capNum(fl.xmin + 0.1, fl.xmax - 0.1, auxx, 0);
        patrick.p[2] = capNum(fl.zmin + 0.1, fl.zmax - 0.1, auxz, 0);
    }
    else if (s == "left")
        patrick.r[1] = capNum(0., 360.,patrick.r[1] + patrick.rotSpeed, 1);
    else if (s == "right")
        patrick.r[1] = capNum(0., 360.,patrick.r[1] - patrick.rotSpeed, 1);
}

void displayScene(){

    // scene sphere
    if (b_sceneSphere){
        glMaterialfv(GL_FRONT, GL_AMBIENT, sphere_ambient);
        glMaterialfv(GL_FRONT, GL_DIFFUSE, sphere_diffuse);
        glMaterialfv(GL_FRONT, GL_SPECULAR, sphere_specular);
        glMaterialfv(GL_FRONT, GL_SHININESS, sphere_shininess);
        glutWireSphere(ss.radius, 50, 50);
    }
    // big patrick
    displayModel(m, 1.5, 2.5, 0.75, 2.5, 0., 0., 0.0);

    // movable patrick
    displayModel(m, 1., patrick.p[0], patrick.p[1], patrick.p[2],
        patrick.r[0], patrick.r[1], patrick.r[2]);

    // the three snowmen
    displaySnowMan(2.5, 0.4, -2.5);
    displaySnowMan(-2.5, 0.4, 2.5);
    displaySnowMan(-2.5, 0.4, -2.5);

    // walls
    if (walls){
        displayWall(0., 0., -4.9, 10., 1.5, 0.2);
        displayWall(1.5, 0., 2.5, 0.2, 1.5, 4);
    }

    // floor
    displayFloor();
}

/*************************************************************************/
/* Camera functions  */
/*************************************************************************/

void calculateVisionVector(){
    cam.visionVector[0] = (cam.OBS[0] - cam.VRP[0]);
    cam.visionVector[1] = (cam.OBS[1] - cam.VRP[1]);
    cam.visionVector[2] = (cam.OBS[2] - cam.VRP[2]);

    float norm = sqrt(pow(cam.visionVector[0], 2.0) +
                      pow(cam.visionVector[1], 2.0) +
                      pow(cam.visionVector[2], 2.0));

    cam.visionVector[0] /= norm;
    cam.visionVector[1] /= norm;
    cam.visionVector[2] /= norm;

    vectorialMult(cam.panX, cam.UP, cam.visionVector);
    cam.panY[0] = cam.UP[0];
    cam.panY[1] = cam.UP[1];
    cam.panY[2] = cam.UP[2];
}

void configCameraPaning(){
    calculateVisionVector();

    // camera paning
    cam.VRP[0] += (cam.panIncXY[0] * cam.panX[0] +
                   cam.panIncXY[1] * cam.panY[0]);
    cam.VRP[1] += (cam.panIncXY[0] * cam.panX[1] +
                   cam.panIncXY[1] * cam.panY[1]);
    cam.VRP[2] += (cam.panIncXY[0] * cam.panX[2] +
                   cam.panIncXY[1] * cam.panY[2]);

    cam.OBS[0] += (cam.panIncXY[0] * cam.panX[0] +
                   cam.panIncXY[1] * cam.panY[0]);
    cam.OBS[1] += (cam.panIncXY[0] * cam.panX[1] +
                   cam.panIncXY[1] * cam.panY[1]);
    cam.OBS[2] += (cam.panIncXY[0] * cam.panX[2] +
                   cam.panIncXY[1] * cam.panY[2]);
}

void configEuler(){
    // rotate and translate in -z for euler positioning
    glTranslatef(-cam.panIncEulerXY[0], -cam.panIncEulerXY[1], -ss.diameter);
    glRotatef(rad_xyz[2], 1, 0, 0);
    glRotatef(rad_xyz[1], 0, 1, 0);
    glRotatef(rad_xyz[0], 0, 0, 1);
}

void configLookAt(){
    // little Patrick first person with glLookAt positioning
    if (first_person and !euler_look)
        gluLookAt(patrick.p[0], 1, patrick.p[2],
            patrick.p[0] + sin(toRads(patrick.r[1],0.0)),
            1,
            patrick.p[2] + cos(toRads(patrick.r[1],0.0)),
            cam.UP[0], cam.UP[1], cam.UP[2]);
    // glLookAt positioning
    else {
        configCameraPaning();
        gluLookAt(cam.OBS[0], cam.OBS[1], cam.OBS[2],
                  cam.VRP[0], cam.VRP[1], cam.VRP[2],
                  cam.UP[0], cam.UP[1], cam.UP[2]);
    }
}

void configCameraPosition(){
    glMatrixMode(GL_MODELVIEW);
    glLoadIdentity();

    // observer position calculation
    cam.OBS[0] = cam.VRP[2] + ss.diameter
        * sin(toRads(rad_xyz[2],-90.0)) * cos(toRads(rad_xyz[1],-90.0));
    cam.OBS[1] = cam.VRP[1] + ss.diameter
        * cos(toRads(rad_xyz[2],-90.0));
    cam.OBS[2] = cam.VRP[0] + ss.diameter
        * sin(toRads(rad_xyz[2],-90.0)) * sin(toRads(rad_xyz[1],-90.0));

    // set the camera on observer position
    if(euler_look && !first_person) configEuler();
    else if(!euler_look) configLookAt();

    cam.panIncXY[0] = cam.panIncXY[1] = 0.0;
}

void configCamera(){
    glMatrixMode(GL_PROJECTION);

    glLoadIdentity();
    aspect_ratio = (float) window_size[0] / (float) window_size[1];
    float zNear = ss.diameter - ss.radius;
    float zFar = ss.diameter + ss.radius;

    if(ortho_camera){
        // axonometric/ortogonal camera
        float width = ss.radius, height = ss.radius;
        width += (zoom_factor * 0.15);
        height += (zoom_factor * 0.15);
        if (aspect_ratio >= 1) width *= aspect_ratio;
        else height /= aspect_ratio;
        glOrtho(-width, width, -height, height, zNear, zFar);
    } else {
        // perspective camera
        float angle = asin(ss.radius / ss.diameter);
        if (aspect_ratio < 1.0) angle = atan(tan(angle) / aspect_ratio);
        angle = (angle * 180) / M_PI;
        if(first_person) gluPerspective(2 * angle, aspect_ratio, 0.1, zFar);
        else
            gluPerspective(2 * angle + zoom_factor, aspect_ratio, zNear, zFar);
    }

    configCameraPosition();

    glutPostRedisplay();
}

/*************************************************************************/
/* Lighting functions  */
/*************************************************************************/

void initLights(){
    // lights on
    glEnable(GL_LIGHTING);

    // set scene light colors
    glLightfv(GL_LIGHT0, GL_AMBIENT, light0_ambient);
    glLightfv(GL_LIGHT0, GL_DIFFUSE, light0_diffuse);
    glLightfv(GL_LIGHT0, GL_SPECULAR, light0_specular);

    // set camera light colors
    glLightfv(GL_LIGHT1, GL_AMBIENT, light1_ambient);
    glLightfv(GL_LIGHT1, GL_DIFFUSE, light1_diffuse);
    glLightfv(GL_LIGHT1, GL_SPECULAR, light1_specular);

    // set patrick light colors
    glLightfv(GL_LIGHT2, GL_AMBIENT, light1_ambient);
    glLightfv(GL_LIGHT2, GL_DIFFUSE, light1_diffuse);
    glLightfv(GL_LIGHT2, GL_SPECULAR, light1_specular);

    // at first the scene light is set to it first position
    glLightfv(GL_LIGHT0, GL_POSITION, light0_pos1);
}

void configLights(){

    // camera light enable/disable
    if (camera_light && lighting){
        glEnable(GL_LIGHT1);
        glLightfv(GL_LIGHT1, GL_POSITION, cam.OBS);
    }
    else glDisable(GL_LIGHT1);

    // patrick light enable/disable
    if (patrick_light && lighting){
        glEnable(GL_LIGHT2);
        glLightfv(GL_LIGHT2, GL_POSITION, patrick.p);
    } else glDisable(GL_LIGHT2);

    // scene light enable/disable
    if (scene_light && lighting) glEnable(GL_LIGHT0);
    else glDisable(GL_LIGHT0);

    switch (scene_light_position){
        case 0:
            glLightfv(GL_LIGHT0, GL_POSITION, light0_pos1);
            if(scene_light)
                displayLight(light0_pos1[0],light0_pos1[1],light0_pos1[2]);
        break;
        case 1:
            glLightfv(GL_LIGHT0, GL_POSITION, light0_pos2);
            if(scene_light)
                displayLight(light0_pos2[0],light0_pos2[1],light0_pos2[2]);
        break;
        case 2:
            glLightfv(GL_LIGHT0, GL_POSITION, light0_pos3);
            if(scene_light)
                displayLight(light0_pos3[0],light0_pos3[1],light0_pos3[2]);
        break;
        case 3:
            glLightfv(GL_LIGHT0, GL_POSITION, light0_pos4);
            if(scene_light)
                displayLight(light0_pos4[0],light0_pos4[1],light0_pos4[2]);
        break;
    }
}

/*************************************************************************/
/* Controller functions  */
/*************************************************************************/

void mousePressCtrl(int button, int state, int x, int y){
    l_click = button == GLUT_LEFT_BUTTON && state == GLUT_DOWN;
    r_click = button == GLUT_RIGHT_BUTTON && state == GLUT_DOWN;
    if(state == GLUT_DOWN){
        last_click[0] = y;
        last_click[1] = x;
    }
    glutPostRedisplay();
}

void mouseMotionCtrl(int x, int y){
    if (l_click and !first_person){
        rad_xyz[2] = capNum(-89., 89., rad_xyz[2] +
            float(y - last_click[0]), 0);
        rad_xyz[1] = capNum(0., 360., rad_xyz[1] +
            float(x - last_click[1]), 1);
    }
    if (r_click and !first_person)
        zoom_factor = capNum(-40., 40., zoom_factor+float(y-last_click[0]), 0);
    last_click[0] = y;
    last_click[1] = x;
    configCamera();
}

void keyboardCtrl(unsigned char key, int x, int y){
    if (verbose) printf("**** %s: %c \n", "key pressed", key);
    switch (key){
        case 'h': showHelp(); break;
        case 27: case 'q': exit(0); break;
        case 'V': verbose = !verbose; break;
        case 'v': walls = !walls; break;
        case 'N': b_sceneSphere = !b_sceneSphere; break;
        case 'n':
            if (per_vertex) glShadeModel(GL_FLAT);
            else glShadeModel(GL_SMOOTH);
            per_vertex = !per_vertex;
            break;
        case 'x': axis = !axis; break;
        case 'r': reset(); configCamera(); break;
        case 'w': movePatrick("forward"); configCamera(); break;
        case 'a': movePatrick("left"); configCamera(); break;
        case 's': movePatrick("backwards"); configCamera(); break;
        case 'd': movePatrick("right"); configCamera(); break;
        case 't': first_person = !first_person; euler_look=0; ortho_camera=0; configCamera(); break;
        case 'p':  ortho_camera = !ortho_camera; first_person=0; configCamera(); break;
        case 'c': first_person=0; euler_look = !euler_look; configCamera(); break;
        case 'm': scene_light_position = capNum(0,4,scene_light_position+1,1); break;
        case 'i': lighting = !lighting; break;
        case '0': scene_light = !scene_light; break;
        case '1': camera_light = !camera_light; break;
        case '2': patrick_light = !patrick_light; break;
    }
    glutPostRedisplay();
}

void keyboardNonAsciiCtrl(int key, int mouseX, int mouseY) {
    glutIgnoreKeyRepeat(false);
    // panning
    switch(key) {
        case GLUT_KEY_RIGHT:
            cam.panIncXY[0] = pan_increment;
            cam.panIncEulerXY[0] += pan_increment;
            configCamera();
            break;
        case GLUT_KEY_LEFT:
            cam.panIncXY[0] = -pan_increment;
            cam.panIncEulerXY[0] -= pan_increment;
            configCamera();
            break;
        case GLUT_KEY_UP:
            cam.panIncXY[1] = pan_increment;
            cam.panIncEulerXY[1] += pan_increment;
            configCamera();
            break;
        case GLUT_KEY_DOWN:
            cam.panIncXY[1] = -pan_increment;
            cam.panIncEulerXY[1] -= pan_increment;
            configCamera();
            break;
    }
}

void resizeCtrl(int w, int h){
    window_size[0] = w;
    window_size[1] = h;
    configCamera();

    // viewport with same size as the window
    glViewport(0, 0, window_size[0], window_size[1]);
    glutPostRedisplay();
}

void refreshCtrl(void){
    glClearColor(0.,0.,0.,1.0);
    glClear(GL_COLOR_BUFFER_BIT | GL_DEPTH_BUFFER_BIT);

    configLights(); // lighting configuration

    displayScene(); // scene display

    if (axis) displayAxis(100., 1.0);
    if (verbose) showVariables();

    glDepthMask(GL_TRUE);
    glutSwapBuffers();
}

/*************************************************************************/
/* Initialization functions  */
/*************************************************************************/

void initGL(int argc, char const *argv[]){

    // initializations
    glutInit(&argc, (char **) argv);
    glutInitDisplayMode(GLUT_DEPTH | GLUT_DOUBLE | GLUT_RGBA);
    glutInitWindowSize(window_size[0],window_size[1]);
    glutCreateWindow("Bloque 4: Luis García Estrades Grupo: 13");
    showHelp();

    // set up depth testing.
    glEnable(GL_DEPTH_TEST);
    m.load("Patricio.obj");

    // patrick initial values
    patrick.p[0] = patrick.p[2] = 0.0;
    patrick.p[1] = 0.5;
    patrick.p[3] = 1.0;
    patrick.r[0] = patrick.r[2] = 0.0;
    patrick.r[1] = 270.0;
    patrick.speed = 0.2;
    patrick.rotSpeed = patrick.rotTaf = 6.0;

    // patrick container box
    calculateModelBox(m);

    calculateSceneSphere();
    // glShadeModel(GL_SMOOTH); its by default
    glEnable(GL_NORMALIZE);
}

int main(int argc, char const *argv[]){

    initGL(argc, argv);

    //callbacks
    glutDisplayFunc(refreshCtrl);
    glutMotionFunc(mouseMotionCtrl);
    glutMouseFunc(mousePressCtrl);
    glutKeyboardFunc(keyboardCtrl);
    glutSpecialFunc(keyboardNonAsciiCtrl);
    glutReshapeFunc(resizeCtrl);

    // lights
    initLights();

    glutMainLoop();
    return 0;
}


