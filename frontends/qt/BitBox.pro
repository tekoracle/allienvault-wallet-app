#-------------------------------------------------
#
# Project created by QtCreator 2017-10-23T04:39:47
#
#-------------------------------------------------

QT       += core gui
QT       += webenginewidgets

TARGET = BitBox
TEMPLATE = app

CFORTIFY = -O2 -D_FORTIFY_SOURCE=2
CSTACK = -fstack-protector-all -fstack-check
CMISC = -fwrapv
CASLR = -fPIE -fPIC

# The following define makes your compiler emit warnings if you use
# any feature of Qt which has been marked as deprecated (the exact warnings
# depend on your compiler). Please consult the documentation of the
# deprecated API in order to know how to port your code away from it.
DEFINES += QT_DEPRECATED_WARNINGS

win32 {
    # -llibssp would be nice to have on Windows
    LIBS += -L$$PWD/server/ -llibserver
    DESTDIR = $$PWD/build/windows
    RC_ICONS += $$PWD/resources/win/icon.ico
    # These flags aren't currently being respected at build time on Windows
    #QMAKE_CXXFLAGS += $$CFORTIFY
    #QMAKE_CXXFLAGS += $$CSTACK
    #QMAKE_CXXFLAGS += $$CMISC
    #QMAKE_LFLAGS += -Wl,--nxcompat
    #QMAKE_LFLAGS += -Wl,--dynamicbase
} else {
    QMAKE_CXXFLAGS += -std=c++11
    LIBS += -L$$PWD/server -lserver
    QMAKE_CXXFLAGS += $$CFORTIFY
    QMAKE_CXXFLAGS += $$CSTACK
    QMAKE_CXXFLAGS += $$CMISC
}

# https://stackoverflow.com/questions/18462420/how-to-specify-mac-platform-in-qmake-qtcreator
unix:!macx {
    QMAKE_LFLAGS_RPATH=
    # so libserver.so will be found by linuxdeployqt, once copied into the same folder.
    QMAKE_LFLAGS += '-Wl,-rpath,\'\$$ORIGIN\''
    QMAKE_LFLAGS += " -pie -Wl,-z,now,-z,relro,-z,noexecstack,-z,defs "
}

SOURCES += \
        main.cpp

HEADERS += libserver.h webclass.h

unix:macx {
    # Those frameworks are needed for Go's http/net packages.
    # Waiting for https://github.com/golang/go/issues/11258 to be able to automatically capture link flags.
    LIBS += -framework CoreFoundation -framework Security
    # QMAKE_RPATHDIR = @executable_path/../Frameworks
    QMAKE_LFLAGS += "-pie -s -w"
}
