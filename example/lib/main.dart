import 'package:flutter/material.dart';
import 'package:flutter/services.dart'; // For clipboard
import 'package:url_launcher/url_launcher.dart'; // For launching URLs
import 'package:alpha_vantage_api/services/complete_alpha_vantage_service.dart';

void main() => runApp(AlphaVantageExampleApp());

class AlphaVantageExampleApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Alpha Vantage Example',
      theme: ThemeData.dark(), // Enable dark mode
      home: AlphaVantageHomePage(),
    );
  }
}

class AlphaVantageHomePage extends StatefulWidget {
  @override
  _AlphaVantageHomePageState createState() => _AlphaVantageHomePageState();
}

class _AlphaVantageHomePageState extends State<AlphaVantageHomePage> {
  final _apiKeyController = TextEditingController();
  final _symbolController = TextEditingController(text: '');
  final _intervalController = TextEditingController(text: '');
  final _fromCurrencyController = TextEditingController();
  final _toCurrencyController = TextEditingController();
  final _outputSizeController = TextEditingController(text: '');

  String _result = 'Enter your API key and press "Fetch Data"';
  String _constructedUrl = '';

  final List<String> _functions = [
    'EARNINGS_CALENDAR',
    'TIME_SERIES_INTRADAY',
    'CURRENCY_EXCHANGE_RATE',
    'TIME_SERIES_DAILY',
    'DIGITAL_CURRENCY_DAILY',
  ];

  String _selectedFunction = 'EARNINGS_CALENDAR';

  void _fetchData() async {
    final apiKey = _apiKeyController.text.trim();
    if (apiKey.isEmpty) {
      setState(() {
        _result = 'Please enter a valid API key.';
      });
      return;
    }

    final service = CompleteAlphaVantageService(apiKey);
    final functionName = _selectedFunction;

    // Collect additional parameters dynamically
    Map<String, String> additionalParams = {};
    if (_symbolController.text.isNotEmpty) {
      additionalParams['symbol'] = _symbolController.text.trim();
    }
    if (_intervalController.text.isNotEmpty) {
      additionalParams['interval'] = _intervalController.text.trim();
    }
    if (_fromCurrencyController.text.isNotEmpty) {
      additionalParams['from_currency'] = _fromCurrencyController.text.trim();
    }
    if (_toCurrencyController.text.isNotEmpty) {
      additionalParams['to_currency'] = _toCurrencyController.text.trim();
    }
    if (_outputSizeController.text.isNotEmpty) {
      additionalParams['outputsize'] = _outputSizeController.text.trim();
    }

    // Generate the resulting URL for the user's input
    final constructedUrl = service.generateUrl(functionName, additionalParams: additionalParams);
    setState(() {
      _constructedUrl = constructedUrl;
    });

    try {
      final content = await service.fetchContent(functionName, additionalParams: additionalParams);
      setState(() {
        _result = content;
      });
    } catch (e) {
      setState(() {
        _result = 'Failed to fetch data: $e';
      });
    }
  }

  // Function to copy the result to clipboard
  void _copyToClipboard() {
    Clipboard.setData(ClipboardData(text: _result));
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Copied to clipboard'),
      ),
    );
  }

  // Function to clear all input fields
  void _clearParams() {
    setState(() {
      _symbolController.clear();
      _intervalController.clear();
      _fromCurrencyController.clear();
      _toCurrencyController.clear();
      _outputSizeController.clear();
      _constructedUrl = '';
      _result = 'Enter your API key and press "Fetch Data"';
    });
  }

  // Function to launch Alpha Vantage documentation
  Future<void> _launchDocsUrl() async {
    const url = 'https://www.alphavantage.co/documentation/';
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Alpha Vantage Example'),
        actions: [
          IconButton(
            icon: const Icon(Icons.help_outline),
            onPressed: _launchDocsUrl, // Open documentation when pressed
            tooltip: 'Open Alpha Vantage Docs',
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: SingleChildScrollView(
          child: Column(
            children: [
              TextField(
                controller: _apiKeyController,
                decoration: const InputDecoration(
                  labelText: 'Alpha Vantage API Key',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 16),
              DropdownButtonFormField<String>(
                value: _selectedFunction,
                items: _functions.map((String function) {
                  return DropdownMenuItem<String>(
                    value: function,
                    child: Text(function),
                  );
                }).toList(),
                onChanged: (String? newValue) {
                  setState(() {
                    _selectedFunction = newValue!;
                  });
                },
                decoration: const InputDecoration(
                  labelText: 'Select Function',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 16),

              if (_selectedFunction == 'TIME_SERIES_INTRADAY' || _selectedFunction == 'TIME_SERIES_DAILY') ...[
                TextField(
                  controller: _symbolController,
                  decoration: const InputDecoration(
                    labelText: 'Symbol (e.g., IBM)',
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 16),
                TextField(
                  controller: _intervalController,
                  decoration: const InputDecoration(
                    labelText: 'Interval (e.g., 1min, 5min)',
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 16),
                TextField(
                  controller: _outputSizeController,
                  decoration: const InputDecoration(
                    labelText: 'Output Size (compact/full)',
                    border: OutlineInputBorder(),
                  ),
                ),
              ],

              if (_selectedFunction == 'FX_INTRADAY') ...[
                TextField(
                  controller: _fromCurrencyController,
                  decoration: const InputDecoration(
                    labelText: 'From Currency (e.g., USD)',
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 16),
                TextField(
                  controller: _toCurrencyController,
                  decoration: const InputDecoration(
                    labelText: 'To Currency (e.g., EUR)',
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 16),
                TextField(
                  controller: _intervalController,
                  decoration: const InputDecoration(
                    labelText: 'Interval (e.g., 1min, 5min)',
                    border: OutlineInputBorder(),
                  ),
                ),
              ],

              if (_selectedFunction == 'DIGITAL_CURRENCY_DAILY') ...[
                TextField(
                  controller: _symbolController,
                  decoration: const InputDecoration(
                    labelText: 'Digital Currency Symbol (e.g., BTC)',
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 16),
              ],

              // Button to fetch data
              ElevatedButton(
                onPressed: _fetchData,
                child: const Text('Fetch Data'),
              ),

              // Button to clear parameters
              ElevatedButton(
                onPressed: _clearParams,
                child: const Text('Clear Parameters'),
              ),

              const SizedBox(height: 16),

              // Display constructed URL dynamically
              SelectableText(
                'Constructed URL: $_constructedUrl',
                style: const TextStyle(fontFamily: 'Courier'),
              ),

              const SizedBox(height: 16),

              // Display fetched result
              SelectableText(
                _result,
                style: const TextStyle(fontFamily: 'Courier'),
              ),

              const SizedBox(height: 16),

              // Button to copy result to clipboard
              ElevatedButton(
                onPressed: _copyToClipboard,
                child: const Text('Copy to Clipboard'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
