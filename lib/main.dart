import 'package:flutter/material.dart';
import 'package:livingseed_media/screens/pages/services/services.dart';
import 'screens/common/widget.dart';
import 'package:provider/provider.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  LivingSeedAppRouter.instance;
  runApp(const LivingSeedApp());
}

class LivingSeedApp extends StatefulWidget {
  const LivingSeedApp({super.key});

  @override
  State<LivingSeedApp> createState() => _LivingSeedAppState();
}

class _LivingSeedAppState extends State<LivingSeedApp> {
  late DarkThemeProvider themeChangeProvider;
  late UsersAuthProvider usersAuthProvider;
  late NotificationProvider notificationProvider;
  late AboutBookProvider aboutBookProvider;
  late BibleStudyProvider bibleStudyProvider;
  late AddEventProvider addEventProvider;
  late MagazineProvider magazineProvider;

  @override
  void initState() {
    super.initState();

    themeChangeProvider = DarkThemeProvider();
    usersAuthProvider = UsersAuthProvider();
    notificationProvider = NotificationProvider();
    aboutBookProvider = AboutBookProvider();
    bibleStudyProvider = BibleStudyProvider();
    addEventProvider = AddEventProvider();
    magazineProvider = MagazineProvider();

    // Load necessary data AFTER the first frame to avoid context-related issues
    WidgetsBinding.instance.addPostFrameCallback((_) {
      usersAuthProvider.initializeUsers();
      notificationProvider.initializeNotifications();
      aboutBookProvider.initializeBooks();
      bibleStudyProvider.initializeBibleStudy();
      addEventProvider.initializeEvents();
      magazineProvider.initializeMagazines();
    });

    getCurrentAppTheme();
  }

  void getCurrentAppTheme() async {
    themeChangeProvider.darkTheme =
        await themeChangeProvider.livingSeedPreference.getTheme();
  }

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => themeChangeProvider),
        ChangeNotifierProvider(create: (_) => usersAuthProvider),
        ChangeNotifierProvider(create: (_) => notificationProvider),
        ChangeNotifierProvider(create: (_) => aboutBookProvider),
        ChangeNotifierProvider(create: (_) => bibleStudyProvider),
        ChangeNotifierProvider(create: (_) => addEventProvider),
        ChangeNotifierProvider(create: (_) => magazineProvider),
      ],
      child: Consumer<DarkThemeProvider>(
        builder: (context, themeData, child) {
          return MaterialApp.router(
            debugShowCheckedModeBanner: false,
            title: 'Living Seed Media',
            theme: Styles.themeData(themeChangeProvider.darkTheme, context),
            routerConfig: LivingSeedAppRouter.router,
          );
        },
      ),
    );
  }
}
