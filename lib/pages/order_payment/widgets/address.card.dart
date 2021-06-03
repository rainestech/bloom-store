import 'package:auto_size_text/auto_size_text.dart';
import 'package:bloom/Animation/slide_left_rout.dart';
import 'package:bloom/AppTheme/theme.dart';
import 'package:bloom/data/entity/personnel.entity.dart';
import 'package:bloom/data/entity/vendor.entity.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../delivery_address.dart';

class AddressCard extends StatefulWidget {
  final Person person;
  final List<Cart> cart;

  const AddressCard({Key key, this.person, this.cart}) : super(key: key);
  @override
  _AddressCardState createState() => _AddressCardState();
}

class _AddressCardState extends State<AddressCard> {
  Person _person;
  Address _address;

  @override
  void initState() {
    super.initState();
    setState(() {
      _person = widget.person;
      _address = (widget.person.addresses != null && widget.person.addresses.length > 0) ? widget.person.addresses.firstWhere((e) => e.type == 'shipping') : null;
    });
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    
    return _address != null ?
      Container(
      width: width,
      margin: EdgeInsets.all(10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text('Shipping Address',
                style: TextStyle(
                  color: AppColors.themeDark,
                  fontWeight: FontWeight.bold,
                  fontSize: 20,
                ),
              ),
              Spacer(),
              Container(
                // margin: EdgeInsets.only(top: 10, bottom: 10),
                decoration: BoxDecoration(
                  color: Colors.amber,
                  borderRadius: BorderRadius.circular(5),
                ),
                child: IconButton(
                  onPressed: () {
                    Navigator.push(
                        context, SlideLeftRoute(page: Delivery(person: widget.person, address: _address, cart: widget.cart)));
                  },
                  icon: Icon(Icons.edit,
                    size: 24, color: Colors.black, ),
                ),
              ),
            ],
          ),
          SizedBox(height: 10,),
          Text(widget.person.name,
            style: TextStyle(
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 10,),
          Text(_address.address),
          SizedBox(height: 10,),
          Row(
            children: [
              Text('City: '),
              Spacer(),
              Text(_address.city),
            ],
          ),
          SizedBox(height: 10,),
          Row(
            children: [
              Text('Province/State: '),
              Spacer(),
              Text(_address.province),
            ],
          ),
          SizedBox(height: 10,),
          Row(
            children: [
              Text('Country: '),
              Spacer(),
              Text(_address.country.name),
            ],
          ),
          SizedBox(height: 10,),
          Row(
            children: [
              Text('Postal Code: '),
              Spacer(),
              Text(_address.postalcode),
            ],
          ),
          SizedBox(height: 10,),
          Row(
            children: [
              Text('Phone No.: '),
              Spacer(),
              Text(_person.phone),
            ],
          ),
        ],
      ),
    ) :
      Container(
      width: width,
      margin: EdgeInsets.all(10),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Icon(
            Icons.local_shipping_outlined,
            color: Colors.grey,
            size: 60.0,
          ),
          SizedBox(
            height: 15.0,
          ),
          AutoSizeText(
            'Add Shipping Address',
            style: TextStyle(
              color: AppColors.themeRed,
              fontSize: 18.0,
              fontFamily: 'Signika Negative',
              fontWeight: FontWeight.w700,
            ),
          ),
          SizedBox(height: 10,),
          Container(
            width: double.infinity,
            alignment: Alignment.center,
            child: InkWell(
              onTap: () {
                Navigator.push(
                    context, SlideLeftRoute(page: Delivery(person: widget.person, address: _address, cart: widget.cart)));
              },
              borderRadius: BorderRadius.circular(30.0),
              child: Material(
                elevation: 1.0,
                borderRadius: BorderRadius.circular(30.0),
                child: Container(
                  padding: EdgeInsets.fromLTRB(40.0, 15.0, 40.0, 15.0),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(30.0),
                    color: AppColors.themeDark,
                  ),
                  child: Text(
                    'Add Address',
                    style: TextStyle(
                      color: AppColors.white,
                      fontSize: 15.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}