
import 'package:bloom/data/entity/personnel.entity.dart';
import 'package:bloom/data/http/persons.provider.dart';
import 'package:bloom/data/repository/person.repository.dart';
import 'package:dio/dio.dart';
import 'package:rxdart/rxdart.dart';

class PersonBloc {
  final PersonRepository _personRepository = PersonRepository();

  final BehaviorSubject<PersonResponse> _personSubject =
      BehaviorSubject<PersonResponse>();

  final BehaviorSubject<PassportResponse> _passportSubject =
      BehaviorSubject<PassportResponse>();

  final BehaviorSubject<PassportListResponse> _passportListSubject =
      BehaviorSubject<PassportListResponse>();

  Future<PersonResponse> savePerson(Person person) async {
    PersonResponse response = await _personRepository.save(person);
    _personSubject.sink.add(response);

    return response;
  }

  Future<PersonResponse> editPerson(Person person) async {
    PersonResponse response = await _personRepository.edit(person);
    _personSubject.sink.add(response);

    return response;
  }

  Future<PersonResponse> me() async {
    PersonResponse response = await _personRepository.me();
    _personSubject.sink.add(response);

    return response;
  }

  Future<PassportResponse> savePassport(FormData formData) async {
    PassportResponse response = await _personRepository.savePassport(formData);
    _passportSubject.sink.add(response);
    return response;
  }

  Future<PassportListResponse> saveMultipleFiles(FormData formData) async {
    PassportListResponse response = await _personRepository.saveMultipleFle(formData);
    _passportListSubject.sink.add(response);
    return response;
  }

  Future<PassportResponse> editPassport(FormData formData) async {
    PassportResponse response = await _personRepository.editPassport(formData);
    _passportSubject.sink.add(response);
    return response;
  }

  Future<PersonResponse> deletePerson(Person person) async {
    PersonResponse response = await _personRepository.delete(person);
    _personSubject.drain(null);

    // if (_vendorListSubject.hasValue) {
    //   List<Vendor> vendors = _vendorListSubject.value.data;
    //   if (vendors != null) {
    //     _vendorListSubject.sink.add(new VendorListResponse(vendors.where((e) => e.id != vendor.id).toList(), "", ""));
    //   }
    // }

    return response;
  }

  bool _isDisposed = false;

  dispose() {
    _personSubject.close();
    _passportSubject.close();
    _passportListSubject.close();
    _isDisposed = true;
  }

  void drainStream() {
    _personSubject.isClosed ? null : _personSubject.drain(null);
    _passportSubject.isClosed ? null : _passportSubject.drain(null);
    _passportListSubject.isClosed ? null : _passportListSubject.drain(null);
  }

  BehaviorSubject<PersonResponse> get personResponse => _personSubject;
  BehaviorSubject<PassportResponse> get passportSubject => _passportSubject;
  BehaviorSubject<PassportListResponse> get passportListSubject => _passportListSubject;
}

final personBloc = PersonBloc();
