import 'package:auto_size_text/auto_size_text.dart';
import 'package:bloom/AppTheme/theme.dart';
import 'package:bloom/bloc/vendor.bloc.dart';
import 'package:bloom/helpers/helper.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';

class Dashboard extends StatefulWidget
{
  @override
  _DashboardState createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard>
{
  Map<String, dynamic> _error;
  Map<String, dynamic> _resp = {};

  static final List<String> chartDropdownItems = [ 'Last 7 days', 'Last month', 'Last year' ];
  String actualDropdown = chartDropdownItems[0];
  int actualChart = 0;

  @override
  void initState() {
    super.initState();
    _getData();
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
                        image: AssetImage('assets/bloom.png'),
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                ),
          ),
          title: Text(
            'Bloom Admin',
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
                                Text('Total Vendors', style: TextStyle(color: Colors.redAccent)),
                                Text(_resp['totalVendors'] != null ? _resp['totalVendors'].toString() : '..', style: TextStyle(color: Colors.black, fontWeight: FontWeight.w700, fontSize: 34.0))
                              ],
                            ),
                            Material
                              (
                                color: Colors.red,
                                borderRadius: BorderRadius.circular(24.0),
                                child: Center
                                  (
                                    child: Padding
                                      (
                                      padding: EdgeInsets.all(16.0),
                                      child: Icon(Icons.store, color: Colors.white, size: 30.0),
                                    )
                                )
                            )
                          ]
                      ),
                    ),
                    onTap: () => {},
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
                            Text(_resp['totalSales'] != null ? _resp['totalSales'] : '..', style: TextStyle(color: Colors.black, fontWeight: FontWeight.w700, fontSize: 24.0)),
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
                            Text(_resp['unclaimed'] != null ? _resp['unclaimed'].toString() : '..', style: TextStyle(color: Colors.black, fontWeight: FontWeight.w700, fontSize: 24.0)),
                            Text('Unclaimed Sales', style: TextStyle(color: Colors.black45)),
                          ]
                      ),
                    ),
                  ),
                  if (_resp['vendorClaims'] != null)
                    _buildTile(
                      Padding
                        (
                          padding: const EdgeInsets.all(24.0),
                          child: ListView(
                            // mainAxisAlignment: MainAxisAlignment.start,
                            // crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              for (Map<String,dynamic> vendor in _resp['vendorClaims'])
                                _loanList(vendor),
                            ],
                          )
                      ),
                    ),
                ],
              staggeredTiles: [
                StaggeredTile.extent(2, 110.0),
                StaggeredTile.extent(2, 110.0),
                StaggeredTile.extent(1, 180.0),
                StaggeredTile.extent(1, 180.0),
                StaggeredTile.extent(2, MediaQuery.of(context).size.height/2),
              ],
              ),
            // if (_resp['vendorClaims'] != null)
            //     for (Map<String,dynamic> vendor in _resp['vendorClaims'])
            //       _buildTile(
            //           Padding(
            //             padding: const EdgeInsets.all(24.0),
            //             child: _loanList(vendor),
            //           )
            //       ),
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

  _loanList(Map<String, dynamic> vendor) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        // Background for card
        Padding(
          padding: const EdgeInsets.fromLTRB(20, 8, 20, 20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              SizedBox(
                height: 5,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Container(
                    height: 30,
                    child: Center(
                      child: Text(
                        'Vendor: ',
                        style: TextStyle(
                            color: Colors.black,
                            fontSize: 14,
                            fontWeight: FontWeight.w500),
                      ),
                    ),
                  ),
                  Expanded(
                    child: Align(
                      alignment: Alignment.centerRight,
                      child: AutoSizeText(
                        vendor['vendorName'],
                        maxLines: 2,
                        textAlign: TextAlign.end,
                        style: TextStyle(
                            color: Colors.blue,
                            fontSize: 17,
                            fontWeight: FontWeight.w500),
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(
                height: 8,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Container(
                    height: 20,
                    child: Center(
                      child: Text(
                        'Total: ',
                        style: TextStyle(
                            color: Colors.black,
                            fontSize: 16,
                            fontWeight: FontWeight.w500),
                      ),
                    ),
                  ),
                  Expanded(
                    child: Align(
                      alignment: Alignment.centerRight,
                      child: Text(
                        '\$${numberFormat.format(double.parse(vendor['total']))}',
                        style: TextStyle(
                            color: Colors.blue,
                            fontSize: 16,
                            fontWeight: FontWeight.w500),
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(
                height: 7,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Container(
                    height: 18,
                    child: Center(
                      child: Text(
                        'Unclaimed: ',
                        style: TextStyle(
                            color: Colors.black,
                            fontSize: 14,
                            fontWeight: FontWeight.w500),
                      ),
                    ),
                  ),
                  Expanded(
                    child: Align(
                      alignment: Alignment.centerRight,
                      child: Text(
                        '\$${numberFormat.format(double.parse(vendor['delivered'].toString()) - double.parse(vendor['claimed'].toString()))}',
                        style: TextStyle(
                            color: Colors.blue,
                            fontSize: 14,
                            fontWeight: FontWeight.w500),
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(
                height: 10,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Container(
                    height: 18,
                    child: Center(
                      child: Text(
                        'Locked: ',
                        style: TextStyle(
                            color: Colors.black,
                            fontSize: 14,
                            fontWeight: FontWeight.w500),
                      ),
                    ),
                  ),
                  Expanded(
                    child: Align(
                      alignment: Alignment.centerRight,
                      child: Text(
                        '\$${numberFormat.format(double.parse(vendor['total'].toString()) - (double.parse(vendor['delivered'].toString()) + double.parse(vendor['claimed'].toString())))}',
                        style: TextStyle(
                            color: Colors.blue,
                            fontSize: 14,
                            fontWeight: FontWeight.w500),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        )
      ],
    );
  }



  Future<void> _getData() async {
    var resp  = await vendorBloc.dashboard();
    setState(() {
      if (resp['error'] == null) {
      }
    });

    if (resp['error'] == null) {

      // List<List<double>> res = [];
      // List<double> temp = [];
      // for (Map<String, dynamic> w in resp['weekSales']) {
      //   temp.add(double.parse(w['sales'].toString()));
      // }
      // res.insert(0, temp);
      //
      // List<double> mTemp = [];
      // for (Map<String, dynamic> w in resp['monthSales']) {
      //   mTemp.add(double.parse(w['sales'].toString()));
      // }
      // res.insert(1, mTemp);
      //
      // List<double> yTemp = [];
      // for (Map<String, dynamic> w in resp['yearSales']) {
      //   yTemp.add(double.parse(w['sales'].toString()));
      // }
      // res.insert(2, yTemp);
      //
      // print(res.toString());
      setState(() {
        _resp = resp;
      });
    } else {
      setState(() {
        _error = resp;
      });
    }
  }
}