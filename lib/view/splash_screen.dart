// import 'package:flutter/material.dart';
// import 'dart:async';

// class SplashScreen extends StatefulWidget {
//   const SplashScreen({super.key});

//   @override
//   State<SplashScreen> createState() => _SplashScreenState();
// }

// class _SplashScreenState extends State<SplashScreen>
//     with TickerProviderStateMixin {
//   late AnimationController _controller;
//   late Animation<double> _scaleAnimation;
//   late Animation<double> _rotationAnimation;
//   late Animation<double> _fadeAnimation;
//   late Animation<Offset> _slideAnimation;

//   @override
//   void initState() {
//     super.initState();

//     _controller = AnimationController(
//       vsync: this,
//       duration: const Duration(seconds: 2),
//     );

//     _scaleAnimation = Tween<double>(
//       begin: 0.6,
//       end: 1.0,
//     ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeOutBack));

//     _rotationAnimation = Tween<double>(
//       begin: 1.0,
//       end: 6.0,
//     ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeOut));

//     _fadeAnimation = Tween<double>(
//       begin: 3.0,
//       end: 1.0,
//     ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeIn));

//     _slideAnimation = Tween<Offset>(
//       begin: const Offset(0, 5),
//       end: Offset.zero,
//     ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeOut));

//     _controller.forward();

//     Timer(const Duration(seconds: 4), () {
//       Navigator.of(context).pushReplacementNamed('/home');
//     });
//   }

//   @override
//   void dispose() {
//     _controller.dispose();
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: Colors.white,
//       body: Center(
//         child: AnimatedBuilder(
//           animation: _controller,
//           builder:
//               (context, child) => Column(
//                 mainAxisSize: MainAxisSize.min,
//                 children: [
//                   Transform.scale(
//                     scale: _scaleAnimation.value,
//                     child: Transform.rotate(
//                       angle: _rotationAnimation.value * 1.05,
//                       child: Image.asset(
//                         'assets/images/tawasul_logo.png',
//                         width: 140,
//                         height: 140,
//                       ),
//                     ),
//                   ),
//                   const SizedBox(height: 0),
//                   FadeTransition(
//                     opacity: _fadeAnimation,
//                     child: SlideTransition(
//                       position: _slideAnimation,
//                       child: const Text(
//                         'Welcome To Tawasul',
//                         style: TextStyle(
//                           fontFamily: "Inter",
//                           fontSize: 26,
//                           fontWeight: FontWeight.normal,
//                           color: Colors.black87,
//                         ),
//                       ),
//                     ),
//                   ),
//                 ],
//               ),
//         ),
//       ),
//     );
//   }
// }

import 'package:flutter/material.dart';
import 'dart:async';
import 'package:provider/provider.dart';
import 'package:tawasul_application/controller/product_controller.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with TickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;
  late Animation<double> _rotationAnimation;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    );

    _scaleAnimation = Tween<double>(
      begin: 0.6,
      end: 1.0,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeOutBack));

    _rotationAnimation = Tween<double>(
      begin: 1.0,
      end: 6.0,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeOut));

    _fadeAnimation = Tween<double>(
      begin: 3.0,
      end: 1.0,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeIn));

    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 5),
      end: Offset.zero,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeOut));

    _controller.forward();

    // Check initialization status and navigate
    _checkInitializationAndNavigate();
  }

  void _checkInitializationAndNavigate() async {
    final productController = Provider.of<ProductController>(
      context,
      listen: false,
    );

    // Wait for animations to complete (2 seconds)
    await Future.delayed(Duration(seconds: 2));

    // If already initialized, navigate immediately
    if (productController.isInitialized) {
      _navigateToHome();
      return;
    }

    // If not initialized yet, wait for it with a timeout
    final completer = Completer();
    final timer = Timer.periodic(Duration(milliseconds: 100), (timer) {
      if (productController.isInitialized) {
        timer.cancel();
        completer.complete();
      }
    });

    // Safety timeout after 3 more seconds (total 5 seconds max)
    Timer(Duration(seconds: 3), () {
      if (!completer.isCompleted) {
        timer.cancel();
        completer.complete();
      }
    });

    await completer.future;
    _navigateToHome();
  }

  void _navigateToHome() {
    if (mounted) {
      Navigator.of(context).pushReplacementNamed('/home');
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: AnimatedBuilder(
          animation: _controller,
          builder:
              (context, child) => Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Transform.scale(
                    scale: _scaleAnimation.value,
                    child: Transform.rotate(
                      angle: _rotationAnimation.value * 1.05,
                      child: Image.asset(
                        'assets/images/tawasul_logo.png',
                        width: 140,
                        height: 140,
                      ),
                    ),
                  ),
                  const SizedBox(height: 0),
                  FadeTransition(
                    opacity: _fadeAnimation,
                    child: SlideTransition(
                      position: _slideAnimation,
                      child: const Text(
                        'Welcome To Tawasul',
                        style: TextStyle(
                          fontFamily: "Inter",
                          fontSize: 26,
                          fontWeight: FontWeight.normal,
                          color: Colors.black87,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
        ),
      ),
    );
  }
}
