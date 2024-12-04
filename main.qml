import QtQuick 2.15
import QtQuick.Window 2.15
import QtQuick.Controls 2.15
import QtQuick.Layouts 1.3

Window {
    width: 640
    height: 480
    visible: true
    title: qsTr("Hello World")

    property string qrCodeUrl: ""
    property string sessionId: ""

    property string lockerSize: "xl"
    property int lockerPrice: 20
    property int lockerTime: 1800

    Component.onCompleted: {
        call_Session_Api()
        //qrCode_Session_Api()
    }

function call_Session_Api() {
        var xhr = new XMLHttpRequest()
        var url = "https://216e-103-85-8-42.ngrok-free.app/api/v1/start"; // API endpoint
        xhr.open("POST", url) // Use POST for sending data
        xhr.setRequestHeader("Content-Type", "application/json") // Specify JSON content type
        xhr.setRequestHeader("Accept", "application/json")
        xhr.setRequestHeader("ngrok-skip-browser-warning", "true")

        xhr.onreadystatechange = function() {
            if (xhr.readyState === XMLHttpRequest.DONE) {
                console.log("Response Text: " + xhr.responseText) // Log the response for debugging
                if (xhr.status === 200) {
                    try {
                        var response = JSON.parse(xhr.responseText)
                        console.log("Parsed Response: " + JSON.stringify(response))

                        if (response.success) {
                            // Store the session ID in the property
                            sessionId = response.session_id
                            console.log("Stored Session ID: " + sessionId )
                            responseText.text = "Session ID: " + sessionId
                        } else {
                            responseText.text = "Request was not successful."
                        }
                    } catch (e) {
                        console.log("JSON Parse Error: " + e)
                        //responseText.text = "Failed to parse JSON. See console for details."
                    }
                } else {
                    console.log("HTTP Error: " + xhr.status + " - " + xhr.statusText)
                    responseText.text = "HTTP Error: " + xhr.status + " - " + xhr.statusText
                }
            }
        }

        // Prepare the JSON body
        var body = JSON.stringify({
            type: "drop",
            device_name: "locker 2"
        })

        console.log("Request Body: " + body) // Log the request body for debugging
        xhr.send(body) // Send the JSON data
    }

function qrCode_Session_Api() {
        var xhr = new XMLHttpRequest()
        var url = "https://216e-103-85-8-42.ngrok-free.app/api/v1/get-qr-code?session_id=" + sessionId; // API endpoint
        xhr.open("POST", url) // Use POST for sending data
        xhr.setRequestHeader("Content-Type", "application/json") // Specify JSON content type
        xhr.setRequestHeader("Accept", "application/json")
        xhr.setRequestHeader("ngrok-skip-browser-warning", "true")

        xhr.onreadystatechange = function() {
            if (xhr.readyState === XMLHttpRequest.DONE) {
                console.log("Response Text: " + xhr.responseText) // Log the response for debugging
                if (xhr.status === 200) {
                    try {
                        var response = JSON.parse(xhr.responseText)
                        console.log("Parsed Response: " + JSON.stringify(response))

                        qrCodeUrl = response.qrCodeUrl;
                        console.log("QR Code URL: " + qrCodeUrl);

                        if (response.success) {
                            // Store the session ID in the property
                            sessionId = response.session_id
                            console.log("Stored Session ID: " + sessionId )
                            responseText.text = "Session ID: " + sessionId
                        } else {
                            responseText.text = "Request was not successful."
                        }
                    } catch (e) {
                        //console.log("JSON Parse Error: " + e)
                        responseText.text = "Failed to parse JSON. See console for details."
                    }
                } else {
                    console.log("HTTP Error: " + xhr.status + " - " + xhr.statusText)
                    responseText.text = "HTTP Error: " + xhr.status + " - " + xhr.statusText
                }
            }
        }

        // Prepare the JSON body
        var body = JSON.stringify({
            //type: "drop",
            amount: lockerPrice,
            locker_time: lockerTime,
            locker_type: lockerSize
        })

        console.log("Request Body: " + body) // Log the request body for debugging
        xhr.send(body) // Send the JSON data
    }

Image {
    id: razorPay
    source: qrCodeUrl
    anchors.centerIn: parent
}

    Timer {
        id: callQrfunctionTimer
        running: true
        interval: 3000
        onTriggered: {
            qrCode_Session_Api()
            running = false
        }
    }
}
