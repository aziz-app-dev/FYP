class AppUrl {
  // Base URLs (legacy - can be removed if not used)
  static const String baseUrl = 'https://reqres.in';
  static const String loginApi = '$baseUrl/api/login';
  static const String userListApi =
      'https://jsonplaceholder.typicode.com/users';
  static const String postListApi =
      'https://jsonplaceholder.typicode.com/posts';

  // ============ SUPABASE CONFIGURATION ============
  // Get these from: Supabase Dashboard > Settings > API
  static const String supabaseUrl = 'https://rulteobkqdbcnytpojso.supabase.co';
  static const String supabaseAnonKey =
      'sb_secret_fmc4ivDbe9fJ6eRjMqF92A_Ax-7T87Y';

  // ============ CLOUDINARY CONFIGURATION ============
  // Get these from: Cloudinary Dashboard > Settings > Access Keys
  // Create an unsigned upload preset in: Settings > Upload > Upload presets
  static const String cloudinaryCloudName =
      'YOUR_CLOUD_NAME'; // Replace with your cloud name
  static const String cloudinaryApiKey =
      'YOUR_API_KEY'; // Replace with your API key
  static const String cloudinaryApiSecret =
      'YOUR_API_SECRET'; // Replace with your API secret
  static const String cloudinaryUploadPreset =
      'YOUR_UPLOAD_PRESET'; // Create unsigned preset in Cloudinary

  // Cloudinary upload URL
  static String get cloudinaryUploadUrl =>
      'https://api.cloudinary.com/v1_1/$cloudinaryCloudName/image/upload';

  // ============ IMAGE SETTINGS ============
  // Maximum image size in bytes (800KB)
  static const int maxImageSizeBytes = 800 * 1024; // 800KB
  static const int maxImageSizeKB = 800;
}
