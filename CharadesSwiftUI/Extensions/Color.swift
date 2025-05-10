//
//  Color.swift
//  CharadesSwiftUI
//
//  Created by Admin on 08/05/25.
//
import SwiftUI

extension Color {
    init(hex: String, alpha: Double = 1.0) {
        var sanitized = hex.trimmingCharacters(in: .whitespacesAndNewlines).uppercased()
        if sanitized.hasPrefix("#") {
            sanitized.remove(at: sanitized.startIndex)
        }

        guard sanitized.count == 6,
              let rgb = UInt64(sanitized, radix: 16) else {
            self = Color.black // Fallback color
            return
        }

        let red = Double((rgb & 0xFF0000) >> 16) / 255.0
        let green = Double((rgb & 0x00FF00) >> 8) / 255.0
        let blue = Double(rgb & 0x0000FF) / 255.0

        self = Color(red: red, green: green, blue: blue, opacity: alpha)
    }
}
