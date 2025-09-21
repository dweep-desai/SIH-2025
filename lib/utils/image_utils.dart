import 'dart:io';
import 'dart:convert';
import 'package:flutter/material.dart';
import '../services/base64_storage_service.dart';

class ImageUtils {
  /// Get the appropriate ImageProvider based on the image path or URL
  /// This method handles local file paths, network URLs, and Base64 encoded images
  static ImageProvider? getImageProvider(String? imagePath) {
    if (imagePath == null || imagePath.isEmpty) {
      print('ImageUtils: No image path provided');
      return null;
    }
    
    print('ImageUtils: Processing image path - ${imagePath.substring(0, imagePath.length > 50 ? 50 : imagePath.length)}...');
    
    // Handle network URLs (including Firebase Storage URLs)
    if (imagePath.startsWith('http://') || imagePath.startsWith('https://')) {
      print('ImageUtils: Using NetworkImage for URL');
      return NetworkImage(imagePath);
    }
    
    // Handle Base64 encoded images
    if (_isBase64Image(imagePath)) {
      print('ImageUtils: Using Base64 image provider');
      final base64Service = Base64StorageService();
      return base64Service.getImageProviderFromBase64(imagePath);
    }
    
    // Handle local file paths
    if (imagePath.startsWith('/') || 
        imagePath.startsWith('C:') || 
        imagePath.startsWith('D:') ||
        imagePath.startsWith('E:') ||
        imagePath.startsWith('F:')) {
      print('ImageUtils: Using FileImage for local path');
      try {
        final file = File(imagePath);
        if (file.existsSync()) {
          return FileImage(file);
        }
      } catch (e) {
        print('ImageUtils: File not found or error accessing: $e');
        return null;
      }
    }
    
    // For any other format, try as network image
    print('ImageUtils: Falling back to NetworkImage');
    return NetworkImage(imagePath);
  }
  
  /// Check if an image path is a valid network URL
  static bool isNetworkUrl(String? imagePath) {
    if (imagePath == null || imagePath.isEmpty) return false;
    return imagePath.startsWith('http://') || imagePath.startsWith('https://');
  }
  
  /// Check if an image path is a local file path
  static bool isLocalFilePath(String? imagePath) {
    if (imagePath == null || imagePath.isEmpty) return false;
    return imagePath.startsWith('/') || 
           imagePath.startsWith('C:') || 
           imagePath.startsWith('D:') ||
           imagePath.startsWith('E:') ||
           imagePath.startsWith('F:');
  }
  
  /// Check if an image path is a Firebase Storage URL
  static bool isFirebaseStorageUrl(String? imagePath) {
    if (imagePath == null || imagePath.isEmpty) return false;
    return imagePath.contains('firebasestorage.googleapis.com') || 
           imagePath.contains('storage.googleapis.com');
  }
  
  /// Check if a string is a Base64 encoded image
  static bool _isBase64Image(String imagePath) {
    if (imagePath.isEmpty) return false;
    
    // Check if it's a data URL format
    if (imagePath.startsWith('data:image/')) {
      return true;
    }
    
    // Check if it's a valid Base64 string (long enough to be an image)
    if (imagePath.length > 100) { // Base64 images are typically much longer
      try {
        base64Decode(imagePath);
        return true;
      } catch (e) {
        return false;
      }
    }
    
    return false;
  }
}

