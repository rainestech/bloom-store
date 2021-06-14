import 'package:auto_size_text/auto_size_text.dart';
import 'package:bloom/AppTheme/theme.dart';
import 'package:bloom/bloc/user.bloc.dart';
import 'package:bloom/bloc/vendor.bloc.dart';
import 'package:bloom/data/entity/admin.entity.dart';
import 'package:bloom/data/entity/vendor.entity.dart';
import 'package:bloom/data/http/endpoints.dart';
import 'package:bloom/data/http/vendor.provider.dart';
import 'package:bloom/helpers/helper.dart';
import 'package:bloom/pages/product/product.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import 'edit.product.dart';

class ProductScreen extends StatefulWidget {
  final Vendor vendor;

  const ProductScreen({Key key, this.vendor}) : super(key: key);
  @override
  _ProductScreenState createState() => _ProductScreenState();
}

class _ProductScreenState extends State<ProductScreen> {
  User _user;
  @override
  void initState() {
    super.initState();
    // if (widget.vendor != null) {
    //   vendorBloc.getShopProductsAdmin(widget.vendor);
    // } else {
    //   vendorBloc.getMyProducts();
    // }

    userBloc.getUser();
    userBloc.userSubject.listen((value) {
      if (!mounted) return;

      setState(() {
        _user = value.data;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;

    getProductTile(Products product) {
      return Slidable(
          actionPane: SlidableDrawerActionPane(),
          actionExtentRatio: 0.25,
          secondaryActions: <Widget>[
            if (widget.vendor == null)
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
                  _delete(product);
                },
              ),
            ),
            if (widget.vendor != null)
            Container(
              margin: EdgeInsets.only(
                top: 5.0,
                bottom: 5.0,
              ),
              child: IconSlideAction(
                caption: 'Disapprove',
                color: Colors.red,
                icon: Icons.remove,
                onTap: () {
                  delist(product);
                },
              ),
            ),
          ],
          actions: <Widget>[
            if (widget.vendor == null)
              Container(
              margin: EdgeInsets.only(
                top: 5.0,
                bottom: 5.0,
              ),
              child: IconSlideAction(
                caption: 'Edit',
                color: Colors.orange,
                icon: Icons.edit,
                onTap: () {
                  return Navigator.push(context,
                      MaterialPageRoute(builder: (context) => AddEditProductPage(product: product,)));
                },
              ),
            ),
            if (widget.vendor != null)
              Container(
              margin: EdgeInsets.only(
                top: 5.0,
                bottom: 5.0,
              ),
              child: IconSlideAction(
                caption: 'Approve',
                color: Colors.orange,
                icon: Icons.check,
                onTap: () {
                  approve(product);
                },
              ),
            ),
          ],
          child: InkWell(
            onTap: () => {
              Navigator.push(context,
              MaterialPageRoute(builder: (context) => ProductPage(product: product,)))
            },
            child: Container(
              padding: EdgeInsets.all(5.0),
              margin: EdgeInsets.all(10.0),
              decoration: BoxDecoration(
                color: Colors.grey[400],
                borderRadius: BorderRadius.circular(20.0),
                boxShadow: <BoxShadow>[
                  BoxShadow(
                    blurRadius: 1.5,
                    spreadRadius: 1.5,
                    color: Colors.grey[500],
                  ),
                ],
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Container(
                    width: 80.0,
                    height: 80.0,
                    decoration: BoxDecoration(
                      image: DecorationImage(
                        image: NetworkImage(fsDlEndpoint + product.images[0].link),
                        fit: BoxFit.cover,
                      ),
                      borderRadius: BorderRadius.circular(20.0),
                    ),
                  ),
                  Container(
                    width: width - 120.0,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Padding(
                          padding: const EdgeInsets.only(
                              top: 8.0, bottom: 4.0, right: 8.0, left: 8.0),
                          child: AutoSizeText(
                            product.name,
                            maxLines: 2,
                            style: TextStyle(
                              color: AppColors.themeDark,
                              fontSize: 20.0,

                              fontWeight: FontWeight.w700,
                              letterSpacing: 0.7,
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(
                              top: 4.0, bottom: 8.0, right: 8.0, left: 8.0),
                          child: Row(
                            children: [
                              AutoSizeText(
                                product.category.name,
                                maxLines: 1,
                                style: TextStyle(
                                  color: AppColors.themeRed,
                                  fontSize: 16.0,

                                  fontWeight: FontWeight.w500,
                                  letterSpacing: 0.7,
                                ),
                              ),
                              Spacer(),
                              if(widget.vendor != null)
                              Icon(
                                product.approved ? Icons.check : Icons.cancel_outlined,
                                color: product.approved ? Colors.green : AppColors.themeRed,
                                size: 24,
                              ),
                            ],
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.only(
                              top: 0.0, right: 8.0, left: 8.0, bottom: 8.0),
                          child: Row(
                            children: [
                              Text(
                                'Stock: ',
                                style: TextStyle(
                                  fontSize: 12.0,

                                  fontWeight: FontWeight.w700,
                                  letterSpacing: 0.7,
                                  color: AppColors.themeDark,
                                ),
                              ),
                              Text(
                                product.stock.toString(),
                                style: TextStyle(
                                  fontSize: 12.0,
                                  fontWeight: FontWeight.w700,
                                  letterSpacing: 0.7,
                                  color: Colors.green,
                                ),
                              ),
                              Spacer(),
                              Text(
                                'Unit Sold: ',
                                style: TextStyle(
                                  fontSize: 12.0,

                                  fontWeight: FontWeight.w700,
                                  letterSpacing: 0.7,
                                  color: AppColors.themeDark,
                                ),
                              ),
                              Text(
                                product.unitsSold == null ? '0' : product.unitsSold.toString(),
                                style: TextStyle(
                                  fontSize: 12.0,

                                  fontWeight: FontWeight.w700,
                                  letterSpacing: 0.7,
                                  color: Colors.green,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
      );
    }

    Widget _listProductsWidget(List<Products> data, double width, double height) {
      return ListView(
        children: [
          for (Products item in data)
            getProductTile(item),
        ],
      );
    }

    Widget _noProduct(double width, double height) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Icon(
              FontAwesomeIcons.shoppingCart,
              color: Colors.green,
              size: 60.0,
            ),
            SizedBox(
              height: 20.0,
            ),
            AutoSizeText(
              'You have no product yet!',
              style: TextStyle(
                color: AppColors.themeRed,
                fontSize: 18.0,

                fontWeight: FontWeight.w700,
              ),
            ),
            SizedBox(height: 10,),
            Container(
              padding: EdgeInsets.only(right: 30.0, left: 30.0),
              child: AutoSizeText(
                'You can begin to add products for sale by using the Plus Button on top right.',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: AppColors.black,
                  fontSize: 14.0,
                ),
              ),
            ),
            SizedBox(height: 10,),
          ],
        ),
      );
    }

    var textTheme = Theme.of(context).textTheme;
    return Scaffold(
        backgroundColor: AppColors.grey,
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
            'My Products',
            style: textTheme.headline1,
          ),
          titleSpacing: 0.0,
          backgroundColor: AppColors.primaryColor,
          iconTheme: IconThemeData(color: AppColors.themeDark),
          actions: <Widget>[
            IconButton(
              icon: Icon(Icons.add),
              color: AppColors.themeDark,
              onPressed: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => AddEditProductPage(product: null,)));
              },
            ),
          ],
        ),
        body: FutureBuilder<ProductListResponse>(
            future: widget.vendor != null ? vendorBloc.getShopProductsAdmin(widget.vendor) : vendorBloc.getMyProducts(),
            builder: (context, AsyncSnapshot<ProductListResponse> snapshot) {
              if (snapshot.hasData) {
                if (snapshot.data.error != null &&
                    (snapshot.data.error.length > 0 || snapshot.data.eTitle.length > 0)) {
                  if ((snapshot.data.eTitle != null && snapshot.data.eTitle.toLowerCase() == 'forbidden') || snapshot.data.error.toLowerCase().contains('token')) {
                    unAuthorizedError(context);
                    // return null;
                  }
                  return HttpErrorWidget(snapshot.data.error.length > 0 ? snapshot.data.error : snapshot.data.eTitle, width, height);
                }

                if (snapshot.data.data.length < 1) {
                  return _noProduct(width, height);
                }
                return _listProductsWidget(snapshot.data.data, width, height);
              } else {
                return Center(
                    child: SpinKitChasingDots(
                      itemBuilder: (BuildContext context, int index) {
                        return DecoratedBox(
                          decoration: BoxDecoration(
                            color: index.isEven ? AppColors.primaryColor : AppColors.secondaryColor,
                          ),
                        );
                      },
                    )
                );
              }
            }
        )
    );
  }

  void _delete(Products product) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        // return object of type Dialog
        return AlertDialog(
          title: Text(
            "Confirm Delete",
            style: TextStyle(
              fontWeight: FontWeight.bold,
            ),
          ),
          content: Text("Are you Sure you want to delete ${product.name} product?"),
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

            TextButton(
              child: Text(
                "Delete",
                style: TextStyle(
                  color: AppColors.themeRed,
                ),
              ),
              onPressed: () {
                Navigator.of(context).pop();
                deleteProduct(product);
              },
            ),
          ],
        );
      },
    );
  }

  Future<void> deleteProduct(Products product) async {
    EasyLoading.show(status: 'Deleting Product...');
    var resp = await vendorBloc.deleteProduct(product);
    EasyLoading.dismiss();

    if (resp.data != null) {
      EasyLoading.showSuccess('Product Deleted', duration: Duration(seconds: 5));
    } else {
      EasyLoading.showError('An Error Occurred, Please try again', duration: Duration(seconds: 5));
    }
  }

  Future<void> delist(Products product) async {
    EasyLoading.show(status: 'DeListing Product...');
    var resp = await vendorBloc.delistProduct(product);
    vendorBloc.getShopProducts(widget.vendor);
    EasyLoading.dismiss();

    if (resp.data != null) {
      EasyLoading.showSuccess('Product Delisted', duration: Duration(seconds: 5));
    } else {
      EasyLoading.showError('An Error Occurred, Please try again', duration: Duration(seconds: 5));
    }
  }

  Future<void> approve(Products product) async {
    EasyLoading.show(status: 'Approving Product...');
    var resp = await vendorBloc.approveProduct(product);
    vendorBloc.getShopProducts(widget.vendor);
    EasyLoading.dismiss();

    if (resp.data != null) {
      EasyLoading.showSuccess('Product Approved', duration: Duration(seconds: 5));
    } else {
      EasyLoading.showError('An Error Occurred, Please try again', duration: Duration(seconds: 5));
    }
  }
}