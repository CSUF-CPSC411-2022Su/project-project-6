LoginViewModel.swift
//  GIFMaker
//
//  Created by csuftitan on 6/21/22.
//

import Firebase
import Foundation
import GoogleSignIn
import LocalAuthentication
import SwiftUI

class LoginViewModel: ObservableObject {
    @Published var email: String = ""
    @Published var password: String = ""
    
    // Note: FaceID Properties
    @AppStorage("use_face_id") var useFaceID: Bool = false
    @AppStorage("use_face_email") var faceIDEmail: String = ""
    @AppStorage("use_face_password") var faceIDPassword: String = ""
    
    // Login Status
    @AppStorage("log_status") var logStatus: Bool = false
    
    // Note: Error
    @Published var showError: Bool = false
    @Published var errorMsg: String = ""
    
    // Note: Firebase Login
    func loginUser(useFaceID: Bool, email: String = "", password: String = "") async throws {
        let _ = try await Auth.auth().signIn(withEmail: email != "" ? email : self.email, password: password != "" ? password : self.password)
        
        DispatchQueue.main.async {
            // Storing Once
            if useFaceID, self.faceIDEmail == "" {
                self.useFaceID = useFaceID
                // Note: Storing for Future FaceID Login
                self.faceIDEmail = self.email
                self.faceIDPassword = self.password
            }
            
            self.logStatus = true
        }
    }
    
    
    // Note: FaceID Usage
    func getBioMetricStatus() -> Bool {
        let scanner = LAContext()
        
        return scanner.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: .none)
    }
    
    // Note: FaceID Login
    func authenticateUser() async throws {
        let status = try await LAContext().evaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, localizedReason: "To Login Into App")

        if status {
            try await loginUser(useFaceID: useFaceID, email: faceIDEmail, password: faceIDPassword)
        }
    }
    
    private func authenticateUser(for user: GIDGoogleUser?, with error: Error?) {
        // 1
        if let error = error {
            print(error.localizedDescription)
            return
        }
      
        // 2
        guard let authentication = user?.authentication, let idToken = authentication.idToken else { return }
      
        let credential = GoogleAuthProvider.credential(withIDToken: idToken, accessToken: authentication.accessToken)
      
        // 3
        Auth.auth().signIn(with: credential) { [unowned self] _, error in
            if let error = error {
                print(error.localizedDescription)
            } else {
                // self.state = .signedIn
                self.logStatus = true
            }
        }
    }
    
    func signIn() {
        // 1
        if GIDSignIn.sharedInstance.hasPreviousSignIn() {
            GIDSignIn.sharedInstance.restorePreviousSignIn { [unowned self] user, error in
                authenticateUser(for: user, with: error)
            }
        } else {
            // 2
            guard let clientID = FirebaseApp.app()?.options.clientID else { return }
        
            // 3
            let configuration = GIDConfiguration(clientID: clientID)
        
            // 4
            guard let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene else { return }
            guard let rootViewController = windowScene.windows.first?.rootViewController else { return }
        
            // 5
            GIDSignIn.sharedInstance.signIn(with: configuration, presenting: rootViewController) { [unowned self] user, error in
                authenticateUser(for: user, with: error)
            }
        }
    }
    
    func signOut() {
        // 1
        GIDSignIn.sharedInstance.signOut()
      
        do {
            // 2
            try Auth.auth().signOut()
            logStatus = false
            // state = .signedOut
        } catch {
            print(error.localizedDescription)
        }
    }  
}
