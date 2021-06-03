import 'package:bloom/data/entity/admin.entity.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:firebase_auth/firebase_auth.dart' as FBAuth;

class FirestoreHelper {
  static FBAuth.FirebaseAuth auth;
  static FirebaseFirestore firestore;
  static FirebaseMessaging messaging;
  static CollectionReference deviceTokens;
  static CollectionReference fbUsers;

  static FBAuth.FirebaseAuth getFBAuth() {
    if (auth == null) {
      init();
    }

    return auth;
  }

  static CollectionReference getFBUsers() {
    if (fbUsers == null) {
      init();
    }

    return fbUsers;
  }

  static CollectionReference getDeviceTokens() {
    if (deviceTokens == null) {
      init();
    }

    return deviceTokens;
  }

  static void init() {
     auth = FBAuth.FirebaseAuth.instance;
    firestore = FirebaseFirestore.instance;
    messaging = FirebaseMessaging.instance;
    deviceTokens = FirebaseFirestore.instance.collection('device_tokens');
    fbUsers = FirebaseFirestore.instance.collection('app_users');
  }

  static Future<void> logout() async {
    if (auth == null) {
      init();
    }

    await auth.signOut();
  }

  static Future<void> updateUser(User user) async {
    if (fbUsers == null) {
      init();
    }

    fbUsers.doc(user.email).get()
        .then((value) => {
        fbUsers.doc(user.email).set(user.toJson())
            .then((newValue) => print("User Updated"))
            .catchError((error) => print("Failed to update User: $error"))
    });
  }

  static Future<User> currentUser() async {
    if (auth == null) {
      init();
    }

    if (auth.currentUser != null) {
      Map<String, dynamic> userMap;
      await fbUsers.doc(auth.currentUser.uid).get().then((value) => userMap = value.data());
      return User.fromJson(userMap);
    }

    return null;
  }

  static Future<void> addUserToken(User user) async {
    // Call the user's CollectionReference to add a new user

    if (auth == null) {
      init();
    }

    var token = await messaging.getToken();

    deviceTokens.doc(user.email).get()
        .then((value) => {
          if (!value.exists) {
            deviceTokens.doc(user.email).set({
              'token': token,
              'username': user.email,
            })
                .then((newValue) => print("Token Added"))
                .catchError((error) => print("Failed to add Token: $error"))
          } else {
              deviceTokens.doc(user.email).set({
                'token': token,
                'username': user.email,
              })
                  .then((newValue) => print("Token Updated"))
                  .catchError((error) => print("Failed to update Token: $error"))
            },
        }
      );

    fbUsers.doc(user.email).get()
        .then((value) => {
      if (!value.exists) {
        fbUsers.doc(user.email).set(user.toJson())
            .then((newValue) => print("User Added"))
            .catchError((error) => print("Failed to add User: $error"))
      } else {
          fbUsers.doc(user.email).set(user.toJson())
              .then((newValue) => print("User Updated"))
              .catchError((error) => print("Failed to update User: $error"))
      }
    });
  }
}

final fbAuth = FirestoreHelper.getFBAuth();
final fbUserCollections = FirestoreHelper.getFBUsers();
final fbDeviceCollections = FirestoreHelper.getDeviceTokens();