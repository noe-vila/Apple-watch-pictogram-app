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
            if !isAuthenticationSuccessful && !isFaceId || viewModel.isFirstTimeLogin {
                SecureField("Contraseña", text: $viewModel.password)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .padding()
            }
            
            Toggle(biometricTypeText(), isOn: $isFaceId)
                .padding()
            
            Button(viewModel.isFirstTimeLogin ? "Guardar" : "Acceder") {
                
                if viewModel.isFirstTimeLogin {
                    guard !viewModel.password.isEmpty else {
                        viewModel.error = LoginError(message: "Debe ingresar una contraseña mínimo la primera vez")
                        return
                    }
                }
                if isFaceId {
                    authenticateWithFaceID()
                } else {
                    viewModel.isFirstTimeLogin ? viewModel.login() : viewModel.profileLogin()
                }
            }
            .padding()
            .alert(item: $viewModel.error) { error in
                Alert(title: Text("Error"), message: Text(error.message), dismissButton: .default(Text("OK")))
            }
        }
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
                        if viewModel.isFirstTimeLogin {
                            viewModel.faceIDLogin()
                        } else {
                            viewModel.faceIDProfileLogin()
                        }
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
                    // Fallback on earlier versions
                    return "Usar Biometrics"
                }
            } else {
                return "Dispositivo no soportado"
            }
        }
}
