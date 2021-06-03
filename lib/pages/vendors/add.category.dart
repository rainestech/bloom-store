import 'package:bloom/AppTheme/theme.dart';
import 'package:bloom/bloc/person.bloc.dart';
import 'package:bloom/bloc/vendor.bloc.dart';
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

class AddCategoryPage extends StatefulWidget {
  final Category category;

  const AddCategoryPage({Key key, @required this.category}) : super(key: key);
  @override
  _AddCategoryState createState() => _AddCategoryState();
}

class _AddCategoryState extends State<AddCategoryPage> {
  FocusNode _nameFocus = FocusNode();
  FocusNode _orderFocus = FocusNode();
  FocusNode _statusFocus = FocusNode();

  final ImagePicker picker = ImagePicker();
  final _formKey = GlobalKey<FormState>();
  final List<String> _status = ['Active', 'Not Active'];
  Category _category;
  PassportResponse _passport;
  bool _uploadingIcon = false;

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
      _category = widget.category != null ? widget.category : new Category();
    });
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        title: Text(
            widget.category == null ? 'Add New Product Category' : 'Edit Product Category'
        ),
        titleSpacing: 0.0,
        backgroundColor: Theme.of(context).primaryColor,
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
                    width: 80.0,
                    height: 80.0,
                    color: Colors.transparent,
                    alignment: Alignment.topCenter,
                    child: GestureDetector(
                      onTap: () {
                        _showPicker(context);
                      },
                      child: _uploadingIcon ? CircularProgressIndicator() : CircleAvatar(
                        radius: 60,
                        backgroundColor: Color(0xffFDCF09),
                        child: _category != null && _category.icon != null ?
                        Container(
                          decoration: BoxDecoration(
                            color: Colors.grey[200],
                            borderRadius:
                            BorderRadius.circular(55),
                            image: DecorationImage(
                              image: NetworkImage(fsDlEndpoint + _category.icon.link),
                              fit: BoxFit.cover,
                            ),
                          ),
                          width: 110,
                          height: 110,
                        ) : Container(
                          decoration: BoxDecoration(
                              color: Colors.grey[200],
                              borderRadius:
                              BorderRadius.circular(55)),
                          width: 110,
                          height: 110,
                          child: Icon(
                            Icons.camera_alt,
                            color: Colors.grey[800],
                          ),
                        ),
                      ),
                    ),
                  ),

                ),
                FadeIn(
                  1.2,
                  Container(
                    alignment: Alignment.topCenter,
                    child: Text(
                      _category.icon == null ? 'Add Category Image/Icon' : 'Change Category Image/Icon',
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
                        FadeIn(
                          1.4,
                          TextFormField(
                            textCapitalization: TextCapitalization.none,
                            focusNode: _nameFocus,
                            keyboardType: TextInputType.text,
                            initialValue: _category.name,
                            decoration: InputDecoration(
                              hintText: 'Category Name',
                              contentPadding: const EdgeInsets.only(
                                  top: 12.0, bottom: 12.0),
                            ),
                            validator: (value) {
                              return Validator.required(
                                  value, 1,
                                  'Category Name is required');
                            },
                            onSaved: (name) => _category.name = name,
                            onFieldSubmitted: (_) {
                              fieldFocusChange(
                                  context, _nameFocus,
                                  _orderFocus);
                            },
                          ),
                        ),
                        FadeIn(
                          1.4,
                          TextFormField(
                            textCapitalization: TextCapitalization.none,
                            focusNode: _orderFocus,
                            initialValue: _category.catOrder != null ? _category.catOrder.toString() : '',
                            keyboardType: TextInputType.number,
                            decoration: InputDecoration(
                              hintText: 'Category Order',
                              contentPadding: const EdgeInsets.only(
                                  top: 12.0, bottom: 12.0),
                            ),
                            validator: (value) {
                              return Validator.between(
                                  double.parse(value), 1, 100,
                                  'Product Order Invalid');
                            },
                            onSaved: (order) => _category.catOrder = int.parse(order),
                            onFieldSubmitted: (_) {
                              fieldFocusChange(
                                  context, _orderFocus,
                                  _statusFocus);
                            },
                          ),
                        ),
                        SizedBox(
                          height: 10.0,
                        ),

                        FadeIn(
                            1.6,
                            DropdownButtonFormField<String>(
                              focusNode: _statusFocus,
                              isExpanded: true,
                              value: _category.catActive != null && _category.catActive ? 'Active' : 'Not Active',
                              hint: Text("Category Status"),
                              icon: const Icon(Icons.arrow_downward),
                              iconSize: 24,
                              elevation: 16,
                              style: TextStyle(color: Colors.black),
                              onChanged: (String newValue) {
                                setState(() {
                                  _category.catActive = newValue == 'Active';
                                });
                              },
                              validator: (value) {
                                return Validator.required(
                                    value, 3,
                                    'Category Status is required');
                              },
                              items: _status
                                  .map<DropdownMenuItem<String>>((String value) {
                                return DropdownMenuItem<String>(
                                  value: value,
                                  child: Text(value),
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
                              "Save Category",
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
      if (_passport == null && _category.icon == null) {
        Fluttertoast.showToast(msg: 'Upload Category Icon', toastLength: Toast.LENGTH_LONG);
        return;
      }
      EasyLoading.show(status: 'Saving product Category', maskType: EasyLoadingMaskType.black);

      CategoryResponse _response = await vendorBloc.saveCategory(_category);
      if (_response.data == null) {
        EasyLoading.dismiss();

        ServerValidationDialog.errorDialog(
            context, _response.error, _response.eTitle); //invoking log
      } else {
        EasyLoading.dismiss();
        EasyLoading.showSuccess('Product Category Saved', maskType: EasyLoadingMaskType.black, duration: Duration(seconds: 5));

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
      _uploadingIcon = true;
    });

    if (_category.icon == null) {
      FormData formData = FormData.fromMap({
        'name': basename(file.path),
        'fileType': lookupMimeType(file.path),
        'tag': 'passport',
        'objID': _category != null ? _category.id : 0,
        'file': await MultipartFile.fromFile(file.path, filename: basename(file.path))
      });

      personBloc.savePassport(formData).then((value) => {
        if (value.data != null) {
          setState(() {
            _category.icon = value.data;
            _passport = value;
            _uploadingIcon = false;
          }),
        }
      });
    } else {
      FormData formData = FormData.fromMap({
        'id': _category.icon.id,
        'name': basename(file.path),
        'fileType': lookupMimeType(file.path),
        'tag': 'passport',
        'objID': _category != null ? _category.id : 0,
        'file': await MultipartFile.fromFile(file.path, filename: basename(file.path))
      });

      personBloc.editPassport(formData).then((value) => {
        setState(() {
          _category.icon = value.data;
          _passport = value;
          _uploadingIcon = false;
        }),
      });
    }
  }
}
