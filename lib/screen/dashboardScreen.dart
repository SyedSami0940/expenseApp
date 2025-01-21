import 'package:expenseapp/content/colors.dart';
import 'package:expenseapp/screen/expense/expense_Dashboard.dart';
import 'package:expenseapp/screen/loginScreen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class DashboardscreenView extends StatefulWidget {
  const DashboardscreenView({super.key});

  @override
  State<DashboardscreenView> createState() => _DashboardscreenViewState();
}

class _DashboardscreenViewState extends State<DashboardscreenView> {
  var isLogoutLoading = false;
  logOut() async {
    setState(() {
      isLogoutLoading = true;
    });
    await FirebaseAuth.instance.signOut();
    //ye login form open ho rah ahi yaha se
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => LoginscreenView(),
      ),
    );
    setState(() {
      isLogoutLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _appBar(),
      body: Center(
        child: Column(
          children: [
            SizedBox(
              height: MediaQuery.of(context).size.height / 4,
            ),
            // Expense Button
            GestureDetector(
              onTap: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => ExpenseDashboardView(),
                  ),
                );
                print('Expense button pressed');
              },
              child: Container(
                width: 150,
                height: 150,
                decoration: BoxDecoration(
                  color: Colors.blueAccent,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    FaIcon(
                      FontAwesomeIcons.coins,
                      color: Colors.white,
                      size: 40,
                    ),
                    SizedBox(height: 8),
                    Text(
                      'Expense',
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(height: 20),

            GestureDetector(
              onTap: () {
                print('Budget button pressed');
              },
              child: Container(
                width: 150,
                height: 150,
                decoration: BoxDecoration(
                  color: Color(ex_color.btn_Expens),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    FaIcon(
                      FontAwesomeIcons.wallet,
                      color: Colors.white,
                      size: 40,
                    ),
                    SizedBox(height: 8),
                    Text(
                      'Budget',
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  PreferredSizeWidget _appBar() {
    return AppBar(
      // backgroundColor: Color(ex_color.header),
      actions: [
        IconButton(
          onPressed: () {
            logOut();
          },
          icon: isLogoutLoading
              ? CircularProgressIndicator()
              : Icon(
                  Icons.exit_to_app,
                  color: Color(ex_color.redout),
                ),
          tooltip: 'Log out',
        ),
      ],
      title: Text(
        "Dashboard",
        style: TextStyle(
          color: Colors.black54,
        ),
      ),
    );
  }
}
