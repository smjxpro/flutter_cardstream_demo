package xyz.smj.flutter_cardstream_demo;

import android.os.AsyncTask;
import android.util.Log;

import androidx.annotation.NonNull;

import java.math.BigDecimal;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import io.flutter.embedding.android.FlutterActivity;
import io.flutter.embedding.engine.FlutterEngine;
import io.flutter.plugin.common.MethodChannel;

public class MainActivity extends FlutterActivity {
    static final String TAG = MainActivity.class.getName();
    static final String DIRECT_URL = "https://gateway.cardstream.com/direct/";
    static final String MERCHANT_ID = "100001";
    static final String MERCHANT_SECRET = "Circle4Take40Idea";
    static final Gateway gateway = new Gateway(DIRECT_URL, MERCHANT_ID, MERCHANT_SECRET);
    private static final String CHANNEL = "flutter_cardstream_demo.smj.xyz/payment";

    @Override
    public void configureFlutterEngine(@NonNull FlutterEngine flutterEngine) {
        super.configureFlutterEngine(flutterEngine);

        new MethodChannel(flutterEngine.getDartExecutor().getBinaryMessenger(), CHANNEL)
                .setMethodCallHandler(
                        (call, result) -> {
                            if (call.method.equals("makePayment")) {
                                Map<String, String> resp = sendPayment(
                                        call.argument("amount").toString(),
                                        call.argument("cardNumber").toString(),
                                        call.argument("cardExpiryDate").toString(),
                                        call.argument("cardCVV").toString(),
                                        call.argument("customerAddress").toString(),
                                        call.argument("customerPostCode").toString()
                                );

                                Log.d(TAG, "RESPONSE: " + resp);
                                result.success(resp);

                            }
                        }
                );
    }

    public Map<String, String> sendPayment(String amount, String cardNumber, String cardExpiryDate, String cardCVV, String customerAddress, String customerPostCode) {

        final HashMap<String, String> request = new HashMap<>();
        final List<Map<String, String>> res = new ArrayList<>();
        final BigDecimal _amount = new BigDecimal(amount);

        request.put("action", "SALE");
        request.put("amount", _amount.multiply(BigDecimal.valueOf(100)).toBigInteger().toString());
        request.put("cardNumber", cardNumber);
        request.put("cardExpiryDate", cardExpiryDate);
        request.put("cardCVV", cardCVV);

        if (customerAddress.length() > 0) {
            request.put("customerAddress", customerAddress);
        }

        if (customerPostCode.length() > 0) {
            request.put("customerPostCode", customerPostCode);
        }

        request.put("countryCode", "826"); // GB
        request.put("currencyCode", "826"); // GBP
        request.put("type", "1"); // E-commerce


        new AsyncTask<Void, Void, Map<String, String>>() {

            @Override
            protected void onPreExecute() {

            }

            @Override
            protected Map<String, String> doInBackground(final Void... b) {
                try {

                    final Map<String, String> response = gateway.directRequest(request);

                    for (final String field : response.keySet()) {
                        Log.i(TAG, field + " = " + response.get(field));
                    }

                    res.add(response);

                    return response;

                } catch (final Exception e) {

                    Log.e(TAG, "Gateway submit failed", e);

                    final Map<String, String> error = new HashMap<String, String>();

                    error.put("responseMessage", e.getMessage());
                    error.put("state", e.getClass().getName());

                    res.add(error);

                    return error;

                }
            }

            @Override
            protected void onPostExecute(final Map<String, String> response) {

            }

        }.execute();

        Log.d(TAG, "SENDPAM " + res.get(0));
        return res.get(0);


    }
}
