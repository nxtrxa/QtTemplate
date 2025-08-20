#include <QGuiApplication>
#include <QQmlApplicationEngine>
#include "authmanager.h"

int main(int argc, char *argv[]) {
    QGuiApplication app(argc, argv);
    QQmlApplicationEngine engine;

    qmlRegisterType<AuthManager>("Backend", 1, 0, "AuthManager");

    engine.load(QUrl(QStringLiteral("qrc:/main.qml")));
    return app.exec();
}
