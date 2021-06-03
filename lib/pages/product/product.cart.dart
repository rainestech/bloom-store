import 'package:bloom/Animation/slide_left_rout.dart';
import 'package:bloom/AppTheme/theme.dart';
import 'package:bloom/bloc/vendor.bloc.dart';
import 'package:bloom/data/entity/personnel.entity.dart';
import 'package:bloom/data/entity/vendor.entity.dart';
import 'package:bloom/data/http/endpoints.dart';
import 'package:bloom/data/http/vendor.provider.dart';
import 'package:bloom/helpers/helper.dart';
import 'package:bloom/pages/order_payment/cart.dart';
import 'package:bloom/pages/order_payment/delivery_address.dart';
import 'package:bloom/widget/cart.widget.dart';
import 'package:carousel_pro/carousel_pro.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:fluttertoast/fluttertoast.dart';

class ProductCartPage extends StatefulWidget {
  final Products product;
  final int quantity;

  ProductCartPage({Key key, this.product, this.quantity}) : super(key: key);

  @override
  _ProductCartPageState createState() => _ProductCartPageState();
}

class _ProductCartPageState extends State<ProductCartPage> {
  TextEditingController _quantityController = new TextEditingController();
  int quantity = 0;

  @override
  void initState() {
    _quantityController.text = '0';
    if (widget.quantity != null) {
      _quantityController.text = widget.quantity.toString();
      quantity = widget.quantity;
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.product.name),
        titleSpacing: 0.0,
        backgroundColor: AppColors.primaryColor,
        iconTheme: IconThemeData(color: AppColors.themeDark),
        actions: <Widget>[
          CartNotification(),
        ],
      ),
      backgroundColor: const Color(0xFFF1F3F6),
      body: _body(),
      bottomNavigationBar: Material(
        elevation: 5.0,
        child: Container(
          color: Colors.white,
          width: width,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              InkWell(
                onTap: () {
                  _addToCart();
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
              InkWell(
                onTap: () {
                  // Navigator.push(context, SlideLeftRoute(page: Delivery()));
                },
                child: Container(
                  width: width / 2,
                  height: 50.0,
                  color: Theme.of(context).primaryColor,
                  alignment: Alignment.center,
                  child: Text(
                    'Checkout',
                    style: TextStyle(color: Colors.white, fontSize: 15.0),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  _body() {
    double height = MediaQuery.of(context).size.height;
    var images = [];
    for (Passport p in widget.product.images) {
      images.add(NetworkImage(fsDlEndpoint + p.link));
    }

    return ListView(
      shrinkWrap: true,
      physics: BouncingScrollPhysics(),
      children: <Widget>[
        // Slider and Add to Wishlist Code Starts Here
        Container(
          padding: EdgeInsets.only(top: 8.0),
          color: Colors.white,
          child: Hero(
            tag: '${widget.product.name}',
            child: SizedBox(
              height: (height / 2.0),
              child: Carousel(
                images: images,
                dotSize: 5.0,
                dotSpacing: 15.0,
                dotColor: Colors.grey,
                indicatorBgPadding: 5.0,
                dotBgColor: Colors.purple.withOpacity(0.0),
                boxFit: BoxFit.fitHeight,
                animationCurve: Curves.decelerate,
                dotIncreasedColor: Colors.blue,
                overlayShadow: true,
                overlayShadowColors: Colors.white,
                overlayShadowSize: 0.7,
              ),
            ),
          ),
        ),
        // Slider and Add to Wishlist Code Ends Here
        Container(
            color: Colors.white,
            child: SizedBox(
              height: 8.0,
            )),
        Divider(
          height: 1.0,
        ),

        Container(
          color: Colors.white,
          padding: EdgeInsets.all(10.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              // Product Title Start Here
              Text(
                '${widget.product.name}',
                style: TextStyle(
                  fontSize: 18.0,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.start,
              ),
              // Product Title End Here

              // Special Price badge Start Here
              if(widget.product.salePrice != null && DateFormatter.dateAheadOfNow(widget.product.saleEnds))
                Container(
                  margin: EdgeInsets.only(top: 5.0, bottom: 5.0),
                  padding: EdgeInsets.all(3.0),
                  decoration: BoxDecoration(
                    color: Colors.grey[200],
                    borderRadius: BorderRadius.circular(5.0),
                  ),
                  child: Text(
                    'Special Price',
                    style: TextStyle(color: Colors.red[800], fontSize: 12.0),
                  ),
                ),
              // Special Price badge Ends Here.

              // Price & Offer Row Starts Here
              if(widget.product.salePrice != null && DateFormatter.dateAheadOfNow(widget.product.saleEnds))
                Container(
                  margin: EdgeInsets.only(top: 5.0, bottom: 5.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      Text(
                        '\$${widget.product.salePrice}',
                        style: TextStyle(
                          fontSize: 18.0,
                        ),
                      ),
                      SizedBox(
                        width: 8.0,
                      ),
                      Text(
                        '\$${widget.product.price}',
                        style: TextStyle(
                            fontSize: 14.0,
                            decoration: TextDecoration.lineThrough,
                            color: Colors.grey),
                      ),
                      SizedBox(
                        width: 8.0,
                      ),
                      Text(
                        '\$${widget.product.salePrice}',
                        style: TextStyle(fontSize: 14.0, color: Colors.red[700]),
                      ),
                    ],
                  ),
                ),

              if(widget.product.salePrice == null || (widget.product.salePrice != null && !DateFormatter.dateAheadOfNow(widget.product.saleEnds)))
                Container(
                  margin: EdgeInsets.only(top: 5.0, bottom: 5.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      Text(
                        '\$${widget.product.price}',
                        style: TextStyle(
                          fontSize: 18.0,
                        ),
                      ),
                      SizedBox(
                        width: 8.0,
                      ),
                    ],
                  ),
                ),

              Container(
                margin: EdgeInsets.only(top: 5.0, bottom: 5.0, left: 40, right: 40),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      decoration: BoxDecoration(
                        color: Colors.grey[300],
                        borderRadius: BorderRadius.circular(55),
                      ),
                      child: IconButton(
                        onPressed: () {
                          if (quantity > 0) {
                            quantity--;
                            _quantityController.text = quantity.toString();
                          }
                        },
                        icon: Icon(Icons.remove,
                          size: 24, color: Colors.red,
                        ),
                      ),
                    ),
                    Container(
                      width: 100,
                      child:TextField(
                        controller: _quantityController,
                        textCapitalization: TextCapitalization.none,
                        keyboardType: TextInputType.number,
                        textAlign: TextAlign.center,
                        onChanged: (value) => {
                          quantity = int.parse(value),
                        },
                        decoration: InputDecoration(
                          hintText: '0',
                          contentPadding: const EdgeInsets.only(
                              top: 12.0, bottom: 12.0),
                        ),
                      ),
                    ),
                    Container(
                      decoration: BoxDecoration(
                        color: Colors.grey[300],
                        borderRadius: BorderRadius.circular(55),
                      ),
                      child: IconButton(
                        onPressed: () {
                          quantity++;
                          _quantityController.text = quantity.toString();
                        },
                        icon: Icon(Icons.add,
                          size: 24, color: Colors.green, ),
                      ),
                    ),
                  ],
                ),
              ),

            ],
          ),
        ),
      ],
    );
  }

  void _showDialog() {
    // flutter defined function
    showDialog(
      context: context,
      builder: (BuildContext context) {
        // return object of type Dialog
        return AlertDialog(
          title: Text(
            "Product Added To Cart!",
            style: TextStyle(
              fontWeight: FontWeight.bold,
            ),
          ),
          // content: Text("Are you Sure you want to Logout?"),
          actions: <Widget>[
            // usually buttons at the bottom of the dialog
            TextButton(
              child: Text(
                "Go to Cart",
                style: TextStyle(
                  color: Theme.of(context).primaryColor,
                ),
              ),
              onPressed: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => CartPage()));
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
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  void _addToCart() async {
    if (quantity < 1) {
      Fluttertoast.showToast(msg: 'Quantity can not be 0 or less than 1');
      return;
    }
    EasyLoading.show(status: 'Adding Product to Cart...', dismissOnTap: false, maskType: EasyLoadingMaskType.black);
    var product = widget.product;
    product.quantity = quantity;
    var data = new Cart();
    data.product = product;
    data.quantity = quantity;
    data.price = (widget.product.salePrice != null && DateFormatter.dateAheadOfNow(widget.product.saleEnds)) ? product.salePrice : product.price;
    data.category = product.category.name;
    data.status = 'cart';

    CartResponse response = await vendorBloc.saveCart(data);
    if (response.data != null) {
      EasyLoading.dismiss();
      _showDialog();
    } else {
      EasyLoading.dismiss();
      ServerValidationDialog.errorDialog(
          context, response.error, response.eTitle); //invoking log
      print(response.error);
    }
  }
}
