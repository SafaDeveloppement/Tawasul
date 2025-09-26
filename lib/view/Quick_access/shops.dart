// import 'package:flutter/material.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';
// import 'package:flutter_gen/gen_l10n/app_localizations.dart';
// import 'package:tawasul_application/view/home_page.dart';

// class Shop {
//   final String nameKey;
//   final String addressKey;
//   final String phone;
//   final String email;
//   final Map<String, String> scheduleKeys;
//   bool isExpanded;

//   Shop({
//     required this.nameKey,
//     required this.addressKey,
//     required this.phone,
//     required this.email,
//     required this.scheduleKeys,
//     this.isExpanded = false,
//   });
// }

// class FindTawasul extends StatefulWidget {
//   @override
//   _FindTawasulState createState() => _FindTawasulState();
// }

// class _FindTawasulState extends State<FindTawasul> {
//   late final List<Shop> shops;

//   @override
//   void initState() {
//     super.initState();
//     shops = [
//       Shop(
//         nameKey: "tawasulAll",
//         addressKey: "streetAlKhototAlBaidaLibya",
//         phone: "+218922559400",
//         email: "Albaidaa.shop@tawasul-world.com",
//         scheduleKeys: {
//           "mon": "10:30AM - 09:00PM",
//           "tue": "10:30AM - 09:00PM",
//           "wed": "10:30AM - 09:00PM",
//           "thu": "10:30AM - 09:00PM",
//           "fri": "Closed",
//           "sat": "10:30AM - 09:00PM",
//           "sun": "10:30AM - 09:00PM",
//         },
//       ),
//       Shop(
//         nameKey: "tawasulApple",
//         addressKey: "veniceBenghaziLibya",
//         phone: "+218922559300",
//         email: "applealijud.shop@tawasul-world.com",
//         scheduleKeys: {
//           "mon": "09:30AM - 09:30PM",
//           "tue": "09:30AM - 09:30PM",
//           "wed": "09:30AM - 09:30PM",
//           "thu": "09:30AM - 09:30PM",
//           "fri": "Closed",
//           "sat": "09:30AM - 09:30PM",
//           "sun": "09:30AM - 09:30PM",
//         },
//       ),
//       Shop(
//         nameKey: "tawasulXiaomi",
//         addressKey: "benghaziLibya",
//         phone: "+218915558900",
//         email: "Xiaomivenicia.shop@tawasul-world.com",
//         scheduleKeys: {
//           "mon": "10:00AM - 10:00PM",
//           "tue": "10:00AM - 10:00PM",
//           "wed": "10:00AM - 10:00PM",
//           "thu": "10:00AM - 10:00PM",
//           "fri": "Closed",
//           "sat": "10:00AM - 10:00PM",
//           "sun": "10:00AM - 10:00PM",
//         },
//       ),
//       Shop(
//         nameKey: "tawasulAll",
//         addressKey: "shariAlQayrawanBenghaziLibya",
//         phone: "+218915559800",
//         email: "Wekalat.shop@tawasul-world.com",
//         scheduleKeys: {
//           "mon": "09:00AM - 07:00PM",
//           "tue": "09:00AM - 07:00PM",
//           "wed": "09:00AM - 07:00PM",
//           "thu": "09:00AM - 07:00PM",
//           "fri": "Closed",
//           "sat": "10:00AM - 04:00PM",
//           "sun": "10:00AM - 04:00PM",
//         },
//       ),
//       Shop(
//         nameKey: "tawasulSamsung",
//         addressKey: "benghaziLibya",
//         phone: "",
//         email: "",
//         scheduleKeys: {
//           "mon": "09:30AM - 09:30PM",
//           "tue": "09:30AM - 09:30PM",
//           "wed": "09:30AM - 09:30PM",
//           "thu": "09:30AM - 09:30PM",
//           "fri": "Closed",
//           "sat": "09:30AM - 09:30PM",
//           "sun": "09:30AM - 09:30PM",
//         },
//       ),
//       Shop(
//         nameKey: "tawasulSamsung",
//         addressKey: "veniceBenghaziLibya",
//         phone: "+218923071800",
//         email: "Samsungvenicia.shop@tawasul-libya.com",
//         scheduleKeys: {
//           "mon": "09:30AM - 09:30PM",
//           "tue": "09:30AM - 09:30PM",
//           "wed": "09:30AM - 09:30PM",
//           "thu": "09:30AM - 09:30PM",
//           "fri": "Closed",
//           "sat": "09:30AM - 09:30PM",
//           "sun": "09:30AM - 09:30PM",
//         },
//       ),
//       Shop(
//         nameKey: "tawasulAll",
//         addressKey: "almadarStreetSertLibya",
//         phone: "+218915559700",
//         email: "Sirt.shop@tawasul-world.com",
//         scheduleKeys: {
//           "mon": "11:00AM - 09:00PM",
//           "tue": "11:00AM - 09:00PM",
//           "wed": "11:00AM - 09:00PM",
//           "thu": "11:00AM - 09:00PM",
//           "fri": "Closed",
//           "sat": "11:00AM - 09:00PM",
//           "sun": "11:00AM - 09:00PM",
//         },
//       ),
//       Shop(
//         nameKey: "tawasulApple",
//         addressKey: "qadisiyahSquareTripoliLibya",
//         phone: "+218922559100",
//         email: "Appleqadisya.shop@tawasul-world.com",
//         scheduleKeys: {
//           "mon": "10:30AM - 09:30PM",
//           "tue": "10:30AM - 09:30PM",
//           "wed": "10:30AM - 09:30PM",
//           "thu": "10:30AM - 09:30PM",
//           "fri": "Closed",
//           "sat": "10:30AM - 09:30PM",
//           "sun": "10:30AM - 09:30PM",
//         },
//       ),
//       Shop(
//         nameKey: "tawasulHuawei",
//         addressKey: "binAshourStreetTripoliLibya",
//         phone: "+218915559900",
//         email: "Benashour.shop@tawasul-world.com",
//         scheduleKeys: {
//           "mon": "10:00AM - 09:30PM",
//           "tue": "10:00AM - 09:30PM",
//           "wed": "10:00AM - 09:30PM",
//           "thu": "10:00AM - 09:30PM",
//           "fri": "Closed",
//           "sat": "10:00AM - 09:30PM",
//           "sun": "10:00AM - 09:30PM",
//         },
//       ),
//       Shop(
//         nameKey: "tawasulXiaomi",
//         addressKey: "awladBinAlHajStreetTripoliLibya",
//         phone: "+218915559100",
//         email: "Xiaomisoqjumaa.shop@tawasul-world.com",
//         scheduleKeys: {
//           "mon": "10:00AM - 10:00PM",
//           "tue": "10:00AM - 10:00PM",
//           "wed": "10:00AM - 10:00PM",
//           "thu": "10:00AM - 10:00PM",
//           "fri": "Closed",
//           "sat": "10:00AM - 10:00PM",
//           "sun": "10:00AM - 10:00PM",
//         },
//       ),
//       Shop(
//         nameKey: "tawasulAll",
//         addressKey: "alJarabaMallTripoliLibya",
//         phone: "+218915559600",
//         email: "Jrabamall.shop@tawasul-world.com",
//         scheduleKeys: {
//           "mon": "10:00AM - 10:00PM",
//           "tue": "10:00AM - 10:00PM",
//           "wed": "10:00AM - 10:00PM",
//           "thu": "10:00AM - 10:00PM",
//           "fri": "04:00AM - 09:30PM",
//           "sat": "10:00AM - 10:00PM",
//           "sun": "10:00AM - 10:00PM",
//         },
//       ),
//       Shop(
//         nameKey: "tawasulXiaomi",
//         addressKey: "grandMallTripoliLibya",
//         phone: "+218913844320",
//         email: "Xiaomiainzara.shop@tawasul-world.com",
//         scheduleKeys: {
//           "mon": "10:30AM - 10:00PM",
//           "tue": "10:30AM - 10:00PM",
//           "wed": "10:30AM - 10:00PM",
//           "thu": "10:30AM - 10:00PM",
//           "fri": "05:00AM - 10:00PM",
//           "sat": "10:30AM - 10:00PM",
//           "sun": "10:30AM - 10:00PM",
//         },
//       ),
//       Shop(
//         nameKey: "tawasulSamsung",
//         addressKey: "tripoliStreetTripoliLibya",
//         phone: "+218923071900",
//         email: "Samsungjumhoria.shop@tawasul-libya.com",
//         scheduleKeys: {
//           "mon": "09:00AM - 09:00PM",
//           "tue": "09:00AM - 09:00PM",
//           "wed": "09:00AM - 09:00PM",
//           "thu": "09:00AM - 09:00PM",
//           "fri": "Closed",
//           "sat": "09:00AM - 09:00PM",
//           "sun": "09:00AM - 09:00PM",
//         },
//       ),
//       Shop(
//         nameKey: "tawasulSamsung",
//         addressKey: "regataVillageTripoliLibya",
//         phone: "+218923071900",
//         email: "Samsungsiahya.shop@tawasul-libya.com",
//         scheduleKeys: {
//           "mon": "11:00AM - 09:00PM",
//           "tue": "11:00AM - 09:00PM",
//           "wed": "11:00AM - 09:00PM",
//           "thu": "11:00AM - 09:00PM",
//           "fri": "Closed",
//           "sat": "11:00AM - 09:00PM",
//           "sun": "11:00AM - 09:00PM",
//         },
//       ),
//       Shop(
//         nameKey: "tawasulApple",
//         addressKey: "tripoliStreetTripoliLibya",
//         phone: "+218922559200",
//         email: "Appletripolistreet.shop@tawasul-world.com",
//         scheduleKeys: {
//           "mon": "10:30AM - 09:30PM",
//           "tue": "10:30AM - 09:30PM",
//           "wed": "10:30AM - 09:30PM",
//           "thu": "10:30AM - 09:30PM",
//           "fri": "Closed",
//           "sat": "10:30AM - 09:30PM",
//           "sun": "10:30AM - 09:30PM",
//         },
//       ),
//       Shop(
//         nameKey: "tawasulAll",
//         addressKey: "investmentMarketMisurataLibya",
//         phone: "+218915559400",
//         email: "Sanaastreet.shop@tawasul-world.com",
//         scheduleKeys: {
//           "mon": "10:30AM - 09:30PM",
//           "tue": "10:30AM - 09:30PM",
//           "wed": "10:30AM - 09:30PM",
//           "thu": "10:30AM - 09:30PM",
//           "fri": "Closed",
//           "sat": "10:30AM - 09:30PM",
//           "sun": "10:30AM - 09:30PM",
//         },
//       ),
//       Shop(
//         nameKey: "tawasulAll",
//         addressKey: "alMurqubDistrictMisurataLibya",
//         phone: "+218915559300",
//         email: "Mgawbaa.shop@tawasul-world.com",
//         scheduleKeys: {
//           "mon": "10:30AM - 09:30PM",
//           "tue": "10:30AM - 09:30PM",
//           "wed": "10:30AM - 09:30PM",
//           "thu": "10:30AM - 09:30PM",
//           "fri": "Closed",
//           "sat": "10:30AM - 09:30PM",
//           "sun": "10:30AM - 09:30PM",
//         },
//       ),
//       Shop(
//         nameKey: "tawasulSamsung",
//         addressKey: "aldisStreetMisurataLibya",
//         phone: "+218923073600",
//         email: "Samsungdiees.shop@tawasul-libya.com",
//         scheduleKeys: {
//           "mon": "10:30AM - 09:30PM",
//           "tue": "10:30AM - 09:30PM",
//           "wed": "10:30AM - 09:30PM",
//           "thu": "10:30AM - 09:30PM",
//           "fri": "Closed",
//           "sat": "10:30AM - 09:30PM",
//           "sun": "10:30AM - 09:30PM",
//         },
//       ),
//     ];
//   }

//   @override
//   Widget build(BuildContext context) {
//     final loc = AppLocalizations.of(context)!;

//     return Scaffold(
//       backgroundColor: const Color(0xFFF5F6FA),
//       appBar: PreferredSize(
//         preferredSize: Size.fromHeight(kToolbarHeight + 30.h),
//         child: Padding(
//           padding: EdgeInsets.only(top: 15.h),
//           child: AppBar(
//             backgroundColor: const Color(0xFFF5F6FA),
//             elevation: 0,
//             leadingWidth: 50.w,
//             leading: Padding(
//               padding: EdgeInsets.only(
//                 left:
//                     Directionality.of(context) == TextDirection.rtl ? 0 : 12.w,
//                 right:
//                     Directionality.of(context) == TextDirection.rtl ? 12.w : 0,
//               ),
//               child: GestureDetector(
//                 onTap:
//                     () => Navigator.push(
//                       context,
//                       MaterialPageRoute(builder: (context) => HomePage()),
//                     ),
//                 child: Container(
//                   width: 35.w,
//                   height: 35.w,
//                   alignment: Alignment.center,
//                   decoration: const BoxDecoration(
//                     color: Color(0xFF0984E3),
//                     shape: BoxShape.circle,
//                   ),
//                   child: const Icon(
//                     Icons.arrow_back_ios_new,
//                     color: Colors.white,
//                     size: 16,
//                   ),
//                 ),
//               ),
//             ),
//             centerTitle: true,
//             title: Text(
//               loc.findTawasul,
//               style: TextStyle(
//                 color: Colors.black87,
//                 fontWeight: FontWeight.w600,
//                 fontSize: 16.sp,
//               ),
//             ),
//           ),
//         ),
//       ),
//       body: Padding(
//         padding: EdgeInsets.only(left: 12.w, right: 12.w, bottom: 12.w),
//         child: ListView.separated(
//           itemCount: shops.length,
//           separatorBuilder: (context, index) => SizedBox(height: 12.h),
//           itemBuilder: (context, index) {
//             final shop = shops[index];
//             return Container(
//               padding: EdgeInsets.all(14.w),
//               decoration: BoxDecoration(
//                 color: Colors.white,
//                 borderRadius: BorderRadius.circular(12.r),
//                 boxShadow: [
//                   BoxShadow(
//                     color: Colors.black12,
//                     blurRadius: 4,
//                     offset: const Offset(0, 2),
//                   ),
//                 ],
//               ),
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   /// Title + Expand icon
//                   Row(
//                     mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                     children: [
//                       Text(
//                         loc.getString(shop.nameKey),
//                         style: TextStyle(
//                           fontSize: 14.sp,
//                           fontWeight: FontWeight.bold,
//                           color: Colors.black87,
//                         ),
//                       ),
//                       IconButton(
//                         icon: Icon(
//                           shop.isExpanded
//                               ? Icons.keyboard_arrow_up
//                               : Icons.keyboard_arrow_down,
//                           color: Colors.black54,
//                         ),
//                         onPressed: () {
//                           setState(() {
//                             shop.isExpanded = !shop.isExpanded;
//                           });
//                         },
//                       ),
//                     ],
//                   ),
//                   SizedBox(height: 6.h),

//                   /// addressKey with icon
//                   Row(
//                     children: [
//                       const Icon(
//                         Icons.place,
//                         size: 18,
//                         color: Colors.redAccent,
//                       ),
//                       SizedBox(width: 6.w),
//                       Expanded(
//                         child: Text(
//                           loc.getString(shop.addressKey),
//                           style: TextStyle(
//                             fontSize: 13.sp,
//                             color: Colors.black54,
//                           ),
//                         ),
//                       ),
//                     ],
//                   ),
//                   SizedBox(height: 6.h),

//                   /// Phone with icon
//                   if (shop.phone.isNotEmpty)
//                     Row(
//                       children: [
//                         const Icon(Icons.phone, size: 18, color: Colors.green),
//                         SizedBox(width: 6.w),
//                         Text(
//                           shop.phone,
//                           style: TextStyle(
//                             fontSize: 13.sp,
//                             color: Colors.black54,
//                           ),
//                         ),
//                       ],
//                     ),
//                   SizedBox(height: 6.h),

//                   /// Email with icon
//                   if (shop.email.isNotEmpty)
//                     Row(
//                       children: [
//                         const Icon(Icons.email, size: 18, color: Colors.blue),
//                         SizedBox(width: 6.w),
//                         Expanded(
//                           child: Text(
//                             shop.email,
//                             style: TextStyle(
//                               fontSize: 13.sp,
//                               color: Colors.blue,
//                             ),
//                           ),
//                         ),
//                       ],
//                     ),

//                   if (shop.isExpanded) ...[
//                     SizedBox(height: 10.h),
//                     Divider(color: Colors.grey[300]),
//                     ...shop.scheduleKeys.entries.map(
//                       (entry) => Padding(
//                         padding: EdgeInsets.symmetric(vertical: 2.h),
//                         child: Row(
//                           mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                           children: [
//                             Text(
//                               loc.getString(entry.key),
//                               style: TextStyle(
//                                 fontWeight: FontWeight.w600,
//                                 fontSize: 13.sp,
//                                 color:
//                                     entry.key == "fri"
//                                         ? Colors.red
//                                         : Colors.black87,
//                               ),
//                             ),
//                             Text(
//                               entry.value,
//                               style: TextStyle(fontSize: 13.sp),
//                             ),
//                           ],
//                         ),
//                       ),
//                     ),
//                   ],
//                 ],
//               ),
//             );
//           },
//         ),
//       ),
//     );
//   }
// }

// extension LocalizationHelper on AppLocalizations {
//   String getString(String key) {
//     final translations = {
//       "findTawasul": findTawasul,
//       "tawasulAll": tawasulAll,
//       "tawasulApple": tawasulApple,
//       "tawasulXiaomi": tawasulXiaomi,
//       "tawasulSamsung": tawasulSamsung,
//       "tawasulHuawei": tawasulHuawei,
//       "streetAlKhototAlBaidaLibya": streetAlKhototAlBaidaLibya,
//       "veniceBenghaziLibya": veniceBenghaziLibya,
//       "benghaziLibya": benghaziLibya,
//       "shariAlQayrawanBenghaziLibya": shariAlQayrawanBenghaziLibya,
//       "almadarStreetSertLibya": almadarStreetSertLibya,
//       "qadisiyahSquareTripoliLibya": qadisiyahSquareTripoliLibya,
//       "binAshourStreetTripoliLibya": binAshourStreetTripoliLibya,
//       "awladBinAlHajStreetTripoliLibya": awladBinAlHajStreetTripoliLibya,
//       "alJarabaMallTripoliLibya": alJarabaMallTripoliLibya,
//       "grandMallTripoliLibya": grandMallTripoliLibya,
//       "regataVillageTripoliLibya": regataVillageTripoliLibya,
//       "tripoliStreetTripoliLibya": tripoliStreetTripoliLibya,
//       "investmentMarketMisurataLibya": investmentMarketMisurataLibya,
//       "alMurqubDistrictMisurataLibya": alMurqubDistrictMisurataLibya,
//       "aldisStreetMisurataLibya": aldisStreetMisurataLibya,
//       "mon": mon,
//       "tue": tue,
//       "wed": wed,
//       "thu": thu,
//       "fri": fri,
//       "sat": sat,
//       "sun": sun,
//     };
//     return translations[key] ?? key;
//   }
// }

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:tawasul_application/view/home_page.dart';

class Shop {
  final String nameKey;
  final String addressKey;
  final String phone;
  final String email;
  final Map<String, String> scheduleKeys;
  bool isExpanded;

  Shop({
    required this.nameKey,
    required this.addressKey,
    required this.phone,
    required this.email,
    required this.scheduleKeys,
    this.isExpanded = false,
  });
}

class FindTawasul extends StatefulWidget {
  @override
  _FindTawasulState createState() => _FindTawasulState();
}

class _FindTawasulState extends State<FindTawasul> {
  late final List<Shop> shops;

  @override
  void initState() {
    super.initState();
    shops = [
      Shop(
        nameKey: "tawasulAll",
        addressKey: "streetAlKhototAlBaidaLibya",
        phone: "+218922559400",
        email: "Albaidaa.shop@tawasul-world.com",
        scheduleKeys: {
          "mon": "10:30AM - 09:00PM",
          "tue": "10:30AM - 09:00PM",
          "wed": "10:30AM - 09:00PM",
          "thu": "10:30AM - 09:00PM",
          "fri": "Closed",
          "sat": "10:30AM - 09:00PM",
          "sun": "10:30AM - 09:00PM",
        },
      ),
      Shop(
        nameKey: "tawasulApple",
        addressKey: "veniceBenghaziLibya",
        phone: "+218922559300",
        email: "applealijud.shop@tawasul-world.com",
        scheduleKeys: {
          "mon": "09:30AM - 09:30PM",
          "tue": "09:30AM - 09:30PM",
          "wed": "09:30AM - 09:30PM",
          "thu": "09:30AM - 09:30PM",
          "fri": "Closed",
          "sat": "09:30AM - 09:30PM",
          "sun": "09:30AM - 09:30PM",
        },
      ),
      Shop(
        nameKey: "tawasulXiaomi",
        addressKey: "benghaziLibya",
        phone: "+218915558900",
        email: "Xiaomivenicia.shop@tawasul-world.com",
        scheduleKeys: {
          "mon": "10:00AM - 10:00PM",
          "tue": "10:00AM - 10:00PM",
          "wed": "10:00AM - 10:00PM",
          "thu": "10:00AM - 10:00PM",
          "fri": "Closed",
          "sat": "10:00AM - 10:00PM",
          "sun": "10:00AM - 10:00PM",
        },
      ),
      Shop(
        nameKey: "tawasulAll",
        addressKey: "shariAlQayrawanBenghaziLibya",
        phone: "+218915559800",
        email: "Wekalat.shop@tawasul-world.com",
        scheduleKeys: {
          "mon": "09:00AM - 07:00PM",
          "tue": "09:00AM - 07:00PM",
          "wed": "09:00AM - 07:00PM",
          "thu": "09:00AM - 07:00PM",
          "fri": "Closed",
          "sat": "10:00AM - 04:00PM",
          "sun": "10:00AM - 04:00PM",
        },
      ),
      Shop(
        nameKey: "tawasulSamsung",
        addressKey: "benghaziLibya",
        phone: "",
        email: "",
        scheduleKeys: {
          "mon": "09:30AM - 09:30PM",
          "tue": "09:30AM - 09:30PM",
          "wed": "09:30AM - 09:30PM",
          "thu": "09:30AM - 09:30PM",
          "fri": "Closed",
          "sat": "09:30AM - 09:30PM",
          "sun": "09:30AM - 09:30PM",
        },
      ),
      Shop(
        nameKey: "tawasulSamsung",
        addressKey: "veniceBenghaziLibya",
        phone: "+218923071800",
        email: "Samsungvenicia.shop@tawasul-libya.com",
        scheduleKeys: {
          "mon": "09:30AM - 09:30PM",
          "tue": "09:30AM - 09:30PM",
          "wed": "09:30AM - 09:30PM",
          "thu": "09:30AM - 09:30PM",
          "fri": "Closed",
          "sat": "09:30AM - 09:30PM",
          "sun": "09:30AM - 09:30PM",
        },
      ),
      Shop(
        nameKey: "tawasulAll",
        addressKey: "almadarStreetSertLibya",
        phone: "+218915559700",
        email: "Sirt.shop@tawasul-world.com",
        scheduleKeys: {
          "mon": "11:00AM - 09:00PM",
          "tue": "11:00AM - 09:00PM",
          "wed": "11:00AM - 09:00PM",
          "thu": "11:00AM - 09:00PM",
          "fri": "Closed",
          "sat": "11:00AM - 09:00PM",
          "sun": "11:00AM - 09:00PM",
        },
      ),
      Shop(
        nameKey: "tawasulApple",
        addressKey: "qadisiyahSquareTripoliLibya",
        phone: "+218922559100",
        email: "Appleqadisya.shop@tawasul-world.com",
        scheduleKeys: {
          "mon": "10:30AM - 09:30PM",
          "tue": "10:30AM - 09:30PM",
          "wed": "10:30AM - 09:30PM",
          "thu": "10:30AM - 09:30PM",
          "fri": "Closed",
          "sat": "10:30AM - 09:30PM",
          "sun": "10:30AM - 09:30PM",
        },
      ),
      Shop(
        nameKey: "tawasulHuawei",
        addressKey: "binAshourStreetTripoliLibya",
        phone: "+218915559900",
        email: "Benashour.shop@tawasul-world.com",
        scheduleKeys: {
          "mon": "10:00AM - 09:30PM",
          "tue": "10:00AM - 09:30PM",
          "wed": "10:00AM - 09:30PM",
          "thu": "10:00AM - 09:30PM",
          "fri": "Closed",
          "sat": "10:00AM - 09:30PM",
          "sun": "10:00AM - 09:30PM",
        },
      ),
      Shop(
        nameKey: "tawasulXiaomi",
        addressKey: "awladBinAlHajStreetTripoliLibya",
        phone: "+218915559100",
        email: "Xiaomisoqjumaa.shop@tawasul-world.com",
        scheduleKeys: {
          "mon": "10:00AM - 10:00PM",
          "tue": "10:00AM - 10:00PM",
          "wed": "10:00AM - 10:00PM",
          "thu": "10:00AM - 10:00PM",
          "fri": "Closed",
          "sat": "10:00AM - 10:00PM",
          "sun": "10:00AM - 10:00PM",
        },
      ),
      Shop(
        nameKey: "tawasulAll",
        addressKey: "alJarabaMallTripoliLibya",
        phone: "+218915559600",
        email: "Jrabamall.shop@tawasul-world.com",
        scheduleKeys: {
          "mon": "10:00AM - 10:00PM",
          "tue": "10:00AM - 10:00PM",
          "wed": "10:00AM - 10:00PM",
          "thu": "10:00AM - 10:00PM",
          "fri": "04:00AM - 09:30PM",
          "sat": "10:00AM - 10:00PM",
          "sun": "10:00AM - 10:00PM",
        },
      ),
      Shop(
        nameKey: "tawasulXiaomi",
        addressKey: "grandMallTripoliLibya",
        phone: "+218913844320",
        email: "Xiaomiainzara.shop@tawasul-world.com",
        scheduleKeys: {
          "mon": "10:30AM - 10:00PM",
          "tue": "10:30AM - 10:00PM",
          "wed": "10:30AM - 10:00PM",
          "thu": "10:30AM - 10:00PM",
          "fri": "05:00AM - 10:00PM",
          "sat": "10:30AM - 10:00PM",
          "sun": "10:30AM - 10:00PM",
        },
      ),
      Shop(
        nameKey: "tawasulSamsung",
        addressKey: "tripoliStreetTripoliLibya",
        phone: "+218923071900",
        email: "Samsungjumhoria.shop@tawasul-libya.com",
        scheduleKeys: {
          "mon": "09:00AM - 09:00PM",
          "tue": "09:00AM - 09:00PM",
          "wed": "09:00AM - 09:00PM",
          "thu": "09:00AM - 09:00PM",
          "fri": "Closed",
          "sat": "09:00AM - 09:00PM",
          "sun": "09:00AM - 09:00PM",
        },
      ),
      Shop(
        nameKey: "tawasulSamsung",
        addressKey: "regataVillageTripoliLibya",
        phone: "+218923071900",
        email: "Samsungsiahya.shop@tawasul-libya.com",
        scheduleKeys: {
          "mon": "11:00AM - 09:00PM",
          "tue": "11:00AM - 09:00PM",
          "wed": "11:00AM - 09:00PM",
          "thu": "11:00AM - 09:00PM",
          "fri": "Closed",
          "sat": "11:00AM - 09:00PM",
          "sun": "11:00AM - 09:00PM",
        },
      ),
      Shop(
        nameKey: "tawasulApple",
        addressKey: "tripoliStreetTripoliLibya",
        phone: "+218922559200",
        email: "Appletripolistreet.shop@tawasul-world.com",
        scheduleKeys: {
          "mon": "10:30AM - 09:30PM",
          "tue": "10:30AM - 09:30PM",
          "wed": "10:30AM - 09:30PM",
          "thu": "10:30AM - 09:30PM",
          "fri": "Closed",
          "sat": "10:30AM - 09:30PM",
          "sun": "10:30AM - 09:30PM",
        },
      ),
      Shop(
        nameKey: "tawasulAll",
        addressKey: "investmentMarketMisurataLibya",
        phone: "+218915559400",
        email: "Sanaastreet.shop@tawasul-world.com",
        scheduleKeys: {
          "mon": "10:30AM - 09:30PM",
          "tue": "10:30AM - 09:30PM",
          "wed": "10:30AM - 09:30PM",
          "thu": "10:30AM - 09:30PM",
          "fri": "Closed",
          "sat": "10:30AM - 09:30PM",
          "sun": "10:30AM - 09:30PM",
        },
      ),
      Shop(
        nameKey: "tawasulAll",
        addressKey: "alMurqubDistrictMisurataLibya",
        phone: "+218915559300",
        email: "Mgawbaa.shop@tawasul-world.com",
        scheduleKeys: {
          "mon": "10:30AM - 09:30PM",
          "tue": "10:30AM - 09:30PM",
          "wed": "10:30AM - 09:30PM",
          "thu": "10:30AM - 09:30PM",
          "fri": "Closed",
          "sat": "10:30AM - 09:30PM",
          "sun": "10:30AM - 09:30PM",
        },
      ),
      Shop(
        nameKey: "tawasulSamsung",
        addressKey: "aldisStreetMisurataLibya",
        phone: "+218923073600",
        email: "Samsungdiees.shop@tawasul-libya.com",
        scheduleKeys: {
          "mon": "10:30AM - 09:30PM",
          "tue": "10:30AM - 09:30PM",
          "wed": "10:30AM - 09:30PM",
          "thu": "10:30AM - 09:30PM",
          "fri": "Closed",
          "sat": "10:30AM - 09:30PM",
          "sun": "10:30AM - 09:30PM",
        },
      ),
    ];
  }

  Widget _buildShopTypeIndicator(String shopTypeKey, BuildContext context) {
    final loc = AppLocalizations.of(context)!;
    final shopType = loc.getString(shopTypeKey);
    Color backgroundColor;
    Color textColor;

    switch (shopTypeKey) {
      case "tawasulApple":
        backgroundColor = Color(0xFF3674B5);
        textColor = Colors.white;
        break;
      case "tawasulSamsung":
        backgroundColor = Color(0xFFA1E3F9);
        textColor = Colors.white;
        break;
      case "tawasulXiaomi":
        backgroundColor = Color.fromARGB(255, 147, 141, 146);
        textColor = Colors.white;
        break;
      case "tawasulHuawei":
        backgroundColor = Color(0xFFDCC5B2);
        textColor = Colors.white;
        break;
      default:
        backgroundColor = Color.fromARGB(222, 7, 7, 149);
        textColor = Colors.white;
    }

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 4.h),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(20.r),
      ),
      child: Text(
        shopType,
        style: TextStyle(
          color: textColor,
          fontSize: 10.sp,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }

  Widget _buildInfoRow(
    IconData icon,
    Color color,
    String text, {
    bool isEmail = false,
  }) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 4.h),
      child: Row(
        children: [
          Container(
            width: 28.w,
            height: 28.w,
            decoration: BoxDecoration(
              color: color.withOpacity(0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(icon, size: 14.sp, color: color),
          ),
          SizedBox(width: 12.w),
          Expanded(
            child:
                isEmail
                    ? GestureDetector(
                      onTap: () {
                        // Add email functionality here
                      },
                      child: Text(
                        text,
                        style: TextStyle(
                          fontSize: 13.sp,
                          color: color,
                          decoration: TextDecoration.underline,
                        ),
                      ),
                    )
                    : GestureDetector(
                      onTap: () {
                        // Add phone functionality here
                      },
                      child: Text(
                        text,
                        style: TextStyle(
                          fontSize: 13.sp,
                          color: Colors.black87,
                        ),
                      ),
                    ),
          ),
        ],
      ),
    );
  }

  Widget _buildScheduleItem(String day, String time, BuildContext context) {
    final loc = AppLocalizations.of(context)!;
    final isClosed = time.toLowerCase() == "closed";

    return Container(
      margin: EdgeInsets.only(bottom: 8.h),
      padding: EdgeInsets.all(12.w),
      decoration: BoxDecoration(
        color: Colors.grey[50],
        borderRadius: BorderRadius.circular(10.r),
        border: Border.all(
          color:
              isClosed
                  ? Colors.red.withOpacity(0.3)
                  : Colors.grey.withOpacity(0.3),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            loc.getString(day),
            style: TextStyle(
              fontWeight: FontWeight.w600,
              fontSize: 13.sp,
              color: isClosed ? Colors.red : Colors.black87,
            ),
          ),
          Text(
            time,
            style: TextStyle(
              fontSize: 13.sp,
              fontWeight: FontWeight.w500,
              color: isClosed ? Colors.red : const Color(0xFF0984E3),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final loc = AppLocalizations.of(context)!;

    return Scaffold(
      backgroundColor: const Color(0xFFF5F6FA),
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(kToolbarHeight + 30.h),
        child: Padding(
          padding: EdgeInsets.only(top: 15.h),
          child: AppBar(
            backgroundColor: const Color(0xFFF5F6FA),
            elevation: 0,
            leadingWidth: 50.w,
            leading: Padding(
              padding: EdgeInsets.only(
                left:
                    Directionality.of(context) == TextDirection.rtl ? 0 : 12.w,
                right:
                    Directionality.of(context) == TextDirection.rtl ? 12.w : 0,
              ),
              child: GestureDetector(
                onTap:
                    () => Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => HomePage()),
                    ),
                child: Container(
                  width: 35.w,
                  height: 35.w,
                  alignment: Alignment.center,
                  decoration: const BoxDecoration(
                    color: Color(0xFF0984E3),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.arrow_back_ios_new,
                    color: Colors.white,
                    size: 16,
                  ),
                ),
              ),
            ),
            centerTitle: true,
            title: Text(
              loc.findTawasul,
              style: TextStyle(
                color: Colors.black87,
                fontWeight: FontWeight.w600,
                fontSize: 16.sp,
              ),
            ),
          ),
        ),
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
        child: ListView.separated(
          itemCount: shops.length,
          separatorBuilder: (context, index) => SizedBox(height: 16.h),
          itemBuilder: (context, index) {
            final shop = shops[index];
            return AnimatedContainer(
              duration: const Duration(milliseconds: 300),
              curve: Curves.easeInOut,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16.r),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.08),
                    blurRadius: 12,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Material(
                color: Colors.transparent,
                child: InkWell(
                  borderRadius: BorderRadius.circular(16.r),
                  onTap: () {
                    setState(() {
                      shop.isExpanded = !shop.isExpanded;
                    });
                  },
                  child: Padding(
                    padding: EdgeInsets.all(16.w),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Header with shop type and expand icon
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            _buildShopTypeIndicator(shop.nameKey, context),
                            AnimatedRotation(
                              duration: const Duration(milliseconds: 300),
                              turns: shop.isExpanded ? 0.5 : 0,
                              child: Icon(
                                Icons.keyboard_arrow_down_rounded,
                                color: Colors.grey[600],
                                size: 24.sp,
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 12.h),

                        // Shop address
                        _buildInfoRow(
                          Icons.location_on_rounded,
                          Colors.red,
                          loc.getString(shop.addressKey),
                        ),

                        // Phone number
                        if (shop.phone.isNotEmpty)
                          _buildInfoRow(
                            Icons.phone_rounded,
                            Colors.green,
                            shop.phone,
                          ),

                        // Email
                        if (shop.email.isNotEmpty)
                          _buildInfoRow(
                            Icons.email_rounded,
                            Colors.blue,
                            shop.email,
                            isEmail: true,
                          ),

                        // Expanded schedule section
                        if (shop.isExpanded) ...[
                          SizedBox(height: 16.h),
                          Divider(color: Colors.grey[300]),
                          SizedBox(height: 12.h),

                          Text(
                            loc.workingHours,
                            style: TextStyle(
                              fontSize: 14.sp,
                              fontWeight: FontWeight.bold,
                              color: Colors.black87,
                            ),
                          ),
                          SizedBox(height: 12.h),

                          Column(
                            children:
                                shop.scheduleKeys.entries
                                    .map(
                                      (entry) => _buildScheduleItem(
                                        entry.key,
                                        entry.value,
                                        context,
                                      ),
                                    )
                                    .toList(),
                          ),
                        ],
                      ],
                    ),
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}

extension LocalizationHelper on AppLocalizations {
  String getString(String key) {
    final translations = {
      "findTawasul": findTawasul,
      "tawasulAll": tawasulAll,
      "tawasulApple": tawasulApple,
      "tawasulXiaomi": tawasulXiaomi,
      "tawasulSamsung": tawasulSamsung,
      "tawasulHuawei": tawasulHuawei,
      "streetAlKhototAlBaidaLibya": streetAlKhototAlBaidaLibya,
      "veniceBenghaziLibya": veniceBenghaziLibya,
      "benghaziLibya": benghaziLibya,
      "shariAlQayrawanBenghaziLibya": shariAlQayrawanBenghaziLibya,
      "almadarStreetSertLibya": almadarStreetSertLibya,
      "qadisiyahSquareTripoliLibya": qadisiyahSquareTripoliLibya,
      "binAshourStreetTripoliLibya": binAshourStreetTripoliLibya,
      "awladBinAlHajStreetTripoliLibya": awladBinAlHajStreetTripoliLibya,
      "alJarabaMallTripoliLibya": alJarabaMallTripoliLibya,
      "grandMallTripoliLibya": grandMallTripoliLibya,
      "regataVillageTripoliLibya": regataVillageTripoliLibya,
      "tripoliStreetTripoliLibya": tripoliStreetTripoliLibya,
      "investmentMarketMisurataLibya": investmentMarketMisurataLibya,
      "alMurqubDistrictMisurataLibya": alMurqubDistrictMisurataLibya,
      "aldisStreetMisurataLibya": aldisStreetMisurataLibya,
      "mon": mon,
      "tue": tue,
      "wed": wed,
      "thu": thu,
      "fri": fri,
      "sat": sat,
      "sun": sun,
      "workingHours": workingHours,
    };

    return translations[key] ?? key;
  }

  // Add this getter for working hours title
  String get workingHours {
    // You'll need to add this key to your ARB files
    // For now, returning a default value
    return "Working Hours";
  }
}
