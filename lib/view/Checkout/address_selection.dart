// import 'package:flutter/material.dart';

// class AddressSelection extends StatefulWidget {
//   const AddressSelection({Key? key}) : super(key: key);

//   @override
//   State<AddressSelection> createState() => _AddressSelectionState();
// }

// class _AddressSelectionState extends State<AddressSelection> {
//   int selectedAddressIndex = 0;

//   final List<Map<String, String>> addresses = [
//     {
//       'name': 'First last name',
//       'address': 'Eastern Fwayhat. Benghazi, Libye',
//       'phone': '+216 58 400 2555',
//     },
//     {
//       'name': 'First last name',
//       'address': 'Eastern Fwayhat. Benghazi, Libye',
//       'phone': '+216 58 400 2555',
//     },
//   ];

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: Colors.white,
//       appBar: AppBar(
//         leading: CircleAvatar(
//           backgroundColor: Colors.blue,
//           child: IconButton(
//             icon: const Icon(Icons.arrow_back, color: Colors.white),
//             onPressed: () => Navigator.pop(context),
//           ),
//         ),
//         backgroundColor: Colors.white,
//         elevation: 0,
//         title: const Text("Checkout", style: TextStyle(color: Colors.black)),
//         centerTitle: true,
//       ),
//       body: Padding(
//         padding: const EdgeInsets.all(16),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             const Text(
//               "DELIVERY ADDRESS",
//               style: TextStyle(fontWeight: FontWeight.bold),
//             ),
//             const SizedBox(height: 16),
//             ...List.generate(addresses.length, (index) {
//               final item = addresses[index];
//               return _buildAddressCard(item, index);
//             }),
//             const SizedBox(height: 16),
//             _buildAddAddressButton(),
//             const Spacer(),
//             _buildContinueButton(),
//           ],
//         ),
//       ),
//     );
//   }

//   Widget _buildAddressCard(Map<String, String> data, int index) {
//     return GestureDetector(
//       onTap: () {
//         setState(() {
//           selectedAddressIndex = index;
//         });
//       },
//       child: Container(
//         margin: const EdgeInsets.only(bottom: 12),
//         padding: const EdgeInsets.all(12),
//         decoration: BoxDecoration(
//           border: Border.all(color: Colors.black54),
//           borderRadius: BorderRadius.circular(12),
//         ),
//         child: Row(
//           children: [
//             Radio<int>(
//               value: index,
//               groupValue: selectedAddressIndex,
//               activeColor: Colors.orange,
//               onChanged: (value) {
//                 setState(() {
//                   selectedAddressIndex = value!;
//                 });
//               },
//             ),
//             const SizedBox(width: 8),
//             Expanded(
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   Text(
//                     data['name']!,
//                     style: const TextStyle(fontWeight: FontWeight.w500),
//                   ),
//                   const SizedBox(height: 4),
//                   Text(data['address']!),
//                   Text(data['phone']!),
//                   const SizedBox(height: 6),
//                   TextButton(
//                     onPressed: () {
//                       // to do: handle change address
//                     },
//                     child: const Text(
//                       "Change",
//                       style: TextStyle(color: Colors.blue),
//                     ),
//                     style: TextButton.styleFrom(padding: EdgeInsets.zero),
//                   ),
//                 ],
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }

//   Widget _buildAddAddressButton() {
//     return OutlinedButton.icon(
//       onPressed: () {
//         // to do : handle add new address
//       },
//       icon: const Icon(Icons.add),
//       label: const Text(
//         "ADD NEW ADDRESS",
//         style: TextStyle(color: Colors.black),
//       ),
//       style: OutlinedButton.styleFrom(
//         minimumSize: const Size.fromHeight(50),
//         shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(25)),
//         side: const BorderSide(color: Colors.black45),
//       ),
//     );
//   }

//   Widget _buildContinueButton() {
//     return SizedBox(
//       width: double.infinity,
//       height: 48,
//       child: ElevatedButton(
//         onPressed: () {
//           // to do: handle validation and navigation
//         },
//         style: ElevatedButton.styleFrom(
//           backgroundColor: Colors.blue,
//           shape: RoundedRectangleBorder(
//             borderRadius: BorderRadius.circular(10),
//           ),
//         ),
//         child: const Text(
//           "Validate and continue",
//           style: TextStyle(color: Colors.white),
//         ),
//       ),
//     );
//   }
// }
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class AddressSelection extends StatefulWidget {
  const AddressSelection({super.key});

  @override
  State<AddressSelection> createState() => _AddressSelectionState();
}

class _AddressSelectionState extends State<AddressSelection> {
  int selectedAddressIndex = 0;

  final List<Map<String, String>> addresses = [
    {
      'name': 'First last name',
      'address': 'Eastern Fwayhat. Benghazi, Libye',
      'phone': '+216 58 400 2555',
    },
    {
      'name': 'First last name',
      'address': 'Eastern Fwayhat. Benghazi, Libye',
      'phone': '+216 58 400 2555',
    },
  ];

  @override
  Widget build(BuildContext context) {
    final t = AppLocalizations.of(context)!;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        leading: CircleAvatar(
          backgroundColor: Colors.blue,
          child: IconButton(
            icon: const Icon(Icons.arrow_back, color: Colors.white),
            onPressed: () => Navigator.pop(context),
          ),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
        title: Text(t.checkout, style: TextStyle(color: Colors.black)),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              t.deliveryAddress,
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            ...List.generate(addresses.length, (index) {
              final item = addresses[index];
              return _buildAddressCard(item, index, t);
            }),
            const SizedBox(height: 16),
            _buildAddAddressButton(t),
            const Spacer(),
            _buildContinueButton(t),
          ],
        ),
      ),
    );
  }

  Widget _buildAddressCard(
    Map<String, String> data,
    int index,
    AppLocalizations t,
  ) {
    return GestureDetector(
      onTap: () {
        setState(() {
          selectedAddressIndex = index;
        });
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          border: Border.all(color: Colors.black54),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          children: [
            Radio<int>(
              value: index,
              groupValue: selectedAddressIndex,
              activeColor: Colors.orange,
              onChanged: (value) {
                setState(() {
                  selectedAddressIndex = value!;
                });
              },
            ),
            const SizedBox(width: 8),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    data['name']!,
                    style: TextStyle(fontWeight: FontWeight.w500),
                  ),
                  const SizedBox(height: 4),
                  Text(data['address']!),
                  Text(data['phone']!),
                  const SizedBox(height: 6),
                  TextButton(
                    onPressed: () {
                      // to do: handle change address
                    },
                    style: TextButton.styleFrom(padding: EdgeInsets.zero),
                    child: Text(t.change, style: TextStyle(color: Colors.blue)),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAddAddressButton(AppLocalizations t) {
    return OutlinedButton.icon(
      onPressed: () {
        // to do : handle add new address
      },
      icon: const Icon(Icons.add),
      label: Text(t.addNewAddress, style: TextStyle(color: Colors.black)),
      style: OutlinedButton.styleFrom(
        minimumSize: const Size.fromHeight(50),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(25)),
        side: const BorderSide(color: Colors.black45),
      ),
    );
  }

  Widget _buildContinueButton(AppLocalizations t) {
    return SizedBox(
      width: double.infinity,
      height: 48,
      child: ElevatedButton(
        onPressed: () {
          // to do: handle validation and navigation
        },
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.blue,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ),
        child: Text(
          t.validateAndContinue,
          style: TextStyle(color: Colors.white),
        ),
      ),
    );
  }
}
