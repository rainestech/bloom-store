import 'package:bloom/AppTheme/theme.dart';
import 'package:bloom/bloc/person.bloc.dart';
import 'package:bloom/bloc/user.bloc.dart';
import 'package:bloom/bloc/vendor.bloc.dart';
import 'package:bloom/data/entity/admin.entity.dart';
import 'package:bloom/data/entity/personnel.entity.dart';
import 'package:bloom/data/entity/vendor.entity.dart';
import 'package:bloom/data/http/endpoints.dart';
import 'package:bloom/pages/admin/admin.container.dart';
import 'package:bloom/pages/category/top_offers_pages/get_products.dart';
import 'package:bloom/pages/container.dart';
import 'package:bloom/pages/faq_and_about_app/contact.dart';
import 'package:bloom/pages/messages/message.home.dart';
import 'package:bloom/pages/profile/my_account.dart';
import 'package:bloom/pages/vendors/vendors.container.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';

import '../auth/login.dart';
import '../home.dart';

class MainDrawer extends StatefulWidget {
  @override
  _MainDrawerState createState() => _MainDrawerState();
}

class _MainDrawerState extends State<MainDrawer> {
  User _user;
  Person _person;

  List<Category> _categories = [];

  @override
  void initState() {
    super.initState();

    userBloc.userSubject.listen((value) {
      if (!mounted) {
        return;
      }

      if (value.data != null) {
        setState(() {
          _user = value.data;
        });
      }
    });

    personBloc.me();
    personBloc.personResponse.listen((value) {
      if (!mounted) return;

      setState(() {
        _person = value.data;
      });
    });

    userBloc.getUser();

    vendorBloc.categoryListSubject.listen((value) {
      if (!mounted) {
        return;
      }

      setState(() {
        if (value.data != null) {
          _categories = value.data;
        }
      });
    });

    vendorBloc.getCategories();
  }

  @override
  Widget build(BuildContext context) {
    // Logout AlertDialog Start Here
    void _showDialog() {
      // flutter defined function
      showDialog(
        context: context,
        builder: (BuildContext context) {
          // return object of type Dialog
          return AlertDialog(
            title: Text(
              "Confirm",
              style: TextStyle(
                fontWeight: FontWeight.bold,
              ),
            ),
            content: Text("Are you Sure you want to Logout?"),
            actions: <Widget>[
              // usually buttons at the bottom of the dialog
              TextButton(
                child: Text(
                  "Close",
                  style: TextStyle(
                    color: Theme.of(context).primaryColor,
                  ),
                ),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),

              TextButton(
                child: Text(
                  "Logout",
                  style: TextStyle(
                    color: Theme.of(context).primaryColor,
                  ),
                ),
                onPressed: () {
                  Navigator.of(context).pop();
                  Navigator.of(context).pop();
                  _logout(context);
                },
              ),
            ],
          );
        },
      );
    }
    // Logout AlertDialog Ends Here

    return Drawer(
      child: SafeArea(
        child: ListView(
          children: <Widget>[
            InkWell(
              onTap: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                    builder: (context) =>
                    ScreenContainer(3)));
              },
              child: Container(
                height: 200.0,
                decoration: BoxDecoration(
                  color: AppColors.primaryColor,
                  image: DecorationImage(
                    image: AssetImage('assets/bloom_full.png'),
                    fit: BoxFit.scaleDown,
                  ),
                ),
                // child: Padding(
                //   padding: EdgeInsets.all(20),
                //
                //   'Bloom'
                // ),
              ),
            ),

            for (Category cat in _categories)
              InkWell(
              child: Container(
                padding: EdgeInsets.only(top: 10.0, bottom: 10.0, left: 15.0),
                child: Row(
                  children: <Widget>[
                    Container(
                      height: 24.0,
                      width: 24.0,
                      decoration: BoxDecoration(
                        image: DecorationImage(
                          image: NetworkImage(fsDlEndpoint + cat.icon.link),
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                    SizedBox(
                      width: 10.0,
                    ),
                    Text(
                      cat.name,
                      style: TextStyle(
                        color: Colors.grey[700],
                        fontSize: 16.0,
                      ),
                    ),
                  ],
                ),
              ),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) =>
                          GetProducts(category: cat,)),
                );
              },
            ),
            Divider(
              color: Colors.grey,
            ),
            InkWell(
              child: Container(
                padding: EdgeInsets.only(top: 10.0, bottom: 10.0, left: 15.0),
                child: Text(
                  'Home',
                  style: TextStyle(
                    color: Colors.grey[700],
                    fontSize: 15.0,
                      fontWeight: FontWeight.w900
                  ),
                ),
              ),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => ScreenContainer(3)),
                );
              },
            ),
            InkWell(
              child: Container(
                padding: EdgeInsets.only(top: 10.0, bottom: 10.0, left: 15.0),
                child: Text(
                  'Profile',
                  style: TextStyle(
                    color: Colors.grey[700],
                    fontSize: 15.0,
                      fontWeight: FontWeight.w900
                  ),
                ),
              ),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => MyAccount()),
                );
              },
            ),
            if (_person != null)
            InkWell(
              child: Container(
                padding: EdgeInsets.only(top: 10.0, bottom: 10.0, left: 15.0),
                child: Text(
                  'Sell',
                  style: TextStyle(
                    color: Colors.grey[700],
                    fontSize: 15.0,
                      fontWeight: FontWeight.w900
                  ),
                ),
              ),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => VendorContainer(4)),
                );
              },
            ),
            if( _user != null && _user.isAdmin)
            InkWell(
              child: Container(
                padding: EdgeInsets.only(top: 10.0, bottom: 10.0, left: 15.0),
                child: Text(
                  'Admin',
                  style: TextStyle(
                    color: Colors.grey[700],
                    fontSize: 15.0,
                      fontWeight: FontWeight.w900
                  ),
                ),
              ),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => AdminContainer(3)),
                );
              },
            ),
            InkWell(
              child: Container(
                padding: EdgeInsets.only(top: 10.0, bottom: 10.0, left: 15.0),
                child: Text(
                  'Messages',
                  style: TextStyle(
                    color: Colors.grey[700],
                    fontWeight: FontWeight.w900,
                    fontSize: 15.0,
                  ),
                ),
              ),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => MessageHome()),
                );
              },
            ),

            InkWell(
              child: Container(
                padding: EdgeInsets.only(top: 10.0, bottom: 10.0, left: 15.0),
                child: Text(
                  'Contact Us',
                  style: TextStyle(
                    color: Colors.grey[700],
                    fontWeight: FontWeight.w900,
                    fontSize: 15.0,
                  ),
                ),
              ),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => ContactPage()),
                );
              },
            ),

            if (_user != null)
            InkWell(
              child: Container(
                padding: EdgeInsets.only(top: 10.0, bottom: 10.0, left: 15.0),
                child: Text(
                  'Logout',
                  style: TextStyle(
                    color: Colors.red,
                    fontSize: 15.0,
                    fontWeight: FontWeight.w900
                  ),
                ),
              ),
              onTap: () {
                _showDialog();
              },
            ),
            if (_user == null)
            InkWell(
              child: Container(
                padding: EdgeInsets.only(top: 10.0, bottom: 10.0, left: 15.0),
                child: Text(
                  'Login',
                  style: TextStyle(
                    color: AppColors.secondaryColor,
                    fontSize: 15.0,
                    fontWeight: FontWeight.w900
                  ),
                ),
              ),
              onTap: () {
                Navigator.push(context, MaterialPageRoute(builder: (context) => Login(null)));
              },
            ),
            SizedBox(
              height: 10.0,
            ),
          ],
        ),
      ),
    );
  }

  void _logout(BuildContext context) async {
    EasyLoading.show(status: 'login you in...', maskType: EasyLoadingMaskType.black);
    await userBloc.logout();
    EasyLoading.dismiss();
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (BuildContext context) => Login(null),
      ),
    );
  }
}
