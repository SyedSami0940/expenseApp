import 'package:expenseapp/content/colors.dart';
import 'package:expenseapp/screen/loginScreen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class SignupScrenView extends StatefulWidget {
  const SignupScrenView({super.key});

  @override
  State<SignupScrenView> createState() => _SignupScrenViewState();
}

class _SignupScrenViewState extends State<SignupScrenView> {
  TextEditingController usernameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController passController = TextEditingController();
  var isLoader = false;
  register() async {
    try {
      setState(() {
        isLoader = true;
      });
      await FirebaseAuth.instance
          .createUserWithEmailAndPassword(
            //user: usernameController.text,
            email: emailController.text,
            password: passController.text,
          )
          .then((value) => Navigator.pushReplacement(context,
              MaterialPageRoute(builder: (context) => const LoginscreenView())))
          .catchError(
            (error) =>
                ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
              shape: RoundedRectangleBorder(),
              backgroundColor: Color.fromARGB(255, 167, 38, 49),
              content: Text(
                "Use Different Email and Password",
                style: TextStyle(color: Colors.white, fontSize: 20),
              ),
            )),
          );
      setState(() {
        isLoader = false;
      });
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        print('The password provided is too weak.');
      } else if (e.code == 'email-already-in-use') {
        print('The account already exists for that email.');
      }
    } catch (e) {
      print(e.toString());
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
              Text(
                "Create New Account",
                style: TextStyle(
                    color: Colors.black,
                    fontSize: 24,
                    fontWeight: FontWeight.w700),
              ),
              SizedBox(
                height: 20,
              ),
              TextField(
                controller: usernameController,
                decoration: InputDecoration(
                    prefixIcon: const Icon(Icons.person),
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10)),
                    labelText: 'User Name',
                    labelStyle: const TextStyle(color: Colors.grey)),
              ),
              SizedBox(
                height: 10,
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
              SizedBox(
                height: 20,
              ),
              ElevatedButton(
                onPressed: () {
                  register();
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Color(ex_color.btn_botton),
                ),
                child: const Text(
                  "Create",
                  style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w400,
                      color: Colors.white),
                ),
              ),
              SizedBox(
                height: 20,
              ),
              TextButton(
                onPressed: () {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                      builder: (_) => LoginscreenView(),
                    ),
                  );
                },
                child: Text(
                  "Back to login",
                  style: TextStyle(
                      color: Color(ex_color.btn_botton),
                      fontSize: 16,
                      fontWeight: FontWeight.w500),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
