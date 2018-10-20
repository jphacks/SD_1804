//
//  Log.swift
//  NoName
//
//  Created by 下村一将 on 2018/10/20.
//  Copyright © 2018 守谷太一. All rights reserved.
//

import Foundation

enum Level {
    case debug
    case error
}

func debugLog(_ elements: Any..., file: String = #file, function: String = #function, line: Int = #line, level: Level = .debug) {
    let df = DateFormatter()
    df.dateFormat = "yyyy-MM-dd HH:mm:ss"
    switch level {
    case .debug:
        print("🌟 ", terminator: "")
    case .error:
        print("⚠️ ", terminator: "")
    }
    let file = URL(fileURLWithPath: file).lastPathComponent
    print("\(df.string(from: Date())): \(file):\(line) \(function):", terminator: "")
    elements.forEach {
        print(" \($0)", terminator: "")
    }
    print()
}
