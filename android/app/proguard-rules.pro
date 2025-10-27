# Google Play Core classes
-keep class com.google.android.play.core.** { *; }
-dontwarn com.google.android.play.core.**

# Flutter Secure Storage
-keep class com.it_nomads.fluttersecurestorage.** { *; }

# Security - Obfuscate but keep functionality
-keepclassmembers class * {
    @com.google.gson.annotations.SerializedName <fields>;
}

# Prevent token logging
-assumenosideeffects class android.util.Log {
    public static *** d(...);
    public static *** v(...);
    public static *** i(...);
}

# Keep Flutter Secure Storage native methods
-keep class com.it_nomads.fluttersecurestorage.FlutterSecureStoragePlugin { *; }
-keep class com.it_nomads.fluttersecurestorage.FlutterSecureStoragePlugin$* { *; }

# Keep Android Keystore related classes
-keep class android.security.keystore.** { *; }
-keep class javax.crypto.** { *; }

# Prevent reflection on security classes
-keepattributes Signature
-keepattributes *Annotation*

# Obfuscate but keep JWT parsing functionality
-keep class * implements java.io.Serializable { *; }

# Keep essential Flutter classes
-keep class io.flutter.app.** { *; }
-keep class io.flutter.plugin.** { *; }
-keep class io.flutter.util.** { *; }
-keep class io.flutter.view.** { *; }
-keep class io.flutter.** { *; }
-keep class io.flutter.plugins.** { *; }

# Keep native methods
-keepclasseswithmembernames class * {
    native <methods>;
}

# Keep enum classes
-keepclassmembers enum * {
    public static **[] values();
    public static ** valueOf(java.lang.String);
}

# Keep Parcelable classes
-keep class * implements android.os.Parcelable {
    public static final android.os.Parcelable$Creator *;
}

# Remove debug information
-renamesourcefileattribute SourceFile
-keepattributes SourceFile,LineNumberTable
