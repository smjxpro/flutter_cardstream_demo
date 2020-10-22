import 'dart:io';

class Gateway {
  Uri gatewayUrl;

  String merchantSecret;

  Map<String, String> directRequest(
      {final Map<String, String> request, final Map<String, String> options}) {
    Uri directUrl;

    if (request.containsKey('directUrl')) {
      directUrl = Uri.parse(request['directUrl']);
    } else {
      directUrl = this.gatewayUrl;
    }
    String secret;

    if (request.containsKey("merchantSecret")) {
      secret = request["merchantSecret"];
    } else {
      secret = this.merchantSecret;
    }

    Map<String, String> _request = this.prepareRequest(request, options);
  }

  Map<String, String> prepareRequest(
      Map<String, String> request, Map<String, String> options) {}
}
