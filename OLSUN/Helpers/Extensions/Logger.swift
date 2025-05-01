//
//  Logger.swift
//  OLSUN
//
//  Created by Narmin Baghirova on 01.05.25.
//

import Foundation

enum Logger {
    static func debug(_ message: String, file: String = #file, function: String = #function, line: Int = #line) {
        #if DEBUG
        let fileName = (file as NSString).lastPathComponent
        print("🟢 [\(fileName):\(line)] \(function) ➜ \(message)")
        #endif
    }
}
