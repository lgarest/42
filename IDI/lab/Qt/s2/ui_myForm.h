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
#include <QtGui/QLabel>
#include <QtGui/QPushButton>
#include <QtGui/QSlider>
#include <QtGui/QSpacerItem>
#include <QtGui/QSpinBox>
#include <QtGui/QVBoxLayout>
#include <QtGui/QWidget>

QT_BEGIN_NAMESPACE

class Ui_myForm
{
public:
    QVBoxLayout *verticalLayout_3;
    QHBoxLayout *horizontalLayout_3;
    QVBoxLayout *verticalLayout_2;
    QHBoxLayout *horizontalLayout;
    QLabel *heightlabel;
    QSpacerItem *horizontalSpacer_2;
    QHBoxLayout *horizontalLayout_2;
    QLabel *meterslabel;
    QSpacerItem *horizontalSpacer_3;
    QVBoxLayout *verticalLayout;
    QSlider *horizontalSlider;
    QSpinBox *spinBox;
    QSpacerItem *verticalSpacer;
    QHBoxLayout *exitLayout;
    QSpacerItem *horizontalSpacer;
    QPushButton *pushButton;

    void setupUi(QWidget *myForm)
    {
        if (myForm->objectName().isEmpty())
            myForm->setObjectName(QString::fromUtf8("myForm"));
        myForm->resize(486, 304);
        myForm->setMinimumSize(QSize(150, 150));
        verticalLayout_3 = new QVBoxLayout(myForm);
        verticalLayout_3->setObjectName(QString::fromUtf8("verticalLayout_3"));
        horizontalLayout_3 = new QHBoxLayout();
        horizontalLayout_3->setObjectName(QString::fromUtf8("horizontalLayout_3"));
        verticalLayout_2 = new QVBoxLayout();
        verticalLayout_2->setObjectName(QString::fromUtf8("verticalLayout_2"));
        horizontalLayout = new QHBoxLayout();
        horizontalLayout->setObjectName(QString::fromUtf8("horizontalLayout"));
        heightlabel = new QLabel(myForm);
        heightlabel->setObjectName(QString::fromUtf8("heightlabel"));

        horizontalLayout->addWidget(heightlabel);

        horizontalSpacer_2 = new QSpacerItem(40, 20, QSizePolicy::Expanding, QSizePolicy::Minimum);

        horizontalLayout->addItem(horizontalSpacer_2);


        verticalLayout_2->addLayout(horizontalLayout);

        horizontalLayout_2 = new QHBoxLayout();
        horizontalLayout_2->setObjectName(QString::fromUtf8("horizontalLayout_2"));
        meterslabel = new QLabel(myForm);
        meterslabel->setObjectName(QString::fromUtf8("meterslabel"));

        horizontalLayout_2->addWidget(meterslabel);

        horizontalSpacer_3 = new QSpacerItem(48, 20, QSizePolicy::Expanding, QSizePolicy::Minimum);

        horizontalLayout_2->addItem(horizontalSpacer_3);


        verticalLayout_2->addLayout(horizontalLayout_2);


        horizontalLayout_3->addLayout(verticalLayout_2);

        verticalLayout = new QVBoxLayout();
        verticalLayout->setObjectName(QString::fromUtf8("verticalLayout"));
        horizontalSlider = new QSlider(myForm);
        horizontalSlider->setObjectName(QString::fromUtf8("horizontalSlider"));
        horizontalSlider->setOrientation(Qt::Horizontal);

        verticalLayout->addWidget(horizontalSlider);

        spinBox = new QSpinBox(myForm);
        spinBox->setObjectName(QString::fromUtf8("spinBox"));

        verticalLayout->addWidget(spinBox);


        horizontalLayout_3->addLayout(verticalLayout);


        verticalLayout_3->addLayout(horizontalLayout_3);

        verticalSpacer = new QSpacerItem(20, 168, QSizePolicy::Minimum, QSizePolicy::Expanding);

        verticalLayout_3->addItem(verticalSpacer);

        exitLayout = new QHBoxLayout();
        exitLayout->setObjectName(QString::fromUtf8("exitLayout"));
        horizontalSpacer = new QSpacerItem(228, 20, QSizePolicy::Expanding, QSizePolicy::Minimum);

        exitLayout->addItem(horizontalSpacer);

        pushButton = new QPushButton(myForm);
        pushButton->setObjectName(QString::fromUtf8("pushButton"));

        exitLayout->addWidget(pushButton);


        verticalLayout_3->addLayout(exitLayout);


        retranslateUi(myForm);
        QObject::connect(horizontalSlider, SIGNAL(sliderMoved(int)), spinBox, SLOT(setValue(int)));
        QObject::connect(spinBox, SIGNAL(valueChanged(int)), horizontalSlider, SLOT(setValue(int)));
        QObject::connect(pushButton, SIGNAL(clicked()), myForm, SLOT(close()));

        QMetaObject::connectSlotsByName(myForm);
    } // setupUi

    void retranslateUi(QWidget *myForm)
    {
        myForm->setWindowTitle(QApplication::translate("myForm", "Form", 0, QApplication::UnicodeUTF8));
        heightlabel->setText(QApplication::translate("myForm", "Height", 0, QApplication::UnicodeUTF8));
        meterslabel->setText(QApplication::translate("myForm", "meters", 0, QApplication::UnicodeUTF8));
        pushButton->setText(QApplication::translate("myForm", "&Sortir", 0, QApplication::UnicodeUTF8));
    } // retranslateUi

};

namespace Ui {
    class myForm: public Ui_myForm {};
} // namespace Ui

QT_END_NAMESPACE

#endif // UI_MYFORM_H
