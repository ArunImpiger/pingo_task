import 'package:flutter/material.dart';
import 'package:pingo_task/view/signup_page.dart';
import 'package:provider/provider.dart';

import '../providers/auth_provider.dart';
import 'product_page.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _isLoading = false;
  String? _errorMessage;

  Future<void> _login() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      if(_emailController.text.isNotEmpty &&  _passwordController.text.isNotEmpty){
        await Provider.of<AuthProvider>(context, listen: false).login(
          _emailController.text,
          _passwordController.text,
        );
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (context) => const ProductPage()),
        );
      }else{
        setState(() {
          _errorMessage = 'Please fill the fields';
        });
      }

    } catch (e) {
      setState(() {
        _errorMessage = e.toString();
      });
    }

    setState(() {
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F9FD),
      appBar: AppBar(
        title: const Text(
          "e-shop",
          style:
              TextStyle(color: Color(0xFF0C54BE), fontWeight: FontWeight.bold),
        ),
        backgroundColor: const Color(0xFFF5F9FD),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            children: [
              if (_errorMessage != null) ...[
                Text(
                  _errorMessage!,
                  style: const TextStyle(color: Colors.red),
                ),
                const SizedBox(height: 10),
              ],
              SizedBox(
                height: MediaQuery.of(context).size.height * .20,
              ),
              TextField(
                controller: _emailController,
                autofocus: false,
                style: const TextStyle(fontSize: 16.0, color: Colors.black),
                decoration: InputDecoration(
                  filled: true,
                  fillColor: Colors.white,
                  hintText: 'Email',
                  contentPadding:
                      const EdgeInsets.only(left: 20.0, right: 20.0),
                  focusedBorder: OutlineInputBorder(
                    borderSide: const BorderSide(color: Colors.white),
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                  enabledBorder: UnderlineInputBorder(
                    borderSide: const BorderSide(color: Colors.white),
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              TextField(
                controller: _passwordController,
                obscureText: true,
                autofocus: false,
                style: const TextStyle(fontSize: 16.0, color: Colors.black),
                decoration: InputDecoration(
                  filled: true,
                  fillColor: Colors.white,
                  hintText: 'Password',
                  contentPadding:
                      const EdgeInsets.only(left: 20.0, right: 20.0),
                  focusedBorder: OutlineInputBorder(
                    borderSide: const BorderSide(color: Colors.white),
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                  enabledBorder: UnderlineInputBorder(
                    borderSide: const BorderSide(color: Colors.white),
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                ),
              ),
              SizedBox(
                height: MediaQuery.of(context).size.height * .30,
              ),
              if (_isLoading)
                const CircularProgressIndicator()
              else
                Container(
                width: 250,
                padding: const EdgeInsets.only(top: 20, left: 30, right: 30),
                child: ElevatedButton(
                  onPressed: _login,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF0C54BE),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8), // Corner radius
                    ),
                  ),
                  child: const Padding(
                    padding: EdgeInsets.all(10),
                    child: Text(
                      'Login',
                      style: TextStyle(

                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 14),
                    ),
                  ),
                ),
              ),
              GestureDetector(
                onTap: (){
                  Navigator.of(context).pushReplacement(
                    MaterialPageRoute(builder: (context) => const SignupPage()),
                  );
                },
                child: const Text.rich(
                  TextSpan(
                    children: [
                      TextSpan(
                        text: 'New here?',
                        style: TextStyle(
                            color: Colors.black,
                            fontSize: 14
                        ),
                      ),
                      TextSpan(
                        text: ' Signup',
                        style: TextStyle(
                          fontSize: 14,
                          color: Color(0xFF0C54BE)
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
