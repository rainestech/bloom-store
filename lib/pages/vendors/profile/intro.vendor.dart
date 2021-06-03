import 'dart:math';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:bloom/AppTheme/theme.dart';
import 'package:bloom/bloc/user.bloc.dart';
import 'package:bloom/pages/vendors/profile/edit.vendor.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class VendorIntro extends StatefulWidget {
  @override
  _VendorIntroState createState() => _VendorIntroState();
}

class _VendorIntroState extends State<VendorIntro> {
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
              borderRadius: BorderRadius.circular(20.0),
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
                  tag: Text("Intro Hero ${rng.nextInt(1000)}"),
                  child: Container(
                    height: 200.0,
                    width: width - 20,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(20.0),
                          topRight: Radius.circular(20.0),
                        ),
                        image: DecorationImage(
                          image: AssetImage('assets/image_v1.png'),
                          fit: BoxFit.cover,
                        )),
                  ),
                ),
                Container(
                  padding: EdgeInsets.all(10.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Center(
                        child: AutoSizeText(
                          'Make money selling at Bloom',
                          textAlign: TextAlign.center,
                          maxLines: 1,
                          style: TextStyle(
                            color: AppColors.themeDark,
                            fontSize: 20.0,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      SizedBox(height: 20.0),
                      Center(
                        child: AutoSizeText(
                                        'Why Us?',
                                        style: TextStyle(
                                          color: AppColors.themeRed,
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          Container(
            margin: EdgeInsets.all(10.0),
            decoration: BoxDecoration(
              color: Colors.grey[100],
              borderRadius: BorderRadius.circular(20.0),
              boxShadow: <BoxShadow>[
                BoxShadow(
                  blurRadius: 2.5,
                  spreadRadius: 1.5,
                  color: Colors.grey[300],
                ),
              ],
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Container(
                  width: 100.0,
                  height: 100.0,
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      image: AssetImage('assets/image_v2.png'),
                      fit: BoxFit.cover,
                    ),
                    borderRadius: BorderRadius.circular(35.0),
                  ),
                ),
                Container(
                  width: width - 140.0,
                  child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Padding(
                          padding: const EdgeInsets.only(
                              top: 8.0, bottom: 4.0, right: 8.0, left: 8.0),
                          child: AutoSizeText(
                            '1. List your items for free',
                            maxLines: 1,
                            style: TextStyle(
                              color: AppColors.themeDark,
                              fontSize: 18.0,
                              fontWeight: FontWeight.bold,
                              letterSpacing: 0.7,
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(
                              top: 8.0, bottom: 4.0, right: 8.0, left: 8.0),
                          child: AutoSizeText(
                            'You can upload upto 20 items for free. You\'ll only pay for any optional upgrades you choose, and only 2% of the final value fee when your item is sold',
                            textAlign: TextAlign.justify,
                            style: TextStyle(
                              color: AppColors.themeDark,
                              fontSize: 14.0,
                              letterSpacing: 0.7,
                            ),
                          ),
                        ),
                      ],
                  ),
                ),
              ],
            ),
          ),
          Container(
            margin: EdgeInsets.all(10.0),
            decoration: BoxDecoration(
              color: Colors.grey[100],
              borderRadius: BorderRadius.circular(20.0),
              boxShadow: <BoxShadow>[
                BoxShadow(
                  blurRadius: 2.5,
                  spreadRadius: 1.5,
                  color: Colors.grey[300],
                ),
              ],
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Container(
                  width: width - 140.0,
                  child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Padding(
                          padding: const EdgeInsets.only(
                              top: 8.0, bottom: 4.0, right: 8.0, left: 8.0),
                          child: AutoSizeText(
                            '2. Sell with ease',
                            maxLines: 1,
                            style: TextStyle(
                              color: AppColors.themeDark,
                              fontSize: 18.0,
                              fontWeight: FontWeight.bold,
                              letterSpacing: 0.7,
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(
                              top: 8.0, bottom: 4.0, right: 8.0, left: 8.0),
                          child: AutoSizeText(
                            'As you list, you\'ll also update your items, add description, price and post your item to your customer.',
                            textAlign: TextAlign.justify,
                            style: TextStyle(
                              color: AppColors.themeDark,
                              fontSize: 14.0,
                              letterSpacing: 0.7,
                            ),
                          ),
                        ),
                      ],
                  ),
                ),
                Container(
                  width: 100.0,
                  height: 100.0,
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      image: AssetImage('assets/image_v3.png'),
                      fit: BoxFit.cover,
                    ),
                    borderRadius: BorderRadius.circular(35.0),
                  ),
                ),
              ],
            ),
          ),
          Container(
            margin: EdgeInsets.all(10.0),
            decoration: BoxDecoration(
              color: Colors.grey[100],
              borderRadius: BorderRadius.circular(20.0),
              boxShadow: <BoxShadow>[
                BoxShadow(
                  blurRadius: 2.5,
                  spreadRadius: 1.5,
                  color: Colors.grey[300],
                ),
              ],
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Container(
                  width: 100.0,
                  height: 100.0,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(35.0),
                  ),
                  child: Icon(FontAwesomeIcons.whatsapp, color: AppColors.secondaryColor, size: 100,),
                ),
                Container(
                  width: width - 140.0,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Padding(
                        padding: const EdgeInsets.only(
                            top: 8.0, bottom: 4.0, right: 8.0, left: 8.0),
                        child: AutoSizeText(
                          '3. We\'ve got your back',
                          maxLines: 1,
                          style: TextStyle(
                            color: AppColors.themeDark,
                            fontSize: 18.0,
                            fontWeight: FontWeight.bold,
                            letterSpacing: 0.7,
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(
                            top: 8.0, bottom: 4.0, right: 8.0, left: 8.0),
                        child: AutoSizeText(
                          'As a seller on Bloom you\'re protected by policies, mpnitoring and a 24/7 customer service team',
                          textAlign: TextAlign.justify,
                          style: TextStyle(
                            color: AppColors.themeDark,
                            fontSize: 14.0,
                            letterSpacing: 0.7,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          InkWell(
            onTap: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) =>
                          EditVendorPage(vendor: null))).then((value) => {
              userBloc.updateUser()
              });
            },
            child: Container(
              width: width,
              alignment: Alignment.center,
              margin: EdgeInsets.all(10.0),
              padding: EdgeInsets.all(15.0),
              decoration: BoxDecoration(
                  color: AppColors.themeDark,
                  borderRadius:
                  BorderRadius.circular(5.0)),
              child: Text(
                'Get Started',
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
    );
  }
}
