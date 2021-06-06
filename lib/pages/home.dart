import 'dart:io';

import 'package:bloom/AppTheme/theme.dart';
import 'package:bloom/bloc/vendor.bloc.dart';
import 'package:bloom/data/entity/vendor.entity.dart';
import 'package:bloom/data/http/endpoints.dart';
import 'package:bloom/pages/product/product.dart';
import 'package:bloom/pages/search.dart';
import 'package:bloom/widget/cart.widget.dart';
import 'package:bloom/widget/notification.widget.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:carousel_pro/carousel_pro.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'category/top_offers_pages/get_products.dart';
import 'home_page_component/category_grid.dart';
import 'home_page_component/drawer.dart';
import 'home_page_component/top_seller_grid.dart';

class Home extends StatefulWidget {
  Home({Key key}) : super(key: key);

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home>  with WidgetsBindingObserver {
  DateTime currentBackPressTime;
  List<Ads> _ads = [];
  bool resp = false;

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      vendorBloc.getAds();
    }
  }

  @override
  void initState() {
    super.initState();
    vendorBloc.getAds();
    vendorBloc.adsListSubject.listen((value) {
      if (!mounted) return;

      setState(() {
        if (value.data != null) {
          _ads = value.data;
        }
        resp = true;
      });
    });
  }

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
                child: !resp ? SpinKitCircle(color: AppColors.secondaryColor,) : _ads.length > 0 ? CarouselSlider(
                  items: _ads.map((i) {
                    return Builder(
                      builder: (BuildContext context) {
                        return Container(
                            width: MediaQuery.of(context).size.width,
                            margin: EdgeInsets.symmetric(horizontal: 5.0),
                            decoration: BoxDecoration(color: Colors.amber),
                            child: GestureDetector(
                                child: Image.network(fsDlEndpoint + i.image.link, fit: BoxFit.fill),
                                onTap: () {
                                  if (i.product != null) {
                                    Navigator.push(context,
                                        MaterialPageRoute(builder: (context) => ProductPage(product: i.product,)));
                                  } else {
                                    Navigator.push(context,
                                        MaterialPageRoute(builder: (context) => GetProducts(category: i.category)));
                                }
                                }));
                      },
                    );
                  }).toList(),
                  options: CarouselOptions(
                    autoPlay: true,
                    autoPlayInterval: const Duration(seconds: 4),
                    autoPlayAnimationDuration: const Duration(milliseconds: 800),
                    autoPlayCurve: Curves.fastOutSlowIn,
                    viewportFraction: 1,
                  ),
                ) : Center(
                  child: Text(
                    'No Ads Posted Yet'
                  )
                )
              ),
            ),

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

  _getImageList() {
    var list = [];
    for(Ads ad in _ads) {
      list.add(NetworkImage(fsDlEndpoint + ad.image.link));
    }

    return list;
  }
}
