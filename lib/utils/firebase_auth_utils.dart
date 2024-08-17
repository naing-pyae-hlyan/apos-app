import 'package:firebase_auth/firebase_auth.dart';

class FAUtils {
  static final _auth = FirebaseAuth.instance;
  static FirebaseAuth get auth => _auth;
}
