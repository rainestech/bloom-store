
import 'package:bloom/Animation/fadeIn.dart';
import 'package:bloom/AppTheme/theme.dart';
import 'package:bloom/bloc/user.bloc.dart';
import 'package:bloom/data/http/user.dart';
import 'package:bloom/helpers/firestore.db.dart';
import 'package:bloom/helpers/form.validators.dart';
import 'package:bloom/helpers/helper.dart';
import 'package:bloom/pages/container.dart';
import 'package:bloom/pages/profile/my_account.dart';
import 'package:bloom/pages/auth/signup.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_sign_in/google_sign_in.dart';

import 'forgot_password.dart';

class Login extends StatefulWidget {
  final String _next;

  const Login(this._next);

  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  // Initially password is obscure
  bool _obscureText = true;

  FocusNode _usernameFocusNode = FocusNode();
  FocusNode _passwordFocusNode = FocusNode();
  String _username;
  String _password;
  final _formKey = GlobalKey<FormState>();
  final GoogleSignIn _googleLogin = GoogleSignIn(
    scopes: [
      'email',
      'https://www.googleapis.com/auth/contacts.readonly',
    ],
  );

  // Toggles the password show status
  void _viewPassword() {
    setState(() {
      _obscureText = !_obscureText;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body:ListView(
        children: <Widget>[
          Container(
            padding: EdgeInsets.only(top: 20.0, right: 30.0, left: 30.0),
            child: FadeIn(
              1.0,
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Text(
                    "Login",
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 40.0,
                      fontWeight: FontWeight.bold,
                      fontFamily: 'Alatsi',
                    ),
                  ),
                  InkWell(
                    child: Text(
                      'Sign Up',
                      textAlign: TextAlign.end,
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
                        MaterialPageRoute(builder: (context) => Signup()),
                      );
                    },
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
                    width: 100.0,
                    height: 100.0,
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
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      FadeIn(
                        1.4,
                        TextFormField(
                          textCapitalization: TextCapitalization.none,
                          focusNode: _usernameFocusNode,
                          keyboardType: TextInputType.text,
                          decoration: InputDecoration(
                            hintText: 'Username or Email Address',
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
                              icon: Icon(_obscureText ? Icons.visibility : Icons.visibility_off),
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
                        Container(
                          alignment: Alignment.bottomRight,
                          child: InkWell(
                            child: Text(
                              'Forgot Password?',
                              style: TextStyle(
                                color: Colors.grey[700],
                                fontFamily: 'Alatsi',
                                fontSize: 15.0,
                              ),
                            ),
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => ForgotPassword()),
                              );
                            },
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 50.0),
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
                                  "LOGIN",
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
                        login(context);
                      } else {
                        Fluttertoast.showToast(
                          msg: 'Invalid Input',
                          backgroundColor: Colors.black,
                          textColor: AppColors.white,
                        );
                      }
                    },
                  ),
                ),
                SizedBox(
                  height: 25.0,
                ),
                FadeIn(
                  2.2,
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Text(
                        'Don\'t Have an Account?',
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
                          'Register',
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
                            MaterialPageRoute(builder: (context) => Signup()),
                          );
                        },
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  height: 15.0,
                ),
                FadeIn(
                  2.4,
                  Text(
                    "Or Connect With",
                    style: TextStyle(
                      color: Colors.grey,
                      fontSize: 18.0,
                      fontFamily: 'Alatsi',
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                SizedBox(
                  height: 15.0,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    FadeIn(
                      2.6,
                      InkWell(
                        child: Container(
                          width: 60.0,
                          height: 60.0,
                          decoration: new BoxDecoration(
                            color: Colors.white,
                            image: new DecorationImage(
                              image: new AssetImage('assets/google.png'),
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                        onTap: () {
                          _googleLogin.signIn().then((acc) => {
                            if (acc != null)
                              {
                                print(acc),
                                _loginGoogle(acc),
                              }
                          });
                        },
                      ),
                    ),
                    SizedBox(
                      width: 18.0,
                    ),
                    FadeIn(
                      2.8,
                      InkWell(
                        child: Container(
                          width: 60.0,
                          height: 60.0,
                          decoration: new BoxDecoration(
                            color: const Color(0xff7c94b6),
                            image: new DecorationImage(
                              image: new AssetImage('assets/fb.png'),
                              fit: BoxFit.cover,
                            ),
                            borderRadius: new BorderRadius.all(
                                new Radius.circular(30.0)),
                            border: new Border.all(width: 0.0),
                          ),
                        ),
                        onTap: () {
                          _fbLogin();
                        },
                      ),
                    ),
                  ],
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

  Future<void> login(BuildContext context) async {
    // try {
     EasyLoading.show(status: 'login you in...', maskType: EasyLoadingMaskType.black);

      UserResponse _response = await userBloc.login(
          _username, _password);
      if (_response.error.length > 0) {
        EasyLoading.dismiss();

        ServerValidationDialog.errorDialog(
            context, _response.error, _response.eTitle); //invoking log
      } else {
        _successRoute(_response);
      }
    // } catch (error) {
    //   EasyLoading.dismiss();
    //   ServerValidationDialog.errorDialog(
    //       context, 'Invalid credentials', ''); //invoking log
    // }
  }

  _loginGoogle(GoogleSignInAccount acc) async {
    EasyLoading.show(status: 'login you in...', maskType: EasyLoadingMaskType.black);
    print(acc);
    try {
      final resp = await userBloc.googleLogin(acc);

      print(resp.data?.email);
      if (resp.data != null) {
        EasyLoading.dismiss();
        _successRoute(resp);
      }
    } catch (e) {
      print(e.toString());
      EasyLoading.showError('An Error Occurred, Please try again',
          maskType: EasyLoadingMaskType.black,
          dismissOnTap: true
      );
    }
  }

  _fbLogin() async {
    EasyLoading.show(status: 'login you in...', maskType: EasyLoadingMaskType.black);
    final LoginResult result = await FacebookAuth.instance.login(); // by default we request the email and the public profile
    if (result.status == LoginStatus.success) {
      final userData = await FacebookAuth.instance.getUserData();
      var data = {
        'id': userData['id'],
        'displayName': userData['name'],
        'email': userData['email'],
        'photoUrl': userData['picture']['data']['url']
      };

      final resp = await userBloc.facebookLogin(data);
      EasyLoading.dismiss();
      _successRoute(resp);
    } else {
      EasyLoading.showError('We could not log you in, please try again!',
          maskType: EasyLoadingMaskType.black,
          dismissOnTap: true
      );
    }

  }

  _successRoute(UserResponse response) {
    EasyLoading.dismiss();

    fbAuth.signInWithCustomToken(response.data.gToken).then((value) =>
        FirestoreHelper.addUserToken(response.data));

    if (widget._next != null && widget._next == 'profile') {
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(
          builder: (BuildContext context) => ScreenContainer(4),
        ),
        ModalRoute.withName('container'),
      );
    } else {
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(
          builder: (BuildContext context) => ScreenContainer(3),
        ),
        ModalRoute.withName('/container'),
      );
    }
  }
}
