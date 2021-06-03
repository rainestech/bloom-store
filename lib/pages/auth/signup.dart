import 'package:bloom/Animation/fadeIn.dart';
import 'package:bloom/bloc/user.bloc.dart';
import 'package:bloom/data/http/user.dart';
import 'package:bloom/helpers/form.validators.dart';
import 'package:bloom/helpers/helper.dart';
import 'package:bloom/pages/auth/otp_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:page_transition/page_transition.dart';

import '../home.dart';
import 'login.dart';

class Signup extends StatefulWidget {
  @override
  _SignupState createState() => _SignupState();
}

class _SignupState extends State<Signup> {
  // Initially password is obscure
  bool _obscureText = true;
  bool _obscureText1 = true;

  FocusNode _usernameFocusNode = FocusNode();
  FocusNode _passwordFocusNode = FocusNode();
  FocusNode _nameFocusNode = FocusNode();
  FocusNode _emailFocusNode = FocusNode();
  FocusNode _cPasswordFocusNode = FocusNode();
  String _username;
  String _password;
  String _cPassword;
  String _name;
  String _email;
  final _formKey = GlobalKey<FormState>();

  // Toggles the password show status
  void _viewPassword() {
    setState(() {
      _obscureText = !_obscureText;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView(
        children: <Widget>[
          Container(
            padding: EdgeInsets.only(top: 20.0, right: 30.0, left: 30.0),
            child: FadeIn(
              1.0,
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  InkWell(
                    child: Text(
                      "Login",
                      style: TextStyle(
                        color: Colors.grey,
                        fontSize: 25.0,
                        fontWeight: FontWeight.bold,
                        fontFamily: 'Alatsi',
                      ),
                    ),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => Login(null)),
                      );
                    },
                  ),
                  Text(
                    'Sign Up',
                    textAlign: TextAlign.end,
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 40.0,
                      fontWeight: FontWeight.bold,
                      fontFamily: 'Alatsi',
                    ),
                  ),
                ],
              ),
            ),
          ),
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
                    decoration: new BoxDecoration(
                      image: new DecorationImage(
                        image: new AssetImage('assets/bloom.png'),
                        fit: BoxFit.cover,
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
                            focusNode: _nameFocusNode,
                            keyboardType: TextInputType.text,
                            decoration: InputDecoration(
                              hintText: 'Name',
                              contentPadding: const EdgeInsets.only(
                                  top: 12.0, bottom: 12.0),
                            ),
                            validator: (value) {
                              return Validator.required(
                                  value, 3,
                                  'Full Name is required');
                            },
                            onSaved: (name) => _name = name,
                            onFieldSubmitted: (_) {
                              fieldFocusChange(
                                  context, _nameFocusNode,
                                  _emailFocusNode);
                            },
                          ),
                        ),
                        FadeIn(
                          1.4,
                          TextFormField(
                            textCapitalization: TextCapitalization.none,
                            focusNode: _emailFocusNode,
                            keyboardType: TextInputType.emailAddress,
                            decoration: InputDecoration(
                              hintText: 'Email Address',
                              contentPadding: const EdgeInsets.only(
                                  top: 12.0, bottom: 12.0),
                            ),
                            validator: (value) {
                              return Validator.email(value);
                            },
                            onSaved: (email) => _email = email,
                            onFieldSubmitted: (_) {
                              fieldFocusChange(
                                  context, _emailFocusNode,
                                  _usernameFocusNode);
                            },
                          ),
                        ),
                        SizedBox(
                          height: 10.0,
                        ),
                        FadeIn(
                          1.4,
                          TextFormField(
                            textCapitalization: TextCapitalization.none,
                            focusNode: _usernameFocusNode,
                            keyboardType: TextInputType.text,
                            decoration: InputDecoration(
                              hintText: 'Username',
                              contentPadding: const EdgeInsets.only(
                                  top: 12.0, bottom: 12.0),
                            ),
                            validator: (value) {
                              return Validator.required(
                                  value, 3,
                                  'Username is required');
                            },
                            onSaved: (username) => _username = username,
                            onFieldSubmitted: (_) {
                              fieldFocusChange(
                                  context, _usernameFocusNode,
                                  _passwordFocusNode);
                            },
                          ),
                        ),
                        SizedBox(
                          height: 10.0,
                        ),
                        FadeIn(
                          1.6,
                          TextFormField(
                            textCapitalization: TextCapitalization.none,
                            focusNode: _passwordFocusNode,
                            keyboardType: TextInputType.text,
                            decoration: InputDecoration(
                              hintText: 'Password',
                              suffixIcon: IconButton(
                                icon: Icon(_obscureText ? Icons.visibility_off : Icons.visibility),
                                onPressed: _viewPassword,
                              ),
                              contentPadding: const EdgeInsets.only(
                                  top: 12.0, bottom: 12.0),
                            ),
                            obscureText: _obscureText,
                            validator: (value) {
                              return Validator.required(
                                  value, 5,
                                  'Password is required, min length is 6');
                            },
                            onSaved: (password) => _password = password,
                          ),
                        ),
                        SizedBox(
                          height: 10.0,
                        ),
                        FadeIn(
                          1.8,
                          TextFormField(
                            textCapitalization: TextCapitalization.none,
                            focusNode: _cPasswordFocusNode,
                            keyboardType: TextInputType.text,
                            decoration: InputDecoration(
                              hintText: 'Password',
                              suffixIcon: IconButton(
                                icon: Icon(_obscureText ? Icons.visibility_off : Icons.visibility),
                                onPressed: _viewPassword,
                              ),
                              contentPadding: const EdgeInsets.only(
                                  top: 12.0, bottom: 12.0),
                            ),
                            obscureText: _obscureText,
                            validator: (value) {
                              return Validator.required(
                                  value, 5,
                                  'Password must be confirmed');
                            },
                            onSaved: (cpassword) => _cPassword = cpassword,
                          ),
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
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: <Widget>[
                                Icon(
                                  Icons.check,
                                  color: Theme.of(context).primaryColor,
                                ),
                                SizedBox(
                                  width: 7.0,
                                ),
                                Text(
                                  "SIGN UP",
                                  style: TextStyle(
                                    fontFamily: 'Alatsi',
                                    color: Theme.of(context).primaryColor,
                                    fontSize: 16.0,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
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
                FadeIn(
                  2.2,
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Text(
                        'Already have an account?',
                        style: TextStyle(
                          color: Colors.grey[600],
                          fontSize: 15.0,
                          fontFamily: 'Alatsi',
                        ),
                      ),
                      SizedBox(
                        width: 5.0,
                      ),
                      InkWell(
                        child: Text(
                          'Login',
                          style: TextStyle(
                            color: Colors.grey[700],
                            fontSize: 18.0,
                            fontFamily: 'Alatsi',
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => Login(null)),
                          );
                        },
                      ),
                    ],
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
      EasyLoading.show(status: 'Processing your details', maskType: EasyLoadingMaskType.black);

      if (_password != _cPassword) {
          Fluttertoast.showToast(msg: "Password do not match");
          return;
      }

      RegisterResponse _response = await userBloc.register(
          _username, _password, _name, _email);

      if (_response.otp == null) {
        EasyLoading.dismiss();

        ServerValidationDialog.errorDialog(
            context, _response.error, _response.eTitle); //invoking log
      } else {
        EasyLoading.dismiss();

        Navigator.push(context, PageTransition(
            type: PageTransitionType.rightToLeft,
            child: OtpScreen(1, _response, _email)));
      }
    } catch (error) {
      EasyLoading.dismiss();
      ServerValidationDialog.errorDialog(
          context, error.toString(), ''); //invoking log
    }
  }
}
