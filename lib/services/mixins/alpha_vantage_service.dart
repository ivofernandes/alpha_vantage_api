import 'dart:convert';
import 'dart:io';

import 'package:flutter/foundation.dart';

mixin AlphaVantageService {
  late final String apiKey;

  void initializeService(String key) {
    apiKey = key;
  }

  /// Helper method to construct the URI
  Uri _constructUri(String functionName,
      {Map<String, String>? additionalParams}) {
    return Uri.https(
      'www.alphavantage.co',
      '/query',
      {
        'function': functionName,
        'apikey': apiKey,
        if (additionalParams != null) ...additionalParams,
      },
    );
  }

  /// Generates the URL based on function name and additional parameters
  String generateUrl(String functionName,
      {Map<String, String>? additionalParams}) {
    return _constructUri(functionName, additionalParams: additionalParams)
        .toString();
  }

  /// Fetches data from Alpha Vantage API
  Future<String> fetchContent(String functionName,
      {Map<String, String>? additionalParams}) async {
    final Uri uri =
        _constructUri(functionName, additionalParams: additionalParams);

    try {
      HttpClient httpClient = HttpClient();
      var request = await httpClient.getUrl(uri);
      var response = await request.close();

      if (response.statusCode == 200) {
        var bytes = await consolidateHttpClientResponseBytes(response);
        final content = utf8.decode(bytes);
        return content;
      } else {
        throw Exception('Failed to fetch data: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Failed to fetch data');
    }
  }
}
