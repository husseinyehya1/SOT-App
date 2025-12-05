import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

class GoogleAuthService {
  final GoogleSignIn _googleSignIn = GoogleSignIn(
    scopes: [
      'email',
      'https://www.googleapis.com/auth/contacts.readonly',
    ],
    // Force account selection on every sign-in attempt
    signInOption: SignInOption.standard,
  );
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future<User?> signInWithGoogle() async {
    try {
      // First, completely disconnect and sign out to clear all cached data
      try {
        await _googleSignIn.disconnect();
      } catch (e) {
        // Ignore disconnect errors - account might not be connected
      }
      
      // Force sign out to clear any cached accounts
      await _googleSignIn.signOut();
      await _auth.signOut();
      
      // Small delay to ensure complete cleanup
      await Future.delayed(const Duration(milliseconds: 500));
      
      // Create a fresh GoogleSignIn instance to force account selection
      final GoogleSignIn freshGoogleSignIn = GoogleSignIn(
        scopes: [
          'email',
          'https://www.googleapis.com/auth/contacts.readonly',
        ],
        signInOption: SignInOption.standard,
      );
      
      // Trigger the authentication flow with fresh account selection
      final GoogleSignInAccount? googleUser = await freshGoogleSignIn.signIn();
      
      if (googleUser == null) {
        // User canceled the sign-in
        return null;
      }

      // Obtain the auth details from the request
      final GoogleSignInAuthentication googleAuth = await googleUser.authentication;

      // Create a new credential
      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      // Sign in to Firebase with the Google credential
      final UserCredential userCredential = await _auth.signInWithCredential(credential);
      
      return userCredential.user;
    } catch (e) {
      throw _handleGoogleSignInError(e);
    }
  }

  Future<void> signOut() async {
    try {
      // Completely disconnect and sign out to clear all cached data
      try {
        await _googleSignIn.disconnect();
      } catch (e) {
        // Ignore disconnect errors - account might not be connected
      }
      
      await _googleSignIn.signOut();
      await _auth.signOut();
    } catch (e) {
      rethrow;
    }
  }

  String _handleGoogleSignInError(dynamic error) {
    if (error is FirebaseAuthException) {
      switch (error.code) {
        case 'account-exists-with-different-credential':
          return 'الحساب موجود بالفعل مع بيانات اعتماد مختلفة';
        case 'invalid-credential':
          return 'بيانات الاعتماد غير صالحة';
        case 'operation-not-allowed':
          return 'عملية تسجيل الدخول بجوجل غير مفعلة';
        case 'user-disabled':
          return 'تم تعطيل الحساب';
        case 'user-not-found':
          return 'لم يتم العثور على المستخدم';
        case 'wrong-password':
          return 'كلمة مرور خاطئة';
        default:
          return error.message ?? 'فشل تسجيل الدخول بجوجل';
      }
    } else if (error.toString().contains('network_error')) {
      return 'خطأ في الشبكة. يرجى التحقق من اتصال الإنترنت';
    } else if (error.toString().contains('sign_in_canceled')) {
      return 'تم إلغاء تسجيل الدخول';
    } else {
      return 'فشل تسجيل الدخول بجوجل. حاول مرة أخرى';
    }
  }
}