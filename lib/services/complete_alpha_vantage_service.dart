import 'package:alpha_vantage_api/services/mixins/alpha_vantage_service.dart';

class CompleteAlphaVantageService with AlphaVantageService {
  CompleteAlphaVantageService(String apiKey) {
    initializeService(apiKey);
  }
}
