import 'admin.entity.dart';

class Person {
  int id;
  User user;
  String lastName;
  String firstName;
  String name;
  String nin;
  String birthdate;
  String phone;
  String gender;
  String nameorder;
  List<Address> addresses;

  Person(
      {this.id,
        this.user,
        this.lastName,
        this.firstName,
        this.name,
        this.birthdate,
        this.phone,
        this.addresses,
        this.nin,
        this.gender,
        this.nameorder});

  Person.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    user = json['user'] != null ? new User.fromJson(json['user']) : null;
    nin = json['nin'];
    nameorder = json['nameorder'];
    lastName = json['lastname'];
    firstName = json['firstname'];
    name = json['name'];
    birthdate = json['birthdate'];
    phone = json['phone'];
    gender = json['gender'];
    if (json['addresses'] != null) {
      addresses = <Address>[];
      json['addresses'].forEach((v) {
        addresses.add(new Address.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    if (this.user != null) {
      data['user'] = this.user.toJson();
    }
    data['nin'] = this.nin;
    data['name'] = this.name;
    data['lastname'] = this.lastName;
    data['firstname'] = this.firstName;
    data['birthdate'] = this.birthdate;
    data['phone'] = this.phone;
    data['gender'] = this.gender;
    data['nameorder'] = this.nameorder;
    this.addresses != null ? data['addresses'] = this.addresses.map((v) => v.toJson()).toList() : null;

    return data;
  }
}

class Address {
  int id;
  Person person;
  String address;
  String type;
  String name;
  Country country;
  String province;
  String city;
  String postalcode;

  Address(
      {this.id,
        this.person,
        this.address,
        this.type,
        this.name,
        this.country,
        this.province,
        this.city,
        this.postalcode});

  Address.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    person = json['person'] != null ? new Person.fromJson(json['person']) : null;
    country = json['country'] != null ? new Country.fromJson(json['country']) : null;
    province = json['province'];
    address = json['address'];
    type = json['type'];
    name = json['name'];
    city = json['city'];
    postalcode = json['postalcode'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    if (this.person != null) {
      data['person'] = this.person.toJson();
    }
    if (this.country != null) {
      data['country'] = this.country.toJson();
    }
    data['province'] = this.province;
    data['name'] = this.name;
    data['type'] = this.type;
    data['address'] = this.address;
    data['city'] = this.city;
    data['postalcode'] = this.postalcode;
    return data;
  }
}

class Country {
  int id;
  String name;
  int phonecode;

  Country(
      {this.id,
        this.name,
        this.phonecode});

  Country.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    phonecode = json['phonecode'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    data['phonecode'] = this.phonecode;
    return data;
  }

  bool operator ==(dynamic other) =>
      other != null && other is Country && this.id == other.id;

  @override
  int get hashCode => super.hashCode;
}

class Province {
  int id;
  Country country;
  String code;
  String name;
  String type;

  Province(
      {this.id,
        this.country,
        this.code,
        this.type,
        this.name});

  Province.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    country = json['country'] != null ? new Country.fromJson(json['country']) : null;
    code = json['code'];
    type = json['type'];
    name = json['name'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    if (this.country != null) {
      data['country'] = this.country.toJson();
    }
    data['name'] = this.name;
    data['type'] = this.type;
    data['code'] = this.code;
    return data;
  }
}

class Passport {
  int id;
  String createdAt;
  String updatedAt;
  String createdBy;
  String lastModifiedBy;
  String name;
  String tag;
  String fileType;
  String link;
  int objID;
  String editorName;
  String editorUsername;

  Passport(
      {this.id,
        this.createdAt,
        this.updatedAt,
        this.createdBy,
        this.lastModifiedBy,
        this.name,
        this.tag,
        this.fileType,
        this.link,
        this.objID,
        this.editorName,
        this.editorUsername});

  Passport.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
    createdBy = json['createdBy'];
    lastModifiedBy = json['lastModifiedBy'];
    name = json['name'];
    tag = json['tag'];
    fileType = json['fileType'];
    link = json['link'];
    // objID = json['objID'];
    editorName = json['editorName'];
    editorUsername = json['editorUsername'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['createdAt'] = this.createdAt;
    data['updatedAt'] = this.updatedAt;
    data['createdBy'] = this.createdBy;
    data['lastModifiedBy'] = this.lastModifiedBy;
    data['name'] = this.name;
    data['tag'] = this.tag;
    data['fileType'] = this.fileType;
    data['link'] = this.link;
    data['objID'] = this.objID;
    data['editorName'] = this.editorName;
    data['editorUsername'] = this.editorUsername;
    return data;
  }
}





