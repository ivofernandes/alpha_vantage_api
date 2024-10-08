# AlphaVantage API Package

This package provides services to interact with the Alpha Vantage API, allowing users to fetch stock market data, time series, and earnings calendar information directly from the API. The package is structured around service classes and mixins to make API requests, handle data, and perform tests.

![AlphaVantage API](https://github.com/ivofernandes/alpha_vantage_api/blob/main/doc/screenshot.png?raw=true)

## Features

- **Alpha Vantage API Integration**: Fetch stock market data including intraday time series and earnings calendar data.
- **Modular Service**: `CompleteAlphaVantageService` allows you to extend and customize API interaction.
- **Real-Time Data Fetching**: The package is designed to fetch live data from the Alpha Vantage API.
- **Test-Driven**: Includes test cases to validate API calls.

## Installation

To use this package in your Flutter project, add it as a dependency in your `pubspec.yaml` file:

```yaml
dependencies:
  alpha_vantage_api: ^0.0.1
```

Run `flutter pub get` to install the dependencies.

## Usage

### 1. Setup API Key

Ensure you have your Alpha Vantage API key ready. You will need this to authenticate your API requests.
You can get it here: https://www.alphavantage.co/support/#api-key

### 2. Create an instance of `CompleteAlphaVantageService`

The service class `CompleteAlphaVantageService` handles the interaction with Alpha Vantage API. Initialize it with your API key.

```dart
import 'package:alpha_vantage_api/services/complete_alpha_vantage_service.dart';

void main() {
  final String apiKey = 'YOUR_ALPHA_VANTAGE_API_KEY';
  final CompleteAlphaVantageService service = CompleteAlphaVantageService(apiKey);
  
  // Example: Fetching intraday time series data for IBM
  final content = await service.fetchContent('TIME_SERIES_INTRADAY', additionalParams: {
    'symbol': 'IBM',
    'interval': '5min',
  });

  print(content);
}
```

### 3. Available Functions

You can use different functions provided by the Alpha Vantage API. Some common functions are:

- `TIME_SERIES_INTRADAY`: Fetches intraday time series data for a specific stock symbol.
- `EARNINGS_CALENDAR`: Retrieves earnings calendar data.

```dart
// Fetch intraday time series data
final content = await service.fetchContent('TIME_SERIES_INTRADAY', additionalParams: {
  'symbol': 'IBM',
  'interval': '5min',
});

// Fetch earnings calendar
final earnings = await service.fetchContent('EARNINGS_CALENDAR');
```

### 4. Testing

This package comes with test cases to ensure the functionality works with the real API.

To run the tests, use:

```bash
flutter test
```

Example test case for fetching real-time content:

```dart
import 'package:flutter_test/flutter_test.dart';
import 'package:alpha_vantage_api/services/complete_alpha_vantage_service.dart';
import 'configuration_environment.dart';

void main() {
  group('AlphaVantageService Real API Tests', () {
    late CompleteAlphaVantageService service;

    setUp(() {
      service = CompleteAlphaVantageService(ConfigurationEnvironment.API_KEY);
    });

    test('fetchContent fetches real data', () async {
      const functionName = 'TIME_SERIES_INTRADAY';
      final additionalParams = {'symbol': 'IBM', 'interval': '5min'};
      final content = await service.fetchContent(functionName, additionalParams: additionalParams);
      
      expect(content.isNotEmpty, isTrue);
    });
  });
}
```

### 5. Configuration

To run the tests or use the service in production, you will need to set up your API key in the environment. In the example tests, the API key is fetched from `ConfigurationEnvironment.API_KEY`.

Ensure that your environment configuration contains the API key for your Alpha Vantage API account.

## Dependencies

- [flutter](https://flutter.dev/)
- [http](https://pub.dev/packages/http)

## Contribution

Feel free to fork and contribute to the repository by opening issues or submitting pull requests.

## License

This project is licensed under the MIT License.

---

This package simplifies interactions with the Alpha Vantage API, enabling easy access to financial data and the ability to test against real API responses.