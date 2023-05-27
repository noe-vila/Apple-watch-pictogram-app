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
    @Binding var showSettings: Bool
    @State private var changedPassword = false
    @State private var showCheckmark = false
    @State private var hideText = false
    let viewModel: LoginViewModel
    
    var body: some View {
        VStack {
            HStack (spacing: 20) {
                if isPasswordHidden {
                    SecureField("Nueva contraseña", text: $newPassword)
                        .font(.system(size: 20))
                        .padding()
                        .cornerRadius(8)
                } else {
                    TextField("Nueva contraseña", text: $newPassword)
                        .font(.system(size: 20))
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
                        .rotationEffect(.degrees(isIconRotated ? 180 : 0))
                        .animation(.easeInOut, value: isPasswordHidden)
                }
                if newPassword.count > 6 {
                    Button(action: {
                        viewModel.changePassword(newPassword: newPassword)
                        changedPassword = true
                        
                        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                            changedPassword = false
                        }
                    }) {
                        Image(systemName: changedPassword ? "checkmark" : "square.and.arrow.down")
                            .accentColor(changedPassword ? .green : .gray)
                            .rotationEffect(.degrees(changedPassword ? 360 : 0))
                            .animation(.easeInOut, value: changedPassword)
                        
                    }
                }
                
                
            }
            .animation(.default, value: newPassword.count > 6)
            .padding()
            
            Spacer()
            
            
            Button(action: {
                showCheckmark = true
                DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                    showCheckmark = false
                    showSettings = false
                    viewModel.firebaseLogout()
                }
            }) {
                ZStack {
                    RoundedRectangle(cornerRadius: showCheckmark ? 100 : 3)
                        .foregroundColor(showCheckmark ? Color.green : Color.gray)
                        .frame(width: showCheckmark ? 40 : 200, height: 40)
                        if !showCheckmark {
                            Text("Cerrar sesión")
                                .foregroundColor(.white)
                                .font(.system(size: 20))
                        } else {
                            Image(systemName: "checkmark")
                                .font(.system(size: 20))
                                .foregroundColor(.white)
                        }
                }
                .padding(.all)
                .animation(.default, value: showCheckmark)
            }
            .padding(.bottom)
        }
    }
}
