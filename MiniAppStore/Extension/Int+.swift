//
//  Int+.swift
//  MiniAppStore
//
//  Created by 림고세 on 2023/07/03.
//

import Foundation

extension Int {
    func toString() -> String {
        func addSuffixWithoutZero(value: Double, suffix: String) -> String {
            var stringValue = String(format: "%.1f", value)
            if stringValue.hasSuffix("0") {
                stringValue.removeLast()
                stringValue.removeLast()
                return stringValue + suffix
            } else {
                return String(format: "%.1f", value) + suffix
            }
        }
        
        if self >= 10000 {
            let suffix = "만"
            let value = Double(self) / 10000
            return addSuffixWithoutZero(value: value, suffix: suffix)
        } else if self >= 1000 {
            let suffix = "천"
            let value = Double(self) / 1000
            return addSuffixWithoutZero(value: value, suffix: suffix)
        } else {
            return "\(self)"
        }
    }
}
