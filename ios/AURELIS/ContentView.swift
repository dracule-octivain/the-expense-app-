import SwiftUI
import SwiftData

struct RootView: View {
    @Environment(\.modelContext) private var context
    @Query(sort: \.date, order: .reverse) private var entries: [ExpenseEntry]
    @Query private var goals: [SavingsGoal]
    @State private var selected = 0
    @State private var showingAdd = false
    @State private var addKind = "expense"
    private var income: Double { entries.filter { $0.kind == "income" }.reduce(0) { $0 + $1.amount } }
    private var spent: Double { entries.filter { $0.kind == "expense" }.reduce(0) { $0 + $1.amount } }
    private var balance: Double { 15_000 + income - spent }

    var body: some View {
        TabView(selection: $selected) {
            Dashboard(balance: balance, income: income, spent: spent, add: { addKind = $0; showingAdd = true }).tabItem { Label("Home", systemImage: "house") }.tag(0)
            Activity(entries: entries).tabItem { Label("Activity", systemImage: "list.bullet") }.tag(1)
            Analytics(entries: entries, spent: spent).tabItem { Label("Lens", systemImage: "chart.bar") }.tag(2)
            GoalsView(goals: goals).tabItem { Label("Destinations", systemImage: "target") }.tag(3)
            SettingsView(entries: entries).tabItem { Label("Vault", systemImage: "lock.shield") }.tag(4)
        }
        .tint(.cyan)
        .sheet(isPresented: $showingAdd) { EntryForm(kind: addKind) }
    }
}

struct Dashboard: View {
    let balance: Double; let income: Double; let spent: Double; let add: (String) -> Void
    var body: some View { NavigationStack { ScrollView { VStack(alignment: .leading, spacing: 20) {
        Text("AURELIS").font(.caption).tracking(4).foregroundStyle(.cyan)
        Text("Your financial clarity.").font(.largeTitle.bold())
        VStack(alignment: .leading, spacing: 8) { Text("AVAILABLE BALANCE").font(.caption).foregroundStyle(.secondary); Text(money(balance)).font(.system(size: 38, weight: .bold, design: .rounded)) }.padding().frame(maxWidth: .infinity, alignment: .leading).background(.ultraThinMaterial, in: RoundedRectangle(cornerRadius: 24))
        HStack { Metric(title: "Income", value: income, color: .green); Metric(title: "Spent", value: spent, color: .orange) }
        HStack { Button { add("expense") } label: { Label("Add expense", systemImage: "minus.circle.fill") }.buttonStyle(.borderedProminent); Button { add("income") } label: { Label("Add income", systemImage: "plus.circle.fill") }.buttonStyle(.bordered) }
    }.padding() }.navigationTitle("Home") } }
}
struct Metric: View { let title: String; let value: Double; let color: Color; var body: some View { VStack(alignment: .leading) { Text(title).foregroundStyle(.secondary); Text(money(value)).font(.headline).foregroundStyle(color) }.frame(maxWidth: .infinity, alignment: .leading).padding().background(Color(.secondarySystemBackground), in: RoundedRectangle(cornerRadius: 16)) } }

struct Activity: View { let entries: [ExpenseEntry]; @State private var search = ""; var filtered: [ExpenseEntry] { entries.filter { search.isEmpty || $0.title.localizedCaseInsensitiveContains(search) || $0.category.localizedCaseInsensitiveContains(search) } }; var body: some View { NavigationStack { List(filtered) { e in HStack { Image(systemName: e.kind == "income" ? "arrow.down.left" : "arrow.up.right").foregroundStyle(e.kind == "income" ? .green : .orange); VStack(alignment: .leading) { Text(e.title); Text(e.category).font(.caption).foregroundStyle(.secondary) }; Spacer(); Text("\(e.kind == "income" ? "+" : "−")\(money(e.amount))").foregroundStyle(e.kind == "income" ? .green : .primary) }.padding(.vertical, 4) }.searchable(text: $search).navigationTitle("Activity") } } }
struct Analytics: View { let entries: [ExpenseEntry]; let spent: Double; var body: some View { NavigationStack { List { Section("Spending by category") { ForEach(Dictionary(grouping: entries.filter { $0.kind == "expense" }, by: \ .category).sorted { $0.value.reduce(0) { $0 + $1.amount } > $1.value.reduce(0) { $0 + $1.amount } }, id: \.key) { key, values in let total = values.reduce(0) { $0 + $1.amount }; HStack { Text(key); Spacer(); Text(money(total)); ProgressView(value: total, total: spent).frame(width: 80) } } } }.navigationTitle("Lens") } } }
struct GoalsView: View { let goals: [SavingsGoal]; var body: some View { NavigationStack { List(goals) { g in VStack(alignment: .leading) { HStack { Text(g.name).bold(); Spacer(); Text(money(g.saved)) }; ProgressView(value: g.saved, total: g.target); Text("of \(money(g.target))").font(.caption).foregroundStyle(.secondary) }.padding(.vertical, 6) }.navigationTitle("Destinations") } } }
