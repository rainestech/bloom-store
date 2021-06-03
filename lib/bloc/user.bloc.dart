import 'dart:async';
import 'dart:io';

import 'package:bloom/bloc/messages.bloc.dart';
import 'package:bloom/data/entity/admin.entity.dart';
import 'package:bloom/data/http/user.dart';
import 'package:bloom/data/repository/user.repository.dart';
import 'package:bloom/helpers/firestore.db.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:rxdart/rxdart.dart';
import 'package:bloom/data/http/http.client.dart';

class UserBloc {
  final FlutterSecureStorage _storage = FlutterSecureStorage();
  final UserRepository _repository = UserRepository();

  final BehaviorSubject<UserResponse> _userSubject =
      BehaviorSubject<UserResponse>();

  final BehaviorSubject<UserListResponse> _adminsSubject =
      BehaviorSubject<UserListResponse>();

  final BehaviorSubject<bool> _userStatus = BehaviorSubject<bool>();
  final BehaviorSubject<String> _token = BehaviorSubject<String>();
  final BehaviorSubject<File> _image = BehaviorSubject<File>();

  StreamSubscription<DocumentSnapshot> streamSub;


  Future<UserResponse> login(String username, String password) async {
    UserResponse response = await _repository.login(username, password);
    _userSubject.sink.add(response);

    return response;
  }

  Future<User> getUser() async {
    UserResponse resp = await _repository.getUser();

    if (resp.data != null) {
      _userSubject.sink.add(resp);
      FirestoreHelper.updateUser(resp.data);
      return resp.data;
    } else {
      await clearUserData();
      _userSubject.sink.add(resp);
    }

    return null;
  }

  Future<void> clearUserData() async {
    await HttpClient.removeUser();
    await FirestoreHelper.logout();
  }

  UserResponse getUserResponse() {
    if (_userSubject.hasValue) {
      _userSubject.sink.add(_userSubject.value);
      return _userSubject.value;
    }
    var resp = new UserResponse(null, "", 0, "");
    _userSubject.sink.add(resp);
    return resp;
  }

  Future<void> removeToken() async {
    await HttpClient.removeToken();
  }

  bool _isDisposed = false;

  dispose() {
    _userSubject.close();
    _adminsSubject.close();
    _userStatus.close();
    _token.close();
    _image.close();
    _isDisposed = true;
  }

  void drainStream() {
    _userSubject.isClosed ? null : _userSubject.drain(null);
    _adminsSubject.isClosed ? null : _adminsSubject.drain(null);
    _userStatus.isClosed ? null : _userStatus.drain(null);
    _token.isClosed ? null : _token.drain(null);
  }

  BehaviorSubject<UserResponse> get userSubject => _userSubject;
  BehaviorSubject<UserListResponse> get adminsSubject => _adminsSubject;

  BehaviorSubject<String> get token => _token;

  BehaviorSubject<bool> get userStatus => _userStatus;

  BehaviorSubject<File> get image => _image;

  void updateUser() async {
    UserResponse resp = await _repository.getUser();
    if (_isDisposed) {
      return;
    }

    if (resp.data != null) {
      FirestoreHelper.updateUser(resp.data);
      _userSubject.sink.add(resp);
    }
  }

  Future<UserResponse> editUser(User user) async {
    UserResponse response = await _repository.editUser(user);

    if (_isDisposed) {
      return null;
    }

    if (response.data != null) {
      _userSubject.sink.add(response);
      FirestoreHelper.updateUser(response.data);
    }

    return response;
  }

  Future<UserListResponse> getAdmin() async {
    UserListResponse response = await _repository.getAdmin();

    if (_isDisposed) {
      return null;
    }

    if (response.data != null) {
      _adminsSubject.sink.add(response);
    }

    return response;
  }

  void getToken() async {
    var t = await _storage.read(key: 'token') ?? null;
    _token.sink.add(t);
  }

  void getImage() async {
    var t = await _repository.getImage();

    // if (_image.isClosed) {
    //   return;
    // }
    _image.sink.add(t);
  }

  Future<bool> logout() async {
    streamSub?.cancel();
    await _repository.logout();
    _userSubject.sink.add(null);

    messagesBloc.drainStream();
    await FirestoreHelper.logout();
    return true;
  }

  Future<UserResponse> googleLogin(GoogleSignInAccount acc) async {
    UserResponse resp = await _repository.googleLogin(acc);
    _userSubject.sink.add(resp);

    return resp;
  }

  Future<UserResponse> facebookLogin(Map<String, dynamic> acc) async {
    UserResponse resp = await _repository.facebookLogin(acc);
    _userSubject.sink.add(resp);

    return resp;
  }

  Future<RegisterResponse> register(String username, String password, String name, String email) async {
    return _repository.register(username, password, name, email);
  }

  Future<UserResponse> verify(String otp, email) async {
    UserResponse resp = await _repository.verify(otp, email);
    _userSubject.sink.add(resp);

    return resp;
  }

  Future<RegisterResponse> resendOtp(email) async {
    return await _repository.resendOtp(email);
  }

  Future<RegisterResponse> resetPassword(String email) async {
    return await _repository.resetPassword(email);
  }

  Future<RegisterResponse> setNewPassword(String email, String password, otp) async {
    return await _repository.setNewPassword(email, password, otp);
  }

  Future<void> initUserStream() async {
    String email = await HttpClient.getEmail();
    if (email != null) {
      streamSub = fbUserCollections.doc(email).snapshots().listen((event) {
        if (event.exists) {
          _userSubject.sink.add(UserResponse.fromJson(event.data(), 0));
        }
      });
    }
  }
}

final userBloc = UserBloc();
