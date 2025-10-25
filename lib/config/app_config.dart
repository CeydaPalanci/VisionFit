class AppConfig {
  static const String apiBaseUrl = 'https://your-api-server.com:7146';
  static const String comfyUIBaseUrl = 'http://your-comfyui-server.com:5000';
  
  // API Endpoints
  static String get loginEndpoint => '$apiBaseUrl/api/auth/login';
  static String get registerEndpoint => '$apiBaseUrl/api/auth/register';
  static String get glassesEndpoint => '$apiBaseUrl/api/glasses';
  static String get analyzeEndpoint => '$apiBaseUrl/api/analyze';
  static String get uploadEndpoint => '$comfyUIBaseUrl/upload';
} 