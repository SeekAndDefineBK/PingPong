//
//  FileManager-DocumentsDirectory.swift
//  PingPong
//
//  Created by Brett Koster on 7/3/22.
//

import Foundation

extension FileManager {
    static var documentsDirectory: URL {
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        return paths[0]
    }
}
