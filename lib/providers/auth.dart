/* Sign up - Login - Session */
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class Auth with ChangeNotifier {
  // String _token;
  // DateTime _expiryDate;
  // /*token thường sẽ expire sau 1 khoảng thời gian (với Firebase là 1 tiếng)
  // nên phải lưu lại thời gian expire*/
  // String _userId;

  /*Sign up:
  Hướng dẫn: https://firebase.google.com/docs/reference/rest/auth#section-create-email-password */
  Future<void> signup(String email, String password) async {
    /* API Key để cho vào URL: copy từ Firebase -> Project Settings -> Web API Key */
    const url =
        'https://identitytoolkit.googleapis.com/v1/accounts:signUp?key=AIzaSyCIRTI838p6SbMXCKEn1tvi-auxPBL-3eQ';
    final response = await http.post(
      Uri.parse(url),
      body: json.encode({
        'email': email,
        'password': password,
        'returnSecureToken': true,
      }),
    );

    print(json.decode(response.body));
  }
}
