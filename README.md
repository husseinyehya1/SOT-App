# فريق التنظيم الطلابي - SOT MOE
# Student Organization Team Mobile Application

تطبيق موبايل متطور مخصص لفريق التنظيم الطلابي (SOT) يوفر خدمات متقدمة للطلاب والمسؤولين.

---

## 📋 وصف المشروع | Project Description

تطبيق **Flutter** احترافي يدعم:
- ✅ المصادقة الآمنة (Firebase Auth)
- ✅ إدارة الحسابات والملفات الشخصية
- ✅ لوحة تحكم شاملة
- ✅ إدارة الفعاليات والأحداث
- ✅ إدارة فريق الطلاب
- ✅ التخزين السحابي (Firebase Storage)
- ✅ قاعدة بيانات في الوقت الفعلي (Firestore)

---

## 🛠️ المتطلبات والتكنولوجيات | Requirements & Technologies

### متطلبات النظام:
- **Flutter SDK**: ^3.10.0
- **Dart**: ^3.10.0
- **Minimum Android API**: 21
- **Minimum iOS**: 11.0

### المكتبات الرئيسية | Main Dependencies:

#### Firebase:
- `firebase_core: ^3.8.1` - Core Firebase services
- `firebase_auth: ^5.3.4` - User authentication
- `cloud_firestore: ^5.4.5` - Cloud database
- `firebase_storage: ^12.3.7` - Cloud storage

#### Authentication:
- `google_sign_in: ^6.2.1` - Google authentication

#### UI & State Management:
- `provider: ^6.1.2` - State management
- `cached_network_image: ^3.4.1` - Image caching
- `cupertino_icons: ^1.0.8` - iOS style icons

#### Storage & Utilities:
- `shared_preferences: ^2.3.3` - Local preferences
- `path_provider: ^2.1.5` - File system paths
- `image_picker: ^1.1.2` - Image selection

---

## 📁 هيكل المشروع | Project Structure

```
lib/
├── main.dart                          # نقطة الدخول الرئيسية
├── firebase_options.dart              # إعدادات Firebase
│
├── login_page.dart                    # صفحة تسجيل الدخول
├── register_page.dart                 # صفحة التسجيل
├── forgot_password_page.dart          # صفحة استرجاع كلمة المرور
├── phone_verification_page.dart       # صفحة التحقق من الهاتف
│
├── pages/
│   ├── main_app_page.dart            # الصفحة الرئيسية
│   ├── dashboard_page.dart           # لوحة التحكم
│   ├── team_page.dart                # صفحة الفريق
│   ├── events_page.dart              # صفحة الفعاليات
│   ├── profile_page.dart             # صفحة الملف الشخصي
│   └── home_page.dart                # الصفحة الرئيسية البديلة
│
├── services/
│   ├── firebase_options.dart         # خيارات Firebase
│   ├── theme_service.dart            # خدمة المظهر (Dark/Light)
│   ├── phone_auth_service.dart       # خدمة المصادقة بالهاتف
│   ├── google_auth_service.dart      # خدمة Google Sign-In
│   ├── user_profile_service.dart     # خدمة ملف المستخدم
│   ├── local_user_profile_service.dart # تخزين الملف محلياً
│   ├── local_storage_service.dart    # خدمة التخزين المحلي
│   └── database_initializer.dart     # تهيئة قاعدة البيانات
│
├── widgets/
│   └── bottom_navigation.dart        # شريط التنقل السفلي
│
└── assets/
    └── team_images/                  # صور الفريق

android/          # ملفات Android
ios/              # ملفات iOS
windows/          # ملفات Windows
linux/            # ملفات Linux
macos/            # ملفات macOS
web/              # ملفات Web
```

---

## 🚀 البدء السريع | Quick Start

### 1️⃣ التثبيت والإعداد
```bash
# استنساخ المشروع
git clone <repository-url>
cd sot_moe

# تثبيت المكتبات
flutter pub get

# الحصول على إعدادات Firebase
# تأكد من وجود firebase_options.dart بالإعدادات الصحيحة
```

### 2️⃣ تشغيل التطبيق
```bash
# الجهاز الافتراضي
flutter run

# جهاز معين
flutter run -d <device-id>

# Web
flutter run -d chrome
```

### 3️⃣ البناء (Build)
```bash
# Android
flutter build apk
flutter build appbundle

# iOS
flutter build ios

# Web
flutter build web
```

---

## 🔐 الميزات الأمنية | Security Features

- ✅ **Firebase Authentication**: مصادقة آمنة باستخدام Firebase
- ✅ **Google Sign-In**: تسجيل دخول آمن عبر Google
- ✅ **Phone Verification**: التحقق من رقم الهاتف
- ✅ **Firestore Security Rules**: قواعد أمان قاعدة البيانات
- ✅ **Storage Rules**: قواعد التحكم في التخزين
- ✅ **Local Encryption**: تشفير البيانات المحلية

---

## 📱 الصفحات الرئيسية | Main Pages

| الصفحة | الوصف |
|-------|--------|
| **Login** | تسجيل الدخول بالبريد/الهاتف/Google |
| **Register** | إنشاء حساب جديد |
| **Phone Verification** | التحقق من رقم الهاتف |
| **Dashboard** | لوحة تحكم رئيسية |
| **Team** | معلومات الفريق والأعضاء |
| **Events** | الفعاليات والأحداث |
| **Profile** | ملف المستخدم الشخصي |

---

## 🎨 المظهر | Theming

التطبيق يدعم **Dark Mode و Light Mode** من خلال:
- `ThemeService`: خدمة متقدمة للتحكم بالمظهر
- `Provider`: لإدارة حالة المظهر عبر التطبيق

---

## 🗄️ قاعدة البيانات | Database

### Firebase Firestore Collections:
- **users**: بيانات المستخدمين
- **teams**: معلومات الفريق
- **events**: الفعاليات
- **profiles**: الملفات الشخصية المتقدمة

### Firebase Storage:
- **team_images**: صور الفريق
- **user_profiles**: صور الملفات الشخصية

---

## 📦 الإصدار | Version

- **Current Version**: 1.0.0+1
- **Status**: Development/Production Ready

---

## 👥 المساهمون | Contributors

تطوير فريق التنظيم الطلابي (SOT MOE)

---

## 📄 الترخيص | License

هذا المشروع مخصص لفريق التنظيم الطلابي وليس للاستخدام العام.

---

## 🔗 موارد مفيدة | Useful Resources

- [Flutter Documentation](https://docs.flutter.dev/)
- [Firebase Documentation](https://firebase.google.com/docs)
- [Dart Language Guide](https://dart.dev/guides)
- [Material Design](https://material.io/design)

---

## ⚙️ الإعدادات الإضافية | Additional Configuration

### Firebase Setup:
1. أنشئ مشروع Firebase
2. أضف Android و iOS
3. حمّل ملفات `google-services.json` و `GoogleService-Info.plist`
4. قم بتوليد `firebase_options.dart`

### Firestore Rules:
تم تكوين قواعد الأمان في `firestore.rules`

### Storage Rules:
تم تكوين قواعل التخزين في `storage.rules`

---

## 🐛 استكشاف الأخطاء | Troubleshooting

```bash
# تنظيف البيانات المخزنة مؤقتاً
flutter clean

# الحصول على جميع التبعيات من جديد
flutter pub get

# تحليل الكود
flutter analyze

# تنسيق الكود
dart format .
```

---

**تم تحديث الملف بنجاح! ✅**
