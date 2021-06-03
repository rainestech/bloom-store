import 'package:bloom/data/entity/personnel.entity.dart';
import 'package:bloom/data/http/persons.provider.dart';
import 'package:dio/dio.dart';

class PersonRepository {
  PersonApiProvider _apiProvider = PersonApiProvider();

  Future<PersonResponse> me() async {
    PersonResponse response = await _apiProvider.me();

    return response;
  }

  Future<PersonResponse> save(Person person) async {
    PersonResponse response = await _apiProvider.savePerson(person);

    return response;
  }

  Future<PersonResponse> edit(Person person) async {
    PersonResponse response = await _apiProvider.editPerson(person);

    return response;
  }

  Future<PersonResponse> delete(Person person) async {
    PersonResponse response = await _apiProvider.deletePerson(person);

    return response;
  }

  Future<PassportResponse> savePassport(FormData passport) async {
    PassportResponse response = await _apiProvider.savePassport(passport);

    return response;
  }

  Future<PassportListResponse> saveMultipleFle(FormData formData) async {
    PassportListResponse response = await _apiProvider.saveMultipleFiles(formData);

    return response;
  }

  Future<PassportResponse> editPassport(FormData passport) async {
    PassportResponse response = await _apiProvider.editPassport(passport);

    return response;
  }

}
