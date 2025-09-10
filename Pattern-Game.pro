# Obstacle Car - Full Project (Qt Quick/QML + C++)
# Version: v2 — qmake Version
# Added Score, Improved Graphics, 10 Obstacles, Levels
# Files included below. Save each section to the named file (filename indicated by '/// File: <name>').
QT += quick gui qml
CONFIG += c++17
TEMPLATE = app
TARGET = ObstacleCar
SOURCES += main.cpp \
    AIController.cpp


DISTFILES += \
    android/AndroidManifest.xml \
    android/build.gradle \
    android/gradle.properties \
    android/gradle/wrapper/gradle-wrapper.jar \
    android/gradle/wrapper/gradle-wrapper.properties \
    android/gradlew \
    android/gradlew.bat \
    android/res/values/libs.xml \
    android/res/xml/qtprovider_paths.xml

contains(ANDROID_TARGET_ARCH,arm64-v8a) {
    ANDROID_PACKAGE_SOURCE_DIR = \
        $$PWD/android
}

RESOURCES += \
    qml.qrc

HEADERS += \
    AIController.h
