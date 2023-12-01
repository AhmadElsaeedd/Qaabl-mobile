import 'package:flutter/services.dart';

class PhotoRoomService {
  static const platform = MethodChannel('com.qaabl/native_image_processor');

  static Future<String> processImage(String imagePath) async {
    final String result =
        await platform.invokeMethod('processImage', {'imagePath': imagePath});
    return result;
  }
}
