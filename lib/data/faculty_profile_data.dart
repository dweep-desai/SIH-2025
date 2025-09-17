import 'dart:io';
import 'package:flutter/material.dart';

class FacultyProfileData {
  static String? _profileImagePath;
  static String? _primaryDomain;
  static String? _secondaryDomain;

  static String? get profileImagePath => _profileImagePath;
  static String? get primaryDomain => _primaryDomain;
  static String? get secondaryDomain => _secondaryDomain;

  static void setProfileImagePath(String? path) {
    _profileImagePath = path;
  }

  static void setPrimaryDomain(String? domain) {
    _primaryDomain = domain;
  }

  static void setSecondaryDomain(String? domain) {
    _secondaryDomain = domain;
  }

  static ImageProvider? getProfileImageProvider() {
    try {
      if (_profileImagePath != null && _profileImagePath!.isNotEmpty) {
        final file = File(_profileImagePath!);
        if (file.existsSync()) {
          return FileImage(file);
        }
      }
    } catch (_) {}
    return null;
  }

  static List<String> getDomains() {
    final result = <String>[];
    if (_primaryDomain != null && _primaryDomain!.isNotEmpty) {
      result.add(_primaryDomain!);
    }
    if (_secondaryDomain != null && _secondaryDomain!.isNotEmpty) {
      result.add(_secondaryDomain!);
    }
    return result;
  }

  static void clear() {
    _profileImagePath = null;
    _primaryDomain = null;
    _secondaryDomain = null;
  }
}


