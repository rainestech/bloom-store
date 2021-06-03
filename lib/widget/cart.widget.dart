import 'package:badges/badges.dart';
import 'package:bloom/Animation/slide_left_rout.dart';
import 'package:bloom/AppTheme/theme.dart';
import 'package:bloom/bloc/vendor.bloc.dart';
import 'package:bloom/data/entity/vendor.entity.dart';
import 'package:bloom/pages/order_payment/cart.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class CartNotification extends StatefulWidget {
  @override
  _CartNotificationState createState() => _CartNotificationState();
}

class _CartNotificationState extends State<CartNotification> {
  List<Cart> _cart = [];

  @override
  void initState() {
    super.initState();
    vendorBloc.cartListSubject.listen((value) {
      if (!mounted) {
        return;
      }

      setState(() {
        if (value.data != null) {
          _cart = value.data;
        }
      });
    });

    vendorBloc.myCart();
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
          Icons.shopping_cart,
          color: AppColors.themeDark,
        ),
      ) : Icon(
        Icons.shopping_cart,
        color: AppColors.themeDark,
      ),
      onPressed: () {
        Navigator.push(context, SlideLeftRoute(page: CartPage()));
      },
    );
  }
}