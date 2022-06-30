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
    
    //Google Signin API
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
    
    
    
    
    
    
}
