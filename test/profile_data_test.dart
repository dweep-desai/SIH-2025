import 'package:flutter_test/flutter_test.dart';
import 'package:sih_project/data/profile_data.dart';

void main() {
  group('ProfileData Tests', () {
    tearDown(() {
      // Clear profile data after each test
      ProfileData.clearProfile();
    });

    test('should store and retrieve domain1', () {
      ProfileData.setDomain1('AI/ML');
      expect(ProfileData.domain1, equals('AI/ML'));
    });

    test('should store and retrieve domain2', () {
      ProfileData.setDomain2('Data Science');
      expect(ProfileData.domain2, equals('Data Science'));
    });

    test('should return empty list when no domains are set', () {
      expect(ProfileData.getDomains(), isEmpty);
    });

    test('should return domains list when domains are set', () {
      ProfileData.setDomain1('AI/ML');
      ProfileData.setDomain2('Data Science');
      
      final domains = ProfileData.getDomains();
      expect(domains, contains('AI/ML'));
      expect(domains, contains('Data Science'));
      expect(domains.length, equals(2));
    });

    test('should return only non-null domains', () {
      ProfileData.setDomain1('AI/ML');
      ProfileData.setDomain2(null);
      
      final domains = ProfileData.getDomains();
      expect(domains, contains('AI/ML'));
      expect(domains.length, equals(1));
    });

    test('should clear all profile data', () {
      ProfileData.setDomain1('AI/ML');
      ProfileData.setDomain2('Data Science');
      ProfileData.setProfileImagePath('/path/to/image.jpg');
      
      ProfileData.clearProfile();
      
      expect(ProfileData.domain1, isNull);
      expect(ProfileData.domain2, isNull);
      expect(ProfileData.profileImagePath, isNull);
      expect(ProfileData.getDomains(), isEmpty);
    });
  });
}
