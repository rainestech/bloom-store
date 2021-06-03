import 'dart:ui';

import 'package:bloom/AppTheme/theme.dart';
import 'package:bloom/data/entity/personnel.entity.dart';
import 'package:bloom/data/entity/vendor.entity.dart';
import 'package:bloom/data/http/endpoints.dart';
import 'package:bloom/helpers/helper.dart';
import 'package:carousel_pro/carousel_pro.dart';
import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
// My Own Imports

class ProductDetails extends StatefulWidget {
  final Products data;

  ProductDetails({Key key, this.data}) : super(key: key);

  @override
  _ProductDetailsState createState() => _ProductDetailsState();
}

class _ProductDetailsState extends State<ProductDetails> {
  bool favourite = false;
  Color color = Colors.grey;

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;

    var images = [];
    for (Passport p in widget.data.images) {
      images.add(NetworkImage(fsDlEndpoint + p.link));
    }

    return ListView(
      shrinkWrap: true,
      physics: BouncingScrollPhysics(),
      children: <Widget>[
        // Slider and Add to Wishlist Code Starts Here
        Stack(
          children: <Widget>[
            Container(
              padding: EdgeInsets.only(top: 8.0),
              color: Colors.white,
              child: Hero(
                tag: '${widget.data.name}',
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
            Positioned(
              top: 20.0,
              right: 20.0,
              child: FloatingActionButton(
                backgroundColor: Colors.white,
                elevation: 3.0,
                onPressed: () {
                  setState(() {
                    if (!favourite) {
                      favourite = true;
                      color = Colors.red;

                      ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text("Added to Wishlist")));
                    } else {
                      favourite = false;
                      color = Colors.grey;
                      ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text("Remove from Wishlist")));
                    }
                  });
                },
                child: Icon(
                  (!favourite)
                      ? FontAwesomeIcons.heart
                      : FontAwesomeIcons.solidHeart,
                  color: color,
                ),
              ),
            ),
          ],
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
                '${widget.data.name}',
                style: TextStyle(
                  fontSize: 18.0,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.start,
              ),
              // Product Title End Here

              // Special Price badge Start Here
              if(widget.data.salePrice != null && DateFormatter.dateAheadOfNow(widget.data.saleEnds))
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
              if(widget.data.salePrice != null && DateFormatter.dateAheadOfNow(widget.data.saleEnds))
                Container(
                  margin: EdgeInsets.only(top: 5.0, bottom: 5.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      Text(
                        '\$${widget.data.salePrice}',
                        style: TextStyle(
                          fontSize: 18.0,
                        ),
                      ),
                      SizedBox(
                        width: 8.0,
                      ),
                      Text(
                        '\$${widget.data.price}',
                        style: TextStyle(
                            fontSize: 14.0,
                            decoration: TextDecoration.lineThrough,
                            color: Colors.grey),
                      ),
                      SizedBox(
                        width: 8.0,
                      ),
                      Text(
                        '\$${widget.data.salePrice}',
                        style: TextStyle(fontSize: 14.0, color: Colors.red[700]),
                      ),
                    ],
                  ),
                ),

              if(widget.data.salePrice == null || (widget.data.salePrice != null && !DateFormatter.dateAheadOfNow(widget.data.saleEnds)))
                Container(
                  margin: EdgeInsets.only(top: 5.0, bottom: 5.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      Text(
                        '\$${widget.data.price}',
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

              // Rating Row Starts Here
              // RatingRow(),
              // Rating Row Ends Here
            ],
          ),
        ),

        Container(
          margin: EdgeInsets.all(10),
          width: width,
          height: 150.0,
          decoration: BoxDecoration(
              image: DecorationImage(
                image: NetworkImage(fsDlEndpoint + widget.data.vendor.logo.link),
                fit: BoxFit.cover,
              )
          ),
          child: Stack(
            children: <Widget>[
              BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 0.8, sigmaY: 0.9),
                child: Container(
                  color: Colors.black.withOpacity(0.7),
                ),
              ),

              Positioned(
                top: 10.0,
                width: width,
                child: Column(
                  children: <Widget>[
                      Padding(
                        padding: EdgeInsets.only(top: 20.0),
                        child: Text(
                          'Sold By',
                          style: TextStyle(
                              fontSize: 14.0, fontWeight: FontWeight.bold, color: AppColors.white),
                        ),
                      ),
                    Padding(
                        padding: EdgeInsets.only(top: 10.0),
                        child: Text(
                          widget.data.vendor.name,
                          style: TextStyle(
                              fontSize: 20.0, fontWeight: FontWeight.bold, color: AppColors.secondaryColor),
                        ),
                      ),
                  ],
                ),
              ),
            ],
          ),
        ),
        // Product Size & Color Start Here
        // ProductSize(),
        // Product Size & Color End Here

        // Product Details Start Here
        // Container(
        //   padding: EdgeInsets.all(10.0),
        //   color: Colors.white,
        //   child: Column(
        //     mainAxisAlignment: MainAxisAlignment.start,
        //     crossAxisAlignment: CrossAxisAlignment.start,
        //     children: <Widget>[
        //       Text(
        //         'Product Details',
        //         style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
        //       ),
        //       SizedBox(
        //         height: 8.0,
        //       ),
        //       // Row(
        //       //   children: <Widget>[
        //       //     Expanded(
        //       //       child: Column(
        //       //         crossAxisAlignment: CrossAxisAlignment.start,
        //       //         children: <Widget>[
        //       //           Text(
        //       //             'Color',
        //       //             style: TextStyle(color: Colors.grey, fontSize: 16.0),
        //       //           ),
        //       //           SizedBox(
        //       //             height: 6.0,
        //       //           ),
        //       //           Text(
        //       //             'Length',
        //       //             style: TextStyle(color: Colors.grey, fontSize: 16.0),
        //       //           ),
        //       //           SizedBox(
        //       //             height: 6.0,
        //       //           ),
        //       //           Text(
        //       //             'Type',
        //       //             style: TextStyle(color: Colors.grey, fontSize: 16.0),
        //       //           ),
        //       //           SizedBox(
        //       //             height: 6.0,
        //       //           ),
        //       //           Text(
        //       //             'Sleeve',
        //       //             style: TextStyle(color: Colors.grey, fontSize: 16.0),
        //       //           ),
        //       //         ],
        //       //       ),
        //       //     ),
        //       //     Expanded(
        //       //       child: Column(
        //       //         crossAxisAlignment: CrossAxisAlignment.start,
        //       //         children: <Widget>[
        //       //           Text(
        //       //             'Yellow',
        //       //             style: TextStyle(fontSize: 16.0),
        //       //           ),
        //       //           SizedBox(
        //       //             height: 6.0,
        //       //           ),
        //       //           Text(
        //       //             'Knee Length',
        //       //             style: TextStyle(fontSize: 16.0),
        //       //           ),
        //       //           SizedBox(
        //       //             height: 6.0,
        //       //           ),
        //       //           Text(
        //       //             'Bandage',
        //       //             style: TextStyle(fontSize: 16.0),
        //       //           ),
        //       //           SizedBox(
        //       //             height: 6.0,
        //       //           ),
        //       //           Text(
        //       //             'Cap Sleeve',
        //       //             style: TextStyle(fontSize: 16.0),
        //       //           ),
        //       //         ],
        //       //       ),
        //       //     ),
        //       //   ],
        //       // ),
        //     ],
        //   ),
        // ),
        // Product Details Ends Here

        // Product Description Start Here
        Container(
          padding: EdgeInsets.all(10.0),
          margin: EdgeInsets.only(top: 5.0),
          color: Colors.white,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(
                'Product Description',
                style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
              ),
              SizedBox(
                height: 8.0,
              ),
              Html(
                data: widget.data.description,
              ),
              SizedBox(height: 5.0),
              Divider(
                height: 1.0,
              ),
              // InkWell(
              //   child: Padding(
              //     padding: const EdgeInsets.all(8.0),
              //     child: Row(
              //       mainAxisAlignment: MainAxisAlignment.center,
              //       children: <Widget>[
              //         Text(
              //           'View More',
              //           style: TextStyle(
              //               color: Theme.of(context).primaryColor,
              //               fontSize: 14.0,
              //               fontWeight: FontWeight.bold),
              //         ),
              //       ],
              //     ),
              //   ),
              //   onTap: () {
              //     _productDescriptionModalBottomSheet(context);
              //   },
              // ),
              Divider(
                height: 1.0,
              ),
            ],
          ),
        ),
        // Product Description Ends Here

        // Similar Product Starts Here
        // Container(
        //   padding: EdgeInsets.all(10.0),
        //   margin: EdgeInsets.only(top: 5.0, bottom: 5.0),
        //   color: Colors.white,
        //   child: Column(
        //     crossAxisAlignment: CrossAxisAlignment.start,
        //     children: <Widget>[
        //       Text(
        //         'Similar Products',
        //         style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
        //       ),
        //       SizedBox(
        //         height: 8.0,
        //       ),
        //       GetSimilarProducts(),
        //     ],
        //   ),
        // ),
        // Similar Product Ends Here
      ],
    );
  }

  // Bottom Sheet for Product Description Starts Here
  // void _productDescriptionModalBottomSheet(context) {
  //   showModalBottomSheet(
  //       context: context,
  //       builder: (BuildContext bc) {
  //         return Container(
  //           child: new Wrap(
  //             children: <Widget>[
  //               Container(
  //                 child: Container(
  //                   margin: EdgeInsets.all(8.0),
  //                   child: Column(
  //                     children: <Widget>[
  //                       Text(
  //                         'Product Description',
  //                         style: TextStyle(
  //                             fontSize: 16.0, fontWeight: FontWeight.bold),
  //                       ),
  //                       SizedBox(
  //                         height: 8.0,
  //                       ),
  //                       Divider(
  //                         height: 1.0,
  //                       ),
  //                       SizedBox(
  //                         height: 8.0,
  //                       ),
  //                       Text(
  //                         'Slip into this trendy and attractive dress from Rudraaksha and look stylish effortlessly. Made to accentuate any body type, it will give you that extra oomph and make you stand out wherever you are. Keep the accessories minimal for that added elegant look, just your favourite heels and dangling earrings, and of course, don\'t forget your pretty smile!',
  //                         style: TextStyle(fontSize: 14.0, height: 1.45),
  //                         // overflow: TextOverflow.ellipsis,
  //                         // maxLines: 5,
  //                         textAlign: TextAlign.start,
  //                       ),
  //                       SizedBox(
  //                         height: 8.0,
  //                       ),
  //                     ],
  //                   ),
  //                 ),
  //               )
  //             ],
  //           ),
  //         );
  //       });
  // }
  // Bottom Sheet for Product Description Ends Here
}
