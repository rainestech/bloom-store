import 'dart:async';

import 'package:bloom/bloc/user.bloc.dart';
import 'package:bloom/data/entity/admin.entity.dart';
import 'package:bloom/helpers/helper.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';
import 'package:rxdart/rxdart.dart';

class MessagesBloc {
  final CollectionReference _chats = FirebaseFirestore.instance.collection('chats');
  final CollectionReference _status = FirebaseFirestore.instance.collection('status');

  final BehaviorSubject<List<Map<String, dynamic>>> _chatSubject = BehaviorSubject<List<Map<String, dynamic>>>();
  final BehaviorSubject<List<Map<String, dynamic>>> _contactSubject = BehaviorSubject<List<Map<String, dynamic>>>();
  final BehaviorSubject<List<Map<String, dynamic>>> _statusSubject = BehaviorSubject<List<Map<String, dynamic>>>();

  BehaviorSubject<List<Map<String, dynamic>>> get chatSubject => _chatSubject;
  BehaviorSubject<List<Map<String, dynamic>>> get contactSubject => _contactSubject;

  StreamSubscription<QuerySnapshot> chatStream;
  StreamSubscription<QuerySnapshot> statusStream;
  StreamSubscription<QuerySnapshot> contactStream;

  dispose() {
    _chatSubject.close();
    _contactSubject.close();
    chatStream?.cancel();
    contactStream?.cancel();
  }

  void drainStream() {
    chatStream?.cancel();
    contactStream?.cancel();
    _chatSubject.isClosed ? null : _chatSubject.drain(null);
    _contactSubject.isClosed ? null : _contactSubject.drain(null);
  }

  Null notFound() {
    return null;
  }

  Future<List<Map<String, dynamic>>> getContacts() async {
    User user = await userBloc.getUser();
    if (user == null) {
      return [];
    }

    String email = user.email;
    bool isAdmin = user.isAdmin;
    List<String> adminContact = ['admin@bloomstore.com', user.email];
    adminContact.sort((a, b) => a.toString().compareTo(b.toString()));
    List<Map<String, dynamic>> contacts = isAdmin ? [] : [{'from': {'name': 'Bloom Admin', 'email': 'admin@bloomstore.com'}, 'sender': user.email, 'to': adminContact, 'date': null}];

    if (email != null && !isAdmin) {
      chatStream = _chats.where('to', arrayContains: email).orderBy('date', descending: true).snapshots().listen((event) {
        event.docs.forEach((e) {
          try {
            if (contacts.isEmpty) {
              contacts.add(e.data());
            } else if (contacts.where((c) => c['sender'] == e['sender']).isEmpty) {
              contacts.add(e.data());
            }
          } on Exception catch (e) {
            print(e.toString());
          }
        });
        _contactSubject.sink.add(contacts);
      });
    }


    if (email != null && isAdmin) {
      chatStream = _chats.where('to', arrayContainsAny: ['admin@bloomstore.com', email]).orderBy('date', descending: true).snapshots().listen((event) {
        event.docs.forEach((e) {
          try {
            if(contacts.isEmpty) {
              contacts.add(e.data());
            } else if (contacts.firstWhere((c) => c['from']['email'] == e['from']['email'], orElse: notFound) == null) {
              contacts.add(e.data());
            }
          } on Exception catch (e) {
            print(e.toString());
          }
        });
        _contactSubject.sink.add(contacts);
      });
    }

    return contacts;
  }

  Future<List<Map<String, dynamic>>> getUsersOnline() async {
      statusStream = _status.where('status', isEqualTo: 'online').snapshots().listen((event) {
        List<Map<String, dynamic>> statuses =  [];
        event.docs.forEach((e) {
          statuses.add(e.data());
        });

        _statusSubject.sink.add(statuses);
        return statuses;
      });

    return [];
  }

  Future<void> setMyStatus(String value, String email) async {
    DateFormat dateFormat = DateFormat("yyyy-MM-dd HH:mm:ss");
    _status.doc(email).set(
      {
        'status': value,
        'email': email,
        'date': dateFormat.format(DateTime.now())
      }
    );
  }

  Future<List<Map<String, dynamic>>> getChats(List<String> to) async {
     chatStream = _chats.where('to', isEqualTo: to)
        .orderBy('date', descending: true).limit(100)
          .snapshots().listen((event) {
            List<Map<String, dynamic>> temp = [];
        event.docs.forEach((e) {
          if (!e['read']) {
            _chats.doc(e.id).update({'read': true});
            temp.add(e.data());
          } else {
            temp.add(e.data());
          }
        });

        _chatSubject.sink.add(temp);
        return temp;
      });
    return [];
  }

  Future<Map<String, dynamic>> sendMessage(Map<String, dynamic> message) async {
    await _chats.add(message).then((value) => null);
    return message;
  }
}

final messagesBloc = MessagesBloc();