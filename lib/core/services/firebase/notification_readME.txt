for using Firebase push notification you have to do......


-------------------------------------------- Setup process ------------------------------------------

1.  Configure firebase in your project

2.  add those dependencies in your project [pubspec.yaml] file
        firebase_core: ^4.0.0
        firebase_messaging: ^16.0.0
        flutter_local_notifications: ^19.4.0
        path_provider: ^2.1.5

3.  Go to [android/app/build.gradle.kts] file and add those lines

    [1] compileOptions {
            sourceCompatibility = JavaVersion.VERSION_11
            targetCompatibility = JavaVersion.VERSION_11
            isCoreLibraryDesugaringEnabled = true <-------------------------> add this line
        }

    [2] dependencies {
            implementation("org.jetbrains.kotlin:kotlin-stdlib-jdk8:1.9.24")

            // Core library desugaring - latest compatible version
            coreLibraryDesugaring("com.android.tools:desugar_jdk_libs:2.1.4")
        } ------------------> Add those lines bellow the android

    [3] (optional) ---> If {ndkVersion} and {minSdk} will create problems,
        then change the version according to the compatible versions......
           ______________________________________________
          |  namespace = "com.example.notification_test" |
          |  compileSdk = flutter.compileSdkVersion      |
          |  ndkVersion = "27.0.12077973" <--------------|-----------> add this line
           ----------------------------------------------

              defaultConfig {
                     applicationId = "com.example.notification_test"
                     minSdk = 23 <-------------------------> add this line
                     targetSdk = flutter.targetSdkVersion
                     versionCode = flutter.versionCode
                     versionName = flutter.versionName
                 }


4.  In your [main.dart] file add this one single line | make sure [main] function should be [async]

    // init function file path
    // [ lib/core/services/firebase/app_notification_initializer.dart ]

    void main() async {

      await AppNotificationInitializer.init(); <---------------------------> add this line at the top of [runApp]
      runApp(const CourseOnline());
    }

-------------------------------------------- End Setup process ------------------------------------------


***************************************************************************************************************


-------------------------------------------- Use of Functions --------------------------------------------------

1.  For [Local Notification] Use

    // file location
    [ lib/core/services/firebase/notification_service.dart ]

    () {
        AppHelperFunctions.sendLocalNotification(title: 'Your Title', body: 'Your Body'); ----------------> You can pass [payload] and [imageUrl] also. but they are optional
    }

-------------------------------------------- End Use of Functions --------------------------------------------------