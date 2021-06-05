import 'package:auto_size_text/auto_size_text.dart';
import 'package:bloom/AppTheme/theme.dart';
import 'package:bloom/bloc/vendor.bloc.dart';
import 'package:bloom/data/entity/vendor.entity.dart';
import 'package:bloom/data/http/endpoints.dart';
import 'package:bloom/data/http/vendor.provider.dart';
import 'package:bloom/helpers/helper.dart';
import 'package:bloom/pages/category/top_offers_pages/get_products.dart';
import 'package:bloom/pages/product/product.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import 'addEdit.ad.dart';

class AdsScreen extends StatefulWidget {
  @override
  _AdsScreenState createState() => _AdsScreenState();
}

class _AdsScreenState extends State<AdsScreen> with WidgetsBindingObserver {
  @override
  void initState() {
    super.initState();
    vendorBloc.myAds();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      vendorBloc.myAds();
    }
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;

    getAdTile(Ads ad) {
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
                  _delete(ad);
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
                caption: 'Edit',
                color: Colors.orange,
                icon: Icons.edit,
                onTap: () {
                  return Navigator.push(context,
                      MaterialPageRoute(builder: (context) => AddEditAdPage(ad: ad,)));
                },
              ),
            ),
          ],
          child: InkWell(
            onTap: () => {
              if (ad.product != null) {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => ProductPage(product: ad.product,)))
              } else {
              Navigator.push(context,
                MaterialPageRoute(builder: (context) => GetProducts(category: ad.category))),
              }
            },
            child: Container(
              width: width - 10,
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
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Container(
                    height: 100.0,
                    decoration: BoxDecoration(
                      image: DecorationImage(
                        image: NetworkImage(fsDlEndpoint + ad.image.link),
                        fit: BoxFit.cover,
                      ),
                      borderRadius: BorderRadius.circular(20.0),
                    ),
                  ),
                  SizedBox(height: 10,),
                  Container(
                    height: 20.0,
                    child: AutoSizeText(
                      ad.product != null ? ad.product.name : ad.category.name,
                      maxLines: 1,
                      textAlign: TextAlign.center,
                    ),
                  ),
                ],
              ),
            ),
          ),
      );
    }

    Widget _listAdsWidget(List<Ads> data, double width, double height) {
      return ListView(
        children: [
          for (Ads item in data)
            getAdTile(item),
        ],
      );
    }

    Widget _noAd(double width, double height) {
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
              'You have no Ads yet!',
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
                'You can begin to add Ads by using the Plus Button on top right.',
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
            'My Ads',
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
                    MaterialPageRoute(builder: (context) => AddEditAdPage(ad: null,)));
              },
            ),
          ],
        ),
        body: StreamBuilder<AdsListResponse>(
            stream: vendorBloc.adsListSubject.stream,
            builder: (context, AsyncSnapshot<AdsListResponse> snapshot) {
              if (snapshot.hasData) {
                if (snapshot.data.error != null &&
                    (snapshot.data.error.length > 0 || (snapshot.data.eTitle != null && snapshot.data.eTitle.length > 0))) {
                  if ((snapshot.data.eTitle != null && snapshot.data.eTitle.toLowerCase() == 'forbidden') || snapshot.data.error.toLowerCase().contains('token')) {
                    unAuthorizedError(context);
                    // return null;
                  }
                  return HttpErrorWidget(snapshot.data.error.length > 0 ? snapshot.data.error : snapshot.data.eTitle, width, height);
                }

                if (snapshot.data.data.length < 1) {
                  return _noAd(width, height);
                }
                return _listAdsWidget(snapshot.data.data, width, height);
              } else {
                return Center(
                    child: SpinKitCircle(color: AppColors.secondaryColor,)
                );
              }
            }
        )
    );
  }

  void _delete(Ads ad) {
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
          content: Text("Are you Sure you want to delete ${ad.product != null ? ad.product.name : ad.category.name} Ad?"),
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
                deleteAd(ad);
              },
            ),
          ],
        );
      },
    );
  }

  Future<void> deleteAd(Ads ad) async {
    EasyLoading.show(status: 'Deleting Ad...');
    var resp = await vendorBloc.deleteAd(ad);
    EasyLoading.dismiss();

    if (resp.data != null) {
      EasyLoading.showSuccess('Ad Deleted', duration: Duration(seconds: 5));
    } else {
      EasyLoading.showError('An Error Occurred, Please try again', duration: Duration(seconds: 5));
    }
  }
}