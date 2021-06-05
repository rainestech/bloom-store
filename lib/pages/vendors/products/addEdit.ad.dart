import 'package:bloom/AppTheme/theme.dart';
import 'package:bloom/bloc/person.bloc.dart';
import 'package:bloom/bloc/user.bloc.dart';
import 'package:bloom/bloc/vendor.bloc.dart';
import 'package:bloom/data/entity/admin.entity.dart';
import 'package:bloom/data/entity/vendor.entity.dart';
import 'package:bloom/data/http/endpoints.dart';
import 'package:bloom/data/http/persons.provider.dart';
import 'package:bloom/data/http/vendor.provider.dart';
import 'package:flutter/material.dart';
import 'package:bloom/Animation/fadeIn.dart';
import 'package:bloom/helpers/form.validators.dart';
import 'package:bloom/helpers/helper.dart';
import 'package:dio/dio.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart';
import 'package:mime/mime.dart';

class AddEditAdPage extends StatefulWidget {
  final Ads ad;

  const AddEditAdPage({Key key, @required this.ad}) : super(key: key);
  @override
  _AddEditAdPageState createState() => _AddEditAdPageState();
}

class _AddEditAdPageState extends State<AddEditAdPage> {
  FocusNode _statusFocus = FocusNode();

  final ImagePicker picker = ImagePicker();
  final _formKey = GlobalKey<FormState>();
  final List<String> _status = ['category', 'product'];
  Ads _ad;
  PassportResponse _image;
  bool _uploadingImage = false;
  String _adLink = 'product';
  User _user;
  List<Category> _categories = [];
  List<Products> _products = [];

  void _showPicker(context) {
    showModalBottomSheet(
        context: context,
        builder: (BuildContext bc) {
          return SafeArea(
            child: Container(
              child: new Wrap(
                children: <Widget>[
                  new ListTile(
                      leading: new Icon(Icons.photo_library),
                      title: new Text('Photo Library'),
                      onTap: () {
                        _imgFromGallery();
                        Navigator.of(context).pop();
                      }),
                  new ListTile(
                    leading: new Icon(Icons.photo_camera),
                    title: new Text('Camera'),
                    onTap: () {
                      _imgFromCamera();
                      Navigator.of(context).pop();
                    },
                  ),
                ],
              ),
            ),
          );
        });
  }

  @override
  void initState() {
    super.initState();
    setState(() {
      _ad = widget.ad != null ? widget.ad : new Ads();
    });

    userBloc.userSubject.listen((value) {
      if (!mounted) {
        return;
      }

      setState(() {
        _user = value.data;
      });
    });

    vendorBloc.categoryListSubject.listen((value) {
      if (!mounted)
        return;

      setState(() {
        if (value.data != null) {
          _categories = value.data;
        }
      });
    });

    vendorBloc.productListSubject.listen((value) {
      if (!mounted)
        return;

      setState(() {
        if (value.data != null) {
          _products = value.data;
        }
      });
    });

    vendorBloc.getMyProducts();
    vendorBloc.getCategories();
    userBloc.getUser();
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;

    return Scaffold(
      appBar: AppBar(
        title: Text(
            widget.ad == null ? 'Add New Advertisement' : 'Edit Advertisement'
        ),
        titleSpacing: 0.0,
        backgroundColor: AppColors.primaryColor,
      ),
      body: ListView(
        shrinkWrap: true,
        children: <Widget>[
          SizedBox(height: 40.0),
          Container(
            alignment: Alignment.center,
            margin: EdgeInsets.only(right: 20.0, left: 20.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                FadeIn(
                  1.2,
                  Container(
                    width: width - 20,
                    height: 80.0,
                    color: Colors.transparent,
                    alignment: Alignment.topCenter,
                    child: GestureDetector(
                      onTap: () {
                        _showPicker(context);
                      },
                      child: _uploadingImage ? CircularProgressIndicator() : DecoratedBox(
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(width: 5.0, color: Colors.white),
                        ),
                        child: _ad != null && _ad.image != null ?
                        Container(
                          decoration: BoxDecoration(
                            color: Colors.grey[200],
                            borderRadius: BorderRadius.circular(20),
                            image: DecorationImage(
                              image: NetworkImage(fsDlEndpoint + _ad.image.link),
                              fit: BoxFit.cover,
                            ),
                          ),
                          width: width - 30,
                          height: 100,
                        ) : Container(
                          decoration: BoxDecoration(
                            color: Colors.grey[200],
                            borderRadius: BorderRadius.circular(20),
                          ),
                          width: width - 30,
                          height: 100,
                          child: Icon(
                            Icons.cloud_upload_outlined, size: 50, color: AppColors.secondaryColor,
                          ),
                        )
                      ),
                    ),
                  ),

                ),
                FadeIn(
                  1.2,
                  Container(
                    alignment: Alignment.topCenter,
                    child: Text(
                      'Tap to ' + (_ad.image == null ? 'Add Ad Image' : 'Change Ad Image'),
                      style: TextStyle(
                        color: Colors.grey[600]
                      ),
                    ),
                  )
                ),
                SizedBox(
                  height: 10.0,
                ),
                Form(
                  key: _formKey,
                  child:
                  Container(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        if (_user != null && _user.isAdmin)
                        FadeIn(
                            1.6,
                            DropdownButtonFormField<String>(
                              focusNode: _statusFocus,
                              isExpanded: true,
                              value: null,
                              hint: Text("Ad Link to"),
                              icon: const Icon(Icons.arrow_downward),
                              iconSize: 24,
                              elevation: 16,
                              style: TextStyle(color: Colors.black),
                              onChanged: (String newValue) {
                                setState(() {
                                  _adLink = newValue;
                                });
                              },
                              validator: (value) {
                                return Validator.required(
                                    value, 3,
                                    'Ad Link type is required');
                              },
                              items: _status
                                  .map<DropdownMenuItem<String>>((String value) {
                                return DropdownMenuItem<String>(
                                  value: value,
                                  child: Text(value.toUpperCase()),
                                );
                              }).toList(),
                            )
                        ),
                        if (_adLink == 'product')
                        FadeIn(
                            1.6,
                            DropdownButtonFormField<Products>(
                              isExpanded: true,
                              value: _ad.product,
                              hint: Text("Select Product to Link"),
                              icon: const Icon(Icons.arrow_downward),
                              iconSize: 24,
                              elevation: 16,
                              style: TextStyle(color: Colors.black),
                              onChanged: (Products newValue) {
                                setState(() {
                                  _ad.product = newValue;
                                });
                              },
                              validator: (value) {
                                return Validator.required(
                                    value.name, 3,
                                    'Product is required');
                              },
                              items: _products
                                  .map<DropdownMenuItem<Products>>((Products value) {
                                return DropdownMenuItem<Products>(
                                  value: value,
                                  child: Text(value.name),
                                );
                              }).toList(),
                            )
                        ),
                        if(_adLink != 'product')
                        FadeIn(
                            1.6,
                            DropdownButtonFormField<Category>(
                              isExpanded: true,
                              value: _ad.category,
                              hint: Text("Select Category to Link"),
                              icon: const Icon(Icons.arrow_downward),
                              iconSize: 24,
                              elevation: 16,
                              style: TextStyle(color: Colors.black),
                              onChanged: (Category newValue) {
                                setState(() {
                                  _ad.category = newValue;
                                });
                              },
                              validator: (value) {
                                return Validator.required(
                                    value.name, 3,
                                    'Category is required');
                              },
                              items: _categories
                                  .map<DropdownMenuItem<Category>>((Category value) {
                                return DropdownMenuItem<Category>(
                                  value: value,
                                  child: Text(value.name),
                                );
                              }).toList(),
                            )
                        ),
                      ],
                    ),
                  ),
                ),
                SizedBox(
                  height: 50.0,
                ),
                FadeIn(
                  2.0,
                  InkWell(
                    child: Container(
                      height: 45.0,
                      child: Material(
                        borderRadius: BorderRadius.circular(20.0),
                        shadowColor: Colors.grey[300],
                        color: Colors.white,
                        borderOnForeground: false,
                        elevation: 5.0,
                        child: GestureDetector(
                          child: Center(
                            child: Text(
                              "Save Ad",
                              style: TextStyle(
                                fontFamily: 'Alatsi',
                                color: Theme.of(context).primaryColor,
                                fontSize: 16.0,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                    onTap: () {
                      if (_formKey.currentState.validate()) {
                        _formKey.currentState.save();
                        submitDetails(context);
                      }
                    },
                  ),
                ),
                SizedBox(
                  height: 15.0,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Future<void> submitDetails(BuildContext context,) async {
    try {
      if (_image == null && _ad.image == null) {
        Fluttertoast.showToast(msg: 'Upload Ad Image', toastLength: Toast.LENGTH_LONG);
        return;
      }
      EasyLoading.show(status: 'Saving Ad...', maskType: EasyLoadingMaskType.black);

      AdsResponse _response = await vendorBloc.saveAds(_ad);
      if (_response.data == null) {
        EasyLoading.dismiss();

        ServerValidationDialog.errorDialog(
            context, _response.error, _response.eTitle); //invoking log
      } else {
        EasyLoading.dismiss();
        EasyLoading.showSuccess('Ad Saved', maskType: EasyLoadingMaskType.black, duration: Duration(seconds: 5));

        Navigator.of(context).pop();
      }
    } catch (error) {
      EasyLoading.dismiss();
      ServerValidationDialog.errorDialog(
          context, error.toString(), ''); //invoking log
    }
  }

  void _imgFromCamera() async {
    PickedFile image =
    await picker.getImage(source: ImageSource.camera, imageQuality: 50);

    if (image == null) return;
    saveImage(image);
  }

  void _imgFromGallery() async {
    PickedFile image =
    await picker.getImage(source: ImageSource.gallery, imageQuality: 50);

    if (image == null) return;
    saveImage(image);
  }

  saveImage(PickedFile file) async {
    setState(() {
      _uploadingImage = true;
    });

    if (_ad.image == null) {
      FormData formData = FormData.fromMap({
        'name': basename(file.path),
        'fileType': lookupMimeType(file.path),
        'tag': 'passport',
        'objID': _ad != null ? _ad.id : 0,
        'file': await MultipartFile.fromFile(file.path, filename: basename(file.path))
      });

      personBloc.savePassport(formData).then((value) => {
        if (value.data != null) {
          setState(() {
            _ad.image = value.data;
            _image = value;
            _uploadingImage = false;
          }),
        }
      });
    } else {
      FormData formData = FormData.fromMap({
        'id': _ad.image.id,
        'name': basename(file.path),
        'fileType': lookupMimeType(file.path),
        'tag': 'passport',
        'objID': _ad != null ? _ad.id : 0,
        'file': await MultipartFile.fromFile(file.path, filename: basename(file.path))
      });

      personBloc.editPassport(formData).then((value) => {
        setState(() {
          _ad.image = value.data;
          _image = value;
          _uploadingImage = false;
        }),
      });
    }
  }
}
