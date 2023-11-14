import 'package:flutter/material.dart';
import 'dailyexpenses.dart';

void main() {
  runApp(const MaterialApp(
    home: LoginScreen(),
  ));
}

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  TextEditingController usernameController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Login Screen'),
      ),
      body: Center(
        child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Padding (
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
            ElevatedButton(
                onPressed: () {
                  //Implement Login Logic here
                  String username = usernameController.text;
                  String password = passwordController.text;
                  if (username == 'text' && password == '123456789'  ) {
                    //Navigate to the daily expense screem
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => DailyExpensesApp(),
                      ),
                    );
                  }else{
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
                                onPressed: (){
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
    );
  }
}

