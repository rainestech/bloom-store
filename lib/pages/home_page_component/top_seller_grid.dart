import 'package:bloom/bloc/vendor.bloc.dart';
import 'package:bloom/data/entity/vendor.entity.dart';
import 'package:bloom/data/http/endpoints.dart';
import 'package:bloom/helpers/helper.dart';
import 'package:bloom/pages/product/product.dart';
import 'package:flutter/material.dart';
import 'package:page_transition/page_transition.dart';

// My Own Imports

class TopSeller extends StatefulWidget {

  @override
  _TopSellerState createState() => _TopSellerState();
}

class _TopSellerState extends State<TopSeller> with WidgetsBindingObserver {
  List<Products> _products = [];

  @override
  void initState() {
    super.initState();
    vendorBloc.getProducts();
    vendorBloc.productListSubject.listen((value) {
      if (!mounted) {
        return;
      }

      setState(() {
        if (value.data != null) {
          _products = value.data;
        }
      });
    });
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      vendorBloc.getProducts();
    }
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;

    InkWell getStructuredGridCell(Products products) {
      if (_products.length < 1) {
        vendorBloc.getProducts();
      }
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
                        if(products.salePrice != null && DateFormatter.dateAheadOfNow(products.saleEnds))
                          Text(
                            "\$${products.salePrice}",
                            style: TextStyle(fontSize: 16.0),
                            overflow: TextOverflow.ellipsis,
                            maxLines: 2,
                            textAlign: TextAlign.center,
                          ),

                        if(products.salePrice == null || (products.salePrice != null &&  !DateFormatter.dateAheadOfNow(products.saleEnds)))
                          Text(
                            "\$${products.price}",
                            style: TextStyle(fontSize: 16.0),
                            overflow: TextOverflow.ellipsis,
                            maxLines: 2,
                            textAlign: TextAlign.center,
                          ),
                        if(products.salePrice != null && DateFormatter.dateAheadOfNow(products.saleEnds))
                          SizedBox(
                            width: 7.0,
                          ),
                        if(products.salePrice != null && DateFormatter.dateAheadOfNow(products.saleEnds))
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
                    // Text(
                    //   products.offerText,
                    //   style: TextStyle(
                    //       color: const Color(0xFF67A86B), fontSize: 14.0),
                    // ),
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

    return Container(
      padding: EdgeInsets.all(0.0),
      alignment: Alignment.center,
      width: width - 20.0,
      child: GridView.count(
        shrinkWrap: true,
        primary: false,
        padding: const EdgeInsets.all(0),
        crossAxisSpacing: 0,
        mainAxisSpacing: 0,
        crossAxisCount: 2,
        children: List.generate(_products.length, (index) {
          return getStructuredGridCell(_products[index]);
        }),
      ),
    );
  }
}
