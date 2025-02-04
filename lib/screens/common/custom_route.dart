import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:livingseed_media/screens/common/custom_bottomnav.dart';
import 'package:livingseed_media/screens/pages/accounts/accounts.dart';
import 'package:livingseed_media/screens/pages/accounts/downloads.dart';
import 'package:livingseed_media/screens/pages/admin/admin.dart';
import 'package:livingseed_media/screens/pages/auth/verify_account.dart';
import 'package:livingseed_media/screens/pages/messages/library.dart';
import 'package:livingseed_media/screens/pages/publications/publications.dart';
import '../models/models.dart';
import '../pages/auth/auth.dart';
import '../pages/widget.dart';

class LivingSeedAppRouter {
  static final LivingSeedAppRouter _instance = LivingSeedAppRouter._internal();
  static LivingSeedAppRouter get instance => _instance;
  static late final GoRouter router;
  static final GlobalKey<NavigatorState> parentNavigatorKey =
      GlobalKey<NavigatorState>();
  static final GlobalKey<NavigatorState> homeTabNavigatorKey =
      GlobalKey<NavigatorState>();
  static final GlobalKey<NavigatorState> booksTabNavigationKey =
      GlobalKey<NavigatorState>();
  static final GlobalKey<NavigatorState> messagesTabNavigationKey =
      GlobalKey<NavigatorState>();
  static final GlobalKey<NavigatorState> accountTabNavigationKey =
      GlobalKey<NavigatorState>();
  BuildContext get context =>
      router.routerDelegate.navigatorKey.currentContext!;
  GoRouterDelegate get routerDelegate => router.routerDelegate;
  GoRouteInformationParser get routeInformationParser =>
      router.routeInformationParser;

  factory LivingSeedAppRouter() {
    return _instance;
  }

  static const String homePath = '/home';
  static const String publicationsPath = '/books';
  static const String messagesPath = '/messages';
  static const String accountPath = '/account';
  static const String aboutBookPath = 'about_book';
  static const String cartPath = 'cart';
  static const String editAccountPath = 'editAccount';
  static const String loginPath = '/login';
  static const String signUpPath = '/signup';
  static const String verifyAccountPath = '/verify_account';
  static const String forgotPasswordPath = '/forgot_password';
  static const String forgotPasswordOtpPath = '/forgot_password_otp';
  static const String reviewsPath = 'reviews';
  static const String writeReviewPath = 'write_review';
  static const String videoMessagesPath = 'video_messages';
  static const String audioScreenPath = 'audio_screen';
  static const String changePasswordPath = 'change_password';
  static const String notificationPath = 'notifications';
  static const String profilePath = 'profile';
  static const String downloadsPath = 'downloads';
  static const String booksPurchasedPath = 'book_purchased';
  static const String readBookPath = 'read_book';

  //admin pages
  static const String uploadBookPath = 'upload_book_path';
  static const String dashboardPath = 'dashboard';
  static const String manageNotificationsPath = 'manage_notifications';
  static const String manageUsersPath = 'manage_users';

  LivingSeedAppRouter._internal() {
    final routes = <RouteBase>[
      GoRoute(
        path: loginPath,
        builder: (context, state) => const LivingSeedSignIn(),
      ),
      GoRoute(
        path: signUpPath,
        builder: (context, state) => const LivingSeedSignUp(),
      ),
      GoRoute(
        path: forgotPasswordPath,
        builder: (context, state) => const LivingSeedResetForgottenPassword(),
      ),
      GoRoute(
        path: forgotPasswordOtpPath,
        builder: (context, state) => const ForgotPasswordOTP(),
      ),
      GoRoute(
        path: verifyAccountPath,
        builder: (context, state) => const VerifyAccount(),
      ),
      StatefulShellRoute.indexedStack(
          parentNavigatorKey: parentNavigatorKey,
          builder: (context, state, navigationShell) {
            return LivingSeedNavBar(navigationShell: navigationShell);
          },
          branches: <StatefulShellBranch>[
            StatefulShellBranch(
                navigatorKey: homeTabNavigatorKey,
                routes: <RouteBase>[
                  GoRoute(
                      path: homePath,
                      builder: (context, state) {
                        final user = state.extra as Users;
                        return user != null
                            ? HomePage(
                                user: user,
                              )
                            : const LivingSeedSignUp();
                      },
                      routes: [
                        GoRoute(
                            path: notificationPath,
                            builder: (context, state) => const Notifications()),
                        GoRoute(
                          path: aboutBookPath,
                          builder: (context, state) {
                            final about_books = state.extra as AboutBooks;
                            return AboutBook(
                              about_books: about_books,
                            );
                          },
                        )
                      ]),
                ]),
            StatefulShellBranch(
                navigatorKey: booksTabNavigationKey,
                routes: <RouteBase>[
                  GoRoute(
                      path: publicationsPath,
                      builder: (context, state) => const PublicationsPage(),
                      routes: [
                        GoRoute(
                            path: notificationPath,
                            builder: (context, state) => const Notifications()),
                        GoRoute(
                            path: aboutBookPath,
                            builder: (context, state) {
                              final about_books = state.extra as AboutBooks?;
                              if (about_books != null) {
                                return AboutBook(
                                  about_books: about_books,
                                );
                              } else {
                                return const Center(
                                    child: Text("No book data available"));
                              }
                            },
                            routes: [
                              GoRoute(
                                  path: reviewsPath,
                                  builder: (context, state) {
                                    final about_books =
                                        state.extra as AboutBooks?;
                                    if (about_books != null) {
                                      return Reviews(
                                        about_books: about_books,
                                      );
                                    } else {
                                      return const Center(
                                          child:
                                              Text("No book data available"));
                                    }
                                  },
                                  routes: [
                                    GoRoute(
                                      path: writeReviewPath,
                                      builder: (context, state) =>
                                          const WriteReview(),
                                    ),
                                  ]),
                            ]),
                      ]),
                ]),
            StatefulShellBranch(
                navigatorKey: messagesTabNavigationKey,
                routes: <RouteBase>[
                  GoRoute(
                      path: messagesPath,
                      builder: (context, state) => const MessagesPage(),
                      routes: [
                        GoRoute(
                            path: notificationPath,
                            builder: (context, state) => const Notifications()),
                        GoRoute(
                            path: videoMessagesPath,
                            builder: (context, state) => const VideoMessages()),
                        GoRoute(
                          path: audioScreenPath,
                          builder: (context, state) {
                            final audioSongs = state.extra as AudioMessage;
                            return AudioScreen(
                              audioSongs: audioSongs,
                            );
                          },
                        ),
                      ]),
                ]),
            StatefulShellBranch(
                navigatorKey: accountTabNavigationKey,
                routes: <RouteBase>[
                  GoRoute(
                      path: accountPath,
                      builder: (context, state) => const AccountPage(),
                      routes: [
                        // admin panel
                        GoRoute(
                            path: dashboardPath,
                            builder: (context, state) => const AdminDashboard(),
                            routes: [
                              GoRoute(
                                path: uploadBookPath,
                                builder: (context, state) =>
                                    const UploadBookScreen(),
                              ),
                              GoRoute(
                                path: manageNotificationsPath,
                                builder: (context, state) =>
                                    const AdminNotifications(),
                              ),
                              GoRoute(
                                path: manageUsersPath,
                                builder: (context, state) =>
                                    const AdminUserManagement(),
                              ),
                            ]),
                        GoRoute(
                            path: notificationPath,
                            builder: (context, state) => const Notifications()),
                        GoRoute(
                          path: cartPath,
                          builder: (context, state) {
                            final user = state.extra as Users;
                            return Cart(
                              user: user,
                            );
                          },
                        ),
                        GoRoute(
                          path: editAccountPath,
                          builder: (context, state) => const Profile(),
                        ),
                        GoRoute(
                          path: downloadsPath,
                          builder: (context, state) {
                            final user = state.extra as Users;
                            return Downloads(user: user,);
                          },
                        ),
                        GoRoute(
                            path: booksPurchasedPath,
                            builder: (context, state) {
                              final user = state.extra as Users;
                              return BooksPurchased(
                                user: user,
                              );
                            },
                            routes: [
                              GoRoute(
                                path: readBookPath,
                                builder: (context, state) {
                                  /* final data = state.extra as Map<String, dynamic>;
                                  final String readBookPath = data['readBookPath']; */
                                  return const ReadBookPage();
                                },
                              ),
                            ]),
                        GoRoute(
                          path: changePasswordPath,
                          builder: (context, state) => const ChangePassword(),
                        ),
                        GoRoute(
                          path: profilePath,
                          builder: (context, state) => const Profile(),
                        )
                      ]),
                ]),
          ])
    ];

    router = GoRouter(
      navigatorKey: parentNavigatorKey,
      initialLocation: loginPath,
      routes: routes,
    );
  }
}
