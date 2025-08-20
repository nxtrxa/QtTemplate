// authmanager.cpp
#include "authmanager.h"

AuthManager::AuthManager(QObject *parent) : QObject(parent) {}

bool AuthManager::login(const QString &username, const QString &password) {
    // Autenticação real (pode chamar banco, API, etc.)
    return username == "admin" && password == "123";
}

bool AuthManager::registerUser(const QString &username, const QString &password) {
    // Simulação de cadastro
    return true;
}
