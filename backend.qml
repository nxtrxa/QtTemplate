import Backend 1.0

AuthSocketClient {
    id: authClient

    onLoginSuccess: console.log("✅ Login autorizado via WebSocket")
    onLoginFailed: console.log("❌ Login recusado")

    Component.onCompleted: {
        authClient.connectToServer("ws://localhost:12345")
    }
}

Button {
    text: "Entrar"
    onClicked: {
        authClient.sendLogin("admin", "123") // ou pegue de TextField
    }
}
