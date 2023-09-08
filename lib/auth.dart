import 'package:firebase_auth/firebase_auth.dart';

class Auth {
  Auth(this.auth);
  final FirebaseAuth auth;
  User? get currentUser => auth.currentUser;
  Stream<User?> get authStateChanges => auth.authStateChanges();

  Future<void> phoneSignIn(
      {required String number, required String otp}) async {
    ConfirmationResult confirmationResult =
        await auth.signInWithPhoneNumber(number);
    UserCredential userCredential = await confirmationResult.confirm(otp);
    final user = userCredential.user;
    print(user?.uid);
  }

  Future<void> singOut() async {
    await auth.signOut();
  }
}
