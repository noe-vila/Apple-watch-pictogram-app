//
//  LoginViewModel.swift
//  WatchTFM
//
//  Created by Noe Vila Muñoz on 25/5/23.
//

import Foundation
import SwiftUI
import Firebase

struct LoginError: Identifiable {
    let id = UUID()
    let message: String
}

class LoginViewModel: ObservableObject {
    @Published var isLoggedIn: Bool = false
    @Published var isProfileLoggedIn: Bool = UserDefaults.standard.bool(forKey: "isProfileLoggedIn")
    @Published var email: String = ""
    @Published var password: String = ""
    @Published var error: LoginError? = nil
    var user: User?
    
    
    init() {
        if let authUser = Auth.auth().currentUser {
            isLoggedIn = true
            isProfileLoggedIn = false
            user = authUser
        }
    }
    
    func firebaseLogin(completion: @escaping (Bool) -> Void) {
        Auth.auth().signIn(withEmail: email, password: password) { [weak self] result, error in
            guard let self = self else { return }
            
            if let error = error {
                self.error = LoginError(message: error.localizedDescription)
                completion(false) // Call completion with false to indicate failure
            } else {
                self.handleSuccessfulLogin()
                completion(true) // Call completion with true to indicate success
            }
        }
    }
    
    func firebaseSignup() {
        Auth.auth().createUser(withEmail: email, password: password) { [weak self] result, error in
            guard let self = self else { return }
            
            if let error = error {
                self.error = LoginError(message: error.localizedDescription)
            } else {
                self.handleSuccessfulLogin()
            }
        }
    }
    
    func firebaseResetPasswordEmail(completion: @escaping (Error?) -> Void) {
        Auth.auth().sendPasswordReset(withEmail: email) { [weak self] error in
            guard let self = self else { return }
            if let error = error {
                self.error = LoginError(message: error.localizedDescription)
            }
            completion(error)
        }
    }

    private func handleSuccessfulLogin() {
        isLoggedIn = true
        isProfileLoggedIn = false
        UserDefaults.standard.set(password, forKey: "password")
        password = ""
        user = Auth.auth().currentUser
    }
    
    func firebaseLogout() {
        do {
            try Auth.auth().signOut()
            isLoggedIn = false
            isProfileLoggedIn = false
            UserDefaults.standard.set(isProfileLoggedIn, forKey: "isProfileLoggedIn")
            UserDefaults.standard.set(false, forKey: "isFaceIdEnabled")
        } catch let signOutError as NSError {
            print("Error signing out: %@", signOutError)
        }
    }
    
    func changePassword(newPassword: String) {
        if let user = Auth.auth().currentUser {
            user.updatePassword(to: newPassword) { [weak self] error in
                guard let self = self else { return }
                
                if let error = error {
                    self.error = LoginError(message: error.localizedDescription)
                } else {
                    UserDefaults.standard.set(true, forKey: "hasPassword")
                    UserDefaults.standard.set(newPassword, forKey: "password")
                    self.password = ""
                    self.error = nil
                }
            }
        }
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
}
