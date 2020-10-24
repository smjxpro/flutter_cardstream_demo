package com.example.flutter_cardstream_demo

import android.os.AsyncTask
import android.util.Log
import com.example.flutter_cardstream_demo.payment.Gateway
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel
import java.math.BigDecimal

class MainActivity : FlutterActivity() {
    private lateinit var channel: MethodChannel

    val TAG: String = "TAG"

    val DIRECT_URL = "https://gateway.cardstream.com/direct/"
    val MERCHANT_ID = "100001"
    val MERCHANT_SECRET = "Circle4Take40Idea"

    val gateway = Gateway(DIRECT_URL, MERCHANT_ID, MERCHANT_SECRET)

    private val CHANNEL = "payment"

    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)

        channel = MethodChannel(flutterEngine.dartExecutor.binaryMessenger, CHANNEL)

        channel.setMethodCallHandler { call, result ->
            if (call.method == "pay") {
                val amount: String = call.argument<String>("amount").toString()
                val cardNumber: String = call.argument<String>("cardNumber").toString()
                val cardExpiryDate: String = call.argument<String>("cardExpiryDate").toString()
                val cardCVV: String = call.argument<String>("cardCVV").toString()
                val customerAddress: String = call.argument<String>("customerAddress").toString()
                val customerPostCode: String = call.argument<String>("customerPostCode").toString()
                makePayment(
                        amount,
                        cardNumber,
                        cardExpiryDate,
                        cardCVV,
                        customerAddress,
                        customerPostCode
                )
                result.success("Payment Done")
            }
        }

    }

    private fun makePayment(amount: String, cardNumber: String, cardExpiryDate: String, cardCVV: String, customerAddress: String, customerPostCode: String) {

        val request: HashMap<String, String> = HashMap()

        val amountDecimal = BigDecimal(amount)

        request["action"] = "SALE"
        request["amount"] = amountDecimal.multiply(BigDecimal.valueOf(100)).toBigInteger().toString()
        request["cardNumber"] = cardNumber
        request["cardExpiryDate"] = cardExpiryDate
        request["cardCVV"] = cardCVV

//        if (this.customerAddress.getText().length() > 0) {
        request["customerAddress"] = customerAddress
        //}

//        if (this.customerPostCode.getText().length() > 0) {
        request["customerPostCode"] = customerPostCode
        //}
//        val amount = BigDecimal("55555")
//
//        request["action"] = "SALE"
//        request["amount"] = amount.multiply(BigDecimal.valueOf(100)).toBigInteger().toString()
//        request["cardNumber"] = "555555555555554444"
//        request["cardExpiryDate"] = "3/25"
//        request["cardCVV"] = "393"
//
////        if (this.customerAddress.getText().length() > 0) {
//        request["customerAddress"] = "Address"
//        //}
//
////        if (this.customerPostCode.getText().length() > 0) {
//        request["customerPostCode"] = "5200"
//        //}


        request["countryCode"] = "826" // GB

        request["currencyCode"] = "826" // GBP

        request["type"] = "1" // E-commerce


        object : AsyncTask<Void?, Void?, Map<String, String?>>() {
            override fun onPreExecute() {
            }


            override fun doInBackground(vararg p0: Void?): Map<String, String?> {
                return try {
                    val response: Map<String, String?> = gateway.directRequest(request)
                    for (field in response.keys) {
                        Log.i(TAG, field + " = " + response[field])
                    }
                    response
                } catch (e: Exception) {
                    Log.e(TAG, "Gateway submit failed", e)
                    val error: MutableMap<String, String?> = HashMap()
                    error["responseMessage"] = e.message
                    error["state"] = e.javaClass.name
                    error
                }
            }

            override fun onPostExecute(response: Map<String, String?>) {
                Log.d(TAG, "RESPONSE$response")

                channel.invokeMethod("show", response)

                print("Method invoked!")

                Log.d(TAG, "CHANNEL $channel")


            }

        }.execute()

    }


}
