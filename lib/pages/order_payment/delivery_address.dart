import 'package:bloom/Animation/slide_left_rout.dart';
import 'package:bloom/AppTheme/theme.dart';
import 'package:bloom/bloc/vendor.bloc.dart';
import 'package:bloom/data/entity/personnel.entity.dart';
import 'package:bloom/data/entity/vendor.entity.dart';
import 'package:bloom/data/http/vendor.provider.dart';
import 'package:bloom/helpers/form.validators.dart';
import 'package:bloom/helpers/helper.dart';
import 'package:bloom/pages/order_payment/checkout.dart';
import 'package:bloom/pages/order_payment/payment.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';


class Delivery extends StatefulWidget {
  final Person person;
  final Address address;
  final List<Cart> cart;

  const Delivery({Key key, this.person, this.cart, this.address}) : super(key: key);
  @override
  _DeliveryState createState() => _DeliveryState();
}

class _DeliveryState extends State<Delivery> {
  Address _address;
  List<Country> _countries = [];
  FocusNode _cityFocus = FocusNode();
  FocusNode _countryFocus = FocusNode();
  FocusNode _provinceFocus = FocusNode();
  FocusNode _postalCodeFocus = FocusNode();
  FocusNode _addressFocus = FocusNode();

  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();

    setState(() {
      _address = widget.address == null ? new Address() : widget.address;
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

    vendorBloc.getCountries();
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;

    return Scaffold(
      appBar: AppBar(
        title: Text('Shipping Address',
          style: TextStyle(
            color: AppColors.themeDark
          ),
        ),
        backgroundColor: AppColors.primaryColor,
        titleSpacing: 0.0,
      ),
      body: ListView(
        shrinkWrap: true,
        children: <Widget>[
          Container(
            padding: EdgeInsets.all(15.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Text(
                  '',
                  style: TextStyle(
                      fontSize: 30.0,
                      color: Colors.grey,
                      fontWeight: FontWeight.bold,
                      fontFamily: 'Alatsi',
                      height: 1.6),
                  textAlign: TextAlign.center,
                ),
                Form(
                  key: _formKey,
                  child:
                  Container(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      mainAxisSize: MainAxisSize.min,
                      children: <Widget>[
                        DropdownButtonFormField<Country>(
                          focusNode: _countryFocus,
                          isExpanded: true,
                          value: _address.country,
                          hint: Text("Delivery Country"),
                          icon: const Icon(Icons.arrow_downward),
                          iconSize: 24,
                          elevation: 16,
                          style: TextStyle(color: Colors.black),
                          onChanged: (Country newValue) {
                            setState(() {
                              _address.country = newValue;
                            });
                          },
                          validator: (value) {
                            return Validator.required(
                                value.name, 1,
                                'Country is required');
                          },
                          items: _countries
                              .map<DropdownMenuItem<Country>>((Country value) {
                            return DropdownMenuItem<Country>(
                              value: value,
                              child: Text(value.name),
                            );
                          }).toList(),
                        ),
                        SizedBox(height: 10,),
                        TextFormField(
                          textCapitalization: TextCapitalization.words,
                          focusNode: _provinceFocus,
                          initialValue: _address.province != null ? _address.province : '',
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
                          onSaved: (province) => _address.province = province,
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
                          initialValue: _address.city,
                          keyboardType: TextInputType.text,
                          decoration: InputDecoration(
                            hintText: 'City',
                            contentPadding: const EdgeInsets.only(
                                top: 12.0, bottom: 12.0),
                          ),
                          validator: (value) {
                            return Validator.required(value, 3,
                                'City is required');
                          },
                          onSaved: (city) => _address.city = city,
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
                          initialValue: _address.address,
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
                          onSaved: (address) => _address.address = address,
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
                          initialValue: _address.postalcode,
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
                          onSaved: (code) => _address.postalcode = code,
                        ),

                        SizedBox(height: 10.0,),

                      ],
                    ),
                  ),
                ),
                Material(
                  elevation: 5.0,
                  borderRadius: BorderRadius.circular(30.0),
                  child: InkWell(
                    onTap: (){
                      // Navigator.push(context, SlideLeftRoute(page: PaymentPage()));
                      if (_formKey.currentState.validate()) {
                        _formKey.currentState.save();
                        _saveAddress(context);
                      }
                    },
                    child: Container(
                      width: width - 40.0,
                      padding: EdgeInsets.all(15.0),
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        color: AppColors.primaryColor,
                        borderRadius: BorderRadius.circular(30.0),
                      ),
                      child: Text(
                        'Save Address',
                        style: TextStyle(
                            color: AppColors.themeDark,
                            fontSize: 18.0,
                            fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _saveAddress(BuildContext context) async {
    try {
      _address.type = 'shipping';
      _address.name = widget.person.name;
      _address.person = widget.person;
      _address.person.addresses = null;

      AddressResponse response = await vendorBloc.saveAddress(_address);
      if (response.data == null) {
        EasyLoading.dismiss();

        ServerValidationDialog.errorDialog(
            context, response.error, response.eTitle); //invoking log
      } else {
        EasyLoading.dismiss();
        EasyLoading.showSuccess('Shipping Address saved successfully', maskType: EasyLoadingMaskType.black, duration: Duration(seconds: 5));
        var person = widget.person;
        person.addresses = person.addresses == null ? [] : person.addresses;
        var addresses = person.addresses.where((e) => e.type != 'shipping', ).toList();
        addresses.add(response.data);
        person.addresses = addresses;
        Navigator.push(context,
            MaterialPageRoute(
                builder: (context) =>
                    CheckoutPage(cart: widget.cart, person: person,)));
      }
    }
    catch(e) {
      EasyLoading.dismiss();
      ServerValidationDialog.errorDialog(
          context, e.toString(), '');
    }
  }
}
