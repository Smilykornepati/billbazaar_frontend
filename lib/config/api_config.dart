class ApiConfig {
  // Base URL for the API - Update this with your actual server URL
  static const String baseUrl = 'YOUR_BASE_URL';
  
  // Authentication endpoints
  static const String signupEndpoint = '$baseUrl/api/auth/signup';
  static const String signinEndpoint = '$baseUrl/api/auth/signin';
  static const String verifyOtpEndpoint = '$baseUrl/api/auth/verify-otp';
  
  // Common headers
  static const Map<String, String> headers = {
    'Content-Type': 'application/json',
    'Accept': 'application/json',
  };
}