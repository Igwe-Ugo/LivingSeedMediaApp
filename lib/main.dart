import 'package:flutter/material.dart';
import 'package:livingseed_media/screens/pages/services/services.dart';
import 'screens/common/widget.dart';
import 'package:provider/provider.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  LivingSeedAppRouter.instance;
  //await Firebase.initializeApp();
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => DarkThemeProvider()),
        ChangeNotifierProvider(
            create: (_) => UsersAuthProvider()..initializeUsers()),
        ChangeNotifierProvider(
            create: (_) => NotificationProvider()..loadNotifications()),
        ChangeNotifierProvider(
            create: (_) => AboutBookProvider()..initializeBooks()),
        ChangeNotifierProvider(
            create: (_) => BibleStudyProvider()..initializeBibleStudy()),
      ],
      child:
          const LivingSeedApp(), // Ensure LivingSeedApp is inside MultiProvider
    ),
  );
}

class LivingSeedApp extends StatefulWidget {
  const LivingSeedApp({super.key});

  @override
  State<LivingSeedApp> createState() => _LivingSeedAppState();
}

class _LivingSeedAppState extends State<LivingSeedApp> {
  late DarkThemeProvider themeChangeProvider;

  @override
  void initState() {
    super.initState();
    themeChangeProvider =
        Provider.of<DarkThemeProvider>(context, listen: false);
    getCurrentAppTheme();
  }

  void getCurrentAppTheme() async {
    themeChangeProvider.darkTheme =
        await themeChangeProvider.livingSeedPreference.getTheme();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<DarkThemeProvider>(
      builder: (context, themeData, child) {
        return MaterialApp.router(
          debugShowCheckedModeBanner: false,
          title: 'Living Seed Media',
          theme: Styles.themeData(themeChangeProvider.darkTheme, context),
          routerConfig: LivingSeedAppRouter.router,
        );
      },
    );
  }
}
