import 'package:bloom/AppTheme/theme.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:url_launcher/url_launcher.dart';

class ContactPage extends StatefulWidget {
  @override
  _ContactPageState createState() => _ContactPageState();
}

class _ContactPageState extends State<ContactPage> {
  @override
  Widget build(BuildContext context) {
    double fullWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: const Color(0xFFF1F3F6),
      appBar: AppBar(
        title: Text('Contact Us',
          style: TextStyle(
            color: AppColors.themeDark,
          ),
        ),
        titleSpacing: 0.0,
        backgroundColor: AppColors.primaryColor,
        iconTheme: IconThemeData(color: AppColors.themeDark),
      ),
      body: ListView (
        children: [
          Container(
            width: fullWidth - 20.0,
            child: Card(
            elevation: 2.0,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Container(
                  width: fullWidth - 20.0,
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Container(
                        padding: const EdgeInsets.all(8.0),
                        width: 80.0,
                        height: 80.0,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20.0),
                        ),
                        child: Center(
                          child: Icon(Icons.phone, color: AppColors.secondaryColor, size: 60,),
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.all(8.0),
                        width: fullWidth - 100,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20.0),
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Text('Call On', style: TextStyle(
                              color: AppColors.themeRed,
                              fontWeight: FontWeight.bold,
                              fontSize: 24
                            ),),
                            SizedBox(height: 15,),
                            Text('+44 7983832188', style: TextStyle(
                                color: Colors.teal,
                                fontWeight: FontWeight.bold,
                                fontSize: 20
                            ),)
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          ),
          SizedBox(height: 20,),
          Container(
            width: fullWidth - 20.0,
            child: Card(
            elevation: 2.0,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Container(
                  width: fullWidth - 20.0,
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Container(
                        padding: const EdgeInsets.all(8.0),
                        width: 80.0,
                        height: 80.0,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20.0),
                        ),
                        child: Center(
                          child: Icon(Icons.mail_outline, color: AppColors.secondaryColor, size: 60,),
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.all(8.0),
                        width: fullWidth - 100,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20.0),
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Text('Reach Us by Mail', style: TextStyle(
                              color: AppColors.themeRed,
                              fontWeight: FontWeight.bold,
                              fontSize: 24
                            ),),
                            SizedBox(height: 15,),
                            Text('thebloomb310@gmail.com', style: TextStyle(
                                color: Colors.teal,
                                fontWeight: FontWeight.bold,
                                fontSize: 20
                            ),)
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          ),
          SizedBox(height: 20,),
          Container(
            width: fullWidth - 20.0,
            child: Card(
            elevation: 2.0,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Container(
                  width: fullWidth - 20.0,
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Container(
                        padding: const EdgeInsets.all(8.0),
                        width: 80.0,
                        height: 80.0,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20.0),
                        ),
                        child: Center(
                          child: Icon(Icons.message, color: AppColors.secondaryColor, size: 60,),
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.all(8.0),
                        width: fullWidth - 100,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20.0),
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Text('Complete Online Form', style: TextStyle(
                              color: AppColors.themeRed,
                              fontWeight: FontWeight.bold,
                              fontSize: 24
                            ),),
                            SizedBox(height: 15,),
                            InkWell(
                              child: Container(
                                width: fullWidth/3,
                                alignment: Alignment.center,
                                padding: EdgeInsets.all(5.0),
                                decoration: BoxDecoration(
                                    color: Colors.amber,
                                    borderRadius: BorderRadius.all(Radius.circular(10)),
                                    border: Border.all(color: AppColors.themeRed, style: BorderStyle.solid)
                                ),
                                child: Text(
                                  'Complete Form',
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                      fontSize: 14.0, fontWeight: FontWeight.bold, color: AppColors.themeDark),
                                ),
                              ),
                              onTap: () {
                                _launchURL();
                              },
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          ),
        ]
      ),
    );
  }

  void _launchURL() async =>
      await canLaunch('https://form.jotform.com/211515386106349') ? await launch('https://form.jotform.com/211515386106349') : Fluttertoast.showToast(msg: 'Can not open form at this time, try again later');
}
