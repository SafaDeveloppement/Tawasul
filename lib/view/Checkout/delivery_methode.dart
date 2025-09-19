// import 'package:flutter/material.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';
// import 'package:tawasul_application/view/Checkout/address_selection.dart';
// import 'package:tawasul_application/view/Checkout/payment_method.dart';
// import 'package:flutter_gen/gen_l10n/app_localizations.dart';

// class DeliveryMethod extends StatefulWidget {
//   const DeliveryMethod({super.key});

//   @override
//   State<DeliveryMethod> createState() => _DeliveryMethodState();
// }

// class _DeliveryMethodState extends State<DeliveryMethod> {
//   String selectedMethod = "home";
//   String? selectedCity;
//   String? selectedShop;
//   String? selectedTime;

//   List<String> cities = ["Tripoli", "Benghazi"];
//   List<String> shops = ["Ras Hasan Hall", "Main Street Branch"];
//   List<String> timeSlots = [
//     "11:15 - 12:15",
//     "12:15 - 13:15",
//     "13:15 - 14:15",
//     "14:15 - 15:15",
//     "15:15 - 16:15",
//   ];

//   @override
//   Widget build(BuildContext context) {
//     final t = AppLocalizations.of(context)!;

//     return Scaffold(
//       backgroundColor: Colors.white,
//       appBar: AppBar(
//         leading: Padding(
//           padding: EdgeInsets.only(left: 18.w),
//           child: GestureDetector(
//             onTap: () {
//               Navigator.push(
//                 context,
//                 MaterialPageRoute(builder: (context) => AddressSelection()),
//               );
//             },
//             child: Container(
//               width: 40.w,
//               height: 40.w,
//               decoration: const BoxDecoration(
//                 color: Color(0xFF008AD2),
//                 shape: BoxShape.circle,
//               ),
//               child: Center(
//                 child: Icon(
//                   Icons.arrow_back_ios_new,
//                   color: Colors.white,
//                   size: 20.sp,
//                 ),
//               ),
//             ),
//           ),
//         ),
//         backgroundColor: Colors.white,
//         elevation: 0,
//         centerTitle: true,
//         title: Text(t.checkout, style: TextStyle(color: Colors.black)),
//       ),
//       body: SingleChildScrollView(
//         padding: const EdgeInsets.all(16),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             Padding(
//               padding: const EdgeInsets.only(left: 12, top: 12, bottom: 18),
//               child: Text(
//                 t.deliveryMethod,
//                 style: TextStyle(
//                   fontSize: 16,
//                   fontWeight: FontWeight.bold,
//                   color: Colors.black,
//                 ),
//               ),
//             ),
//             SizedBox(height: 20),
//             _buildDeliveryOption(t.homeDelivery, "home"),
//             const SizedBox(height: 20),
//             _buildDeliveryOption(t.storePickupDelivery, "pickup"),

//             if (selectedMethod == "pickup") ...[
//               const SizedBox(height: 20),
//               _buildDropdown(
//                 hint: t.selectCity,
//                 value: selectedCity,
//                 items: cities,
//                 onChanged: (val) {
//                   setState(() {
//                     selectedCity = val;
//                     selectedShop = null;
//                   });
//                 },
//               ),
//               const SizedBox(height: 15),

//               _buildDropdown(
//                 hint: t.selectShop,
//                 value: selectedShop,
//                 items: shops,
//                 onChanged: (val) {
//                   setState(() {
//                     selectedShop = val;
//                   });
//                 },
//               ),
//               const SizedBox(height: 20),

//               Card(
//                 color: Colors.white,
//                 shape: RoundedRectangleBorder(
//                   borderRadius: BorderRadius.circular(12),
//                 ),
//                 borderOnForeground: true,
//                 shadowColor: const Color.fromARGB(255, 0, 0, 0),
//                 child: Padding(
//                   padding: const EdgeInsets.all(16),
//                   child: Column(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                       Row(
//                         children: [
//                           Text(
//                             t.pickingDateTime,
//                             style: TextStyle(
//                               fontWeight: FontWeight.w300,
//                               fontSize: 14,
//                             ),
//                           ),
//                           Spacer(),
//                           Icon(Icons.calendar_today, size: 20),
//                         ],
//                       ),
//                       const SizedBox(height: 10),
//                       Wrap(
//                         spacing: 8,
//                         runSpacing: 8,
//                         children:
//                             timeSlots.map((slot) {
//                               final isSelected = slot == selectedTime;
//                               return GestureDetector(
//                                 onTap: () {
//                                   setState(() {
//                                     selectedTime = slot;
//                                   });
//                                 },
//                                 child: Container(
//                                   padding: const EdgeInsets.symmetric(
//                                     horizontal: 16,
//                                     vertical: 10,
//                                   ),
//                                   decoration: BoxDecoration(
//                                     color:
//                                         isSelected
//                                             ? Colors.orange
//                                             : const Color(0xFFE9EAEB),
//                                     borderRadius: BorderRadius.circular(8),
//                                   ),
//                                   child: Text(
//                                     slot,
//                                     style: TextStyle(
//                                       color:
//                                           isSelected
//                                               ? Colors.white
//                                               : Colors.black,
//                                       fontWeight: FontWeight.bold,
//                                     ),
//                                   ),
//                                 ),
//                               );
//                             }).toList(),
//                       ),
//                       const SizedBox(height: 20),
//                       Container(
//                         width: double.infinity,
//                         padding: const EdgeInsets.all(12),
//                         decoration: BoxDecoration(
//                           borderRadius: BorderRadius.circular(10),
//                           color: const Color(0xFFFFFFFF),
//                           border: Border.all(color: Colors.black),
//                         ),
//                         child: Row(
//                           mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                           children: [
//                             Column(
//                               crossAxisAlignment: CrossAxisAlignment.start,
//                               children: [
//                                 Text(
//                                   t.dateTime,
//                                   style: TextStyle(
//                                     fontWeight: FontWeight.w300,
//                                     fontSize: 14,
//                                   ),
//                                 ),
//                                 Text(t.september142025),
//                               ],
//                             ),
//                             Text(
//                               selectedTime ?? t.selectTime,
//                               style: TextStyle(
//                                 fontWeight: FontWeight.bold,
//                                 fontSize: 14,
//                               ),
//                             ),
//                           ],
//                         ),
//                       ),
//                     ],
//                   ),
//                 ),
//               ),
//             ],

//             const SizedBox(height: 30),
//             SizedBox(
//               width: double.infinity,
//               child: ElevatedButton(
//                 style: ElevatedButton.styleFrom(
//                   backgroundColor: Color(0xFF008AD2),
//                   padding: const EdgeInsets.symmetric(vertical: 14),
//                   shape: RoundedRectangleBorder(
//                     borderRadius: BorderRadius.circular(8),
//                   ),
//                 ),
//                 onPressed:
//                     () => Navigator.push(
//                       context,
//                       MaterialPageRoute(builder: (context) => PaymentMethod()),
//                     ),
//                 child: Text(
//                   t.validateAndContinue,
//                   style: TextStyle(
//                     fontSize: 16,
//                     fontWeight: FontWeight.bold,
//                     color: Colors.white,
//                   ),
//                 ),
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }

//   Widget _buildDeliveryOption(String label, String value) {
//     return InkWell(
//       onTap: () {
//         setState(() => selectedMethod = value);
//       },
//       child: Container(
//         padding: const EdgeInsets.all(14),
//         decoration: BoxDecoration(
//           borderRadius: BorderRadius.circular(10),
//           border: Border.all(
//             color: selectedMethod == value ? Colors.orange : Colors.grey,
//           ),
//           color: Colors.white,
//         ),
//         child: Row(
//           children: [
//             Icon(
//               selectedMethod == value
//                   ? Icons.radio_button_checked
//                   : Icons.radio_button_off,
//               color: Colors.orange,
//             ),
//             const SizedBox(width: 10),
//             Text(label, style: const TextStyle(fontSize: 16)),
//           ],
//         ),
//       ),
//     );
//   }

//   Widget _buildDropdown({
//     required String hint,
//     required String? value,
//     required List<String> items,
//     required ValueChanged<String?> onChanged,
//   }) {
//     return Container(
//       padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
//       decoration: BoxDecoration(
//         color: Colors.white,
//         borderRadius: BorderRadius.circular(10),
//         border: Border.all(color: Colors.grey.shade300),
//       ),
//       child: DropdownButton<String>(
//         value: value,
//         isExpanded: true,
//         hint: Text(hint),
//         underline: const SizedBox(),
//         items:
//             items.map((e) {
//               return DropdownMenuItem<String>(value: e, child: Text(e));
//             }).toList(),
//         onChanged: onChanged,
//       ),
//     );
//   }
// }

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:tawasul_application/view/Checkout/address_selection.dart';
import 'package:tawasul_application/view/Checkout/payment_method.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class DeliveryMethod extends StatefulWidget {
  const DeliveryMethod({super.key});

  @override
  State<DeliveryMethod> createState() => _DeliveryMethodState();
}

class _DeliveryMethodState extends State<DeliveryMethod> {
  String selectedMethod = "home";
  String? selectedCity;
  String? selectedShop;
  String? selectedTime;
  DateTime? selectedDate;

  List<String> cities = ["Tripoli", "Benghazi"];
  List<String> shops = ["Ras Hasan Hall", "Main Street Branch"];
  List<String> timeSlots = [
    "11:15 - 12:15",
    "12:15 - 13:15",
    "13:15 - 14:15",
    "14:15 - 15:15",
    "15:15 - 16:15",
  ];

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: selectedDate ?? DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime(DateTime.now().year + 1),
      builder: (BuildContext context, Widget? child) {
        return Theme(
          data: ThemeData.light().copyWith(
            colorScheme: const ColorScheme.light(
              primary: Color(0xFF008AD2),
              onPrimary: Colors.white,
              surface: Colors.white,
              onSurface: Colors.black,
            ),
            dialogBackgroundColor: Colors.white,
          ),
          child: child!,
        );
      },
    );
    if (picked != null && picked != selectedDate) {
      setState(() {
        selectedDate = picked;
      });
    }
  }

  String _formatDate(DateTime? date) {
    if (date == null) return '';

    final months = [
      'January',
      'February',
      'March',
      'April',
      'May',
      'June',
      'July',
      'August',
      'September',
      'October',
      'November',
      'December',
    ];

    return '${months[date.month - 1]} ${date.day} ${date.year}';
  }

  @override
  Widget build(BuildContext context) {
    final t = AppLocalizations.of(context)!;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        leading: Padding(
          padding: EdgeInsets.only(
            left: Directionality.of(context) == TextDirection.rtl ? 0 : 12.w,
            right: Directionality.of(context) == TextDirection.rtl ? 12.w : 0,
          ),
          child: GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => AddressSelection()),
              );
            },
            child: Container(
              width: 40.w,
              height: 40.w,
              decoration: const BoxDecoration(
                color: Color(0xFF008AD2),
                shape: BoxShape.circle,
              ),
              child: Center(
                child: Icon(
                  Icons.arrow_back_ios_new,
                  color: Colors.white,
                  size: 20.sp,
                ),
              ),
            ),
          ),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        title: Text(t.checkout, style: TextStyle(color: Colors.black)),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.only(left: 12, top: 12, bottom: 18),
              child: Text(
                t.deliveryMethod,
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
            ),
            SizedBox(height: 20),
            _buildDeliveryOption(t.homeDelivery, "home"),
            const SizedBox(height: 20),
            _buildDeliveryOption(t.storePickupDelivery, "pickup"),

            if (selectedMethod == "pickup") ...[
              const SizedBox(height: 20),
              _buildDropdown(
                hint: t.selectCity,
                value: selectedCity,
                items: cities,
                onChanged: (val) {
                  setState(() {
                    selectedCity = val;
                    selectedShop = null;
                  });
                },
              ),
              const SizedBox(height: 15),

              _buildDropdown(
                hint: t.selectShop,
                value: selectedShop,
                items: shops,
                onChanged: (val) {
                  setState(() {
                    selectedShop = val;
                  });
                },
              ),
              const SizedBox(height: 20),

              Card(
                color: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                borderOnForeground: true,
                shadowColor: const Color.fromARGB(255, 0, 0, 0),
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Text(
                            t.pickingDateTime,
                            style: TextStyle(
                              fontWeight: FontWeight.w300,
                              fontSize: 14,
                            ),
                          ),
                          Spacer(),
                          GestureDetector(
                            onTap: () => _selectDate(context),
                            child: Icon(Icons.calendar_today, size: 20),
                          ),
                        ],
                      ),
                      const SizedBox(height: 10),
                      Wrap(
                        spacing: 8,
                        runSpacing: 8,
                        children:
                            timeSlots.map((slot) {
                              final isSelected = slot == selectedTime;
                              return GestureDetector(
                                onTap: () {
                                  setState(() {
                                    selectedTime = slot;
                                  });
                                },
                                child: Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 16,
                                    vertical: 10,
                                  ),
                                  decoration: BoxDecoration(
                                    color:
                                        isSelected
                                            ? Colors.orange
                                            : const Color(0xFFE9EAEB),
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  child: Text(
                                    slot,
                                    style: TextStyle(
                                      color:
                                          isSelected
                                              ? Colors.white
                                              : Colors.black,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              );
                            }).toList(),
                      ),
                      const SizedBox(height: 20),
                      GestureDetector(
                        onTap: () => _selectDate(context),
                        child: Container(
                          width: double.infinity,
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            color: const Color(0xFFFFFFFF),
                            border: Border.all(color: Colors.black),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    t.dateTime,
                                    style: TextStyle(
                                      fontWeight: FontWeight.w300,
                                      fontSize: 14,
                                    ),
                                  ),
                                  Text(
                                    selectedDate != null
                                        ? _formatDate(selectedDate)
                                        : t.selectDate,
                                  ),
                                ],
                              ),
                              Text(
                                selectedTime ?? t.selectTime,
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 14,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],

            const SizedBox(height: 30),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Color(0xFF008AD2),
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                onPressed:
                    () => Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => PaymentMethod()),
                    ),
                child: Text(
                  t.validateAndContinue,
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDeliveryOption(String label, String value) {
    return InkWell(
      onTap: () {
        setState(() => selectedMethod = value);
      },
      child: Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          border: Border.all(
            color: selectedMethod == value ? Colors.orange : Colors.grey,
          ),
          color: Colors.white,
        ),
        child: Row(
          children: [
            Icon(
              selectedMethod == value
                  ? Icons.radio_button_checked
                  : Icons.radio_button_off,
              color: Colors.orange,
            ),
            const SizedBox(width: 10),
            Text(label, style: const TextStyle(fontSize: 16)),
          ],
        ),
      ),
    );
  }

  Widget _buildDropdown({
    required String hint,
    required String? value,
    required List<String> items,
    required ValueChanged<String?> onChanged,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: Colors.grey.shade300),
      ),
      child: DropdownButton<String>(
        value: value,
        isExpanded: true,
        hint: Text(hint),
        underline: const SizedBox(),
        items:
            items.map((e) {
              return DropdownMenuItem<String>(value: e, child: Text(e));
            }).toList(),
        onChanged: onChanged,
      ),
    );
  }
}
