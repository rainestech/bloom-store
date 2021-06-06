import 'package:auto_size_text/auto_size_text.dart';
import 'package:bloom/AppTheme/theme.dart';
import 'package:bloom/bloc/vendor.bloc.dart';
import 'package:bloom/data/entity/vendor.entity.dart';
import 'package:bloom/data/http/endpoints.dart';
import 'package:bloom/data/http/vendor.provider.dart';
import 'package:bloom/helpers/helper.dart';
import 'package:bloom/pages/vendors/products/products.dart';
import 'package:bloom/pages/vendors/profile/shop.profile.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class AdminVendorScreen extends StatefulWidget {
  @override
  _AdminVendorScreenState createState() => _AdminVendorScreenState();
}

class _AdminVendorScreenState extends State<AdminVendorScreen> {
  @override
  void initState() {
    super.initState();
    vendorBloc.getVendors();
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;

    getVendorTile(Vendor vendor) {
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
                caption: 'Disapprove',
                color: Colors.red,
                icon: Icons.cancel_outlined,
                onTap: () {
                  _delete(vendor);
                },
              ),
            ),
          ],
          actions: <Widget>[
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
                  _approve(vendor);
                },
              ),
            ),
          ],
          child: InkWell(
            onTap: () => {
              Navigator.push(context,
              MaterialPageRoute(builder: (context) => ShopProfileScreen(vendor: vendor,)))
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
                    height: 100.0,
                    decoration: BoxDecoration(
                      image: DecorationImage(
                        image: NetworkImage(fsDlEndpoint + vendor.logo.link),
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
                            vendor.name,
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
                              top: 8.0, bottom: 4.0, right: 8.0, left: 8.0),
                          child: AutoSizeText(
                            vendor.approved ? 'Approved' : 'Not Approved',
                            maxLines: 1,
                            style: TextStyle(
                              color: vendor.approved ? Colors.green : AppColors.themeRed,
                              fontSize: 16.0,

                              fontWeight: FontWeight.w500,
                              letterSpacing: 0.7,
                            ),
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.only(
                              top: 0.0, right: 8.0, left: 8.0, bottom: 8.0),
                          child: Row(
                            children: [
                              Text(
                                'Products: ',
                                style: TextStyle(
                                  fontSize: 12.0,

                                  fontWeight: FontWeight.w700,
                                  letterSpacing: 0.7,
                                  color: AppColors.themeDark,
                                ),
                              ),
                              Text(
                                vendor.productCount.toString(),
                                style: TextStyle(
                                  fontSize: 12.0,
                                  fontWeight: FontWeight.w700,
                                  letterSpacing: 0.7,
                                  color: Colors.green,
                                ),
                              ),
                              Spacer(),
                              Text(
                                'Approved Products: ',
                                style: TextStyle(
                                  fontSize: 12.0,

                                  fontWeight: FontWeight.w700,
                                  letterSpacing: 0.7,
                                  color: AppColors.themeDark,
                                ),
                              ),
                              Text(
                                vendor.approvedProduct == null ? '0' : vendor.approvedProduct.toString(),
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
                        Padding(
                          padding: EdgeInsets.only(
                              top: 0.0, right: 8.0, left: 8.0, bottom: 8.0),
                          child: Row(
                            children: [
                              Text(
                                'Wallet Balance: ',
                                style: TextStyle(
                                  fontSize: 12.0,

                                  fontWeight: FontWeight.w700,
                                  letterSpacing: 0.7,
                                  color: AppColors.themeDark,
                                ),
                              ),
                              Text(
                                '\$' + numberFormat.format(vendor.walletBalance),
                                style: TextStyle(
                                  fontSize: 12.0,
                                  fontWeight: FontWeight.w700,
                                  letterSpacing: 0.7,
                                  color: Colors.green,
                                ),
                              ),
                              Spacer(),
                              InkWell(
                                child: Container(
                                  width: width/4 - 20,
                                  alignment: Alignment.center,
                                  padding: EdgeInsets.all(5.0),
                                  decoration: BoxDecoration(
                                      color: Colors.amber,
                                      borderRadius: BorderRadius.all(Radius.circular(10)),
                                      border: Border.all(color: AppColors.themeRed, style: BorderStyle.solid)
                                  ),
                                  child: Text(
                                    'Products',
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                        fontSize: 14.0, fontWeight: FontWeight.bold, color: AppColors.themeDark),
                                  ),
                                ),
                                onTap: () {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) =>
                                              ProductScreen(vendor: vendor)));
                                },
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

    Widget _listProductsWidget(List<Vendor> data, double width, double height) {
      return ListView(
        children: [
          for (Vendor item in data)
            getVendorTile(item),
        ],
      );
    }

    Widget _noVendor(double width, double height) {
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
              'No Registered Vendor at the moment!',
              style: TextStyle(
                color: AppColors.themeRed,
                fontSize: 18.0,

                fontWeight: FontWeight.w700,
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
            'Bloom Vendors',
            style: textTheme.headline1,
          ),
          titleSpacing: 0.0,
          backgroundColor: AppColors.primaryColor,
          iconTheme: IconThemeData(color: AppColors.themeDark),
          actions: <Widget>[
            // IconButton(
            //   icon: Icon(Icons.add),
            //   color: AppColors.themeDark,
            //   onPressed: () {
            //   },
            // ),
          ],
        ),
        body: StreamBuilder<VendorListResponse>(
            stream: vendorBloc.vendorListSubject.stream,
            builder: (context, AsyncSnapshot<VendorListResponse> snapshot) {
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
                  return _noVendor(width, height);
                }
                return _listProductsWidget(snapshot.data.data, width, height);
              } else {
                return Center(
                    child: SpinKitCircle( color: AppColors.primaryColor,)
                );
              }
            }
        )
    );
  }

  void _delete(Vendor vendor) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        // return object of type Dialog
        return AlertDialog(
          title: Text(
            "Confirm Status Change",
            style: TextStyle(
              fontWeight: FontWeight.bold,
            ),
          ),
          content: Text("Are you Sure you want to disapprove ${vendor.name}?"),
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
                "Disapprove",
                style: TextStyle(
                  color: AppColors.themeRed,
                ),
              ),
              onPressed: () {
                Navigator.of(context).pop();
                revokeVendor(vendor);
              },
            ),
          ],
        );
      },
    );
  }

  Future<void> revokeVendor(Vendor vendor) async {
    EasyLoading.show(status: 'Revoking Vendor Status...');
    var resp = await vendorBloc.revokeVendor(vendor);
    EasyLoading.dismiss();

    if (resp.data != null) {
      vendorBloc.getVendors();
      EasyLoading.showSuccess('Vendor Disapproved', duration: Duration(seconds: 5));
    } else {
      EasyLoading.showError('An Error Occurred, Please try again', duration: Duration(seconds: 5));
    }
  }

  Future<void> _approve(Vendor vendor) async {
    EasyLoading.show(status: 'Approving Vendor...');
    var resp = await vendorBloc.approveVendor(vendor);
    EasyLoading.dismiss();

    if (resp.data != null) {
      vendorBloc.getVendors();
      EasyLoading.showSuccess('Vendor Approved', duration: Duration(seconds: 5));
    } else {
      EasyLoading.showError('An Error Occurred, Please try again', duration: Duration(seconds: 5));
    }
  }
}