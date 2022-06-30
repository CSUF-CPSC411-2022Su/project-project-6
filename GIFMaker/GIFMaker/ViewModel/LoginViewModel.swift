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
    
    // Login Status
    @AppStorage("log_status") var logStatus: Bool = false
    
    // Note: Error
    @Published var showError: Bool = false
    @Published var errorMsg: String = ""
}
