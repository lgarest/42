/********************************************************************************
** Form generated from reading UI file 'myForm.ui'
**
** Created by: Qt User Interface Compiler version 4.8.6
**
** WARNING! All changes made in this file will be lost when recompiling UI file!
********************************************************************************/

#ifndef UI_MYFORM_H
#define UI_MYFORM_H

#include <QtCore/QVariant>
#include <QtGui/QAction>
#include <QtGui/QApplication>
#include <QtGui/QButtonGroup>
#include <QtGui/QHBoxLayout>
#include <QtGui/QHeaderView>
#include <QtGui/QPushButton>
#include <QtGui/QSlider>
#include <QtGui/QSpacerItem>
#include <QtGui/QVBoxLayout>
#include <QtGui/QWidget>
#include <qlcdcustom.h>

QT_BEGIN_NAMESPACE

class Ui_myForm
{
public:
    QVBoxLayout *verticalLayout;
    QHBoxLayout *horizontalLayout_2;
    QHBoxLayout *horizontalLayout;
    qlcdCustom *lcdNumber;
    QSlider *horizontalSlider;
    QPushButton *pushButton;
    QSpacerItem *horizontalSpacer;
    QPushButton *closebtn;
    QSpacerItem *verticalSpacer;

    void setupUi(QWidget *myForm)
    {
        if (myForm->objectName().isEmpty())
            myForm->setObjectName(QString::fromUtf8("myForm"));
        myForm->resize(514, 156);
        verticalLayout = new QVBoxLayout(myForm);
        verticalLayout->setObjectName(QString::fromUtf8("verticalLayout"));
        horizontalLayout_2 = new QHBoxLayout();
        horizontalLayout_2->setObjectName(QString::fromUtf8("horizontalLayout_2"));
        horizontalLayout = new QHBoxLayout();
        horizontalLayout->setObjectName(QString::fromUtf8("horizontalLayout"));
        lcdNumber = new qlcdCustom(myForm);
        lcdNumber->setObjectName(QString::fromUtf8("lcdNumber"));

        horizontalLayout->addWidget(lcdNumber);

        horizontalSlider = new QSlider(myForm);
        horizontalSlider->setObjectName(QString::fromUtf8("horizontalSlider"));
        horizontalSlider->setOrientation(Qt::Horizontal);

        horizontalLayout->addWidget(horizontalSlider);

        pushButton = new QPushButton(myForm);
        pushButton->setObjectName(QString::fromUtf8("pushButton"));

        horizontalLayout->addWidget(pushButton);


        horizontalLayout_2->addLayout(horizontalLayout);

        horizontalSpacer = new QSpacerItem(40, 20, QSizePolicy::Expanding, QSizePolicy::Minimum);

        horizontalLayout_2->addItem(horizontalSpacer);

        closebtn = new QPushButton(myForm);
        closebtn->setObjectName(QString::fromUtf8("closebtn"));

        horizontalLayout_2->addWidget(closebtn);


        verticalLayout->addLayout(horizontalLayout_2);

        verticalSpacer = new QSpacerItem(20, 94, QSizePolicy::Minimum, QSizePolicy::Expanding);

        verticalLayout->addItem(verticalSpacer);


        retranslateUi(myForm);
        QObject::connect(horizontalSlider, SIGNAL(sliderMoved(int)), lcdNumber, SLOT(setNum(int)));
        QObject::connect(closebtn, SIGNAL(clicked()), myForm, SLOT(close()));
        QObject::connect(pushButton, SIGNAL(clicked()), lcdNumber, SLOT(setZero()));

        QMetaObject::connectSlotsByName(myForm);
    } // setupUi

    void retranslateUi(QWidget *myForm)
    {
        myForm->setWindowTitle(QApplication::translate("myForm", "Form", 0, QApplication::UnicodeUTF8));
        pushButton->setText(QApplication::translate("myForm", "Zero", 0, QApplication::UnicodeUTF8));
        closebtn->setText(QApplication::translate("myForm", "Surt", 0, QApplication::UnicodeUTF8));
    } // retranslateUi

};

namespace Ui {
    class myForm: public Ui_myForm {};
} // namespace Ui

QT_END_NAMESPACE

#endif // UI_MYFORM_H
