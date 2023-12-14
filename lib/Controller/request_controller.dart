import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class RequestController {
  String path;
  String server;
  http.Response? _res;

  final Map <dynamic, dynamic> _body = {};
  final Map <String, String> _headers ={};
  dynamic _resultData;


  RequestController ({required this.path, required this.server});
  setBody (Map<String, dynamic> data) {
    _body.clear();
    _body.addAll(data);
    _headers["Content-Type"] = "application/json; charset=UTF-8";

  }


  Future<void> post() async {
    final SharedPreferences pref = await SharedPreferences.getInstance();
    String api = pref.getString("retrieveTheURLFROMSharedPrefs") ?? "";
    _res = await http.post(
      Uri.parse("http://$api$path"),
      headers: _headers,
      body: jsonEncode(_body),
    );
    _parseResult();
    print("url>>");
    print (server+path);
  }

  Future<void> get() async {
    final SharedPreferences pref = await SharedPreferences.getInstance();
    String api = pref.getString("retrieveTheURLFROMSharedPrefs") ?? "";
    _res= await http.get(
      Uri.parse("http://$api$path"),
      headers: _headers,
    );
    _parseResult();
    print("url>>");
    print (server+path);
  }

  void _parseResult(){
    //parse result into json structure if possible
    try {
      print("raw response:${_res?.body}");
      _resultData = jsonDecode(_res?.body??"");
    }catch(ex){
      //otherwise the response body will be stored as is
      _resultData= _res?.body;
      print ("exception in http result parsing ${ex}");
    }
  }

  dynamic result() {
    return _resultData;
  }

  int status () {
    return _res?.statusCode ?? 0;
  }
}