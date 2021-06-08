import 'package:bloom/AppTheme/theme.dart';
import 'package:bloom/bloc/vendor.bloc.dart';
import 'package:bloom/data/entity/vendor.entity.dart';
import 'package:bloom/data/http/endpoints.dart';
import 'package:bloom/data/http/vendor.provider.dart';
import 'package:bloom/helpers/helper.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

import '../container.dart';

class MyOrders extends StatefulWidget {
  @override
  _MyOrdersState createState() => _MyOrdersState();
}

class _MyOrdersState extends State<MyOrders> {
  List<OrderItems> _orderItems = [];
  OrderListResponse _orders;

  @override
  void initState() {
    super.initState();
    vendorBloc.myOrders();
    vendorBloc.orderListSubject.listen((value) {
      if (!mounted) {
        return;
      }

      if (value.data != null) {
        this.setOrders(value.data);
      }

      setState(() {
        _orders = value;
      });
    });
  }

  @override
  Widget build(BuildContext context) {

    Container _checkStatus(status) {
      if (status == 'paid') {
        return Container(
          padding: EdgeInsets.all(5.0),
          decoration: BoxDecoration(
            color: Colors.blue,
            borderRadius: BorderRadius.only(topRight: Radius.circular(5.0)),
          ),
          child: Text(
            'Item Shipped',
            style: TextStyle(color: Colors.white, fontSize: 12.0),
          ),
        );
      } else if (status == 'pending') {
        return Container(
          padding: EdgeInsets.all(5.0),
          decoration: BoxDecoration(
            color: Colors.orange,
            borderRadius: BorderRadius.only(topRight: Radius.circular(5.0)),
          ),
          child: Text(
            'Pending Payment',
            style: TextStyle(color: Colors.white, fontSize: 12.0),
          ),
        );
      } else {
        return Container(
          padding: EdgeInsets.all(5.0),
          decoration: BoxDecoration(
            color: Colors.green,
            borderRadius: BorderRadius.only(topRight: Radius.circular(5.0)),
          ),
          child: Text(
            'Delivered',
            style: TextStyle(color: Colors.white, fontSize: 12.0),
          ),
        );
      }
    }

    return Scaffold(
      appBar: AppBar(
        title: Text('My Orders', style: TextStyle(
          color: AppColors.themeDark,
        ),),
        titleSpacing: 0.0,
        backgroundColor: AppColors.primaryColor,
        iconTheme: IconThemeData(color: AppColors.themeDark),      ),
      body: _orders == null ? Center(child: SpinKitCircle(color: AppColors.secondaryColor))
          : _orders != null && _orderItems.length < 1 ?
            Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  SizedBox(
                    height: 10.0,
                  ),
                  Text(
                    'You have no ordered Items',
                    style: TextStyle(color: Colors.grey),
                  ),
                  SizedBox(
                    height: 10.0,
                  ),
                  TextButton(
                    child: Text(
                      'Shop for Items',
                      style: TextStyle(color: Colors.white),
                    ),
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => ScreenContainer(3)),
                      );
                    },
                  )
                ],
              ),
            ) :
            ListView.builder(
              itemCount: _orderItems.length,
              itemBuilder: (context, index) {
                final item = _orderItems[index];
                return Container(
                  height: 180.0,
                  child: Card(
                      elevation: 5.0,
                      child: Stack(
                        children: <Widget>[
                          Positioned(
                            top: 0,
                            right: 0,
                            child: _checkStatus(item.status),
                          ),
                          Padding(
                            padding: EdgeInsets.all(5.0),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: <Widget>[
                                    Column(
                                      crossAxisAlignment: CrossAxisAlignment.center,
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: <Widget>[
                                        Container(
                                          width: 120.0,
                                          height: 160.0,
                                          alignment: Alignment.center,
                                          child: Image(
                                            image: NetworkImage(fsDlEndpoint + item.product.images[0].link),
                                            fit: BoxFit.fitHeight,
                                          ),
                                        ),
                                      ],
                                    ),
                                    Expanded(
                                      child: Container(
                                        padding: EdgeInsets.all(10.0),
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          mainAxisAlignment: MainAxisAlignment.center,
                                          children: <Widget>[
                                            Text(
                                              '${item.product.name}',
                                              style: TextStyle(
                                                fontSize: 15.0,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                            SizedBox(
                                              height: 7.0,
                                            ),
                                            Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.start,
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
                                                  '\$${numberFormat.format(item.price)}',
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
                                            Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.start,
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.center,
                                              children: <Widget>[
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
                                                SizedBox(
                                                  width: 10.0,
                                                ),
                                              ],
                                            ),
                                            SizedBox(
                                              height: 7.0,
                                            ),
                                            if(item.status == 'pending')
                                            Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.start,
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.center,
                                              children: <Widget>[
                                                InkWell(
                                                  onTap: () {},
                                                  child: Container(
                                                    padding: EdgeInsets.all(8.0),
                                                    decoration: BoxDecoration(
                                                      color: AppColors.themeRed,
                                                      borderRadius: BorderRadius.all(Radius.circular(5.0)),
                                                    ),
                                                    child: Text(
                                                      'Cancel Order',
                                                      style: TextStyle(color: Colors.white, fontSize: 14.0),
                                                    ),
                                                  )
                                                ),
                                                Spacer(),
                                                InkWell(
                                                    onTap: () {},
                                                    child: Container(
                                                      padding: EdgeInsets.all(8.0),
                                                      decoration: BoxDecoration(
                                                        color: Colors.green,
                                                        borderRadius: BorderRadius.all(Radius.circular(5.0)),
                                                      ),
                                                      child: Text(
                                                        'Pay',
                                                        style: TextStyle(color: Colors.white, fontSize: 14.0),
                                                      ),
                                                    )
                                                ),
                                              ],
                                            ),
                                            if(item.status == 'paid')
                                            Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.start,
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.center,
                                              children: <Widget>[
                                                InkWell(
                                                  onTap: () {},
                                                  child: Container(
                                                    padding: EdgeInsets.all(8.0),
                                                    decoration: BoxDecoration(
                                                      color: AppColors.themeRed,
                                                      borderRadius: BorderRadius.all(Radius.circular(5.0)),
                                                    ),
                                                    child: Text(
                                                      'Open Dispute',
                                                      style: TextStyle(color: Colors.white, fontSize: 14.0),
                                                    ),
                                                  )
                                                ),
                                                Spacer(),
                                                InkWell(
                                                    onTap: () {},
                                                    child: Container(
                                                      padding: EdgeInsets.all(8.0),
                                                      decoration: BoxDecoration(
                                                        color: Colors.green,
                                                        borderRadius: BorderRadius.all(Radius.circular(5.0)),
                                                      ),
                                                      child: Text(
                                                        'Mark as Delivered',
                                                        style: TextStyle(color: Colors.white, fontSize: 14.0),
                                                      ),
                                                    )
                                                ),
                                              ],
                                            ),
                                          ],
                                        ),
                                      ),
                                    )
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ],
                      )),
                );
              },
            ),
    );
  }

  void setOrders(List<Orders> data) {
    List<OrderItems> items = [];
    for(Orders o in data) {
      items.addAll(o.items);
    }

    setState(() {
      _orderItems = items;
    });
  }
}
