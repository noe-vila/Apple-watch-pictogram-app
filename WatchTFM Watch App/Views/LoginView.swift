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
    @Binding var refreshHome: Bool
    
    var body: some View {
        VStack (spacing: 10) {
            Spacer()
            TextField("Email".uppercased(), text: $viewModel.email)
                .foregroundColor(.white)
            
            SecureField("Password".uppercased(), text: $viewModel.password)
                .foregroundColor(.white)
            
            if (!viewModel.email.isEmpty && !viewModel.password.isEmpty) {
                Button(action: {
                    viewModel.firebaseLogin()
                    refreshHome.toggle()
                }) {
                    Text("Login".uppercased())
                        .foregroundColor(Color.black)
                }
                .background(Color.primary)
                .cornerRadius(10)
                .disabled(viewModel.email.isEmpty || viewModel.password.isEmpty)
                .alert(item: $viewModel.error) { error in
                    Alert(title: Text("Error"), message: Text(error.message), dismissButton: .default(Text("OK")))
                }
            }
            Spacer()
        }
        .animation(.default, value: !viewModel.email.isEmpty && !viewModel.password.isEmpty)
        .padding(.horizontal)
        .edgesIgnoringSafeArea(.all)
        .navigationBarHidden(true)
    }
}
