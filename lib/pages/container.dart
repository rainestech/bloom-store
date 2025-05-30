import 'dart:io';
import 'package:bloom/AppTheme/theme.dart';
import 'package:bloom/bloc/person.bloc.dart';
import 'package:bloom/bloc/user.bloc.dart';
import 'package:bloom/data/entity/personnel.entity.dart';
import 'package:bloom/pages/category/top_offers_pages/deals.products.dart';
import 'package:bloom/pages/messages/message.home.dart';
import 'package:bloom/pages/profile/my_account.dart';
import 'package:bloom/pages/vendors/vendors.container.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import 'home.dart';

class ScreenContainer extends StatefulWidget {
  final int page;

  ScreenContainer(this.page);
  @override
  _ScreenContainerState createState() => _ScreenContainerState();
}

class _ScreenContainerState extends State<ScreenContainer> {
  int activeTabNumber = 3;
  DateTime currentBackPressTime;
  Person _person;

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

    personBloc.me();
    personBloc.personResponse.listen((value) {
      if (!mounted) return;

      setState(() {
        _person = value.data;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      child: Scaffold(
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
                if(_person != null)
                InkWell(
                  onTap: () {
                    Navigator.push(context, MaterialPageRoute(
                                builder: (context) =>
                                    VendorContainer(4))).then((value) => {
                                      userBloc.updateUser()
                        });
                  },
                  splashColor: Colors.transparent,
                  highlightColor: Colors.transparent,
                  child: bottomBarItem(2, activeTabNumber,
                      Icons.account_balance_wallet, 'Sell'),
                ),
                InkWell(
                  onTap: () {
                    if (activeTabNumber != 3) {
                      changeTab(3);
                    }
                  },
                  splashColor: Colors.transparent,
                  highlightColor: Colors.transparent,
                  child: bottomBarItem(3, activeTabNumber, Icons.home, 'Home'),
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
                      4, activeTabNumber, Icons.list, 'Deals'),
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
                ? Home()
                : (activeTabNumber == 3)
                    ? Home()
                    : (activeTabNumber == 4)
                        ? DealsProducts()
                        : MyAccount(),
      ),
      onWillPop: () async {
        bool backStatus = onWillPop();
        if (backStatus) {
          exit(0);
        }
        return false;
      },
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
