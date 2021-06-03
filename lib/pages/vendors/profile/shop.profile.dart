import 'dart:ui';

import 'package:bloom/AppTheme/theme.dart';
import 'package:bloom/bloc/user.bloc.dart';
import 'package:bloom/bloc/vendor.bloc.dart';
import 'package:bloom/data/entity/admin.entity.dart';
import 'package:bloom/data/entity/vendor.entity.dart';
import 'package:bloom/data/http/endpoints.dart';
import 'package:bloom/helpers/no.login.dart';
import 'package:bloom/pages/home_page_component/drawer.dart';
import 'package:bloom/pages/vendors/profile/intro.vendor.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../auth/login.dart';
import 'edit.vendor.dart';

class ShopProfileScreen extends StatefulWidget {
  @override
  _ShopProfileScreenState createState() => _ShopProfileScreenState();
}

class _ShopProfileScreenState extends State<ShopProfileScreen> with WidgetsBindingObserver {
  DateTime currentBackPressTime;
  User _user = new User();
  Vendor _vendor;

  @override
  void initState() {
    super.initState();

    userBloc.userSubject.listen((value) {
      if (!mounted) {
        return;
      }

      if (value != null && value.data != null) {
        setState(() {
          _user = value.data;
        });
      }
    });

    vendorBloc.vendorSubject.listen((value) {
      if (!mounted) {
        return;
      }

      setState(() {
        _vendor = value.data;
      });
    });

    userBloc.getUser();
    vendorBloc.myShop();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      userBloc.updateUser();
    }
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    var textTheme = Theme.of(context).textTheme;

    return Scaffold(
        backgroundColor: const Color(0xFFF1F3F6),
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
                        image: _vendor == null ? AssetImage('assets/bloom.png') : NetworkImage(fsDlEndpoint + _vendor.logo.link),
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                ),
          ),
          title: Text(
            _vendor == null ? 'Bloom Store' : _vendor.name,
            style: textTheme.headline1,
          ),
          titleSpacing: 0.0,
          backgroundColor: AppColors.primaryColor,
          iconTheme: IconThemeData(color: AppColors.themeDark),
          actions: <Widget>[

          ],
        ),

        // Drawer Code Start Here

        drawer: MainDrawer(),

        // Drawer Code End Here
        body: _user.id == null ? Center(
          child: SpinKitChasingDots(
            itemBuilder: (BuildContext context, int index) {
              return DecoratedBox(
                decoration: BoxDecoration(
                  color: index.isEven ? AppColors.primaryColor : AppColors.secondaryColor,
                ),
              );
            },
          ),
        ) : _user == null ? NoLoginWidget() : !_user.isVendor ? VendorIntro() :
        ListView(
        shrinkWrap: true,
        children: <Widget>[
          Container(
            width: width,
            height: 150.0,
            decoration: BoxDecoration(
              image: DecorationImage(
                  image: _vendor == null ? AssetImage('assets/user_profile/background.jpg'): NetworkImage(fsDlEndpoint + _vendor.logo.link),
                    fit: BoxFit.cover,
                  )
              ),
            child: Stack(
              children: <Widget>[
                BackdropFilter(
                  filter: ImageFilter.blur(sigmaX: 0.8, sigmaY: 0.9),
                  child: Container(
                    color: Colors.black.withOpacity(0.7),
                  ),
                ),

                Positioned(
                    top: 10.0,
                    width: width,
                    child: Column(
                      children: <Widget>[
                        if (_vendor != null)
                          Padding(
                            padding: EdgeInsets.only(top: 20.0),
                            child: Text(
                              _vendor.name,
                              style: TextStyle(
                                  fontSize: 20.0, fontWeight: FontWeight.bold, color: AppColors.secondaryColor),
                            ),
                          ),
                      ],
                    ),
                ),

                if (_vendor != null)
                  Positioned(
                    bottom: 10.0,
                    width: width,
                    child: Center(
                      child: InkWell(
                        child: Container(
                          width: width/2,
                          alignment: Alignment.center,
                          padding: EdgeInsets.all(10.0),
                          decoration: BoxDecoration(
                            color: Colors.amber,
                            borderRadius: BorderRadius.all(Radius.circular(10)),
                            border: Border.all(color: AppColors.themeRed, style: BorderStyle.solid)
                          ),
                            child: Text(
                              'Edit Shop Profile',
                              style: TextStyle(
                                  fontSize: 14.0, fontWeight: FontWeight.bold, color: AppColors.themeDark),
                            ),
                          ),
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) =>
                                    EditVendorPage(vendor: _vendor))).then((value) => {
                          userBloc.updateUser()
                        });
                      },
                    ),
                    ),
                ),
              ],
            ),
          ),

          if (_vendor != null)
          Container(
            padding: EdgeInsets.all(16.0),
            child: Html(
              data: _vendor.description,
            ),
          ),

          // Padding(
          //   padding: EdgeInsets.only(right: 30.0, left: 70.0),
          //   child: Divider(
          //     height: 1.0,
          //   ),
          // ),

          if (_vendor != null && (_vendor.facebook != null || _vendor.twitter != null || _vendor.instagram != null))
            Container(
              padding: EdgeInsets.all(16.0),
              child: Text('Follow us on:'),
            ),


          if (_vendor != null && _vendor.facebook != null)
            InkWell(
            onTap: () {
              _launchURL(_vendor.facebook);
            },
            child: Container(
                padding: EdgeInsets.all(16.0),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    Icon(
                      FontAwesomeIcons.facebook,
                      size: 30.0,
                      color: Colors.blue,
                    ),
                    SizedBox(
                      width: 25,
                    ),
                    Text(
                      'Facebook',
                      style: TextStyle(fontSize: 20.0),
                    )
                  ],
                ),
              ),
            ),

          if (_vendor != null && _vendor.twitter != null)
            InkWell(
            onTap: () {
              _launchURL(_vendor.twitter);
            },
            child: Container(
                padding: EdgeInsets.all(16.0),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    Icon(
                      FontAwesomeIcons.twitter,
                      size: 30.0,
                      color: Colors.lightBlueAccent,
                    ),
                    SizedBox(
                      width: 25,
                    ),
                    Text(
                      'Twitter',
                      style: TextStyle(fontSize: 20.0),
                    )
                  ],
                ),
              ),
            ),

          if (_vendor != null && _vendor.instagram != null)
            InkWell(
            onTap: () {
              _launchURL(_vendor.instagram);
            },
            child: Container(
                padding: EdgeInsets.all(16.0),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    Icon(
                      FontAwesomeIcons.instagram,
                      size: 30.0,
                      color: Colors.brown,
                    ),
                    SizedBox(
                      width: 25,
                    ),
                    Text(
                      'Instagram',
                      style: TextStyle(fontSize: 20.0),
                    )
                  ],
                ),
              ),
            ),

        ],
      ),
    );
  }

  void _showToast() {
    Fluttertoast.showToast(msg: 'Not Implemented Yet', backgroundColor: Colors.black);
  }

  void _logout() async {
    EasyLoading.show(status: 'login you in...', maskType: EasyLoadingMaskType.black);
    await userBloc.logout();
    EasyLoading.dismiss();
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (BuildContext context) => Login('profile'),
      ),
    );
  }

  void _launchURL(url) async =>
      await canLaunch(url) ? await launch(url) : Fluttertoast.showToast(msg: "Can not launch url");

}
