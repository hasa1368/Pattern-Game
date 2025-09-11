#include <QGuiApplication>
#include <QQmlApplicationEngine>
#include <QFontDatabase>
#include <QDebug>
#include<AIController.h>
#include <QQmlContext>

int main(int argc, char *argv[])
{
    QGuiApplication app(argc, argv);

    int fontId = QFontDatabase::addApplicationFont(":/fonts/iransans.ttf");
    if (fontId == -1) {
        qWarning() << "Font load failed!";
    }
    QQmlApplicationEngine engine;
    AIController ai;
    engine.rootContext()->setContextProperty("AI", &ai);
    const QUrl url(u"qrc:/qml/Main.qml"_qs);
    QObject::connect(&engine, &QQmlApplicationEngine::objectCreated,
                     &app, [url](QObject *obj, const QUrl &objUrl) {
                         if (!obj && url == objUrl)
                             QCoreApplication::exit(-1);
                     }, Qt::QueuedConnection);
    engine.load(url);


    return app.exec();
}
