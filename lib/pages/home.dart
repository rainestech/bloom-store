import 'dart:io';

import 'package:bloom/AppTheme/theme.dart';
import 'package:bloom/pages/search.dart';
import 'package:bloom/widget/cart.widget.dart';
import 'package:bloom/widget/notification.widget.dart';
import 'package:flutter/material.dart';
import 'package:carousel_pro/carousel_pro.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'home_page_component/category_grid.dart';
import 'home_page_component/drawer.dart';
import 'home_page_component/top_seller_grid.dart';

class Home extends StatefulWidget {
  Home({Key key}) : super(key: key);

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  DateTime currentBackPressTime;

  @override
  Widget build(BuildContext context) {
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
      body: WillPopScope(
        child: ListView(
          physics: BouncingScrollPhysics(),
          children: <Widget>[
            // Slider Code Start Here
            Container(
              child: SizedBox(
                height: 170.0,
                child: Carousel(
                  images: [
                    AssetImage('assets/slider/s1.jpg'),
                    AssetImage('assets/slider/s2.jpg'),
                    AssetImage('assets/slider/s3.jpg'),
                    AssetImage('assets/slider/s4.jpg'),
                    AssetImage('assets/slider/s5.jpg')
                  ],
                  dotSize: 4.0,
                  dotSpacing: 15.0,
                  dotColor: Colors.lightGreenAccent,
                  indicatorBgPadding: 5.0,
                  dotBgColor: Colors.purple.withOpacity(0.0),
                  boxFit: BoxFit.fill,
                  animationCurve: Curves.fastOutSlowIn,
                ),
              ),
            ),

            // Slider Code End Here

            SizedBox(
              height: 5.0,
            ),

            // Category Grid Start Here
            CategoryGrid(),

            // Category Grid End Here

            SizedBox(
              height: 5.0,
            ),

            Divider(
              height: 1.0,
            ),

            SizedBox(
              height: 4.0,
            ),

            SizedBox(
              height: 5.0,
            ),

            Divider(
              height: 1.0,
            ),

            SizedBox(
              height: 2.0,
            ),

            // // Top Seller Grid Start Here
            TopSeller(),
            // // Top Seller Grid End Here

            SizedBox(
              height: 6.0,
            ),

            Divider(
              height: 1.0,
            ),

            SizedBox(
              height: 6.0,
            ),
          ],
        ),
        onWillPop: () async {
          bool backStatus = onWillPop();
          if (backStatus) {
            exit(0);
          }
          return false;
        },
      ),
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
        textColor: Colors.white,
      );
      return false;
    } else {
      return true;
    }
  }
}
