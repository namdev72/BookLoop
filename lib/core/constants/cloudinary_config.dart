/// Cloudinary Configuration
/// Replace these values with your actual Cloudinary credentials
class CloudinaryConfig {
  static const String cloudName = 'diuphk0xx'; 
  static const String uploadPreset = 'book_images'; 
  static const String apiKey = ''; // Unsigned upload doesn't require API key

  static String get uploadUrl =>
      'https://api.cloudinary.com/v1_1/$cloudName/image/upload';

  static String optimizedUrl(String publicId, {int width = 400}) =>
      'https://res.cloudinary.com/$cloudName/image/upload/w_$width,c_fill,q_auto,f_auto/$publicId';
}
