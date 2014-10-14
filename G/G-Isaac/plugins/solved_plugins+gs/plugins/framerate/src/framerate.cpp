#include "framerate.h"
#include "glwidget.h"
#include <iostream>

  void Framerate::preFrame(){
    timer.restart();
  }
  void Framerate::postFrame() {
    float a = 1000.0/timer.elapsed();
    int frames_per_second = a;
    glColor3f(0.0, 0.0, 0.0);
    int x = 40;
    int y = 15;
    QString fps = QString::number(frames_per_second,10);
    fps += " fps";
    pglwidget->renderText(x,y, fps);
  }
Q_EXPORT_PLUGIN2(framerate, Framerate) // plugin name, class name