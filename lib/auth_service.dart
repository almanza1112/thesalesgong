import 'package:firebase_auth/firebase_auth.dart';
import 'package:thesalesgong/home_page.dart';
import 'package:thesalesgong/login/opening_page.dart';

class AuthService {
  handleAuthStateNew() {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      return const OpeningPage();
    } else {
      return const HomePage();
    }
  }
}
