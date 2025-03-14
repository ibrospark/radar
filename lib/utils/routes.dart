// -----------------------------------------------
import 'package:get/get.dart';
import 'package:get/get_navigation/src/routes/get_route.dart';
import 'package:radar/main.dart';
import 'package:radar/screens/activity_zone/activity_zone_list_screen.dart';
import 'package:radar/screens/chat/chat_list_screen.dart';
import 'package:radar/screens/users/verification_otp_screen.dart';
import 'package:radar/screens/houses/add_house_screen.dart';
import 'package:radar/screens/maps/main_maps_screen.dart';
import 'package:radar/screens/maps/search_place_screen.dart';
import 'package:radar/screens/notifications/notifications_screen.dart';
import 'package:radar/screens/offer/offer_add_screen.dart';
import 'package:radar/screens/offer/offer_list_screen.dart';
import 'package:radar/screens/offer/subscription_offer_screen.dart';
import 'package:radar/screens/users/settings_screen.dart';
import 'package:radar/screens/users/user_complete_registration_screen.dart';
import 'package:radar/screens/users/user_settings_screen.dart';

class Routes {
  // Main
  static const String home = '/';
  // Auth & User
  static const String login = '/login';
  static const String verificationOtp = '/verification-otp';
  static const String settings = '/settings';
  static const String userSettings = '/user-settings';
  static const String userCompleteRegistration = '/user-complete-registration';

  // Map
  static const String mainMap = '/main-map';
  static const String searchPlace = '/search-place';

// House
  static const String addHouse = '/add-house';
  // Plans & offers
  static const String planSubscription = '/plan-subscription';
  static const String offers = '/offers';
  static const String addOffer = '/add-Offer';
  static const String offerSubscription = '/offer-subscription';
  // Notifications
  static const String notifications = '/notifications';
  // Chat
  static const String discussionList = '/discussion-list';
  static const String ChatListScreen = '/chat-list';
  // Activity Zone
  static const String activityZoneScreen = '/activity-zone';
}

List<GetPage<dynamic>> routesList = [
  // Main----------------------------
  GetPage(
    name: Routes.home,
    page: () => const MyApp(),
  ),
  // Auth & User----------------------------
  GetPage(
    name: Routes.verificationOtp,
    page: () => const VerificationOtpScreen(),
  ),
  GetPage(
    name: Routes.settings,
    page: () => const SettingsScreen(),
  ),
  GetPage(
    name: Routes.userSettings,
    page: () => const UserSettingsScreen(),
  ),
  GetPage(
    name: Routes.userCompleteRegistration,
    page: () => const UserCompleteRegistrationScreen(),
  ),
  // Map----------------------------
  GetPage(
    name: Routes.mainMap,
    page: () => const MainMapsScreen(),
  ),
  GetPage(
    name: Routes.searchPlace,
    page: () => const SearchPlaceScreen(),
  ),
  // House----------------------------
  GetPage(
    name: Routes.addHouse,
    page: () => const AddHouseScreen(),
  ),
  //Plan subscription & offers----------------------------

  GetPage(
    name: Routes.offers,
    page: () => const OfferListScreen(),
  ),
  GetPage(
    name: Routes.addOffer,
    page: () => OfferAddScreen(),
  ),
  GetPage(
    name: Routes.offerSubscription,
    page: () => const OfferSubscriptionListScreen(),
  ),
  // Notifications----------------------------
  GetPage(
    name: Routes.notifications,
    page: () => NotificationScreen(),
  ),
  // Chat----------------------------

  GetPage(
    name: Routes.ChatListScreen,
    page: () => ChatListScreen(),
  ),
  // Activity Zone----------------------------
  GetPage(
    name: Routes.activityZoneScreen,
    page: () => const ActivityZoneListScreen(),
  ),
];
