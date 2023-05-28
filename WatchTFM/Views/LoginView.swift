import SwiftUI
import LocalAuthentication

struct LoginView: View {
    @StateObject var viewModel: LoginViewModel
    @State private var isAuthenticationSuccessful = false
    @State private var isProfileLogin = false
    @State private var isRegister = false
    @State private var isFaceId = UserDefaults.standard.bool(forKey: "isFaceIdEnabled")
    
    var body: some View {
        VStack {
            
            Spacer()
            if !isProfileLogin {
                TitleView()
            }
            if !isRegister {
                if !viewModel.isLoggedIn {
                    EmailView(email: $viewModel.email)
                }
                if !viewModel.isLoggedIn || !viewModel.isProfileLoggedIn && !isFaceId {
                    PasswordView(password: $viewModel.password)
                }
            }
            if viewModel.isLoggedIn {
                BiometricToggleView(isFaceId: $isFaceId)
            }
            LoginButtonView(isRegister: $isRegister, isFaceId: $isFaceId, isAuthenticationSuccessful: isAuthenticationSuccessful, viewModel: viewModel)
            Spacer()
            if !isProfileLogin {
                NoAccountView()
            }
            if isRegister {
                if !viewModel.isLoggedIn {
                    EmailView(email: $viewModel.email)
                }
                if !viewModel.isLoggedIn || !viewModel.isProfileLoggedIn && !isFaceId {
                    PasswordView(password: $viewModel.password)
                }
            }
            if !viewModel.isLoggedIn {
                SignUpButtonView(isRegister: $isRegister, viewModel: viewModel)
            }
            Spacer()
            
        }
        .animation(.default, value: isFaceId || isRegister)
        .onAppear {
            isProfileLogin = viewModel.isLoggedIn && !viewModel.isProfileLoggedIn
        }
    }
}

struct TitleView: View {
    var body: some View {
        HStack {
            Text("Accede a tu cuenta")
                .bold()
                .font(.title)
            Spacer()
        }
        .padding()
    }
}

struct EmailView: View {
    @Binding var email: String
    
    var body: some View {
        VStack (spacing: 0) {
            TextField("Correo electrónico".uppercased(), text: $email)
                .foregroundColor(.white)
                .padding()
                .keyboardType(.emailAddress)
                .autocapitalization(.none)
            
            Divider()
                .padding(.horizontal)
                .padding(.top, -8)
        }
    }
}

struct PasswordView: View {
    @Binding var password: String
    
    var body: some View {
        VStack (spacing: 0) {
            SecureField("Contraseña".uppercased(), text: $password)
                .textFieldStyle(DefaultTextFieldStyle())
                .padding()
            
            Divider()
                .padding(.horizontal)
                .padding(.top, -8)
        }
    }
}

struct BiometricToggleView: View {
    @Binding var isFaceId: Bool
    
    var body: some View {
        Toggle(biometricTypeText(), isOn: $isFaceId)
            .padding()
            .frame(width: 200)
    }
    
    func biometricTypeText() -> String {
        let context = LAContext()
        var error: NSError?
        
        if context.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: &error) {
            if #available(iOS 11.0, *) {
                switch context.biometryType {
                case .faceID:
                    return "Usar Face ID"
                case .touchID:
                    return "Usar Touch ID"
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

struct LoginButtonView: View {
    @Binding var isRegister: Bool
    @Binding var isFaceId: Bool
    @State var isAuthenticationSuccessful: Bool
    @ObservedObject var viewModel: LoginViewModel
    
    var body: some View {
        Button(action: {
            if isRegister {
                isRegister.toggle()
            } else if isFaceId {
                authenticateWithFaceID()
            } else {
                if viewModel.isLoggedIn {
                    viewModel.profileLogin()
                } else {
                    viewModel.firebaseLogin()
                }
            }
            UserDefaults.standard.set(isFaceId, forKey: "isFaceIdEnabled")
        }) {
            Text(viewModel.isLoggedIn ? "Acceder".uppercased() : "Iniciar sesión".uppercased())
                .font(.headline)
                .frame(maxWidth: .infinity)
                .background(Color.clear)
                .foregroundColor(isRegister ? .white : .black)
        }
        .alert(item: $viewModel.error) { error in
            Alert(title: Text("Error"), message: Text(error.message), dismissButton: .default(Text("OK")))
        }
        .buttonStyle(LoginButtonStyle())
        .background(isRegister ? Color.secondary : Color.primary.opacity(0.8))
        .cornerRadius(5)
        .padding()
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
}

struct NoAccountView: View {
    var body: some View {
        HStack {
            Text("¿No tienes cuenta?")
                .bold()
                .font(.title2)
            Spacer()
        }
        .padding()
    }
}

struct SignUpButtonView: View {
    @Binding var isRegister: Bool
    @ObservedObject var viewModel: LoginViewModel
    
    var body: some View {
        Button(action: {
            if isRegister {
                viewModel.firebaseSignup()
                isRegister.toggle()
            }
            isRegister.toggle()
        }) {
            Text("Registrarse".uppercased())
                .font(.headline)
                    .background(Color.clear)
                    .foregroundColor(isRegister ? .black : .white)
                    .frame(maxWidth: .infinity)
        }
        .buttonStyle(LoginButtonStyle())
        .background(isRegister ? Color.primary.opacity(0.8) : Color.secondary)
        .cornerRadius(5)
        .padding()
        .alert(item: $viewModel.error) { error in
            Alert(title: Text("Error"), message: Text(error.message), dismissButton: .default(Text("OK")))
        }
    }
}

struct LoginButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .padding()
            .frame(maxWidth: .infinity)
    }
}
