import 'package:bloom/AppTheme/theme.dart';
import 'package:bloom/bloc/vendor.bloc.dart';
import 'package:bloom/data/entity/vendor.entity.dart';
import 'package:bloom/data/http/endpoints.dart';
import 'package:bloom/pages/category/top_offers_pages/get_products.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';


class CategoryGrid extends StatefulWidget {
  @override
  _CategoryGridState createState() => _CategoryGridState();
}

class _CategoryGridState extends State<CategoryGrid> with WidgetsBindingObserver {
  List<Category> _categories = [];

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      vendorBloc.getCategories();
    }
  }

  @override
  void initState() {
    super.initState();
    vendorBloc.getCategories();
    vendorBloc.categoryListSubject.listen((value) {
      if(!mounted) {
        return;
      }

      setState(() {
        if (value.data != null) {
          _categories = value.data;
        }
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    if (_categories.length < 1) {
      vendorBloc.getCategories();
    }

    InkWell getStructuredGridCell(Category category) {
      final item = category;
      return InkWell(
        child: Container(
          padding: EdgeInsets.all(10),
          child: Image(
            image: NetworkImage(fsDlEndpoint + item.icon.link),
            fit: BoxFit.fitHeight,
          ),
        ),
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => GetProducts(category: item)),
          );
        },
      );
    }

    if (_categories.length < 1) {
      return Center(
        child: Container(
          padding: EdgeInsets.all(50),
          child: SpinKitCircle(color: AppColors.primaryColor,),
        ),
      );
    } else {
      return Container(
        decoration: BoxDecoration(
          color: Colors.white,
        ),
        padding: EdgeInsets.all(5.0),
        alignment: Alignment.center,
        width: width - 20.0,
        child: GridView.count(
          primary: false,
          shrinkWrap: true,
          padding: const EdgeInsets.all(0),
          crossAxisSpacing: 0,
          mainAxisSpacing: 15,
          crossAxisCount: 4,
          childAspectRatio: ((width) / 500),
          children: List.generate(_categories.length, (index) {
            return getStructuredGridCell(_categories[index]);
          }),
        ),
      );
    }
  }
}
