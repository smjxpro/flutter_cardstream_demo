import 'dart:collection';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'models/payment_info.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final _formKey = GlobalKey<FormState>();
  final _scaffoldKey = GlobalKey<ScaffoldState>();

  PaymentInfo paymentInfo = PaymentInfo();

  var _result;

  static const platform = const MethodChannel('payment');

  Future<void> _makePayment() async {
    Map<String, String> args = HashMap();

    args['amount'] = paymentInfo.amount;
    args['cardNumber'] = paymentInfo.cardNumber;
    args['cardExpiryDate'] = paymentInfo.cardExpiryDate;
    args['cardCVV'] = paymentInfo.cardCVV;
    args['customerAddress'] = paymentInfo.customerAddress;
    args['customerPostCode'] = paymentInfo.customerPostCode;

    try {
      final String res = await platform.invokeMethod('pay', args);

      print(res);
    } on PlatformException catch (e) {
      print(e);
    }
  }

  Future<dynamic> nativeMethodCallHandler(MethodCall methodCall) async {
    switch (methodCall.method) {
      case "show":
        print(" FROM AND: ${methodCall.arguments.toString()}");

        setState(() {
          _result = methodCall.arguments;
        });
        break;

      default:
        print("NOTHING");
        break;
    }
  }

  @override
  void initState() {
    platform.setMethodCallHandler(nativeMethodCallHandler);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        title: Text("CardStream Payment Demo"),
      ),
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.all(8),
          child: Form(
            key: _formKey,
            child: Container(
              width: double.infinity,
              child: ListView(
                children: [
                  Text(
                    _result != null
                        ? "Card Type: " + _result["cardType"]
                        : "Card Type: " + "",
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    _result != null
                        ? "Card Valid: " + _result["cardNumberValid"]
                        : "Card Valid: " + "",
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    _result != null
                        ? "Card Issuer: " + _result["cardIssuer"]
                        : "Card Issuer: " + "",
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  // Text(_result != null ? _result.toString() : ""),

                  Row(
                    children: [
                      Text(
                        'Amount: ',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Expanded(
                        child: TextFormField(
                          keyboardType: TextInputType.number,
                          validator: (value) {
                            if (value.isEmpty) {
                              return 'Please enter amount';
                            }
                            return null;
                          },
                          onSaved: (value) {
                            paymentInfo.amount = value;
                          },
                        ),
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      Text(
                        'Card Number: ',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Expanded(
                        child: TextFormField(
                          keyboardType: TextInputType.number,
                          validator: (value) {
                            if (value.isEmpty) {
                              return 'Please enter card number';
                            }
                            return null;
                          },
                          onSaved: (value) {
                            paymentInfo.cardNumber = value;
                          },
                        ),
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      Text(
                        'Expiry Date: ',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Expanded(
                        child: TextFormField(
                          keyboardType: TextInputType.datetime,
                          validator: (value) {
                            if (value.isEmpty) {
                              return 'Please enter expiry date';
                            }
                            return null;
                          },
                          onSaved: (value) {
                            paymentInfo.cardExpiryDate = value;
                          },
                        ),
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      Text(
                        'CVV: ',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Expanded(
                        child: TextFormField(
                          keyboardType: TextInputType.number,
                          validator: (value) {
                            if (value.isEmpty) {
                              return 'Please enter CVV';
                            }
                            return null;
                          },
                          onSaved: (value) {
                            paymentInfo.cardCVV = value;
                          },
                        ),
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      Text(
                        'Address: ',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Expanded(
                        child: TextFormField(
                          keyboardType: TextInputType.multiline,
                          minLines: 3,
                          maxLines: 3,
                          validator: (value) {
                            if (value.isEmpty) {
                              return 'Please enter address';
                            }
                            return null;
                          },
                          onSaved: (value) {
                            paymentInfo.customerAddress = value;
                          },
                        ),
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      Text(
                        'Post Code: ',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Expanded(
                        child: TextFormField(
                          keyboardType: TextInputType.text,
                          validator: (value) {
                            if (value.isEmpty) {
                              return 'Please enter post code';
                            }
                            return null;
                          },
                          onSaved: (value) {
                            paymentInfo.customerPostCode = value;
                          },
                        ),
                      ),
                    ],
                  ),
                  ElevatedButton(
                    onPressed: () {
                      if (_formKey.currentState.validate()) {
                        // _scaffoldKey.currentState
                        //   ..showSnackBar(
                        //       SnackBar(content: Text('Processing Data')));
                        _formKey.currentState.save();

                        // Navigator.push(
                        //   context,
                        //   MaterialPageRoute(
                        //     builder: (context) => Result(
                        //       paymentInfo: this.paymentInfo,
                        //     ),
                        //   ),
                        // );
                        _makePayment();
                      }
                    },
                    child: Text('Pay'),
                  ),
                  // ElevatedButton(onPressed: _makePayment, child: Text('Pay'))
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
