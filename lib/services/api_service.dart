import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../config/api_config.dart';

class ApiService {
  static final ApiService _instance = ApiService._internal();
  factory ApiService() => _instance;
  ApiService._internal();

  String? _token;

  // Initialize token from storage
  Future<void> initialize() async {
    final prefs = await SharedPreferences.getInstance();
    _token = prefs.getString('auth_token');
  }

  // Save token
  Future<void> saveToken(String token) async {
    _token = token;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('auth_token', token);
  }

  // Clear token
  Future<void> clearToken() async {
    _token = null;
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('auth_token');
  }

  // Get token
  String? get token => _token;

  // Check if authenticated
  bool get isAuthenticated => _token != null && _token!.isNotEmpty;

  // Get headers with auth
  Map<String, String> _getHeaders({bool includeAuth = true}) {
    final headers = {
      'Content-Type': 'application/json',
    };
    
    if (includeAuth && _token != null) {
      headers['Authorization'] = 'Bearer $_token';
    }
    
    return headers;
  }

  // Handle response
  Map<String, dynamic> _handleResponse(http.Response response) {
    final data = jsonDecode(response.body);
    
    if (response.statusCode >= 200 && response.statusCode < 300) {
      return data;
    } else {
      throw ApiException(
        message: data['message'] ?? 'An error occurred',
        statusCode: response.statusCode,
        data: data,
      );
    }
  }

  // POST request
  Future<Map<String, dynamic>> post(
    String url,
    Map<String, dynamic> body, {
    bool includeAuth = true,
  }) async {
    try {
      final response = await http
          .post(
            Uri.parse(url),
            headers: _getHeaders(includeAuth: includeAuth),
            body: jsonEncode(body),
          )
          .timeout(ApiConfig.timeoutDuration);
      
      return _handleResponse(response);
    } catch (e) {
      rethrow;
    }
  }

  // GET request
  Future<Map<String, dynamic>> get(
    String url, {
    bool includeAuth = true,
  }) async {
    try {
      final response = await http
          .get(
            Uri.parse(url),
            headers: _getHeaders(includeAuth: includeAuth),
          )
          .timeout(ApiConfig.timeoutDuration);
      
      return _handleResponse(response);
    } catch (e) {
      rethrow;
    }
  }

  // PUT request
  Future<Map<String, dynamic>> put(
    String url,
    Map<String, dynamic> body, {
    bool includeAuth = true,
  }) async {
    try {
      final response = await http
          .put(
            Uri.parse(url),
            headers: _getHeaders(includeAuth: includeAuth),
            body: jsonEncode(body),
          )
          .timeout(ApiConfig.timeoutDuration);
      
      return _handleResponse(response);
    } catch (e) {
      rethrow;
    }
  }

  // DELETE request
  Future<Map<String, dynamic>> delete(
    String url, {
    bool includeAuth = true,
  }) async {
    try {
      final response = await http
          .delete(
            Uri.parse(url),
            headers: _getHeaders(includeAuth: includeAuth),
          )
          .timeout(ApiConfig.timeoutDuration);
      
      return _handleResponse(response);
    } catch (e) {
      rethrow;
    }
  }
}

// API Exception class
class ApiException implements Exception {
  final String message;
  final int statusCode;
  final Map<String, dynamic>? data;

  ApiException({
    required this.message,
    required this.statusCode,
    this.data,
  });

  @override
  String toString() => message;
}
