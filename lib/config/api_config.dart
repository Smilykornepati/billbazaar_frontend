class ApiConfig {
  // Base URL - Update this to your server URL
  static const String baseUrl = 'http://localhost:5001/api';
  
  // Auth endpoints
  static const String signupUrl = '$baseUrl/auth/signup';
  static const String signinUrl = '$baseUrl/auth/signin';
  static const String verifyOtpUrl = '$baseUrl/auth/verify-otp';
  
  // Bill endpoints
  static const String billsUrl = '$baseUrl/bills';
  static String billByIdUrl(int id) => '$baseUrl/bills/$id';
  static String printBillUrl(int id) => '$baseUrl/bills/$id/print';
  
  // Printer endpoints
  static const String printersUrl = '$baseUrl/printers';
  static const String defaultPrinterUrl = '$baseUrl/printers/default';
  static String printerByIdUrl(int id) => '$baseUrl/printers/$id';
  static String testPrinterUrl(int id) => '$baseUrl/printers/$id/test';
  
  // Timeout duration
  static const Duration timeoutDuration = Duration(seconds: 30);

 

  static Map<String, String>? get headers => null;


}