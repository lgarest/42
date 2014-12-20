#include "qlcdcustom.h"

qlcdCustom::qlcdCustom(QWidget *parent):QLCDNumber(parent){
}

qlcdCustom::qlcdCustom(){
    setStyleSheet("color:green");
}

void qlcdCustom::setZero(){
    setStyleSheet("color:green");
    display(0);
}

void qlcdCustom::setNum(int n){
    if (intValue() == 0 || n == 0) {
        // setSegmentStyle(Flat);
        setStyleSheet("color:green");
        display(n);
    }
    else if (intValue() % 2 == 0) {
        // setSegmentStyle(Flat);
        setStyleSheet("color:blue");
        display(n);
    }
    else if (intValue() % 2 != 0) {
        // setSegmentStyle(Flat);
        setStyleSheet("color:red");
        display(n);
    }
}
