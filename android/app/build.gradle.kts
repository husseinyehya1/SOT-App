plugins {
    id("com.android.application")
    id("com.google.gms.google-services")
    id("kotlin-android")
    id("dev.flutter.flutter-gradle-plugin")
}

import java.util.Properties
import java.io.FileInputStream

// Load keystore properties
val keystoreProperties = Properties()
val keystorePropertiesFile = rootProject.file("key.properties")

if (keystorePropertiesFile.exists()) {
    keystoreProperties.load(FileInputStream(keystorePropertiesFile))
    println("✅ key.properties loaded successfully.")
} else {
    println("⚠️ WARNING: key.properties file not found — Release signing will fail.")
}

android {
    namespace = "com.example.sot_moe"
    compileSdk = flutter.compileSdkVersion
    ndkVersion = flutter.ndkVersion

    defaultConfig {
        applicationId = "com.the_sot.earth"
        minSdk = flutter.minSdkVersion
        targetSdk = flutter.targetSdkVersion
        versionCode = flutter.versionCode
        versionName = flutter.versionName
    }

    compileOptions {
        sourceCompatibility = JavaVersion.VERSION_17
        targetCompatibility = JavaVersion.VERSION_17
    }

    kotlinOptions {
        jvmTarget = "17"
    }

    signingConfigs {
        create("release") {
            val alias = keystoreProperties.getProperty("keyAlias")
            val keyPass = keystoreProperties.getProperty("keyPassword")
            val storePass = keystoreProperties.getProperty("storePassword")
            val storeFilePath = keystoreProperties.getProperty("storeFile")

            if (!alias.isNullOrBlank() && !keyPass.isNullOrBlank() && 
                !storePass.isNullOrBlank() && !storeFilePath.isNullOrBlank()) {
                keyAlias = alias
                keyPassword = keyPass
                storePassword = storePass
                storeFile = file(storeFilePath)
                println("✅ Release signingConfig configured.")
            } else {
                println("⚠️ WARNING: Missing keystore properties — Release signing disabled.")
            }
        }
    }

    buildTypes {
        getByName("release") {
            signingConfig = signingConfigs.getByName("release")
            isMinifyEnabled = false
            isShrinkResources = false
        }
        getByName("debug") {
            signingConfig = signingConfigs.getByName("release")
        }
    }
}

flutter {
    source = "../.."
}
