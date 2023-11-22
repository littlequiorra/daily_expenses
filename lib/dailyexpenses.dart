import 'package:daily_expenses/Controller/request_controller.dart';
import 'package:daily_expenses/Model/expense.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(DailyExpensesApp());
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
  get username => null;

  @override
  _ExpenseListState createState() => _ExpenseListState();
}

class _ExpenseListState extends State<ExpenseList> {
  final List<Expense> expenses = [];
  final TextEditingController descriptionController = TextEditingController();
  final TextEditingController amountController = TextEditingController();
  final TextEditingController totalAmountController = TextEditingController();
  final TextEditingController txtDateController = TextEditingController();

  double totalAmount = 0.0;

  void _addExpense() async {
    String description = descriptionController.text.trim();
    String amount = amountController.text.trim();
    if (description.isNotEmpty && amount.isNotEmpty) {
      Expense exp =
      Expense(double.parse(amount), description, txtDateController.text);
      if (await exp.save()) {
        setState(() {
          expenses.add(exp);
          descriptionController.clear();
          amountController.clear();
        });
      } else {
        _showMessage("Failed to save Expenses data");
      }
    }
  }

  void _removeExpense(int index) {
    setState(() {
      expenses.removeAt(index);
    });
  }

  void _showMessage (String msg) {
    if (mounted) {
      //make sure this context is still mounted/exist
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(msg),
        ),
      );
    }
  }

  void _editExpense(int index) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => EditExpenseScreen(
          expense: expenses[index],
          onSave: (editedExpense) {
            setState(() {
              totalAmount += editedExpense.amount - expenses[index].amount;
              expenses[index] = editedExpense;
                  totalAmountController.text = totalAmount.toString();
            });
          },
        ),
      ),
    );
  }

  //new fn- Date and time picker on textField
  _selectDate() async {
    final DateTime? pickedDate = await showDatePicker(
      context : context,
      initialDate : DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );

    final TimeOfDay? pickedTime = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );

    if (pickedDate !=null && pickedTime != null) {
      setState((){
        txtDateController.text =
        "${pickedDate.year}-${pickedDate.month}-${pickedDate.day}"
            "${pickedTime.hour}:${pickedTime.minute}:00";
      });
    }
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) async {
      _showMessage ("Welcome ${widget.username}");

      RequestController req = RequestController(
        path: "/api/timezone/Asia/Kuala_Lumpur",
        server:"http://worldtimeapi.org");

      req.get().then((value) {
        dynamic res = req.result();
        txtDateController.text =
            res["datetime"].toString().substring(0,19).replaceAll('T','');

      });
      expenses.addAll(await Expense.loadAll());

      setState(() {
        _calculateTotal();
      });
    });
  }


  String _calculateTotal() {
    double total = 0.0;
    for (var expense in expenses) {
      total += expense.amount;
    }
    return total.toStringAsFixed(2);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar: AppBar(
      //   title: Text('Daily Expenses'),
      // ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: TextField(
              controller: descriptionController,
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
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: TextField(
                keyboardType: TextInputType.datetime,
                controller:txtDateController,
                readOnly: true,
                onTap: _selectDate,
                decoration: const InputDecoration(labelText: 'Date'),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: TextField(
              controller: totalAmountController,
              readOnly: true,
              decoration: InputDecoration(labelText: 'Total Amount (RM):${_calculateTotal()}'),
              ),
            ),
          ElevatedButton(
            onPressed: _addExpense,
            child: Text('Add Expense'),
          ),
          Container(
            child: _buildListView(),
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
            key: Key(expenses[index].amount.toString()),
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
                title: Text(expenses[index].desc),
                subtitle: Row(children: [

                  Text('Amount: RM ${expenses[index].amount.toString()}'),
                    const Spacer(),
                    Text('Date: ${expenses[index].dateTime}'),
                ]) ,
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
    descController.text = expense.desc;
    amountController.text= expense.amount.toString();

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
              onSave(Expense (double.parse(amountController.text),
                  descController.text, expense.dateTime)); //Expense

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










