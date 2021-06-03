import 'dart:async';
import 'dart:io';
import 'dart:ui';

import 'package:bloom/Animation/fadeup.dart';
import 'package:bloom/AppTheme/theme.dart';
import 'package:bloom/bloc/messages.bloc.dart';
import 'package:bloom/data/entity/admin.entity.dart';
import 'package:bloom/helpers/helper.dart';
import 'package:bloom/pages/messages/message.home.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:fluttercontactpicker/fluttercontactpicker.dart';
import 'package:firebase_storage/firebase_storage.dart' as FileStorage;
import 'package:intl/intl.dart';
import 'package:path/path.dart';
import 'package:mime/mime.dart';
import 'package:uuid/uuid.dart';

class MessageScreen extends StatefulWidget {
  final String name;
  final String email;
  final String imagePath;
  final User user;
  final List<String> to;

  MessageScreen({Key key, @required this.name, @required this.user, @required this.email, @required this.imagePath, @required this.to})
      : super(key: key);
  @override
  _MessageScreenState createState() => _MessageScreenState();
}

class _MessageScreenState extends State<MessageScreen> {
  final msgController = TextEditingController();
  DateTime now = DateTime.now();
  ScrollController _scrollController = new ScrollController();
  String amPm;

  FileStorage.UploadTask uploadTask;
  String _fileStatus;
  String _uploadProgress;
  List<Map<String, dynamic>> chatData;

  @override
  void initState() {
    super.initState();
    messagesBloc.chatSubject.listen((value) {
      if (!mounted) {
        return;
      }

      setState(() {
        chatData = value;
      });
    });

    messagesBloc.getChats(widget.to);
    _scrollToBottom();
  }

  void _scrollToBottom() {
    if (_scrollController.hasClients) {
      _scrollController.animateTo(0.0,
          duration: Duration(milliseconds: 300), curve: Curves.elasticOut);
    } else {
      Timer(Duration(milliseconds: 400), () => _scrollToBottom());
    }
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    return Stack(
      children: <Widget>[
        Container(
          width: width,
          height: height,
          decoration: BoxDecoration(
            color: AppColors.grey,
          ),
        ),
        BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 6.0, sigmaY: 6.0),
          child: Container(
            width: width,
            height: height,
            decoration: BoxDecoration(
              color: Colors.grey.shade200.withOpacity(0.1),
            ),
            child: Scaffold(
              backgroundColor: Colors.transparent,
              appBar: AppBar(
                backgroundColor: AppColors.primaryColor,
                elevation: 0.0,
                leading: IconButton(
                  icon: Icon(Icons.arrow_back_ios, color: AppColors.white),
                  onPressed: () {
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) => MessageHome()));
                  },
                ),
                titleSpacing: 0.0,
                title: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    InkWell(
                      onTap: () {
                        // Navigator.push(
                        //   context,
                        //   MaterialPageRoute(
                        //     builder: (context) => Profile(
                        //       userName: widget.name,
                        //       userImage: widget.imagePath,
                        //     ),
                        //   ),
                        // );
                      },
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: <Widget>[
                          Container(
                            height: 45.0,
                            width: 45.0,
                            alignment: Alignment.topRight,
                            padding: EdgeInsets.all(10),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(22.5),
                              image: DecorationImage(
                                image: widget.name == 'Bloom Admin' ? AssetImage('assets/bloom.png') : NetworkImage(widget.imagePath),
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                          SizedBox(width: 10,),
                          Column(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Text(
                                widget.name,
                                style: TextStyle(
                                  color: AppColors.white,
                                  fontFamily: 'Rubik',
                                  fontSize: 16.0,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                              Text(
                                'Online',
                                style: TextStyle(
                                  color: AppColors.white,
                                  fontFamily: 'Rubik',
                                  fontSize: 13.0,
                                  fontWeight: FontWeight.w300,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              body: body(context),
            ),
          ),
        ),
      ],
    );
  }

  body(BuildContext context) {
    return Container(
        padding: EdgeInsets.only(bottom: 0.0),
        child: StreamBuilder<List<Map<String, dynamic>>>(
          stream: messagesBloc.chatSubject.stream,
          builder: (context, AsyncSnapshot<List<Map<String, dynamic>>> snapshot) {
            if (!snapshot.hasData) {
              return Center(
                  child: SpinKitCircle(color: AppColors.primaryColor,)
              );
            } else  {
              return _buildListWidget(snapshot.data, context);
            }
          },
        )
    );
  }

  // Bottom Sheet for Attach Here
  void _attachBottomSheet(context, width) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (BuildContext bc) {
        return Container(
          width: width,
          color: Colors.transparent,
          margin: EdgeInsets.all(10),
          child: Container(
            padding: EdgeInsets.all(10 * 3.0),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10.0),
              color: AppColors.white,
            ),
            child: Wrap(
              children: <Widget>[
                Column(
                  children: <Widget>[
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
                        getAttachTile(
                            Colors.blue,
                            Icon(Icons.note_add, size: 24.0, color: AppColors.white),
                            'Document', context),
                        getAttachTile(
                            Colors.red,
                            Icon(Icons.photo, size: 24.0, color: AppColors.themeDark),
                            'Gallery', context),
                        getAttachTile(
                            Colors.indigo,
                            Icon(Icons.person, size: 24.0, color: AppColors.themeDark),
                            'Contact', context),
                      ],
                    ),
                    SizedBox(height: 20,),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }
  // Bottom Sheet for Attach Ends Here

  getAttachTile(Color color, Icon icon, String title, BuildContext context) {
    return InkWell(
      onTap: () {
        if (title == 'Contact') {
          _selectContact(context);
        }
      },
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Container(
            width: 60.0,
            height: 60.0,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(30.0),
              color: color,
            ),
            child: icon,
          ),
          SizedBox(height: 10,),
          Text(
            title,
            style: TextStyle(
              color: AppColors.secondaryColor,
              fontFamily: 'Rubik',
              fontSize: 13.0,
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _selectContact(BuildContext context) async {

    bool perm = await ContactPickerPlatform.instance.requestPermission(force: false);
    print('Perm: $perm');
    if (perm) {
      final FullContact contact = await FlutterContactPicker.pickFullContact();
      Navigator.pop(context);
      _sendContact(context, contact);
    }
  }

  Map<String, dynamic> constructMsg(String message, FullContact contact, File file, bool image) {
    
    Map<String, dynamic> from = {
      'name': widget.user.name,
      'email': widget.user.email,
      'avatar': widget.user.avatar,
    };

    if (widget.to.contains('admin@bloomstore.com')) {
      from['email'] = 'admin@bloomstore.com';
    }

    Map<String, dynamic> fileData;
    Map<String, dynamic> contactData;

    if (file != null) {
      var uuid = Uuid();
      fileData = {
        'name': basename(file.path),
        'type': lookupMimeType(file.path),
        'ref': uuid.v4() + '-' + basename(file.path)
      };
      
      uploadFile(fileData, file);
    }

    if (contact != null) {
      contactData = {
        'name': contact.name.nickName,
        'email': contact.emails,
        'phone': contact.phones,
      };
    }

    DateFormat dateFormat = DateFormat("yyyy-MM-dd HH:mm:ss");

    Map<String, dynamic> data = {
      'message': message,
      'type': contact == null ? file == null ? !image ? 'message' : 'image' : 'doc' : 'contact',
      'from': from,
      'sender': from['email'],
      'date': dateFormat.format(DateTime.now()),
      'to': widget.to,
      'file': fileData,
      'contact': contactData,
      'read': false
    };

    return data;
  }

  void uploadFile(Map<String, dynamic> fileData, File file) async {
    uploadTask = FileStorage.FirebaseStorage.instance
        .ref('uploads/' + fileData['ref'])
        .putFile(file);

    uploadTask.snapshotEvents.listen((FileStorage.TaskSnapshot snapshot) {
      setState(() {
        _uploadProgress = '${(snapshot.bytesTransferred / snapshot.totalBytes) * 100} %';
      });
    }, onError: (e) {
      setState(() {
        _fileStatus = e.toString();
      });
    });

    // We can still optionally use the Future alongside the stream.
    try {
      await uploadTask;
      setState(() {
        _fileStatus = 'complete';
      });
    } on FileStorage.FirebaseException catch (e) {
      setState(() {
        _fileStatus = e.message;
      });
    }
  }

  void pauseFile() async {
    // Pause the upload.
    bool paused = await uploadTask?.pause();

    if (paused) {
      setState(() {
        _fileStatus = 'paused';
      });
    }
  }

  void resumeFile() async {
    bool resume = await uploadTask?.resume();

    if (resume) {
      setState(() {
        _fileStatus = 'uploading';
      });
    }
  }

  void cancelFileUpload() async {
    bool paused = await uploadTask?.cancel();

    if (paused) {
      setState(() {
        _fileStatus = 'canceled';
      });
    }
  }

  void _sendContact(BuildContext context, FullContact contact) {
    messagesBloc.sendMessage(constructMsg('', contact, null, false));
  }

  void _sendMessage(BuildContext context, String message) {
    messagesBloc.sendMessage(constructMsg(message, null, null, false));
  }

  void _uploadFile(File file, bool image) async {
    messagesBloc.sendMessage(constructMsg('', null, file, image));
  }

  _buildListWidget(List<Map<String, dynamic>> data, BuildContext context) {
    double width = MediaQuery.of(context).size.width;

    return Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Expanded(
              child: ListView(
                controller: _scrollController,
                reverse: true,
                physics: BouncingScrollPhysics(),
                children: [
                  for (Map<String,dynamic> contact in data) _renderChat(context, contact),
                ]
            ),
          ),
          FadeUp(
            -10.0,
            Container(
              width: width,
              height: 70.0,
              padding: EdgeInsets.all(10.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  InkWell(
                    borderRadius: BorderRadius.circular(20.0),
                    onTap: () => {}, // _attachBottomSheet(context, width),
                    child: Container(
                      width: 40.0,
                      height: 40.0,
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20.0),
                        color: Colors.white.withOpacity(0.3),
                      ),
                      child: Icon(
                        Icons.attach_file,
                        color: AppColors.themeDark,
                        size: 18.0,
                      ),
                    ),
                  ),
                  SizedBox(width: 10,),
                  Container(
                    width: width - 120.0,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10.0),
                      color: AppColors.themeDark.withOpacity(0.1),
                    ),
                    child: TextField(
                      controller: msgController,
                      style: TextStyle(
                        fontSize: 13.0,
                        color: AppColors.themeDark,
                      ),
                      decoration: InputDecoration(
                        hintText: 'Type a Message',
                        hintStyle: TextStyle(
                          fontSize: 13.0,
                          color: AppColors.black,
                        ),
                        contentPadding: EdgeInsets.only(left: 10.0),
                        border: InputBorder.none,
                      ),
                    ),
                  ),
                  SizedBox(width: 10,),
                  InkWell(
                    borderRadius: BorderRadius.circular(20.0),
                    onTap: () {
                      if (msgController.text != '') {
                        _sendMessage(context, msgController.text);
                        setState(() {
                          msgController.text = '';
                          _scrollController.animateTo(
                            0.0,
                            curve: Curves.easeOut,
                            duration: const Duration(milliseconds: 300),
                          );
                        });
                      }
                    },
                    child: Container(
                      width: 40.0,
                      height: 40.0,
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20.0),
                        color: Colors.white.withOpacity(0.3),
                      ),
                      child: Icon(
                        Icons.send,
                        color: AppColors.themeDark,
                        size: 18.0,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
    );
  }

  Widget _renderChat(BuildContext context, Map<String, dynamic> item) {
    double width = MediaQuery.of(context).size.width;
    return Container(
                width: width,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: (item['from']['email'] == widget.user.email || (item['from']['email'] == 'admin@bloomstore.com' && widget.user.isAdmin))
                      ? CrossAxisAlignment.end
                      : CrossAxisAlignment.start,
                  children: <Widget>[
                    Wrap(
                      children: <Widget>[
                        Padding(
                          padding: (item['from']['email'] == widget.user.email || (item['from']['email'] == 'admin@bloomstore.com' && widget.user.isAdmin))
                              ? EdgeInsets.only(left: 100.0)
                              : EdgeInsets.only(right: 100.0),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: (item['from']['email'] == widget.user.email || (item['from']['email'] == 'admin@bloomstore.com' && widget.user.isAdmin))
                                ? CrossAxisAlignment.end
                                : CrossAxisAlignment.start,
                            children: <Widget>[
                              (item['type'] == 'message')
                                  ? Container(
                                padding: EdgeInsets.all(10.0),
                                margin: EdgeInsets.only(
                                    left: 10.0, right: 10.0),
                                decoration: BoxDecoration(
                                  borderRadius:
                                  BorderRadius.circular(5.0),
                                  color: (item['from']['email'] == widget.user.email || (item['from']['email'] == 'admin@bloomstore.com' && widget.user.isAdmin))
                                      ? AppColors.primaryColor
                                      : AppColors.secondaryColor,
                                ),
                                child: Text(
                                  item['message'],
                                  style: TextStyle(
                                    color: AppColors.white,
                                    fontSize: 15.0,
                                  ),
                                ),
                              )
                                  : !(item['from']['email'] == widget.user.email || (item['from']['email'] == 'admin@bloomstore.com' && widget.user.isAdmin))
                                  ? InkWell(
                                      onTap: () {
                                        //   Navigator.push(
                                        //       context,
                                        //       MaterialPageRoute(
                                        //           builder: (context) =>
                                        //               FullScreenImage(
                                        //                 imagePath:
                                        //                 item['image'],
                                        //               )));
                                      },
                                      child: Hero(
                                        tag: item['file']['name'],
                                        child: Container(
                                          width: 150.0,
                                          height: 150.0,
                                          margin: EdgeInsets.only(
                                              left: 10.0, right: 10.0),
                                          decoration: BoxDecoration(
                                            borderRadius: BorderRadius.circular(5.0),
                                            border: Border.all(
                                                width: 2.0,
                                                color: AppColors.white),
                                            image: DecorationImage(
                                              image:
                                              NetworkImage(item['file']['url']),
                                              fit: BoxFit.cover,
                                            ),
                                          ),
                                        ),
                                      ),
                                    )
                                  : Container(
                                padding: EdgeInsets.all(10.0),
                                margin: EdgeInsets.only(
                                    left: 10.0, right: 10.0),
                                decoration: BoxDecoration(
                                  borderRadius:
                                  BorderRadius.circular(5.0),
                                  color: !(item['from']['email'] == widget.user.email || (item['from']['email'] == 'admin@bloomstore.com' && widget.user.isAdmin))
                                      ? Colors.white
                                      : AppColors.primaryColor,
                                ),
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  mainAxisAlignment:
                                  !(item['from']['email'] == widget.user.email || (item['from']['email'] == 'admin@bloomstore.com' && widget.user.isAdmin))
                                      ? MainAxisAlignment.start
                                      : MainAxisAlignment.end,
                                  crossAxisAlignment:
                                  CrossAxisAlignment.center,
                                  children: <Widget>[
                                    Icon(
                                      Icons.group_add,
                                      color: AppColors.themeDark,
                                    ),
                                    SizedBox(width: 10.0),
                                    Container(
                                      height: 8.0,
                                      width: 0.7,
                                      color:
                                      !(item['from']['email'] == widget.user.email || (item['from']['email'] == 'admin@bloomstore.com' && widget.user.isAdmin))
                                          ? AppColors.primaryColor
                                          : AppColors.secondaryColor,
                                    ),
                                    SizedBox(width: 10.0),
                                    Text(
                                      item['name'],
                                      style: TextStyle(
                                        color: AppColors.white,
                                        fontSize: 15.0,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Padding(
                                padding: EdgeInsets.all(10.0),
                                child: Row(
                                  mainAxisAlignment: !(item['from']['email'] == widget.user.email || (item['from']['email'] == 'admin@bloomstore.com' && widget.user.isAdmin))
                                      ? MainAxisAlignment.start
                                      : MainAxisAlignment.end,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: <Widget>[
                                    !(item['from']['email'] == widget.user.email || (item['from']['email'] == 'admin@bloomstore.com' && widget.user.isAdmin))
                                        ? Container()
                                        : Icon(
                                      (item['read'])
                                          ? Icons.done_all
                                          : Icons.check,
                                      color: AppColors.themeDark,
                                      size: 16.0,
                                    ),
                                    SizedBox(
                                      width: 7.0,
                                    ),
                                    Text(
                                      DateFormatter.stringToTimeAgo(item['date']),
                                      style: TextStyle(
                                        color: AppColors.themeDark,
                                        fontSize: 12.0,
                                        fontWeight: FontWeight.w400,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              );
  }
}


