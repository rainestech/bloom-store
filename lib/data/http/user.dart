import 'dart:convert';

import 'package:bloom/data/entity/admin.entity.dart';
import 'package:bloom/data/http/http.client.dart';
import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';

import 'endpoints.dart';

class UserResponse {
  final User data;
  final String error;
  final String eTitle;
  final int length;

  UserResponse(this.data, this.error, this.length, this.eTitle);

  UserResponse.fromJson(resp, len)
      : data = new User.fromJson(resp),
        error = "",
        eTitle = "",
        length = len;

  UserResponse.withError(String msg, title)
      : data = null,
        error = msg,
        eTitle = title,
        length = 0;
}

class UserListResponse {
  final List<User> data;
  final String error;
  final String eTitle;

  UserListResponse(this.data, this.error, this.eTitle);

  UserListResponse.fromJson(resp)
      : data = (resp as List).map((i) => new User.fromJson(i)).toList(),
        error = "",
        eTitle = "";

  UserListResponse.withError(String msg, title)
      : data = null,
        error = msg,
        eTitle = title;
}

class RegisterResponse {
  final String otp;
  final User user;
  final String error;
  final String eTitle;

  RegisterResponse(this.user, this.otp, this.error, this.eTitle);

  RegisterResponse.fromJson(resp)
      : otp = resp['otp'],
        user = new User.fromJson(resp['user']),
        error = "",
        eTitle = "";

  RegisterResponse.withError(String msg, String title)
      : otp = null,
        user = null,
        eTitle = title,
        error = msg;
}

class UserApiProvider {
  Future<UserResponse> loginUser(String username, String password) async {
    try {
      final Dio _dio = await HttpClient.http();
      Response response = await _dio.post(loginEndpoint,
          data: {'username': username, 'password': password});

      await HttpClient.setPassword(password);
      await HttpClient.setUsername(username);
      UserResponse resp = UserResponse.fromJson(response.data, response.data.length);
      if (resp.data.passport != null) {
        await HttpClient.setPassport(fsDlEndpoint + resp.data.passport.link);
      }

      await HttpClient.setEmail(resp.data.email);
      await HttpClient.setIsAdmin(resp.data.isAdmin);

      return resp;
    } catch (e) {
      debugPrint(e.toString());
      if (e.response != null) {
        Map<String, dynamic> error = json.decode(e.response.toString());
        return UserResponse.withError(error['message'], error['error']);
      }
      return UserResponse.withError(e.message, "Network Error");
    }
  }

  Future<UserResponse> changePasswordUsingId(int id, String password, String oldPassword) async {
    try {
      final Dio _dio = await HttpClient.http();
      Response response = await _dio.post(adminEndpoint + "/changePwd",
          data: {'id': id, 'password': password, 'oldPassword': oldPassword});

      await HttpClient.setPassword(password);
      return UserResponse.fromJson(response.data, response.data.length);
    } catch (e) {
      if (e.response != null) {
        Map<String, dynamic> error = json.decode(e.response.toString());
        return UserResponse.withError(error['message'], error['error']);
      }
      return UserResponse.withError(e.message, "Network Error");
    }
  }

  logout() async {
    await HttpClient.removeUser();
  }

  Future<RegisterResponse> register(String username, String password,
      String name, String email) async {
    try {
      final Dio _dio = await HttpClient.http();
      Response response = await _dio.post(registerEndpoint, data: {
        'username': username,
        'password': password,
        'name': name,
        'email': email
      });

      print('Register Resp ' + response.data.toString());

      return RegisterResponse.fromJson(response.data);
    } catch (e) {
      if (e.response != null) {
        print(e.response.toString());
        Map<String, dynamic> error = json.decode(e.response.toString());
        return RegisterResponse.withError(error['message'], error['error']);
      }
      return RegisterResponse.withError(e.message, "Network Error");
    }
  }

  Future<RegisterResponse> resendOtp(String email) async {
    try {
      final Dio _dio = await HttpClient.http();
      Response response = await _dio.post(registerEndpoint + '/otp', data: {
        'email': email
      });

      return RegisterResponse.fromJson(response.data);
    } catch (e) {
      if (e.response != null) {
        print(e.response.toString());
        Map<String, dynamic> error = json.decode(e.response.toString());
        return RegisterResponse.withError(error['message'], error['error']);
      }
      return RegisterResponse.withError(e.message, "Network Error");
    }
  }

  Future<RegisterResponse> resetPassword(String email) async {
    final Dio _dio = await HttpClient.http();
    try {
      print("Email: $email");
      Response response = await _dio.post(resetPasswordEndpoint, data: {
        'email': email,
      });

      return RegisterResponse.fromJson(response.data);
    } catch (e) {
      if (e.response != null) {
        Map<String, dynamic> error = json.decode(e.response.toString());
        return RegisterResponse.withError(error['message'], error['error']);
      }
      return RegisterResponse.withError(e.message, "Network Error");
    }
  }

  Future<RegisterResponse> setNewPassword(
      String email, String password, String otp) async {
    try {
      final Dio _dio = await HttpClient.http();
      Response response = await _dio.post(passwordEndpoint,
          data: {'email': email, 'otp': otp, 'password': password});

      return RegisterResponse.fromJson(response.data);
    } catch (e) {
      if (e.response != null) {
        Map<String, dynamic> error = json.decode(e.response.toString());

        return RegisterResponse.withError(error['message'], error['error']);
      }
      return RegisterResponse.withError(e.message, "Network Error");
    }
  }

  Future<RegisterResponse> changePassword(String email, String password,
      String oldPassword) async {
    try {
      final Dio _dio = await HttpClient.http();
      Response response = await _dio.put(passwordChangeEndpoint,
          data: {
            'email': email,
            'oldPassword': oldPassword,
            'password': password
          });

      return RegisterResponse(null, '', null, null);
    } catch (e) {
      if (e.response != null) {
        Map<String, dynamic> error = json.decode(e.response.toString());
        return RegisterResponse.withError(error['message'], error['error']);
      }
      return RegisterResponse.withError(e.message, "Network Error");
    }
  }

  Future<UserResponse> verify(String otp, String email) async {
    try {
      final Dio _dio = await HttpClient.http();
      Response response =
      await _dio.post(verifyEndpoint, data: {'otp': otp, 'email': email});

      print(response.data.toString());

      UserResponse resp = UserResponse.fromJson(response.data, response.data.length);
      if (resp.data.passport != null) {
        await HttpClient.setPassport(fsDlEndpoint + resp.data.passport.link);
      }

      await HttpClient.setEmail(resp.data.email);
      await HttpClient.setIsAdmin(resp.data.isAdmin);

      return resp;
    } catch (e) {
      if (e.response != null) {
        print('Otp Error ' + e.response.toString());
        Map<String, dynamic> error = json.decode(e.response.toString());
        return UserResponse.withError(error['message'], error['error']);
      }
      return UserResponse.withError(e.message, "Network Error");
    }
  }

  Future<UserResponse> editUser(User _user) async {
    try {
      final Dio _dio = await HttpClient.http();
      Response response = await _dio.put(editUserEndpoint, data: _user);

      UserResponse resp = UserResponse.fromJson(response.data, response.data.length);

      String email = await HttpClient.getEmail();

      if (email == resp.data.email) {
        if (resp.data.passport != null) {
          await HttpClient.setPassport(fsDlEndpoint + resp.data.passport.link);
        }
        await HttpClient.setIsAdmin(resp.data.isAdmin);
      }

      return resp;
    } catch (e) {
      if (e.response != null) {
        Map<String, dynamic> error = json.decode(e.response.toString());
        return UserResponse.withError(error['message'], error['error']);
      }
      return UserResponse.withError(e.message, "Network Error");
    }
  }

  Future<UserResponse> getUser() async {
    try {
      final Dio _dio = await HttpClient.http();
      Response response = await _dio.get(adminEndpoint + '/me');

      UserResponse resp = UserResponse.fromJson(response.data, response.data.length);

      if (resp.data.passport != null) {
        await HttpClient.setPassport(fsDlEndpoint + resp.data.passport.link);
      }
      await HttpClient.setIsAdmin(resp.data.isAdmin);

      return resp;
    } catch (e) {
      print(e.message);
      return UserResponse.withError(e.message, "Network Error");
    }
  }

  Future<UserListResponse> getAdmin() async {
    try {
      final Dio _dio = await HttpClient.http();
      Response response = await _dio.get(editUserEndpoint + '/admin');
      return UserListResponse.fromJson(response.data);
    } catch (e) {
      print(e.message);
      return UserListResponse.withError(e.message, "Network Error");
    }
  }

  Future<UserResponse> loginGoogle(GoogleSignInAccount acc) async {
    try {
      final Dio _dio = await HttpClient.http();
      Response response = await _dio.post(loginGoogleEndpoint, data: {
        'email': acc.email,
        'id': acc.id,
        'displayName': acc.displayName,
        'photoUrl': acc.photoUrl
      });
      UserResponse resp = UserResponse.fromJson(response.data, response.data.length);

      if (resp.data.passport != null) {
        await HttpClient.setPassport(fsDlEndpoint + resp.data.passport.link);
      }
      await HttpClient.setIsAdmin(resp.data.isAdmin);

      return resp;
    } catch (e) {
      if (e.response != null) {
        Map<String, dynamic> error = json.decode(e.response.toString());
        return UserResponse.withError(error['message'], error['error']);
      }
      return UserResponse.withError(e.message, "Network Error");
    }
  }

  Future<UserResponse> loginFacebook(Map<String, dynamic> acc) async {
    try {
      final Dio _dio = await HttpClient.http();
      Response response = await _dio.post(loginGoogleEndpoint, data: acc);
      UserResponse resp = UserResponse.fromJson(response.data, response.data.length);

      if (resp.data.passport != null) {
        await HttpClient.setPassport(fsDlEndpoint + resp.data.passport.link);
      }
      await HttpClient.setIsAdmin(resp.data.isAdmin);

      return resp;
    } catch (e) {
      if (e.response != null) {
        Map<String, dynamic> error = json.decode(e.response.toString());
        return UserResponse.withError(error['message'], error['error']);
      }
      return UserResponse.withError(e.message, "Network Error");
    }
  }
}
