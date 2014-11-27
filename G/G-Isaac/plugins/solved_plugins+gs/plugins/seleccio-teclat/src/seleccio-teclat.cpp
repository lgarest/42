#include "seleccio-teclat.h"
#include "glwidget.h"
#include <iostream>

SeleccioTeclat::SeleccioTeclat() : pmouseAction(NONE)
{}

void SeleccioTeclat::keyPressEvent ( QKeyEvent *  event) {
  int model = -1;
  if(event->key() >= Qt::Key_0 && event->key() <= Qt::Key_9){
    model = event->key()-0x30;
    if (model >= pglwidget->scene()->objects().size()) model = -1;
  }
  pglwidget->scene()->setSelectedObject(model);
  std::cout << "Model: " << model << endl;
  pglwidget->updateGL();
}

Q_EXPORT_PLUGIN2(seleccio-teclat, SeleccioTeclat)   // plugin name, plugin class
