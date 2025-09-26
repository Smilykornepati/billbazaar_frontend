import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class AuthService {
  // Base URL for your API - replace with your actual API endpoint
  static const String baseUrl = 'https://your-api-endpoint.com/api';
  
  // Sign in method
  Future<bool> signIn(String email, String password) async {
    try {
      /* TODO: Uncomment when backend is ready
      final url = Uri.parse('$baseUrl/auth/signin');
      
      final response = await http.post(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
        body: jsonEncode({
          'email': email,
          'password': password,
        }),
      );

      if (response.statusCode == 200) {
        final responseData = jsonDecode(response.body);
        
        // Assuming the API returns a token and user data
        if (responseData['success'] == true) {
          final token = responseData['data']['token'];
          final userData = responseData['data']['user'];
          
          // Save token and user data to local storage
          await _saveUserData(token, userData);
          
          return true;
        } else {
          throw Exception(responseData['message'] ?? 'Login failed');
        }
      } else if (response.statusCode == 401) {
        throw Exception('Invalid email or password');
      } else if (response.statusCode == 422) {
        final responseData = jsonDecode(response.body);
        throw Exception(responseData['message'] ?? 'Validation error');
      } else {
        throw Exception('Server error. Please try again later.');
      }
      */

      // For testing purposes - simulate successful login
      await Future.delayed(const Duration(seconds: 1));
      
      // Simulate user data
      final userData = {
        'id': '1',
        'name': 'Test User',
        'email': email,
      };
      
      // Save mock data
      await _saveUserData('mock_token_123', userData);
      
      return true;
    } catch (e) {
      if (e is Exception) {
        rethrow;
      } else {
        throw Exception('Network error. Please check your connection.');
      }
    }
  }

  // Save user data to local storage
  Future<void> _saveUserData(String token, Map<String, dynamic> userData) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('auth_token', token);
    await prefs.setString('user_data', jsonEncode(userData));
    await prefs.setBool('is_logged_in', true);
  }

  // Get saved token
  Future<String?> getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('auth_token');
  }

  // Get saved user data
  Future<Map<String, dynamic>?> getUserData() async {
    final prefs = await SharedPreferences.getInstance();
    final userDataString = prefs.getString('user_data');
    if (userDataString != null) {
      return jsonDecode(userDataString);
    }
    return null;
  }

  // Check if user is logged in
  Future<bool> isLoggedIn() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool('is_logged_in') ?? false;
  }

  // Sign out
  Future<void> signOut() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('auth_token');
    await prefs.remove('user_data');
    await prefs.setBool('is_logged_in', false);
  }

  // Validate token with server (optional)
  Future<bool> validateToken() async {
    try {
      /* TODO: Uncomment when backend is ready
      final token = await getToken();
      if (token == null) return false;

      final url = Uri.parse('$baseUrl/auth/validate');
      
      final response = await http.get(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );

      return response.statusCode == 200;
      */

      // For testing - simulate token validation
      final token = await getToken();
      return token != null;
    } catch (e) {
      return false;
    }
  }

  // Refresh token (if your API supports it)
  Future<bool> refreshToken() async {
    try {
      final token = await getToken();
      if (token == null) return false;

      final url = Uri.parse('$baseUrl/auth/refresh');
      
      final response = await http.post(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );

      if (response.statusCode == 200) {
        final responseData = jsonDecode(response.body);
        final newToken = responseData['data']['token'];
        
        final prefs = await SharedPreferences.getInstance();
        await prefs.setString('auth_token', newToken);
        
        return true;
      }
      
      return false;
    } catch (e) {
      return false;
    }
  }

  // Register new user (bonus method)
  Future<bool> signUp({
    required String name,
    required String email,
    required String password,
    String? phone,
  }) async {
    try {
      /* TODO: Uncomment when backend is ready
      final url = Uri.parse('$baseUrl/auth/signup');
      
      final response = await http.post(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
        body: jsonEncode({
          'name': name,
          'email': email,
          'password': password,
          if (phone != null) 'phone': phone,
        }),
      );

      if (response.statusCode == 201) {
        final responseData = jsonDecode(response.body);
        
        if (responseData['success'] == true) {
          // Optionally auto-login after signup
          return await signIn(email, password);
        }
      }
      
      return false;
      */

      // For testing purposes - simulate successful signup
      await Future.delayed(const Duration(seconds: 1));
      
      // Simulate user data
      final userData = {
        'id': '1',
        'name': name,
        'email': email,
      };
      
      // Save mock data (auto-login after signup)
      await _saveUserData('mock_token_123', userData);
      
      return true;
    } catch (e) {
      throw Exception('Registration failed. Please try again.');
    }
  }

  // Reset password
  Future<bool> resetPassword(String email) async {
    try {
      final url = Uri.parse('$baseUrl/auth/reset-password');
      
      final response = await http.post(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
        body: jsonEncode({
          'email': email,
        }),
      );

      return response.statusCode == 200;
    } catch (e) {
      return false;
    }
  }
}