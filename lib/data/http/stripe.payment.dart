import 'dart:convert';

import 'package:bloom/data/http/http.client.dart';
import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';

import 'endpoints.dart';

class StripeSecret {
  final String secret;
  final String error;

  StripeSecret(this.secret, this.error);

  StripeSecret.fromJson(json)
      : secret = json['secret'],
        error = "";

  StripeSecret.withError(String msg, String title)
      : secret = null,
        error = msg;
}

class PaymentResponse {
  String email;
  String response;
  double amount;
  double amountPaid;
  String status;
  String type;
  int paymentMethodId;
  int orderId;
  String error;

  PaymentResponse({this.email, this.response, this.amount, this.amountPaid, this.status, this.paymentMethodId, this.orderId, this.error });

  PaymentResponse.fromJson(Map<String, dynamic> json) {
    email = json['email'];
    response = json['response'];
    status = json['status'];
    type = json['type'];
    amount = double.parse(json['amount'].toString());
    amountPaid = double.parse(json['amount_paid'].toString());
    orderId = int.parse(json['order_id'].toString());
    paymentMethodId = int.parse(json['payment_method_id'].toString());
    error = json['error'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> json = new Map<String, dynamic>();
    json['email'] = email;
    json['amount'] = amount;
    json['amount_paid'] = amountPaid;
    json['payment_method_id'] = paymentMethodId;
    json['order_id'] = orderId;
    json['error'] = error;
    json['status'] = status;
    json['type'] = type;
    json['response'] = response;

    return json;
  }
}

class StripeSecretApiProvider {
  Future<StripeSecret> getSecret(
      String email, String paymentMethodId, double amount) async {
    try {
      final Dio _dio = await HttpClient.http();
      Response response = await _dio.post(paymentSecretEndpoint, data: {
        'email': email,
        'payment_method_id': paymentMethodId,
        'amount': amount
      });
      return StripeSecret.fromJson(response.data);
    } catch (e) {
      if (e.response != null) {
        Map<String, dynamic> error = json.decode(e.response.toString());
        return StripeSecret.withError(error['message'], error['error']);
      }
      return StripeSecret.withError(e.message, "Network Error");
    }
  }

  Future<bool> savePayment(PaymentResponse resp) async {
    try {
      final Dio _dio = await HttpClient.http();
      Response response = await _dio.put(paymentLogEndpoint,
          data: resp.toJson());
      return true;
    } catch (e) {
      debugPrint(e.toString());
      return false;
    }
  }
}
