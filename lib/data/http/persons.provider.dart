import 'dart:convert';

import 'package:bloom/data/entity/personnel.entity.dart';
import 'package:bloom/data/http/http.client.dart';
import 'package:dio/dio.dart';
import 'endpoints.dart';

class PersonResponse {
  final Person data;
  final String error;
  final String eTitle;

  PersonResponse(this.data, this.error, this.eTitle);

  PersonResponse.fromJson(resp)
      : data = new Person.fromJson(resp),
        error = "",
        eTitle = "";

  PersonResponse.withError(String msg, title)
      : data = null,
        error = msg,
        eTitle = title;
}

class PassportResponse {
  final Passport data;
  final String error;
  final String eTitle;

  PassportResponse(this.data, this.error, this.eTitle);

  PassportResponse.fromJson(resp)
      : data = new Passport.fromJson(resp),
        error = "",
        eTitle = "";

  PassportResponse.withError(String msg, title)
      : data = null,
        error = msg,
        eTitle = title;
}

class PassportListResponse {
  final List<Passport> data;
  final String error;
  final String eTitle;

  PassportListResponse(this.data, this.error, this.eTitle);

  PassportListResponse.fromJson(resp)
      : data = (resp as List).map((i) => new Passport.fromJson(i)).toList(),
        error = null,
        eTitle = null;

  PassportListResponse.withError(String msg, title)
      : data = null,
        error = msg,
        eTitle = title;
}

class PersonApiProvider {
  Future<PersonResponse> me() async {
    try {
      final Dio _dio = await HttpClient.http();
      Response response = await _dio.get(personEndpoint + '/me');

      PersonResponse resp = PersonResponse.fromJson(response.data);

      return resp;
    } catch (e) {
      if (e.response != null) {
        Map<String, dynamic> error = json.decode(e.response.toString());
        return PersonResponse.withError(error['message'], error['error']);
      }
      return PersonResponse.withError(e.message, "Network Error");
    }
  }

  Future<PersonResponse> savePerson(Person person) async {
    try {
      final Dio _dio = await HttpClient.http();
      Response response = await _dio.post(personEndpoint,
          data: person.toJson());

      return PersonResponse.fromJson(response.data);
    } catch (e) {
      print(e.toString());
      if (e.response != null) {
        Map<String, dynamic> error = json.decode(e.response.toString());
        return PersonResponse.withError(error['message'], error['error']);
      }
      return PersonResponse.withError(e.message, "Network Error");
    }
  }

  Future<PersonResponse> editPerson(Person person) async {
    try {
      final Dio _dio = await HttpClient.http();
      Response response = await _dio.put(personEndpoint, data: person.toJson());

      return PersonResponse.fromJson(response.data);
    } catch (e) {
      if (e.response != null) {
        Map<String, dynamic> error = json.decode(e.response.toString());
        return PersonResponse.withError(error['message'], error['error']);
      }
      return PersonResponse.withError(e.message, "Network Error");
    }
  }

  Future<PersonResponse> deletePerson(Person person) async {
    final Dio _dio = await HttpClient.http();
    try {
      await _dio.delete(personEndpoint + '/remove/$person.id');

      return PersonResponse(person, "", "");
    } catch (e) {
      if (e.response != null) {
        Map<String, dynamic> error = json.decode(e.response.toString());
        return PersonResponse.withError(error['message'], error['error']);
      }
      return PersonResponse.withError(e.message, "Network Error");
    }
  }

  Future<PassportResponse> savePassport(FormData formData) async {
    try {
      final Dio _dio = await HttpClient.http();
      Response response = await _dio.post(storageEndpoint, data: formData);
      return PassportResponse.fromJson(response.data);
    } catch (e) {
      print(e.toString());
      if (e.response != null) {
        Map<String, dynamic> error = json.decode(e.response.toString());
        return PassportResponse.withError(error['message'], error['error']);
      }
      print(e.toString());
      return PassportResponse.withError(e.message, "Network Error");
    }
  }

  Future<PassportListResponse> saveMultipleFiles(FormData formData) async {
    try {
      final Dio _dio = await HttpClient.http();
      Response response = await _dio.post(storageEndpoint + '/multi', data: formData);
      return PassportListResponse.fromJson(response.data);
    } catch (e) {
      print(e.toString());
      if (e.response != null) {
        Map<String, dynamic> error = json.decode(e.response.toString());
        return PassportListResponse.withError(error['message'], error['error']);
      }
      print(e.toString());
      return PassportListResponse.withError(e.message, "Network Error");
    }
  }

  Future<PassportResponse> editPassport(FormData formData) async {
    try {
      final Dio _dio = await HttpClient.http();
      Response response = await _dio.post(storageEndpoint, data: formData);
      return PassportResponse.fromJson(response.data);
    } catch (e) {
      if (e.response != null) {
        Map<String, dynamic> error = json.decode(e.response.toString());
        return PassportResponse.withError(error['message'], error['error']);
      }
      print(e.toString());
      return PassportResponse.withError(e.message, "Network Error");
    }
  }
}
