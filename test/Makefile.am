bin_PROGRAMS = ut-fap3vis-lib

AM_CPPFLAGS = -D_PLAT_LINUX_ -g -O0

ut_fap3vis_lib_SOURCES = \
		       ut_main.cpp \
		       ut_wdg.cpp

ut_fap3vis_lib_LDFLAGS=-L../src/.libs/ -lfap3vis -lfap3  -lcppunit -lrt
ut_fap3vis_lib_CXXFLAGS=-I@srcdir@/../src

check: test_fap3vis_lib

test_fap3vis_lib:
	 ./ut-fap3vis-lib


