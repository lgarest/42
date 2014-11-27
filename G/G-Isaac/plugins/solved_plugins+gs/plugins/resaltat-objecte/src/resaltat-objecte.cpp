#include "glwidget.h"
#include "resaltat-objecte.h"

  void ResaltatObjecte::postFrame() {
    int objecte = pglwidget->scene()->selectedObject();
    if (objecte != -1){
      const Object& obj = pglwidget->scene()->objects()[objecte];
      obj.boundingBox().render();
    }
  }
Q_EXPORT_PLUGIN2(resaltat-objecte, ResaltatObjecte) // plugin name, class name