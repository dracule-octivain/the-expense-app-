import SwiftUI
import SwiftData

@main
struct AURELISApp: App {
    var body: some Scene {
        WindowGroup { RootView() }
            .modelContainer(for: [ExpenseEntry.self, SavingsGoal.self])
    }
}
