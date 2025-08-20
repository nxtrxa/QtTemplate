import QtQuick 6.6
import QtQuick.Controls 6.6
import QtQuick.Layouts 6.6
import QtQuick.Effects 6.6 // necessário para DropShadow
import Backend 1.0

ApplicationWindow {
    visible: true
    width: 1024
    height: 600
    title: "Slides com Header e Indicadores Animados"

    qmlRegisterType<AuthSocketClient>("Backend", 1, 0, "AuthSocketClient");

    property int currentSlide: 0
    property var slideImages: [
        "images/slide1.jpg",
        "images/slide2.jpg",
        "images/slide3.jpg"
    ]

        QtObject {
        id: themeManager
        property var theme: Theme // default (claro)
    }


    Timer {
        id: autoPlayTimer
        interval: 5000
        running: true
        repeat: true

        onTriggered: {
            currentSlide = (currentSlide + 1) % slideImages.length
        }
    }

    // ----------------------------
    // HEADER
    // ----------------------------
    Rectangle {
        id: header
        height: 60
        width: parent.width
        color: "#1f1f1f"
        anchors.top: parent.top

        RowLayout {
            anchors.fill: parent
            anchors.margins: 10

            // LOGO
            Rectangle {
                width: 150
                height: 40
                color: "transparent"
                Layout.alignment: Qt.AlignVCenter | Qt.AlignLeft

                Image {
                    source: "images/logo.png" // ou substitua por texto
                    anchors.fill: parent
                    fillMode: Image.PreserveAspectFit
                }
            }

            Item { Layout.fillWidth: true } // espaço flexível

            // BOTÕES
            RowLayout {
                spacing: 12

                Button {
                    text: "Configurações"
                    font.pixelSize: 14
                }

                Button {
                    text: "Entrar"
                    font.pixelSize: 14
                }

                Button {
                    text: "Registre-se"
                    font.pixelSize: 14
                }
                 Button {
                    text: "Tema Claro/Escuro"
                    onClicked: {
                        themeManager.theme = themeManager.theme === Theme ? DarkTheme : Theme
                    }
                }

                ToolButton {
                    text: "Entrar"
                    icon.source: "icons/login.svg"
                    font.pixelSize: 14
                }

                ToolButton {
                    text: "Registre-se"
                    icon.source: "icons/register.svg"
                    font.pixelSize: 14
                }
                    import Backend 1.0

                AuthManager {
                    id: auth
                }

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

            }
        }
    }

        Rectangle {
        width: 200
        height: 100
        color: themeManager.theme.background

        Label {
            text: "Bem-vindo"
            color: themeManager.theme.foreground
        }
    }


    // ----------------------------
    // SLIDES
    // ----------------------------
    Rectangle {
        id: slideContainer
        anchors.top: header.bottom
        anchors.left: parent.left
        anchors.right: parent.right
        anchors.bottom: parent.bottom
        color: "black"

        DropShadow {
            anchors.fill: slideImage
            source: slideImage
            radius: 12
            samples: 32
            verticalOffset: 4
            color: "#40000000"
        }


        Image {
            id: slideImage
            anchors.fill: parent
            source: slideImages[currentSlide]
            fillMode: Image.PreserveAspectCrop
            scale: 1.0
            opacity: 1.0

            Behavior on source {
                SequentialAnimation {
                    PropertyAnimation { target: slideImage; property: "opacity"; to: 0.0; duration: 300 }
                    ScriptAction { script: slideImage.source = slideImages[currentSlide] }
                    ParallelAnimation {
                        PropertyAnimation { target: slideImage; property: "opacity"; to: 1.0; duration: 300 }
                        PropertyAnimation { target: slideImage; property: "scale"; from: 1.05; to: 1.0; duration: 300 }
                    }
                }
            }
        }


        // ----------------------------
        // INDICADORES ANIMADOS
        // ----------------------------
        Row {
            id: indicators
            spacing: 12
            anchors.horizontalCenter: parent.horizontalCenter
            anchors.bottom: parent.bottom
            anchors.bottomMargin: 80

            Repeater {
                model: slideImages.length

                Rectangle {
                    id: dot
                    width: index === currentSlide ? 16 : 10
                    height: index === currentSlide ? 16 : 10
                    radius: width / 2
                    color: index === currentSlide ? "#ffffff" : "#888888"
                    opacity: 0.9
                    scale: index === currentSlide ? 1.2 : 1.0
                    Behavior on scale { NumberAnimation { duration: 200 } }
                    Behavior on width { NumberAnimation { duration: 200 } }
                    Behavior on height { NumberAnimation { duration: 200 } }
                    Behavior on color { ColorAnimation { duration: 200 } }

                    MouseArea {
                        anchors.fill: parent
                        onClicked: {
                            autoPlayTimer.restart()
                            currentSlide = index
                        }
                        cursorShape: Qt.PointingHandCursor
                    }
                }
            }
        }
    }

    // ----------------------------
    // NAVEGAÇÃO MANUAL
    // ----------------------------
    RowLayout {
        spacing: 20
        anchors.bottom: parent.bottom
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.bottomMargin: 20

        Button {
            text: "<"
            onClicked: {
                autoPlayTimer.restart()
                currentSlide = (currentSlide - 1 + slideImages.length) % slideImages.length
            }
        }

        Button {
            text: ">"
            onClicked: {
                autoPlayTimer.restart()
                currentSlide = (currentSlide + 1) % slideImages.length
            }
        }
    }
}
