// Firebase Database Initialization Script
// This script helps set up the Firestore database structure and security rules

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class DatabaseInitializer {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // Initialize user document with default data
  Future<void> initializeUserDocument() async {
    try {
      final user = _auth.currentUser;
      if (user == null) return;

      final userDoc = _firestore.collection('users').doc(user.uid);
      final docSnapshot = await userDoc.get();

      if (!docSnapshot.exists) {
        // Create new user document with default data
        await userDoc.set({
          'displayName': user.displayName ?? 'مستخدم',
          'email': user.email ?? '',
          'phoneNumber': user.phoneNumber ?? '',
          'photoURL': user.photoURL ?? '',
          'settings': {
            'notifications': true,
            'language': 'ar',
            'theme': 'light',
            'pushNotifications': true,
            'emailNotifications': false,
          },
          'createdAt': FieldValue.serverTimestamp(),
          'updatedAt': FieldValue.serverTimestamp(),
        });
        
        print('✅ User document created successfully');
      } else {
        print('ℹ️ User document already exists');
      }
    } catch (e) {
      print('❌ Error initializing user document: $e');
      rethrow;
    }
  }

  // Update existing user document
  Future<void> updateUserDocument(Map<String, dynamic> updates) async {
    try {
      final user = _auth.currentUser;
      if (user == null) return;

      final userDoc = _firestore.collection('users').doc(user.uid);
      
      await userDoc.update({
        ...updates,
        'updatedAt': FieldValue.serverTimestamp(),
      });
      
      print('✅ User document updated successfully');
    } catch (e) {
      print('❌ Error updating user document: $e');
      rethrow;
    }
  }

  // Get user document
  Future<Map<String, dynamic>?> getUserDocument() async {
    try {
      final user = _auth.currentUser;
      if (user == null) return null;

      final userDoc = _firestore.collection('users').doc(user.uid);
      final docSnapshot = await userDoc.get();

      if (docSnapshot.exists) {
        return docSnapshot.data();
      }
      return null;
    } catch (e) {
      print('❌ Error getting user document: $e');
      rethrow;
    }
  }

  // Check if user document exists
  Future<bool> userDocumentExists() async {
    try {
      final user = _auth.currentUser;
      if (user == null) return false;

      final userDoc = _firestore.collection('users').doc(user.uid);
      final docSnapshot = await userDoc.get();

      return docSnapshot.exists;
    } catch (e) {
      print('❌ Error checking user document: $e');
      return false;
    }
  }

  // Delete user document (for testing purposes)
  Future<void> deleteUserDocument() async {
    try {
      final user = _auth.currentUser;
      if (user == null) return;

      final userDoc = _firestore.collection('users').doc(user.uid);
      await userDoc.delete();
      
      print('✅ User document deleted successfully');
    } catch (e) {
      print('❌ Error deleting user document: $e');
      rethrow;
    }
  }

  // Create indexes (manual setup required in Firebase Console)
  void printSetupInstructions() {
    print('''
🔧 Firebase Database Setup Instructions:

1. **Firestore Database**:
   - Go to Firebase Console > Firestore Database
   - Create database in production mode
   - Choose your preferred location (e.g., us-central1)

2. **Security Rules**:
   - Go to Firebase Console > Firestore > Rules
   - Copy and paste the rules from firestore.rules file
   - Click "Publish"

3. **Storage**:
   - Go to Firebase Console > Storage
   - Create storage bucket
   - Copy and paste the rules from storage.rules file
   - Click "Publish"

4. **Indexes** (if needed):
   - Single-field indexes are created automatically
   - Composite indexes can be created as needed

5. **Test the Setup**:
   - Run the app and login
   - Check Firestore Console for user documents
   - Test profile picture upload functionality

✅ Database structure will be created automatically on first user login
    ''');
  }
}