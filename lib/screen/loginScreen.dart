import 'package:expenseapp/content/colors.dart';
import 'package:expenseapp/screen/dashboardScreen.dart';
import 'package:expenseapp/screen/signupScren.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class LoginscreenView extends StatefulWidget {
  const LoginscreenView({super.key});

  @override
  State<LoginscreenView> createState() => _LoginscreenViewState();
}

class _LoginscreenViewState extends State<LoginscreenView> {
  bool val = false;
  TextEditingController emailController = TextEditingController();
  TextEditingController passController = TextEditingController();
  bool _rememberMe = false;
  login() async {
    try {
      final credential = await FirebaseAuth.instance
          .signInWithEmailAndPassword(
            email: emailController.text,
            password: passController.text,
          )
          .then((value) => Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                  builder: (context) => const DashboardscreenView())))
          .catchError(
            (error) =>
                ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
              shape: RoundedRectangleBorder(),
              backgroundColor: Color.fromARGB(255, 167, 38, 49),
              content: Text(
                "Wrong Password or Email",
                style: TextStyle(color: Colors.white, fontSize: 20),
              ),
            )),
          );
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        print('No user found for that email.');
      } else if (e.code == 'wrong-password') {
        print('Wrong password provided for that user.');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              const SizedBox(height: 80),
              Image.asset(
                'assets/images/splash1.png',
                height: 150,
              ),
              SizedBox(
                height: 20,
              ),
              const Text(
                "Login to your Account",
                style: TextStyle(
                    color: Colors.black,
                    fontSize: 24,
                    fontWeight: FontWeight.w700),
              ),
              SizedBox(
                height: 20,
              ),
              TextField(
                controller: emailController,
                decoration: InputDecoration(
                    prefixIcon: const Icon(Icons.mail),
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10)),
                    labelText: 'Email',
                    labelStyle: const TextStyle(color: Colors.grey)),
              ),
              SizedBox(
                height: 10,
              ),
              TextField(
                obscureText: true,
                controller: passController,
                decoration: InputDecoration(
                    prefixIcon: const Icon(Icons.lock),
                    suffixIcon: const Icon(Icons.remove_red_eye),
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10)),
                    labelText: 'Password',
                    labelStyle: const TextStyle(color: Colors.grey)),
              ),
              const SizedBox(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Checkbox(
                    value: _rememberMe,
                    onChanged: (value) {
                      setState(() {
                        _rememberMe = value!;
                      });
                    },
                  ),
                  const Text('Remember Me'),
                ],
              ),
              SizedBox(
                height: 10,
              ),
              SizedBox(
                width: 300,
                child: ElevatedButton(
                  onPressed: () {
                    login();
                  },
                  style: ElevatedButton.styleFrom(backgroundColor: Colors.blue),
                  child: const Text(
                    "SIGN IN",
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ),
              const SizedBox(height: 15),
              Row(
                children: [
                  TextButton(
                    onPressed: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (_) => SignupScrenView(),
                        ),
                      );
                    },
                    child: Row(
                      children: [
                        Padding(padding: EdgeInsets.symmetric(horizontal: 20)),
                        Text(
                          "Create new account?",
                          style: TextStyle(
                            color: Color(ex_color.btn_botton),
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(
                    width: 2,
                  ),
                  Text(
                    "|",
                    style: TextStyle(
                      color: Color(ex_color.btn_botton),
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(
                    width: 2,
                  ),
                  TextButton(
                    onPressed: () {},
                    child: Row(
                      children: [
                        Text(
                          "Forgot the Password?",
                          style: TextStyle(
                            color: Color(ex_color.btn_botton),
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
