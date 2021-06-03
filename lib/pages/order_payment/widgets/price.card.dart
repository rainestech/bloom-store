import 'package:bloom/data/entity/vendor.entity.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class PriceDetailsCard extends StatelessWidget {
  final List<Cart> cart;

  const PriceDetailsCard({Key key, this.cart}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width * 0.7;

    return Container(
      width: width,
      margin: EdgeInsets.all(10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text('Sub-Total: '),
              Spacer(),
              Text(_getTotal(cart, 'sub')),
            ],
          ),
          SizedBox(height: 10,),
          Row(
            children: [
              Text('Value Added Tax (VAT): '),
              Spacer(),
              Text(_getTotal(cart, 'vat')),
            ],
          ),
          SizedBox(height: 10,),
          Row(
            children: [
              Text('Delivery Charges : '),
              Spacer(),
              Text(_getDeliveryCharges(cart, 'local')),
            ],
          ),
          SizedBox(height: 10,),
          SizedBox(height: 10,),
        ],
      ),
    );
  }

  String _getDeliveryCharges(List<Cart> cart, String type) {
    if (cart.length > 0) {
      return cart.fold(0.0, (sum, item) => sum + item.shipping).toString();
    }

    return '0';
  }

  String _getTotal(List<Cart> cart, String type) {
    if (cart.length > 0 && type == 'sub') {
      return cart.fold(0.0, (sum, item) => sum + item.price).toString();
    } else if (cart.length > 0 && type != 'sub') {
      return (cart.fold(0.0, (sum, item) => sum + item.price) * 0.05).toString();
    }

    return '0';
  }

}