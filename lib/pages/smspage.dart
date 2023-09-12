import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_ui_auth/firebase_ui_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:testapp/pages/homepage.dart';

class SmsScreen extends StatefulWidget {
  final Object flowKey;
  const SmsScreen({Key? key, required this.flowKey}) : super(key: key);

  @override
  State<SmsScreen> createState() => _SmsScreenState();
}

class _SmsScreenState extends State<SmsScreen> {
  @override
  Widget build(BuildContext context) {
    final user = context.watch<User?>();
    if (user != null) {
      return const MyHomePage(
        title: 'Location App',
      );
    } else {
      return SMSCodeInputScreen(
        flowKey: widget.flowKey,
      );
    }
  }
}
