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
    //phải return để cái loading spinner hoạt động bình thường đc
    return _authenticate(email, password, 'signUp');
  }

  /* Login:
  Hướng dẫn: https://firebase.google.com/docs/reference/rest/auth#section-sign-in-email-password */
  Future<void> login(String email, String password) async {
    return _authenticate(email, password, 'signInWithPassword');
  }

  /* Optional: vì 2 function login và signup có code tương tự -> có thể dùng
  chung 1 function thôi, truyền vào URL vì đó là cái khác duy nhất */
  Future<void> _authenticate(
      String email, String password, String urlSegment) async {
    final url =
        'https://identitytoolkit.googleapis.com/v1/accounts:$urlSegment?key=AIzaSyCIRTI838p6SbMXCKEn1tvi-auxPBL-3eQ';
    //URL gắn vs URL truyền vào
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
