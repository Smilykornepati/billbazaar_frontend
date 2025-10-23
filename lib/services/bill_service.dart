import '../config/api_config.dart';
import 'api_service.dart';

class BillService {
  final ApiService _apiService = ApiService();

  // Create bill
  Future<Map<String, dynamic>> createBill({
    required String clientName,
    String? clientContact,
    required DateTime issueDate,
    required DateTime dueDate,
    required List<Map<String, dynamic>> items,
    required double subtotal,
    required double discount,
    required double gstAmount,
    required double grandTotal,
    required String paymentMethod,
    required String paymentType,
    String? notes,
  }) async {
    final body = {
      'clientName': clientName,
      'clientContact': clientContact,
      'issueDate': issueDate.toIso8601String(),
      'dueDate': dueDate.toIso8601String(),
      'items': items,
      'subtotal': subtotal,
      'discount': discount,
      'gstAmount': gstAmount,
      'grandTotal': grandTotal,
      'paymentMethod': paymentMethod,
      'paymentType': paymentType,
      'notes': notes,
    };

    return await _apiService.post(ApiConfig.billsUrl, body);
  }

  // Print bill
  Future<Map<String, dynamic>> printBill(int billId, {int? printerId}) async {
    final body = printerId != null ? {'printerId': printerId} : {};
    return await _apiService.post(ApiConfig.printBillUrl(billId), body);
  }

  // Get all bills
  Future<List<Map<String, dynamic>>> getBills({
    int limit = 50,
    int offset = 0,
  }) async {
    final url = '${ApiConfig.billsUrl}?limit=$limit&offset=$offset';
    final response = await _apiService.get(url);
    return List<Map<String, dynamic>>.from(response['data']);
  }

  // Get bill by ID
  Future<Map<String, dynamic>> getBillById(int billId) async {
    return await _apiService.get(ApiConfig.billByIdUrl(billId));
  }
}