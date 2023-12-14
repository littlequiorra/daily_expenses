import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

import '../Controller/sqlite_db.dart';
import '../Controller/request_controller.dart';


class Expense {
  static const String SQLiteTable = "expense";
  int? id;
  String desc;
  double amount;
  String dateTime;
  Expense(this.amount,this.desc, this.dateTime);

  Expense.fromJson(Map<String, dynamic> json)
      : desc = json['desc'] as String,
        amount = double.parse(json['amount'] as dynamic),
        dateTime = json['dateTime'] as String,
        id = json['id'] as int?;

  //toJson will be automatically called by jsonEncode when necessary
  Map<String, dynamic> toJson() =>
      {'desc': desc, 'amount': amount, 'dateTime': dateTime };

  Future<bool> save() async {
    //Save to local SQlite
    await SQLiteDB().insert(SQLiteTable, toJson());
    //API Operation
    final SharedPreferences pref = await SharedPreferences.getInstance();
    String api = pref.getString("retrieveTheURLFROMSharedPrefs") ?? "";
    RequestController req = RequestController(path: "/api/expenses.php", server: api);
    req.setBody(toJson());
    await req.post();
    if (req.status()==200) {
      return true;
    }
    else
      {
        if (await SQLiteDB().insert(SQLiteTable, toJson())!=0) {
          return true;
        }
        else {
          return false;
        }
      }
  }

  static Future<List<Expense>> loadAll() async {
    List<Expense> result =[];
    final SharedPreferences pref = await SharedPreferences.getInstance();
    String api = pref.getString("retrieveTheURLFROMSharedPrefs") ?? "";
     RequestController req = RequestController(
      path: "/api/expenses.php",
       server: "http://$api",
    );

    await req.get();
    if (req.status() == 200 && req.result() != null) {
      for (var item in req.result()) {
        result.add(Expense.fromJson(item));
      }
    }
    else
      {
        List <Map<String, dynamic>> result = await SQLiteDB().queryAll(SQLiteTable);
        List <Expense> expenses = [];
        for (var item in result) {
          result.add(Expense.fromJson(item) as Map<String, dynamic>);
        }
      }

    return result;
  }
}