#pragma once

#include <QObject>
#include <QWebSocket>

class AuthSocketClient : public QObject {
    Q_OBJECT
public:
    explicit AuthSocketClient(QObject *parent = nullptr);

    Q_INVOKABLE void connectToServer(const QUrl &url);
    Q_INVOKABLE void sendLogin(const QString &username, const QString &password);

signals:
    void loginSuccess();
    void loginFailed();
    void connectionStatusChanged(bool connected);

private slots:
    void onConnected();
    void onTextMessageReceived(const QString &message);

private:
    QWebSocket socket;
};
