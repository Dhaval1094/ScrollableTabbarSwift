//
//  ChatView.swift
//  MQTT-iOS
//
//  Created by Dhaval Trivedi on 05/07/23.
//

import SwiftUI

struct ChatView: View {
    @State private var message: String = ""
    @StateObject private var manager = MQQTManager.shared
    var body: some View {
        VStack {
            TextField("Enter your message", text: $message)
                .frame(height: 40)
                .textFieldStyle(PlainTextFieldStyle())
                .multilineTextAlignment(.center)
                .overlay(RoundedRectangle(cornerRadius: 6).stroke(Color.gray))
                .padding(.horizontal, 10)
            Button {
                manager.send(message: message)
                message = ""
            } label: {
                Text("Send")
            }
            .padding(.bottom, 30)
            if manager.message != nil && manager.isReceiveNewMessage {
                Text("From \n \(manager.getMessengerName(topic: manager.message.topic))")
                    .font(.largeTitle)
                    .padding(.bottom, 10)
                Text("\(manager.message.string!)")
                    .padding()
                    .font(.title3)
                    .border(.red)
                    .foregroundColor(.blue)
                    
                Text("Data: \(manager.message.description)")
                    .font(.body)
            }
        }
    }
}

