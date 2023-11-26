//
//  LoginView.swift
//  SquareHabitsTracker
//
//  Created by Marcelo Diefenbach on 25/11/23.
//

import SwiftUI
import AuthenticationServices

class AppleSignInManager: NSObject, ASAuthorizationControllerDelegate, ASAuthorizationControllerPresentationContextProviding {
    
    var onAuthorizationComplete: ((String) -> Void)?

    func authorizationController(controller: ASAuthorizationController, didCompleteWithAuthorization authorization: ASAuthorization) {
        if let appleIDCredential = authorization.credential as? ASAuthorizationAppleIDCredential {
            if let userEmail = appleIDCredential.email {
                UserDefaults.standard.set(userEmail, forKey: "email")
            }
            UserDefaults.standard.set(appleIDCredential.user, forKey: "userCredential")
            addUser(email: UserDefaults.standard.string(forKey: "email") ?? appleIDCredential.user, userId: appleIDCredential.user) { result in
                switch result {
                    case .success(let responseString):
                        print("Resposta da API: \(responseString)")
                        self.onAuthorizationComplete?(appleIDCredential.user)
                    case .failure(let error):
                        print("Erro ao adicionar usuário: \(error.localizedDescription)")
                        self.onAuthorizationComplete?(appleIDCredential.user)
                    }
            }
        }
    }

    func authorizationController(controller: ASAuthorizationController, didCompleteWithError error: Error) {
        // Lidar com erro
        onAuthorizationComplete?("no")
    }
    
    func presentationAnchor(for controller: ASAuthorizationController) -> ASPresentationAnchor {
        // Retornar a janela de apresentação adequada
        return UIApplication.shared.windows.first!
    }
    
    func addUser(email: String, userId: String, completion: @escaping (Result<String, Error>) -> Void) {
        guard let url = URL(string: "http://gpt-treinador.herokuapp.com/add_user") else {
            completion(.failure(NSError(domain: "", code: 1, userInfo: [NSLocalizedDescriptionKey: "URL inválida"])))
            return
        }

        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")

        let body: [String: Any] = ["email": email, "id": userId]
        request.httpBody = try? JSONSerialization.data(withJSONObject: body, options: [])

        URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                completion(.failure(error))
                return
            }

            guard let data = data, let responseString = String(data: data, encoding: .utf8) else {
                completion(.failure(NSError(domain: "", code: 2, userInfo: [NSLocalizedDescriptionKey: "Nenhum dado recebido"])))
                return
            }

            completion(.success(responseString))
        }.resume()
    }
}

struct LoginView: View {
    private let signInManager = AppleSignInManager()
    
    @State var showAlert = false
    @State var isAuthenticated: String

    var body: some View {
        if isAuthenticated != "no" {
            TrackersList()
        } else {
            VStack(spacing: 0) {
                
                Spacer()
                
                Image(systemName: "icloud")
                    .font(.system(size: 120, weight: .regular))
                    .padding(.bottom, 32)
                Text("LoginView_title_view")
                    .font(.system(size: 32, weight: .bold))
                    .multilineTextAlignment(.center)
                    .padding(.bottom, 16)
                    .frame(width: UIScreen.main.bounds.width * 0.5)
                Text("LoginView_subtitle_view")
                    .font(.system(size: 12, weight: .light))
                    .multilineTextAlignment(.center)
                    .padding(.bottom, 16)
                    .frame(width: UIScreen.main.bounds.width * 0.6)
                
                Spacer()
                Spacer()
                
                HStack {
                    Spacer()
                    Image(systemName: "apple.logo")
                        .font(.system(size: 20, weight: .regular))
                        .foregroundStyle(.white)
                        .padding(.trailing, 4)
                    Text("LoginView_sign_in_button")
                        .font(.system(size: 20, weight: .regular))
                        .foregroundStyle(.white)
                    Spacer()
                }
                .padding(.vertical, 16)
                .background(.black)
                .clipShape(RoundedRectangle(cornerRadius: 8))
                .padding(.horizontal, 16)
                .onTapGesture {
                    performAppleSignIn()
                }
                .padding(.bottom, 24)
                .alert(isPresented: $showAlert) {
                    Alert(
                        title: Text("LoginView_title_error_lable"),
                        message: Text("LoginView_subtitle_error_label"),
                        dismissButton: .default(Text("LoginView_ok_button_error_label"))
                    )
                }
                .onAppear {
                    performAppleSignIn()
                }
            }
        }
    }

    private func performAppleSignIn() {
        let appleIDProvider = ASAuthorizationAppleIDProvider()
        let request = appleIDProvider.createRequest()
        request.requestedScopes = [.fullName, .email]

        let authorizationController = ASAuthorizationController(authorizationRequests: [request])
        authorizationController.delegate = signInManager
        authorizationController.presentationContextProvider = signInManager
        authorizationController.performRequests()

        signInManager.onAuthorizationComplete = { response in
            if response != "no" {
                self.isAuthenticated = response
            } else {
                print("Erro")
                showAlert = true
            }
        }
    }
}



#Preview {
    LoginView(isAuthenticated: "no")
}
