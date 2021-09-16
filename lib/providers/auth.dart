import 'dart:convert';
import 'package:flutter/widgets.dart';
import 'package:http/http.dart' as http;
import 'package:shop_app/models/http_Exception.dart';

class Auth with ChangeNotifier {
  String _token;
  DateTime _expiryDate;
  String _userId;

  bool get isAuth {
    return token != null;
  }

  String get token {
    if (_expiryDate != null &&
        _expiryDate.isAfter(DateTime.now()) &&
        _token != null) return _token;
    return null;
  }

  Future<void> _authenticate(String email, String pwd, String urlseg) async {
    final url =
        "https://identitytoolkit.googleapis.com/v1/accounts:$urlseg?key=AIzaSyAj9vZr8v1_iPQgJfQDO3ZmHLX_spC1jBg";
    try {
      final response = await http.post(
        Uri.parse(url),
        body: json.encode(
          {
            'email': email,
            'password': pwd,
            'returnSecureToken': true,
          },
        ),
      );
      final responseData = json.decode(response.body);
      if (responseData['error'] != null) {
        throw HttpExepction(responseData['error']['message']);
      }
      _token = responseData['idToken'];
      _userId = responseData["localId"];
      _expiryDate = DateTime.now().add(
        Duration(
          seconds: int.parse(
            responseData['expiresIn'],
          ),
        ),
      );
      notifyListeners();
    } catch (err) {
      throw err;
    }
    // print(json.decode(response.body));
  }

  Future<void> signUp(String email, String pwd) async {
    return _authenticate(email, pwd, 'signUp');
  }

  Future<void> signIn(String email, String pwd) async {
    return _authenticate(email, pwd, 'signInWithPassword');
  }
}
