#include "model-info.h"
#include "glwidget.h"
#include <iostream>

  void ModelInfo::preFrame(){
  }
  void ModelInfo::postFrame() {
    int numero_objectes = pglwidget->scene()->objects().size();
    double num_pol = 0;
    double num_vert = 0;
    for (int i = 0; i < numero_objectes; i++){
      num_pol += (pglwidget->scene()->objects()[i].faces()).size();
      num_vert += (pglwidget->scene()->objects()[i].vertices()).size();
    }
    float num_possible_triangles = num_vert*3;
    float pertriangles = (100*(num_pol/num_possible_triangles));
    glColor3f(0.0, 0.0, 0.0);
    int x = 340;
    int y = 480;
    QString nobj = "Numero de models carregats: ";
    nobj += QString::number(numero_objectes,10);
    pglwidget->renderText(x,y, nobj);
    y = 500;
    QString npolyg = "Numero de poligons: ";
    npolyg += QString::number(num_pol);
    pglwidget->renderText(x,y, npolyg);
    y = 520;
    QString nvertexs = "Numero de vertexs: ";
    nvertexs += QString::number(num_vert);
    pglwidget->renderText(x,y, nvertexs);
    y = 540;
    QString per_tri = "Percentatge de triangles: ";
    per_tri += QString::number(pertriangles);
    per_tri += "%";
    pglwidget->renderText(x,y, per_tri);
  }
Q_EXPORT_PLUGIN2(model-info, ModelInfo) // plugin name, class name