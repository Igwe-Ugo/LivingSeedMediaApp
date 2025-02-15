import 'package:flutter/material.dart';
import 'package:livingseed_media/screens/pages/services/services.dart';
import 'screens/common/widget.dart';
import 'package:provider/provider.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  LivingSeedAppRouter.instance;
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => DarkThemeProvider()),
        ChangeNotifierProvider(create: (_) => UsersAuthProvider()),
        ChangeNotifierProvider(create: (_) => NotificationProvider()),
        ChangeNotifierProvider(create: (_) => AboutBookProvider()),
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

    // Load initial data after the first frame
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<NotificationProvider>(context, listen: false)
          .loadNotifications();
      Provider.of<AboutBookProvider>(context, listen: false).initializeBooks();
    });
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
