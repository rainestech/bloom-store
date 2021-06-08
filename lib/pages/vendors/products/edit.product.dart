import 'dart:io';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:bloom/AppTheme/theme.dart';
import 'package:bloom/bloc/person.bloc.dart';
import 'package:bloom/bloc/vendor.bloc.dart';
import 'package:bloom/data/entity/personnel.entity.dart';
import 'package:bloom/data/entity/vendor.entity.dart';
import 'package:bloom/data/http/endpoints.dart';
import 'package:bloom/data/http/persons.provider.dart';
import 'package:bloom/data/http/vendor.provider.dart';
import 'package:dio/dio.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:bloom/Animation/fadeIn.dart';
import 'package:bloom/helpers/form.validators.dart';
import 'package:bloom/helpers/helper.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:html_editor_enhanced/html_editor.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:path/path.dart';

class AddEditProductPage extends StatefulWidget {
  final Products product;

  const AddEditProductPage({Key key, @required this.product}) : super(key: key);
  @override
  _AddEditProductState createState() => _AddEditProductState();
}

class _AddEditProductState extends State<AddEditProductPage> {
  FocusNode _nameFocus = FocusNode();
  FocusNode _salePriceFocus = FocusNode();
  FocusNode _saleEndFocus = FocusNode();
  FocusNode _descriptionFocus = FocusNode();
  FocusNode _stockFocus = FocusNode();
  FocusNode _stateFocus = FocusNode();
  FocusNode _priceFocus = FocusNode();
  FocusNode _categoryFocus = FocusNode();
  HtmlEditorController htmlEditorController = HtmlEditorController();

  final ImagePicker picker = ImagePicker();
  final _formKey = GlobalKey<FormState>();
  final List<String> _status = ['active', 'inactive', 'unavailable', 'draft'];
  List<Category> _categories = [];
  Products _product;
  PassportListResponse _images;
  List<Passport> _serverImages;
  bool _uploadingIcon = false;
  List<File> _selectedImages;
  TextEditingController _saleEndController = new TextEditingController();

  @override
  void initState() {
    super.initState();
    setState(() {
      if (widget.product != null) {
        _product = widget.product;
        _serverImages = _product.images;
      } else {
        _product = new Products();
      }

    });

    vendorBloc.categoryListSubject.listen((value) {
      if (!mounted) {
        return;
      }

      setState(() {
        _categories = value.data == null ? [] : value.data;
      });
    });

    vendorBloc.getCategories();
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;

    void _showPicker(context, int index) {
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
                          _imgFromGallery(index);
                          Navigator.of(context).pop();
                        }),
                    new ListTile(
                      leading: new Icon(Icons.photo_camera),
                      title: new Text('Camera'),
                      onTap: () {
                        _imgFromCamera(index);
                        Navigator.of(context).pop();
                      },
                    ),
                  ],
                ),
              ),
            );
          });
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(
            widget.product == null ? 'Add New Product' : 'Edit Product'
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
                if(_serverImages == null && _selectedImages == null)
                  Container(
                  padding: EdgeInsets.all(20.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Card(
                        color: Colors.brown,
                        child: IconButton(
                          icon: Icon(Icons.add),
                          onPressed: () {
                            _onAddImageClick();
                          },
                        ),
                      ),
                      Container(
                        padding: EdgeInsets.only(right: 50.0, left: 50.0),
                        child: AutoSizeText(
                          'Upload Product Images, minimum of 1 and max of 10',
                          maxLines: 2,
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ],
                  ),
                ),

                if(_serverImages != null || _selectedImages != null)
                  Container(
                    width: width,
                    height: 80,
                    child: GridView.count(
                      // Create a grid with 2 columns. If you change the scrollDirection to
                      // horizontal, this produces 2 rows.
                      scrollDirection: Axis.horizontal,
                      crossAxisCount: 1,
                      // Generate 100 widgets that display their index in the List.
                      children: List.generate(_serverImages != null ? _serverImages.length : _selectedImages.length, (index) {
                        return Container(
                          height: 80.0,
                          width: 80.0,
                          margin: EdgeInsets.only(right: 5, left:5),
                          padding: EdgeInsets.all(0),
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10.0),
                            border: Border.all(color: AppColors.themeDark, width: 5.0),
                          ),
                          child: GestureDetector(
                            onTap: () {
                              _showPicker(context, index);
                            },
                            child: ClipRRect(
                              borderRadius: new BorderRadius.circular(10.0),
                              child: Image(
                                image: _serverImages != null ? NetworkImage(fsDlEndpoint + _serverImages[index].link)
                                    : FileImage(_selectedImages[index]),
                                height: 100.0,
                                width: 100.0,
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                        );
                      }),
                    ),
                  ),

                if(_serverImages != null || _selectedImages != null)
                  SizedBox(height: 10.0,),

                if(_serverImages != null || _selectedImages != null)
                  Text(_serverImages != null ? 'Uploaded Product Images' : 'Selected Product images'),

                SizedBox(height: 10.0,),
                Form(
                  key: _formKey,
                  child:
                  Container(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                          TextFormField(
                            textCapitalization: TextCapitalization.words,
                            focusNode: _nameFocus,
                            keyboardType: TextInputType.text,
                            initialValue: _product.name,
                            decoration: InputDecoration(
                              hintText: 'Product Name',
                              contentPadding: const EdgeInsets.only(
                                  top: 12.0, bottom: 12.0),
                            ),
                            validator: (value) {
                              return Validator.required(
                                  value, 1,
                                  'Product Name is required');
                            },
                            onSaved: (name) => _product.name = name,
                            onFieldSubmitted: (_) {
                              fieldFocusChange(
                                  context, _nameFocus,
                                  _categoryFocus);
                            },
                          ),
                        DropdownButtonFormField<Category>(
                          focusNode: _categoryFocus,
                          isExpanded: true,
                          value: _product.category,
                          hint: Text("Select Product Category"),
                          icon: const Icon(Icons.arrow_downward),
                          iconSize: 24,
                          elevation: 16,
                          style: TextStyle(color: Colors.black),
                          onChanged: (Category newValue) {
                            setState(() {
                              _product.category = newValue;
                            });

                            fieldFocusChange(
                                context, _categoryFocus,
                                _stateFocus);
                          },
                          validator: (value) {
                            return Validator.required(
                                value?.name, 3,
                                'Product Category is required');
                          },
                          items: _categories
                              .map<DropdownMenuItem<Category>>((Category value) {
                            return DropdownMenuItem<Category>(
                              value: value,
                              child: Text(value.name),
                            );
                          }).toList(),
                        ),
                        SizedBox(height: 15,),
                        DropdownButtonFormField<String>(
                          focusNode: _stateFocus,
                          isExpanded: true,
                          value: _product.state,
                          hint: Text("Select Product State"),
                          icon: const Icon(Icons.arrow_downward),
                          iconSize: 24,
                          elevation: 16,
                          style: TextStyle(color: Colors.black),
                          onChanged: (String newValue) {
                            setState(() {
                              _product.state = newValue;
                            });

                            fieldFocusChange(
                                context, _stateFocus,
                                _stockFocus);
                          },
                          validator: (value) {
                            return Validator.required(
                                value, 3,
                                'Product State is required');
                          },
                          items: _status
                              .map<DropdownMenuItem<String>>((String value) {
                            return DropdownMenuItem<String>(
                              value: value,
                              child: Text(value.toUpperCase()),
                            );
                          }).toList(),
                        ),
                        SizedBox(height: 15,),
                        Row(
                          children: [
                            Container(
                              width: (width / 2) - 30,
                              child: TextFormField(
                                textCapitalization: TextCapitalization.none,
                                focusNode: _stockFocus,
                                initialValue: _product.stock != null ? _product.stock.toString() : null,
                                keyboardType: TextInputType.number,
                                decoration: InputDecoration(
                                  hintText: 'Available Stock',
                                  contentPadding: const EdgeInsets.only(
                                      top: 12.0, bottom: 12.0),
                                ),
                                validator: (value) {
                                  return Validator.between(
                                      double.parse(value == null ? 0 : value), 1, 100000,
                                      'Product Stock Invalid');
                                },
                                onSaved: (order) => _product.stock = int.parse(order),
                                onFieldSubmitted: (_) {
                                  fieldFocusChange(
                                      context, _stockFocus,
                                      _priceFocus);
                                },
                              ),
                            ),
                            Spacer(),
                            Container(
                              width: (width / 2) - 30,
                              child: TextFormField(
                                textCapitalization: TextCapitalization.none,
                                focusNode: _priceFocus,
                                initialValue: _product.price != null ? _product.price.toString() : null,
                                keyboardType: TextInputType.number,
                                decoration: InputDecoration(
                                  hintText: 'Price',
                                  contentPadding: const EdgeInsets.only(
                                      top: 12.0, bottom: 12.0),
                                ),
                                validator: (value) {
                                  return Validator.between(
                                      double.parse(value == null ? 0 : value), 0.01, 100000,
                                      'Product Price Invalid');
                                },
                                onSaved: (price) => _product.price = double.parse(price),
                                onFieldSubmitted: (_) {
                                  fieldFocusChange(
                                      context, _priceFocus,
                                      _descriptionFocus);
                                },
                              ),
                            ),

                          ],
                        ),
                        SizedBox(height: 15,),
                        AutoSizeText('Leave Blank the below fields if Item is not on Sale!',
                          maxLines: 2,
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: Colors.deepOrangeAccent
                          ),
                        ),
                        SizedBox(height: 10,),
                        Container(
                          padding: EdgeInsets.all(10),
                          decoration: BoxDecoration(
                            color: Colors.grey[400],
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Row(
                            children: [
                              Container(
                                width: (width / 2) - 40,
                                child: TextFormField(
                                  textCapitalization: TextCapitalization.none,
                                  focusNode: _salePriceFocus,
                                  initialValue: _product.salePrice != null ? _product.salePrice.toString() : null,
                                  keyboardType: TextInputType.number,
                                  decoration: InputDecoration(
                                    hintText: 'Sale Price',
                                    contentPadding: const EdgeInsets.only(
                                        top: 12.0, bottom: 12.0),
                                  ),
                                  onSaved: (order) => _product.salePrice = double.parse(order),
                                  onFieldSubmitted: (_) {
                                    fieldFocusChange(
                                        context, _salePriceFocus,
                                        _saleEndFocus);
                                  },
                                ),
                              ),
                              Spacer(),
                              Container(
                                width: (width / 2) - 40,
                                child: TextFormField(
                                  controller: _saleEndController,
                                  onTap: (){
                                    // Below line stops keyboard from appearing
                                    FocusScope.of(context).requestFocus(new FocusNode());

                                    // Show Date Picker Here
                                    _selectDate(context);
                                  },
                                  focusNode: _saleEndFocus,
                                  textCapitalization: TextCapitalization.none,
                                  keyboardType: TextInputType.text,
                                  decoration: InputDecoration(
                                    hintText: 'Sale End Date',
                                    contentPadding: const EdgeInsets.only(
                                        top: 12.0, bottom: 12.0),
                                  ),
                                  onSaved: (dob) => _product.saleEnds = dob,
                                  onFieldSubmitted: (_) {
                                    fieldFocusChange(
                                        context, _saleEndFocus,
                                        _descriptionFocus);
                                  },
                                ),
                              ),

                            ],
                          ),
                        ),

                        SizedBox(height: 25,),
                        HtmlEditor(
                          controller: htmlEditorController, //required
                          htmlEditorOptions: HtmlEditorOptions(
                            hint: "Description here...",
                            initialText: _product.description,
                          ),
                          htmlToolbarOptions: HtmlToolbarOptions(
                            toolbarPosition: ToolbarPosition.belowEditor,
                            toolbarType: ToolbarType.nativeScrollable,
                          ),
                          otherOptions: OtherOptions(
                            height: 200,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                SizedBox(height: 50.0,),
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
                              "Save Product",
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
      EasyLoading.show(status: 'Saving product', maskType: EasyLoadingMaskType.black);
      _product.description = await htmlEditorController.getText();
      if (_product.id == null) _product.unitsSold = 0;

      if (_product.description == null || _product.description.isEmpty) {
        EasyLoading.dismiss();

        ServerValidationDialog.errorDialog(
            context, 'Product Description can not be empty!', ''); //inv

        return;
      }

      if (_selectedImages != null) {
        var files = await saveAllImage(_selectedImages);
        if (files.data == null) {
          EasyLoading.dismiss();
          ServerValidationDialog.errorDialog(
              context, 'An Error Occurred uploading your product Images: ${files.error}', files.eTitle);

          return;
        }
      } else if (_serverImages == null) {
        Fluttertoast.showToast(msg: 'No product images selected');
        return;
      }

      ProductsResponse _response = await vendorBloc.saveProduct(_product);
      if (_response.data == null) {
        EasyLoading.dismiss();

        ServerValidationDialog.errorDialog(
            context, _response.error, _response.eTitle); //invoking log
      } else {
        EasyLoading.dismiss();
        EasyLoading.showSuccess('Product Saved', maskType: EasyLoadingMaskType.black, duration: Duration(seconds: 5));

        Navigator.of(context).pop();
      }
    } catch (error) {
      EasyLoading.dismiss();
      ServerValidationDialog.errorDialog(
          context, error.toString(), ''); //invoking log
    }
  }

  void _onAddImageClick() async {
    FilePickerResult result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['jpg', 'png', 'jpeg'],
      allowMultiple: true,
    );

    if(result != null) {
      List<File> files = result.paths.map((path) => File(path)).toList();
      setState(() {
        _selectedImages = files;
      });
    } else {
      Fluttertoast.showToast(msg: 'No files selected');
    }
  }

  Future<PassportListResponse> saveAllImage(List<File> files) async {
      FormData formData = FormData.fromMap({
        'tag': 'products',
        'objID': _product != null ? _product.id : 0,
        'name': 'productImage',
        'fileType': 'image',
        'files': [
          for (var file in files) {
            await MultipartFile.fromFile(file.path, filename: basename(file.path))
          }.toList()
        ]
      });

      PassportListResponse resp = await personBloc.saveMultipleFiles(formData);
      setState(() {
        if (resp.data != null) {
          _serverImages = resp.data;
          _product.images = resp.data;
          _selectedImages = null;
        }
      });

      return resp;
    }

  void _imgFromCamera(int index) async {
    PickedFile image =
    await picker.getImage(source: ImageSource.camera, imageQuality: 50);

    if (image == null) return;
    if (_serverImages == null) {
      _selectedImages[index] = File(image.path);
      return;
    }
    saveImage(image, index);
  }

  void _imgFromGallery(int index) async {
    PickedFile image =
    await picker.getImage(source: ImageSource.gallery, imageQuality: 50);

    if (image == null) return;

    if (_serverImages == null) {
      _selectedImages[index] = File(image.path);
      return;
    }
    saveImage(image, index);
  }

  saveImage(PickedFile file, int index) async {
    setState(() {
      _uploadingIcon = true;
    });
      var old = _serverImages[index];
      FormData formData = FormData.fromMap({
        'id': old.id,
        'tag': 'products',
        'objID': _product != null ? _product.id : 0,
        'name': 'productImage',
        'fileType': 'image',
        'file': await MultipartFile.fromFile(file.path, filename: basename(file.path))
      });

      personBloc.savePassport(formData).then((value) => {
        if (value.data != null) {
          setState(() {
            _serverImages[index] = value.data;
            _uploadingIcon = false;
          }),
        }
      });
    }

  Future _selectDate(BuildContext context) async {
    DateTime picked = await showDatePicker(
      context: context,
      initialDate: new DateTime(2010),
      firstDate: new DateTime(1950),
      lastDate: new DateTime.now(),
    );

    if(picked != null) setState(() => {
      _product.saleEnds = picked.toString(),
      _saleEndController.text = DateFormat('yyyy-MM-dd').format(picked)
    });
  }
}
