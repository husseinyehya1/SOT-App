import 'dart:io';
import 'package:firebase_auth/firebase_auth.dart';
import 'local_storage_service.dart';

class LocalUserProfile {
  final String uid;
  final String? displayName;
  final String? email;
  final String? phoneNumber;
  final String? photoPath; // Local file path instead of URL
  final Map<String, dynamic>? settings;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  LocalUserProfile({
    required this.uid,
    this.displayName,
    this.email,
    this.phoneNumber,
    this.photoPath,
    this.settings,
    this.createdAt,
    this.updatedAt,
  });

  factory LocalUserProfile.fromMap(Map<String, dynamic> data) {
    return LocalUserProfile(
      uid: data['uid'] ?? '',
      displayName: data['displayName'],
      email: data['email'],
      phoneNumber: data['phoneNumber'],
      photoPath: data['photoPath'],
      settings: data['settings'] ?? {},
      createdAt: data['createdAt'] != null 
          ? DateTime.parse(data['createdAt']) 
          : null,
      updatedAt: data['updatedAt'] != null 
          ? DateTime.parse(data['updatedAt']) 
          : null,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'uid': uid,
      'displayName': displayName,
      'email': email,
      'phoneNumber': phoneNumber,
      'photoPath': photoPath,
      'settings': settings ?? {},
      'createdAt': createdAt?.toIso8601String(),
      'updatedAt': updatedAt?.toIso8601String(),
    };
  }

  LocalUserProfile copyWith({
    String? displayName,
    String? email,
    String? phoneNumber,
    String? photoPath,
    Map<String, dynamic>? settings,
  }) {
    return LocalUserProfile(
      uid: uid,
      displayName: displayName ?? this.displayName,
      email: email ?? this.email,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      photoPath: photoPath ?? this.photoPath,
      settings: settings ?? this.settings,
      createdAt: createdAt,
      updatedAt: DateTime.now(),
    );
  }
}

class LocalUserProfileService {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // Initialize user profile from Firebase Auth and local storage
  Future<LocalUserProfile?> initializeUserProfile() async {
    try {
      final user = _auth.currentUser;
      if (user == null) return null;

      // Check if local profile exists
      final existingProfile = await getUserProfile();
      
      if (existingProfile == null) {
        // Create new local profile from Firebase Auth data
        final defaultSettings = await LocalStorageService.getDefaultSettings();
        final newProfile = LocalUserProfile(
          uid: user.uid,
          displayName: user.displayName ?? 'مستخدم',
          email: user.email ?? '',
          phoneNumber: user.phoneNumber ?? '',
          photoPath: null,
          settings: defaultSettings,
          createdAt: DateTime.now(),
          updatedAt: DateTime.now(),
        );
        
        await saveUserProfile(newProfile);
        return newProfile;
      }
      
      return existingProfile;
    } catch (e) {
      print('Error initializing user profile: $e');
      return null;
    }
  }

  // Get user profile from local storage
  Future<LocalUserProfile?> getUserProfile() async {
    try {
      final profileData = await LocalStorageService.getUserProfile();
      if (profileData != null) {
        return LocalUserProfile.fromMap(profileData);
      }
      return null;
    } catch (e) {
      print('Error getting user profile: $e');
      return null;
    }
  }

  // Save user profile to local storage
  Future<bool> saveUserProfile(LocalUserProfile profile) async {
    try {
      return await LocalStorageService.saveUserProfile(profile.toMap());
    } catch (e) {
      print('Error saving user profile: $e');
      return false;
    }
  }

  // Update user settings
  Future<bool> updateUserSettings(Map<String, dynamic> settings) async {
    try {
      final currentProfile = await getUserProfile();
      if (currentProfile != null) {
        final updatedProfile = currentProfile.copyWith(settings: settings);
        return await saveUserProfile(updatedProfile);
      }
      return false;
    } catch (e) {
      print('Error updating user settings: $e');
      return false;
    }
  }

  // Update profile field
  Future<bool> updateProfileField(String field, dynamic value) async {
    try {
      final currentProfile = await getUserProfile();
      if (currentProfile != null) {
        LocalUserProfile updatedProfile;
        
        switch (field) {
          case 'displayName':
            updatedProfile = currentProfile.copyWith(displayName: value);
            break;
          case 'phoneNumber':
            updatedProfile = currentProfile.copyWith(phoneNumber: value);
            break;
          default:
            return false;
        }
        
        return await saveUserProfile(updatedProfile);
      }
      return false;
    } catch (e) {
      print('Error updating profile field: $e');
      return false;
    }
  }

  // Upload and save profile picture locally
  Future<String?> uploadProfilePicture(File imageFile) async {
    try {
      // Save image to app directory
      final savedImagePath = await LocalStorageService.saveImageToAppDirectory(imageFile);
      
      if (savedImagePath != null) {
        // Update profile with new image path
        final currentProfile = await getUserProfile();
        if (currentProfile != null) {
          // Delete old image if exists
          if (currentProfile.photoPath != null) {
            final oldImageFile = File(currentProfile.photoPath!);
            if (await oldImageFile.exists()) {
              await oldImageFile.delete();
            }
          }
          
          // Update profile with new image path
          final updatedProfile = currentProfile.copyWith(photoPath: savedImagePath);
          await saveUserProfile(updatedProfile);
          
          return savedImagePath;
        }
      }
      return null;
    } catch (e) {
      print('Error uploading profile picture: $e');
      return null;
    }
  }

  // Pick image from gallery
  Future<File?> pickImageFromGallery() async {
    return await LocalStorageService.pickImageFromGallery();
  }

  // Clear all user data
  Future<bool> clearAllUserData() async {
    return await LocalStorageService.clearAllUserData();
  }

  // Check if user data exists
  Future<bool> hasUserData() async {
    return await LocalStorageService.hasUserData();
  }

  // Get user settings
  Future<Map<String, dynamic>?> getUserSettings() async {
    return await LocalStorageService.getUserSettings();
  }
}