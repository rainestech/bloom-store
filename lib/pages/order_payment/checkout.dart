import 'package:auto_size_text/auto_size_text.dart';
import 'package:bloom/Animation/slide_left_rout.dart';
import 'package:bloom/AppTheme/theme.dart';
import 'package:bloom/bloc/vendor.bloc.dart';
import 'package:bloom/data/entity/personnel.entity.dart';
import 'package:bloom/data/entity/vendor.entity.dart';
import 'package:bloom/data/http/endpoints.dart';
import 'package:bloom/data/http/stripe.payment.dart';
import 'package:bloom/data/http/vendor.provider.dart';
import 'package:bloom/helpers/helper.dart';
import 'package:bloom/pages/container.dart';
import 'package:bloom/pages/order_payment/payment.dart';
import 'package:bloom/pages/order_payment/widgets/address.card.dart';
import 'package:bloom/pages/order_payment/widgets/price.card.dart';
import 'package:bloom/pages/profile/edit_profile.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../home.dart';

class CheckoutPage extends StatefulWidget {
  final List<Cart> cart;
  final Person person;

  const CheckoutPage({Key key, this.cart, this.person}) : super(key: key);
  @override
  _CheckoutPageState createState() => _CheckoutPageState();
}

class _CheckoutPageState extends State<CheckoutPage> {
  List<Cart> _cart = [];

  @override
  void initState() {
    super.initState();
    setState(() {
      _cart = widget.cart;
    });
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width * 0.7;
    double widthFull = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;

    // No Item in Cart AlertDialog Ends Here

    return Scaffold(
      appBar: AppBar(
        title: Text('Check Out',
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
                  _createOrder();
                },
                child: Container(
                  width: ((widthFull) / 2),
                  height: 50.0,
                  color: (_cart.length == 0)
                      ? Colors.grey
                      : Theme.of(context).primaryColor,
                  alignment: Alignment.center,
                  child: Text(
                    'Pay Now',
                    style: TextStyle(color: Colors.white, fontSize: 15.0),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
      body: (_cart.length == 0)
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
          : ListView (
            children: [
              AddressCard(person: widget.person, cart: widget.cart,),
              Divider(height: 10, thickness: 1,),
              Container(
                padding: EdgeInsets.only(right: 10, left: 10),
                  child: Text('Order Items'),
              ),
              Divider(height: 10, thickness: 1,),
              for(Cart item in _cart)
                Container(
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
                          Divider(height: 5, thickness: 1,),
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
                                        onTap: () {},
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
                                      RichText(
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
                                    ],
                                  ),
                                )
                              ],
                            ),
                          ),
                        ],
                      )),
                ),

              PriceDetailsCard(cart: _cart,),
            ]
      ),
    );
  }

  String _getTotal() {
    if (_cart.length > 0) {
      double price = _cart.fold(0.0, (sum, item) => sum + (item.price * item.quantity));
      double shipping = _cart.fold(0.0, (sum, item) => sum + item.shipping);
      return numberFormat.format(price + shipping);
    }

    return '0';
  }

  void _createOrder() async {
    var address = (widget.person.addresses != null && widget.person.addresses.length > 0) ? widget.person.addresses.firstWhere((e) => e.type == 'shipping') : null;

    if (_cart.isEmpty) {
      return;
    }

    if (widget.person == null) {
      Fluttertoast.showToast(msg: 'Please complete your profile first!');
      return;
    }

    if (address == null) {
      Fluttertoast.showToast(msg: 'Add Shipping Address first!');
      return;
    }

    EasyLoading.show(status: 'Creating your Order....');
    try {
      var order = Orders.cartToOrder(_cart, address);
      OrderResponse response = await vendorBloc.saveOrder(order);

      if (response.data != null) {
        var pr = new PaymentResponse();
        pr.orderId = response.data.id;
        pr.email = response.data.user.email;
        pr.amount = response.data.amount;
        pr.paymentMethodId = 1;

        EasyLoading.dismiss();
        Navigator.push(context, SlideLeftRoute(page: PaymentPage(paymentResponse: pr,)));
      } else {
        EasyLoading.dismiss();
        ServerValidationDialog.errorDialog(
            context, response.error, response.eTitle);
      }
    } on Exception catch (e) {
      EasyLoading.dismiss();
      ServerValidationDialog.errorDialog(
          context, e.toString(), '');
    }

  }
}
