//
//  ContentView.swift
//  MQTT-iOS
//
//  Created by Dhaval Trivedi on 04/07/23.
//

import SwiftUI

struct HomeView: View {
    @State private var name: String = "Dhaval"
    @StateObject private var manager = MQQTManager.shared
    var body: some View {
        NavigationView {
            VStack(alignment: .center) {
                HStack {
                    Text("Your name :")
                    TextField("Enter your name", text: $name)
                        .frame(height: 40)
                        .textFieldStyle(PlainTextFieldStyle())
                        .multilineTextAlignment(.center)
                        .overlay(RoundedRectangle(cornerRadius: 6).stroke(Color.gray))
                        .padding(.horizontal, 10)
                }
                .padding(.bottom, 10)
                Text("Hello, \(name)!")
                    .padding(.bottom, 10)
                switch manager.state {
                case .connecting:
                    Text("Connecting...")
                    ProgressView()
                        .progressViewStyle(.circular)
                case .connected:
                    Text("Connected")
                case .disconnected:
                    Button {
                        manager.userName = name
                        manager.connectToServer()
                    } label: {
                        Text("Connect")
                    }
                }
                if manager.isStartChat {
                    NavigationLink(destination: ChatView(), isActive: $manager.isStartChat) {
                        EmptyView()
                    }
                }
            }
            .padding()
            .onAppear {
                
            }
        }
    }
}

