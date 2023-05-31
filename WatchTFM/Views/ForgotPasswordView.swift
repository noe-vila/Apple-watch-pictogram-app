//
//  ForgotPasswordView.swift
//  WatchTFM
//
//  Created by Noe Vila Muñoz on 31/5/23.
//

import SwiftUI
import UIKit

struct ForgotPasswordView: View {
    @StateObject var viewModel: LoginViewModel
    @Binding var showForgotPassword: Bool
    @State private var restored = false
    
    var body: some View {
        VStack {
            Spacer()
            EmailView(email: $viewModel.email)
            if restored {
                HStack {
                    Text("Se ha enviado un correo con las instrucciones para restaurar tu contraseña a \(viewModel.email)")
                    Spacer()
                }
                .padding(.horizontal)
            }
            ForgotButtonView(viewModel: viewModel, restored: $restored, showForgotPassword: $showForgotPassword)
            Spacer()
        }
        .animation(.default, value: restored)
    }
}

struct ForgotButtonView: View {
    @Environment(\.colorScheme) var colorScheme: ColorScheme
    @ObservedObject var viewModel: LoginViewModel
    @Binding var restored: Bool
    @Binding var showForgotPassword: Bool
    @State private var pulsed = false
    
    var body: some View {
        Button(action: {
            hideKeyboard()
            if restored {
                showForgotPassword = false
            } else {
                pulsed = true
                viewModel.firebaseResetPasswordEmail() { error in
                    if error == nil {
                        restored = true
                    }
                    pulsed = false
                }
            }
        }) {
            if pulsed {
                ProgressView()
                    .progressViewStyle(CircularProgressViewStyle(tint: Color.black))
            } else {
                Text(restored ? "Entendido".uppercased() : "Restaura tu contraseña".uppercased())
                    .font(.headline)
                    .background(Color.clear)
                    .foregroundColor(.black)
                    .frame(maxWidth: .infinity)
            }
        }
        .buttonStyle(LoginButtonStyle())
        .background(Color.primary.opacity(colorScheme == .light ? 0.2 : 0.8))
        .cornerRadius(5)
        .padding()
        .alert(item: $viewModel.error) { error in
            Alert(title: Text("Error"), message: Text(error.message), dismissButton: .default(Text("OK")))
        }
    }
}

extension View {
    func hideKeyboard() {
        UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
}
