import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:testapp/auth.dart';
import 'package:testapp/pages/homepage.dart';
import 'package:testapp/pages/loginpage.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MultiProvider(
      providers: [
        Provider(create: (_) => Auth(FirebaseAuth.instance)),
        StreamProvider(
          create: (context) => context.read<Auth>().authStateChanges,
          initialData: null,
        )
      ],
      child: const MaterialApp(
          debugShowCheckedModeBanner: false, home: Wrapper())));
}

class Wrapper extends StatefulWidget {
  const Wrapper({Key? key}) : super(key: key);

  @override
  _WrapperState createState() => _WrapperState();
}

class _WrapperState extends State<Wrapper> {
  @override
  Widget build(BuildContext context) {
    final user = context.watch<User?>();
    if (user != null) {
      return const MyHomePage(
        title: 'Location App',
      );
    } else {
      return const LogInPage();
    }
  }
}
