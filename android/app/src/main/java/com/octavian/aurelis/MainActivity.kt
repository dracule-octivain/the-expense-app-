package com.octavian.aurelis

import android.os.Bundle
import androidx.activity.ComponentActivity
import androidx.activity.compose.setContent
import androidx.compose.foundation.layout.*
import androidx.compose.foundation.lazy.LazyColumn
import androidx.compose.foundation.lazy.items
import androidx.compose.material.icons.Icons
import androidx.compose.material.icons.filled.*
import androidx.compose.material3.*
import androidx.compose.runtime.*
import androidx.compose.ui.Modifier
import androidx.compose.ui.unit.dp
import java.text.NumberFormat
import java.util.Locale
import java.util.UUID

data class Entry(val id: String = UUID.randomUUID().toString(), val kind: String, val title: String, val category: String, val amount: Double)
private fun money(v: Double) = NumberFormat.getCurrencyInstance(Locale("en", "IN")).format(v)

class MainActivity : ComponentActivity() { override fun onCreate(savedInstanceState: Bundle?) { super.onCreate(savedInstanceState); setContent { AurelisTheme { AurelisApp() } } } }

@Composable fun AurelisApp() { var entries by remember { mutableStateOf(listOf(Entry(kind="expense", title="Lunch", category="Food", amount=450.0), Entry(kind="expense", title="Metro", category="Transport", amount=80.0), Entry(kind="income", title="Freelance", category="Work", amount=5000.0))) }; var tab by remember { mutableIntStateOf(0) }; var showAdd by remember { mutableStateOf(false) }; val income = entries.filter { it.kind == "income" }.sumOf { it.amount }; val spent = entries.filter { it.kind == "expense" }.sumOf { it.amount }
    Scaffold(bottomBar = { NavigationBar { listOf(Icons.Default.Home to "Home", Icons.Default.List to "Activity", Icons.Default.BarChart to "Lens", Icons.Default.Flag to "Goals").forEachIndexed { i, item -> NavigationBarItem(tab == i, { tab = i }, { Icon(item.first, item.second) }, label = { Text(item.second) }) } } }, floatingActionButton = { FloatingActionButton({ showAdd = true }) { Icon(Icons.Default.Add, "Add") } }) { pad -> when(tab) { 0 -> Home(Modifier.padding(pad), income, spent, { showAdd = true }); 1 -> Activity(Modifier.padding(pad), entries); 2 -> Lens(Modifier.padding(pad), entries, spent); else -> Goals(Modifier.padding(pad)) } }; if (showAdd) AddDialog({ showAdd = false }) { entry -> entries = listOf(entry) + entries; showAdd = false } }
}
@Composable fun Home(modifier: Modifier, income: Double, spent: Double, add: () -> Unit) { Column(modifier.padding(20.dp), verticalArrangement = Arrangement.spacedBy(18.dp)) { Text("AURELIS", style = MaterialTheme.typography.labelLarge, color = MaterialTheme.colorScheme.primary); Text("Your financial clarity.", style = MaterialTheme.typography.headlineMedium); Card { Column(Modifier.padding(20.dp)) { Text("AVAILABLE BALANCE"); Text(money(15000 + income - spent), style = MaterialTheme.typography.displaySmall) } }; Row(horizontalArrangement = Arrangement.spacedBy(12.dp)) { Stat("Income", income); Stat("Spent", spent) } } }
@Composable fun Stat(label: String, value: Double) { Card(Modifier.weight(1f)) { Column(Modifier.padding(14.dp)) { Text(label); Text(money(value), style = MaterialTheme.typography.titleMedium) } } }
@Composable fun Activity(modifier: Modifier, entries: List<Entry>) { LazyColumn(modifier.padding(12.dp)) { item { Text("Activity", style = MaterialTheme.typography.headlineMedium, modifier = Modifier.padding(8.dp)) }; items(entries) { e -> ListItem(leadingContent = { Icon(if (e.kind == "income") Icons.Default.ArrowDownward else Icons.Default.ArrowUpward, null) }, headlineContent = { Text(e.title) }, supportingContent = { Text(e.category) }, trailingContent = { Text((if (e.kind == "income") "+" else "−") + money(e.amount)) }) } } }
@Composable fun Lens(modifier: Modifier, entries: List<Entry>, spent: Double) { val groups = entries.filter { it.kind == "expense" }.groupBy { it.category }; LazyColumn(modifier.padding(20.dp)) { item { Text("Lens", style = MaterialTheme.typography.headlineMedium) }; items(groups.entries.toList()) { (category, values) -> val total = values.sumOf { it.amount }; Column(Modifier.padding(vertical = 12.dp)) { Row(Modifier.fillMaxWidth(), horizontalArrangement = Arrangement.SpaceBetween) { Text(category); Text(money(total)) }; LinearProgressIndicator({ if (spent == 0.0) 0f else (total / spent).toFloat() }, Modifier.fillMaxWidth()) } } } }
@Composable fun Goals(modifier: Modifier) { Column(modifier.padding(20.dp)) { Text("Destinations", style = MaterialTheme.typography.headlineMedium); Text("Savings goals will be stored locally on this device.", modifier = Modifier.padding(top = 16.dp)) } }
@Composable fun AddDialog(close: () -> Unit, save: (Entry) -> Unit) { var title by remember { mutableStateOf("") }; var amount by remember { mutableStateOf("") }; AlertDialog(onDismissRequest = close, title = { Text("Add expense") }, text = { Column { OutlinedTextField(title, { title = it }, label = { Text("Title") }); OutlinedTextField(amount, { amount = it }, label = { Text("Amount") }) } }, confirmButton = { TextButton({ amount.toDoubleOrNull()?.let { save(Entry(kind="expense", title=title, category="Other", amount=it)) } }) { Text("Save") } }, dismissButton = { TextButton(close) { Text("Cancel") } }) }
@Composable fun AurelisTheme(content: @Composable () -> Unit) { MaterialTheme(colorScheme = darkColorScheme(primary = androidx.compose.ui.graphics.Color(0xFF62D9D2)), content = content) }
