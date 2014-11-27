#include "pintat-va-flat.h"
#include "glwidget.h"

using namespace std;

void PintatVaFlat::drawScene()
{
    Scene* scene = pglwidget->scene();
    int i = 0;
    const Object& obj = scene->objects()[0];
    /*// per cada cara
    for(unsigned int c=0; c<obj.faces().size(); c++)
    {
      const Face& face = obj.faces()[c];
      glBegin (GL_POLYGON);
      glNormal3f(normals[j].x(), normals[j].y(), normals[j].z());
      // per cada vertex
      for(int v=0; v<face.numVertices(); v++)
      { 
	glVertex3f(punts[i].x(), punts[i].y(), punts[i].z());
	++i;
      }
      glEnd();
      ++j;
    }*/
    
    glNormalPointer(GL_FLOAT, 0, &normals[0]);
    glVertexPointer(3, GL_FLOAT, 0, &punts[0]);
    glEnableClientState(GL_VERTEX_ARRAY);
    glEnableClientState(GL_NORMAL_ARRAY);
    for(unsigned int c=0; c<obj.faces().size(); c++)
    {
      const Face& face = obj.faces()[c];
      glBegin (GL_POLYGON);
      // per cada vertex
      for(int v=0; v<face.numVertices(); v++)
      { 
	glArrayElement(i);
	++i;
      }
      glEnd();
    }
}

void PintatVaFlat::onPluginLoad(){
    Scene* scene = pglwidget->scene();
    // per cada objecte
    int i = 0;
    const Object& obj = scene->objects()[0];
    for(unsigned int c=0; c<obj.faces().size(); c++)
    {
      const Face& face = obj.faces()[c];
      Point normal = Point(face.normal().x(), face.normal().y(), face.normal().z());
      // per cada vertex
      for(int v=0; v<face.numVertices(); v++)
      { 
	const Point& p = obj.vertices()[face.vertexIndex(v)].coord();
	punts.push_back(p);
	normals.push_back(normal);
	++i;
      }
    }
}

void PintatVaFlat::ObjectAdd(){
  
}

Q_EXPORT_PLUGIN2(pintat-va-flat, PintatVaFlat)   // plugin name, plugin class
