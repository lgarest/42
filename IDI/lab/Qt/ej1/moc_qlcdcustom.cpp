/****************************************************************************
** Meta object code from reading C++ file 'qlcdcustom.h'
**
** Created by: The Qt Meta Object Compiler version 63 (Qt 4.8.6)
**
** WARNING! All changes made in this file will be lost!
*****************************************************************************/

#include "qlcdcustom.h"
#if !defined(Q_MOC_OUTPUT_REVISION)
#error "The header file 'qlcdcustom.h' doesn't include <QObject>."
#elif Q_MOC_OUTPUT_REVISION != 63
#error "This file was generated using the moc from 4.8.6. It"
#error "cannot be used with the include files from this version of Qt."
#error "(The moc has changed too much.)"
#endif

QT_BEGIN_MOC_NAMESPACE
static const uint qt_meta_data_qlcdCustom[] = {

 // content:
       6,       // revision
       0,       // classname
       0,    0, // classinfo
       2,   14, // methods
       0,    0, // properties
       0,    0, // enums/sets
       0,    0, // constructors
       0,       // flags
       0,       // signalCount

 // slots: signature, parameters, type, tag, flags
      12,   11,   11,   11, 0x0a,
      22,   11,   11,   11, 0x0a,

       0        // eod
};

static const char qt_meta_stringdata_qlcdCustom[] = {
    "qlcdCustom\0\0setZero()\0setNum(int)\0"
};

void qlcdCustom::qt_static_metacall(QObject *_o, QMetaObject::Call _c, int _id, void **_a)
{
    if (_c == QMetaObject::InvokeMetaMethod) {
        Q_ASSERT(staticMetaObject.cast(_o));
        qlcdCustom *_t = static_cast<qlcdCustom *>(_o);
        switch (_id) {
        case 0: _t->setZero(); break;
        case 1: _t->setNum((*reinterpret_cast< int(*)>(_a[1]))); break;
        default: ;
        }
    }
}

const QMetaObjectExtraData qlcdCustom::staticMetaObjectExtraData = {
    0,  qt_static_metacall 
};

const QMetaObject qlcdCustom::staticMetaObject = {
    { &QLCDNumber::staticMetaObject, qt_meta_stringdata_qlcdCustom,
      qt_meta_data_qlcdCustom, &staticMetaObjectExtraData }
};

#ifdef Q_NO_DATA_RELOCATION
const QMetaObject &qlcdCustom::getStaticMetaObject() { return staticMetaObject; }
#endif //Q_NO_DATA_RELOCATION

const QMetaObject *qlcdCustom::metaObject() const
{
    return QObject::d_ptr->metaObject ? QObject::d_ptr->metaObject : &staticMetaObject;
}

void *qlcdCustom::qt_metacast(const char *_clname)
{
    if (!_clname) return 0;
    if (!strcmp(_clname, qt_meta_stringdata_qlcdCustom))
        return static_cast<void*>(const_cast< qlcdCustom*>(this));
    return QLCDNumber::qt_metacast(_clname);
}

int qlcdCustom::qt_metacall(QMetaObject::Call _c, int _id, void **_a)
{
    _id = QLCDNumber::qt_metacall(_c, _id, _a);
    if (_id < 0)
        return _id;
    if (_c == QMetaObject::InvokeMetaMethod) {
        if (_id < 2)
            qt_static_metacall(this, _c, _id, _a);
        _id -= 2;
    }
    return _id;
}
QT_END_MOC_NAMESPACE