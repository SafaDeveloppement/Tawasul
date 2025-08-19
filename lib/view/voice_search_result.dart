// import 'package:flutter/material.dart';

// class VoiceSearchResult extends StatelessWidget {
//   const VoiceSearchResult({super.key});

//   final List<Map<String, String>> stores = const [
//     {
//       "name": "Tawasul Apple",
//       "address": "Venice, Benghazi\nLibya",
//       "phone": "+218922559300",
//     },
//     {
//       "name": "Tawasul Xiaomi",
//       "address": "Benghazi, Benghazi\nLibya",
//       "phone": "+218922559400",
//     },
//     {
//       "name": "Tawasul Samsung",
//       "address": "Street Al-Riwayat ard Ben Ali, Benghazi\nLibya",
//       "phone": "+218922559300",
//     },
//     {
//       "name": "Tawasul All",
//       "address": "Shari Al Qayrawan, Benghazi\nLibya",
//       "phone": "+218922559400",
//     },
//     {
//       "name": "Tawasul Samsung",
//       "address": "Venice, Benghazi\nLibya",
//       "phone": "+218922559300",
//     },
//   ];

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
//                   Image.asset(
//                     'assets/images/logo_tawasul_blanc.png',
//                     width: 40,
//                   ),
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
//                                 hintText: 'Benghazi',
//                                 hintStyle: TextStyle(color: Colors.white),
//                                 border: InputBorder.none,
//                               ),
//                               style: TextStyle(color: Colors.white),
//                             ),
//                           ),
//                           Padding(
//                             padding: EdgeInsets.symmetric(horizontal: 12),
//                             child: Icon(Icons.search, color: Colors.white),
//                           ),
//                         ],
//                       ),
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//             // Store results
//             Expanded(
//               child: ListView.builder(
//                 padding: const EdgeInsets.symmetric(horizontal: 12),
//                 itemCount: stores.length,
//                 itemBuilder: (context, index) {
//                   final store = stores[index];
//                   return Container(
//                     margin: const EdgeInsets.only(bottom: 16),
//                     padding: const EdgeInsets.all(12),
//                     decoration: BoxDecoration(
//                       color: Colors.white,
//                       borderRadius: BorderRadius.circular(16),
//                       boxShadow: const [
//                         BoxShadow(
//                           color: Colors.black26,
//                           blurRadius: 4,
//                           offset: Offset(0, 2),
//                         ),
//                       ],
//                     ),
//                     child: Row(
//                       children: [
//                         Image.asset(
//                           'assets/images/location_icon.png',
//                           width: 40,
//                         ),
//                         const SizedBox(width: 12),
//                         Expanded(
//                           child: Column(
//                             crossAxisAlignment: CrossAxisAlignment.start,
//                             children: [
//                               Text(
//                                 store["name"]!,
//                                 style: const TextStyle(
//                                   fontWeight: FontWeight.bold,
//                                 ),
//                               ),
//                               Text(
//                                 store["address"]!,
//                                 style: const TextStyle(height: 1.3),
//                               ),
//                             ],
//                           ),
//                         ),
//                         Column(
//                           children: [
//                             const Icon(Icons.phone, color: Color(0xFF008AD2)),
//                             Text(
//                               store["phone"]!,
//                               style: const TextStyle(
//                                 color: Color(0xFF008AD2),
//                                 fontSize: 12,
//                               ),
//                             ),
//                           ],
//                         ),
//                       ],
//                     ),
//                   );
//                 },
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }


import 'package:flutter/material.dart';

class VoiceSearchResult extends StatelessWidget {
  final String searchQuery;
  
  const VoiceSearchResult({
    super.key,
    required this.searchQuery,
  });

  final List<Map<String, String>> allStores = const [
    {
      "name": "Tawasul Apple",
      "address": "Venice, Benghazi\nLibya",
      "phone": "+218922559300",
    },
    {
      "name": "Tawasul Xiaomi",
      "address": "Benghazi, Benghazi\nLibya",
      "phone": "+218922559400",
    },
    {
      "name": "Tawasul Samsung",
      "address": "Street Al-Riwayat ard Ben Ali, Benghazi\nLibya",
      "phone": "+218922559300",
    },
    {
      "name": "Tawasul All",
      "address": "Shari Al Qayrawan, Benghazi\nLibya",
      "phone": "+218922559400",
    },
  ];

  @override
  Widget build(BuildContext context) {
    final matchingStores = allStores.where((store) {
      return store["name"]!.toLowerCase().contains(searchQuery.toLowerCase()) ||
             store["address"]!.toLowerCase().contains(searchQuery.toLowerCase());
    }).toList();

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
                              searchQuery,
                              style: const TextStyle(color: Colors.white),
                            ),
                          ),
                          const Padding(
                            padding: EdgeInsets.symmetric(horizontal: 12),
                            child: Icon(Icons.search, color: Colors.white),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: ListView.builder(
                padding: const EdgeInsets.symmetric(horizontal: 12),
                itemCount: matchingStores.length,
                itemBuilder: (context, index) {
                  final store = matchingStores[index];
                  return Container(
                    margin: const EdgeInsets.only(bottom: 16),
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(16),
                      boxShadow: const [
                        BoxShadow(
                          color: Colors.black26,
                          blurRadius: 4,
                          offset: Offset(0, 2),
                        ),
                      ],
                    ),
                    child: Row(
                      children: [
                        Image.asset(
                          'assets/images/location_icon.png',
                          width: 40,
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                store["name"]!,
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              Text(
                                store["address"]!,
                                style: const TextStyle(height: 1.3),
                              ),
                            ],
                          ),
                        ),
                        Column(
                          children: [
                            const Icon(Icons.phone, color: Color(0xFF008AD2)),
                            Text(
                              store["phone"]!,
                              style: const TextStyle(
                                color: Color(0xFF008AD2),
                                fontSize: 12,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}