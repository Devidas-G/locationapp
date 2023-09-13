import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

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

  Future<UserCredential> signInWithGoogle() async {
    final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();

    final GoogleSignInAuthentication? googleAuth =
        await googleUser?.authentication;

    final credential = GoogleAuthProvider.credential(
      accessToken: googleAuth?.accessToken,
      idToken: googleAuth?.idToken,
    );

    return await auth.signInWithCredential(credential);
  }

  Future<void> singOut() async {
    await auth.signOut();
  }
}
