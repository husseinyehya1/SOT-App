import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:provider/provider.dart';
import 'dart:io';
import '../services/local_user_profile_service.dart';
import '../services/theme_service.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final LocalUserProfileService _profileService = LocalUserProfileService();
  final FirebaseAuth _auth = FirebaseAuth.instance;
  
  LocalUserProfile? _userProfile;
  bool _isLoading = true;
  bool _isUploadingImage = false;
  File? _selectedImage;

  // Settings state
  bool _notificationsEnabled = true;
  bool _darkModeEnabled = false;
  String _selectedLanguage = 'ar';

  @override
  void initState() {
    super.initState();
    _loadUserProfile();
  }

  Future<void> _loadUserProfile() async {
    try {
      setState(() => _isLoading = true);
      
      final user = _auth.currentUser;
      if (user != null) {
        // Initialize profile if not exists
        final profile = await _profileService.initializeUserProfile();
        
        if (profile != null) {
          setState(() {
            _userProfile = profile;
            _loadSettingsFromProfile(profile);
          });
        }
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('فشل تحميل بيانات الملف الشخصي: $e')),
      );
    } finally {
      setState(() => _isLoading = false);
    }
  }

  void _loadSettingsFromProfile(LocalUserProfile profile) {
    final settings = profile.settings ?? {};
    setState(() {
      _notificationsEnabled = settings['notifications'] ?? true;
      _darkModeEnabled = settings['theme'] == 'dark';
      _selectedLanguage = settings['language'] ?? 'ar';
    });
  }

  Future<void> _updateSettings() async {
    try {
      final newSettings = {
        'notifications': _notificationsEnabled,
        'language': _selectedLanguage,
        'theme': _darkModeEnabled ? 'dark' : 'light',
      };

      final success = await _profileService.updateUserSettings(newSettings);
      
      if (success) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('تم حفظ الإعدادات بنجاح')),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('فشل حفظ الإعدادات')),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('فشل حفظ الإعدادات: $e')),
      );
    }
  }

  Future<void> _pickImage() async {
    try {
      final imageFile = await _profileService.pickImageFromGallery();
      if (imageFile != null) {
        setState(() {
          _selectedImage = imageFile;
        });
        await _uploadProfilePicture();
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('فشل اختيار الصورة: $e')),
      );
    }
  }

  Future<void> _uploadProfilePicture() async {
    if (_selectedImage == null) return;

    try {
      setState(() => _isUploadingImage = true);
      
      final photoPath = await _profileService.uploadProfilePicture(_selectedImage!);
      
      if (photoPath != null) {
        setState(() {
          _userProfile = _userProfile?.copyWith(photoPath: photoPath);
        });
        
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('تم تحديث صورة الملف الشخصي')),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('فشل رفع الصورة')),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('فشل رفع الصورة: $e')),
      );
    } finally {
      setState(() => _isUploadingImage = false);
    }
  }

  Future<void> _editProfileField(String field, String currentValue) async {
    final controller = TextEditingController(text: currentValue);
    
    final result = await showDialog<String>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('تعديل ${field == 'displayName' ? 'الاسم' : 'رقم الهاتف'}'),
        content: TextField(
          controller: controller,
          decoration: InputDecoration(
            labelText: field == 'displayName' ? 'الاسم الكامل' : 'رقم الهاتف',
            border: const OutlineInputBorder(),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('إلغاء'),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(context, controller.text.trim()),
            child: const Text('حفظ'),
          ),
        ],
      ),
    );

    if (result != null && result.isNotEmpty) {
      try {
        final success = await _profileService.updateProfileField(field, result);
        
        if (success) {
          setState(() {
            if (field == 'displayName') {
              _userProfile = _userProfile?.copyWith(displayName: result);
            } else if (field == 'phoneNumber') {
              _userProfile = _userProfile?.copyWith(phoneNumber: result);
            }
          });
          
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('تم تحديث البيانات بنجاح')),
          );
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('فشل تحديث البيانات')),
          );
        }
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('فشل تحديث البيانات: $e')),
        );
      }
    }
  }

  Future<void> _showLanguageDialog() async {
    final languages = {
      'ar': 'العربية',
      'en': 'English',
      'fr': 'Français',
    };

    String? selectedLanguage = _selectedLanguage;

    final result = await showDialog<String>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('اختر اللغة'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: languages.entries.map((entry) => 
            RadioListTile<String>(
              title: Text(entry.value),
              value: entry.key,
              groupValue: selectedLanguage,
              onChanged: (value) {
                selectedLanguage = value;
                Navigator.pop(context, value);
              },
            ),
          ).toList(),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('إلغاء'),
          ),
        ],
      ),
    );

    if (result != null) {
      setState(() {
        _selectedLanguage = result;
      });
      await _updateSettings();
    }
  }

  Future<void> _showHelpDialog() async {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('المساعدة'),
        content: const SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'الأسئلة الشائعة:',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 8),
              Text('• كيفية تغيير الصورة الشخصية؟'),
              Text(' اضغط على زر "تغيير الصورة" أعلاه'),
              SizedBox(height: 8),
              Text('• كيفية تعديل الاسم أو رقم الهاتف؟'),
              Text(' اضغط على عنصر المعلومات الذي تريد تعديله'),
              SizedBox(height: 8),
              Text('• هل تُحفظ البيانات على الجهاز؟'),
              Text(' نعم، جميع البيانات تُحفظ محلياً على جهازك'),
              SizedBox(height: 8),
              Text('• كيفية تغيير اللغة؟'),
              Text(' اضغط على عنصر "اللغة" في إعدادات الحساب'),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('حسناً'),
          ),
        ],
      ),
    );
  }

  Future<void> _showAboutDialog() async {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('عن التطبيق'),
        content: const SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'فريق التنظيم الطلابي - SOT',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 8),
              Text('الإصدار: 1.0.0'),
              SizedBox(height: 8),
              Text('تطبيق إداري لأعضاء فريق التنظيم الطلابي بوزارة التربية والتعليم'),
              SizedBox(height: 8),
              Text('جميع البيانات تُحفظ محلياً على جهازك لضمان الخصوصية'),
              SizedBox(height: 8),
              Text('© 2024 فريق التنظيم الطلابي'),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('حسناً'),
          ),
        ],
      ),
    );
  }

  Future<void> _showRatingDialog() async {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('قيم التطبيق'),
        content: const Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text('شكراً لاستخدامك تطبيق SOT!'),
            SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.star, color: Colors.amber, size: 32),
                Icon(Icons.star, color: Colors.amber, size: 32),
                Icon(Icons.star, color: Colors.amber, size: 32),
                Icon(Icons.star, color: Colors.amber, size: 32),
                Icon(Icons.star_border, size: 32),
              ],
            ),
            SizedBox(height: 8),
            Text('يمكنك تقييم التطبيق على المتجر'),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('لاحقاً'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('شكراً لتقييمك!')),
              );
            },
            child: const Text('تقييم'),
          ),
        ],
      ),
    );
  }

  Future<void> _signOut(BuildContext context) async {
    await _auth.signOut();
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Scaffold(
        body: Center(
          child: CircularProgressIndicator(),
        ),
      );
    }

    final user = _auth.currentUser;
    final displayName = _userProfile?.displayName ?? user?.displayName ?? 'مستخدم';
    final email = _userProfile?.email ?? user?.email ?? 'غير محدد';
    final phoneNumber = _userProfile?.phoneNumber ?? user?.phoneNumber ?? 'غير محدد';
    final photoPath = _userProfile?.photoPath;

    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: 240,
            floating: true,
            pinned: true,
            backgroundColor: Theme.of(context).colorScheme.primary,
            foregroundColor: Colors.white,
            flexibleSpace: FlexibleSpaceBar(
              titlePadding: const EdgeInsetsDirectional.only(
                start: 16,
                bottom: 16,
              ),
              title: const Text(
                'حسابي',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              background: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      Theme.of(context).colorScheme.primary,
                      Theme.of(context).colorScheme.primaryContainer,
                    ],
                  ),
                ),
                child: SafeArea(
                  child: Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const SizedBox(height: 16),
                        Stack(
                          children: [
                            Hero(
                              tag: 'profile_image',
                              child: CircleAvatar(
                                radius: 45,
                                backgroundColor: Colors.white,
                                backgroundImage: photoPath != null
                                    ? FileImage(File(photoPath))
                                    : null,
                                child: photoPath == null
                                    ? Text(
                                        displayName.substring(0, 1),
                                        style: TextStyle(
                                          fontSize: 32,
                                          fontWeight: FontWeight.bold,
                                          color: Theme.of(context).colorScheme.primary,
                                        ),
                                      )
                                    : null,
                              ),
                            ),
                            if (_isUploadingImage)
                              Positioned.fill(
                                child: Container(
                                  decoration: BoxDecoration(
                                    color: Colors.black.withValues(alpha: 0.5),
                                    shape: BoxShape.circle,
                                  ),
                                  child: const Center(
                                    child: CircularProgressIndicator(
                                      color: Colors.white,
                                      strokeWidth: 2,
                                    ),
                                  ),
                                ),
                              ),
                          ],
                        ),
                        const SizedBox(height: 12),
                        Text(
                          displayName,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          email,
                          style: TextStyle(
                            color: Colors.white.withValues(alpha: 0.8),
                            fontSize: 14,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),

          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Profile Picture Actions
                  Center(
                    child: ElevatedButton.icon(
                      onPressed: _pickImage,
                      icon: const Icon(Icons.camera_alt),
                      label: const Text('تغيير الصورة'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Theme.of(context).colorScheme.primary,
                        foregroundColor: Colors.white,
                      ),
                    ),
                  ),

                  const SizedBox(height: 16),

                  // Profile Info Card
                  Card(
                    elevation: 2,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Text(
                                'معلومات الحساب',
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              IconButton(
                                icon: const Icon(Icons.edit),
                                onPressed: () {},
                                tooltip: 'تعديل',
                              ),
                            ],
                          ),
                          const SizedBox(height: 16),
                          _buildEditableProfileItem(
                            icon: Icons.person,
                            title: 'الاسم الكامل',
                            subtitle: displayName,
                            onEdit: () => _editProfileField('displayName', displayName),
                          ),
                          const Divider(),
                          _buildProfileItem(
                            icon: Icons.email,
                            title: 'البريد الإلكتروني',
                            subtitle: email,
                          ),
                          const Divider(),
                          _buildEditableProfileItem(
                            icon: Icons.phone,
                            title: 'رقم الهاتف',
                            subtitle: phoneNumber,
                            onEdit: () => _editProfileField('phoneNumber', phoneNumber),
                          ),
                        ],
                      ),
                    ),
                  ),

                  const SizedBox(height: 16),

                  // Settings Section
                  Card(
                    elevation: 2,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Column(
                      children: [
                        _buildSettingsSwitch(
                          icon: Icons.notifications,
                          title: 'الإشعارات',
                          subtitle: 'إعدادات التنبيهات',
                          value: _notificationsEnabled,
                          onChanged: (value) {
                            setState(() {
                              _notificationsEnabled = value;
                            });
                            _updateSettings();
                          },
                        ),
                        const Divider(height: 1),
                        _buildSettingsItem(
                          icon: Icons.language,
                          title: 'اللغة',
                          subtitle: _selectedLanguage == 'ar' ? 'العربية' : 
                                   _selectedLanguage == 'en' ? 'English' : 'Français',
                          onTap: _showLanguageDialog,
                        ),
                        const Divider(height: 1),
                        _buildSettingsSwitch(
                          icon: Icons.dark_mode,
                          title: 'المظهر الداكن',
                          subtitle: _darkModeEnabled ? 'مفعل' : 'غير مفعل',
                          value: _darkModeEnabled,
                          onChanged: (value) async {
                            setState(() {
                              _darkModeEnabled = value;
                            });
                            await _updateSettings();
                            
                            // Apply theme change immediately across the app
                            if (mounted) {
                              final themeService = Provider.of<ThemeService>(context, listen: false);
                              await themeService.toggleTheme(value);
                            }
                          },
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 16),

                  // Help Section
                  Card(
                    elevation: 2,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Column(
                      children: [
                        _buildSettingsItem(
                          icon: Icons.help_outline,
                          title: 'المساعدة',
                          subtitle: 'الأسئلة الشائعة',
                          onTap: _showHelpDialog,
                        ),
                        const Divider(height: 1),
                        _buildSettingsItem(
                          icon: Icons.info_outline,
                          title: 'عن التطبيق',
                          subtitle: 'معلومات عن SOT',
                          onTap: _showAboutDialog,
                        ),
                        const Divider(height: 1),
                        _buildSettingsItem(
                          icon: Icons.rate_review,
                          title: 'قيم التطبيق',
                          subtitle: 'شارك رأيك',
                          onTap: _showRatingDialog,
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 24),

                  // Logout Button
                  SizedBox(
                    width: double.infinity,
                    child: OutlinedButton.icon(
                      onPressed: () => _showLogoutDialog(context),
                      icon: const Icon(Icons.logout, color: Colors.red),
                      label: const Text(
                        'تسجيل الخروج',
                        style: TextStyle(color: Colors.red),
                      ),
                      style: OutlinedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        side: const BorderSide(color: Colors.red),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProfileItem({
    required IconData icon,
    required String title,
    required String subtitle,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          Icon(icon, color: Colors.grey[600]),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey[600],
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  subtitle,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEditableProfileItem({
    required IconData icon,
    required String title,
    required String subtitle,
    required VoidCallback onEdit,
  }) {
    return InkWell(
      onTap: onEdit,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8),
        child: Row(
          children: [
            Icon(icon, color: Colors.grey[600]),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey[600],
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    subtitle,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),
            Icon(
              Icons.edit,
              size: 16,
              color: Colors.grey[400],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSettingsItem({
    required IconData icon,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
  }) {
    return ListTile(
      leading: Icon(icon, color: Colors.grey[600]),
      title: Text(title),
      subtitle: Text(subtitle),
      trailing: const Icon(Icons.arrow_forward_ios, size: 16),
      onTap: onTap,
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
    );
  }

  Widget _buildSettingsSwitch({
    required IconData icon,
    required String title,
    required String subtitle,
    required bool value,
    required Function(bool) onChanged,
  }) {
    return ListTile(
      leading: Icon(icon, color: Colors.grey[600]),
      title: Text(title),
      subtitle: Text(subtitle),
      trailing: Switch(
        value: value,
        onChanged: onChanged,
      ),
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
    );
  }

  void _showLogoutDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('تسجيل الخروج'),
          content: const Text('هل أنت متأكد من أنك تريد تسجيل الخروج؟'),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('إلغاء'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop();
                _signOut(context);
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red,
                foregroundColor: Colors.white,
              ),
              child: const Text('تسجيل الخروج'),
            ),
          ],
        );
      },
    );
  }
}