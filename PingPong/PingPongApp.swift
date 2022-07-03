//
//  PingPongApp.swift
//  PingPong
//
//  Created by Brett Koster on 7/3/22.
//

import SwiftUI

@main
struct PingPongApp: App {
    @NSApplicationDelegateAdaptor(AppDelegate.self) var appDelegate //this will close the app when the last window is closed
    
    @StateObject var viewModel = ViewModel()
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(viewModel)
        }
    }
}
