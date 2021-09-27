import 'dart:convert';
import 'package:flutter/widgets.dart';
import 'package:http/http.dart' as http;
import 'package:shop_app/models/http_Exception.dart';
import 'dart:async';
import 'package:shared_preferences/shared_preferences.dart';

class Auth with ChangeNotifier {
  String _token;
  DateTime _expiryDate;
  String _userId;
  Timer _authTimer;

  bool get isAuth {
    return token != null;
  }

  String get token {
    if (_expiryDate != null &&
        _expiryDate.isAfter(DateTime.now()) &&
        _token != null) return _token;
    return null;
  }

  String get userId {
    return _userId;
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
      _autoLogout();
      notifyListeners();
      final prefs = await SharedPreferences.getInstance();
      final userData = json.encode({
        'token': _token,
        'userId': _userId,
        'expiryDate': _expiryDate.toIso8601String(),
      });
      prefs.setString('userData', userData);
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

  Future<bool> tryAutoLogin() async {
    final prefs = await SharedPreferences.getInstance();
    if (!prefs.containsKey('userData')) {
      return false;
    }
    final extractedData =
        json.decode(prefs.getString('userData')) as Map<String, Object>;
    final expiryData = DateTime.parse(extractedData['expiryDate']);
    if (expiryData.isBefore(DateTime.now())) return false;
    _token = extractedData['token'];
    _expiryDate = expiryData;
    _userId = extractedData['userId'];
    notifyListeners();
    _autoLogout();
    return true;
  }

  Future<void> logOut() async {
    _token = null;
    _userId = null;
    _expiryDate = null;
    if (_authTimer != null) {
      _authTimer.cancel();
      _authTimer = null;
    }
    notifyListeners();
    final prefs = await SharedPreferences.getInstance();
    // prefs.remove('userData');
    prefs.clear();
  }

  void _autoLogout() {
    if (_authTimer != null) {
      _authTimer.cancel();
    }
    final timeExp = _expiryDate.difference(DateTime.now()).inSeconds;
    _authTimer = Timer(Duration(seconds: timeExp), logOut);
  }
}
