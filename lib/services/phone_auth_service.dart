import 'package:firebase_auth/firebase_auth.dart';

class PhoneAuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  String? _verificationId;
  int? _resendToken;

  Future<void> verifyPhoneNumber({
    required String phoneNumber,
    required Function(String verificationId) onCodeSent,
    required Function(String error) onError,
    required Function(UserCredential) onVerificationCompleted,
    Function()? onTimeout,
  }) async {
    try {
      await _auth.verifyPhoneNumber(
        phoneNumber: phoneNumber,
        timeout: const Duration(seconds: 60),
        verificationCompleted: (PhoneAuthCredential credential) async {
          try {
            final UserCredential userCredential = await _auth.signInWithCredential(credential);
            onVerificationCompleted(userCredential);
          } catch (e) {
            onError('فشل التحقق التلقائي: ${e.toString()}');
          }
        },
        verificationFailed: (FirebaseAuthException e) {
          String errorMessage;
          switch (e.code) {
            case 'invalid-phone-number':
              errorMessage = 'رقم الهاتف غير صالح';
              break;
            case 'too-many-requests':
              errorMessage = 'تم إرسال العديد من الطلبات. حاول مرة أخرى لاحقًا';
              break;
            case 'quota-exceeded':
              errorMessage = 'تم تجاوز الحد المسموح به';
              break;
            default:
              errorMessage = 'فشل التحقق: ${e.message ?? "خطأ غير معروف"}';
          }
          onError(errorMessage);
        },
        codeSent: (String verificationId, int? resendToken) {
          _verificationId = verificationId;
          _resendToken = resendToken;
          onCodeSent(verificationId);
        },
        codeAutoRetrievalTimeout: (String verificationId) {
          _verificationId = verificationId;
          if (onTimeout != null) onTimeout();
        },
        forceResendingToken: _resendToken,
      );
    } catch (e) {
      onError('خطأ في إرسال رمز التحقق: ${e.toString()}');
    }
  }

  Future<UserCredential?> verifySmsCode(String smsCode) async {
    if (_verificationId == null) {
      throw Exception('لم يتم إرسال رمز التحقق بعد');
    }

    try {
      final credential = PhoneAuthProvider.credential(
        verificationId: _verificationId!,
        smsCode: smsCode,
      );

      return await _auth.signInWithCredential(credential);
    } catch (e) {
      throw Exception('رمز التحقق غير صحيح أو منتهي الصلاحية');
    }
  }

  Future<void> signOut() async {
    await _auth.signOut();
    _verificationId = null;
    _resendToken = null;
  }

  String? getCurrentUserPhoneNumber() {
    final user = _auth.currentUser;
    return user?.phoneNumber;
  }

  bool isUserSignedIn() {
    return _auth.currentUser != null;
  }
}