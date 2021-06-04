import 'package:bloom/bloc/user.bloc.dart';
import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart' as Sec;

class HttpClient {
  static Dio _dio;
  static Sec.FlutterSecureStorage _secureStorage;
  static String _token;
  static String _username;
  static String _password;
  static String _passport;
  static String _name;
  static String _email;
  static bool _isAdmin;

  static init() async {
    _dio = Dio();
    _secureStorage = Sec.FlutterSecureStorage();
    _token = await _secureStorage.read(key: 'token') ?? null;
    _username = await _secureStorage.read(key: 'username') ?? null;
    _password = await _secureStorage.read(key: 'password') ?? null;
    _passport = await _secureStorage.read(key: 'passport') ?? null;
    _email = await _secureStorage.read(key: 'email') ?? null;
    _name = await _secureStorage.read(key: 'name') ?? null;
    _isAdmin = await _secureStorage.read(key: 'isAdmin') == 'true' ? true : false;
  }

  static Future<Dio> http() async {
    if (_token == null) {
      await init();
    }
    if (_token != null) {
      _dio.interceptors
          .add(InterceptorsWrapper(onRequest: (RequestOptions options, RequestInterceptorHandler handler) async {
        options.headers["Authorization"] = "Bearer " + _token;
        options.headers["User-Agent"] = "Mobile App";
        options.headers["Accept"] = "application/json";
        return handler.next(options);
      }));
    } else {
      _dio.interceptors
          .add(InterceptorsWrapper(onRequest: (RequestOptions options, RequestInterceptorHandler handler) async {
        options.headers["User-Agent"] = "Mobile App";
        options.headers["Accept"] = "application/json";
        return handler.next(options);
      }));
    }

    _dio.interceptors.add(InterceptorsWrapper(onResponse: (Response response, ResponseInterceptorHandler handler) async {
        if (response.headers['authorization'] != null) {
          _token = response.headers['authorization'].toString().substring(8, response.headers['authorization'].toString().length - 1);
          print('New Token: ${_token.substring(0,10)}');
          await setToken(_token);
        }

        if (response.statusCode == 401) {
          await HttpClient.removeToken();
          await userBloc.logout();
        }
        return handler.next(response);
    }));

    return _dio;
  }

  static Future<String> getToken() async {
    if (_token == null) {
      await init();
    }

    return _token;
  }

  static Future<void> setToken(String token) async {
    await init();
    await _secureStorage.write(key: 'token', value: token);
  }

  static Future<void> removeToken() async {
    if (_token == null) {
      await init();
    }

    await _secureStorage.delete(key: 'token');
  }

  static Future<String> getPassword() async {
    if (_password == null) {
      await init();
    }

    return _password;
  }

  static Future<Map<String, dynamic>> getUser() async {
    if (_name == null) {
      await init();
    }

    if (_name == null) {
      return null;
    }

    return {"username": _username, "passport" : _passport, "password": _password, "name": _name};
  }

  static Future<void> setPassword(String password) async {
    await init();
    await _secureStorage.write(key: 'password', value: password);
  }

  static Future<void> setPassport(String passportUrl) async {
    await init();
    await _secureStorage.write(key: 'passport', value: passportUrl);
  }

  static Future<String> getUsername() async {
    if (_username == null) {
      await init();
    }

    return _username;
  }

  static Future<void> setUsername(String username) async {
    await init();
    await _secureStorage.write(key: 'username', value: username);
  }

  static Future<void> setEmail(String email) async {
    await init();
    await _secureStorage.write(key: 'email', value: email);
  }

  static Future<String> getEmail() async {
    if (_email == null) {
      await init();
    }

    return _email;
  }

  static Future<void> setIsAdmin(bool admin) async {
    await init();
    await _secureStorage.write(key: 'isAdmin', value: admin.toString());
  }

  static Future<bool> getIsAdmin() async {
    if (_isAdmin == null) {
      await init();
    }

    return _isAdmin;
  }

  static Future<void> setName(String name) async {
    await init();
    await _secureStorage.write(key: 'name', value: name);
  }

  static Future<void> removeUser() async {
    if (_token == null) {
      await init();
    }

    await _secureStorage.delete(key: 'token');
    await _secureStorage.delete(key: 'username');
    await _secureStorage.delete(key: 'password');
    await _secureStorage.delete(key: 'passport');
    await _secureStorage.delete(key: 'name');
    await _secureStorage.delete(key: 'email');
    await _secureStorage.delete(key: 'isAdmin');

    _token = null;
    _username = null;
    _password = null;
    _passport = null;
    _email = null;
    _name = null;
    _isAdmin = false;
  }
}
