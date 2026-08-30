pluginManagement {
    val flutterSdkPath = run {
        val properties = java.util.Properties()
        val localPropertiesFile = file("local.properties")
        if (localPropertiesFile.exists()) {
            properties.load(localPropertiesFile.inputStream())
        }
        val flutterSdkPath = properties.getProperty("flutter.sdk")
        assert(flutterSdkPath != null) { "flutter.sdk not set in local.properties" }
        flutterSdkPath
    }

    includeBuild("$flutterSdkPath/packages/flutter_tools/gradle")

    repositories {
        google()
        mavenCentral()
        gradlePluginPortal()
    }
}

plugins {
    id("dev.flutter.flutter-plugin-loader") version "1.0.0"
    id("com.android.application") version "9.0.1" apply false
    id("org.jetbrains.kotlin.android") version "2.3.20" apply false
}

dependencyResolutionManagement {
    repositoriesMode.set(RepositoriesMode.PREFER_SETTINGS)
    repositories {
        google()
        mavenCentral()
    }
}

include(":app")