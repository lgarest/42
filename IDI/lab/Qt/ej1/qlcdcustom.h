#include <QLCDNumber>

class qlcdCustom: public QLCDNumber{
    Q_OBJECT
public:
    qlcdCustom(QWidget *parent);
    qlcdCustom();

    public slots:

    void setZero();
    void setNum(int);
};
