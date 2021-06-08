import 'package:bloom/AppTheme/theme.dart';
import 'package:bloom/bloc/vendor.bloc.dart';
import 'package:bloom/data/entity/vendor.entity.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import 'category/top_offers_pages/get_products.dart';

class SearchPage extends StatefulWidget {
  @override
  _SearchPageState createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  List<Products> _result = [];
  bool _searching = false;
  bool _search = false;
  TextEditingController _controller = new TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: TextField(
          style: TextStyle(color: Colors.white),
          controller: _controller,
          decoration: InputDecoration(
            hintText: 'Search for Products',
            hintStyle: TextStyle(
              fontSize: 14.0,
              color: AppColors.themeDark,
            ),
            suffixIcon: IconButton(
              icon: Icon(Icons.search, color: AppColors.themeDark),
              onPressed: () {
                _searchTerm();
              },
            ),
            border: InputBorder.none,
            labelStyle: TextStyle(color: AppColors.themeDark),
          ),
        ),
        titleSpacing: 0.0,
        backgroundColor: AppColors.primaryColor,
        iconTheme: IconThemeData(color: AppColors.themeDark),
      ),
      body: (_result.length < 1 && !_search && !_searching) ?
        Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            SizedBox(
              height: 10.0,
            ),
            Text(
              'Search for products',
              style: TextStyle(color: Colors.grey),
            ),
            SizedBox(
              height: 10.0,
            ),
          ],
        ),
      )
          : (_result.length < 1 && _search && !_searching) ?
        Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Icon(
                FontAwesomeIcons.search,
                color: Colors.grey,
                size: 60.0,
              ),
              SizedBox(
                height: 10.0,
              ),
              Text(
                'The are no products matching your search query!',
                style: TextStyle(color: Colors.grey),
              ),
              SizedBox(
                height: 10.0,
              ),
            ],
          ),
        ) : _searching ? Center(
          child: SpinKitCircle(color: AppColors.secondaryColor),
        ) : ListView(
          physics: BouncingScrollPhysics(),
          shrinkWrap: true,
          children: <Widget>[
            Container(
              padding: EdgeInsets.all(10),
              child: Text(
                'Results for: ' + _controller.text,
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.grey),
              ),
            ),
            Container(
                margin: EdgeInsets.only(top: 10.0),
                child: ProductsGridView(products: _result)),
          ],
      ),
    );
  }

  Future<void> _searchTerm() async {
    if (_controller.text == null || _controller.text.isEmpty ) {
      Fluttertoast.showToast(msg: "Enter search parameter");
      return;
    }

    setState(() {
      _searching = true;
    });

    var response = await vendorBloc.search(_controller.text);
    if (response.data != null) {
      setState(() {
        _result = response.data;
        _search = true;
        _searching = false;
      });
    } else {
      setState(() {
        _search = true;
        _searching = false;
      });
    }
  }
}
