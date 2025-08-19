// import 'package:flutter/material.dart';
// import 'package:tawasul_application/view/home_page.dart';

// class PasswordUpdated extends StatelessWidget {
//   const PasswordUpdated({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: SafeArea(
//         child: Padding(
//           padding: const EdgeInsets.only(
//             top: 130.0,
//             left: 25,
//             right: 25,
//             bottom: 0,
//           ),
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.center,
//             children: [
//               Center(
//                 child: Image.asset(
//                   'assets/images/success.png',
//                   width: 350,
//                   height: 350,
//                 ),
//               ),
//               Text(
//                 "Your password has been updated successfully!",
//                 style: TextStyle(
//                   fontSize: 24,
//                   fontWeight: FontWeight.bold,
//                   fontFamily: 'Montserrat',
//                 ),
//                 textAlign: TextAlign.center,
//               ),
//               SizedBox(height: 20),
//               Text(
//                 "You can use your new password to log in.",
//                 style: TextStyle(
//                   fontSize: 18,
//                   fontWeight: FontWeight.normal,
//                   fontFamily: 'Montserrat',
//                 ),
//                 textAlign: TextAlign.center,
//               ),
//               SizedBox(height: 40),
//               Center(
//                 child: SizedBox(
//                   width: 310,
//                   height: 50,
//                   child: ElevatedButton(
//                     onPressed: () {
//                       Navigator.push(
//                         context,
//                         MaterialPageRoute(builder: (context) => HomePage()),
//                       );
//                     },
//                     style: ElevatedButton.styleFrom(
//                       backgroundColor: const Color(0xFF008AD2),
//                       shape: RoundedRectangleBorder(
//                         borderRadius: BorderRadius.circular(8),
//                       ),
//                     ),
//                     child: const Text(
//                       'Back to home',
//                       style: TextStyle(
//                         fontSize: 20,
//                         fontWeight: FontWeight.normal,
//                         color: Colors.white,
//                       ),
//                     ),
//                   ),
//                 ),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }
