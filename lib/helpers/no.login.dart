import 'package:auto_size_text/auto_size_text.dart';
import 'package:bloom/AppTheme/theme.dart';
import 'package:bloom/pages/auth/login.dart';
import 'package:bloom/pages/profile/my_account.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class NoLoginWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Icon(
            Icons.warning_amber_rounded,
            color: Colors.grey,
            size: 60.0,
          ),
          SizedBox(
            height: 20.0,
          ),
          AutoSizeText(
            'You are yet to Login',
            style: TextStyle(
              color: AppColors.themeRed,
              fontSize: 18.0,
              fontFamily: 'Signika Negative',
              fontWeight: FontWeight.w700,
            ),
          ),
          SizedBox(height: 10,),
          Container(
            width: double.infinity,
            alignment: Alignment.center,
            child: InkWell(
              onTap: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => Login('home')));
              },
              borderRadius: BorderRadius.circular(30.0),
              child: Material(
                elevation: 1.0,
                borderRadius: BorderRadius.circular(30.0),
                child: Container(
                  padding: EdgeInsets.fromLTRB(40.0, 15.0, 40.0, 15.0),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(30.0),
                    color: AppColors.themeDark,
                  ),
                  child: Text(
                    'Login Here',
                    style: TextStyle(
                      color: AppColors.white,
                      fontSize: 15.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

}
class NoProfileWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Icon(
            Icons.person_search_rounded,
            color: Colors.grey,
            size: 60.0,
          ),
          SizedBox(
            height: 20.0,
          ),
          AutoSizeText(
            'You are yet to Complete your profile!',
            style: TextStyle(
              color: AppColors.themeRed,
              fontSize: 18.0,
              fontFamily: 'Signika Negative',
              fontWeight: FontWeight.w700,
            ),
          ),
          SizedBox(height: 10,),
          Container(
            width: double.infinity,
            alignment: Alignment.center,
            child: InkWell(
              onTap: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => MyAccount()));
              },
              borderRadius: BorderRadius.circular(30.0),
              child: Material(
                elevation: 1.0,
                borderRadius: BorderRadius.circular(30.0),
                child: Container(
                  padding: EdgeInsets.fromLTRB(40.0, 15.0, 40.0, 15.0),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(30.0),
                    color: AppColors.themeDark,
                  ),
                  child: Text(
                    'Complete Profile Here',
                    style: TextStyle(
                      color: AppColors.white,
                      fontSize: 15.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

}