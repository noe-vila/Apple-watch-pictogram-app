import SwiftUI
import LocalAuthentication

struct LoginView: View {
    @StateObject var viewModel: LoginViewModel
    @State private var isAuthenticationSuccessful = false
    @State private var isProfileLogin = false
    @State private var isRegister = false
    @State private var isFaceId = UserDefaults.standard.bool(forKey: "isFaceIdEnabled")
    @State private var showForgotPassword = false
    
    var body: some View {
        VStack {
            Spacer()
            if !isProfileLogin {
                TitleView(isRegister: isRegister)
            }
            Group {
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
            }
            LoginButtonView(isRegister: $isRegister, isFaceId: $isFaceId, isAuthenticationSuccessful: isAuthenticationSuccessful, viewModel: viewModel)
            if !isRegister && !viewModel.isLoggedIn {
                HStack {
                    ForgotPasswordTextView()
                        .onTapGesture {
                            showForgotPassword = true
                        }
                    Spacer()
                }
            }
            Spacer()
            if !isProfileLogin {
                NoAccountView(isRegister: isRegister)
            }
            Group {
                if isRegister {
                    if !viewModel.isLoggedIn {
                        EmailView(email: $viewModel.email)
                    }
                    if !viewModel.isLoggedIn || !viewModel.isProfileLoggedIn && !isFaceId {
                        PasswordView(password: $viewModel.password)
                    }
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
        .sheet(isPresented: $showForgotPassword, onDismiss: {
            showForgotPassword = false
        }) {
            ForgotPasswordView(viewModel: viewModel, showForgotPassword: $showForgotPassword)
        }
    }
}

struct TitleView: View {
    var isRegister: Bool
    var body: some View {
        HStack {
            Text("Accede a tu cuenta")
                .bold()
                .font(isRegister ? .title2 : .title)
            Spacer()
        }
        .padding()
    }
}

struct ForgotPasswordTextView: View {
    var body: some View {
        HStack {
            Text("Restaura tu contraseña")
                .bold()
                .font(.title3)
                .foregroundColor(.secondary)
        }
        .padding()
    }
}

struct EmailView: View {
    @Binding var email: String
    
    var body: some View {
        VStack (spacing: 0) {
            TextField("Correo electrónico".uppercased(), text: $email)
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
    @Environment(\.colorScheme) var colorScheme: ColorScheme
    @Binding var isRegister: Bool
    @Binding var isFaceId: Bool
    @State var isAuthenticationSuccessful: Bool
    @ObservedObject var viewModel: LoginViewModel
    @State private var pulsed = false
    
    var body: some View {
        Button(action: {
            if isRegister {
                isRegister.toggle()
            } else {
                pulsed = true
                if isFaceId {
                    authenticateWithFaceID()
                } else {
                    if viewModel.isLoggedIn {
                        viewModel.profileLogin()
                    } else {
                        viewModel.firebaseLogin()
                    }
                }
                DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                    pulsed = false
                }
            }
            UserDefaults.standard.set(isFaceId, forKey: "isFaceIdEnabled")
        }) {
            if pulsed {
                ProgressView()
            } else {
                Text(viewModel.isLoggedIn ? "Acceder".uppercased() : "Iniciar sesión".uppercased())
                    .font(.headline)
                    .foregroundColor(isRegister ? .white : .black)
                    .frame(maxWidth: .infinity)
                    .background(Color.clear)
            }
        }
        .alert(item: $viewModel.error) { error in
            Alert(title: Text("Error"), message: Text(error.message), dismissButton: .default(Text("OK")))
        }
        .buttonStyle(LoginButtonStyle())
        .background(isRegister ? Color.secondary : Color.primary.opacity(colorScheme == .light ? 0.2 : 0.8))
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
    var isRegister: Bool
    var body: some View {
        HStack {
            Text("¿No tienes cuenta?")
                .bold()
                .font(isRegister ? .title : .title2)
            Spacer()
        }
        .padding()
    }
}

struct SignUpButtonView: View {
    @Environment(\.colorScheme) var colorScheme: ColorScheme
    @Binding var isRegister: Bool
    @ObservedObject var viewModel: LoginViewModel
    @State private var pulsed = false
    
    var body: some View {
        Button(action: {
            if isRegister {
                pulsed = true
                viewModel.firebaseSignup()
                isRegister.toggle()
                DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                    pulsed = false
                }
            }
            isRegister.toggle()
        }) {
            if pulsed {
                ProgressView()
            } else {
                Text("Registrarse".uppercased())
                    .font(.headline)
                    .background(Color.clear)
                    .foregroundColor(isRegister ? .black : .white)
                    .frame(maxWidth: .infinity)
            }
        }
        .buttonStyle(LoginButtonStyle())
        .background(isRegister ? Color.primary.opacity(colorScheme == .light ? 0.2 : 0.8) : Color.secondary)
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
