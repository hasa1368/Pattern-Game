# Pattern Game - Full Project (Qt Quick/QML + C++)
# Version: v2 — qmake Version
# About the Developer
#My name is Hamed Sadeghi Firouzja, a software engineer with expertise in Qt, QML, and Android development. I am passionate about creating innovative applications, combining technology and creativity to deliver enjoyable user experiences.
#About the Game
#This project is a Pattern game developed with Qt6 and QML. It features dynamic shapes, multiple levels, and a scoring system that challenges the player to improve their performance. The game is designed to be both fun and engaging, while also showcasing the power of modern cross-platform development.
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



