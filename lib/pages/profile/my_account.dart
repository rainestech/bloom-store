import 'package:bloom/Animation/slide_left_rout.dart';
import 'package:bloom/AppTheme/theme.dart';
import 'package:bloom/bloc/person.bloc.dart';
import 'package:bloom/bloc/user.bloc.dart';
import 'package:bloom/data/entity/admin.entity.dart';
import 'package:bloom/data/entity/personnel.entity.dart';
import 'package:bloom/data/http/endpoints.dart';
import 'package:bloom/pages/faq_and_about_app/about.dart';
import 'package:bloom/pages/faq_and_about_app/contact.dart';
import 'package:bloom/pages/faq_and_about_app/legal.dart';
import 'package:bloom/pages/home_page_component/drawer.dart';
import 'package:bloom/pages/order_payment/delivery_address.dart';
import 'package:bloom/pages/order_payment/my_orders.dart';
import 'package:bloom/pages/wishlist.dart';
import 'package:bloom/widget/cart.widget.dart';
import 'package:bloom/widget/notification.widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:share_plus/share_plus.dart';

import '../auth/login.dart';
import '../search.dart';
import 'edit_profile.dart';

class MyAccount extends StatefulWidget {
  @override
  _MyAccountState createState() => _MyAccountState();
}

class _MyAccountState extends State<MyAccount> with WidgetsBindingObserver {
  DateTime currentBackPressTime;
  User _user;
  bool _dataReturned = false;
  Person person = Person();
  Address _address;

  @override
  void initState() {
    super.initState();
    userBloc.getUser();
    personBloc.me();

    personBloc.personResponse.listen((value) {
      if(!mounted)
        return;

      if (value.data != null) {
        person = value.data;
      }
      _address = (person.addresses != null && person.addresses.length > 0) ? person.addresses.firstWhere((e) => e.type == 'shipping') : null;
    });

    userBloc.userSubject.listen((value) {
      if (!mounted) {
        return;
      }
      setState(() {
        _dataReturned = true;
      });
      if (value != null && value.data != null) {
        setState(() {
          _user = value.data;
        });
      }
    });
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
                        image: AssetImage('assets/bloom.png'),
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                ),
          ),
          title: Text(
            'Bloom',
            style: textTheme.headline1,
          ),
          titleSpacing: 0.0,
          backgroundColor: AppColors.primaryColor,
          iconTheme: IconThemeData(color: AppColors.themeDark),
          actions: <Widget>[
            IconButton(
              icon: Icon(Icons.search),
              color: AppColors.themeDark,
              onPressed: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => SearchPage()));
              },
            ),
            NotificationWidget(),
            CartNotification(),
          ],
        ),

        // Drawer Code Start Here

        drawer: MainDrawer(),

        // Drawer Code End Here
        body: ListView(
        shrinkWrap: true,
        children: <Widget>[
          Container(
            width: width,
            height: 260.0,
            child: Stack(
              children: <Widget>[
                Image(
                  image: AssetImage('assets/user_profile/background.jpg'),
                  width: width,
                  height: 150.0,
                  fit: BoxFit.cover,
                ),
                  Positioned(
                  top: 90.0,
                  width: width,
                  child: Center(
                    child: !_dataReturned ?
                        SpinKitCircle(color: AppColors.primaryColor,)
                        : Column(
                      children: <Widget>[
                        Container(
                          height: 110.0,
                          width: 110.0,
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(55.0),
                            border: Border.all(color: Colors.white, width: 5.0),
                          ),
                          child: ClipRRect(
                            borderRadius: new BorderRadius.circular(50.0),
                            child:

                            Image(
                              image:
                              _user != null && _user.passport != null ?
                              NetworkImage(fsDlEndpoint + _user.passport.link) : _user != null && _user.passport == null && _user.avatar != null ?
                              NetworkImage(_user.avatar) : AssetImage('assets/user_profile/blank.png'),
                              height: 100.0,
                              width: 100.0,
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                        if (_user != null)
                          Padding(
                            padding: EdgeInsets.only(top: 8.0),
                            child: Text(
                              _user.name,
                              style: TextStyle(
                                  fontSize: 20.0, fontWeight: FontWeight.bold),
                            ),
                          ),
                        if (_user != null)
                          Padding(
                            padding: EdgeInsets.only(top: 8.0),
                            child: InkWell(
                              child: Text(
                                'Edit Profile',
                                style:
                                TextStyle(fontSize: 16.0, color: Colors.grey),
                              ),
                              onTap: () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) =>
                                            EditProfile())).then((value) => {
                                              userBloc.updateUser()
                                });
                              },
                            ),
                          ),
                        if (_user == null)
                          Padding(
                            padding: EdgeInsets.only(top: 8.0),
                            child: InkWell(
                              child: Text(
                                'Login',
                                style:
                                TextStyle(fontSize: 16.0, color: Colors.red),
                              ),
                              onTap: () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) =>
                                            Login('profile')));
                              },
                            ),
                          ),
                      ],
                    ),
                  )
                ),
              ],
            ),
          ),

          if (_user != null)
            InkWell(
            onTap: () {
              Navigator.push(context, SlideLeftRoute(page: MyOrders()));
            },
            child: Container(
              padding: EdgeInsets.all(16.0),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Icon(
                    FontAwesomeIcons.truck,
                    size: 30.0,
                    color: Theme.of(context).primaryColor,
                  ),
                  SizedBox(
                    width: 25,
                  ),
                  Text(
                    'My Orders',
                    style: TextStyle(fontSize: 20.0),
                  )
                ],
              ),
            ),
          ),
          if (_user != null)
            Padding(
            padding: EdgeInsets.only(right: 30.0, left: 70.0),
            child: Divider(
              height: 1.0,
            ),
          ),

          if (_user != null)
          InkWell(
            onTap: () {
              Navigator.push(context, SlideLeftRoute(page: WishlistPage()));
            },
            child: Container(
              padding: EdgeInsets.all(16.0),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Icon(
                    FontAwesomeIcons.heart,
                    size: 30.0,
                    color: Theme.of(context).primaryColor,
                  ),
                  SizedBox(
                    width: 25,
                  ),
                  Text(
                    'My Favorites',
                    style: TextStyle(fontSize: 20.0),
                  )
                ],
              ),
            ),
          ),

          if (_user != null)
            Padding(
            padding: EdgeInsets.only(right: 30.0, left: 70.0),
            child: Divider(
              height: 1.0,
            ),
          ),
          InkWell(
            onTap: () {
              Share.share('check out Bloom Store on google play https://playstore.com', subject: 'Bloom Store!');
            },
            child: Container(
              padding: EdgeInsets.all(16.0),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Icon(
                    FontAwesomeIcons.share,
                    size: 30.0,
                    color: Theme.of(context).primaryColor,
                  ),
                  SizedBox(
                    width: 25,
                  ),
                  Text(
                    'Invite Friends',
                    style: TextStyle(fontSize: 20.0),
                  )
                ],
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.only(right: 30.0, left: 70.0),
            child: Divider(
              height: 1.0,
            ),
          ),

          if (_user != null)
            InkWell(
            onTap: () {
              Navigator.push(context, SlideLeftRoute(page: Delivery(cart: null, address: _address, person: person,)));
            },
            child: Container(
              padding: EdgeInsets.all(16.0),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Icon(
                    FontAwesomeIcons.cogs,
                    size: 30.0,
                    color: Theme.of(context).primaryColor,
                  ),
                  SizedBox(
                    width: 25,
                  ),
                  Text(
                    'Settings',
                    style: TextStyle(fontSize: 20.0),
                  )
                ],
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.only(right: 30.0, left: 70.0),
            child: Divider(
              height: 1.0,
            ),
          ),

          InkWell(
            onTap: () {
              _showToast();
              Navigator.push(context, SlideLeftRoute(page: AboutUsPage()));
            },
            child: Container(
              padding: EdgeInsets.all(16.0),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Icon(
                    FontAwesomeIcons.questionCircle,
                    size: 30.0,
                    color: Theme.of(context).primaryColor,
                  ),
                  SizedBox(
                    width: 25,
                  ),
                  Text(
                    'About Us',
                    style: TextStyle(fontSize: 20.0),
                  )
                ],
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.only(right: 30.0, left: 70.0),
            child: Divider(
              height: 1.0,
            ),
          ),

          InkWell(
            onTap: () {
              Navigator.push(context, SlideLeftRoute(page: LegalPage()));
            },
            child: Container(
              padding: EdgeInsets.all(16.0),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Icon(
                    FontAwesomeIcons.info,
                    size: 30.0,
                    color: Theme.of(context).primaryColor,
                  ),
                  SizedBox(
                    width: 25,
                  ),
                  Text(
                    'Legal Information',
                    style: TextStyle(fontSize: 20.0),
                  )
                ],
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.only(right: 30.0, left: 70.0),
            child: Divider(
              height: 1.0,
            ),
          ),

          InkWell(
            onTap: () {
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => ContactPage()));
            },
            child: Container(
              padding: EdgeInsets.all(16.0),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Icon(
                    FontAwesomeIcons.handsHelping,
                    size: 30.0,
                    color: Theme.of(context).primaryColor,
                  ),
                  SizedBox(
                    width: 25,
                  ),
                  Text(
                    'Help Center',
                    style: TextStyle(fontSize: 20.0),
                  )
                ],
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.only(right: 30.0, left: 70.0),
            child: Divider(
              height: 1.0,
            ),
          ),

          if (_user != null)
          InkWell(
            onTap: () {
              _logout();
            },
            child: Container(
              padding: EdgeInsets.all(16.0),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Icon(
                    FontAwesomeIcons.signOutAlt,
                    size: 30.0,
                    color: AppColors.themeRed,
                  ),
                  SizedBox(
                    width: 25,
                  ),
                  Text(
                    'Logout',
                    style: TextStyle(fontSize: 20.0, color: Colors.red),
                  )
                ],
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.only(right: 30.0, left: 70.0),
            child: Divider(
              height: 1.0,
            ),
          ),
        ],
      ),
    );
  }

   // onWillPop() {
  //   DateTime now = DateTime.now();
  //   if (currentBackPressTime == null ||
  //       now.difference(currentBackPressTime) > Duration(seconds: 2)) {
  //     currentBackPressTime = now;
  //     Fluttertoast.showToast(
  //       msg: 'Press Back Once Again to Exit.',
  //       backgroundColor: Colors.black,
  //       textColor: Colors.white,
  //     );
  //     return false;
  //   } else {
  //     return true;
  //   }
  // }

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
}
