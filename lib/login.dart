import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dailyexpenses.dart';

void main() {
  runApp( MaterialApp(
    home: LoginScreen(),
  ));
}

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  //late String api;
  late final String api;
  TextEditingController usernameController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController apiController = TextEditingController();


  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        title: const Text('Login Screen'),
      ),
      body: SingleChildScrollView(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Image.network('https://w7.pngwing.com/pngs/978/821/png-transparent-money-finance-wallet-payment-daily-expenses-saving-service-personal-finance.png'),
              ),
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: TextField(
                  controller: usernameController,
                  decoration: const InputDecoration(
                    labelText: 'Username',
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: TextField(
                  controller: passwordController,
                  obscureText: true,
                  decoration: const InputDecoration(
                    labelText: 'Password',
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: TextField(
                  controller: apiController,
                  decoration: const InputDecoration(
                    labelText: 'REST API address',
                  ),
                ),
              ),
              ElevatedButton(
                onPressed: () async {
                  //Implement Login Logic here
                  String username = usernameController.text;
                  String password = passwordController.text;
                  String api = apiController.text;
                  if (username == 'text' && password == '123456789') {
                    final SharedPreferences pref = await SharedPreferences.getInstance();
                    await pref.setString("retrieveTheURLFROMSharedPrefs", api);
                    print(api);
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) =>
                            DailyExpensesApp(username: username, ),
                      ),
                    );
                  } else {
                    //Show an error message or handle invalid login
                    showDialog(
                      context: context,
                      builder: (context) {
                        return AlertDialog(
                          title: const Text('Login Failed'),
                          content: const Text('Invalid username or password.'),
                          actions: [
                            TextButton(
                              child: const Text('OK'),
                              onPressed: () {
                                Navigator.pop(context);
                              },
                            ),
                          ],
                        );
                      },
                    );
                  }
                },
                child: const Text('Login'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
