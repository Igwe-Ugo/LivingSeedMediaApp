import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:iconsax/iconsax.dart';
import 'package:livingseed_media/screens/common/custom_bottomnav.dart';
import 'package:livingseed_media/screens/pages/accounts/accounts.dart';
import 'package:livingseed_media/screens/pages/admin/admin.dart';
import 'package:livingseed_media/screens/pages/auth/verify_account.dart';
import 'package:livingseed_media/screens/pages/notices/notices.dart';
import 'package:livingseed_media/screens/pages/home/home.dart';
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
  static final GlobalKey<NavigatorState> notificationTabNavigatorKey =
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
  static const String changePasswordPath = 'change_password';
  static const String profilePath = 'profile';
  static const String booksPurchasedPath = 'book_purchased';
  static const String readBookPath = 'read_book';
  static const String makePaymentPath = 'make_payment';
  static const String moreBooksPath = 'more_books';
  static const String moreBibleStudyPath = 'more_bible_study';
  static const String aboutBibleStudyPath = 'about_bible_study';
  static const String upcomingEventsPath = 'upcoming_events';
  static const String aboutMagazinePath = 'about_magazine';
  static const String moreMagazinePath = 'more_magazine';
  static const String viewUpcomingEventsPath = 'view_upcoming_events';

  // notification pages
  static const String notificationPath = '/notifications';
  static const String anouncementsPath = 'announcements';

  //admin pages
  static const String uploadBookPath = 'upload_book';
  static const String uploadBibleStudyPath = 'upload_bibilestudy';
  static const String dashboardPath = 'dashboard';
  static const String manageNotificationsPath = 'manage_notifications';
  static const String manageUsersPath = 'manage_users';
  static const String userProfilePath = 'user_profile';
  static const String addEventPath = 'add_event';

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
                      builder: (context, state) => const Home(),
                      routes: [
                        GoRoute(
                          path: moreBooksPath,
                          builder: (context, state) => const MoreBooks(),
                        ),
                        GoRoute(
                          path: moreBibleStudyPath,
                          builder: (context, state) => const MoreBibleStudy(),
                        ),
                        GoRoute(
                          path: moreMagazinePath,
                          builder: (context, state) => const MoreMagazine(),
                        ),
                        GoRoute(
                          path: aboutBibleStudyPath,
                          builder: (context, state) {
                            final about_biblestudy =
                                state.extra as BibleStudyMaterial?;
                            if (about_biblestudy != null) {
                              return AboutBibleStudy(
                                about_biblestudy: about_biblestudy,
                              );
                            } else {
                              return const Center(
                                  child: Text("No book data available"));
                            }
                          },
                        ),
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
                        GoRoute(
                          path: aboutMagazinePath,
                          builder: (context, state) {
                            final about_magazines =
                                state.extra as MagazineModel?;
                            if (about_magazines != null) {
                              return AboutMagazine(
                                magazine: about_magazines,
                              );
                            } else {
                              return const Center(
                                  child: Text("No book data available"));
                            }
                          },
                        ),
                      ]),
                ]),
            StatefulShellBranch(
                navigatorKey: notificationTabNavigatorKey,
                routes: <RouteBase>[
                  GoRoute(
                      path: notificationPath,
                      builder: (context, state) => Notifications(),
                      routes: [
                        GoRoute(
                          path: anouncementsPath,
                          builder: (context, state) {
                            final anouncement = state.extra;
                            if (anouncement is NotificationItems) {
                              return Announcements(
                                announcement: anouncement,
                              );
                            } else {
                              return Center(
                                child: Text(
                                    'No Recent Announcements to be reviewed'),
                              );
                            }
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
                                path: uploadBibleStudyPath,
                                builder: (context, state) =>
                                    const UploadBibleStudy(),
                              ),
                              GoRoute(
                                path: addEventPath,
                                builder: (context, state) =>
                                    const AdminAddEvent(),
                              ),
                              GoRoute(
                                  path: manageNotificationsPath,
                                  builder: (context, state) =>
                                      const AdminNotifications(),
                                  routes: [
                                    GoRoute(
                                      path: anouncementsPath,
                                      builder: (context, state) {
                                        final anouncement = state.extra;
                                        if (anouncement is NotificationItems) {
                                          return Announcements(
                                            announcement: anouncement,
                                          );
                                        } else {
                                          return Center(
                                            child: Text(
                                                'No Recent Announcements to be reviewed'),
                                          );
                                        }
                                      },
                                    ),
                                  ]),
                              GoRoute(
                                  path: manageUsersPath,
                                  builder: (context, state) =>
                                      const AdminUserManagement(),
                                  routes: [
                                    GoRoute(
                                      path: userProfilePath,
                                      builder: (context, state) {
                                        final user = state.extra;
                                        if (user is Users) {
                                          return UsersProfile(user: user);
                                        } else {
                                          return Center(
                                            child: Text(
                                                'User Profile not available'),
                                          );
                                        }
                                      },
                                    ),
                                  ]),
                            ]),
                        GoRoute(
                            path: upcomingEventsPath,
                            builder: (context, state) => const UpcomingEvents(),
                            routes: [
                              GoRoute(
                                  path: viewUpcomingEventsPath,
                                  builder: (context, state) {
                                    final upcomingEvents = state.extra;
                                    if (upcomingEvents is UpcomingEventsModel) {
                                      return ViewUpcomingEvents(
                                          upcomingEvents: upcomingEvents);
                                    } else {
                                      return Center(
                                        child:  Text('Upcoming event details cannot be displayed'),
                                      );
                                    }
                                  }),
                            ]),
                        GoRoute(
                            path: cartPath,
                            builder: (context, state) {
                              final user = state.extra;
                              if (user is Users) {
                                return Cart(
                                  user: user,
                                );
                              } else {
                                return Padding(
                                  padding: const EdgeInsets.symmetric(
                                      vertical: 25, horizontal: 10),
                                  child: Column(
                                    children: [
                                      Row(
                                        children: [
                                          IconButton(
                                              onPressed: () {
                                                GoRouter.of(context).pop();
                                              },
                                              icon: const Icon(
                                                Iconsax.arrow_left_2,
                                                size: 17,
                                              )),
                                          const SizedBox(
                                            width: 15,
                                          ),
                                          const Text(
                                            'My Cart',
                                            style: TextStyle(
                                              fontFamily: 'Playfair',
                                              fontSize: 20,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                        ],
                                      ),
                                      Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.center,
                                          children: const [
                                            SizedBox(
                                              height: 30,
                                            ),
                                            Icon(
                                              Icons.shopify_sharp,
                                              size: 100,
                                            ),
                                            SizedBox(
                                              height: 20,
                                            ),
                                            Text(
                                              'Nothing in Cart Session yet, please add book to cart',
                                              textAlign: TextAlign.center,
                                              style: TextStyle(
                                                  fontSize: 15,
                                                  fontWeight: FontWeight.bold),
                                            ),
                                          ]),
                                    ],
                                  ),
                                );
                              }
                            },
                            routes: [
                              GoRoute(
                                  path: makePaymentPath,
                                  builder: (context, state) {
                                    final book = state.extra;
                                    if (book is List<AboutBooks>) {
                                      return MakePayment(
                                        book: book,
                                      );
                                    } else {
                                      return Center(
                                        child: Text(
                                            'No book has been purchased yet'),
                                      );
                                    }
                                  }),
                            ]),
                        GoRoute(
                          path: editAccountPath,
                          builder: (context, state) => const Profile(),
                        ),
                        GoRoute(
                            path: booksPurchasedPath,
                            builder: (context, state) {
                              final user = state.extra;
                              if (user is Users) {
                                return BooksPurchased(
                                  user: user,
                                );
                              } else {
                                return Center(
                                  child: Text('No book purchased'),
                                );
                              }
                            },
                            routes: [
                              GoRoute(
                                path: readBookPath,
                                builder: (context, state) {
                                  final readBook = state.extra;
                                  if (readBook is String) {
                                    return const ReadBookPage(
                                      readBookPath: readBookPath,
                                    );
                                  } else {
                                    return Center(
                                      child: Text('Book not found'),
                                    );
                                  }
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
