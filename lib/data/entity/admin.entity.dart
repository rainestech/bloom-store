import 'package:bloom/data/entity/personnel.entity.dart';

class User {
  int id;
  String name;
  String email;
  String username;
  bool status;
  bool isVendor;
  bool isAdmin;
  String createdAt;
  String updatedAt;
  String deletedOn;
  Passport passport;
  String avatar;
  String gToken;

  User(
      {this.id,
        this.email,
        this.username,
        this.status,
        this.isAdmin,
        this.isVendor,
        this.createdAt,
        this.updatedAt,
        this.deletedOn,
        this.passport,
        this.avatar,
        this.gToken,
        this.name});

  User.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    avatar = json['avatar'];
    email = json['email'];
    username = json['username'];
    status = json['status'];
    isAdmin = json['isAdmin'];
    isVendor = json['isVendor'];
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
    deletedOn = json['deletedOn'];
    gToken = json['gToken'];
    if (json['passport'] != null) {
      passport = new Passport.fromJson(json['passport']);
    }
    name = json['name'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['avatar'] = this.avatar;
    data['email'] = this.email;
    data['username'] = this.username;
    data['status'] = this.status;
    data['isAdmin'] = this.isAdmin;
    data['isVendor'] = this.isVendor;
    data['createdAt'] = this.createdAt;
    data['updatedAt'] = this.updatedAt;
    data['deletedOn'] = this.deletedOn;
    data['passport'] = this.passport == null ? null : this.passport.toJson();
    // data['gToken'] = this.gToken;
    data['name'] = this.name;
    return data;
  }
}