
AC_INIT([fap3-vis], [0.1], [yuri.borisov.v@gmail.com])

AM_INIT_AUTOMAKE([-Wall])

AC_CONFIG_FILES([
		 Makefile
		 src/Makefile
		 test/Makefile
		 ])


AC_PROG_CC
AC_PROG_CXX
AC_PROG_LIBTOOL

# Configure options: --enable-debug[=no].
AC_ARG_ENABLE([debug],
	      [AS_HELP_STRING([--enable-debug],
			      [enable debug code (default is no)])],
			      [debug="$withval"], [debug=no])



PKG_CHECK_MODULES(GLFW, [glfw3 >= 3.0], , [
    AC_MSG_ERROR([You must have 'libglfw' dev headers (libglfw3-dev) installed
    ]) ])

AC_SUBST(GLFW_CFLAGS)
AC_SUBST(GLFW_LIBS)


PKG_CHECK_MODULES(GLEW, [glew >= 1.10], , [
    AC_MSG_ERROR([You must have 'libglew' dev headers (libglew-dev) installed
    ]) ])

AC_SUBST(GLEW_CFLAGS)
AC_SUBST(GLEW_LIBS)


PKG_CHECK_MODULES(FREETYPE2, [freetype2 >= 17.1.11], , [
    AC_MSG_ERROR([You must have 'freetype2' dev headers (libfreetype6-dev) installed
    ]) ])

AC_SUBST(FREETYPE2_CFLAGS)
AC_SUBST(FREETYPE2_LIBS)


PKG_CHECK_MODULES(FTGL, [ftgl >= 2.1.3], , [
    AC_MSG_ERROR([You must have 'ftgl' dev headers (libftgl-dev) installed
    ]) ])

AC_SUBST(FTGL_CFLAGS)
AC_SUBST(FTGL_LIBS)




# libgl1-mesa-dev package doesn't include pc file so cannot be processed by pkg check
#PKG_CHECK_MODULES(GL1MESA, [libgl1-mesa-dev >= 10.1.3], , [
#    AC_MSG_ERROR([You must have 'freeglut3' dev headers (libgl1-mesa-dev) installed
#    ]) ])

AC_SUBST(GL1MESA_CFLAGS)
AC_SUBST(GL1MESA_LIBS)

GL1MESA_CFLAGS="-lGL"



PKG_CHECK_MODULES(FAP3, [libfap3 >= 0.1], , [
    AC_MSG_ERROR([You must have 'libfap3' dev headers (libfap3-dev) installed
    ]) ])

AC_SUBST(FAP3_CFLAGS)
AC_SUBST(FAP3_LIBS)


PKG_CHECK_MODULES([LIBCPPU], [cppunit >= 1.13], , [AC_MSG_ERROR([
You must have the libcppunit-1.13 and development headers installed to build.
])])

AC_SUBST(LIBCPPU_CFLAGS)
AC_SUBST(LIBCPPU_LIBS)

CXXFLAGS="-std=c++11 -Wno-deprecated-declarations"

if test x$debug = xyes; then
    CXXFLAGS="$CXXFLAGS -g -O0"
else
#    CXXFLAGS="-g -O2"
    CXXFLAGS="$CXXFLAGS -g -O0"
fi


CXXFLAGS="$CXXFLAGS $FAP3_CFLAGS $GLFW_CFLAGS  $GL1MESA_CFLAGS  $GLEW_CFLAGS $FREETYPE2_CFLAGS $FTGL_CFLAGS" 
LDFLAGS="$LDFLAGS $FAP3_LIBS $GLFW_LIBS $GL1MESA_LIBS $GLEW_LIBS $FREETYPE2_LIBS $FTGL_LIBS"

AC_CONFIG_FILES([fap3vis.pc])

AC_OUTPUT

echo CXXFLAGS $CXXFLAGS
echo "
($PACKAGE_NAME) version $PACKAGE_VERSION
Prefix.........: $prefix
Debug Build....: $debug
C++ Compiler...: $CXX $CXXFLAGS $CPPFLAGS
Linker.........: $LD $LDFLAGS $LIBS
Doxygen........: ${DOXYGEN:-NONE}
"

