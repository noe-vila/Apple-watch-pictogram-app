//
//  LoginView.swift
//  WatchTFM
//
//  Created by Noe Vila Muñoz on 23/5/23.
//

import SwiftUI
import LocalAuthentication

struct LoginView: View {
    @StateObject var viewModel: LoginViewModel
    @State private var isAuthenticationSuccessful = false
    @State private var isFaceId = UserDefaults.standard.bool(forKey: "isFaceIdEnabled")
    
    var body: some View {
        VStack {
            
            if !viewModel.isLoggedIn {
                TextField("Correo electrónico", text: $viewModel.email)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .padding()
                    .keyboardType(.emailAddress)
                    .autocapitalization(.none)
            }
            
            if !viewModel.isLoggedIn || !viewModel.isProfileLoggedIn && !isFaceId {
                SecureField("Contraseña", text: $viewModel.password)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .padding()
            }
            
            if viewModel.isLoggedIn{
                Toggle(biometricTypeText(), isOn: $isFaceId)
                    .padding()
                    .frame(width: 200)
            }
            
            HStack {
                Button(viewModel.isLoggedIn ? "Acceder" : "Login") {
                    if isFaceId {
                        authenticateWithFaceID()
                    } else {
                        viewModel.isLoggedIn ? viewModel.profileLogin() : viewModel.firebaseLogin()
                    }
                    UserDefaults.standard.set(isFaceId, forKey: "isFaceIdEnabled")
                }
                .buttonStyle(.bordered)
                .padding()
                .alert(item: $viewModel.error) { error in
                    Alert(title: Text("Error"), message: Text(error.message), dismissButton: .default(Text("OK")))
                }
                if !viewModel.isLoggedIn{
                    Button("Registrarse") {
                        viewModel.firebaseSignup()
                    }
                    .buttonStyle(.bordered)
                    .padding()
                    .alert(item: $viewModel.error) { error in
                        Alert(title: Text("Error"), message: Text(error.message), dismissButton: .default(Text("OK")))
                    }
                }
            }
        }
        .animation(.default, value: isFaceId)
    }
    
    private func authenticateWithFaceID() {
        guard isFaceId else {
            viewModel.profileLogin()
            return
        }
        
        let context = LAContext()
        var error: NSError?
        
        if context.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: &error) {
            let reason = "Autenticación requerida"
            context.evaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, localizedReason: reason) { success, authenticationError in
                DispatchQueue.main.async {
                    if success {
                        isAuthenticationSuccessful = true
                        UserDefaults.standard.set(true, forKey: "isFaceIdEnabled")
                        viewModel.faceIDProfileLogin()
                    } else {
                        fallbackToPassword()
                    }
                }
            }
        } else {
            fallbackToPassword()
        }
    }
    
    private func fallbackToPassword() {
        isAuthenticationSuccessful = false
        isFaceId = false
        UserDefaults.standard.set(false, forKey: "isFaceIdEnabled")
    }
    
    private func biometricTypeText() -> String {
            let context = LAContext()
            var error: NSError?
            
            if context.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: &error) {
                if #available(iOS 11.0, *) {
                    switch context.biometryType {
                    case .faceID:
                        return "Usar Face ID"
                    case .touchID:
                        return "Use Touch ID"
                    default:
                        return "Usar Biometrics"
                    }
                } else {
                    return "Usar Biometrics"
                }
            } else {
                return "Dispositivo no soportado"
            }
        }
}
