//
//  SettingsView.swift
//  WatchTFM
//
//  Created by Noe Vila Muñoz on 25/5/23.
//

import SwiftUI

struct SettingsView: View {
    @State private var newPassword: String = ""
    @State private var isPasswordHidden: Bool = true
    @State private var isIconRotated: Bool = false
    
    var body: some View {
        VStack {
            HStack {
                if isPasswordHidden {
                    SecureField("Nueva contraseña", text: $newPassword)
                        .padding()
                        .cornerRadius(8)
                } else {
                    TextField("Nueva contraseña", text: $newPassword)
                        .padding()
                        .cornerRadius(8)
                }
                Button(action: {
                    withAnimation {
                        isPasswordHidden.toggle()
                        isIconRotated.toggle()
                    }
                }) {
                    Image(systemName: isPasswordHidden ? "eye.slash" : "eye")
                        .foregroundColor(.gray)
                        .rotationEffect(.degrees(isIconRotated ? 360 : 0))
                        .animation(.easeInOut, value: isPasswordHidden)
                }
            }
            .padding()
            Spacer()
            Button(action: {
                
            }) {
                ZStack {
                    RoundedRectangle(cornerRadius: 10)
                        .foregroundColor(newPassword.isEmpty ? Color.gray : Color.blue)
                        .frame(width: 120, height: 40)
                    HStack {
                        Text("Guardar")
                            .foregroundColor(.white)
                            .font(.system(size: 16, weight: .bold))
                        Image(systemName: "square.and.arrow.down")
                            .font(.system(size: 20))
                            .foregroundColor(.white)
                    }
                }
            }
            .disabled(newPassword.isEmpty)
        }
    }
}
