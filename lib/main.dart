import 'dart:collection';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_cardstream_demo/models/payment_info.dart';
import 'package:flutter_cardstream_demo/pages/result.dart';

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
        // This is the theme of your application.
        //
        // Try running your application with "flutter run". You'll see the
        // application has a blue toolbar. Then, without quitting the app, try
        // changing the primarySwatch below to Colors.green and then invoke
        // "hot reload" (press "r" in the console where you ran "flutter run",
        // or simply save your changes to "hot reload" in a Flutter IDE).
        // Notice that the counter didn't reset back to zero; the application
        // is not restarted.
        primarySwatch: Colors.blue,
        // This makes the visual density adapt to the platform that you run
        // the app on. For desktop platforms, the controls will be smaller and
        // closer together (more dense) than on mobile platforms.
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

  HashMap<String, dynamic> _result = HashMap();

  static const platform =
      const MethodChannel('flutter_cardstream_demo.smj.xyz/payment');

  Future<void> _makePayment() async {
    HashMap<String, dynamic> result;

    HashMap<String, dynamic> args = HashMap();

    args['amount'] = paymentInfo.amount;
    args['cardNumber'] = paymentInfo.cardNumber;
    args['cardExpiryDate'] = paymentInfo.cardExpiryDate;
    args['cardCVV'] = paymentInfo.cardCVV;
    args['customerAddress'] = paymentInfo.customerAddress;
    args['customerPostCode'] = paymentInfo.customerPostCode;

    try {
      final HashMap<String, dynamic> res =
          await platform.invokeMethod('makePayment', args);
      result = res;
    } on PlatformException catch (e) {
      print(e);
    }

    setState(() {
      _result = result;
    });
  }

  Future<dynamic> nativeMethodCallHandler(MethodCall methodCall) async {
    switch (methodCall.method) {
      case "getGatewayResponse":
        setState(() {
          _result = methodCall.arguments;
          print(" FROM AND: ${methodCall.arguments}");
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
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.all(8),
          child: Form(
            key: _formKey,
            child: Container(
              width: double.infinity,
              child: ListView(
                children: [
                  Text(_result.toString()),
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
                          keyboardType: TextInputType.text,
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
                          keyboardType: TextInputType.streetAddress,
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
                          keyboardType: TextInputType.number,
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
                    child: Text('Submit'),
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
