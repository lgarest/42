#include "modelinfo.h"
#include "glwidget.h"

void ModelInfo::postFrame() 
{
    vector<Object> objects = pglwidget->scene()->objects();

    glColor3f(0.0,0.0,0.0);
    int x = 0, y = 0;
    for (int j = 0; j < objects.size(); ++j) { 

	    int x += 5, y += 15;
	    pglwidget->renderText(x,y,
	    	QString("Objectes: ")+QString::number(objects.size()));

	    x = 5, y += 30;
	    int faces = objects[j].faces().size();
	    pglwidget->renderText(x,y,
	    	QString("Cares: ")+QString::number(faces));

	    int vertexs = 0;
	    int triangles = 0;
	    for (int i = 0; i < faces; ++i) {
	    	int vertface = objects[j].faces()[i].numVertices();
	    	vertexs += vertface;
	    	if (vertface == 3) ++triangles;
	    }

	    x = 5, y += 45;
	    pglwidget->renderText(x,y,
	    	QString("Vertexs: ")+QString::number(vertexs));


	    x = 5, y += 60;
	    pglwidget->renderText(x,y,
	    	QString("Perc. Triangles: ")+QString::number((triangles/float(vertexs))*100));
	}
}

Q_EXPORT_PLUGIN2(modelinfo, ModelInfo)   // plugin name, plugin class
