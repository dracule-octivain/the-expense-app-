import Foundation
import SwiftData

@Model final class ExpenseEntry {
    var id: UUID
    var kind: String
    var title: String
    var category: String
    var amount: Double
    var date: Date
    var recurring: Bool
    init(id: UUID = UUID(), kind: String, title: String, category: String, amount: Double, date: Date = .now, recurring: Bool = false) {
        self.id = id; self.kind = kind; self.title = title; self.category = category; self.amount = amount; self.date = date; self.recurring = recurring
    }
}

@Model final class SavingsGoal {
    var id: UUID
    var name: String
    var target: Double
    var saved: Double
    init(id: UUID = UUID(), name: String, target: Double, saved: Double) { self.id = id; self.name = name; self.target = target; self.saved = saved }
}

let inr: NumberFormatter = { let f = NumberFormatter(); f.numberStyle = .currency; f.currencyCode = "INR"; f.locale = Locale(identifier: "en_IN"); return f }()
func money(_ value: Double) -> String { inr.string(from: value as NSNumber) ?? "₹0" }
