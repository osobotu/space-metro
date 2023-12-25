import 'package:firebase_auth/firebase_auth.dart';

class FirebaseAuthService {
  static final FirebaseAuth _auth = FirebaseAuth.instance;

  static Stream<User?> userChanges() {
    return _auth.userChanges();
  }

  static User? get currentUser => _auth.currentUser;

  static Future<void> handleGoogleSignIn() async {
    GoogleAuthProvider googleProvider = GoogleAuthProvider();
    await FirebaseAuth.instance.signInWithPopup(googleProvider);
    return;
  }

  static Future<void> logout() async {
    await _auth.signOut();
  }
}
