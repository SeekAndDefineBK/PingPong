//
//  Server.swift
//  PingPong
//
//  Created by Brett Koster on 7/3/22.
//

import Foundation

class Server: Identifiable, Codable {
    var id: UUID
    var url: URL
    var content: Data?
    var lastChange: Date
    var hasChanges: Bool
    
    static let example = Server(url: URL(string: "https://www.apple.com")!)
    
    init(url: URL) {
        self.url = url
        
        self.id = UUID()
        self.lastChange = .now
        self.hasChanges = false
    }
}
