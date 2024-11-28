import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

//def login page
class LoginPage extends StatefulWidget {
  @override

  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  //controllers
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  //managing form validation using key
  final _formKey = GlobalKey<FormState>();
   final FirebaseAuth _auth = FirebaseAuth.instance;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Login to Hama Fast',
          style: TextStyle(color: Colors.white),
        )
      ),
      body: Padding(
        padding:const EdgeInsets.all(16.0),
      child: Form(
        key: _formKey,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              'Login',
              style: Theme.of(context).textTheme.headlineMedium,
            ),

            SizedBox(height:20),

            //email field
            TextFormField(
              controller: emailController,
              decoration: InputDecoration(
                labelText: 'Email',
                border: OutlineInputBorder(borderSide: BorderSide(color:Colors.black)),
                focusedBorder: OutlineInputBorder(borderSide: BorderSide(color:Colors.black)),
              ),
              keyboardType: TextInputType.emailAddress,
              validator: (value) {
                if (value == null  || value.isEmpty) {
                  return 'Please enter your email';
                }
                if (!RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(value)) {
                  return 'Please enter a valid email';
                }
                return null;
              },
            ),

            SizedBox(height: 20),

            //password UI
            TextFormField(
              controller: passwordController,
              obscureText: true,
              decoration: InputDecoration(
                labelText: 'Password',
                border: OutlineInputBorder(borderSide: BorderSide(color:Colors.black)),
                focusedBorder: OutlineInputBorder(borderSide: BorderSide(color:Colors.black)),
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter your password';
                }
                return null;
              },
            ),

            SizedBox(height:20),


            ElevatedButton(
              onPressed: () async {
                if (_formKey.currentState!.validate()) {
                  try{
                     await _auth.signInWithEmailAndPassword(
                      email: emailController.text.trim(),
                      password: passwordController.text.trim(),
                    );
                    Navigator.pushReplacementNamed(context, '/dashboard');
                  }on FirebaseAuthException catch (e) {
                    String errorMessage;
                    if (e.code == 'user-not-found') {
                      errorMessage = 'No user for that email';
                    }else if (e.code == 'wrong-password') {
                      errorMessage = 'Wrong password';
                    }else {
                      errorMessage = 'Error!! Please try again';
                    }
                    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(errorMessage)));
                  }
                }
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.teal,
                foregroundColor: Colors.white,
              ),
              child: Text('Login'),
            ),
            

              SizedBox (height:10),

              TextButton(
                onPressed: () {
                  Navigator.pushNamed(context, '/register');
                },
                style: TextButton.styleFrom(
                  foregroundColor: Colors.teal
                ),
                child: Text('Don\'t have an account? Register Here'),
              ),
            ],
          ),
        ),
      )
    );
  }
}