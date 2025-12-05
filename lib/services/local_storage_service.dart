import 'dart:convert';
import 'dart:io';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:path_provider/path_provider.dart';
import 'package:image_picker/image_picker.dart';

class LocalStorageService {
  static const String _userProfileKey = 'user_profile';
  static const String _userSettingsKey = 'user_settings';
  static const String _profileImagePathKey = 'profile_image_path';

  // Get SharedPreferences instance
  static Future<SharedPreferences> _getPrefs() async {
    return await SharedPreferences.getInstance();
  }

  // Save user profile data
  static Future<bool> saveUserProfile(Map<String, dynamic> profileData) async {
    try {
      final prefs = await _getPrefs();
      final jsonString = jsonEncode(profileData);
      return await prefs.setString(_userProfileKey, jsonString);
    } catch (e) {
      print('Error saving user profile: $e');
      return false;
    }
  }

  // Get user profile data
  static Future<Map<String, dynamic>?> getUserProfile() async {
    try {
      final prefs = await _getPrefs();
      final jsonString = prefs.getString(_userProfileKey);
      
      if (jsonString != null) {
        return jsonDecode(jsonString) as Map<String, dynamic>;
      }
      return null;
    } catch (e) {
      print('Error getting user profile: $e');
      return null;
    }
  }

  // Save user settings
  static Future<bool> saveUserSettings(Map<String, dynamic> settingsData) async {
    try {
      final prefs = await _getPrefs();
      final jsonString = jsonEncode(settingsData);
      return await prefs.setString(_userSettingsKey, jsonString);
    } catch (e) {
      print('Error saving user settings: $e');
      return false;
    }
  }

  // Get user settings
  static Future<Map<String, dynamic>?> getUserSettings() async {
    try {
      final prefs = await _getPrefs();
      final jsonString = prefs.getString(_userSettingsKey);
      
      if (jsonString != null) {
        return jsonDecode(jsonString) as Map<String, dynamic>;
      }
      return null;
    } catch (e) {
      print('Error getting user settings: $e');
      return null;
    }
  }

  // Save profile image path
  static Future<bool> saveProfileImagePath(String imagePath) async {
    try {
      final prefs = await _getPrefs();
      return await prefs.setString(_profileImagePathKey, imagePath);
    } catch (e) {
      print('Error saving profile image path: $e');
      return false;
    }
  }

  // Get profile image path
  static Future<String?> getProfileImagePath() async {
    try {
      final prefs = await _getPrefs();
      return prefs.getString(_profileImagePathKey);
    } catch (e) {
      print('Error getting profile image path: $e');
      return null;
    }
  }

  // Delete profile image
  static Future<bool> deleteProfileImage() async {
    try {
      final prefs = await _getPrefs();
      final imagePath = await getProfileImagePath();
      
      if (imagePath != null) {
        final file = File(imagePath);
        if (await file.exists()) {
          await file.delete();
        }
      }
      
      return await prefs.remove(_profileImagePathKey);
    } catch (e) {
      print('Error deleting profile image: $e');
      return false;
    }
  }

  // Pick image from gallery
  static Future<File?> pickImageFromGallery() async {
    try {
      final picker = ImagePicker();
      final pickedFile = await picker.pickImage(
        source: ImageSource.gallery,
        maxWidth: 800,
        maxHeight: 800,
        imageQuality: 85,
      );
      
      if (pickedFile != null) {
        return File(pickedFile.path);
      }
      return null;
    } catch (e) {
      print('Error picking image: $e');
      return null;
    }
  }

  // Save image to app directory
  static Future<String?> saveImageToAppDirectory(File imageFile) async {
    try {
      final directory = await getApplicationDocumentsDirectory();
      final fileName = 'profile_image_${DateTime.now().millisecondsSinceEpoch}.jpg';
      final savedImage = File('${directory.path}/$fileName');
      
      await savedImage.writeAsBytes(await imageFile.readAsBytes());
      return savedImage.path;
    } catch (e) {
      print('Error saving image to app directory: $e');
      return null;
    }
  }

  // Clear all user data
  static Future<bool> clearAllUserData() async {
    try {
      final prefs = await _getPrefs();
      
      // Delete profile image
      await deleteProfileImage();
      
      // Clear SharedPreferences
      final profileRemoved = await prefs.remove(_userProfileKey);
      final settingsRemoved = await prefs.remove(_userSettingsKey);
      final imagePathRemoved = await prefs.remove(_profileImagePathKey);
      
      return profileRemoved && settingsRemoved && imagePathRemoved;
    } catch (e) {
      print('Error clearing all user data: $e');
      return false;
    }
  }

  // Initialize default user settings
  static Future<Map<String, dynamic>> getDefaultSettings() async {
    return {
      'notifications': true,
      'language': 'ar',
      'theme': 'light',
    };
  }

  // Initialize default user profile
  static Future<Map<String, dynamic>> getDefaultProfile() async {
    return {
      'displayName': 'مستخدم',
      'email': '',
      'phoneNumber': '',
      'photoURL': '',
      'createdAt': DateTime.now().toIso8601String(),
      'updatedAt': DateTime.now().toIso8601String(),
    };
  }

  // Check if user data exists
  static Future<bool> hasUserData() async {
    try {
      final prefs = await _getPrefs();
      return prefs.containsKey(_userProfileKey) || 
             prefs.containsKey(_userSettingsKey) ||
             prefs.containsKey(_profileImagePathKey);
    } catch (e) {
      print('Error checking user data: $e');
      return false;
    }
  }
}