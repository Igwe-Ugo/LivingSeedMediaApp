import 'package:flutter/material.dart';
import 'package:livingseed_media/screens/pages/services/services.dart';
import 'screens/common/widget.dart';
import 'package:provider/provider.dart';

void main() {
  LivingSeedAppRouter.instance;
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const LivingSeedApp());
}

class LivingSeedApp extends StatefulWidget {
  const LivingSeedApp({super.key});

  @override
  State<LivingSeedApp> createState() => _LivingSeedAppState();
}

class _LivingSeedAppState extends State<LivingSeedApp> {
  DarkThemeProvider themeChangeProvider = DarkThemeProvider();

  @override
  void initState() {
    super.initState();
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
        ChangeNotifierProvider(create: (_) => UsersAuthProvider()),
        ChangeNotifierProvider(create: (_) => AdminAuthProvider()),
        ChangeNotifierProvider(
            create: (_) => AboutBookProvider()..initializeBooks())
      ],
      child: Consumer<DarkThemeProvider>(builder: (context, themeData, child) {
        return MaterialApp.router(
          debugShowCheckedModeBanner: false,
          title: 'Living Seed Media',
          theme: Styles.themeData(themeChangeProvider.darkTheme, context),
          routerConfig: LivingSeedAppRouter.router,
        );
      }),
    );
  }
}
