import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class ForgotPasswordPage extends StatefulWidget {
  const ForgotPasswordPage({super.key});

  @override
  State<ForgotPasswordPage> createState() => _ForgotPasswordPageState();
}

class _ForgotPasswordPageState extends State<ForgotPasswordPage> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  bool _isLoading = false;
  bool _isEmailSent = false;
  String? _errorMessage;
  String? _successMessage;

  @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
  }

  Future<void> _resetPassword() async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _isLoading = true;
        _errorMessage = null;
        _successMessage = null;
      });

      try {
        await FirebaseAuth.instance.sendPasswordResetEmail(
          email: _emailController.text.trim(),
        );
        
        setState(() {
          _isEmailSent = true;
          _successMessage = 'تم إرسال رابط إعادة تعيين كلمة المرور إلى بريدك الإلكتروني';
        });
      } on FirebaseAuthException catch (e) {
        String errorMessage = 'فشل إرسال رابط إعادة التعيين';
        
        switch (e.code) {
          case 'invalid-email':
            errorMessage = 'البريد الإلكتروني غير صحيح';
            break;
          case 'user-not-found':
            errorMessage = 'لا يوجد حساب مرتبط بهذا البريد الإلكتروني';
            break;
          case 'too-many-requests':
            errorMessage = 'تم إرسال العديد من الطلبات. يرجى المحاولة لاحقاً';
            break;
          default:
            errorMessage = e.message ?? 'فشل إرسال رابط إعادة التعيين';
        }
        
        setState(() {
          _errorMessage = errorMessage;
        });
      } catch (e) {
        setState(() {
          _errorMessage = 'حدث خطأ غير متوقع';
        });
      } finally {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('نسيت كلمة المرور'),
        backgroundColor: Colors.blue[800],
        foregroundColor: Colors.white,
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Colors.blue[800]!,
              Colors.blue[600]!,
              Colors.blue[400]!,
            ],
          ),
        ),
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(16.0),
            child: Card(
              elevation: 8,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              child: Padding(
                padding: const EdgeInsets.all(24.0),
                child: Form(
                  key: _formKey,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const SizedBox(height: 16),
                      const Icon(
                        Icons.lock_reset,
                        size: 80,
                        color: Colors.blue,
                      ),
                      const SizedBox(height: 16),
                      const Text(
                        'إعادة تعيين كلمة المرور',
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: Colors.blue,
                        ),
                      ),
                      const SizedBox(height: 8),
                      const Text(
                        'أدخل بريدك الإلكتروني وسنرسل لك رابط لإعادة تعيين كلمة المرور',
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.grey,
                          height: 1.5,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      
                      const SizedBox(height: 32),
                      
                      // Email Field
                      TextFormField(
                        controller: _emailController,
                        decoration: InputDecoration(
                          labelText: 'البريد الإلكتروني',
                          prefixIcon: const Icon(Icons.email),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        keyboardType: TextInputType.emailAddress,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'يرجى إدخال البريد الإلكتروني';
                          }
                          if (!value.contains('@')) {
                            return 'يرجى إدخال بريد إلكتروني صحيح';
                          }
                          return null;
                        },
                      ),
                      
                      if (_errorMessage != null) ...[
                        const SizedBox(height: 16),
                        Text(
                          _errorMessage!,
                          style: const TextStyle(
                            color: Colors.red,
                            fontSize: 14,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ],
                      
                      if (_successMessage != null) ...[
                        const SizedBox(height: 16),
                        Text(
                          _successMessage!,
                          style: const TextStyle(
                            color: Colors.green,
                            fontSize: 14,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ],
                      
                      const SizedBox(height: 24),
                      
                      // Reset Password Button
                      SizedBox(
                        width: double.infinity,
                        height: 48,
                        child: ElevatedButton(
                          onPressed: _isLoading || _isEmailSent ? null : _resetPassword,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.blue[800],
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          child: _isLoading
                              ? const CircularProgressIndicator(color: Colors.white)
                              : const Text(
                                  'إرسال رابط إعادة التعيين',
                                  style: TextStyle(
                                    fontSize: 16,
                                    color: Colors.white,
                                  ),
                                ),
                        ),
                      ),
                      
                      if (_isEmailSent) ...[
                        const SizedBox(height: 16),
                        SizedBox(
                          width: double.infinity,
                          height: 48,
                          child: OutlinedButton(
                            onPressed: () {
                              Navigator.pop(context);
                            },
                            style: OutlinedButton.styleFrom(
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                              side: BorderSide(color: Colors.blue[800]!),
                            ),
                            child: Text(
                              'العودة لتسجيل الدخول',
                              style: TextStyle(
                                color: Colors.blue[800],
                                fontSize: 16,
                              ),
                            ),
                          ),
                        ),
                      ],
                      
                      if (!_isEmailSent) ...[
                        const SizedBox(height: 16),
                        
                        // Back to Login Link
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Text('تذكرت كلمة المرور؟'),
                            TextButton(
                              onPressed: () {
                                Navigator.pop(context);
                              },
                              child: const Text(
                                'تسجيل الدخول',
                                style: TextStyle(
                                  color: Colors.blue,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                      
                      const SizedBox(height: 16),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}