// import 'package:flutter/material.dart';

// class VoiceSearchScreen extends StatelessWidget {
//   const VoiceSearchScreen({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: const Color(0xFF008AD2),
//       body: SafeArea(
//         child: Column(
//           children: [
//             // Header with logo and search bar
//             Padding(
//               padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 20),
//               child: Row(
//                 children: [
//                   Image.asset('assets/images/logo_tawasul_blanc.png', width: 40),
//                   const SizedBox(width: 12),
//                   Expanded(
//                     child: Container(
//                       height: 40,
//                       decoration: BoxDecoration(
//                         color: Colors.lightBlue[300],
//                         borderRadius: BorderRadius.circular(20),
//                       ),
//                       child: const Row(
//                         children: [
//                           SizedBox(width: 12),
//                           Expanded(
//                             child: TextField(
//                               decoration: InputDecoration(
//                                 hintText: 'Search',
//                                 hintStyle: TextStyle(color: Colors.white),
//                                 border: InputBorder.none,
//                               ),
//                               style: TextStyle(color: Colors.white),
//                             ),
//                           ),
//                           Padding(
//                             padding: EdgeInsets.symmetric(horizontal: 12),
//                             child: Icon(Icons.search, color: Colors.white),
//                           )
//                         ],
//                       ),
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//             const Spacer(),
//             // Waveform circle
//             Container(
//               height: 200,
//               width: 200,
//               decoration: BoxDecoration(
//                 shape: BoxShape.circle,
//                 color: Colors.white,
//                 boxShadow: [
//                   BoxShadow(color: Colors.black26, blurRadius: 8),
//                 ],
//               ),
//               child: Center(
//                 child: Image.asset('assets/images/wave.png', width: 100),
//               ),
//             ),
//             const Spacer(),
//             // Mic button
//             Container(
//               margin: const EdgeInsets.only(bottom: 24),
//               padding: const EdgeInsets.all(12),
//               decoration: BoxDecoration(
//                 shape: BoxShape.circle,
//                 color: Colors.white.withOpacity(0.2),
//               ),
//               child: Container(
//                 padding: const EdgeInsets.all(16),
//                 decoration: const BoxDecoration(
//                   shape: BoxShape.circle,
//                   color: Colors.white,
//                 ),
//                 child: const Icon(Icons.mic, color: Colors.black),
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }

import 'package:flutter/material.dart';

class VoiceSearchScreen extends StatefulWidget {
  const VoiceSearchScreen({super.key});

  @override
  State<VoiceSearchScreen> createState() => _VoiceSearchScreenState();
}

class _VoiceSearchScreenState extends State<VoiceSearchScreen> {
  bool _isListening = false;
  String _spokenText = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF008AD2),
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 20),
              child: Row(
                children: [
                  Image.asset(
                    'assets/images/logo_tawasul_blanc.png',
                    width: 40,
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Container(
                      height: 40,
                      decoration: BoxDecoration(
                        color: Colors.lightBlue[300],
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Row(
                        children: [
                          const SizedBox(width: 12),
                          Expanded(
                            child: Text(
                              _spokenText.isEmpty
                                  ? 'Listening...'
                                  : _spokenText,
                              style: const TextStyle(color: Colors.white),
                            ),
                          ),
                          IconButton(
                            icon: const Icon(Icons.close, color: Colors.white),
                            onPressed: () => Navigator.pop(context),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const Spacer(),
            AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              height: _isListening ? 220 : 200,
              width: _isListening ? 220 : 200,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                    color: _isListening ? Colors.black38 : Colors.black26,
                    blurRadius: 8,
                  ),
                ],
              ),
              child: Center(
                child: Image.asset(
                  'assets/images/wave.png',
                  width: _isListening ? 120 : 100,
                ),
              ),
            ),
            const Spacer(),
            GestureDetector(
              child: Container(
                margin: const EdgeInsets.only(bottom: 24),
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.white.withOpacity(0.2),
                ),
                child: Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: _isListening ? Colors.red : Colors.white,
                  ),
                  child: Icon(
                    Icons.mic,
                    color: _isListening ? Colors.white : Colors.black,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
