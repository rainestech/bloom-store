import 'dart:io';
import 'package:bloom/data/entity/admin.entity.dart';
import 'package:bloom/data/http/user.dart';
import 'package:bloom/helpers/file.upload.dart';
import 'package:bloom/data/http/http.client.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:shared_preferences/shared_preferences.dart';

class UserRepository {
  UserApiProvider _apiProvider = UserApiProvider();

  Future<UserResponse> login(String username, String password) async {
    UserResponse response = await _apiProvider.loginUser(username, password);

    // if (response.data != null) {
    //   if (response.results.image != null && response.results.image.length > 0) {
    //     try {
    //       await SaveFile().saveImage(response.results.image);
    //     } catch (e) {
    //       print('Image Get Error: ' + e.toString());
    //     }
    //   }
    // }

    return response;
  }

  Future<RegisterResponse> register(String username, String password,
      String name, String email) async {
    RegisterResponse response = await _apiProvider.register(
        username, password, name, email);

    return response;
  }

  Future<RegisterResponse> resendOtp(String email) async {
    RegisterResponse response = await _apiProvider.resendOtp(email);

    return response;
  }

  Future<RegisterResponse> resetPassword(String email) async {
    RegisterResponse response = await _apiProvider.resetPassword(email);

    return response;
  }

  Future<RegisterResponse> setNewPassword(
      String email, String password, String otp) async {
    RegisterResponse response =
        await _apiProvider.setNewPassword(email, password, otp);

    return response;
  }

  Future<UserResponse> getUser() async {
    final UserResponse response = await _apiProvider.getUser();
    if (response.data != null) {
      // saveUser(response.data);
    }
    return response;
  }
  
  Future<UserListResponse> getAdmin() async {
    final UserListResponse response = await _apiProvider.getAdmin();
    return response;
  }

  Future<UserResponse>   editUser(User user) async {
    final UserResponse response = await _apiProvider.editUser(user);
    if (response.data != null) {
      // saveUser(response.data);
    }
    return response;
  }

  Future<RegisterResponse> changePassword(
      String email, String password, String oldPassword) async {
    RegisterResponse response =
        await _apiProvider.changePassword(email, password, oldPassword);

    return response;
  }

  Future<UserResponse> verify(String otp, String email) async {
    UserResponse response = await _apiProvider.verify(otp, email);

    if (response.data != null) {
      // saveUser(response.data);

      if (response.data.avatar != null && response.data.avatar.length > 0) {
        SaveFile().saveImage(response.data.avatar);
      }
    }

    return response;
  }

  Future<UserResponse> logout() async {
    await _apiProvider.logout();
    return null;
  }

  Future<File> getImage() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String path = prefs.getString('profileImage') ?? null;

    if (path != null) {
      return File(path);
    }
    return null;
  }

  Future<UserResponse> changePasswordUsingId(
      int id, String password, String oldPassword) async {
    UserResponse response =
    await _apiProvider.changePasswordUsingId(id, password, oldPassword);

    return response;
  }

  Future<UserResponse> googleLogin(GoogleSignInAccount acc) async {
    UserResponse response = await _apiProvider.loginGoogle(acc);

    if (response.data != null) {
      if (acc.photoUrl != null) {
        SaveFile().saveImage(acc.photoUrl);
      }
    }

    return response;
  }

  Future<UserResponse> facebookLogin(Map<String, dynamic> acc) async {
    UserResponse response = await _apiProvider.loginFacebook(acc);

    if (response.data != null) {
      if (acc['photoUrl'] != null) {
        SaveFile().saveImage(acc['photoUrl']);
      }
    }

    return response;
  }

}
