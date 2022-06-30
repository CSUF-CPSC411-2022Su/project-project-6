//
//  SignupPage.swift
//  GIFMaker
//
//  Created by csuftitan on 6/26/22.
//

import Firebase
import SwiftUI

struct SignupPage: View {
    @State private var email = ""
    @State private var password = ""
    
    // Login Status
    @AppStorage("log_status") var logStatus: Bool = false
    
    var body: some View {
        if logStatus {
            LoginPage()
        } else {
            content
        }
    }
    
    var content: some View {
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
                            
                Text("Signup Now")
                    .padding(.top, 10)
                    .padding(.bottom, 5)
                    .font(.title3)
                    .foregroundColor(.gray)
                
                // MARK: Textfields

                TextField("Email", text: $email)
                    .padding()
                    .background {
                        RoundedRectangle(cornerRadius: 8)
                            .fill(
                                email == "" ? Color.black.opacity(0.05) :
                                    Color.black.opacity(0.05)
                            )
                    }
                    .textInputAutocapitalization(.never)
                    .padding(.top, 10)
                
                SecureField("Password", text: $password)
                    .padding()
                    .background {
                        RoundedRectangle(cornerRadius: 8)
                            .fill(
                                password == "" ? Color.black.opacity(0.05)
                                    : Color.black.opacity(0.05)
                            )
                    }
                    .textInputAutocapitalization(.never)
                    .padding(.top, 10)
                
                // Note: Signup Button
                Button {
                    register()
                } label: {
                    Text("Create Account")
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
                .disabled(email == "" || password == "")
                .opacity(email == "" || password == "" ? 0.5 : 1)
                
                NavigationLink(destination: LoginPage()
                    .navigationBarBackButtonHidden(true)
                    .navigationBarHidden(true), label: {
                        Text("Already have an Account? Login")
                            .font(.body)
                            .padding(.top, 40)
                            .foregroundColor(.gray)
                    })
            }
            .padding(.horizontal, 25)
            .navigationBarHidden(true)
            .navigationBarBackButtonHidden(true)
            .onAppear {
                Auth.auth().addStateDidChangeListener { _, user in
                    if user != nil {
                        self.logStatus = true
                    }
                }
            }
        }
        .ignoresSafeArea()
    }

    func register() {
        Auth.auth().createUser(withEmail: email, password: password) { _, error in
            if error != nil {
                print(error!.localizedDescription)
            }
        }
    }
}

struct SignupPage_Previews: PreviewProvider {
    static var previews: some View {
        SignupPage()
    }
}
