//
//  MQQTManager.swift
//  MQTT-iOS
//
//  Created by Dhaval Trivedi on 04/07/23.
//

import Foundation
import CocoaMQTT

// https://www.emqx.com/en/mqtt/public-mqtt5-broker
//The broker access information is as follows:
//
//Broker: broker.emqx.io
//TCP Port: 1883
//Websocket Port: 8083
//TCP/TLS Port: 8883
//Websocket/TLS Port:8084

class MQQTManager: NSObject, ObservableObject {
    
    static let shared = MQQTManager()
    var mqtt5: CocoaMQTT5!
    @Published var message: CocoaMQTT5Message!
    var setting: MqttSetting = .signedSSLSetting
    // Broker config
    let defaultHost = "broker-cn.emqx.io"
    var userName = "Dhaval"
    let mqttVesion = "5.0"
    @Published var isStartChat = false
    @Published var isReceiveNewMessage = false
    var clientID: String {
        let clientID = "CocoaMQTT5-\(userName)-" + String(ProcessInfo().processIdentifier)
        return clientID
    }
    var connectProperties: MqttConnectProperties {
        let connectProperties = MqttConnectProperties()
        connectProperties.topicAliasMaximum = 0
        connectProperties.sessionExpiryInterval = 0
        connectProperties.receiveMaximum = 100
        connectProperties.maximumPacketSize = 500
        return connectProperties
    }
    
    enum MqttSetting {
        case defaultSetting
        case signedSSLSetting
        case simpleSSLSetting
        case websocketSetting
        case websocketSSLSetting
        
        var port: UInt16 {
            switch self {
            case .defaultSetting:
                return 1883
            case .signedSSLSetting:
                return 8883
            case .simpleSSLSetting:
                return 8883
            case .websocketSetting:
                return 8083
            case .websocketSSLSetting:
                return 8084
            }
        }
    }
    @Published var state: CocoaMQTTConnState = .disconnected
    private override init() {
        super.init()
        selectServer()
    }
    func selectServer() {
        switch setting {
        case .defaultSetting:
            defaultMQTTSettings()
        case .simpleSSLSetting:
            simpleSSLSetting()
        case .signedSSLSetting:
            selfSignedSSLSetting()
        case .websocketSetting:
            mqttWebsocketsSetting()
        case .websocketSSLSetting:
            mqttWebsocketSSLSetting()
        }
    }
    func addCommonConfiguration() {
        mqtt5.connectProperties = connectProperties
        mqtt5.username = ""
        mqtt5.password = ""
        mqtt5.keepAlive = 60
        mqtt5.delegate = self
    }
    func connectToServer() {
        _ = mqtt5.connect()
    }
//    MQTT may not provide enough information for the server to perform authentication through CONNECT alone, so this feature is added in MQTT 5.0, which is used to strengthen authentication between the client and the server.
    func sendAuthToServer(){
        let authProperties = MqttAuthProperties()
        mqtt5.auth(reasonCode: CocoaMQTTAUTHReasonCode.continueAuthentication, authProperties: authProperties)
    }
    func defaultMQTTSettings() {
        mqtt5 = CocoaMQTT5(clientID: clientID, host: defaultHost, port: MqttSetting.defaultSetting.port)
        addCommonConfiguration()
        let lastWillMessage = CocoaMQTT5Message(topic: "/will", string: "dieout")
        lastWillMessage.contentType = "JSON"
        lastWillMessage.willResponseTopic = "/will"
        lastWillMessage.willExpiryInterval = .max
        lastWillMessage.willDelayInterval = 0
        lastWillMessage.qos = .qos1
        mqtt5.willMessage = lastWillMessage
        //mqtt5!.autoReconnect = true
    }
    func simpleSSLSetting() {
        mqtt5 = CocoaMQTT5(clientID: clientID, host: defaultHost, port: MqttSetting.simpleSSLSetting.port)
        addCommonConfiguration()
        mqtt5.willMessage = CocoaMQTT5Message(topic: "/will", string: "dieout")
        mqtt5.enableSSL = true
    }
    func selfSignedSSLSetting() {
        mqtt5 = CocoaMQTT5(clientID: clientID, host: defaultHost, port: MqttSetting.signedSSLSetting.port)
        mqtt5.connectProperties = connectProperties
        addCommonConfiguration()
        mqtt5.willMessage = CocoaMQTT5Message(topic: "/will", string: "dieout")
        mqtt5.enableSSL = true
        mqtt5.allowUntrustCACertificate = true
        let clientCertArray = getClientCertFromP12File(certName: "client-keycert", certPassword: "MySecretPassword")
        var sslSettings: [String: NSObject] = [:]
        sslSettings[kCFStreamSSLCertificates as String] = clientCertArray
        mqtt5.sslSettings = sslSettings
    }
    func mqttWebsocketsSetting() {
        let websocket = CocoaMQTTWebSocket(uri: "/mqtt")
        mqtt5 = CocoaMQTT5(clientID: clientID, host: defaultHost, port: MqttSetting.websocketSetting.port, socket: websocket)
        addCommonConfiguration()
        let lastWillMessage = CocoaMQTT5Message(topic: "/will", string: "dieout")
        lastWillMessage.contentType = "JSON"
        lastWillMessage.willExpiryInterval = .max
        lastWillMessage.willDelayInterval = 0
        lastWillMessage.qos = .qos1
        mqtt5.willMessage = lastWillMessage
    }
    func mqttWebsocketSSLSetting() {
        let websocket = CocoaMQTTWebSocket(uri: "/mqtt")
        mqtt5 = CocoaMQTT5(clientID: clientID, host: defaultHost, port: MqttSetting.websocketSSLSetting.port, socket: websocket)
        addCommonConfiguration()
        mqtt5.enableSSL = true
        mqtt5.willMessage = CocoaMQTT5Message(topic: "/will", string: "dieout")
    }
    func getClientCertFromP12File(certName: String, certPassword: String) -> CFArray? {
        // get p12 file path
        let resourcePath = Bundle.main.path(forResource: certName, ofType: "p12")
        
        guard let filePath = resourcePath, let p12Data = NSData(contentsOfFile: filePath) else {
            print("Failed to open the certificate file: \(certName).p12")
            return nil
        }
        
        // create key dictionary for reading p12 file
        let key = kSecImportExportPassphrase as String
        let options : NSDictionary = [key: certPassword]
        
        var items : CFArray?
        
        let securityError = SecPKCS12Import(p12Data, options, &items)
        
        guard securityError == errSecSuccess else {
            if securityError == errSecAuthFailed {
                print("ERROR: SecPKCS12Import returned errSecAuthFailed. Incorrect password?")
            } else {
                print("Failed to open the certificate file: \(certName).p12")
            }
            return nil
        }
        
        guard let theArray = items, CFArrayGetCount(theArray) > 0 else {
            return nil
        }
        
        let dictionary = (theArray as NSArray).object(at: 0)
        guard let identity = (dictionary as AnyObject).value(forKey: kSecImportItemIdentity as String) else {
            return nil
        }
        let certArray = [identity] as CFArray
        
        return certArray
    }
    
    func getMessengerName(topic: String) -> String {
        guard let name = topic.components(separatedBy: "/").last else {
            return ""
        }
        return name
    }
}

extension MQQTManager: CocoaMQTT5Delegate {
    
    func mqtt5(_ mqtt5: CocoaMQTT5, didReceiveDisconnectReasonCode reasonCode: CocoaMQTTDISCONNECTReasonCode) {
        print("disconnect res : \(reasonCode)")
    }
    
    func mqtt5(_ mqtt5: CocoaMQTT5, didReceiveAuthReasonCode reasonCode: CocoaMQTTAUTHReasonCode) {
        print("auth res : \(reasonCode)")
    }
    
    // Optional ssl CocoaMQTT5Delegate
    func mqtt5(_ mqtt5: CocoaMQTT5, didReceive trust: SecTrust, completionHandler: @escaping (Bool) -> Void) {
        print("trust: \(trust)")
        /// Validate the server certificate
        ///
        /// Some custom validation...
        ///
        /// if validatePassed {
        ///     completionHandler(true)
        /// } else {
        ///     completionHandler(false)
        /// }
        completionHandler(true)
    }
    
    func mqtt5(_ mqtt5: CocoaMQTT5, didConnectAck ack: CocoaMQTTCONNACKReasonCode, connAckData: MqttDecodeConnAck?) {
        print("ack: \(ack)")

        if ack == .success {
            if(connAckData != nil){
                print("properties maximumPacketSize: \(String(describing: connAckData!.maximumPacketSize))")
                print("properties topicAliasMaximum: \(String(describing: connAckData!.topicAliasMaximum))")
            }

            mqtt5.subscribe("chat/room/animals/client/+", qos: CocoaMQTTQoS.qos0)
            //or
            //let subscriptions : [MqttSubscription] = [MqttSubscription(topic: "chat/room/animals/client/+"),MqttSubscription(topic: "chat/room/foods/client/+"),MqttSubscription(topic: "chat/room/trees/client/+")]
            //mqtt.subscribe(subscriptions)

//            let chatViewController = storyboard?.instantiateViewController(withIdentifier: "ChatViewController") as? ChatViewController
//            chatViewController?.mqtt5 = mqtt5
//            chatViewController?.mqttVersion = mqttVesion
//            navigationController!.pushViewController(chatViewController!, animated: true)

        }
    }
    
    func mqtt5(_ mqtt5: CocoaMQTT5, didStateChangeTo state: CocoaMQTTConnState) {
        print("new state: \(state)")
        if state == .connected {
            isStartChat = true
        }
        self.state = state
    }
    
    func mqtt5(_ mqtt5: CocoaMQTT5, didPublishMessage message: CocoaMQTT5Message, id: UInt16) {
        print("message: \(message.description), id: \(id)")
    }
    
    func mqtt5(_ mqtt5: CocoaMQTT5, didPublishAck id: UInt16, pubAckData: MqttDecodePubAck?) {
        print("id: \(id)")
        if(pubAckData != nil){
            print("pubAckData reasonCode: \(String(describing: pubAckData!.reasonCode))")
        }
    }

    func mqtt5(_ mqtt5: CocoaMQTT5, didPublishRec id: UInt16, pubRecData: MqttDecodePubRec?) {
        print("id: \(id)")
        if(pubRecData != nil){
            print("pubRecData reasonCode: \(String(describing: pubRecData!.reasonCode))")
        }
    }

    func mqtt5(_ mqtt5: CocoaMQTT5, didPublishComplete id: UInt16,  pubCompData: MqttDecodePubComp?){
        print("id: \(id)")
        if(pubCompData != nil){
            print("pubCompData reasonCode: \(String(describing: pubCompData!.reasonCode))")
        }
    }

    func mqtt5(_ mqtt5: CocoaMQTT5, didReceiveMessage message: CocoaMQTT5Message, id: UInt16, publishData: MqttDecodePublish?){
        print("message: \(message.string!.description), id: \(id)")
        receive(message: message, publishData: publishData)
    }
    
    func mqtt5(_ mqtt5: CocoaMQTT5, didSubscribeTopics success: NSDictionary, failed: [String], subAckData: MqttDecodeSubAck?) {
        print("subscribed: \(success), failed: \(failed)")
        if(subAckData != nil){
            print("subAckData.reasonCodes \(String(describing: subAckData!.reasonCodes))")
        }
    }
    
    func mqtt5(_ mqtt5: CocoaMQTT5, didUnsubscribeTopics topics: [String], UnsubAckData: MqttDecodeUnsubAck?) {
        print("topic: \(topics)")
        if(UnsubAckData != nil){
            print("unsubAckData.reasonCodes \(String(describing: UnsubAckData!.reasonCodes))")
        }
        print("----------------------")
    }
    
    func mqtt5DidPing(_ mqtt5: CocoaMQTT5) {
        print("mqtt5DidPing")
    }
    
    func mqtt5DidReceivePong(_ mqtt5: CocoaMQTT5) {
        print("mqtt5DidReceivePong")
    }

    func mqtt5DidDisconnect(_ mqtt5: CocoaMQTT5, withError err: Error?) {
        print("\(err?.localizedDescription ?? "")")
        let name = NSNotification.Name(rawValue: "MQTTMessageNotificationDisconnect")
        NotificationCenter.default.post(name: name, object: nil)
    }
}

// Communication
extension MQQTManager {
    
    func send(
        message: String
    ) {
        let publishProperties = MqttPublishProperties()
        publishProperties.contentType = "JSON"
        mqtt5.publish(
            "chat/room/animals/client/" + userName,
            withString: message,
            qos: .qos1,
            DUP: true,
            retained: false,
            properties: publishProperties
        )
    }
    func receive(
        message: CocoaMQTT5Message,
        publishData: MqttDecodePublish?
    ) {
        if(publishData != nil) {
            print("publish.contentType \(String(describing: publishData!.contentType))")
        }
        if getMessengerName(topic: message.topic) == userName {
            return
        }
        self.message = message
        self.isReceiveNewMessage = true
    }
}
