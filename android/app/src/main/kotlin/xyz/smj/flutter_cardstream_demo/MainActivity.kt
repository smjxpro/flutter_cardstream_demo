package xyz.smj.flutter_cardstream_demo

import android.os.AsyncTask
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel

class MainActivity : FlutterActivity() {
    private val CHANNEL = "flutter_cardstream_demo.smj.xyz/payment"

    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)

        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, CHANNEL).setMethodCallHandler { call, result ->
            if (call.method == "makePayment") {
                val res = makePayment()

                if (res != "") {
                    result.success(res)
                } else {
                    result.error("FAILED", "Payment failed!", null)
                }
            } else {
                result.notImplemented()
            }

        }
    }

    private fun makePayment(): String {
        val request: HashMap<String, String> = HashMap<String, String>()

        request["action"] = "SALE"
        request["amount"] = ""
        request["cardNumber"] = ""
        request["cardExpiryDate"] = ""
        request["cardCVV"] = ""
        request["customerAddress"] = ""
        request["customerPostCode"] = ""
        request["countryCode"] = "826"
        request["currencyCode"] = "826"
        request["type"] = "1"

        return "Payment Success"

    }
}
