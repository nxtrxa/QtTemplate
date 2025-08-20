// authmanager.h
#pragma once
#include <QObject>

class AuthManager : public QObject {
    Q_OBJECT
public:
    explicit AuthManager(QObject *parent = nullptr);

    Q_INVOKABLE bool login(const QString &username, const QString &password);
    Q_INVOKABLE bool registerUser(const QString &username, const QString &password);
};
