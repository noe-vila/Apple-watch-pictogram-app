//
//  LoginViewModel.swift
//  WatchTFM
//
//  Created by Noe Vila Muñoz on 25/5/23.
//

import Foundation
import SwiftUI

struct LoginError: Identifiable {
    let id = UUID()
    let message: String
}

class LoginViewModel: ObservableObject {
    @Published var isLoggedIn: Bool = UserDefaults.standard.bool(forKey: "isLoggedIn")
    @Published var isProfileLoggedIn: Bool = UserDefaults.standard.bool(forKey: "isProfileLoggedIn")
    @Published var isFirstTimeLogin: Bool = !UserDefaults.standard.bool(forKey: "hasPassword")
    @Published var password: String = ""
    @Published var error: LoginError? = nil
    
    func login() {
        guard let savedPassword = UserDefaults.standard.string(forKey: "password") else {
            isLoggedIn = true
            isFirstTimeLogin = false
            UserDefaults.standard.set(true, forKey: "hasPassword")
            UserDefaults.standard.set(password, forKey: "password")
            UserDefaults.standard.set(isLoggedIn, forKey: "isLoggedIn")
            password = ""
            return
        }
        if password == savedPassword {
            isLoggedIn = true
            password = ""
            UserDefaults.standard.set(isLoggedIn, forKey: "isLoggedIn")
        } else {
            error = LoginError(message: "Contraseña incorrecta")
        }
    }
    
    func faceIDLogin() {
        isLoggedIn = true
        isFirstTimeLogin = false
        UserDefaults.standard.set(true, forKey: "hasPassword")
        UserDefaults.standard.set(password, forKey: "password")
        UserDefaults.standard.set(isLoggedIn, forKey: "isLoggedIn")
    }
    
    func faceIDProfileLogin() {
        isProfileLoggedIn = true
        UserDefaults.standard.set(isLoggedIn, forKey: "isProfileLoggedIn")
    }
    
    func profileLogin() {
        if let savedPassword = UserDefaults.standard.string(forKey: "password") {
            if password == savedPassword {
                isProfileLoggedIn = true
                password = ""
                UserDefaults.standard.set(isProfileLoggedIn, forKey: "isProfileLoggedIn")
            } else {
                error = LoginError(message: "Contraseña incorrecta")
            }
        }
    }
    
    func profileLogout() {
        isProfileLoggedIn = false
        password = ""
        UserDefaults.standard.set(isProfileLoggedIn, forKey: "isProfileLoggedIn")
        
    }
    
    func logout() {
        isLoggedIn = false
        isFirstTimeLogin = false
        password = ""
        UserDefaults.standard.set(isLoggedIn, forKey: "isLoggedIn")
        UserDefaults.standard.set(false, forKey: "hasPassword")
    }
    
    func changePassword(newPassword: String) {
        UserDefaults.standard.set(newPassword, forKey: "password")
    }
}
