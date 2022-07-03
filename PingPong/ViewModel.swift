//
//  ViewModel.swift
//  PingPong
//
//  Created by Brett Koster on 7/3/22.
//
import AppKit
import UserNotifications
import Foundation

class ViewModel: ObservableObject {
    @Published var servers: [Server]
    @Published var lastRefreshDate = Date.now
    @Published var refreshInprogress = false
    
    private var refreshTask: Task<Void, Error>?
//    private let delay: UInt64 = 1_000_000_000 * 10 //10 second delay, 1 billion nanoseconds multiplied by 10
    private let delay: UInt64 = 1_000_000_000 * 60 * 10 //10 minute delay, 1 billion nanoseconds multiplied by 60 multiplied by 10
    
    private let savePath = FileManager.documentsDirectory.appendingPathComponent("ServerCache")
    
    init() {
        do {
            let data = try Data(contentsOf: savePath)
            servers = try JSONDecoder().decode([Server].self, from: data)
        } catch {
            servers = []
        }
        
        refresh()
    }
    
    func save() {
        print("Savings to \(savePath)")
        
        do {
            let data = try JSONEncoder().encode(servers)
            try data.write(to: savePath, options: [.atomic, .completeFileProtection])
        } catch {
            print("unable to save data")
        }
    }
    
    func add(_ url: URL) {
        let server = Server(url: url)
        servers.append(server)
        save()
        refresh()
    }
    
    func delete(_ offsets: IndexSet) {
        servers.remove(atOffsets: offsets)
        save()
    }
    
    //MARK: Refreshing Methods
    @MainActor private func refreshAllServers() async {
        defer { queueRefresh() }
        
        guard !servers.isEmpty else { return }
        
        refreshInprogress = true
        try? await Task.sleep(nanoseconds: 200_000_000) //delay to show user a very fast refresh has occured.
        
        let session = URLSession(configuration: .ephemeral)
        var changesDetected = false
        
        for server in servers {
            print("Fetching \(server.url)")
            
            if let (newData, _) = try? await session.data(from: server.url) {
                if newData != server.content {
                    if server.content != nil {
                        notifyChanges(for: server)
                        changesDetected = true
                        server.hasChanges = true
                    }
                    
                    server.lastChange = .now
                    server.content = newData
                }
            }
        }
        
        if changesDetected {
            NSApp.requestUserAttention(.criticalRequest) //criticalRequest bounces the app perpetually until the user reopens app. informational only bounces briefly
            save()
        }
        
        lastRefreshDate = .now
        refreshInprogress = false
    }
    
    private func queueRefresh() {
        refreshTask = Task {
            try await Task.sleep(nanoseconds: delay)
            await refreshAllServers()
        }
    }
    
    func refresh() {
        guard refreshInprogress == false else { return }
        refreshTask?.cancel()
        
        Task {
            await refreshAllServers()
        }
    }
    
    
    //MARK: Notifications
    private func notifyChanges(for server: Server) {
        let center = UNUserNotificationCenter.current()
        
        center.requestAuthorization(options: [.alert, .badge]) { granted, error in
            guard granted else { return }
            
            let content = UNMutableNotificationContent()
            let host = server.url.host ?? "Server"
            content.title = "\(host) has changed!"
            
            let request = UNNotificationRequest(identifier: UUID().uuidString, content: content, trigger: nil)
            center.add(request)
        }
    }
    
    func acknowledgeChanges(for server: Server) {
        guard server.hasChanges else { return }
        
        objectWillChange.send()
        server.hasChanges = false
        save()
    }
}
