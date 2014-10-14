#include "seleccio-objectes.h"
#include "glwidget.h"
#include <QApplication>
#include <iostream>
using namespace std;

SeleccioObjectes::SeleccioObjectes() : pmouseAction(NONE)
{}

/*void SeleccioObjectes::keyPressEvent ( QKeyEvent *  event) {
  int model = -1;
  if(event->key() >= Qt::Key_0 && event->key() <= Qt::Key_9){
    model = event->key()-0x30;
    if (model >= pglwidget->scene()->objects().size()) model = -1;
  }
  pglwidget->scene()->setSelectedObject(model);
  std::cout << "Model: " << model << endl;
  pglwidget->updateGL();
}*/

void SeleccioObjectes::mousePressEvent ( QMouseEvent * event ){
  //cout << "ASSDF" << Qt::ControlModifier << " " << event->button() << endl;
}

void SeleccioObjectes::mouseReleaseEvent ( QMouseEvent * event ){
  Qt::KeyboardModifiers keyMod = QApplication::keyboardModifiers();
  bool isCTRL = keyMod.testFlag(Qt::ControlModifier);
  if (isCTRL && (event->button() == Qt::LeftButton)){
    glDisable(GL_LIGHTING);
    glClearColor(0,0,0,1);
    glClear(GL_COLOR_BUFFER_BIT | GL_DEPTH_BUFFER_BIT);
    Scene* scene = pglwidget->scene();
    for (unsigned int i=0; i<scene->objects().size(); ++i){
      glColor3ub(i+128,0,0);
      const Object& obj = scene->objects()[i];
      // per cada cara
      for(unsigned int c=0; c<obj.faces().size(); c++){
	const Face& face = obj.faces()[c];
	glBegin (GL_POLYGON);
	// per cada vertex
	for(int v=0; v<face.numVertices(); v++){
	    const Point& p = obj.vertices()[face.vertexIndex(v)].coord();
	    glVertex3f(p.x(), p.y(), p.z());
	}
	glEnd();
      }
    }
    int mouseX = event->x();
    int mouseY = event->y();
    GLint viewport[4];
    glGetIntegerv(GL_VIEWPORT, viewport);
 
    GLubyte colors[3]; // RGB x 1 pixel
    glReadPixels(mouseX, viewport[3]-mouseY, 1, 1, GL_RGB, GL_UNSIGNED_BYTE, colors);
    
    int idmodel;
    if((int)colors[0] > 0){
      idmodel = colors[0]-128;
    }
    else idmodel = -1;
    scene->setSelectedObject(idmodel);
    glEnable(GL_LIGHTING);
    //pglwidget->swapBuffers();
    pglwidget->updateGL();
  }
}
/**/
Q_EXPORT_PLUGIN2(seleccio-objectes, SeleccioObjectes)   // plugin name, plugin class
