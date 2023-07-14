//
//  ContentView.swift
//  AsyncTestCases
//
//  Created by Dhaval Trivedi on 06/07/23.
//

import SwiftUI

struct UserDetailsView: View {
    @StateObject private var viewModel = UserDetailsViewModel()
    @State private var name: String = "Nathan"
    var body: some View {
        ZStack {
            VStack {
                Image("user")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 100, height: 100)
                    .clipShape(Circle())
                    .padding(.top, 60)
                TextField("Enter name", text: $name)
                    .frame(height: 40)
                    .textFieldStyle(PlainTextFieldStyle())
                    .multilineTextAlignment(.center)
                    .overlay(RoundedRectangle(cornerRadius: 6).stroke(Color.gray))
                    .padding(.horizontal, 10)
                Button.init {
                    Task {
                        try await viewModel.getUserDetails(name: name)
                    }
                } label: {
                    Text("Search")
                }
                
                if viewModel.user != nil {
                    Text(viewModel.user.name)
                        .padding()
                        .font(.title)
                        .foregroundColor(.black)
                        .padding(.bottom, 40)
                    HStack {
                        Text("Country")
                            .font(.title2)
                            .padding(20)
                        Spacer()
                        Text("Probabillity")
                            .font(.title2)
                    }
                    List(viewModel.user.country, id: \.self) { country in
                        HStack {
                            Text(country.countryID.description)
                                .font(.headline)
                                .padding(20)
                            Spacer()
                            Text((country.probability * 100.0).description + "%")
                                .font(.headline)
                        }
                    }
                    Spacer()
                }
            }
            .padding()
            if viewModel.isShowIndicator {
                ProgressView()
                    .frame(width: 100, height: 100)
                    .progressViewStyle(.circular)
            }
        }
    }
}
