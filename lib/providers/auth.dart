/* Sign up - Login - Session */
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import '../models/http_exception.dart';

class Auth with ChangeNotifier {
  String? _token;
  DateTime? _expiryDate;
  /*token thường sẽ expire sau 1 khoảng thời gian (với Firebase là 1 tiếng)
  nên phải lưu lại thời gian expire*/
  String? _userId;

  /* Kiểm tra xem đã login chưa, dùng cho main.dart;
  Rule: nếu có token và token chưa expire thì là login rồi */
  bool get isAuth {
    //nếu getter token ko null thì return true
    return token != null;
  }

  //kiểm tra xem có token ko và token đó phải chưa expire
  String? get token {
    if (_expiryDate != null &&
        _expiryDate!.isAfter(DateTime.now()) &&
        _token != null) {
      return _token;
    }

    //nếu ko có hoặc đã expire thì return null
    return null;
  }

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

    //cho vào try catch để nếu có lỗi gì thì xử lý
    try {
      final response = await http.post(
        Uri.parse(url),
        body: json.encode({
          'email': email,
          'password': password,
          'returnSecureToken': true,
        }),
      );

      /* (nếu là server API khác thì có thể truyền về error code -> http.post()
      sẽ throw ra error) nhưng Firebase luôn trả về code 200, kế cả có lỗi, và
      lỗi thì ở trong message thôi -> mình phải tự check message xem có lỗi thì
      throw ra*/
      final responseData = json.decode(response.body);
      if (responseData['error'] != null) {
        /*nếu có key 'error' trong Map (khi có lỗi sẽ có) thì throw ra cái 
        exception mà mình tạo ra*/
        throw HttpException(responseData['error']['message']);
        //throw ra cái message của Firebase -> xử lý bên auth_screen
      }

      //set token và các thứ để check chuyển page sang home
      _token = responseData['idToken'];
      _userId = responseData['localId'];
      //response chỉ có số giây (string) cho đến lúc expire thôi -> phải tự tính
      _expiryDate = DateTime.now().add(
        Duration(
          seconds: int.parse(
            responseData['expiresIn'],
          ),
        ),
      );

      notifyListeners();
    } catch (error) {
      rethrow;
    }

    //print(json.decode(response.body));
  }
}
