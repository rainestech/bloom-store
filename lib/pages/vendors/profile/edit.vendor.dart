import 'package:bloom/AppTheme/theme.dart';
import 'package:bloom/bloc/person.bloc.dart';
import 'package:bloom/bloc/vendor.bloc.dart';
import 'package:bloom/data/entity/personnel.entity.dart';
import 'package:bloom/data/entity/vendor.entity.dart';
import 'package:bloom/data/http/endpoints.dart';
import 'package:bloom/data/http/persons.provider.dart';
import 'package:bloom/data/http/vendor.provider.dart';
import 'package:bloom/pages/vendors/vendors.container.dart';
import 'package:flutter/material.dart';
import 'package:bloom/helpers/form.validators.dart';
import 'package:bloom/helpers/helper.dart';
import 'package:dio/dio.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:html_editor_enhanced/html_editor.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart';
import 'package:mime/mime.dart';

class EditVendorPage extends StatefulWidget {
  final Vendor vendor;
  final Person person;

  const EditVendorPage({Key key, @required this.vendor, this.person}) : super(key: key);
  @override
  _EditVendorPageState createState() => _EditVendorPageState();
}

class _EditVendorPageState extends State<EditVendorPage> {
  FocusNode _nameFocus = FocusNode();
  FocusNode _descriptionFocus = FocusNode();
  FocusNode _cityFocus = FocusNode();
  FocusNode _countryFocus = FocusNode();
  FocusNode _provinceFocus = FocusNode();
  FocusNode _postalCodeFocus = FocusNode();
  FocusNode _addressFocus = FocusNode();
  FocusNode _facebookFocus = FocusNode();
  FocusNode _twitterFocus = FocusNode();
  FocusNode _instagramFocus = FocusNode();

  final ImagePicker picker = ImagePicker();
  final _formKey = GlobalKey<FormState>();
  List<Country> _countries = [];
  Vendor _vendor;
  Person _person;
  PassportResponse _passport;
  bool _uploadingIcon = false;
  HtmlEditorController controller = HtmlEditorController();

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
                  // if (_image != null)
                  //   new ListTile(
                  //     leading: new Icon(Icons.no_photography_outlined),
                  //     title: new Text('Remove Profile Pic'),
                  //     onTap: () {
                  //       _removePic();
                  //       Navigator.of(context).pop();
                  //     },
                  //   ),
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
      if (widget.vendor != null) {
        _vendor = widget.vendor;
      } else {
        _vendor = new Vendor();
        _vendor.address = new Address();
      }
      _person = widget.person;
    });

    vendorBloc.countriesSubject.listen((value) {
      if (!mounted) {
        return;
      }

      setState(() {
        if (value.data != null) {
          _countries = value.data;
        }
      });
    });

    personBloc.personResponse.listen((value) {
      if (!mounted) {
        return;
      }

      if (value != null && value.data != null && _person == null) {
        setState(() {
          _person = value.data;
        });
      }
    });

    if (_person == null) {
      personBloc.me();
    }

    vendorBloc.getCountries();
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        title: Text(
            widget.vendor == null ? 'Register New Vendor' : 'Update Vendor Profile'
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
                      child: _vendor != null && _vendor.logo != null ?
                      Container(
                        decoration: BoxDecoration(
                          color: Colors.grey[200],
                          borderRadius:
                          BorderRadius.circular(55),
                          image: DecorationImage(
                            image: NetworkImage(fsDlEndpoint + _vendor.logo.link),
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
                Container(
                  alignment: Alignment.topCenter,
                  child: Text(
                    _vendor.logo == null ? 'Add Logo' : 'Update Logo',
                    style: TextStyle(
                        color: Colors.grey[600]
                    ),
                  ),
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
                      mainAxisSize: MainAxisSize.min,
                      children: <Widget>[
                        TextFormField(
                          textCapitalization: TextCapitalization.none,
                          focusNode: _nameFocus,
                          keyboardType: TextInputType.text,
                          initialValue: _vendor.name,
                          decoration: InputDecoration(
                            hintText: 'Vendor Name',
                            contentPadding: const EdgeInsets.only(
                                top: 12.0, bottom: 12.0),
                          ),
                          validator: (value) {
                            return Validator.required(
                                value, 1,
                                'Vendor Name is required');
                          },
                          onSaved: (name) => _vendor.name = name,
                          onFieldSubmitted: (_) {
                            fieldFocusChange(
                                context, _nameFocus,
                                _descriptionFocus);
                          },
                        ),
                        SizedBox(height: 15,),
                        HtmlEditor(
                          controller: controller, //required
                          htmlEditorOptions: HtmlEditorOptions(
                            hint: "Description here...",
                            initialText: _vendor.description,
                          ),
                          htmlToolbarOptions: HtmlToolbarOptions(
                            toolbarPosition: ToolbarPosition.belowEditor,
                            toolbarType: ToolbarType.nativeScrollable,
                          ),
                          otherOptions: OtherOptions(
                            height: 200,
                          ),
                        ),
                        SizedBox(height: 15,),

                        DropdownButtonFormField<Country>(
                          focusNode: _countryFocus,
                          isExpanded: true,
                          value: _vendor.address.country,
                          hint: Text("Vendor Country"),
                          icon: const Icon(Icons.arrow_downward),
                          iconSize: 24,
                          elevation: 16,
                          style: TextStyle(color: Colors.black),
                          onChanged: (Country newValue) {
                            setState(() {
                              _vendor.address.country = newValue;
                            });
                          },
                          validator: (value) {
                            return Validator.required(
                                value.name, 1,
                                'Vendor Country is required');
                          },
                          items: _countries
                              .map<DropdownMenuItem<Country>>((Country value) {
                            return DropdownMenuItem<Country>(
                              value: value,
                              child: Text(value.name),
                            );
                          }).toList(),
                        ),

                        TextFormField(
                          textCapitalization: TextCapitalization.words,
                          focusNode: _provinceFocus,
                          initialValue: _vendor.address.province != null ? _vendor.address.province : '',
                          keyboardType: TextInputType.text,
                          decoration: InputDecoration(
                            hintText: 'Province/State',
                            contentPadding: const EdgeInsets.only(
                                top: 12.0, bottom: 12.0),
                          ),
                          validator: (value) {
                            return Validator.required(value, 3,
                                'Province is required');
                          },
                          onSaved: (province) => _vendor.address.province = province,
                          onFieldSubmitted: (_) {
                            fieldFocusChange(
                                context, _provinceFocus,
                                _cityFocus);
                          },
                        ),

                        SizedBox(height: 10.0,),

                        TextFormField(
                          textCapitalization: TextCapitalization.words,
                          focusNode: _cityFocus,
                          initialValue: _vendor.address.city,
                          keyboardType: TextInputType.text,
                          decoration: InputDecoration(
                            hintText: 'City',
                            contentPadding: const EdgeInsets.only(
                                top: 12.0, bottom: 12.0),
                          ),
                          validator: (value) {
                            return Validator.required(value, 3,
                                'Vendor City is required');
                          },
                          onSaved: (city) => _vendor.address.city = city,
                          onFieldSubmitted: (_) {
                            fieldFocusChange(
                                context, _cityFocus,
                                _addressFocus);
                          },
                        ),

                        SizedBox(height: 10.0,),

                        TextFormField(
                          textCapitalization: TextCapitalization.words,
                          focusNode: _addressFocus,
                          initialValue: _vendor.address.address,
                          keyboardType: TextInputType.text,
                          maxLines: 2,
                          decoration: InputDecoration(
                            hintText: 'Contact Address',
                            contentPadding: const EdgeInsets.only(
                                top: 12.0, bottom: 12.0),
                          ),
                          validator: (value) {
                            return Validator.required(value, 3,
                                'Contact Address is required');
                          },
                          onSaved: (address) => _vendor.address.address = address,
                          onFieldSubmitted: (_) {
                            fieldFocusChange(
                                context, _addressFocus,
                                _postalCodeFocus);
                          },
                        ),

                        SizedBox(height: 10.0,),
                        TextFormField(
                          textCapitalization: TextCapitalization.characters,
                          focusNode: _postalCodeFocus,
                          initialValue: _vendor.address.postalcode,
                          keyboardType: TextInputType.text,
                          maxLines: 2,
                          decoration: InputDecoration(
                            hintText: 'Postal Code',
                            contentPadding: const EdgeInsets.only(
                                top: 12.0, bottom: 12.0),
                          ),
                          validator: (value) {
                            return Validator.required(value, 3,
                                'Postal Code is required');
                          },
                          onSaved: (code) => _vendor.address.postalcode = code,
                          onFieldSubmitted: (_) {
                            fieldFocusChange(
                                context, _postalCodeFocus,
                                _facebookFocus);
                          },
                        ),

                        SizedBox(height: 10.0,),
                        TextFormField(
                          textCapitalization: TextCapitalization.none,
                          focusNode: _facebookFocus,
                          initialValue: _vendor.facebook,
                          keyboardType: TextInputType.text,
                          maxLines: 2,
                          decoration: InputDecoration(
                            hintText: 'Facebook Page Link',
                            contentPadding: const EdgeInsets.only(
                                top: 12.0, bottom: 12.0),
                          ),
                          onSaved: (facebook) => _vendor.facebook = facebook,
                          onFieldSubmitted: (_) {
                            fieldFocusChange(
                                context, _facebookFocus,
                                _twitterFocus);
                          },
                        ),

                        SizedBox(height: 10.0,),
                        TextFormField(
                          textCapitalization: TextCapitalization.none,
                          focusNode: _twitterFocus,
                          initialValue: _vendor.twitter,
                          keyboardType: TextInputType.text,
                          maxLines: 2,
                          decoration: InputDecoration(
                            hintText: 'Twitter Page Link',
                            contentPadding: const EdgeInsets.only(
                                top: 12.0, bottom: 12.0),
                          ),
                          onSaved: (twitter) => _vendor.twitter = twitter,
                          onFieldSubmitted: (_) {
                            fieldFocusChange(
                                context, _twitterFocus,
                                _instagramFocus);
                          },
                        ),

                        SizedBox(height: 10.0,),
                        TextFormField(
                          textCapitalization: TextCapitalization.none,
                          focusNode: _instagramFocus,
                          initialValue: _vendor.instagram,
                          keyboardType: TextInputType.text,
                          maxLines: 2,
                          decoration: InputDecoration(
                            hintText: 'Instagram Page Link',
                            contentPadding: const EdgeInsets.only(
                                top: 12.0, bottom: 12.0),
                          ),
                          onSaved: (instagram) => _vendor.instagram = instagram,
                        ),

                        SizedBox(height: 10.0,),

                      ],
                    ),
                  ),
                ),
                SizedBox(
                  height: 50.0,
                ),
                InkWell(
                  child: Container(
                    height: 45.0,
                    child: Material(
                      borderRadius: BorderRadius.circular(20.0),
                      shadowColor: Colors.grey[300],
                      color: AppColors.themeDark,
                      borderOnForeground: false,
                      elevation: 5.0,
                      child: GestureDetector(
                        child: Center(
                          child: Text(
                            _vendor.id != null ? 'Update Vendor Profile' : 'Register Vendor',
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
      if (_passport == null && _vendor.logo == null) {
        Fluttertoast.showToast(msg: 'Upload Vendor Logo', toastLength: Toast.LENGTH_LONG);
        return;
      }

      _vendor.description = await controller.getText();
      _vendor.address.type = 'business';
      _vendor.address.name = _vendor.name;
      _vendor.person = [_person];

      EasyLoading.show(status: 'Saving Vendor', maskType: EasyLoadingMaskType.black);

      VendorResponse _response = await vendorBloc.saveVendor(_vendor);
      if (_response.data == null) {
        EasyLoading.dismiss();

        ServerValidationDialog.errorDialog(
            context, _response.error, _response.eTitle); //invoking log
      } else {
        EasyLoading.dismiss();
        if (_vendor.id == null) {
          EasyLoading.showSuccess('Vendor Application Received. This will be reviewed by Admin for approval in due course.', maskType: EasyLoadingMaskType.black, duration: Duration(seconds: 5));
        } else {
          EasyLoading.showSuccess('Vendor Information updated successfully', maskType: EasyLoadingMaskType.black, duration: Duration(seconds: 5));
        }

        Navigator.push(context,
            MaterialPageRoute(
                builder: (context) =>
                    VendorContainer(4)));
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

    if (_vendor.logo == null) {
      FormData formData = FormData.fromMap({
        'name': basename(file.path),
        'fileType': lookupMimeType(file.path),
        'tag': 'passport',
        'objID': _vendor != null ? _vendor.id : 0,
        'file': await MultipartFile.fromFile(file.path, filename: basename(file.path))
      });

      personBloc.savePassport(formData).then((value) => {
        if (value.data != null) {
          setState(() {
            _vendor.logo = value.data;
            _passport = value;
            _uploadingIcon = false;
          }),
        }
      });
    } else {
      FormData formData = FormData.fromMap({
        'id': _vendor.logo.id,
        'name': basename(file.path),
        'fileType': lookupMimeType(file.path),
        'tag': 'passport',
        'objID': _vendor != null ? _vendor.id : 0,
        'file': await MultipartFile.fromFile(file.path, filename: basename(file.path))
      });

      personBloc.editPassport(formData).then((value) => {
        setState(() {
          _vendor.logo = value.data;
          _passport = value;
          _uploadingIcon = false;
        }),
      });
    }
  }
}
