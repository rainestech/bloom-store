import 'dart:math';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:bloom/AppTheme/theme.dart';
import 'package:bloom/bloc/user.bloc.dart';
import 'package:bloom/pages/vendors/profile/edit.vendor.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class VendorPlans extends StatefulWidget {
  @override
  _VendorPlansState createState() => _VendorPlansState();
}

class _VendorPlansState extends State<VendorPlans> {
  var rng = new Random();
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;

    return Container(
      padding: EdgeInsets.only(bottom: 0.0),
      child: ListView(
        shrinkWrap: true,
        children: <Widget>[
          Container(
            width: width - 20,
            margin: EdgeInsets.all(10.0),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.only(bottomLeft: Radius.circular(20.0), bottomRight: Radius.circular(20.0),),
              boxShadow: [
                BoxShadow(
                  blurRadius: 2.0,
                  spreadRadius: 1.5,
                  color: Colors.grey[300],
                )
              ],
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Hero(
                  tag: Text("Plan Hero ${rng.nextInt(1000)}"),
                  child: Container(
                    height: 200.0,
                    width: width - 20,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.zero,
                        image: DecorationImage(
                          image: AssetImage('assets/image_v5.png'),
                          fit: BoxFit.cover,
                        )),

                  ),
                ),
                Container(
                  padding: EdgeInsets.all(10.0),
                  child: Center(
                        child: AutoSizeText(
                          'Registration and Subscription',
                          textAlign: TextAlign.center,
                          maxLines: 1,
                          style: TextStyle(
                            color: AppColors.themeDark,
                            fontSize: 20.0,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                ),
              ],
            ),
          ),
          SizedBox(height: 20.0),
          Center(
            child: AutoSizeText(
              'Start Your Business today, pick a plan now or later',
              style: TextStyle(
                color: AppColors.themeRed,
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          SizedBox(height: 20.0),
          Container(
            height: 350,
            child: ListView(
              scrollDirection: Axis.horizontal,
              physics: BouncingScrollPhysics(),
              shrinkWrap: true,
              children: [
                Container(
                  width: width / 2,
                  margin: EdgeInsets.all(10.0),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.zero,
                    boxShadow: [
                      BoxShadow(
                        blurRadius: 2.0,
                        spreadRadius: 1.5,
                        color: Colors.grey[300],
                      )
                    ],
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      Text('Starter Pack',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            color: AppColors.themeDark,
                            fontSize: 20.0,
                            fontWeight: FontWeight.bold
                        ),
                      ),
                      SizedBox(height: 50.0),
                      Text(
                        'For 1 Month',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 16.0,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Divider(),
                      SizedBox(height: 10.0),
                      Text('\u2022 Open Account'),
                      SizedBox(height: 10.0),
                      Text('\u2022 Upload 15 Images'),
                      SizedBox(height: 10.0),
                      Text('\u2022 Personal Profile'),
                      Text('\u2022 Visibility Support'),
                      SizedBox(height: 10.0),
                      Text('\u2022 Free Upgrade'),
                      Divider(),
                      InkWell(
                        onTap: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) =>
                                      EditVendorPage(vendor: null, plans: 0))).then((value) => {
                            userBloc.updateUser()
                          });
                        },
                        child: Container(
                          width: width / 2,
                          alignment: Alignment.center,
                          margin: EdgeInsets.all(10.0),
                          padding: EdgeInsets.all(15.0),
                          decoration: BoxDecoration(
                              color: AppColors.themeDark,
                              borderRadius:
                              BorderRadius.circular(5.0)),
                          child: Text(
                            'Start for Free',
                            style: TextStyle(
                              fontFamily: 'Signika Negative',
                              fontSize: 18.0,
                              color: AppColors.primaryColor,
                              fontWeight: FontWeight.w700,
                              wordSpacing: 3.0,
                              letterSpacing: 0.6,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  width: width / 2,
                  margin: EdgeInsets.all(10.0),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.zero,
                    boxShadow: [
                      BoxShadow(
                        blurRadius: 2.0,
                        spreadRadius: 1.5,
                        color: Colors.grey[300],
                      )
                    ],
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      Text('Growth',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            color: AppColors.themeDark,
                            fontSize: 20.0,
                            fontWeight: FontWeight.bold
                        ),
                      ),
                      SizedBox(height: 30.0),
                      Text(
                        '6 Months Subscription \n \$85.00',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 16.0,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Divider(),
                      SizedBox(height: 10.0),
                      Text('\u2022 Order Management'),
                      SizedBox(height: 10.0),
                      Text('\u2022 Product Management'),
                      SizedBox(height: 10.0),
                      Text('\u2022 Personal Profile'),
                      Text('\u2022 Visibility Support'),
                      SizedBox(height: 10.0),
                      Text('\u2022 50 Images Monthly'),
                      Divider(),
                      InkWell(
                        onTap: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) =>
                                      EditVendorPage(vendor: null, plans: 85))).then((value) => {
                            userBloc.updateUser()
                          });
                        },
                        child: Container(
                          width: width / 2,
                          alignment: Alignment.center,
                          margin: EdgeInsets.all(10.0),
                          padding: EdgeInsets.all(15.0),
                          decoration: BoxDecoration(
                              color: AppColors.themeDark,
                              borderRadius:
                              BorderRadius.circular(5.0)),
                          child: Text(
                            'Start for Free',
                            style: TextStyle(
                              fontFamily: 'Signika Negative',
                              fontSize: 18.0,
                              color: AppColors.primaryColor,
                              fontWeight: FontWeight.w700,
                              wordSpacing: 3.0,
                              letterSpacing: 0.6,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  width: width / 2,
                  margin: EdgeInsets.all(10.0),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.zero,
                    boxShadow: [
                      BoxShadow(
                        blurRadius: 2.0,
                        spreadRadius: 1.5,
                        color: Colors.grey[300],
                      )
                    ],
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      Text('Ambitious',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            color: AppColors.themeDark,
                            fontSize: 20.0,
                            fontWeight: FontWeight.bold
                        ),
                      ),
                      SizedBox(height: 10.0),
                      Text(
                        'Annual Subscription \n \$170.00 \n 10% Discount',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 16.0,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Divider(),
                      SizedBox(height: 10.0),
                      Text('\u2022 Order Management'),
                      SizedBox(height: 10.0),
                      Text('\u2022 Product Management'),
                      SizedBox(height: 10.0),
                      Text('\u2022 Personal Profile'),
                      Text('\u2022 Visibility Support'),
                      SizedBox(height: 10.0),
                      Text('\u2022 Unlimited Products'),
                      Divider(),
                      InkWell(
                        onTap: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) =>
                                      EditVendorPage(vendor: null, plans: 170))).then((value) => {
                            userBloc.updateUser()
                          });
                        },
                        child: Container(
                          width: width / 2,
                          alignment: Alignment.center,
                          margin: EdgeInsets.all(10.0),
                          padding: EdgeInsets.all(15.0),
                          decoration: BoxDecoration(
                              color: AppColors.themeDark,
                              borderRadius:
                              BorderRadius.circular(5.0)),
                          child: Text(
                            'Start for Free',
                            style: TextStyle(
                              fontFamily: 'Signika Negative',
                              fontSize: 18.0,
                              color: AppColors.primaryColor,
                              fontWeight: FontWeight.w700,
                              wordSpacing: 3.0,
                              letterSpacing: 0.6,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

              ],
            ),
          ),
        ],
      ),
    );
  }
}
