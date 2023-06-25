import 'package:firebase_auth/firebase_auth.dart';

const baseURL = '10.0.2.2:8080';

Future<Map<String, String>> getHeaders() async {

  final currentUser = await FirebaseAuth.instance.currentUser;
  final token = await currentUser?.getIdToken();

  return {
    "Content-Type": "application/json",
    "Authorization": "Bearer $token"
  };
}