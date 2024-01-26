//
//  Untitled.swift
//  Arista
//
//  Created by Sarah Maimoun on /03/2026.
//

import SwiftUI

enum AppTheme {
    static let primary = Color(hex: "#B25B5B")
    static let secondary = Color(hex: "#D29F9E")
    static let background = Color(hex: "#FAF7F6")
    static let cardBackground = Color.white
    static let textPrimary = Color.black
    static let textSecondary = Color.gray.opacity(0.8)
    static let border = Color(hex: "#E8D8D8")
}

extension Color {
    init(hex: String) {
        let hex = hex.trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
        var int: UInt64 = 0
        Scanner(string: hex).scanHexInt64(&int)

        let a, r, g, b: UInt64
        switch hex.count {
        case 3:
            (a, r, g, b) = (255,
                            (int >> 8) * 17,
                            (int >> 4 & 0xF) * 17,
                            (int & 0xF) * 17)
        case 6:
            (a, r, g, b) = (255,
                            int >> 16,
                            int >> 8 & 0xFF,
                            int & 0xFF)
        case 8:
            (a, r, g, b) = (int >> 24,
                            int >> 16 & 0xFF,
                            int >> 8 & 0xFF,
                            int & 0xFF)
        default:
            (a, r, g, b) = (255, 0, 0, 0)
        }

        self.init(
            .sRGB,
            red: Double(r) / 255,
            green: Double(g) / 255,
            blue: Double(b) / 255,
            opacity: Double(a) / 255
        )
    }
}
struct AristaCardModifier: ViewModifier {
    func body(content: Content) -> some View {
        content
            .padding()
            .background(AppTheme.cardBackground)
            .overlay(
                RoundedRectangle(cornerRadius: 20)
                    .stroke(AppTheme.border, lineWidth: 1)
            )
            .cornerRadius(20)
            .shadow(color: .black.opacity(0.04), radius: 8, x: 0, y: 4)
    }
}

extension View {
    func aristaCard() -> some View {
        self.modifier(AristaCardModifier())
    }
}
    
