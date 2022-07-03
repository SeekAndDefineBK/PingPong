//
//  ContentView.swift
//  PingPong
//
//  Created by Brett Koster on 7/3/22.
//

import SwiftUI

struct ContentView: View {
    @EnvironmentObject var viewModel: ViewModel
    @State private var showingAddSheet = false
    
    var body: some View {
        Group {
            if viewModel.servers.isEmpty {
                Text("Please add a server")
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
            } else {
                List {
                    ForEach(viewModel.servers) { server in
                        ServerRow(server: server)
                    }
                    .onDelete(perform: viewModel.delete)
                }
            }
        }
        .navigationSubtitle("Last Refresh: \(viewModel.lastRefreshDate.formatted())")
        .toolbar {
            Button {
                viewModel.refresh()
            } label: {
                if viewModel.refreshInprogress {
                    ProgressView()
                        .controlSize(.small)
                } else {
                    Label("Refresh", systemImage: "arrow.clockwise")
                }
            }
            .disabled(viewModel.refreshInprogress)
            
            Button {
                showingAddSheet.toggle()
            } label: {
                Label("Add Server", systemImage: "plus")
            }
        }
        .sheet(isPresented: $showingAddSheet) {
            AddServerView()
        }
    }
}
