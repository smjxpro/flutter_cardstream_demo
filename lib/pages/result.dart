import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_cardstream_demo/models/payment_info.dart';

class Result extends StatelessWidget {
  PaymentInfo paymentInfo;

  Result({this.paymentInfo});

  @override
  Widget build(BuildContext context) {
    return (Scaffold(
      appBar: AppBar(
        title: Text('Successful'),
      ),
      body: Container(
        margin: EdgeInsets.all(10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              paymentInfo.amount,
              style: TextStyle(fontSize: 22),
            ),
            Text(
              paymentInfo.cardNumber,
              style: TextStyle(fontSize: 22),
            ),
            Text(
              paymentInfo.cardExpiryDate,
              style: TextStyle(fontSize: 22),
            ),
            Text(
              paymentInfo.cardCVV,
              style: TextStyle(fontSize: 22),
            ),
            Text(
              paymentInfo.customerAddress,
              style: TextStyle(fontSize: 22),
            ),
            Text(
              paymentInfo.customerPostCode,
              style: TextStyle(fontSize: 22),
            ),
          ],
        ),
      ),
    ));
  }
}
