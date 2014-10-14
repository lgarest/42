#ifndef _SELECCIO_OBJECTES_H
#define _SELECCIO_OBJECTES_H

#include "actioninterface.h"

class SeleccioObjectes : public QObject, public ActionInterface
 {
     Q_OBJECT
     Q_INTERFACES(ActionInterface)

 public:
    SeleccioObjectes();
 
    //void	keyPressEvent ( QKeyEvent *  e);
    
    void 	mousePressEvent ( QMouseEvent * event );
    void 	mouseReleaseEvent ( QMouseEvent * event );
    
    /*
    void	mouseMoveEvent ( QMouseEvent * event );
    */
    //void	wheelEvent ( QWheelEvent *  ) {};*/
 
 private:
    typedef  enum {NONE, ROTATE, ZOOM, PAN} MouseAction;
    MouseAction pmouseAction;
    int   pxClick, pyClick;
    bool ctrl;
 };
 
 #endif
 
 