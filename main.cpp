#include <QGuiApplication>
#include <QQmlApplicationEngine>
#include <QQmlContext>
#include "calcengine.h"

int main(int argc, char *argv[])
{
    qputenv("QSG_RENDER_LOOP", "basic");

    QGuiApplication app(argc, argv);

    CalcEngine calcEngine;
    QQmlApplicationEngine engine;

    engine.rootContext()->setContextProperty("calc", &calcEngine);

    QObject::connect(
        &engine,
        &QQmlApplicationEngine::objectCreationFailed,
        &app,
        []() { QCoreApplication::exit(-1); },
        Qt::QueuedConnection
    );

    engine.loadFromModule("KawaiiCalc", "Main");

    return app.exec();
}