import 'dart:io';
import 'dart:convert';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class Base64StorageService {
  static final Base64StorageService _instance = Base64StorageService._internal();
  factory Base64StorageService() => _instance;
  Base64StorageService._internal();

  /// Convert image file to Base64 string
  Future<String?> imageToBase64(File imageFile) async {
    try {
      final bytes = await imageFile.readAsBytes();
      final base64String = base64Encode(bytes);
      return base64String;
    } catch (e) {
      print('Error converting image to Base64: $e');
      return null;
    }
  }

  /// Convert XFile to Base64 string
  Future<String?> xFileToBase64(XFile xFile) async {
    try {
      final bytes = await xFile.readAsBytes();
      final base64String = base64Encode(bytes);
      return base64String;
    } catch (e) {
      print('Error converting XFile to Base64: $e');
      return null;
    }
  }

  /// Convert Base64 string back to bytes
  Uint8List? base64ToBytes(String base64String) {
    try {
      return base64Decode(base64String);
    } catch (e) {
      print('Error converting Base64 to bytes: $e');
      return null;
    }
  }

  /// Get image provider from Base64 string
  ImageProvider? getImageProviderFromBase64(String? base64String) {
    if (base64String == null || base64String.isEmpty) {
      return null;
    }
    
    try {
      final bytes = base64Decode(base64String);
      return MemoryImage(bytes);
    } catch (e) {
      print('Error creating image provider from Base64: $e');
      return null;
    }
  }

  /// Check if a string is a valid Base64 image
  bool isBase64Image(String? data) {
    if (data == null || data.isEmpty) return false;
    
    try {
      // Check if it starts with data URL format
      if (data.startsWith('data:image/')) {
        return true;
      }
      
      // Check if it's a valid Base64 string
      base64Decode(data);
      return true;
    } catch (e) {
      return false;
    }
  }

  /// Compress image before converting to Base64 to reduce size
  Future<String?> compressAndConvertToBase64(File imageFile, {int quality = 85}) async {
    try {
      // For now, we'll use the original file
      // In a production app, you might want to add image compression here
      return await imageToBase64(imageFile);
    } catch (e) {
      print('Error compressing and converting image: $e');
      return null;
    }
  }

  /// Get Base64 data URL format (for web compatibility)
  String getBase64DataUrl(String base64String, {String mimeType = 'image/jpeg'}) {
    return 'data:$mimeType;base64,$base64String';
  }

  /// Extract Base64 string from data URL
  String? extractBase64FromDataUrl(String dataUrl) {
    if (dataUrl.startsWith('data:image/')) {
      final commaIndex = dataUrl.indexOf(',');
      if (commaIndex != -1) {
        return dataUrl.substring(commaIndex + 1);
      }
    }
    return dataUrl; // Return as-is if not a data URL
  }
}
