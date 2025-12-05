import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'services/phone_auth_service.dart';

class PhoneVerificationPage extends StatefulWidget {
  final String phoneNumber;
  
  const PhoneVerificationPage({
    super.key,
    required this.phoneNumber,
  });

  @override
  State<PhoneVerificationPage> createState() => _PhoneVerificationPageState();
}

class _PhoneVerificationPageState extends State<PhoneVerificationPage> {
  final _formKey = GlobalKey<FormState>();
  final _codeController = TextEditingController();
  final PhoneAuthService _phoneAuthService = PhoneAuthService();
  bool _isLoading = false;
  bool _isResending = false;
  String? _errorMessage;
  String? _verificationId;
  int _resendTimer = 0;

  @override
  void initState() {
    super.initState();
    _sendVerificationCode();
  }

  @override
  void dispose() {
    _codeController.dispose();
    super.dispose();
  }

  Future<void> _sendVerificationCode() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    await _phoneAuthService.verifyPhoneNumber(
      phoneNumber: widget.phoneNumber,
      onCodeSent: (verificationId) {
        setState(() {
          _verificationId = verificationId;
          _isLoading = false;
          _startResendTimer();
        });
      },
      onError: (error) {
        setState(() {
          _errorMessage = error;
          _isLoading = false;
        });
      },
      onVerificationCompleted: (userCredential) {
        // Auto-verification completed successfully
        Navigator.of(context).pop();
      },
    );
  }

  void _startResendTimer() {
    setState(() {
      _resendTimer = 60;
    });
    
    Future.delayed(const Duration(seconds: 1), () {
      if (mounted && _resendTimer > 0) {
        setState(() {
          _resendTimer--;
        });
        _startResendTimer();
      }
    });
  }

  Future<void> _verifyCode() async {
    if (_formKey.currentState!.validate() && _verificationId != null) {
      setState(() {
        _isLoading = true;
        _errorMessage = null;
      });

      try {
        await _phoneAuthService.verifySmsCode(_codeController.text.trim());
        Navigator.of(context).pop();
      } catch (e) {
        setState(() {
          _errorMessage = e.toString();
          _isLoading = false;
        });
      }
    }
  }

  Future<void> _resendCode() async {
    if (_resendTimer > 0) return;
    
    setState(() {
      _isResending = true;
      _errorMessage = null;
    });

    await _sendVerificationCode();
    
    setState(() {
      _isResending = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('التحقق من رقم الهاتف'),
        backgroundColor: Colors.blue[800],
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
                      const Icon(
                        Icons.phone_android,
                        size: 80,
                        color: Colors.blue,
                      ),
                      const SizedBox(height: 16),
                      const Text(
                        'أدخل رمز التحقق',
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: Colors.blue,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'تم إرسال رمز التحقق إلى ${widget.phoneNumber}',
                        style: const TextStyle(
                          fontSize: 14,
                          color: Colors.grey,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 32),
                      TextFormField(
                        controller: _codeController,
                        decoration: InputDecoration(
                          labelText: 'رمز التحقق',
                          prefixIcon: const Icon(Icons.confirmation_number),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        keyboardType: TextInputType.number,
                        maxLength: 6,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'يرجى إدخال رمز التحقق';
                          }
                          if (value.length != 6) {
                            return 'يجب أن يكون رمز التحقق 6 أرقام';
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
                      const SizedBox(height: 24),
                      SizedBox(
                        width: double.infinity,
                        height: 48,
                        child: ElevatedButton(
                          onPressed: (_isLoading || _verificationId == null) ? null : _verifyCode,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.blue[800],
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          child: _isLoading
                              ? const CircularProgressIndicator(color: Colors.white)
                              : const Text(
                                  'التحقق',
                                  style: TextStyle(
                                    fontSize: 16,
                                    color: Colors.white,
                                  ),
                                ),
                        ),
                      ),
                      const SizedBox(height: 16),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          TextButton(
                            onPressed: (_resendTimer > 0 || _isResending) ? null : _resendCode,
                            child: Text(
                              _resendTimer > 0
                                  ? 'إعادة الإرسال بعد $_resendTimer ثانية'
                                  : 'إعادة إرسال الرمز',
                              style: TextStyle(
                                color: _resendTimer > 0 || _isResending
                                    ? Colors.grey
                                    : Colors.blue[800],
                              ),
                            ),
                          ),
                        ],
                      ),
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