import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:testapp/auth.dart';
import 'package:testapp/pages/loginpage.dart';

class LogOptions extends StatefulWidget {
  const LogOptions({super.key});

  @override
  State<LogOptions> createState() => _LogOptionsState();
}

class _LogOptionsState extends State<LogOptions> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              LogInButton(
                text: "Continue with Phone",
                icon: Icon(
                  Icons.smartphone_sharp,
                  color: Colors.black,
                ),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => LogInPage(),
                    ),
                  );
                },
              ),
              SizedBox(
                height: 15,
              ),
              LogInButton(
                text: "Continue with Google",
                icon: Icon(
                  FontAwesomeIcons.google,
                  color: Colors.black,
                ),
                onTap: () {
                  Auth(FirebaseAuth.instance).signInWithGoogle();
                },
              ),
              SizedBox(
                height: 15,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "JUST BROWSING THROUGH",
                    style: TextStyle(color: Colors.black),
                  ),
                ],
              ),
              TextButton(
                onPressed: () {
                  print('Button pressed');
                },
                style: TextButton.styleFrom(
                  foregroundColor: Colors.black,
                  textStyle: TextStyle(
                    decoration: TextDecoration.underline,
                    decorationThickness: 2.0,
                    // Add underline
                  ),
                ),
                child: Text(
                  'Continue without Login',
                  style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold
                      // You can customize the text style further if needed
                      ),
                ),
              )
            ]),
      ),
    );
  }
}

class LogInButton extends StatelessWidget {
  LogInButton({
    Key? key,
    required this.text,
    required this.icon,
    required this.onTap,
  }) : super(key: key);

  final String text;
  final Icon icon;
  final Function onTap;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 50,
      margin: const EdgeInsets.only(left: 15, right: 15),
      child: ElevatedButton(
          onPressed: () => onTap(),
          style: ElevatedButton.styleFrom(
            foregroundColor: Colors.grey,
            backgroundColor: Colors.transparent,
            shadowColor: Colors.transparent,
            surfaceTintColor: Colors.grey,
            side: BorderSide(
              color: Colors.grey.shade800, // Black border color
              width: 2.0, // Border width
            ),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8.0), // Rounded corners
            ),
          ),
          child: Row(
            children: [
              icon,
              SizedBox(
                width: 10,
              ),
              Text(
                text,
                style: TextStyle(color: Colors.black),
              )
            ],
          )),
    );
  }
}
