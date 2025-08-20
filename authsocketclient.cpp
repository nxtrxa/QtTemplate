#include "authsocketclient.h"
#include <QJsonDocument>
#include <QJsonObject>

AuthSocketClient::AuthSocketClient(QObject *parent) : QObject(parent) {
    connect(&socket, &QWebSocket::connected, this, &AuthSocketClient::onConnected);
    connect(&socket, &QWebSocket::textMessageReceived, this, &AuthSocketClient::onTextMessageReceived);
}

void AuthSocketClient::connectToServer(const QUrl &url) {
    socket.open(url);
}

void AuthSocketClient::onConnected() {
    emit connectionStatusChanged(true);
}

void AuthSocketClient::sendLogin(const QString &username, const QString &password) {
    QJsonObject obj;
    obj["type"] = "login";
    obj["username"] = username;
    obj["password"] = password;
    socket.sendTextMessage(QJsonDocument(obj).toJson());
}

void AuthSocketClient::onTextMessageReceived(const QString &message) {
    QJsonDocument doc = QJsonDocument::fromJson(message.toUtf8());
    QJsonObject obj = doc.object();

    if (obj["type"] == "loginResult") {
        bool success = obj["success"].toBool();
        success ? emit loginSuccess() : emit loginFailed();
    }
}
