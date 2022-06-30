//
//  LoginPage.swift
//  GIFMaker
//
//  Created by csuftitan on 6/21/22.
//

import FBSDKLoginKit
import Foundation
import SwiftUI

struct LoginPage: View {
    @StateObject var loginModel: LoginViewModel = .init()
    
    // Login Status
    @AppStorage("log_status") var logStatus: Bool = false
    @State var manager = LoginManager()

    // Note: FaceID Properties
    @State var useFaceID: Bool = false
        
    var body: some View {
        NavigationView {
            VStack {
                Circle()
                    .trim(from: 0, to: 0.5)
                    .fill(Color("CherryRed"))
                    .frame(width: 45, height: 45)
                    .rotationEffect(.init(degrees: -90))
                    .hLeading()
                    .offset(x: -23)
                    .padding(.bottom, 30)
                Text("Welcome to,\nGIF Maker")
                    .font(.largeTitle.bold())
                    .foregroundColor(.black)
                    .hLeading()
                            
                Text("Login Now")
                    .padding(.top, 10)
                    .padding(.bottom, 5)
                    .font(.title3)
                    .foregroundColor(.gray)

                // MARK: Textfields

                TextField("Email", text: $loginModel.email)
                    .padding()
                    .background {
                        RoundedRectangle(cornerRadius: 8)
                            .fill(
                                loginModel.email == "" ? Color.black.opacity(0.05) :
                                    Color.black.opacity(0.05)
                            )
                    }
                    .textInputAutocapitalization(.never)
                    .padding(.top, 10)
                SecureField("Password", text: $loginModel.password)
                    .padding()
                    .background {
                        RoundedRectangle(cornerRadius: 8)
                            .fill(
                                loginModel.password == "" ? Color.black.opacity(0.05)
                                    : Color.black.opacity(0.05)
                            )
                    }
                    .textInputAutocapitalization(.never)
                    .padding(.top, 10)
                
                // Note: User Prompt to ask to store Login using FaceID on next time
                if loginModel.getBioMetricStatus() {
                    Group {
                        if loginModel.useFaceID {
                            Button {
                                // Note: Do FaceID Action
                                Task {
                                    do {
                                        try await loginModel.authenticateUser()
                                    } catch {
                                        loginModel.errorMsg = error.localizedDescription
                                        loginModel.showError.toggle()
                                    }
                                }
                            } label: {
                                VStack(alignment: .leading, spacing: 10) {
                                    Label {
                                        Text("Use FaceId to Login into Your Account")
                                    } icon: {
                                        Image(systemName: "faceid")
                                    }
                                    .font(.caption)
                                    .foregroundColor(.gray)
                                    
                                    Text("Note: You can turn off from Setting!")
                                        .font(.caption2)
                                        .foregroundColor(.gray)
                                }
                            }
                            .hLeading()

                        } else {
                            Toggle(isOn: $useFaceID) {
                                Text("Use FaceID to Login")
                                    .foregroundColor(.gray)
                            }
                        }
                    }
                    .padding(.vertical, 25)
                }
                
                // Note: Login Button
                Button {
                    Task {
                        do {
                            try await loginModel.loginUser(useFaceID: useFaceID)
                        } catch {
                            loginModel.errorMsg = error.localizedDescription
                            loginModel.showError.toggle()
                        }
                    }
                } label: {
                    Text("Login")
                        .fontWeight(.semibold)
                        .foregroundColor(.white)
                        .padding()
                        .hCenter()
                        .background {
                            RoundedRectangle(cornerRadius: 8)
                                .fill(Color("CherryRed"))
                        }
                        .padding(.top, 25)
                }
                
                .padding(.horizontal, 25)
                .disabled(loginModel.email == "" || loginModel.password == "")
                .opacity(loginModel.email == "" || loginModel.password == "" ? 0.5 : 1)
                
//                LabelledDivider(label: "or")
//                    .padding(.top, 20)
                
                GoogleSignInButton()
                    .frame(height: 50)
                    .padding(.top, 10)
                    .padding(.horizontal, 20)
                    .onTapGesture {
                        loginModel.signIn()
                    }
                
                FBLog(logStatus: $logStatus)
                    .frame(height: 50)
                    .padding(.horizontal, 20)
                    
                NavigationLink(destination: SignupPage()
                    .navigationBarBackButtonHidden(true)
                    .navigationBarHidden(true),
                    label: {
                        Text("Create an Account")
                            .font(.body)
                            .foregroundColor(.gray)
                    })
                    .padding(.top, 20)
            }
            .padding(.horizontal, 25)
            .navigationBarBackButtonHidden(true)
            .navigationBarHidden(true)
            .alert(loginModel.errorMsg, isPresented: $loginModel.showError) {}
        }
        .ignoresSafeArea()
    }
}

struct LoginPage_Previews: PreviewProvider {
    static var previews: some View {
        LoginPage()
    }
}

struct FBLog: UIViewRepresentable {
    func makeCoordinator() -> Coordinator {
        return FBLog.Coordinator(parent1: self)
    }
    
    @Binding var logStatus: Bool
    
    func makeUIView(context: Context) -> FBLoginButton {
        let button = FBLoginButton()
        
        button.delegate = context.coordinator
        
        return button
    }
    
    func updateUIView(_ uiView: FBLoginButton, context: Context) {}
    
    class Coordinator: NSObject, LoginButtonDelegate {
        var parent: FBLog
        
        init(parent1: FBLog) {
            self.parent = parent1
        }
        
        // Facebook Login
        func loginButton(_ loginButton: FBLoginButton, didCompleteWith result: LoginManagerLoginResult?, error: Error?) {
            if error != nil {
                print(error!.localizedDescription)
                return
            }
            
            if !result!.isCancelled {
                self.parent.logStatus = true
            }
        }
        
        // Facebook logout
        func loginButtonDidLogOut(_ loginButton: FBLoginButton) {
            self.parent.logStatus = false
        }
    }
}

// MARK: Extensions for UI Designing

extension View {
    func hLeading() -> some View {
        self
            .frame(maxWidth: .infinity, alignment: .leading)
    }

    func hTrailing() -> some View {
        self
            .frame(maxWidth: .infinity, alignment: .trailing)
    }

    func hCenter() -> some View {
        self
            .frame(maxWidth: .infinity, alignment: .center)
    }
}
