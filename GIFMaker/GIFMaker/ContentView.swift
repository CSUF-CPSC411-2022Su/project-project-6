//
//  ContentView.swift
//  GIFMaker
//
//  Created by csuftitan on 6/21/22.
//
import Firebase
import SwiftUI

struct ContentView: View {
    // Login Status
    @AppStorage("log_status") var logStatus: Bool = false
    
    var body: some View {
        NavigationView {
            if logStatus {
                Home()
            } else {
                LoginPage()
                    .navigationBarHidden(true)
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
