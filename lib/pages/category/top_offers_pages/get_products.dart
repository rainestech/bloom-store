import 'package:bloom/AppTheme/theme.dart';
import 'package:bloom/bloc/vendor.bloc.dart';
import 'package:bloom/data/entity/vendor.entity.dart';
import 'package:bloom/data/http/endpoints.dart';
import 'package:bloom/data/http/vendor.provider.dart';
import 'package:bloom/helpers/helper.dart';
import 'package:bloom/pages/product/product.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

// My Own Imports
import 'package:page_transition/page_transition.dart';
import '../../home.dart';
import 'filter_row.dart';

class GetProducts extends StatefulWidget {
  final Category category;

  const GetProducts({Key key, this.category}) : super(key: key);
  @override
  _GetProductsState createState() => _GetProductsState();
}

class _GetProductsState extends State<GetProducts> {
  ProductListResponse _response;
  List<Products> _data = [];
  int filterValue = 1;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
        title: Text(widget.category.name + ' Products',
        style: TextStyle(
        color: AppColors.themeDark
    ),),
    titleSpacing: 0.0,
    backgroundColor: AppColors.primaryColor,
    iconTheme: IconThemeData(color: AppColors.themeDark),
    ),
    body: FutureBuilder<ProductListResponse>(
      future: vendorBloc.getCategoryProducts(widget.category),
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
                      'No Product added to this Category yet',
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
              : ListView(
                physics: BouncingScrollPhysics(),
                shrinkWrap: true,
                children: <Widget>[
                  FilterRow(
                    onSortChanged: (value) {
                      _filTerResult(value);
                    },
                  ),
                  Divider(
                    height: 1.0,
                  ),
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
    );
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