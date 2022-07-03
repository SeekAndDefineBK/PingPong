//
//  AddServerView.swift
//  PingPong
//
//  Created by Brett Koster on 7/3/22.
//

import SwiftUI

struct AddServerView: View {
    @Environment(\.dismiss) var dismiss
    @EnvironmentObject var viewModel: ViewModel
    @State private var url = ""
    
    @State private var showingError = false
    
    func close() {
        dismiss()
    }
    
    func save() {
        guard url.hasPrefix("https://") else {
            showingError = true
            return
        }
        
        if let url = URL(string: url) {
            viewModel.add(url)
            close()
        }
    }
    
    var body: some View {
        Form {
            TextField("Server URL:", text: $url)
                .onSubmit(save)
            
            HStack {
                Spacer()

                Button("Cancel", action: close)
                    .keyboardShortcut(.cancelAction)
                
                Button("Save", action: save)
                    .keyboardShortcut(.defaultAction)
            }
        }
        .alert("Invalid URL", isPresented: $showingError) {
            //no buttons, default SwiftUI will provide Okay button
        } message: {
            Text("The URL is not valid, please double check that the url begins with https:// .")
        }
        .onExitCommand(perform: close) //This allows the user to exit using the escape key
        .frame(minWidth: 400)
        .padding()
    }
}
