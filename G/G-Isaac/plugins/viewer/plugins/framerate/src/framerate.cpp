#include "framerate.h"
#include "glwidget.h"
#include <QElapsedTimer>

void FrameRate::preFrame() 
{
    timer.start();
}

void FrameRate::postFrame() 
{
    glColor3f(0.0,0.0,0.0);
    int x = 5;
    int y = 15;
    pglwidget->renderText(x,y,QString::number(timer.elapsed()));
}

Q_EXPORT_PLUGIN2(framerate, FrameRate)   // plugin name, plugin class
