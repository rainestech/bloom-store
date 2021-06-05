import 'dart:ui';
import 'package:bloom/AppTheme/theme.dart';
import 'package:bloom/bloc/person.bloc.dart';
import 'package:bloom/data/http/persons.provider.dart';
import 'package:bloom/helpers/no.login.dart';
import 'package:bloom/pages/messages/message.home.dart';
import 'package:bloom/pages/vendors/products/ads.dart';
import 'package:bloom/pages/vendors/products/products.dart';
import 'package:bloom/pages/vendors/profile/shop.profile.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import 'dashboard.dart';

class VendorContainer extends StatefulWidget {
  final int page;

  VendorContainer(this.page);
  @override
  _VendorContainerState createState() => _VendorContainerState();
}

class _VendorContainerState extends State<VendorContainer> with WidgetsBindingObserver {
  int activeTabNumber = 3;
  DateTime currentBackPressTime;
  PersonResponse _personResponse;

  changeTab(int i) {
    setState(() {
      activeTabNumber = i;
    });
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      personBloc.me();
      // personBloc.personResponse.listen((value) {
      //   if(!mounted) {
      //     return;
      //   }
      //
      //   setState(() {
      //     _personResponse = value;
      //   });
      // });
    }
  }

  @override
  void initState() {
    super.initState();
    setState(() {
      activeTabNumber = widget.page;
    });
    activeTabNumber = widget.page;

    personBloc.me();
    personBloc.personResponse.listen((value) {
      if(!mounted) {
        return;
      }

      setState(() {
        _personResponse = value;
      });
    });
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
                child: bottomBarItem(1, activeTabNumber, Icons.home, 'Dashboard'),
              ),
              InkWell(
                onTap: () {
                  if (activeTabNumber != 2) {
                    changeTab(2);
                  }
                },
                splashColor: Colors.transparent,
                highlightColor: Colors.transparent,
                child: bottomBarItem(
                    2, activeTabNumber, FontAwesomeIcons.comments, 'Messages'),
              ),
              InkWell(
                onTap: () {
                  if (activeTabNumber != 3) {
                    changeTab(3);
                  }
                },
                splashColor: Colors.transparent,
                highlightColor: Colors.transparent,
                child: bottomBarItem(3, activeTabNumber,
                    Icons.list_alt, 'Products'),
              ),
              InkWell(
                onTap: () {
                  if (activeTabNumber != 3) {
                    changeTab(5);
                  }
                },
                splashColor: Colors.transparent,
                highlightColor: Colors.transparent,
                child: bottomBarItem(5, activeTabNumber,
                    FontAwesomeIcons.ad, 'Ads'),
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
                    4, activeTabNumber, Icons.shopping_bag, 'Shop Profile'),
              ),
            ],
          ),
        ),
      ),
      body: (_personResponse == null) ? Center( child: SpinKitCircle(color: AppColors.primaryColor))
          : _personResponse.data == null ? NoProfileWidget() :
      (activeTabNumber == 1)
          ? Dashboard()
          : (activeTabNumber == 2)
          ? MessageHome()
          : (activeTabNumber == 3)
          ? ProductScreen()
          : (activeTabNumber == 4)
          ? ShopProfileScreen()
          : (activeTabNumber == 5)
          ? AdsScreen()
          : Dashboard(),
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
