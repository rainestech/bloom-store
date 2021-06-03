import 'dart:async';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:bloom/Animation/fadeIn.dart';
import 'package:bloom/AppTheme/theme.dart';
import 'package:bloom/bloc/user.bloc.dart';
import 'package:bloom/data/http/user.dart';
import 'package:bloom/helpers/form.validators.dart';
import 'package:bloom/helpers/helper.dart';
import 'package:bloom/pages/container.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:page_transition/page_transition.dart';

import 'login.dart';

class OtpScreen extends StatefulWidget {
  final mode;
  final data;
  final email;

  const OtpScreen(this.mode, this.data, this.email);

  @override
  _OtpScreenState createState() => _OtpScreenState();
}

class _OtpScreenState extends State<OtpScreen> {
  var firstController = TextEditingController();
  var secondController = TextEditingController();
  var thirdController = TextEditingController();
  var fourthController = TextEditingController();
  FocusNode secondFocusNode = FocusNode();
  FocusNode thirdFocusNode = FocusNode();
  FocusNode fourthFocusNode = FocusNode();
  FocusNode _passwordFocusNode = FocusNode();
  FocusNode _cPasswordFocusNode = FocusNode();
  final _formKey = GlobalKey<FormState>();
  bool _obscureText = true;
  Timer _timer;
  int _start = 60;

  bool _pinValid = false;
  String _password;
  String _cPassword;
  String _otp;

  void startTimer() {
    _timer = new Timer.periodic(
      Duration(seconds: 1),
          (Timer timer) {
        if (_start == 0) {
          if (mounted) {
            setState(() {
              timer.cancel();
            });
          }
        } else {
          if (mounted) {
            setState(() {
              _start--;
            });
          }
        }
      },
    );
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    _start = 60;
    startTimer();
    _otp = widget.data.otp;
  }

  void _viewPassword() {
    setState(() {
      _obscureText = !_obscureText;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // backgroundColor: AppColors.themeDark.withOpacity(0.5),
      body: ListView(
        children: <Widget>[
          Container(
            padding: EdgeInsets.only(top: 70.0, right: 30.0, left: 30.0),
            child: FadeIn(
              1.0,
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Text(
                    "OTP",
                    style: TextStyle(
                      color: AppColors.primaryColor,
                      fontSize: 35.0,
                      fontWeight: FontWeight.bold,
                      fontFamily: 'Alatsi',
                    ),
                  ),
                ],
              ),
            ),
          ),
          SizedBox(height: 10,),
          AutoSizeText('Enter the OTP sent to your email to proceed',
            maxLines: 2,
            textAlign: TextAlign.center,
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
                  height: 30.0,
                ),
                if (!_pinValid)
                  FadeIn(
                  1.4,
                  // OTP Box Start
                  Padding(
                    padding: EdgeInsets.only(left: 10.0, right: 10),
                    child:
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
                        // 1 Start
                        Container(
                          width: 50.0,
                          height: 50.0,
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(5.0),
                            boxShadow: <BoxShadow>[
                              BoxShadow(
                                blurRadius: 1.5,
                                spreadRadius: 1.5,
                                color: AppColors.themeDark,
                              ),
                            ],
                          ),
                          child: TextFormField(
                            controller: firstController,
                            keyboardType: TextInputType.number,
                            decoration: InputDecoration(
                              contentPadding: EdgeInsets.all(18.0),
                              border: InputBorder.none,
                            ),
                            onChanged: (v) {
                              FocusScope.of(context)
                                  .requestFocus(secondFocusNode);
                            },
                            validator: (value) {
                              return Validator.required(value, 0, '');
                            },
                          ),
                        ),
                        // 1 End
                        // 2 Start
                        Container(
                          width: 50.0,
                          height: 50.0,
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(5.0),
                            boxShadow: <BoxShadow>[
                              BoxShadow(
                                blurRadius: 1.5,
                                spreadRadius: 1.5,
                                color: AppColors.themeDark,
                              ),
                            ],
                          ),
                          child: TextFormField(
                            focusNode: secondFocusNode,
                            controller: secondController,
                            keyboardType: TextInputType.number,
                            decoration: InputDecoration(
                              contentPadding: EdgeInsets.all(18.0),
                              border: InputBorder.none,
                            ),
                            validator: (value) {
                              return Validator.required(value, 0, '');
                            },
                            onChanged: (v) {
                              FocusScope.of(context).requestFocus(
                                  thirdFocusNode);
                            },
                          ),
                        ),
                        // 2 End
                        // 3 Start
                        Container(
                          width: 50.0,
                          height: 50.0,
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(5.0),
                            boxShadow: <BoxShadow>[
                              BoxShadow(
                                blurRadius: 1.5,
                                spreadRadius: 1.5,
                                color: AppColors.themeDark,
                              ),
                            ],
                          ),
                          child: TextFormField(
                            focusNode: thirdFocusNode,
                            controller: thirdController,
                            keyboardType: TextInputType.number,
                            decoration: InputDecoration(
                              contentPadding: EdgeInsets.all(18.0),
                              border: InputBorder.none,
                            ),
                            validator: (value) {
                              return Validator.required(value, 0, '');
                            },
                            onChanged: (v) {
                              FocusScope.of(context)
                                  .requestFocus(fourthFocusNode);
                            },
                          ),
                        ),
                        // 3 End
                        // 4 Start
                        Container(
                          width: 50.0,
                          height: 50.0,
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(5.0),
                            boxShadow: <BoxShadow>[
                              BoxShadow(
                                blurRadius: 1.5,
                                spreadRadius: 1.5,
                                color: AppColors.themeDark,
                              ),
                            ],
                          ),
                          child: TextFormField(
                            focusNode: fourthFocusNode,
                            controller: fourthController,
                            keyboardType: TextInputType.number,
                            decoration: InputDecoration(
                              contentPadding: EdgeInsets.all(18.0),
                              border: InputBorder.none,
                            ),
                            validator: (value) {
                              return Validator.required(value, 0, '');
                            },
                            onChanged: (v) {
                              checkPin(v, context);
                            },
                          ),
                        ),
                        // 4 End
                      ],
                    ),
                  ), // OTP Box End

                ),
                if (!_pinValid)
                  SizedBox(height: 30.0),
                if (!_pinValid)
                  FadeIn(
                  1.6,
                  Padding(
                    padding: EdgeInsets.only(left: 10.0, right: 10),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      // crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
                        Text(
                          _start == 0
                              ? 'Didn\'t receive OTP Code!'
                              : 'Email Sent! Check Your Inbox',
                          style: TextStyle(
                            fontSize: 13.0,
                            color: Colors.grey[500],
                          ),
                        ),
                        SizedBox(width: 10.0),
                        InkWell(
                          onTap: () {
                            if (_start == 0) {
                              resendOtp();
                            }
                          },
                          child: Text(
                            _start == 0 ? 'Resend' : _start.toString(),
                            style: TextStyle(
                              fontSize: 13.0,
                              color: AppColors.themeDark,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                if (!_pinValid)
                  SizedBox(height: 30.0),
                if (_pinValid)
                  Form(
                    key: _formKey,
                    child: Container(
                      child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        SlideDown(
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
                            onFieldSubmitted: (_) {
                              fieldFocusChange(
                                  context, _passwordFocusNode,
                                  _cPasswordFocusNode);
                            },
                          ),
                      ),

                      SizedBox(height: 25.0,),

                      SlideDown(
                        1.6,
                        TextFormField(
                          textCapitalization: TextCapitalization.none,
                          keyboardType: TextInputType.text,
                          focusNode: _cPasswordFocusNode,
                          decoration: InputDecoration(
                            hintText: 'Confirm Password',
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
                                'Password must match');
                          },
                          onSaved: (cPassword) => _cPassword = cPassword,
                        ),
                      ),

                       SizedBox(height: 30.0),
                      FadeIn(
                      1.6,
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
                                      "Reset Password",
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
                              resetPassword(context);
                            }
                        },
                      ),
                    ),
                  ]),
                )),
                SizedBox(height: 25,),
                FadeIn(
                  1.8,
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Text(
                        'Go To',
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

  Future<void> checkPin(String v, BuildContext context) async {
    try {
      if (v.length < 1) {
        return;
      }
      String otp = firstController.value.text + secondController.value.text +
          thirdController.value.text + fourthController.value.text;
      if (otp == _otp) {
        EasyLoading.show(status: 'Processing your details', maskType: EasyLoadingMaskType.black);

        if (widget.mode == 1) {
          UserResponse _response = await userBloc.verify(
              otp, widget.email);

          if (_response.error.length > 0) {
            EasyLoading.dismiss();

            ServerValidationDialog.errorDialog(
                context, _response.error, ""); //invoking log
          } else {
            EasyLoading.dismiss();

            Navigator.push(context, PageTransition(
                type: PageTransitionType.rightToLeft,
                child: ScreenContainer(3)));
          }
        } else {
          EasyLoading.dismiss();
          setState(() {
            _pinValid = true;
          });
        }
      } else {
        ServerValidationDialog.errorDialog(
            context, 'Please check again.', 'Invalid input'); //invoking log
      }
    } catch (error) {
     EasyLoading.dismiss();
      ServerValidationDialog.errorDialog(
          context, 'An Error Occurred. Pls try again', ""); //invoking log
    }
  }

  Future<void> resendOtp() async {
    try {
      print(widget.email);
      EasyLoading.show(status: 'Processing your request...', maskType: EasyLoadingMaskType.black);

      RegisterResponse _response = await userBloc.resendOtp(widget.email);

      if (_response.otp != null) {
        EasyLoading.dismiss();
        EasyLoading.showSuccess('Otp Resent Successfully', maskType: EasyLoadingMaskType.black, duration: Duration(seconds: 5));
        setState(() {
          _otp = _response.otp;
        });
      } else {
        EasyLoading.dismiss();
        EasyLoading.showError('An Error Occurred during the process, try again!', maskType: EasyLoadingMaskType.black, duration: Duration(seconds: 5));
      }
    } catch (e) {
      EasyLoading.dismiss();
      EasyLoading.showError('An Error Occurred during the process, try again!', maskType: EasyLoadingMaskType.black, duration: Duration(seconds: 5));
    }
  }

  Future<void> resetPassword(BuildContext context) async {
    try {
      EasyLoading.show(status: 'Processing your request...', maskType: EasyLoadingMaskType.black);

     RegisterResponse _response = await userBloc.setNewPassword(
          widget.email, _password, _otp);

      if (_response.error.length > 0) {
        EasyLoading.dismiss();

        ServerValidationDialog.errorDialog(
            context, _response.error, ""); //invoking log
      }
      else {
        EasyLoading.dismiss();

        showDialog<void>(
            context: context,
            barrierDismissible: true,
            builder: (BuildContext context) {
              return new WillPopScope(
                  onWillPop: () async => false,
                  child: Dialog(
                      backgroundColor: AppColors.secondaryColor,
                      child: Container(
                        padding: EdgeInsets.all(20.0),
                        child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              AutoSizeText(
                                'Password Reset Success',
                                style: TextStyle(
                                  color: AppColors.themeDark,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 18,
                                ),
                              ),
                              SizedBox(
                                height: 10,
                              ),
                              AutoSizeText(
                                'Your Password has been reset successfully. Click Ok to proceed to  Login',
                                style: TextStyle(color: AppColors.themeDark),
                              ),
                              SizedBox(
                                height: 10,
                              ),
                              InkWell(
                                onTap: () {
                                  Navigator.pop(context);
                                  Navigator.push(
                                      context,
                                      PageTransition(
                                          type: PageTransitionType.rightToLeft,
                                          child: Login(null)));
                                },
                                child: Container(
                                  width: 100,
                                  alignment: Alignment.center,
                                  padding: EdgeInsets.all(10.0),
                                  decoration: BoxDecoration(
                                    color: AppColors.primaryColor,
                                    borderRadius: BorderRadius.circular(5.0),
                                  ),
                                  child: Text(
                                    'Ok',
                                    style: TextStyle(
                                      fontFamily: 'Signika Negative',
                                      fontWeight: FontWeight.w700,
                                      color: AppColors.themeDark
                                    ),
                                  ),
                                ),
                              ),
                            ]),
                      )));
            });
      }
    } catch (e) {
      EasyLoading.dismiss();

      ServerValidationDialog.errorDialog(
      context, 'An Error Occurred. Pls check your Network Connection and try again', "");
    }
  }
}
