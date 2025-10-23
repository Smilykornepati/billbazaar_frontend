import '../config/api_config.dart';
import 'api_service.dart';

class PrinterServiceApi {
  final ApiService _apiService = ApiService();

  // Get all printers
  Future<List<Map<String, dynamic>>> getPrinters() async {
    final response = await _apiService.get(ApiConfig.printersUrl);
    return List<Map<String, dynamic>>.from(response['data']);
  }

  // Get default printer
  Future<Map<String, dynamic>?> getDefaultPrinter() async {
    try {
      final response = await _apiService.get(ApiConfig.defaultPrinterUrl);
      return response['data'];
    } on ApiException catch (e) {
      if (e.statusCode == 404) {
        return null; // No default printer
      }
      rethrow;
    }
  }

  // Create printer
  Future<Map<String, dynamic>> createPrinter({
    required String name,
    required String model,
    required String connection,
    String paperWidth = '80mm',
    bool isDefault = false,
    bool isConnected = false,
    String? ipAddress,
    int? port,
    bool autoCut = true,
    bool soundEnabled = true,
    int copies = 1,
  }) async {
    final body = {
      'name': name,
      'model': model,
      'connection': connection,
      'paperWidth': paperWidth,
      'isDefault': isDefault,
      'isConnected': isConnected,
      'ipAddress': ipAddress,
      'port': port,
      'autoCut': autoCut,
      'soundEnabled': soundEnabled,
      'copies': copies,
    };

    return await _apiService.post(ApiConfig.printersUrl, body);
  }

  // Update printer
  Future<Map<String, dynamic>> updatePrinter(
    int printerId,
    Map<String, dynamic> updates,
  ) async {
    return await _apiService.put(
      ApiConfig.printerByIdUrl(printerId),
      updates,
    );
  }

  // Delete printer
  Future<void> deletePrinter(int printerId) async {
    await _apiService.delete(ApiConfig.printerByIdUrl(printerId));
  }

  // Test printer
  Future<Map<String, dynamic>> testPrinter(int printerId) async {
    return await _apiService.post(
      ApiConfig.testPrinterUrl(printerId),
      {},
    );
  }
}