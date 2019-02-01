/*
  +----------------------------------------------------------------------+
  | PHP Version 7                                                        |
  +----------------------------------------------------------------------+
  | Copyright (c) 2006-2019 The PHP Group                                |
  +----------------------------------------------------------------------+
  | This source file is subject to version 3.01 of the PHP license,      |
  | that is bundled with this package in the file LICENSE, and is        |
  | available through the world-wide-web at the following url:           |
  | http://www.php.net/license/3_01.txt                                  |
  | If you did not receive a copy of the PHP license and are unable to   |
  | obtain it through the world-wide-web, please send a note to          |
  | license@php.net so we can mail you a copy immediately.               |
  +----------------------------------------------------------------------+
*/

#ifndef SDK_FOUNDATION_OPAQUE_IMPL_I
#define SDK_FOUNDATION_OPAQUE_IMPL_I

/*
  Template definitions for opaque_impl<X> constructors/destructors
  and methods. It is crucial that this file is included only in
  the file that implements class X that inherits from opaque_impl<X>
  and that this file contains IMPL_TYPE() declaration for such a
  class X. Otherwise compiler will complain that impl_traits<X> structure,
  which is used by templates, is not defined.

  This header should not be included from public CDK headers.
*/

#include "opaque_impl.h"
#include "static_assert.h"

namespace cdk {
namespace foundation {

  // The wrapper around concrete implementation type

  template<class X>
  struct opaque_impl<X>::_Impl
    : public impl_traits<X>::impl_type
  {
    private: _Impl();
  };

  // Method to access internal implementation object

  template<class X>
  typename opaque_impl<X>::_Impl&
  opaque_impl<X>::get_impl() const
  {
    return *m_impl;
  }

  /*
    Constructors that pass arguments to internal implementation
    object constructor.
  */

  template<class X>
  template <typename A>
  inline opaque_impl<X>::opaque_impl(void*, A a)
  {
    typedef typename impl_traits<X>::impl_type impl_type;
    m_impl= (_Impl*)new impl_type(a);
  }

  template<class X>
  template <typename A, typename B>
  inline opaque_impl<X>::opaque_impl(void*, A a, B b)
  {
    typedef typename impl_traits<X>::impl_type impl_type;
    m_impl= (_Impl*)new impl_type(a,b);
  }

  template<class X>
  template <typename A, typename B, typename C>
  inline opaque_impl<X>::opaque_impl(void*, A a, B b, C c)
  {
    typedef typename impl_traits<X>::impl_type impl_type;
    m_impl= (_Impl*)new impl_type(a,b,c);
  }

}}  // cdk::foundation


/*
  Macro to declare type of implementation.

  Note: Specialization of impl_traits<> must be defined inside cdk::foundation
  namespace. Macro IMPL_TYPE puts the definition inside this namespace and
  for that reason it must be used outside of any other namespaces.
*/

#define IMPL_TYPE(X,Y) \
  namespace cdk {                                         \
  namespace foundation {                                  \
    template<> struct impl_traits<X>                      \
    {                                                     \
      typedef Y impl_type;                                \
      static void default_constructor_instantiate();      \
      static void copy_constructor_instantiate(const X&); \
    };                                                    \
  }}  // cdk::foundation


/*
  Macros to define opaque_impl<X> destructor and special constructors
  (if needed).

  One of these macros should be put in exactly one compilation unit
  of the project that uses opaque_impl<X>.
*/

#define IMPL_PLAIN(X) \
  namespace cdk {                                         \
  namespace foundation {                                  \
    template<>                                            \
    opaque_impl<X>::~opaque_impl() { delete m_impl; }     \
  }}  // cdk::foundation

#define IMPL_DEFAULT(X) \
  IMPL_PLAIN(X)         \
  IMPL_DEFAULT_CONS(X)  \

#define IMPL_COPY(X) \
  IMPL_PLAIN(X)      \
  IMPL_COPY_CONS(X)  \

#define IMPL_DEFAULTCOPY(X) \
  IMPL_PLAIN(X)         \
  IMPL_DEFAULT_CONS(X)  \
  IMPL_COPY_CONS(X)     \

/*
  Macros to define default or copy constructors for particular specialization
  of opaque_impl<X> template. These constructors use default/copy constructor
  of the underlying concrete implementation type. Thus they should be defined
  only if the underlying implementation supports default/copy constructor.
*/

#define IMPL_DEFAULT_CONS(X) \
  namespace cdk {                                   \
  namespace foundation {                            \
    template<>                                      \
    opaque_impl<X>::opaque_impl()                   \
    {                                               \
      typedef impl_traits<X>::impl_type impl_type;  \
      m_impl = (_Impl*) new impl_type();            \
    }                                               \
    IMPL_DEFAULT_INSTANTIATE(X)                     \
  }}  // cdk::foundation


#define IMPL_COPY_CONS(X) \
  namespace cdk {                                                   \
  namespace foundation {                                            \
    template<> inline                                               \
    opaque_impl<X>::opaque_impl(const opaque_impl<X> &i)            \
    {                                                               \
      typedef impl_traits<X>::impl_type impl_type;                  \
      m_impl= (_Impl*) new impl_type(*(impl_type*)i.m_impl);        \
    }                                                               \
    template <> template <> inline                                  \
    opaque_impl<X>::opaque_impl(const impl_traits<X>::impl_type &i) \
    {                                                               \
      typedef impl_traits<X>::impl_type impl_type;                  \
      m_impl= (_Impl*) new impl_type(i);                            \
    }                                                               \
    template <> template <> inline                                  \
    opaque_impl<X>::opaque_impl(const X &x)                         \
    {                                                               \
      typedef impl_traits<X>::impl_type impl_type;                  \
      _Impl &i = ((const opaque_impl<X>&)x).get_impl();             \
      m_impl= (_Impl*) new impl_type(i);                            \
    }                                                               \
    IMPL_COPY_INSTANTIATE(X)                                        \
  }}  // cdk::foundation


/*
  Trigger generation of default/copy constructor by compiler from the
  templates. Mere presence of template specializations is not sufficient
  for compiler to generate actual code. Thus compiler complained about
  missing symbols even though IMPL_DEFAULT() or IMPL_COPY() define explicit
  specializations (at least on Windows).

  The solution is to define a phony function which uses either default
  or copy constructor. This proved to be enough to get the compiler to
  generate and emit constructor code to the output.

  It is not sure if this will work with aggressive compile optimizations
  that could optimize-out code of unused functions.
*/

#define IMPL_DEFAULT_INSTANTIATE(X) \
  void impl_traits<X>::default_constructor_instantiate() \
  { X x; }

#define IMPL_COPY_INSTANTIATE(X) \
  void impl_traits<X>::copy_constructor_instantiate(const X &x0) \
  { X x(x0); }

#endif
