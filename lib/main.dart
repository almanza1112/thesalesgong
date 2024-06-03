import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:thesalesgong/auth_service.dart';
import 'package:thesalesgong/home_page.dart';
import 'package:thesalesgong/login/admin_signup/add_team_members_page.dart';
import 'package:thesalesgong/login/admin_signup/add_team_name_page.dart';
import 'package:thesalesgong/login/admin_signup/admin_payment_page.dart';
import 'package:thesalesgong/login/admin_signup/admin_signup_page.dart';
import 'package:thesalesgong/login/login_page.dart';
import 'package:thesalesgong/login/opening_page.dart';
import 'package:thesalesgong/login/signup_page.dart';
import 'package:thesalesgong/login/team_member_signup_page.dart';
import 'package:thesalesgong/menu/custom_alerts_times_pages.dart';
import 'package:thesalesgong/menu/delete_account_page.dart';
import 'package:thesalesgong/menu/email_page.dart';
import 'package:thesalesgong/menu/name_page.dart';
import 'package:thesalesgong/menu/notifications_settings_page.dart';
import 'package:thesalesgong/menu/password_page.dart';
import 'package:thesalesgong/menu/subscription/change_subscription_page.dart';
import 'package:thesalesgong/menu/subscription/subscription_page.dart';
import 'package:thesalesgong/menu/support_page.dart';
import 'package:thesalesgong/menu/team/edit_team_name_page.dart';
import 'package:thesalesgong/menu/team/team_settings_page.dart';
import 'package:thesalesgong/notifications_page.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:thesalesgong/services/notification_controller.dart';
import 'firebase_options.dart';

@pragma('vm:entry-point')
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
//   // If you're going to use other Firebase services in the background, such as Firestore,
//   // make sure you call `initializeApp` before using other Firebase services.
//   //await Firebase.initializeApp();

// //   AwesomeNotifications().createNotification(
// //   content: NotificationContent(
// //       id: 10,
// //       channelKey: 'basic_channel',
// //       actionType: ActionType.Default,
// //       title: message.notification!.title,
// //       body: message.notification!.body,
// //   )
// // );
}
void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

  await AwesomeNotifications().initialize(
    null,
    [
      NotificationChannel(
        channelGroupKey: 'basic_channel_group',
        channelKey: 'basic_channel1',
        channelName: 'Basic Notifications',
        channelDescription: 'Basic notifications channel',
        defaultColor: const Color(0xFF9D50DD),
        ledColor: Colors.white,
        playSound: true,
        soundSource: 'resource://raw/gong1',
      ),
      NotificationChannel(
        channelGroupKey: 'basic_channel_group',
        channelKey: 'basic_channel2',
        channelName: 'Basic Notifications',
        channelDescription: 'Basic notifications channel',
        defaultColor: const Color(0xFF9D50DD),
        ledColor: Colors.white,
        playSound: true,
        soundSource: 'resource://raw/gong2',
      ),
      NotificationChannel(
        channelGroupKey: 'basic_channel_group',
        channelKey: 'basic_channel3',
        channelName: 'Basic Notifications',
        channelDescription: 'Basic notifications channel',
        defaultColor: const Color(0xFF9D50DD),
        ledColor: Colors.white,
        playSound: true,
        soundSource: 'resource://raw/gong3',
      ),
    ],
    channelGroups: [
      NotificationChannelGroup(
          channelGroupKey: 'basic_channel_group',
          channelGroupName: 'Basic Channel Group')
    ],
  );

  bool isNotificationAllowed =
      await AwesomeNotifications().isNotificationAllowed();
  if (!isNotificationAllowed) {
    if (FirebaseAuth.instance.currentUser != null) {
      await AwesomeNotifications().requestPermissionToSendNotifications();
    }
  }

  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  void initState() {
    // AwesomeNotifications().setListeners(
    //     onActionReceivedMethod: NotificationController.onActionReceivedMethod,
    //     onDismissActionReceivedMethod:
    //         NotificationController.onDismissActionReceivedMethod,
    //     onNotificationCreatedMethod:
    //         NotificationController.onNotificationCreatedMethod,
    //     onNotificationDisplayedMethod:
    //         NotificationController.onNotificationDisplayedMethod);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'The Sales Gong',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(useMaterial3: true),
      home: AuthService().handleAuthStateNew(),
      routes: {
        '/opening': (context) => const OpeningPage(),
        '/login': (context) => const LoginPage(),
        '/signup': (context) => const SignupPage(),
        '/admin_signup': (context) => const AdminSignupPage(),
        '/team_member_signup': (context) => const TeamMemberSignupPage(),
        '/add_team_name': (context) => const AddTeamNamePage(),
        '/add_team_members': (context) => const AddTeamMembersPage(),
        '/admin_payment': (context) => const AdminPaymentPage(),
        '/home': (context) => const HomePage(),
        '/notifications': (context) => const NotificationsPage(),
        '/team': (context) => const TeamPage(),
        '/notifications_settings': (context) =>
            const NotificationSettingsPage(),
        '/custom_alert_times': (context) => const CustomAlertTimesPage(),
        '/email': (context) => const EmailPage(),
        '/password': (context) => const PasswordPage(),
        '/name': (context) => const NamePage(),
        '/support': (context) => const SupportPage(),
        '/subscription': (context) => const SubscriptionPage(),
        '/delete_account': (context) => const DeleteAccountPage(),
        '/edit_team_name': (context) => const EditTeamNamePage(),
        '/change_subscription': (context) => const ChangeSubscriptionPage(),
      },
    );
  }
}
