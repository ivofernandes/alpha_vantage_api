import 'package:alpha_vantage_api/services/complete_alpha_vantage_service.dart';
import 'package:alpha_vantage_api/services/mixins/alpha_vantage_service.dart';
import 'package:flutter_test/flutter_test.dart';

import 'configuration_environment.dart';

class RealAlphaVantageService with AlphaVantageService {}

void main() {
  group('AlphaVantageService Real API Tests', () {
    late CompleteAlphaVantageService service;
    late String apiKey;

    setUp(() {
      service = CompleteAlphaVantageService(ConfigurationEnvironment.API_KEY);
    });

    test('fetchContent fetches real data', () async {
      const functionName = 'TIME_SERIES_INTRADAY';
      final additionalParams = {'symbol': 'IBM', 'interval': '5min'};

      try {
        final content = await service.fetchContent(functionName, additionalParams: additionalParams);
        print('Received content: $content');

        expect(content.isNotEmpty, isTrue);
      } catch (e) {
        fail('Failed to fetch data: $e');
      }
    });

    test('EARNINGS_CALENDAR request', () async {
      const functionName = 'EARNINGS_CALENDAR';

      try {
        // The additional parameters for the EARNINGS_CALENDAR request can vary
        final content = await service.fetchContent(functionName);

        expect(content.isNotEmpty, isTrue);
      } catch (e) {
        print('Caught expected exception: $e');
      }
    });
  });
}
