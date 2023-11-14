import 'package:daily_expenses/dailyexpenses.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(DailyExpensesApp());
}

class Expense {
  final String description;
  final String amount;

  Expense(this.description, this.amount);
}

class DailyExpensesApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: Text('Daily Expenses'),
        ),
        body: ExpenseList(),
      ),
    );
  }
}

class ExpenseList extends StatefulWidget {
  @override
  _ExpenseListState createState() => _ExpenseListState();
}

class _ExpenseListState extends State<ExpenseList> {
  final List<Expense> expenses = [];
  final TextEditingController descriptionController = TextEditingController();
  final TextEditingController amountController = TextEditingController();

  double totalAmount = 0.0;

  void _addExpense() {
    String description = descriptionController.text.trim();
    String amount = amountController.text.trim();
    if (description.isNotEmpty && amount.isNotEmpty) {
      setState(() {
        expenses.add(Expense(description, amount));
        descriptionController.clear();
        amountController.clear();
      });
    }
  }

  void _removeExpense(int index) {
    setState(() {
      expenses.removeAt(index);
    });
  }

  void _editExpense(int index) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => EditExpenseScreen(
          expense: expenses[index],
          onSave: (editedExpense) {
            setState(() {
              totalAmount +=
                  double.parse(editedExpense.amount) -
                      double.parse(expenses[index].amount);
              expenses[index] = editedExpense;
            });
          },
        ),
      ),
    );
  }

  String _calculateTotal() {
    double total = 0;
    for (var expense in expenses) {
      total += double.parse(expense.amount);
    }
    return total.toStringAsFixed(2);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Daily Expenses'),
      ),
      body: Column(
        children: [
          // Add your UI components here

          // Example: Text widget to display total amount
          Text('Total Amount: RM ${_calculateTotal()}'),

          // Add the ListView
          _buildListView(),

          // Add your input fields and buttons here
          // Example: TextField and ElevatedButton for adding expenses
          TextField(
            controller: descriptionController,
            decoration: InputDecoration(labelText: 'Description'),
          ),
          TextField(
            controller: amountController,
            decoration: InputDecoration(labelText: 'Amount(RM)'),
          ),
          ElevatedButton(
            onPressed: _addExpense,
            child: Text('Add Expense'),
          ),
        ],
      ),
    );
  }

  Widget _buildListView() {
    return Expanded(
      child: ListView.builder(
        itemCount: expenses.length,
        itemBuilder: (context, index) {
          return Dismissible(
            key: Key(expenses[index].description),
            background: Container(
              color: Colors.red,
              child: Center(
                child: Text(
                  'Delete',
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ),
            onDismissed: (direction) {
              _removeExpense(index);
              ScaffoldMessenger.of(context)
                  .showSnackBar(SnackBar(content: Text('Item dismissed')));
            },
            child: Card(
              margin: EdgeInsets.all(8.0),
              child: ListTile(
                title: Text(expenses[index].description),
                subtitle: Text('Amount: RM ${expenses[index].amount}'),
                trailing: IconButton(
                  icon: Icon(Icons.delete),
                  onPressed: () => _removeExpense(index),
                ),
                onLongPress: () {
                  _editExpense(index);
                },
              ),
            ),
          );
        },
      ),
    );
  }
}

class EditExpenseScreen extends StatelessWidget {
  final Expense expense;
  final Function(Expense) onSave;

  EditExpenseScreen({required this.expense, required this.onSave});

  final TextEditingController descController = TextEditingController();
  final TextEditingController amountController = TextEditingController();

  // Widget build method and user interface (UI) goes here

  @override
  Widget build(BuildContext context) {
    //Initialize the controllers with the current expense details
    descController.text = expense.description;
    amountController.text= expense.amount;

    return Scaffold(
      appBar: AppBar(
        title: Text('Daily Expenses'),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: TextField(
              controller: descController,
              decoration: InputDecoration(
                labelText: 'Description',
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: TextField(
              controller: amountController,
              decoration: InputDecoration(
                labelText: 'Amount(RM)',
              ),
            ),
          ),

          ElevatedButton(
            onPressed: () {
              //Save the edited expense details
              onSave(Expense (amountController.text, descController.text));

              //Navigate back to the ExpenseList Screen
              Navigator.pop(context);
            },

            child: Text('Save'),
          ),

        ],
      ),
    );
  }
}










