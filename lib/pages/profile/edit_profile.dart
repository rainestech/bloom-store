import 'dart:io';

import 'package:bloom/bloc/person.bloc.dart';
import 'package:bloom/bloc/user.bloc.dart';
import 'package:bloom/data/entity/admin.entity.dart';
import 'package:bloom/data/entity/personnel.entity.dart';
import 'package:bloom/data/http/endpoints.dart';
import 'package:bloom/data/http/persons.provider.dart';
import 'package:bloom/pages/profile/my_account.dart';
import 'package:flutter/material.dart';
import 'package:bloom/Animation/fadeIn.dart';
import 'package:bloom/helpers/file.upload.dart';
import 'package:bloom/helpers/form.validators.dart';
import 'package:bloom/helpers/helper.dart';
import 'package:dio/dio.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:intl_phone_number_input/intl_phone_number_input.dart';
import 'package:page_transition/page_transition.dart';
import 'package:path/path.dart';
import 'package:mime/mime.dart';

class EditProfile extends StatefulWidget {
  @override
  _EditProfileState createState() => _EditProfileState();
}

class _EditProfileState extends State<EditProfile> {
  FocusNode _firstNameFocus = FocusNode();
  FocusNode _lastNameFocus = FocusNode();
  FocusNode _phoneFocus = FocusNode();
  FocusNode _birthdateFocus = FocusNode();
  FocusNode _genderFocus = FocusNode();
  FocusNode _ninFocus = FocusNode();

  File _image;
  Person _person = new Person();
  User _user;
  PersonResponse _personResponse;
  PhoneNumber _number = PhoneNumber(isoCode: 'GB');
  final TextEditingController _phoneController = TextEditingController();
  TextEditingController _dobController = new TextEditingController();

  final ImagePicker picker = ImagePicker();
  final _formKey = GlobalKey<FormState>();

  final List<String> _genders = ['Female', 'Male'];

  PassportResponse _passport;

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

  Future _selectDate(BuildContext context) async {
    DateTime picked = await showDatePicker(
      context: context,
      initialDate: new DateTime(2010),
      firstDate: new DateTime(1950),
      lastDate: new DateTime.now(),
    );

    if(picked != null) setState(() => {
      _person.birthdate = picked.toString(),
      _dobController.text = DateFormat('yyyy-MM-dd').format(picked)
    });
  }

  @override
  void initState() {
    super.initState();

    personBloc.personResponse.listen((value) {
      if (!mounted) {
        return;
      }

      setState(() {
        _personResponse = value;

        if (value.data == null) {
          _person = new Person();
        }  else {
          _person = value.data;
          _dobController.text = _person.birthdate;
          _setPhoneNo(_person.phone);

          if (_user == null) {
            _user = value.data.user;
          }
        }
      });
    });

    userBloc.userSubject.listen((value) {
      if (!mounted) {
        return;
      }

      setState(() {
        _user = value.data;
        _person.user = _user;
      });
    });

    userBloc.getUser();
    personBloc.me();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Edit Profile'),
        titleSpacing: 0.0,
        backgroundColor: Theme.of(context).primaryColor,
      ),
      body: _personResponse == null ?
      Center(
          child: SpinKitChasingDots(
          itemBuilder: (BuildContext context, int index) {
            return DecoratedBox(
              decoration: BoxDecoration(
                color: index.isEven ? Colors.red : Colors.green,
              ),
            );
          },
        )
      ) :
      ListView(
        shrinkWrap: true,
        children: <Widget>[
          SizedBox(height: 40.0),
          Container(
            alignment: Alignment.center,
            margin: EdgeInsets.only(right: 50.0, left: 50.0),
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
                      child: CircleAvatar(
                        radius: 60,
                        backgroundColor: Color(0xffFDCF09),
                        child: _user != null && _user.passport != null ?
                        Container(
                          decoration: BoxDecoration(
                            color: Colors.grey[200],
                            borderRadius:
                            BorderRadius.circular(55),
                            image: DecorationImage(
                              image: NetworkImage(fsDlEndpoint + _user.passport.link),
                              fit: BoxFit.cover,
                            ),
                          ),
                          width: 110,
                          height: 110,
                        ) : _user != null && _user.passport == null && _user.avatar != null ?
                        Container(
                          decoration: BoxDecoration(
                            color: Colors.grey[200],
                            borderRadius:
                            BorderRadius.circular(55),
                            image: DecorationImage(
                              image: NetworkImage(_user.avatar),
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
                            focusNode: _firstNameFocus,
                            keyboardType: TextInputType.text,
                            initialValue: _person.firstName,
                            decoration: InputDecoration(
                              hintText: 'First Name',
                              contentPadding: const EdgeInsets.only(
                                  top: 12.0, bottom: 12.0),
                            ),
                            validator: (value) {
                              return Validator.required(
                                  value, 1,
                                  'First Name is required');
                            },
                            onSaved: (name) => _person.firstName = name,
                            onFieldSubmitted: (_) {
                              fieldFocusChange(
                                  context, _firstNameFocus,
                                  _lastNameFocus);
                            },
                          ),
                        ),
                        FadeIn(
                          1.4,
                          TextFormField(
                            textCapitalization: TextCapitalization.none,
                            focusNode: _lastNameFocus,
                            initialValue: _person.lastName,
                            keyboardType: TextInputType.text,
                            decoration: InputDecoration(
                              hintText: 'Last Name',
                              contentPadding: const EdgeInsets.only(
                                  top: 12.0, bottom: 12.0),
                            ),
                            validator: (value) {
                              return Validator.required(
                                  value, 1,
                                  'First Name is required');
                            },
                            onSaved: (lastName) => _person.lastName = lastName,
                            onFieldSubmitted: (_) {
                              fieldFocusChange(
                                  context, _lastNameFocus,
                                  _phoneFocus);
                            },
                          ),
                        ),
                        SizedBox(
                          height: 10.0,
                        ),
                        FadeIn(
                          1.4,
                          InternationalPhoneNumberInput(
                            selectorConfig: SelectorConfig(
                              selectorType: PhoneInputSelectorType.DROPDOWN,
                            ),
                            focusNode: _phoneFocus,
                            ignoreBlank: false,
                            autoValidateMode: AutovalidateMode.disabled,
                            selectorTextStyle: TextStyle(color: Colors.black),
                            initialValue: _number,
                            textFieldController: _phoneController,
                            formatInput: false,
                            keyboardType:
                            TextInputType.numberWithOptions(signed: true, decimal: true),
                            inputBorder: UnderlineInputBorder(),
                            onSaved: (PhoneNumber number) {
                              _person.phone = number.phoneNumber;
                            },
                            onFieldSubmitted: (_) {
                              fieldFocusChange(
                                  context, _phoneFocus,
                                  _birthdateFocus);
                            },
                          ),
                        ),
                        FadeIn(
                          1.4,
                          TextFormField(
                            controller: _dobController,
                            onTap: (){
                              // Below line stops keyboard from appearing
                              FocusScope.of(context).requestFocus(new FocusNode());

                              // Show Date Picker Here
                              _selectDate(context);
                            },
                            focusNode: _birthdateFocus,
                            textCapitalization: TextCapitalization.none,
                            keyboardType: TextInputType.text,
                            decoration: InputDecoration(
                              hintText: 'Date of Birth',
                              contentPadding: const EdgeInsets.only(
                                  top: 12.0, bottom: 12.0),
                            ),
                            validator: (value) {
                              return Validator.required(
                                  value, 3,
                                  'Date of Birth is required');
                            },
                            onSaved: (dob) => _person.birthdate = dob,
                            onFieldSubmitted: (_) {
                              fieldFocusChange(
                                  context, _birthdateFocus,
                                  _genderFocus);
                            },
                          ),
                        ),
                        SizedBox(
                          height: 10.0,
                        ),
                        FadeIn(
                          1.6,
                          DropdownButtonFormField<String>(
                              focusNode: _genderFocus,
                              isExpanded: true,
                              value: _person.gender,
                              hint: Text("Gender"),
                              icon: const Icon(Icons.arrow_downward),
                              iconSize: 24,
                              elevation: 16,
                              style: TextStyle(color: Colors.black),
                              // underline: Container(
                              //   height: 2,
                              //   color: AppColors.secondaryColor,
                              // ),
                              onChanged: (String newValue) {
                                setState(() {
                                  _person.gender = newValue;
                                });
                              },
                              validator: (value) {
                                return Validator.required(
                                    value, 3,
                                    'Gender is required');
                              },
                              items: _genders
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
                                  "Save Profile",
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
      EasyLoading.show(status: 'Submitting details', maskType: EasyLoadingMaskType.black);

      PersonResponse _response = await personBloc.savePerson(_person);
      if (_response.data == null) {
        EasyLoading.dismiss();

        ServerValidationDialog.errorDialog(
            context, _response.error, _response.eTitle); //invoking log
      } else {
        EasyLoading.dismiss();
        EasyLoading.showSuccess('Details submitted successfully', maskType: EasyLoadingMaskType.black, duration: Duration(seconds: 5));

        Navigator.push(context, PageTransition(
            type: PageTransitionType.rightToLeft,
            child: MyAccount()));
      }
    } catch (error) {
      EasyLoading.dismiss();
      ServerValidationDialog.errorDialog(
          context, error.toString(), ''); //invoking log
      print(error);
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

  void _removePic() async {

  }

  saveImage(PickedFile file) async {
    setState(() {
      _image = File(file.path);
      // _image = Image.file(File(image.path));
    });

    await SaveFile().saveFile(_image, 'profileImage');

    if (_user.passport == null) {
      FormData formData = FormData.fromMap({
        'name': basename(file.path),
        'fileType': lookupMimeType(file.path),
        'tag': 'passport',
        'objID': _person.user != null ? _person.user.id : _user.id,
        'file': await MultipartFile.fromFile(file.path, filename: basename(file.path))
      });

      personBloc.savePassport(formData).then((value) => {
        if (value.data != null) {
          setState(() {
            _user.passport = value.data;
          }),
          userBloc.editUser(_user)
        }
      });
    } else {
      FormData formData = FormData.fromMap({
        'id': _user.passport.id,
        'name': basename(file.path),
        'fileType': lookupMimeType(file.path),
        'tag': 'passport',
        'objID': _person.user != null ? _person.user.id : _user.id,
        'file': await MultipartFile.fromFile(file.path, filename: basename(file.path))
      });

      personBloc.editPassport(formData).then((value) => {
        setState(() {
          _user.passport = value.data;
        }),
      });
    }

  }

  Future<void> _setPhoneNo(String phoneNumber) async {
    PhoneNumber number = await PhoneNumber.getRegionInfoFromPhoneNumber(phoneNumber);
    String parsableNumber = number.parseNumber();
    _phoneController.text = parsableNumber;
    setState(() {
      _number = number;
    });
  }
}
