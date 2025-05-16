//
//  ColorHex.swift
//  Rest
//
//  Created by Me Tomm on 22/3/2568 BE.
//

import SwiftUI

extension Color {
    init(hex: String) {
        var hexSanitized = hex.trimmingCharacters(in: .whitespacesAndNewlines)
        hexSanitized = hexSanitized.replacingOccurrences(of: "#", with: "")
        
        var rgb: UInt64 = 0
        Scanner(string: hexSanitized).scanHexInt64(&rgb)
        
        let red = Double((rgb & 0xFF0000) >> 16) / 255.0
        let green = Double((rgb & 0x00FF00) >> 8) / 255.0
        let blue = Double(rgb & 0x0000FF) / 255.0
        
        self.init(red: red, green: green, blue: blue)
    }
}

struct BackgroundGradient {
    static let gradient: LinearGradient = {
        return LinearGradient(
            gradient: Gradient(colors: [
                Color(hex: colorLevel1),
                Color(hex: colorLevel4)
            ]),
            startPoint: .topLeading,
            endPoint: .bottomTrailing
        )
    }()
}

struct BackgroundBlueGradient {
    static let gradient: LinearGradient = {
        return LinearGradient(
            gradient: Gradient(colors: [
                Color(hex: colorBlueLevel1),
                Color(hex: colorBlueLevel3)
            ]),
            startPoint: .topLeading,
            endPoint: .bottomTrailing
        )
    }()
}

public let colorLevel1: String = "#727D73"
public let colorLevel2: String = "#AAB99A"
public let colorLevel3: String = "#D0DDD0"
public let colorLevel4: String = "#F0F0D7"
public let colorBlueLevel1: String = "#213448"
public let colorBlueLevel2: String = "#547792"
public let colorBlueLevel3: String = "#94B4C1"


