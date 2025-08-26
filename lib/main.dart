// import 'package:flutter/material.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';
// import 'package:provider/provider.dart';
// import 'package:responsive_framework/responsive_framework.dart';
// import 'package:tawasul_application/controller/product_controller.dart';
// import 'package:tawasul_application/view/home_page.dart';
// import 'package:tawasul_application/view/splash_screen.dart';

// void main() {
//   runApp(const MyApp());
// }

// class MyApp extends StatelessWidget {
//   const MyApp({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return ScreenUtilInit(
//       designSize: Size(360, 690),
//       minTextAdapt: true,
//       splitScreenMode: true,
//       builder: (context, child) {
//         return MultiProvider(
//           providers: [
//             ChangeNotifierProvider(
//               create: (context) => ProductController()..initialize(),
//               lazy: false,
//             ),
//           ],
//           child: MaterialApp(
//             debugShowCheckedModeBanner: false,
//             initialRoute: '/',
//             routes: {
//               '/': (context) => const SplashScreen(),
//               '/home': (context) => const HomePage(),
//             },
//             builder:
//                 (context, child) => ResponsiveBreakpoints.builder(
//                   child: BouncingScrollWrapper.builder(context, child!),
//                   breakpoints: [
//                     const Breakpoint(start: 0, end: 450, name: MOBILE),
//                     const Breakpoint(start: 451, end: 800, name: TABLET),
//                     const Breakpoint(start: 801, end: 1200, name: DESKTOP),
//                     const Breakpoint(
//                       start: 1201,
//                       end: double.infinity,
//                       name: '4K',
//                     ),
//                   ],
//                 ),
//           ),
//         );
//       },
//     );
//   }
// }

import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:responsive_framework/responsive_framework.dart';
import 'package:tawasul_application/controller/product_controller.dart';
import 'package:tawasul_application/view/home_page.dart';
import 'package:tawasul_application/view/splash_screen.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

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
          ],
          child: MaterialApp(
            debugShowCheckedModeBanner: false,
            onGenerateTitle: (ctx) => AppLocalizations.of(ctx)!.appTitle,
            localizationsDelegates: const [
              AppLocalizations.delegate,
              GlobalMaterialLocalizations.delegate,
              GlobalWidgetsLocalizations.delegate,
              GlobalCupertinoLocalizations.delegate,
            ],
            supportedLocales: AppLocalizations.supportedLocales,
            initialRoute: '/',
            routes: {
              '/': (context) => const SplashScreen(),
              '/home': (context) => const HomePage(),
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
