import 'package:auto_size_text/auto_size_text.dart';
import 'package:bloom/AppTheme/theme.dart';
import 'package:bloom/bloc/vendor.bloc.dart';
import 'package:bloom/data/entity/vendor.entity.dart';
import 'package:bloom/data/http/endpoints.dart';
import 'package:bloom/helpers/helper.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';

class Dashboard extends StatefulWidget {
  @override
  _DashboardState createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  Vendor _vendor;

  Map<String, dynamic> _error;
  Map<String, dynamic> _resp = {};

  @override
  void initState() {
    super.initState();
    _getData();

    vendorBloc.myShop();
    vendorBloc.vendorSubject.listen((value) {
      if(!mounted) return;

      setState(() {
        _vendor = value.data;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    var textTheme = Theme.of(context).textTheme;

    return Scaffold(
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
                        image: _vendor == null ? AssetImage('assets/bloom.png') : NetworkImage(fsDlEndpoint + _vendor.logo.link),
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                ),
          ),
          title: Text(
            _vendor == null ? '.. Dashboard' : '${_vendor.name} Dashboard',
            style: textTheme.headline1,
          ),
          titleSpacing: 0.0,
          backgroundColor: AppColors.primaryColor,
          iconTheme: IconThemeData(color: AppColors.themeDark),
          actions: <Widget>[
          ],
        ),
        body: ListView(
          physics: ScrollPhysics(),
          shrinkWrap: true,
          children: [
            StaggeredGridView.count(
              shrinkWrap: true,
              crossAxisCount: 2,
              crossAxisSpacing: 12.0,
              mainAxisSpacing: 12.0,
              padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
              children: <Widget>[
                _buildTile(
                  Padding
                    (
                    padding: const EdgeInsets.all(24.0),
                    child: Row
                      (
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: <Widget>
                        [
                          Column
                            (
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>
                            [
                              Text('Total Products', style: TextStyle(color: Colors.blueAccent)),
                              Text(_resp['totalProducts'] != null ? _resp['totalProducts'].toString() : '..', style: TextStyle(color: Colors.black, fontWeight: FontWeight.w700, fontSize: 34.0))
                            ],
                          ),
                          Material
                            (
                              color: Colors.blue,
                              borderRadius: BorderRadius.circular(24.0),
                              child: Center
                                (
                                  child: Padding
                                    (
                                    padding: const EdgeInsets.all(16.0),
                                    child: Icon(Icons.analytics, color: Colors.white, size: 30.0),
                                  )
                              )
                          )
                        ]
                    ),
                  ),
                ),
                _buildTile(
                  Padding(
                    padding: const EdgeInsets.all(24.0),
                    child: Column
                      (
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>
                        [
                          Material
                            (
                              color: Colors.teal,
                              shape: CircleBorder(),
                              child: Padding
                                (
                                padding: const EdgeInsets.all(16.0),
                                child: Icon(Icons.shopping_bag, color: Colors.white, size: 30.0),
                              )
                          ),
                          Padding(padding: EdgeInsets.only(bottom: 16.0)),
                          Text(_resp['totalSales'] != null ? _resp['totalSales'].toString() : '..', style: TextStyle(color: Colors.black, fontWeight: FontWeight.w700, fontSize: 24.0)),
                          Text('Total Sales', style: TextStyle(color: Colors.black45)),
                        ]
                    ),
                  ),
                ),
                _buildTile(
                  Padding
                    (
                    padding: const EdgeInsets.all(24.0),
                    child: Column
                      (
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>
                        [
                          Material
                            (
                              color: Colors.amber,
                              shape: CircleBorder(),
                              child: Padding
                                (
                                padding: EdgeInsets.all(16.0),
                                child: Icon(Icons.notifications, color: Colors.white, size: 30.0),
                              )
                          ),
                          Padding(padding: EdgeInsets.only(bottom: 16.0)),
                          Text(_resp['totalRevenue'] != null ? _resp['totalRevenue'].toString() : '..', style: TextStyle(color: Colors.black, fontWeight: FontWeight.w700, fontSize: 24.0)),
                          Text('Pending Fund', style: TextStyle(color: Colors.black45)),
                        ]
                    ),
                  ),
                ),
                if (_resp['newOrders'] != null)
                _buildTile(
                  Padding
                    (
                      padding: const EdgeInsets.all(24.0),
                      child: _resp['newOrders'].length > 0 ?  ListView(
                        // mainAxisAlignment: MainAxisAlignment.start,
                        // crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          for (Map<String,dynamic> item in _resp['newOrders'])
                            getVendorTile(OrderItems.fromJson(item)),
                        ],
                      ) : Center(
                        child: Text('No New Orders'),
                      )
                  ),
                ),
              ],
              staggeredTiles: [
                StaggeredTile.extent(2, 110.0),
                // StaggeredTile.extent(2, 110.0),
                StaggeredTile.extent(1, 180.0),
                StaggeredTile.extent(1, 180.0),
                StaggeredTile.extent(2, MediaQuery.of(context).size.height/2),
              ],
            ),
          ],
        )
    );
  }

  Widget _buildTile(Widget child, {Function() onTap}) {
    return Material(
        elevation: 14.0,
        borderRadius: BorderRadius.circular(12.0),
        shadowColor: Color(0x802196F3),
        child: InkWell
          (
          // Do onTap() if it isn't null, otherwise do print()
            onTap: onTap != null ? () => onTap() : () { print('Not set yet'); },
            child: child
        )
    );
  }

  Future<void> _getData() async {
    var resp  = await vendorBloc.vendorDashboard();

    if (resp['error'] == null) {
      setState(() {
        _resp = resp;
      });
    } else {
      setState(() {
        _error = resp;
      });
    }
  }

  getVendorTile(OrderItems item) {
    double width = MediaQuery.of(context).size.width;
    return InkWell(
      onTap: () => {

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
                  image: NetworkImage(fsDlEndpoint + item.product.images[0].link),
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
                      item.product.name,
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
                      item.buyerName,
                      maxLines: 1,
                      style: TextStyle(
                        color: Colors.teal,
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
                          'Quantity: ',
                          style: TextStyle(
                            fontSize: 12.0,

                            fontWeight: FontWeight.w700,
                            letterSpacing: 0.7,
                            color: AppColors.themeDark,
                          ),
                        ),
                        Text(
                          item.quantity.toString(),
                          style: TextStyle(
                            fontSize: 12.0,
                            fontWeight: FontWeight.w700,
                            letterSpacing: 0.7,
                            color: Colors.green,
                          ),
                        ),
                        Spacer(),
                        Text(
                          'Price: ',
                          style: TextStyle(
                            fontSize: 12.0,

                            fontWeight: FontWeight.w700,
                            letterSpacing: 0.7,
                            color: AppColors.themeDark,
                          ),
                        ),
                        Text(
                          '\$' + numberFormat.format(item.price),
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
                        InkWell(
                          child: Container(
                            width: width/4 - 20,
                            alignment: Alignment.center,
                            padding: EdgeInsets.all(5.0),
                            decoration: BoxDecoration(
                                color: Colors.teal,
                                borderRadius: BorderRadius.all(Radius.circular(10)),
                                border: Border.all(color: AppColors.themeRed, style: BorderStyle.solid)
                            ),
                            child: Text(
                              'Mark Shipped',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                  fontSize: 14.0, fontWeight: FontWeight.bold, color: AppColors.themeDark),
                            ),
                          ),
                          onTap: () {
                            
                          },
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
                              'Cancel Order',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                  fontSize: 14.0, fontWeight: FontWeight.bold, color: AppColors.themeDark),
                            ),
                          ),
                          onTap: () {
                            
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
    );
  }
}