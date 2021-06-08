import 'dart:io';

import 'package:bloom/AppTheme/theme.dart';
import 'package:bloom/bloc/vendor.bloc.dart';
import 'package:bloom/data/entity/vendor.entity.dart';
import 'package:bloom/data/http/endpoints.dart';
import 'package:bloom/data/http/vendor.provider.dart';
import 'package:bloom/pages/container.dart';
import 'package:bloom/pages/home_page_component/drawer.dart';
import 'package:bloom/pages/product/product.dart';
import 'package:bloom/widget/cart.widget.dart';
import 'package:bloom/widget/notification.widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';

// My Own Imports
import 'package:page_transition/page_transition.dart';
import '../../home.dart';
import '../../search.dart';
import 'filter_row.dart';

class DealsProducts extends StatefulWidget {
  @override
  _DealsProductsState createState() => _DealsProductsState();
}

class _DealsProductsState extends State<DealsProducts> {
  ProductListResponse _response;
  List<Products> _data = [];
  int filterValue = 1;
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
            'Deals',
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
          child: FutureBuilder<ProductListResponse>(
            future: vendorBloc.getDeals(),
            builder: (context, snapshot) {
              if (snapshot.hasError) {
                print(snapshot.error);
              }

              if (snapshot.hasData) {
                // setState(() {
                _response = snapshot.data;
                _data = snapshot.data.data;
                // });
              }

              return snapshot.hasData
                  ? (snapshot.data.data.length < 1) ?
              Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    Icon(
                      FontAwesomeIcons.shoppingBasket,
                      color: Colors.grey,
                      size: 60.0,
                    ),
                    SizedBox(
                      height: 10.0,
                    ),
                    Text(
                      'There is currently No Deals, check again later!',
                      style: TextStyle(color: Colors.grey),
                    ),
                    SizedBox(
                      height: 10.0,
                    ),
                    TextButton(
                      child: Text(
                        'Go To Home',
                        style: TextStyle(color: Colors.white),
                      ),
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => ScreenContainer(3)),
                        );
                      },
                    )
                  ],
                ),
              )
                  : ListView(
                physics: BouncingScrollPhysics(),
                shrinkWrap: true,
                children: <Widget>[
                  Container(
                      margin: EdgeInsets.only(top: 10.0),
                      child: ProductsGridView(products: _data)),
                ],
              )
                  : Center(
                  child: SpinKitFoldingCube(
                    color: Theme.of(context).primaryColor,
                    size: 35.0,
                  ));
            },
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

  void _filTerResult(int value) {
    if (_response == null || _response.data == null) {
      return;
    }

    var temp = _data;
    if (value == 2) {
      temp.sort((a, b) => a.price.compareTo(b.price));
    } else if (value == 3) {
      temp.sort((a, b) => a.price.compareTo(b.price));
      temp.reversed;
    } else {
      temp.sort((a, b) => a.id.compareTo(b.id));
      temp.reversed;
    }

    setState(() {
      _data = temp;
    });
  }
}

class ProductsGridView extends StatefulWidget {
  final List<Products> products;

  ProductsGridView({Key key, this.products}) : super(key: key);

  @override
  _ProductsGridViewState createState() => _ProductsGridViewState();
}

class _ProductsGridViewState extends State<ProductsGridView> {
  InkWell getStructuredGridCell(Products products) {
    return InkWell(
      child: Container(
        margin: EdgeInsets.all(5.0),
        padding: EdgeInsets.all(5.0),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10.0),
          boxShadow: [
            BoxShadow(
              blurRadius: 5.0,
              color: Colors.grey,
            ),
          ],
        ),
        child: Column(
          children: <Widget>[
            Expanded(
              child: Container(
                height: double.infinity,
                child: Hero(
                  tag: '${products.name}',
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(10.0),
                    child: Image(
                      image: NetworkImage(fsDlEndpoint + products.images[0].link),
                      fit: BoxFit.fitHeight,
                    ),
                  ),
                ),
              ),
            ),
            Container(
              alignment: Alignment.center,
              padding: EdgeInsets.all(5.0),
              margin: EdgeInsets.only(right: 6.0, left: 6.0),
              child: Column(
                children: <Widget>[
                  Text(
                    products.name,
                    style: TextStyle(fontSize: 12.0),
                    overflow: TextOverflow.ellipsis,
                    maxLines: 1,
                    textAlign: TextAlign.center,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                        Text(
                        "\$${products.salePrice}",
                        style: TextStyle(fontSize: 16.0),
                        overflow: TextOverflow.ellipsis,
                        maxLines: 2,
                        textAlign: TextAlign.center,
                      ),

                      SizedBox(
                        width: 7.0,
                      ),
                      Text(
                        "\$${products.price}",
                        style: TextStyle(
                            fontSize: 13.0,
                            decoration: TextDecoration.lineThrough,
                            color: Colors.grey),
                        overflow: TextOverflow.ellipsis,
                        maxLines: 2,
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                  Text(
                    "Offer ends ${getDate(products.saleEnds)}",
                    style: TextStyle(
                        color: const Color(0xFF67A86B), fontSize: 14.0),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      onTap: () {
        Navigator.push(
            context,
            PageTransition(
                type: PageTransitionType.fade,
                duration: Duration(microseconds: 600),
                child: ProductPage(product: products,)));

        },
    );
  }

  String getDate(String date) {
    if (date == null) {
      return "..";
    }

    DateTime tempDate =
    new DateFormat("yyyy-MM-dd hh:mm:ss").parse(date);
    return DateFormat("MMMM dd, yyyy").format(tempDate);
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    return GridView.count(
      shrinkWrap: true,
      primary: false,
      crossAxisSpacing: 0,
      mainAxisSpacing: 0,
      crossAxisCount: 2,
      childAspectRatio: ((width) / (height - 150.0)),
      children: List.generate(widget.products.length, (index) {
        return getStructuredGridCell(widget.products[index]);
      }),
    );
  }
}