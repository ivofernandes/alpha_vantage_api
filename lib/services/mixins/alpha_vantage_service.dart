import 'dart:convert';
import 'dart:io';

import 'package:flutter/foundation.dart';

mixin AlphaVantageService {
  late final String apiKey;

  void initializeService(String key) {
    apiKey = key;
  }

  Future<String> fetchContent(String functionName, {Map<String, String>? additionalParams}) async {
    final Uri uri = Uri.https(
      'www.alphavantage.co',
      '/query',
      {
        'function': functionName,
        'apikey': apiKey,
        if (additionalParams != null) ...additionalParams,
      },
    );

    print('Fetching URL: $uri'); // Debugging line to log the URL

    try {
      HttpClient httpClient = HttpClient();
      var request = await httpClient.getUrl(uri);
      var response = await request.close();

      print('Response status: ${response.statusCode}');
      print('Response headers: ${response.headers}');

      if (response.statusCode == 200) {
        var bytes = await consolidateHttpClientResponseBytes(response);
        final content = utf8.decode(bytes);
        print('Response body as bytes: $content');
        return content;
      } else {
        print('Failed to fetch data: ${response.statusCode}, ${response.reasonPhrase}');
        throw Exception('Failed to fetch data: ${response.statusCode}');
      }
    } catch (e) {
      print('HTTP error: $e');
      throw Exception('Failed to fetch data');
    }
  }
}
