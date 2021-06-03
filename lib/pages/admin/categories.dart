import 'package:auto_size_text/auto_size_text.dart';
import 'package:bloom/AppTheme/theme.dart';
import 'package:bloom/bloc/vendor.bloc.dart';
import 'package:bloom/data/entity/vendor.entity.dart';
import 'package:bloom/data/http/endpoints.dart';
import 'package:bloom/data/http/vendor.provider.dart';
import 'package:bloom/helpers/helper.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

import 'add.category.dart';

class CategoryScreen extends StatefulWidget {
  @override
  _CategoryScreenState createState() => _CategoryScreenState();
}

class _CategoryScreenState extends State<CategoryScreen> {
  @override
  void initState() {
    super.initState();
    vendorBloc.getCategories();
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;

    getCategoryTile(Category category) {
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
                  _delete(category);
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
                      MaterialPageRoute(builder: (context) => AddCategoryPage(category: category,)));
                },
              ),
            ),
          ],
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
                    image: NetworkImage(fsDlEndpoint + category.icon.link),
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
                        category.name,
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
                      padding: EdgeInsets.only(
                          top: 0.0, right: 8.0, left: 8.0, bottom: 8.0),
                      child: Row(
                        children: [
                          Text(
                            'Status: ',
                            style: TextStyle(
                              fontSize: 12.0,

                              fontWeight: FontWeight.w700,
                              letterSpacing: 0.7,
                              color: Colors.green,
                            ),
                          ),
                          Text(
                            category.catActive ? 'Active' : 'Not Active',
                            style: TextStyle(
                              fontSize: 12.0,
                              fontWeight: FontWeight.w700,
                              letterSpacing: 0.7,
                              color: AppColors.primaryColor,
                            ),
                          ),
                          Spacer(),
                          Text(
                            'Order No: ',
                            style: TextStyle(
                              fontSize: 12.0,

                              fontWeight: FontWeight.w700,
                              letterSpacing: 0.7,
                              color: AppColors.themeDark,
                            ),
                          ),
                          Text(
                            category.catOrder.toString(),
                            style: TextStyle(
                              fontSize: 12.0,

                              fontWeight: FontWeight.w700,
                              letterSpacing: 0.7,
                              color: AppColors.primaryColor,
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
      );
    }

    Widget _listCategoriesWidget(List<Category> data, double width, double height) {
      return ListView(
        children: [
          for (Category item in data)
            getCategoryTile(item),
        ],
      );
    }

    Widget _noCategory(double width, double height) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Icon(
              Icons.dnd_forwardslash,
              color: Colors.green,
              size: 60.0,
            ),
            SizedBox(
              height: 20.0,
            ),
            AutoSizeText(
              'No Category Added Yet!',
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
            'Product Categories',
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
                    MaterialPageRoute(builder: (context) => AddCategoryPage(category: null,)));
              },
            ),
          ],
        ),
        body: StreamBuilder<CategoryListResponse>(
            stream: vendorBloc.categoryListSubject.stream,
            builder: (context, AsyncSnapshot<CategoryListResponse> snapshot) {
              if (snapshot.hasData) {
                if (snapshot.data.error != null &&
                    (snapshot.data.error.length > 0 || snapshot.data.eTitle.length > 0)) {
                  if (snapshot.data.eTitle.toLowerCase() == 'forbidden') {
                    unAuthorizedError(context);
                    // return null;
                  }
                  return HttpErrorWidget(snapshot.data.error.length > 0 ? snapshot.data.error : snapshot.data.eTitle, width, height);
                }

                if (snapshot.data.data.length < 1) {
                  return _noCategory(width, height);
                }
                return _listCategoriesWidget(snapshot.data.data, width, height);
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

  void _delete(Category category) {
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
          content: Text("Are you Sure you want to delete ${category.name} product category?"),
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
                deleteCategory(category);
              },
            ),
          ],
        );
      },
    );
  }

  Future<void> deleteCategory(Category category) async {
    EasyLoading.show(status: 'Deleting Product Category...');
    var resp = await vendorBloc.deleteCategory(category);
    EasyLoading.dismiss();

    if (resp.data != null) {
      EasyLoading.showSuccess('Category Deleted', duration: Duration(seconds: 5));
    } else {
      EasyLoading.showError('An Error Occurred, Please try again', duration: Duration(seconds: 5));
    }
  }
}