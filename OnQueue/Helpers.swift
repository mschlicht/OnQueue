//
//  helpers.swift
//  OnQueue
//
//  Created by Miguel Schlicht on 12/5/24.
//

import SwiftUI
import Combine

extension UIApplication {
    func endEditing() {
        sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
}

func colorFromDescription(_ description: String) -> Color {
    switch description.lowercased() {
    case "red": return .red
    case "orange": return .orange
    case "yellow": return .yellow
    case "green": return .green
    case "mint": return .mint
    case "teal": return .teal
    case "cyan": return .cyan
    case "blue": return .blue
    case "indigo": return .indigo
    case "purple": return .purple
    case "pink": return .pink
    case "brown": return .brown
    default: return .gray // Default fallback color
    }
}

extension NotificationCenter {
    var storeDidChangePublisher: Publishers.ReceiveOn<NotificationCenter.Publisher, DispatchQueue> {
        return publisher(for: .cdcksStoreDidChange).receive(on: DispatchQueue.main)
    }
}
