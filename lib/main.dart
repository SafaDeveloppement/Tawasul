import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:responsive_framework/responsive_framework.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tawasul_application/Provider/cart_provider.dart';
import 'package:tawasul_application/Provider/order_provider.dart';
import 'package:tawasul_application/Provider/product_provider.dart';
import 'package:tawasul_application/Provider/user_provider.dart';
import 'package:tawasul_application/controller/product_controller.dart'; 
import 'package:tawasul_application/view/home_page.dart';
import 'package:tawasul_application/view/splash_screen.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final prefs = await SharedPreferences.getInstance();
  String? langCode = prefs.getString("language_code");

  runApp(
    MyApp(initialLocale: langCode != null ? Locale(langCode) : Locale("ar")),
  );
}

class MyApp extends StatefulWidget {
  final Locale initialLocale;

  const MyApp({super.key, required this.initialLocale});

  static void setLocale(BuildContext context, Locale newLocale) {
    _MyAppState? state = context.findAncestorStateOfType<_MyAppState>();
    state?.setLocale(newLocale);
  }

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  late Locale _locale;

  @override
  void initState() {
    super.initState();
    _locale = widget.initialLocale;
  }

  Future<void> setLocale(Locale locale) async {
    setState(() {
      _locale = locale;
    });

    final prefs = await SharedPreferences.getInstance();
    await prefs.setString("language_code", locale.languageCode);
  }

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(360, 690),
      minTextAdapt: true,
      splitScreenMode: true,
      builder: (context, child) {
        return MultiProvider(
          providers: [
            ChangeNotifierProvider(
              create: (context) => ProductController()..initialize(),
              lazy: false,
            ),
            ChangeNotifierProvider(create: (context) => CartProvider()),
            ChangeNotifierProvider(create: (_) => ProductProvider()),
            //ChangeNotifierProvider(create: (_) => AddressProvider()),
            ChangeNotifierProvider(create: (_) => OrderProvider()),
            ChangeNotifierProvider(create: (context) => UserProvider()),
          ],
          child: MaterialApp(
            debugShowCheckedModeBanner: false,
            onGenerateTitle: (ctx) => AppLocalizations.of(ctx)!.appTitle,
            locale: _locale,
            localizationsDelegates: const [
              AppLocalizations.delegate,
              GlobalMaterialLocalizations.delegate,
              GlobalWidgetsLocalizations.delegate,
              GlobalCupertinoLocalizations.delegate,
            ],
            supportedLocales: AppLocalizations.supportedLocales,
            initialRoute: '/',
            routes: {
              '/': (context) => SplashScreen(),
              '/home': (context) => HomePage(),
            },
            builder:
                (context, child) => ResponsiveBreakpoints.builder(
                  child: BouncingScrollWrapper.builder(context, child!),
                  breakpoints: [
                    const Breakpoint(start: 0, end: 450, name: MOBILE),
                    const Breakpoint(start: 451, end: 800, name: TABLET),
                    const Breakpoint(start: 801, end: 1200, name: DESKTOP),
                    const Breakpoint(
                      start: 1201,
                      end: double.infinity,
                      name: '4K',
                    ),
                  ],
                ),
          ),
        );
      },
    );
  }
}
