import 'dart:io';
import 'dart:ui';
import 'package:bloom/AppTheme/theme.dart';
import 'package:bloom/pages/admin/categories.dart';
import 'package:bloom/pages/messages/message.home.dart';
import 'package:bloom/pages/profile/my_account.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import 'dashboard.dart';

class AdminContainer extends StatefulWidget {
  final int page;

  AdminContainer(this.page);
  @override
  _AdminContainerState createState() => _AdminContainerState();
}

class _AdminContainerState extends State<AdminContainer> {
  int activeTabNumber = 3;
  DateTime currentBackPressTime;

  changeTab(int i) {
    setState(() {
      activeTabNumber = i;
    });
  }

  @override
  void initState() {
    super.initState();
    setState(() {
      activeTabNumber = widget.page;
    });
    activeTabNumber = widget.page;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: Material(
        elevation: 2.0,
        shadowColor: AppColors.primaryColor,
        // backgroundColor: AppColors.primaryColor,

        child: Container(
          height: 60.0,
          width: double.infinity,
          decoration: BoxDecoration(
            color: AppColors.primaryColor,
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              InkWell(
                onTap: () {
                  if (activeTabNumber != 1) {
                    changeTab(1);
                  }
                },
                splashColor: Colors.transparent,
                highlightColor: Colors.transparent,
                child: bottomBarItem(
                    1, activeTabNumber, FontAwesomeIcons.comments, 'Messages'),
              ),
              InkWell(
                onTap: () {
                  if (activeTabNumber != 2) {
                    changeTab(2);
                  }
                },
                splashColor: Colors.transparent,
                highlightColor: Colors.transparent,
                child: bottomBarItem(2, activeTabNumber,
                    Icons.list_alt, 'Categories'),
              ),
              InkWell(
                onTap: () {
                  if (activeTabNumber != 3) {
                    changeTab(3);
                  }
                },
                splashColor: Colors.transparent,
                highlightColor: Colors.transparent,
                child: bottomBarItem(3, activeTabNumber, Icons.home, 'Dashboard'),
              ),
              InkWell(
                onTap: () {
                  if (activeTabNumber != 4) {
                    changeTab(4);
                  }
                },
                splashColor: Colors.transparent,
                highlightColor: Colors.transparent,
                child: bottomBarItem(
                    4, activeTabNumber, Icons.shopping_bag, 'Vendors'),
              ),
              InkWell(
                onTap: () {
                  if (activeTabNumber != 5) {
                    changeTab(5);
                  }
                },
                splashColor: Colors.transparent,
                highlightColor: Colors.transparent,
                child: bottomBarItem(5, activeTabNumber, Icons.person, 'Profile'),
              ),
            ],
          ),
        ),
      ),
      body: (activeTabNumber == 1)
          ? MessageHome()
          : (activeTabNumber == 2)
          ? CategoryScreen()
          : (activeTabNumber == 3)
          ? Dashboard()
          : (activeTabNumber == 4)
          ? Dashboard()
          : MyAccount(),
    );
  }

  bottomBarItem(tabNumber, activeIndex, icon, title) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Icon(
          icon,
          size: 30.0,
          color: (activeIndex == tabNumber) ? AppColors.themeRed : AppColors.black,
        ),
        SizedBox(height: 5.0),
        Text(
          title,
          style: TextStyle(
            fontSize: 10.0,
            color: (activeIndex == tabNumber) ? AppColors.themeRed : AppColors.black,
          ),
        ),
      ],
    );
  }

  onWillPop() {
    DateTime now = DateTime.now();
    if (currentBackPressTime == null ||
        now.difference(currentBackPressTime) > Duration(seconds: 2)) {
      currentBackPressTime = now;
      Fluttertoast.showToast(
        msg: 'Press Back Once Again to Exit.',
        backgroundColor: Colors.black,
        textColor: AppColors.white,
      );
      return false;
    } else {
      return true;
    }
  }
}
