import 'package:bloom/Animation/slide_left_rout.dart';
import 'package:bloom/AppTheme/theme.dart';
import 'package:bloom/data/entity/vendor.entity.dart';
import 'package:bloom/data/repository/vendor.repository.dart';
import 'package:bloom/pages/order_payment/delivery_address.dart';
import 'package:bloom/pages/product/product.cart.dart';
import 'package:bloom/pages/product/product_details.dart';
import 'package:bloom/widget/cart.widget.dart';
import 'package:flutter/material.dart';
import '../wishlist.dart';

class ProductPage extends StatefulWidget {
  final Products product;

  ProductPage({Key key, this.product}) : super(key: key);

  @override
  _ProductPageState createState() => _ProductPageState();
}

class _ProductPageState extends State<ProductPage> {
  bool favourite = false;
  int cartItem = 3;

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.product.name,
          style: TextStyle(
            color: AppColors.themeDark,
          ),
        ),
        titleSpacing: 0.0,
        backgroundColor: AppColors.primaryColor,
        iconTheme: IconThemeData(color: AppColors.themeDark),
        actions: <Widget>[
          IconButton(
            icon: Icon(
              Icons.favorite,
              color: AppColors.themeDark,
            ),
            onPressed: () {
              Navigator.push(context, SlideLeftRoute(page: WishlistPage()));
            },
          ),
          CartNotification(),
        ],
      ),
      backgroundColor: const Color(0xFFF1F3F6),
      body: ProductDetails(data: widget.product),
      bottomNavigationBar: Material(
        elevation: 5.0,
        child: Container(
          color: Colors.white,
          width: width,
          child: InkWell(
                onTap: () {
                  Navigator.push(context, SlideLeftRoute(page: ProductCartPage(product: widget.product,)));
                },
                child: Container(
                  width: width / 2,
                  height: 50.0,
                  color: Theme.of(context).primaryColorLight,
                  alignment: Alignment.center,
                  child: Text(
                    'Add To Cart',
                    style: TextStyle(color: Colors.black, fontSize: 15.0),
                  ),
                ),
              ),
        ),
      ),
    );
  }
}
