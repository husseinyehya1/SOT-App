import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'dart:io';
import 'package:image_picker/image_picker.dart';

class UserProfile {
  final String uid;
  final String? displayName;
  final String? email;
  final String? phoneNumber;
  final String? photoURL;
  final Map<String, dynamic>? settings;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  UserProfile({
    required this.uid,
    this.displayName,
    this.email,
    this.phoneNumber,
    this.photoURL,
    this.settings,
    this.createdAt,
    this.updatedAt,
  });

  factory UserProfile.fromFirestore(DocumentSnapshot doc) {
    Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
    return UserProfile(
      uid: doc.id,
      displayName: data['displayName'],
      email: data['email'],
      phoneNumber: data['phoneNumber'],
      photoURL: data['photoURL'],
      settings: data['settings'] ?? {},
      createdAt: data['createdAt']?.toDate(),
      updatedAt: data['updatedAt']?.toDate(),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'displayName': displayName,
      'email': email,
      'phoneNumber': phoneNumber,
      'photoURL': photoURL,
      'settings': settings ?? {},
      'createdAt': createdAt ?? FieldValue.serverTimestamp(),
      'updatedAt': FieldValue.serverTimestamp(),
    };
  }

  UserProfile copyWith({
    String? displayName,
    String? email,
    String? phoneNumber,
    String? photoURL,
    Map<String, dynamic>? settings,
  }) {
    return UserProfile(
      uid: uid,
      displayName: displayName ?? this.displayName,
      email: email ?? this.email,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      photoURL: photoURL ?? this.photoURL,
      settings: settings ?? this.settings,
      createdAt: createdAt,
      updatedAt: DateTime.now(),
    );
  }
}

class UserProfileService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseStorage _storage = FirebaseStorage.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // Collection reference
  CollectionReference get _usersCollection => _firestore.collection('users');

  // Create or update user profile
  Future<void> createOrUpdateUserProfile(UserProfile profile) async {
    try {
      await _usersCollection.doc(profile.uid).set(
        profile.toMap(),
        SetOptions(merge: true),
      );
    } catch (e) {
      throw Exception('Failed to update user profile: $e');
    }
  }

  // Get user profile
  Future<UserProfile?> getUserProfile(String uid) async {
    try {
      final doc = await _usersCollection.doc(uid).get();
      if (doc.exists) {
        return UserProfile.fromFirestore(doc);
      }
      return null;
    } catch (e) {
      throw Exception('Failed to get user profile: $e');
    }
  }

  // Get user profile stream
  Stream<UserProfile?> getUserProfileStream(String uid) {
    return _usersCollection.doc(uid).snapshots().map((doc) {
      if (doc.exists) {
        return UserProfile.fromFirestore(doc);
      }
      return null;
    });
  }

  // Update user settings
  Future<void> updateUserSettings(String uid, Map<String, dynamic> settings) async {
    try {
      await _usersCollection.doc(uid).update({
        'settings': settings,
        'updatedAt': FieldValue.serverTimestamp(),
      });
    } catch (e) {
      throw Exception('Failed to update user settings: $e');
    }
  }

  // Update profile picture
  Future<String?> uploadProfilePicture(String uid, File imageFile) async {
    try {
      final ref = _storage.ref().child('profile_pictures/$uid.jpg');
      await ref.putFile(imageFile);
      final url = await ref.getDownloadURL();
      
      // Update user profile with new photo URL
      await _usersCollection.doc(uid).update({
        'photoURL': url,
        'updatedAt': FieldValue.serverTimestamp(),
      });
      
      return url;
    } catch (e) {
      throw Exception('Failed to upload profile picture: $e');
    }
  }

  // Pick image from gallery
  Future<File?> pickImageFromGallery() async {
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
      throw Exception('Failed to pick image: $e');
    }
  }

  // Initialize user profile from Firebase Auth
  Future<void> initializeUserProfile() async {
    try {
      final user = _auth.currentUser;
      if (user != null) {
        final existingProfile = await getUserProfile(user.uid);
        
        if (existingProfile == null) {
          // Create new profile
          final newProfile = UserProfile(
            uid: user.uid,
            displayName: user.displayName,
            email: user.email,
            phoneNumber: user.phoneNumber,
            photoURL: user.photoURL,
            settings: {
              'notifications': true,
              'language': 'ar',
              'theme': 'light',
              'pushNotifications': true,
              'emailNotifications': false,
            },
            createdAt: DateTime.now(),
            updatedAt: DateTime.now(),
          );
          
          await createOrUpdateUserProfile(newProfile);
        }
      }
    } catch (e) {
      throw Exception('Failed to initialize user profile: $e');
    }
  }

  // Update user profile field
  Future<void> updateProfileField(String uid, String field, dynamic value) async {
    try {
      await _usersCollection.doc(uid).update({
        field: value,
        'updatedAt': FieldValue.serverTimestamp(),
      });
    } catch (e) {
      throw Exception('Failed to update profile field: $e');
    }
  }
}