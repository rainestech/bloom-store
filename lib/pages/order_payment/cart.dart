import 'package:auto_size_text/auto_size_text.dart';
import 'package:bloom/Animation/slide_left_rout.dart';
import 'package:bloom/AppTheme/theme.dart';
import 'package:bloom/bloc/person.bloc.dart';
import 'package:bloom/bloc/vendor.bloc.dart';
import 'package:bloom/data/entity/personnel.entity.dart';
import 'package:bloom/data/entity/vendor.entity.dart';
import 'package:bloom/data/http/endpoints.dart';
import 'package:bloom/helpers/helper.dart';
import 'package:bloom/pages/order_payment/checkout.dart';
import 'package:bloom/pages/product/product.cart.dart';
import 'package:bloom/pages/product/product.dart';
import 'package:bloom/pages/profile/edit_profile.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../home.dart';

class CartPage extends StatefulWidget {
  @override
  _CartPageState createState() => _CartPageState();
}

class _CartPageState extends State<CartPage> {
  List<Cart> _cart = [];
  Person _me;
  bool _resp = false;

  @override
  void initState() {
    super.initState();
    vendorBloc.myCart();
    personBloc.me();
    vendorBloc.cartListSubject.listen((value) {
      if(!mounted) {
        return;
      }

      setState(() {
        if (value.data != null) {
          _cart = value.data;
        }
      });
    });

    personBloc.personResponse.listen((value) {
      if(!mounted) {
        return;
      }

      setState(() {
        _resp = true;
        if (value.data != null) {
          _me = value.data;
        }
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width * 0.7;
    double widthFull = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;

    // No Item in Cart AlertDialog Start Here
    void _showDialog() {
      // flutter defined function
      showDialog(
        context: context,
        builder: (BuildContext context) {
          // return object of type Dialog
          return AlertDialog(
            title: Text(
              "Alert",
              style: TextStyle(
                fontWeight: FontWeight.bold,
              ),
            ),
            content: Text("No Item in Cart"),
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
            ],
          );
        },
      );
    }
    // No Item in Cart AlertDialog Ends Here

    return Scaffold(
      appBar: AppBar(
        title: Text('My Shopping Cart',
        style: TextStyle(
          color: AppColors.themeDark
        ),),
        titleSpacing: 0.0,
        backgroundColor: AppColors.primaryColor,
        iconTheme: IconThemeData(color: AppColors.themeDark),
      ),
      bottomNavigationBar: Material(
        elevation: 5.0,
        child: Container(
          color: Colors.white,
          width: widthFull,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              Container(
                width: ((widthFull) / 2),
                height: 50.0,
                alignment: Alignment.center,
                child: RichText(
                  text: TextSpan(
                    text: 'Total: ',
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 15.0,
                        color: Colors.black),
                    children: <TextSpan>[
                      TextSpan(
                          text: ' \$' + _getTotal(),
                          style: TextStyle(
                              fontSize: 18.0,
                              fontWeight: FontWeight.bold,
                              color: Colors.blue)),
                    ],
                  ),
                ),
              ),
              InkWell(
                onTap: () {
                  print(_me.name);
                  if (_cart.length == 0)
                       _showDialog();
                   else if (_me.id == null && _resp) {
                    Fluttertoast.showToast(msg: "Update your profile first", backgroundColor: Colors.black, textColor: Colors.white);
                    _showProfileDialog();
                  } else {
                    Navigator.push(
                        context, SlideLeftRoute(page: CheckoutPage(cart: _cart, person: _me)));
                  }
                },
                child: Container(
                  width: ((widthFull) / 2),
                  height: 50.0,
                  color: (_cart.length == 0)
                      ? Colors.grey
                      : Theme.of(context).primaryColor,
                  alignment: Alignment.center,
                  child: Text(
                    'Check Out',
                    style: TextStyle(color: Colors.white, fontSize: 15.0),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
      body: (_cart.length == 0 || _me == null)
          ? Center(
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
                    'No Item in Cart',
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
                        MaterialPageRoute(builder: (context) => Home()),
                      );
                    },
                  )
                ],
              ),
            )
          : ListView.builder(
              itemCount: _cart.length,
              itemBuilder: (context, index) {
                final item = _cart[index];
                return Slidable(
                  actionPane: SlidableDrawerActionPane(),
                  actionExtentRatio: 0.25,
                  secondaryActions: <Widget>[
                    Container(
                      margin: EdgeInsets.only(
                        top: 5.0,
                        bottom: 5.0,
                      ),
                      child: IconSlideAction(
                        caption: 'Delete',
                        color: Colors.red,
                        icon: Icons.delete,
                        onTap: () {
                          _removeItem(_cart[index]);
                        },
                      ),
                    ),
                  ],
                  child: Container(
                    height: (height / 4.0),
                    width: width,
                    child: Card(
                        elevation: 3.0,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              width: width,
                              margin: EdgeInsets.only(right: 10, left: 10),
                              child: Row (
                                children: [
                                  Icon(Icons.location_city_outlined, size: 24, color: AppColors.themeRed,),
                                  SizedBox(width: 10,),
                                  AutoSizeText(
                                    '${item.product.vendor.name}',
                                    maxLines: 1,
                                    style: TextStyle(
                                      fontSize: 12.0,
                                      color: AppColors.themeDark,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Divider(height: 10, thickness: 1,),
                            Container(
                              height: (height / 6.0),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: <Widget>[
                                  Column(
                                    crossAxisAlignment: CrossAxisAlignment.center,
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    mainAxisSize: MainAxisSize.min,
                                    children: <Widget>[
                                      Expanded(
                                        child: InkWell(
                                          onTap: () {
                                            Navigator.push(context,
                                                MaterialPageRoute(builder: (context) => ProductPage(product: item.product,)));
                                          },
                                          child: Container(
                                            width: 110.0,
                                            height: 110,
                                            alignment: Alignment.center,
                                            child: Image(
                                              image: NetworkImage(fsDlEndpoint + item.product.images[0].link),
                                              fit: BoxFit.cover,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                  Container(
                                    padding: EdgeInsets.all(10.0),
                                    width: (width - 20.0),
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: <Widget>[
                                        Text(
                                          '${item.product.name}',
                                          style: TextStyle(
                                            fontSize: 15.0,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        AutoSizeText(
                                          '${item.category}',
                                          maxLines: 1,
                                          style: TextStyle(
                                            fontSize: 12.0,
                                            color: Colors.grey,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        SizedBox(
                                          height: 7.0,
                                        ),
                                        Row(
                                          mainAxisAlignment: MainAxisAlignment.start,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.center,
                                          children: <Widget>[
                                            Text(
                                              'Price:',
                                              style: TextStyle(
                                                color: Colors.grey,
                                                fontSize: 15.0,
                                              ),
                                            ),
                                            SizedBox(
                                              width: 10.0,
                                            ),
                                            Text(
                                              '\$${item.price}',
                                              style: TextStyle(
                                                color: Colors.blue,
                                                fontSize: 15.0,
                                              ),
                                            ),
                                          ],
                                        ),
                                        SizedBox(
                                          height: 7.0,
                                        ),
                                        Row(
                                          mainAxisAlignment: MainAxisAlignment.start,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.center,
                                          children: <Widget>[
                                            InkWell(
                                              onTap: () {
                                                Navigator.push(context,
                                                    MaterialPageRoute(builder: (context) => ProductCartPage(product: item.product, quantity: item.quantity)));
                                              },
                                              child: RichText(
                                                text: TextSpan(
                                                  text: 'Quantity:  ',
                                                  style: TextStyle(
                                                      fontSize: 15.0,
                                                      color: Colors.grey),
                                                  children: <TextSpan>[
                                                    TextSpan(
                                                        text: '  ${item.quantity}',
                                                        style: TextStyle(
                                                            fontSize: 15.0,
                                                            color: Colors.blue)),
                                                  ],
                                                ),
                                              ),
                                            ),
                                            Spacer(),
                                            InkWell(
                                              child: Container(
                                                color: AppColors.themeRed,
                                                padding: EdgeInsets.all(3.0),
                                                child: Text(
                                                  'Remove',
                                                  style:
                                                      TextStyle(color: Colors.white),
                                                ),
                                              ),
                                              onTap: () {
                                                _removeItem(_cart[index]);
                                              },
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  )
                                ],
                              ),
                            ),
                          ],
                        )),
                  ),
                );
              },
            ),
    );
  }

  String _getTotal() {
    if (_cart.length > 0) {
      return numberFormat.format(_cart.fold(0.0, (sum, item) => sum + (item.price * item.quantity)));
    }

    return '0';
  }

  void _removeItem(Cart cart) async {
    await vendorBloc.deleteCart(cart);
    vendorBloc.myCart();
    // Then show a snackbar.
    ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Item Removed")));
  }

  void _showProfileDialog() async {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          // return object of type Dialog
          return AlertDialog(
            title: Text(
              "Profile Not Completed!",
              style: TextStyle(
                fontWeight: FontWeight.bold,
              ),
            ),
            // content: Text("Are you Sure you want to Logout?"),
            actions: <Widget>[
              // usually buttons at the bottom of the dialog
              TextButton(
                child: Text(
                  "Complete Profile",
                  style: TextStyle(
                    color: Theme.of(context).primaryColor,
                  ),
                ),
                onPressed: () {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => EditProfile()));
                },
              ),

              TextButton(
                child: Text(
                  "Continue Shopping",
                  style: TextStyle(
                    color: Theme.of(context).primaryColor,
                  ),
                ),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ],
          );
        },
      );
    }
}
