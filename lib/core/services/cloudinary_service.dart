import 'dart:io';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../constants/cloudinary_config.dart';

class CloudinaryService {
  Future<String?> uploadImage(File imageFile) async {
    try {
      final uri = Uri.parse(CloudinaryConfig.uploadUrl);
      final request = http.MultipartRequest('POST', uri);

      request.fields['upload_preset'] = CloudinaryConfig.uploadPreset;
      request.files.add(
        await http.MultipartFile.fromPath('file', imageFile.path),
      );

      final response = await request.send();
      final body = await response.stream.bytesToString();

      if (response.statusCode == 200) {
        final json = jsonDecode(body);
        return json['secure_url'] as String?;
      } else {
        print('Cloudinary upload failed: $body');
        return null;
      }
    } catch (e) {
      print('Cloudinary error: $e');
      return null;
    }
  }
}
