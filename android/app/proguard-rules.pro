# Flutter / embedding
-keep class io.flutter.app.** { *; }
-keep class io.flutter.plugin.** { *; }
-keep class io.flutter.util.** { *; }
-keep class io.flutter.view.** { *; }
-keep class io.flutter.** { *; }
-keep class io.flutter.plugins.** { *; }

# Keep Flutter plugin implementations (see flutter_proguard_rules.pro)
-if class * implements io.flutter.embedding.engine.plugins.FlutterPlugin
-keep,allowshrinking,allowobfuscation class <1>

-dontwarn io.flutter.embedding.**
-dontwarn io.flutter.plugin.**
-dontwarn android.**
