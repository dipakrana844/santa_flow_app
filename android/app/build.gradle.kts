plugins {
    id("com.android.application")
    id("kotlin-android")
    // The Flutter Gradle Plugin must be applied after the Android and Kotlin Gradle plugins.
    id("dev.flutter.flutter-gradle-plugin")
}

android {
    namespace = "com.example.santa_flow_app"
    compileSdk = flutter.compileSdkVersion
    ndkVersion = flutter.ndkVersion

    compileOptions {
        sourceCompatibility = JavaVersion.VERSION_17
        targetCompatibility = JavaVersion.VERSION_17
    }

    kotlinOptions {
        jvmTarget = JavaVersion.VERSION_17.toString()
    }

    defaultConfig {
        // TODO: Specify your own unique Application ID (https://developer.android.com/studio/build/application-id.html).
        applicationId = "com.example.santa_flow_app"
        // You can update the following values to match your application needs.
        // For more information, see: https://flutter.dev/to/review-gradle-config.
        minSdk = flutter.minSdkVersion // Android 5.0 (Lollipop) - required for camera and modern features
        targetSdk = flutter.targetSdkVersion
        versionCode = flutter.versionCode
        versionName = flutter.versionName
    }

    buildTypes {
        release {
            // TODO: Add your own signing config for the release build.
            // Signing with the debug keys for now, so `flutter run --release` works.
            // For production, uncomment the following and configure signing:
            // signingConfig = signingConfigs.getByName("release")
            signingConfig = signingConfigs.getByName("debug")
            
            // Enable code shrinking, obfuscation, and optimization
            // isMinifyEnabled = true
            // isShrinkResources = true
            // proguardFiles(
            //     getDefaultProguardFile("proguard-android-optimize.txt"),
            //     "proguard-rules.pro"
            // )
        }
    }
    
    // Signing configs template (uncomment and configure for production)
    // signingConfigs {
    //     create("release") {
    //         storeFile = file("../key.properties")
    //         storePassword = System.getenv("KEYSTORE_PASSWORD")
    //         keyAlias = System.getenv("KEY_ALIAS")
    //         keyPassword = System.getenv("KEY_PASSWORD")
    //     }
    // }
}

dependencies {
    // Add Play Core library to fix R8 missing classes error
    // This is required even if not using deferred components, as Flutter embedding references it
    implementation("com.google.android.play:core:1.10.3")
}

flutter {
    source = "../.."
}
