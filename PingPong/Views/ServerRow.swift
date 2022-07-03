//
//  ServerRow.swift
//  PingPong
//
//  Created by Brett Koster on 7/3/22.
//

import SwiftUI

struct ServerRow: View {
    @EnvironmentObject var viewModel: ViewModel
    let server: Server
    
    var body: some View {
        HStack(spacing: 15) {
            Button {
                viewModel.acknowledgeChanges(for: server)
            } label: {
                Circle()
                    .fill(server.hasChanges ? .red : .green)
                    .frame(width: 24, height: 24)
            }
            .buttonStyle(.borderless)
            .help(server.hasChanges ? "Click to clear the change marker for this server" : "")
            
            VStack(alignment: .leading) {
                Link("\(server.url.absoluteString)", destination: server.url)
                    .font(.title)
                Text("Last Changed: \(server.lastChange.formatted())")
            }
        }
        .contextMenu {
            Button {
                //
            } label: {
                Label("Delete", systemImage: "trash.fill")
            }
            
            Button {
                //
            } label: {
                Label("Refresh", systemImage: "")
            }
        }
    }
}
