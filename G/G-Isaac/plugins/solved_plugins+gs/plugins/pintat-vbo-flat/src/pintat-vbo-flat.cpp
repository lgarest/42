#include "pintat-vbo-flat.h"
#include "glwidget.h"

using namespace std;

void PintatVboFlat::drawScene()
{  
    for (unsigned int i = 0; i < objspunts.size(); i++){
      const vector <Point>& punts = objspunts[i];
      const vector <Point>& normals = objsnormals[i];
      
      // Pas 1
      GLuint points;
      GLuint normales;
      GLuint indexs;
      
      glGenBuffers(1,&points);
      glBindBuffer(GL_ARRAY_BUFFER, points);
      glBufferData(GL_ARRAY_BUFFER,sizeof(GL_FLOAT)*3*punts.size(),&punts[0],GL_STATIC_DRAW);
      
      glGenBuffers(1,&normales);
      glBindBuffer(GL_ARRAY_BUFFER,normales);
      glBufferData(GL_ARRAY_BUFFER,sizeof(GL_FLOAT)*3*normals.size(),&normals[0],GL_STATIC_DRAW);
      
      glGenBuffers(1, &indexs);
      glBindBuffer(GL_ELEMENT_ARRAY_BUFFER,indexs);
      glBufferData(GL_ELEMENT_ARRAY_BUFFER,sizeof(GL_INT)*objsindexs[i].size(),&objsindexs[i][0],GL_STATIC_DRAW);
      
      // Pas 2.
      glBindBuffer(GL_ARRAY_BUFFER,points);
      glVertexPointer(3, GL_FLOAT, 0, (GLvoid*)0);
      glEnableClientState(GL_VERTEX_ARRAY);
      
      glBindBuffer(GL_ARRAY_BUFFER,normales);
      glNormalPointer(GL_FLOAT, 0, (GLvoid*)0);
      glEnableClientState(GL_NORMAL_ARRAY);
      
      glBindBuffer(GL_ELEMENT_ARRAY_BUFFER,indexs);
      glDrawElements(GL_TRIANGLES,punts.size(),GL_UNSIGNED_INT,(GLvoid*) 0);
      
      glDisableClientState(GL_VERTEX_ARRAY);
      glDisableClientState(GL_NORMAL_ARRAY);
      
      glBindBuffer(GL_ARRAY_BUFFER,0);
      glBindBuffer(GL_ELEMENT_ARRAY_BUFFER,0);
      
      // Pas 3.
      glDeleteBuffers(1,&points);
      glDeleteBuffers(1,&normales);
      glDeleteBuffers(1,&indexs);
    }
}

void PintatVboFlat::onPluginLoad(){
    vector <Point> punts;
    vector <Point> normals;
    vector <int> index;
    Scene* scene = pglwidget->scene();
    // per cada objecte
    int i = 0;
    if (scene->objects().size() > 0){
      const Object& obj = scene->objects()[0];
      for(unsigned int c=0; c<obj.faces().size(); c++)
      {
	const Face& face = obj.faces()[c];
	const Point& normal_cara = Point(face.normal().x(), face.normal().y(), face.normal().z());
	// per cada vertex
	if (face.numVertices() == 4){
	  const Point& ps = obj.vertices()[face.vertexIndex(0)].coord();
	  for(int v=0; v<face.numVertices(); v++)
	  { 
	    const Point& p = obj.vertices()[face.vertexIndex(v)].coord();
	    punts.push_back(p);
	    if(v == 2){ punts.push_back(p); index.push_back(i); ++i; normals.push_back(normal_cara);}
	    normals.push_back(normal_cara);
	    index.push_back(i);
	    ++i;
	  }
	  punts.push_back(ps);
	  normals.push_back(normal_cara);
	  index.push_back(i);
	  ++i;
	}
	else if (face.numVertices() == 3){
	  for(int v=0; v<face.numVertices(); v++)
	  { 
	    const Point& p = obj.vertices()[face.vertexIndex(v)].coord();
	    punts.push_back(p);
	    normals.push_back(normal_cara);
	    index.push_back(i);
	    ++i;
	  }
	}
	else{
	  const Point& ps = obj.vertices()[face.vertexIndex(0)].coord();
	  Point previous = obj.vertices()[face.vertexIndex(1)].coord();
	  for(int v=2; v<face.numVertices(); v++)
	  { 
	    punts.push_back(ps);
	    normals.push_back(normal_cara);
	    index.push_back(i);
	    ++i;
	    punts.push_back(previous);
	    normals.push_back(normal_cara);
	    index.push_back(i);
	    ++i;
	    const Point& p = obj.vertices()[face.vertexIndex(v)].coord();
	    normals.push_back(normal_cara);
	    punts.push_back(p);
	    index.push_back(i);
	    ++i;
	    previous = obj.vertices()[face.vertexIndex(v)].coord();
	  }
	}
      }
      objspunts.push_back(punts);
      objsnormals.push_back(normals);
      objsindexs.push_back(index);
    }
}

void PintatVboFlat::onObjectAdd(){
    Scene* scene = pglwidget->scene();
    vector <Point> punts;
    vector <Point> normals;
    vector <int> index;
    int size = scene->objects().size();
    const Object& obj = scene->objects()[size-1];
    int i = 0;
    for(unsigned int c=0; c<obj.faces().size(); c++)
    {
      const Face& face = obj.faces()[c];
      const Point& normal_cara = Point(face.normal().x(), face.normal().y(), face.normal().z());
      // per cada vertex
      if (face.numVertices() == 4){
	const Point& ps = obj.vertices()[face.vertexIndex(0)].coord();
	for(int v=0; v<face.numVertices(); v++)
	{ 
	  const Point& p = obj.vertices()[face.vertexIndex(v)].coord();
	  punts.push_back(p);
	  if(v == 2){ punts.push_back(p); index.push_back(i); ++i; normals.push_back(normal_cara);}
	  normals.push_back(normal_cara);
	  index.push_back(i);
	  ++i;
	}
	punts.push_back(ps);
	normals.push_back(normal_cara);
	index.push_back(i);
	++i;
      }
      else if (face.numVertices() == 3){
	for(int v=0; v<face.numVertices(); v++)
	{ 
	  const Point& p = obj.vertices()[face.vertexIndex(v)].coord();
	  punts.push_back(p);
	  normals.push_back(normal_cara);
	  index.push_back(i);
	  ++i;
	}
      }
      else{
	const Point& ps = obj.vertices()[face.vertexIndex(0)].coord();
	Point previous = obj.vertices()[face.vertexIndex(1)].coord();
	for(int v=2; v<face.numVertices(); v++)
	{ 
	  punts.push_back(ps);
	  normals.push_back(normal_cara);
	  index.push_back(i);
	  ++i;
	  punts.push_back(previous);
	  normals.push_back(normal_cara);
	  index.push_back(i);
	  ++i;
	  const Point& p = obj.vertices()[face.vertexIndex(v)].coord();
	  normals.push_back(normal_cara);
	  punts.push_back(p);
	  index.push_back(i);
	  ++i;
	  previous = obj.vertices()[face.vertexIndex(v)].coord();
	}
      }
    }
    objspunts.push_back(punts);
    objsnormals.push_back(normals);
    objsindexs.push_back(index);
}

Q_EXPORT_PLUGIN2(pintat-vbo-flat, PintatVboFlat)   // plugin name, plugin class
