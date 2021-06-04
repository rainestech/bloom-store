import 'package:bloom/Animation/slide_left_rout.dart';
import 'package:bloom/AppTheme/theme.dart';
import 'package:bloom/data/http/stripe.payment.dart';
import 'package:bloom/helpers/helper.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:stripe_sdk/stripe_sdk.dart';
import 'package:stripe_sdk/stripe_sdk_ui.dart';

import '../home.dart';


class PaymentPage extends StatefulWidget {
  final PaymentResponse paymentResponse;

  const PaymentPage({Key key, this.paymentResponse}) : super(key: key);
  @override
  _PaymentPageState createState() => _PaymentPageState();
}

class _PaymentPageState extends State<PaymentPage> {
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  final StripeCard card = StripeCard();
  final _provider = StripeSecretApiProvider();
  final GlobalKey<State> _keyLoader = new GlobalKey<State>();

  final Stripe stripe = Stripe(
    "pk_test_51HsR3wGaJnbtdG28cW9E5DCOpj1eh6R5CGb550AY6BkDjAzomSdffYaaQqzsVtrvWhHJhJZtEkk3reLlzXECypOl00HvkfCg7U",
    //Your Publishable Key
    returnUrlForSca: "stripesdk://3ds.stripesdk.io", //Return URL for SCA
  );

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;

    return Scaffold(
      appBar: AppBar(
        title: Text('Payment'),
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
                  'We Accept',
                  style: TextStyle(
                      fontSize: 20.0,
                      color: AppColors.secondaryColor,
                      fontWeight: FontWeight.bold,
                      fontFamily: 'Alatsi',
                      height: 1.6),
                  textAlign: TextAlign.center,
                ),
                SizedBox(
                  height: 20.0,
                ),
                Text(
                  'Credit / Debit Card',
                  style: TextStyle(
                      fontSize: 16.0,
                      color: AppColors.themeDark,
                      fontWeight: FontWeight.bold,
                      fontFamily: 'Alatsi',
                      height: 1.6),
                  textAlign: TextAlign.center,
                ),
                SizedBox(
                  height: 20.0,
                ),
                Container(
                  width: width - 20.0,
                  height: 60,
                  margin: EdgeInsets.only(top: 10.0, bottom: 10.0),
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      image: AssetImage('assets/cards.png'),
                      fit: BoxFit.fitWidth,
                    )
                  ),
                ),
                Divider(
                  height: 1.0,
                ),
                CardForm(
                  formKey: formKey,
                  card: card,
                ),
                Divider(
                  height: 1.0,
                ),
                Container(
                  padding: EdgeInsets.only(right:30, left:30),
                  child: Row(
                    children: [
                      Text(
                        'Total Amount:',
                        style: TextStyle(
                            fontSize: 20.0,
                            color: AppColors.secondaryColor,
                            fontWeight: FontWeight.bold,
                            fontFamily: 'Alatsi',
                            height: 1.6),
                        textAlign: TextAlign.center,
                      ),
                      Spacer(),
                      Text(
                        '\$${numberFormat.format(widget.paymentResponse.amount)}',
                        style: TextStyle(
                            fontSize: 20.0,
                            color: AppColors.themeRed,
                            fontWeight: FontWeight.bold,
                            fontFamily: 'Alatsi',
                            height: 1.6),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                ),
                Divider(
                  height: 1.0,
                ),
                SizedBox(
                  height: 40.0,
                ),
                Material(
                  elevation: 5.0,
                  borderRadius: BorderRadius.circular(30.0),
                  child: InkWell(
                    onTap: () {
                      formKey.currentState.validate();
                      formKey.currentState.save();
                      buy(context);
                    },
                    child: Container(
                      width: width - 40.0,
                      padding: EdgeInsets.all(15.0),
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        color: Theme.of(context).primaryColor,
                        borderRadius: BorderRadius.circular(30.0),
                      ),
                      child: Text(
                        'Pay',
                        style: TextStyle(
                            color: Colors.white,
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

  void buy(context) async {
    EasyLoading.show(status: 'Processing your payment', maskType: EasyLoadingMaskType.black);

    final StripeCard stripeCard = card;

    if (!stripeCard.validateCVC()) {
      showAlertDialog(context, "Error", "CVC not valid.", false);
      return;
    }
    if (!stripeCard.validateDate()) {
      showAlertDialog(context, "Error", "Date not valid.", false);
      return;
    }
    if (!stripeCard.validateNumber()) {
      showAlertDialog(context, "Error", "Number not valid.", false);
      return;
    }

    Map<String, dynamic> paymentIntentRes = await createPaymentIntent(stripeCard, widget.paymentResponse);
    String clientSecret = paymentIntentRes['client_secret'];
    String paymentMethodId = paymentIntentRes['payment_method'];
    String status = paymentIntentRes['status'];

    if (status == 'requires_action') //3D secure is enable in this card
      paymentIntentRes =
      await confirmPayment3DSecure(clientSecret, paymentMethodId);

    if (paymentIntentRes['status'] != 'succeeded') {
      showAlertDialog(context, "Warning", "Canceled Transaction.", false);
      return;
    }

    if (paymentIntentRes['status'] == 'succeeded') {
      await logPayment(paymentIntentRes);
      showAlertDialog(
          context,
          "Payment Success",
          "Thanks for Shopping with us, your order will be on its way to you soon!",
          true);
      return;
    }
    showAlertDialog(context, "Warning",
        "Transaction rejected.\nSomething went wrong", false);
  }

  Future<Map<String, dynamic>> createPaymentIntent(
      StripeCard stripeCard, PaymentResponse paymentResponse) async {
    String clientSecret;
    Map<String, dynamic> paymentIntentRes, paymentMethod;
    try {
      paymentMethod = await stripe.api.createPaymentMethodFromCard(stripeCard);
      StripeSecret clientRes = await _provider.getSecret(paymentResponse.email, paymentMethod['id'], paymentResponse.amount);
      if (clientRes.secret == null) {
        throw Exception(clientRes.error);
      }
      clientSecret = clientRes.secret;
      paymentIntentRes = await stripe.api.retrievePaymentIntent(clientSecret);
    } catch (e) {
      print("ERROR_CreatePaymentIntentAndSubmit: $e");
      showAlertDialog(context, "Error", "Something went wrong.", false);
    }
    return paymentIntentRes;
  }

  Future<Map<String, dynamic>> confirmPayment3DSecure(
      String clientSecret, String paymentMethodId) async {
    Map<String, dynamic> paymentIntentRes_3dSecure;
    try {
      await stripe.confirmPayment(clientSecret,
          paymentMethodId: paymentMethodId);
      paymentIntentRes_3dSecure =
      await stripe.api.retrievePaymentIntent(clientSecret);
    } catch (e) {
      print("ERROR_ConfirmPayment3DSecure: $e");
      showAlertDialog(context, "Error", "Something went wrong.", false);
    }
    return paymentIntentRes_3dSecure;
  }

  showAlertDialog(
      BuildContext context, String title, String message, bool success) async {
    await Future.delayed(Duration(seconds: 2));
    EasyLoading.dismiss();

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(title),
          content: Text(message),
          actions: [
            TextButton(
                child: Text("OK"),
                onPressed: () => {
                  Navigator.of(context).pop(),
                  if (success) {
                    Navigator.of(context).pop(),
                    Navigator.of(context).pop(),
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => Home(),
                      ),
                    )
                  }
                }),
          ],
        );
      },
    );
  }

  logPayment(Map<String, dynamic> paymentIntentRes) async {
    var log = widget.paymentResponse;
    log.response = paymentIntentRes.toString();
    log.status = 'paid';
    log.amountPaid = double.parse(paymentIntentRes['amount'].toString());
    log.paymentMethodId = 1;
    _provider.savePayment(widget.paymentResponse);
  }
}
