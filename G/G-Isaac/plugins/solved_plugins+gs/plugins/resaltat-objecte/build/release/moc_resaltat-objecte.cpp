/****************************************************************************
** Meta object code from reading C++ file 'resaltat-objecte.h'
**
** Created:
**      by: The Qt Meta Object Compiler version 63 (Qt 4.8.4)
**
** WARNING! All changes made in this file will be lost!
*****************************************************************************/

#include "../../include/resaltat-objecte.h"
#if !defined(Q_MOC_OUTPUT_REVISION)
#error "The header file 'resaltat-objecte.h' doesn't include <QObject>."
#elif Q_MOC_OUTPUT_REVISION != 63
#error "This file was generated using the moc from 4.8.4. It"
#error "cannot be used with the include files from this version of Qt."
#error "(The moc has changed too much.)"
#endif

QT_BEGIN_MOC_NAMESPACE
static const uint qt_meta_data_ResaltatObjecte[] = {

 // content:
       6,       // revision
       0,       // classname
       0,    0, // classinfo
       0,    0, // methods
       0,    0, // properties
       0,    0, // enums/sets
       0,    0, // constructors
       0,       // flags
       0,       // signalCount

       0        // eod
};

static const char qt_meta_stringdata_ResaltatObjecte[] = {
    "ResaltatObjecte\0"
};

void ResaltatObjecte::qt_static_metacall(QObject *_o, QMetaObject::Call _c, int _id, void **_a)
{
    Q_UNUSED(_o);
    Q_UNUSED(_id);
    Q_UNUSED(_c);
    Q_UNUSED(_a);
}

const QMetaObjectExtraData ResaltatObjecte::staticMetaObjectExtraData = {
    0,  qt_static_metacall 
};

const QMetaObject ResaltatObjecte::staticMetaObject = {
    { &QObject::staticMetaObject, qt_meta_stringdata_ResaltatObjecte,
      qt_meta_data_ResaltatObjecte, &staticMetaObjectExtraData }
};

#ifdef Q_NO_DATA_RELOCATION
const QMetaObject &ResaltatObjecte::getStaticMetaObject() { return staticMetaObject; }
#endif //Q_NO_DATA_RELOCATION

const QMetaObject *ResaltatObjecte::metaObject() const
{
    return QObject::d_ptr->metaObject ? QObject::d_ptr->metaObject : &staticMetaObject;
}

void *ResaltatObjecte::qt_metacast(const char *_clname)
{
    if (!_clname) return 0;
    if (!strcmp(_clname, qt_meta_stringdata_ResaltatObjecte))
        return static_cast<void*>(const_cast< ResaltatObjecte*>(this));
    if (!strcmp(_clname, "EffectInterface"))
        return static_cast< EffectInterface*>(const_cast< ResaltatObjecte*>(this));
    if (!strcmp(_clname, "edu.upc.fib.graug.EffectInterface/1.0"))
        return static_cast< EffectInterface*>(const_cast< ResaltatObjecte*>(this));
    return QObject::qt_metacast(_clname);
}

int ResaltatObjecte::qt_metacall(QMetaObject::Call _c, int _id, void **_a)
{
    _id = QObject::qt_metacall(_c, _id, _a);
    if (_id < 0)
        return _id;
    return _id;
}
QT_END_MOC_NAMESPACE
