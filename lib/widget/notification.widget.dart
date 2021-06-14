import 'package:badges/badges.dart';
import 'package:bloom/AppTheme/theme.dart';
import 'package:bloom/bloc/vendor.bloc.dart';
import 'package:bloom/data/entity/vendor.entity.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class NotificationWidget extends StatefulWidget {
  @override
  _NotificationWidgetState createState() => _NotificationWidgetState();
}

class _NotificationWidgetState extends State<NotificationWidget> {
  List<Cart> _cart = [];

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: _cart.length > 0 ? Badge(
        badgeContent: Text(
          _cart.length.toString(),
          style: TextStyle(
            color: Colors.white,
          ),
        ),
        badgeColor: AppColors.themeRed,
        child: Icon(
          Icons.notifications,
          color: Colors.transparent, // made invincible
        ),
      ) : Icon(
        Icons.notifications,
        color: Colors.transparent, // made invincible,
      ),
      onPressed: () {
        // Navigator.push(context, SlideLeftRoute(page: CartPage()));
      },
    );
  }
}