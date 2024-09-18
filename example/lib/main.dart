import 'package:flutter/material.dart';
import 'package:alpha_vantage_api/services/complete_alpha_vantage_service.dart';
import 'package:flutter/services.dart';

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
  final _intervalController = TextEditingController(text: '5min');

  String _result = 'Enter your API key and press "Fetch Data"';

  // List of available functions
  final List<String> _functions = [
    'EARNINGS_CALENDAR',
    'TIME_SERIES_INTRADAY',
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
    final symbol = _symbolController.text.trim();

    // Collect additional parameters based on selected function
    Map<String, String> additionalParams = {'symbol': symbol};
    if (functionName == 'TIME_SERIES_INTRADAY') {
      additionalParams['interval'] = _intervalController.text.trim();
    }

    try {
      final content = await service.fetchContent(
        functionName,
        additionalParams: additionalParams,
      );
      setState(() {
        _result = content;
      });
    } catch (e) {
      setState(() {
        _result = 'Failed to fetch data: $e';
      });
    }
  }

  void _copyToClipboard() {
    Clipboard.setData(ClipboardData(text: _result));

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Copied to clipboard'),
      ),
    );
  }

  @override
  void dispose() {
    _apiKeyController.dispose();
    _symbolController.dispose();
    _intervalController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Alpha Vantage Example'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: SingleChildScrollView( // Prevent overflow when keyboard appears
          child: Column(
            children: [
              TextField(
                controller: _apiKeyController,
                decoration: InputDecoration(
                  labelText: 'Alpha Vantage API Key',
                  border: OutlineInputBorder(),
                ),
              ),
              SizedBox(height: 16),
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
                decoration: InputDecoration(
                  labelText: 'Select Function',
                  border: OutlineInputBorder(),
                ),
              ),
              SizedBox(height: 16),
              TextField(
                controller: _symbolController,
                decoration: InputDecoration(
                  labelText: 'Symbol (e.g., IBM)',
                  border: OutlineInputBorder(),
                ),
              ),
              SizedBox(height: 16),
              if (_selectedFunction == 'TIME_SERIES_INTRADAY') ...[
                TextField(
                  controller: _intervalController,
                  decoration: InputDecoration(
                    labelText: 'Interval (e.g., 1min, 5min)',
                    border: OutlineInputBorder(),
                  ),
                ),
                SizedBox(height: 16),
              ],
              ElevatedButton(
                onPressed: _fetchData,
                child: Text('Fetch Data'),
              ),
              ElevatedButton(onPressed: _copyToClipboard, child: Text('Copy to Clipboard'),),
              SizedBox(height: 16),
              Text(
                _result,
                style: TextStyle(fontFamily: 'Courier'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}