import 'package:auto_size_text/auto_size_text.dart';
import 'package:bloom/AppTheme/theme.dart';
import 'package:bloom/bloc/messages.bloc.dart';
import 'package:bloom/bloc/user.bloc.dart';
import 'package:bloom/data/http/user.dart';
import 'package:bloom/helpers/helper.dart';
import 'package:bloom/helpers/no.login.dart';
import 'package:bloom/pages/home_page_component/drawer.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

import 'chat.messages.dart';

class MessageHome extends StatefulWidget {
  @override
  _MessageHomeState createState() => _MessageHomeState();
}

class _MessageHomeState extends State<MessageHome>  with WidgetsBindingObserver {
  UserResponse _user;
  var _data;

  @override
  void initState() {
    super.initState();
    messagesBloc.getContacts();

    messagesBloc.contactSubject.listen((value) {
      if (!mounted) {
        return;
      }

      setState(() {
        if (value.isNotEmpty) {
          _data = value;
        }
      });
    });

    userBloc.userSubject.listen((value) {
      if(!mounted) {
        return;
      }

      setState(() {
        _user = value;
      });
    });

    userBloc.getUserResponse();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      messagesBloc.getContacts();
      userBloc.getUserResponse();
    }
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    var textTheme = Theme.of(context).textTheme;
    return Scaffold(
        appBar: AppBar(
        leading: Builder(
        builder: (context) =>
        InkWell(
          onTap: () => Scaffold.of(context).openDrawer(),
          child: Container(
            height: 24.0,
            width: 24.0,
            margin: EdgeInsets.all(10.0),
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/bloom.png'),
                fit: BoxFit.cover,
              ),
            ),
          ),
        ),
    ),
    title: Text(
      'Messages',
      style: textTheme.headline1.copyWith(
        fontFamily: 'Rubik',
      ),
    ),
    titleSpacing: 0.0,
    backgroundColor: AppColors.primaryColor,
    iconTheme: IconThemeData(color: AppColors.themeDark),
          actions: [
            IconButton(
              icon: Icon(Icons.search, color: AppColors.themeDark),
              onPressed: () {},
            ),
          ],
    ),

    // Drawer Code Start Here

    drawer: MainDrawer(),

    // Drawer Code End Here
    body: Container(
        padding: EdgeInsets.only(bottom: 0.0),
        child: StreamBuilder<List<Map<String, dynamic>>>(
          stream: messagesBloc.contactSubject.stream,
          builder: (context, AsyncSnapshot<List<Map<String, dynamic>>> snapshot) {
            if (_user == null && !snapshot.hasData) {
              return Center(
                  child: SpinKitChasingDots(
                    itemBuilder: (BuildContext context, int index) {
                      return DecoratedBox(
                        decoration: BoxDecoration(
                          color: index.isEven ? AppColors.primaryColor : AppColors.secondaryColor,
                        ),
                      );
                    },
                  )
              );
            } else if (_user != null && snapshot.hasData) {
              return _buildListWidget(snapshot.data);
            } else if (_user != null && _user.data == null) {
              return NoLoginWidget();
            } else {
              return _noMsgWidget();
            }
          },
        )
      )
    );
  }

  Widget _buildListWidget(List<Map<String, dynamic>> data) {
    return ListView(
      children: <Widget>[
        for (Map<String,dynamic> contact in data) _listContacts(contact),
      ],
    );
  }

  _listContacts(Map<String, dynamic> contact) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;

    return InkWell(
        onTap: () {
          List<String> to = [];
          for (String t in contact['to']) {
            to.add(t);
          }

          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => MessageScreen(
                      name: contact['from']['name'], imagePath: contact['from']['avatar'], email: contact['from']['email'], user: _user.data, to: to,)));
        },
        child: Container(
          width: width,
          height: 92.0,
          decoration: BoxDecoration(
            color: AppColors.white,
            borderRadius: BorderRadius.circular(5.0),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Padding(
                padding: EdgeInsets.all(10),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: <Widget>[
                    Hero(
                      tag: contact['to'].toString() + contact['sender'].toString() ,
                      child: InkWell(
                        onTap: () {
                          // showProfileImage(item['name'], item['image']);
                        },
                        child: Container(
                          height: 60.0,
                          width: 60.0,
                          alignment: Alignment.topRight,
                          padding: EdgeInsets.all(10),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(30.0),
                            image: DecorationImage(
                              image: contact['from']['name'] == 'Bloom Admin' ? AssetImage('assets/bloom.png') : contact['from']['avatar'] != null ? NetworkImage(contact['from']['avatar']) : AssetImage('assets/user_profile/blank.png'),
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                      ),
                    ),
                    Container(
                      width: width - ((20) + 60.0 + 30.0),
                      padding: EdgeInsets.all(10),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Text(
                                contact['from']['name'],
                                style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 16.0,
                                  fontFamily: 'Rubik',
                                  fontWeight: FontWeight.w500,
                                ),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                              SizedBox(width: 10.0),
                              if(contact['date'] != null)
                                Text(
                                DateFormatter.stringToTimeAgo(contact['date']),
                                style: TextStyle(
                                  color: Colors.grey.withOpacity(0.6),
                                  fontSize: 11.0,
                                  fontFamily: 'Rubik',
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: 10.0),
                          (contact['type'] == 'msg')
                              ? Text(
                            contact['msg'],
                            style: TextStyle(
                              color: Colors.grey,
                              fontSize: 14.0,
                              fontFamily: 'Rubik',
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          )
                              : (contact['type'] == 'file')
                              ? Row(
                            children: <Widget>[
                              Icon(
                                Icons.attach_file,
                                color: Colors.grey,
                                size: 16.0,
                              ),
                              SizedBox(width: 3.0),
                              Text(
                                'You share a file',
                                style: TextStyle(
                                  color: Colors.grey,
                                  fontSize: 14.0,
                                  fontFamily: 'Rubik',
                                ),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              )
                            ],
                          )
                              : Row(),
                        ],
                      ),
                    ),
                    (contact['msgNumber'] != null && contact['msgNumber'] != '0')
                        ? Container(
                      height: 20.0,
                      width: 20.0,
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        color: AppColors.primaryColor,
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                      child: Text(
                        contact['msgNumber'],
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 14.0,
                          fontFamily: 'Rubik',
                        ),
                      ),
                    )
                        : Container(),
                  ],
                ),
              ),
              Container(),
            ],
          ),
        ),
      );
  }

  Widget _noMsgWidget() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Icon(
            Icons.attach_email_outlined,
            color: Colors.grey,
            size: 60.0,
          ),
          SizedBox(
            height: 20.0,
          ),
          AutoSizeText(
            'You have no recent contacts',
            style: TextStyle(
              color: AppColors.themeRed,
              fontSize: 18.0,
              fontFamily: 'Signika Negative',
              fontWeight: FontWeight.w700,
            ),
          ),
          SizedBox(height: 10,),
        ],
      ),
    );
  }
}
