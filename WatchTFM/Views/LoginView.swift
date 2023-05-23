//
//  LoginView.swift
//  WatchTFM
//
//  Created by Noe Vila Muñoz on 23/5/23.
//

import SwiftUI

struct LoginView: View {
    @Binding var isLoggedIn: Bool
    @State private var password = ""
    
    var body: some View {
        VStack {
            SecureField("Contraseña", text: $password)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding()
            
            Button("Iniciar sesión") {
                if password == "contrasena" { // Aquí puedes establecer tu contraseña válida
                    isLoggedIn = true
                } else {
                    // Manejar la contraseña incorrecta, mostrar mensaje de error, etc.
                }
            }
            .padding()
        }
    }
}
