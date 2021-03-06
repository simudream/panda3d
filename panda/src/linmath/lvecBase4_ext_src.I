// Filename: lvecBase4_ext_src.I
// Created by:  rdb (02Jan11)
//
////////////////////////////////////////////////////////////////////
//
// PANDA 3D SOFTWARE
// Copyright (c) Carnegie Mellon University.  All rights reserved.
//
// All use of this software is subject to the terms of the revised BSD
// license.  You should have received a copy of this license along
// with this source code in a file named "LICENSE."
//
////////////////////////////////////////////////////////////////////

#ifdef FLOATTYPE_IS_INT
#if PY_MAJOR_VERSION >= 3
#define PYNUMBER_FLOATTYPE PyNumber_Long
#define PY_FROM_FLOATTYPE PyLong_FromLong
#define PY_AS_FLOATTYPE PyLong_AS_LONG
#else
#define PYNUMBER_FLOATTYPE PyNumber_Int
#define PY_FROM_FLOATTYPE PyInt_FromLong
#define PY_AS_FLOATTYPE PyInt_AS_LONG
#endif
#else
#define PYNUMBER_FLOATTYPE PyNumber_Float
#define PY_FROM_FLOATTYPE PyFloat_FromDouble
#define PY_AS_FLOATTYPE PyFloat_AsDouble
#endif

////////////////////////////////////////////////////////////////////
//     Function: LVecBase4::__setitem__
//       Access: Public
//  Description:
////////////////////////////////////////////////////////////////////
INLINE_LINMATH void Extension<FLOATNAME(LVecBase4)>::
__setitem__(int i, FLOATTYPE v) {
  nassertv(i >= 0 && i < 4);
  _this->_v(i) = v;
}

////////////////////////////////////////////////////////////////////
//     Function: LVecBase4::python_repr
//       Access: Published
//  Description:
////////////////////////////////////////////////////////////////////
INLINE_LINMATH void Extension<FLOATNAME(LVecBase4)>::
python_repr(ostream &out, const string &class_name) const {
  out << class_name << "("
      << MAYBE_ZERO(_this->_v(0)) << ", "
      << MAYBE_ZERO(_this->_v(1)) << ", "
      << MAYBE_ZERO(_this->_v(2)) << ", "
      << MAYBE_ZERO(_this->_v(3)) << ")";
}

////////////////////////////////////////////////////////////////////
//     Function: LVecBase4::__reduce__
//       Access: Published
//  Description: This special Python method is implement to provide
//               support for the pickle module.
////////////////////////////////////////////////////////////////////
INLINE_LINMATH PyObject *Extension<FLOATNAME(LVecBase4)>::
__reduce__(PyObject *self) const {
  // We should return at least a 2-tuple, (Class, (args)): the
  // necessary class object whose constructor we should call
  // (e.g. this), and the arguments necessary to reconstruct this
  // object.
  PyObject *this_class = PyObject_Type(self);
  if (this_class == NULL) {
    return NULL;
  }

#if FLOATTOKEN == 'i'
  PyObject *result = Py_BuildValue("(O(iiii))", this_class,
                                   (*_this)[0], (*_this)[1], (*_this)[2], (*_this)[3]);
#elif FLOATTOKEN == 'f'
  PyObject *result = Py_BuildValue("(O(ffff))", this_class,
                                   (*_this)[0], (*_this)[1], (*_this)[2], (*_this)[3]);
#else
  PyObject *result = Py_BuildValue("(O(dddd))", this_class,
                                   (*_this)[0], (*_this)[1], (*_this)[2], (*_this)[3]);
#endif

  Py_DECREF(this_class);
  return result;
}

////////////////////////////////////////////////////////////////////
//     Function: LVecBase4::__getattr__
//       Access: Published
//  Description: This is used to implement swizzle masks.
////////////////////////////////////////////////////////////////////
INLINE_LINMATH PyObject *Extension<FLOATNAME(LVecBase4)>::
__getattr__(const string &attr_name) const {
#ifndef CPPPARSER
  extern struct Dtool_PyTypedObject FLOATNAME(Dtool_LVecBase2);
  extern struct Dtool_PyTypedObject FLOATNAME(Dtool_LVecBase3);
  extern struct Dtool_PyTypedObject FLOATNAME(Dtool_LVecBase4);
#endif

  // Validate the attribute name.
  for (string::const_iterator it = attr_name.begin(); it < attr_name.end(); it++) {
    if (*it < 'w' || *it > 'z') {
      return NULL;
    }
  }

  switch (attr_name.size()) {
    case 1:
      if (attr_name[0] == 'w') {
        return PY_FROM_FLOATTYPE(_this->_v(3));
      } else {
        return PY_FROM_FLOATTYPE(_this->_v(attr_name[0] - 'x'));
      }

    case 2: {
      FLOATNAME(LVecBase2) *vec = new FLOATNAME(LVecBase2);
      vec->_v(0) = _this->_v((attr_name[0] == 'w') ? 3 : attr_name[0] - 'x');
      vec->_v(1) = _this->_v((attr_name[1] == 'w') ? 3 : attr_name[1] - 'x');
      return DTool_CreatePyInstance((void *)vec, FLOATNAME(Dtool_LVecBase2), true, false);

    } case 3: {
      FLOATNAME(LVecBase3) *vec = new FLOATNAME(LVecBase3);
      vec->_v(0) = _this->_v((attr_name[0] == 'w') ? 3 : attr_name[0] - 'x');
      vec->_v(1) = _this->_v((attr_name[1] == 'w') ? 3 : attr_name[1] - 'x');
      vec->_v(2) = _this->_v((attr_name[2] == 'w') ? 3 : attr_name[2] - 'x');
      return DTool_CreatePyInstance((void *)vec, FLOATNAME(Dtool_LVecBase3), true, false);

    } case 4: {
      FLOATNAME(LVecBase4) *vec = new FLOATNAME(LVecBase4);
      vec->_v(0) = _this->_v((attr_name[0] == 'w') ? 3 : attr_name[0] - 'x');
      vec->_v(1) = _this->_v((attr_name[1] == 'w') ? 3 : attr_name[1] - 'x');
      vec->_v(2) = _this->_v((attr_name[2] == 'w') ? 3 : attr_name[2] - 'x');
      vec->_v(3) = _this->_v((attr_name[3] == 'w') ? 3 : attr_name[3] - 'x');
      return DTool_CreatePyInstance((void *)vec, FLOATNAME(Dtool_LVecBase4), true, false);
    }
  }

  return NULL;
}

////////////////////////////////////////////////////////////////////
//     Function: LVecBase4::__setattr__
//       Access: Published
//  Description: This is used to implement write masks.
////////////////////////////////////////////////////////////////////
INLINE_LINMATH int Extension<FLOATNAME(LVecBase4)>::
__setattr__(PyObject *self, const string &attr_name, PyObject *assign) {
#ifndef NDEBUG
  // Validate the attribute name.
  for (string::const_iterator it = attr_name.begin(); it < attr_name.end(); it++) {
    if (*it < 'w' || *it > 'z') {
      PyTypeObject *tp = self->ob_type;
      PyErr_Format(PyExc_AttributeError,
                   "'%.100s' object has no attribute '%.200s'",
                   tp->tp_name, attr_name.c_str());
      return -1;
    }
  }
#endif

  // It is a sequence, perhaps another vector?
  if (PySequence_Check(assign)) {

    // Whoosh.
    PyObject* fast = PySequence_Fast(assign, "");
    nassertr(fast != NULL, -1);

    // Let's be strict about size mismatches, to prevent user error.
    if (PySequence_Fast_GET_SIZE(fast) != (int)attr_name.size()) {
      PyErr_SetString(PyExc_ValueError, "length mismatch");
      Py_DECREF(fast);
      return -1;
    }

    // Get a pointer to the items, iterate over it and
    // perform our magic assignment.  Fast fast.  Oh yeah.
    PyObject** items = PySequence_Fast_ITEMS(fast);
    for (size_t i = 0; i < attr_name.size(); ++i) {

      PyObject* fl = PYNUMBER_FLOATTYPE(items[i]);
      if (fl == NULL) {
        // Oh darn.  Not when we've come this far.
#ifdef FLOATTYPE_IS_INT
        PyErr_SetString(PyExc_ValueError, "a sequence of integers is required");
#else
        PyErr_SetString(PyExc_ValueError, "a sequence of floats is required");
#endif
        Py_DECREF(fast);
        return -1;
      }
      FLOATTYPE value = PY_AS_FLOATTYPE(fl);
      Py_DECREF(fl);

      _this->_v((attr_name[i] == 'w') ? 3 : attr_name[i] - 'x') = value;
    }

    Py_DECREF(fast);

  } else {
    // Maybe it's a single floating-point value.
    PyObject* fl = PYNUMBER_FLOATTYPE(assign);

    if (fl == NULL) {
      // It's not a floating-point value either?
      // Sheesh, I don't know what to do with it then.
      if (attr_name.size() == 1) {
#ifdef FLOATTYPE_IS_INT
        PyErr_SetString(PyExc_ValueError, "an integer is required");
#else
        PyErr_SetString(PyExc_ValueError, "a float is required");
#endif
      } else {
        PyErr_Format(PyExc_ValueError, "'%.200s' object is not iterable",
          assign->ob_type->tp_name);
      }
      return -1;
    }
    FLOATTYPE value = PY_AS_FLOATTYPE(fl);
    Py_DECREF(fl);

    // Loop through the components in the attribute name,
    // and assign the floating-point value to every one of them.
    for (string::const_iterator it = attr_name.begin(); it < attr_name.end(); it++) {
      _this->_v(((*it) == 'w') ? 3 : (*it) - 'x') = value;
    }
  }

  return 0;
}

////////////////////////////////////////////////////////////////////
//     Function: LVecBase4::__pow__
//       Access: Public
//  Description:
////////////////////////////////////////////////////////////////////
INLINE_LINMATH FLOATNAME(LVecBase4) Extension<FLOATNAME(LVecBase4)>::
__pow__(FLOATTYPE exponent) const {
  return FLOATNAME(LVecBase4)(
    cpow(_this->_v(0), exponent),
    cpow(_this->_v(1), exponent),
    cpow(_this->_v(2), exponent),
    cpow(_this->_v(3), exponent));
}

////////////////////////////////////////////////////////////////////
//     Function: LVecBase4::__ipow__
//       Access: Public
//  Description:
////////////////////////////////////////////////////////////////////
INLINE_LINMATH PyObject *Extension<FLOATNAME(LVecBase4)>::
__ipow__(PyObject *self, FLOATTYPE exponent) {
  _this->_v(0) = cpow(_this->_v(0), exponent);
  _this->_v(1) = cpow(_this->_v(1), exponent);
  _this->_v(2) = cpow(_this->_v(2), exponent);
  _this->_v(3) = cpow(_this->_v(3), exponent);
  Py_INCREF(self);
  return self;
}

////////////////////////////////////////////////////////////////////
//     Function: UnalignedLVecBase4::__setitem__
//       Access: Public
//  Description:
////////////////////////////////////////////////////////////////////
INLINE_LINMATH void Extension<FLOATNAME(UnalignedLVecBase4)>::
__setitem__(int i, FLOATTYPE v) {
  nassertv(i >= 0 && i < 4);
  _this->_v(i) = v;
}

#undef PYNUMBER_FLOATTYPE
#undef PY_FROM_FLOATTYPE
#undef PY_AS_FLOATTYPE
