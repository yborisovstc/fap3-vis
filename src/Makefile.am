includedir = @includedir@/libfap3vis

libdir = @libdir@/fap3/plugins

AM_CPPFLAGS = -D_PLAT_LINUX_ -g -O0

lib_LTLIBRARIES = libfap3vis.la

libfap3vis_la_SOURCES = \
		       mwidget.h \
		       mscel.h \
		       mvisenv.h \
		       mwindow.h \
		       visenv.h \
		       visenv.cpp \
		       visprov.h \
		       visprov.cpp \
		       scene.h \
		       scene.cpp \
		       widget.h \
		       widget.cpp \
		       label.h \
		       label.cpp

include_HEADERS = \
		  mwidget.h \
		  mvisenv.h \
		  mwindow.h \
                  mscel.h


libfap3vis_la_LDFLAGS = -rdynamic -no-undefined -lrt
