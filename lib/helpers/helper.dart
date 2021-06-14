import 'package:auto_size_text/auto_size_text.dart';
import 'package:bloom/AppTheme/theme.dart';
import 'package:bloom/bloc/user.bloc.dart';
import 'package:bloom/pages/auth/login.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

void fieldFocusChange(BuildContext context, FocusNode currentNode, FocusNode nextNode) {
  currentNode.unfocus();
  FocusScope.of(context).requestFocus(nextNode);
}

final numberFormat = new NumberFormat("#,##0.00", "en_US");

class DateFormatter {
  static String stringToTimeAgo(String date) {
    return stringForDatetime(new DateFormat("yyyy-MM-dd hh:mm:ss").parse(date));
  }

  static String stringForDatetime(DateTime dt) {
    var dtInLocal = dt.toLocal();
    var now = DateTime.now().toLocal();
    var dateString = "";

    var diff = now.difference(dtInLocal);

    if (now.day == dtInLocal.day) {
      // creates format like: 12:35 PM,
      var todayFormat = DateFormat("h:mm a");
      dateString += todayFormat.format(dtInLocal);
    } else if ((diff.inDays) == 1 ||
        (diff.inSeconds < 86400 && now.day != dtInLocal.day)) {
      var yesterdayFormat = DateFormat("h:mm a");
      dateString += "Yesterday, " + yesterdayFormat.format(dtInLocal);
    } else if (now.year == dtInLocal.year && diff.inDays > 1) {
      var monthFormat = DateFormat("MMM d");
      dateString += monthFormat.format(dtInLocal);
    } else {
      var yearFormat = DateFormat("MMM d y");
      dateString += yearFormat.format(dtInLocal);
    }

    return dateString;
  }

  static DateTime stringToDate(String date) {
    return new DateFormat("yyyy-MM-dd hh:mm:ss").parse(date);
  }

  static bool dateAheadOfNow(String date) {
    if (date == null) {
      return false;
    }
    var dt = new DateFormat("yyyy-MM-dd hh:mm:ss").parse(date).toLocal();
    var now = DateTime.now().toLocal();
    return now.difference(dt).inDays < 1;
  }

  static DateTime string2ToDate(String date) {
    return DateTime.tryParse(date);
  }
}

Future<void> unAuthorizedError(BuildContext context) async {
  await userBloc.removeToken();
  await userBloc.logout();
  Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(
        builder: (context) => Login(null),
      ),
          (route) => false
  );
}

class ServerValidationDialog {
  static Future<void> errorDialog(
      BuildContext context, String msg, String title) async {
    return showDialog<void>(
        context: context,
        barrierDismissible: true,
        builder: (BuildContext context) {
          return new WillPopScope(
              onWillPop: () async => false,
              child: Dialog(
                  backgroundColor: AppColors.secondaryColor,
                  child: Container(
                    padding: EdgeInsets.all(20.0),
                    child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          AutoSizeText(
                            title == null ? '' : title,
                            style: TextStyle(
                              color: AppColors.themeDark,
                              fontWeight: FontWeight.bold,
                              fontSize: 18,
                            ),
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          AutoSizeText(
                            msg == null ? '' : msg,
                            style: TextStyle(color: AppColors.themeRed),
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          InkWell(
                            onTap: () {
                              Navigator.pop(context);
                            },
                            child: Container(
                              width: 100,
                              alignment: Alignment.center,
                              padding: EdgeInsets.all(10.0),
                              decoration: BoxDecoration(
                                color: AppColors.themeDark,
                                borderRadius: BorderRadius.circular(5.0),
                              ),
                              child: Text(
                                'Ok',
                                style: TextStyle(
                                  fontFamily: 'Signika Negative',
                                  fontWeight: FontWeight.w700,
                                  color: Colors.white
                                ),
                              ),
                            ),
                          ),
                        ]),
                  )));
        });
  }
}

class HttpErrorWidget extends StatelessWidget {
  final String error;
  final double width;
  final double height;

  HttpErrorWidget(this.error, this.width, this.height);

  @override
  Widget build(BuildContext context) {
    return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.error_outline,
              size: 50,
              color: Colors.orange,
            ),
            SizedBox(
              height: 10,
            ),
            AutoSizeText(
              error,
              textAlign: TextAlign.center,
            ),
          ],
        ));
  }
}


