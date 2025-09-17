import 'dart:io';
import 'package:flutter/material.dart';

class ProfileData {
  static String? _profileImagePath;
  static String? _domain1;
  static String? _domain2;

  // Getters
  static String? get profileImagePath => _profileImagePath;
  static String? get domain1 => _domain1;
  static String? get domain2 => _domain2;

  // Setters
  static void setProfileImagePath(String? path) {
    _profileImagePath = path;
  }

  static void setDomain1(String? domain) {
    _domain1 = domain;
  }

  static void setDomain2(String? domain) {
    _domain2 = domain;
  }

  // Get profile image provider
  static ImageProvider? getProfileImageProvider() {
    try {
      if (_profileImagePath != null && _profileImagePath!.isNotEmpty) {
        final file = File(_profileImagePath!);
        if (file.existsSync()) {
          return FileImage(file);
        }
      }
    } catch (e) {
      // Error loading profile image, return null
    }
    return null;
  }

  // Get domains as a list (excluding null values)
  static List<String> getDomains() {
    List<String> domains = [];
    if (_domain1 != null && _domain1!.isNotEmpty) {
      domains.add(_domain1!);
    }
    if (_domain2 != null && _domain2!.isNotEmpty) {
      domains.add(_domain2!);
    }
    return domains;
  }

  // Clear all profile data
  static void clearProfile() {
    _profileImagePath = null;
    _domain1 = null;
    _domain2 = null;
  }
}
