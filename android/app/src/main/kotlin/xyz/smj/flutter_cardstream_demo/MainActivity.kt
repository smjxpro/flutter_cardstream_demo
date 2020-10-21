package xyz.smj.flutter_cardstream_demo

import android.os.AsyncTask
import android.util.Log
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel
import xyz.smj.flutter_cardstream_demo.cardstream.Gateway


class MainActivity : FlutterActivity() {
    private val CHANNEL = "flutter_cardstream_demo.smj.xyz/payment"


    val TAG: String = MainActivity::class.java.name

    val DIRECT_URL: String = "https://gateway.cardstream.com/direct/"

    val MERCHANT_ID: String = "100001"

    val MERCHANT_SECRET: String = "Circle4Take40Idea"

    val gateway = Gateway(DIRECT_URL, MERCHANT_ID, MERCHANT_SECRET)


    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)

        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, CHANNEL).setMethodCallHandler { call, result ->
            if (call.method == "makePayment") {
                val res = makePayment()

                if (res != null) {
                    result.success(res)
                } else {
                    result.error("FAILED", "Payment failed!", null)
                }
            } else {
                result.notImplemented()
            }

        }
    }

    fun makePayment(): HashMap<String, String> {
        val request: HashMap<String, String> = HashMap<String, String>()

        request["action"] = "SALE"
        request["amount"] = "54"
        request["cardNumber"] = "5545454"
        request["cardExpiryDate"] = "05/25"
        request["cardCVV"] = "393"
        request["customerAddress"] = "Test"
        request["customerPostCode"] = "5869"
        request["countryCode"] = "826"
        request["currencyCode"] = "826"
        request["type"] = "1"

        var res = HashMap<String, String>()
        var err: Any

        class MyNetworkTask : AsyncTask<Void, Void, Map<String, String?>>() {

            override fun doInBackground(vararg params: Void?): Map<String, String?>? {
                try {
                    val response = gateway.directRequest(request)
                    for (field in response.keys) {
                        Log.i(TAG, field + " = " + response[field])
                    }
                    res = response as HashMap<String, String>
                    return response
                } catch (e: Exception) {
                    Log.e(TAG, "Gateway submit failed", e)
                    val error: MutableMap<String, String?> = HashMap()
                    error["responseMessage"] = e.message
                    error["state"] = e.javaClass.name
                    err = error
                    return error
                }
            }

            override fun onPostExecute(result: Map<String, String?>?) {
                if (result != null) {
                    res = result as HashMap<String, String>
                }
            }
        }
        MyNetworkTask().execute()

        print("rEs: ${res}")

        return res


    }
}
