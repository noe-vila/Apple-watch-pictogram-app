//
//  LoginView.swift
//  WatchTFM Watch App
//
//  Created by Noe Vila Muñoz on 28/5/23.
//

import SwiftUI

struct LoginView: View {
    @State private var email: String = ""
    @StateObject var viewModel: LoginViewModel
    
    var body: some View {
        VStack {
            TextField("Email", text: $viewModel.email)
                .textFieldStyle(PlainTextFieldStyle())
                .padding()
            SecureField("Password", text: $viewModel.password)
                .textFieldStyle(PlainTextFieldStyle())
                .padding()
            Button(action: {
                viewModel.firebaseLogin()
            }) {
                Text("Okay")
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color.blue)
                    .foregroundColor(.white)
                    .cornerRadius(10)
            }
            .padding()
            
            Spacer()
        }
    }
}
