includedir = @includedir@/libfap3vis

libdir = @libdir@/fap3/plugins

# Scene rendering solutions:
# _SDR_ enable feature "Scene direct rendering"
# _SIU_RDC_ enable feature "Scene incr update. RDC solution"
# _SIU_UCI_ enable feature "Scene incr update. Up-to-down, change detection. Invalidation."

AM_CPPFLAGS = -D_PLAT_LINUX_ -D_SIU_UCI_ -g -O0

lib_LTLIBRARIES = libfap3vis.la

libfap3vis_la_SOURCES = \
		       plugin.cpp \
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
		       button.h \
		       button.cpp \
		       container.h \
		       container.cpp \
		       vlayout.h \
		       vlayout.cpp \
		       hlayout.h \
		       hlayout.cpp \
		       alignment.h \
		       alignment.cpp \
		       agentvr.h \
		       agentvr.cpp \
		       systdrp.h \
		       systdrp.cpp \
		       label.h \
		       label.cpp

include_HEADERS = \
		  mwidget.h \
		  mvisenv.h \
		  mwindow.h \
		  mcontainer.h \
                  mscel.h


libfap3vis_la_LDFLAGS = -rdynamic -no-undefined -lrt
