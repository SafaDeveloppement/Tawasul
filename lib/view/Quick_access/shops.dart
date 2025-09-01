// // import 'package:flutter/material.dart';
// // import 'package:flutter_screenutil/flutter_screenutil.dart';
// // import 'package:tawasul_application/view/home_page.dart';

// // class Shop {
// //   final String name;
// //   final String address;
// //   final String phone;
// //   final String email;
// //   final Map<String, String> schedule;
// //   bool isExpanded;

// //   Shop({
// //     required this.name,
// //     required this.address,
// //     required this.phone,
// //     required this.email,
// //     required this.schedule,
// //     this.isExpanded = false,
// //   });
// // }

// // class FindTawasul extends StatefulWidget {
// //   @override
// //   _FindTawasulState createState() => _FindTawasulState();
// // }

// // class _FindTawasulState extends State<FindTawasul> {
// //   final List<Shop> shops = [
// //     Shop(
// //       name: "Tawasul All",
// //       address: "Street Al Khotot, Al Baida, Libya",
// //       phone: "+218922559400",
// //       email: "Albaidaa.shop@tawasul-world.com",
// //       schedule: {
// //         "Mon": "10:30AM - 09:00PM",
// //         "Tue": "10:30AM - 09:00PM",
// //         "Wed": "10:30AM - 09:00PM",
// //         "Thu": "10:30AM - 09:00PM",
// //         "Fri": "Closed",
// //         "Sat": "10:30AM - 09:00PM",
// //         "Sun": "10:30AM - 09:00PM",
// //       },
// //     ),
// //     Shop(
// //       name: "Tawasul Apple",
// //       address: "Venice, Benghazi, Libya",
// //       phone: "+218922559300",
// //       email: "applealijud.shop@tawasul-world.com",
// //       schedule: {
// //         "Mon": "09:30AM - 09:30PM",
// //         "Tue": "09:30AM - 09:30PM",
// //         "Wed": "09:30AM - 09:30PM",
// //         "Thu": "09:30AM - 09:30PM",
// //         "Fri": "Closed",
// //         "Sat": "09:30AM - 09:30PM",
// //         "Sun": "09:30AM - 09:30PM",
// //       },
// //     ),
// //     Shop(
// //       name: "Tawasul Xiaomi",
// //       address: "Benghazi, Libya",
// //       phone: "+218915558900",
// //       email: "Xiaomivenicia.shop@tawasul-world.com",
// //       schedule: {
// //         "Mon": "10:00AM - 10:00PM",
// //         "Tue": "10:00AM - 10:00PM",
// //         "Wed": "10:00AM - 10:00PM",
// //         "Thu": "10:00AM - 10:00PM",
// //         "Fri": "Closed",
// //         "Sat": "10:00AM - 10:00PM",
// //         "Sun": "10:00AM - 10:00PM",
// //       },
// //     ),
// //     Shop(
// //       name: "Tawasul All",
// //       address: "Shari Al Qayrawan, Benghazi, Libya",
// //       phone: "+218915559800",
// //       email: "Wekalat.shop@tawasul-world.com",
// //       schedule: {
// //         "Mon": "09:00AM - 07:00PM",
// //         "Tue": "09:00AM - 07:00PM",
// //         "Wed": "09:00AM - 07:00PM",
// //         "Thu": "09:00AM - 07:00PM",
// //         "Fri": "Closed",
// //         "Sat": "10:00AM - 04:00PM",
// //         "Sun": "10:00AM - 04:00PM",
// //       },
// //     ),
// //     Shop(
// //       name: "Tawasul Samsung",
// //       address: "Street Al-Riwayat ard Ben Ali, Benghazi, Libya",
// //       phone: "",
// //       email: "",
// //       schedule: {
// //         "Mon": "09:30AM - 09:30PM",
// //         "Tue": "09:30AM - 09:30PM",
// //         "Wed": "09:30AM - 09:30PM",
// //         "Thu": "09:30AM - 09:30PM",
// //         "Fri": "Closed",
// //         "Sat": "09:30AM - 09:30PM",
// //         "Sun": "09:30AM - 09:30PM",
// //       },
// //     ),
// //     Shop(
// //       name: "Tawasul Samsung",
// //       address: "Venice, Benghazi, Libya",
// //       phone: "+218923071800",
// //       email: "Samsungvenicia.shop@tawasul-libya.com",
// //       schedule: {
// //         "Mon": "09:30AM - 09:30PM",
// //         "Tue": "09:30AM - 09:30PM",
// //         "Wed": "09:30AM - 09:30PM",
// //         "Thu": "09:30AM - 09:30PM",
// //         "Fri": "Closed",
// //         "Sat": "09:30AM - 09:30PM",
// //         "Sun": "09:30AM - 09:30PM",
// //       },
// //     ),
// //     Shop(
// //       name: "Tawasul All",
// //       address: "Almadar Street, in front of the city Square, Sert, Libya",
// //       phone: "+218915559700",
// //       email: "Sirt.shop@tawasul-world.com",
// //       schedule: {
// //         "Mon": "11:00AM - 09:00PM",
// //         "Tue": "11:00AM - 09:00PM",
// //         "Wed": "11:00AM - 09:00PM",
// //         "Thu": "11:00AM - 09:00PM",
// //         "Fri": "Closed",
// //         "Sat": "11:00AM - 09:00PM",
// //         "Sun": "11:00AM - 09:00PM",
// //       },
// //     ),
// //     Shop(
// //       name: "Tawasul Apple",
// //       address: "Qadisiyah Square, Tripoli, Libya",
// //       phone: "+218922559100",
// //       email: "Appleqadisya.shop@tawasul-world.com",
// //       schedule: {
// //         "Mon": "10:30AM - 09:30PM",
// //         "Tue": "10:30AM - 09:30PM",
// //         "Wed": "10:30AM - 09:30PM",
// //         "Thu": "10:30AM - 09:30PM",
// //         "Fri": "Closed",
// //         "Sat": "10:30AM - 09:30PM",
// //         "Sun": "10:30AM - 09:30PM",
// //       },
// //     ),
// //     Shop(
// //       name: "Tawasul Huawei",
// //       address: "Bin Ashour Street, Tripoli, Libya",
// //       phone: "+218915559900",
// //       email: "Benashour.shop@tawasul-world.com",
// //       schedule: {
// //         "Mon": "10:00AM - 09:30PM",
// //         "Tue": "10:00AM - 09:30PM",
// //         "Wed": "10:00AM - 09:30PM",
// //         "Thu": "10:00AM - 09:30PM",
// //         "Fri": "Closed",
// //         "Sat": "10:00AM - 09:30PM",
// //         "Sun": "10:00AM - 09:30PM",
// //       },
// //     ),
// //     Shop(
// //       name: "Tawasul Xiaomi",
// //       address: "Awlad Bin al Haj Street, Tripoli, Libya",
// //       phone: "+218915559100",
// //       email: "Xiaomisoqjumaa.shop@tawasul-world.com",
// //       schedule: {
// //         "Mon": "10:00AM - 10:00PM",
// //         "Tue": "10:00AM - 10:00PM",
// //         "Wed": "10:00AM - 10:00PM",
// //         "Thu": "10:00AM - 10:00PM",
// //         "Fri": "Closed",
// //         "Sat": "10:00AM - 10:00PM",
// //         "Sun": "10:00AM - 10:00PM",
// //       },
// //     ),
// //     Shop(
// //       name: "Tawasul All",
// //       address: "Al-Jaraba Mall, Tripoli, Libya",
// //       phone: "+218915559600",
// //       email: "Jrabamall.shop@tawasul-world.com",
// //       schedule: {
// //         "Mon": "10:00AM - 10:00PM",
// //         "Tue": "10:00AM - 10:00PM",
// //         "Wed": "10:00AM - 10:00PM",
// //         "Thu": "10:00AM - 10:00PM",
// //         "Fri": "04:00AM - 09:30PM",
// //         "Sat": "10:00AM - 10:00PM",
// //         "Sun": "10:00AM - 10:00PM",
// //       },
// //     ),
// //     Shop(
// //       name: "Tawasul Xiaomi",
// //       address: "Grand Mall, Tripoli, Libya",
// //       phone: "+218913844320",
// //       email: "Xiaomiainzara.shop@tawasul-world.com",
// //       schedule: {
// //         "Mon": "10:30AM - 10:00PM",
// //         "Tue": "10:30AM - 10:00PM",
// //         "Wed": "10:30AM - 10:00PM",
// //         "Thu": "10:30AM - 10:00PM",
// //         "Fri": "05:00AM - 10:00PM",
// //         "Sat": "10:30AM - 10:00PM",
// //         "Sun": "10:30AM - 10:00PM",
// //       },
// //     ),
// //     Shop(
// //       name: "Tawasul Samsung",
// //       address: "Al Jamahirriyah Street, Tripoli, Libya",
// //       phone: "+218923071900",
// //       email: "Samsungjumhoria.shop@tawasul-libya.com",
// //       schedule: {
// //         "Mon": "09:00AM - 09:00PM",
// //         "Tue": "09:00AM - 09:00PM",
// //         "Wed": "09:00AM - 09:00PM",
// //         "Thu": "09:00AM - 09:00PM",
// //         "Fri": "Closed",
// //         "Sat": "09:00AM - 09:00PM",
// //         "Sun": "09:00AM - 09:00PM",
// //       },
// //     ),
// //     Shop(
// //       name: "Tawasul Samsung",
// //       address: "Regata Village, Tripoli, Libya",
// //       phone: "+218923071900",
// //       email: "Samsungsiahya.shop@tawasul-libya.com",
// //       schedule: {
// //         "Mon": "11:00AM - 09:00PM",
// //         "Tue": "11:00AM - 09:00PM",
// //         "Wed": "11:00AM - 09:00PM",
// //         "Thu": "11:00AM - 09:00PM",
// //         "Fri": "Closed",
// //         "Sat": "11:00AM - 09:00PM",
// //         "Sun": "11:00AM - 09:00PM",
// //       },
// //     ),
// //     Shop(
// //       name: "Tawasul Apple",
// //       address: "Tripoli Street, Tripoli, Libya",
// //       phone: "+218922559200",
// //       email: "Appletripolistreet.shop@tawasul-world.com",
// //       schedule: {
// //         "Mon": "10:30AM - 09:30PM",
// //         "Tue": "10:30AM - 09:30PM",
// //         "Wed": "10:30AM - 09:30PM",
// //         "Thu": "10:30AM - 09:30PM",
// //         "Fri": "Closed",
// //         "Sat": "10:30AM - 09:30PM",
// //         "Sun": "10:30AM - 09:30PM",
// //       },
// //     ),
// //     Shop(
// //       name: "Tawasul All",
// //       address:
// //           "Investment market, Sana Street, near The High mosque, Misurata, Libya",
// //       phone: "+218915559400",
// //       email: "Sanaastreet.shop@tawasul-world.com",
// //       schedule: {
// //         "Mon": "10:30AM - 09:30PM",
// //         "Tue": "10:30AM - 09:30PM",
// //         "Wed": "10:30AM - 09:30PM",
// //         "Thu": "10:30AM - 09:30PM",
// //         "Fri": "Closed",
// //         "Sat": "10:30AM - 09:30PM",
// //         "Sun": "10:30AM - 09:30PM",
// //       },
// //     ),
// //     Shop(
// //       name: "Tawasul All",
// //       address: "Al Murqub District, Misurata, Libya",
// //       phone: "+218915559300",
// //       email: "Mgawbaa.shop@tawasul-world.com",
// //       schedule: {
// //         "Mon": "10:30AM - 09:30PM",
// //         "Tue": "10:30AM - 09:30PM",
// //         "Wed": "10:30AM - 09:30PM",
// //         "Thu": "10:30AM - 09:30PM",
// //         "Fri": "Closed",
// //         "Sat": "10:30AM - 09:30PM",
// //         "Sun": "10:30AM - 09:30PM",
// //       },
// //     ),
// //     Shop(
// //       name: "Tawasul Samsung",
// //       address: "Aldis Street, Misurata, Libya",
// //       phone: "+218923073600",
// //       email: "Samsungdiees.shop@tawasul-libya.com",
// //       schedule: {
// //         "Mon": "10:30AM - 09:30PM",
// //         "Tue": "10:30AM - 09:30PM",
// //         "Wed": "10:30AM - 09:30PM",
// //         "Thu": "10:30AM - 09:30PM",
// //         "Fri": "Closed",
// //         "Sat": "10:30AM - 09:30PM",
// //         "Sun": "10:30AM - 09:30PM",
// //       },
// //     ),
// //   ];

// //   @override
// //   Widget build(BuildContext context) {
// //     return Scaffold(
// //       backgroundColor: const Color(0xFFF5F6FA),
// //       appBar: PreferredSize(
// //         preferredSize: Size.fromHeight(kToolbarHeight + 30.h),
// //         child: Padding(
// //           padding: EdgeInsets.only(top: 15.h),
// //           child: AppBar(
// //             backgroundColor: const Color(0xFFF5F6FA),
// //             elevation: 0,
// //             leadingWidth: 50.w,
// //             leading: Padding(
// //               padding: EdgeInsets.only(left: 12.w),
// //               child: GestureDetector(
// //                 onTap:
// //                     () => Navigator.push(
// //                       context,
// //                       MaterialPageRoute(builder: (context) => HomePage()),
// //                     ),
// //                 child: Container(
// //                   width: 35.w,
// //                   height: 35.w,
// //                   alignment: Alignment.center,
// //                   decoration: const BoxDecoration(
// //                     color: Color(0xFF0984E3),
// //                     shape: BoxShape.circle,
// //                   ),
// //                   child: const Icon(
// //                     Icons.arrow_back_ios_new,
// //                     color: Colors.white,
// //                     size: 16,
// //                   ),
// //                 ),
// //               ),
// //             ),
// //             centerTitle: true,
// //             title: Text(
// //               "Find Tawasul",
// //               style: TextStyle(
// //                 color: Colors.black87,
// //                 fontWeight: FontWeight.w600,
// //                 fontSize: 16.sp,
// //               ),
// //             ),
// //           ),
// //         ),
// //       ),
// //       body: Padding(
// //         padding: EdgeInsets.only(left: 12.w, right: 12.w, bottom: 12.w),
// //         child: ListView.separated(
// //           itemCount: shops.length,
// //           separatorBuilder: (context, index) => SizedBox(height: 12.h),
// //           itemBuilder: (context, index) {
// //             final shop = shops[index];
// //             return Container(
// //               padding: EdgeInsets.all(14.w),
// //               decoration: BoxDecoration(
// //                 color: Colors.white,
// //                 borderRadius: BorderRadius.circular(12.r),
// //                 boxShadow: [
// //                   BoxShadow(
// //                     color: Colors.black12,
// //                     blurRadius: 4,
// //                     offset: const Offset(0, 2),
// //                   ),
// //                 ],
// //               ),
// //               child: Column(
// //                 crossAxisAlignment: CrossAxisAlignment.start,
// //                 children: [
// //                   /// Title + Expand icon
// //                   Row(
// //                     mainAxisAlignment: MainAxisAlignment.spaceBetween,
// //                     children: [
// //                       Text(
// //                         shop.name,
// //                         style: TextStyle(
// //                           fontSize: 14.sp,
// //                           fontWeight: FontWeight.bold,
// //                           color: Colors.black87,
// //                         ),
// //                       ),
// //                       IconButton(
// //                         icon: Icon(
// //                           shop.isExpanded
// //                               ? Icons.keyboard_arrow_up
// //                               : Icons.keyboard_arrow_down,
// //                           color: Colors.black54,
// //                         ),
// //                         onPressed: () {
// //                           setState(() {
// //                             shop.isExpanded = !shop.isExpanded;
// //                           });
// //                         },
// //                       ),
// //                     ],
// //                   ),
// //                   SizedBox(height: 6.h),

// //                   /// Address with icon
// //                   Row(
// //                     children: [
// //                       const Icon(
// //                         Icons.place,
// //                         size: 18,
// //                         color: Colors.redAccent,
// //                       ),
// //                       SizedBox(width: 6.w),
// //                       Expanded(
// //                         child: Text(
// //                           shop.address,
// //                           style: TextStyle(
// //                             fontSize: 13.sp,
// //                             color: Colors.black54,
// //                           ),
// //                         ),
// //                       ),
// //                     ],
// //                   ),
// //                   SizedBox(height: 6.h),

// //                   /// Phone with icon
// //                   if (shop.phone.isNotEmpty)
// //                     Row(
// //                       children: [
// //                         const Icon(Icons.phone, size: 18, color: Colors.green),
// //                         SizedBox(width: 6.w),
// //                         Text(
// //                           shop.phone,
// //                           style: TextStyle(
// //                             fontSize: 13.sp,
// //                             color: Colors.black54,
// //                           ),
// //                         ),
// //                       ],
// //                     ),
// //                   SizedBox(height: 6.h),

// //                   /// Email with icon
// //                   if (shop.email.isNotEmpty)
// //                     Row(
// //                       children: [
// //                         const Icon(Icons.email, size: 18, color: Colors.blue),
// //                         SizedBox(width: 6.w),
// //                         Expanded(
// //                           child: Text(
// //                             shop.email,
// //                             style: TextStyle(
// //                               fontSize: 13.sp,
// //                               color: Colors.blue,
// //                             ),
// //                           ),
// //                         ),
// //                       ],
// //                     ),

// //                   if (shop.isExpanded) ...[
// //                     SizedBox(height: 10.h),
// //                     Divider(color: Colors.grey[300]),
// //                     ...shop.schedule.entries.map(
// //                       (entry) => Padding(
// //                         padding: EdgeInsets.symmetric(vertical: 2.h),
// //                         child: Row(
// //                           mainAxisAlignment: MainAxisAlignment.spaceBetween,
// //                           children: [
// //                             Text(
// //                               entry.key,
// //                               style: TextStyle(
// //                                 fontWeight: FontWeight.w600,
// //                                 fontSize: 13.sp,
// //                                 color:
// //                                     entry.key == "Fri"
// //                                         ? Colors.red
// //                                         : Colors.black87,
// //                               ),
// //                             ),
// //                             Text(
// //                               entry.value,
// //                               style: TextStyle(fontSize: 13.sp),
// //                             ),
// //                           ],
// //                         ),
// //                       ),
// //                     ),
// //                   ],
// //                 ],
// //               ),
// //             );
// //           },
// //         ),
// //       ),
// //     );
// //   }
// // }

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
//         nameKey: "TawasulXiaomi",
//         addressKey: "Benghazi, Libya",
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
//         nameKey: "TawasulAll",
//         addressKey: "Shari Al Qayrawan, Benghazi, Libya",
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
//         nameKey: "TawasulSamsung",
//         addressKey: "Street Al-Riwayat ard Ben Ali, Benghazi, Libya",
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
//         nameKey: "TawasulSamsung",
//         addressKey: "Venice, Benghazi, Libya",
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
//         nameKey: "TawasulAll",
//         addressKey: "Almadar Street, in front of the city Square, Sert, Libya",
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
//         nameKey: "TawasulApple",
//         addressKey: "Qadisiyah Square, Tripoli, Libya",
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
//         nameKey: "TawasulHuawei",
//         addressKey: "Bin Ashour Street, Tripoli, Libya",
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
//         nameKey: "TawasulXiaomi",
//         addressKey: "Awlad Bin al Haj Street, Tripoli, Libya",
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
//         nameKey: "TawasulAll",
//         addressKey: "Al-Jaraba Mall, Tripoli, Libya",
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
//         nameKey: "TawasulXiaomi",
//         addressKey: "Grand Mall, Tripoli, Libya",
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
//         nameKey: "TawasulSamsung",
//         addressKey: "Al Jamahirriyah Street, Tripoli, Libya",
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
//         nameKey: "TawasulSamsung",
//         addressKey: "Regata Village, Tripoli, Libya",
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
//         nameKey: "TawasulApple",
//         addressKey: "Tripoli Street, Tripoli, Libya",
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
//         nameKey: "TawasulAll",
//         addressKey:
//             "Investment market, Sana Street, near The High mosque, Misurata, Libya",
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
//         nameKey: "TawasulAll",
//         addressKey: "Al Murqub District, Misurata, Libya",
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
//         nameKey: "TawasulSamsung",
//         addressKey: "Aldis Street, Misurata, Libya",
//         phone: "+218923073600",
//         email: "Samsungdiees.shop@tawasul-libya.com",
//         scheduleKeys: {
//           "mon": "10:30AM - 09:30PM",
//           "tue": "10:30AM - 09:30PM",
//           "wed": "10:30AM - 09:30PM",
//           "thu": "10:30AM - 09:30PM",
//           "fri": "Closed",
//           "sat": "10:30AM - 09:30PM",
//           "Sun": "10:30AM - 09:30PM",
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
//               padding: EdgeInsets.only(left: 12.w),
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
//                               loc.getString(entry.key), // 🔑 day translation
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
//                               entry.value, // time stays static
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
//     switch (key) {
//       case "findTawasul":
//         return findTawasul;
//       case "tawasulAll":
//         return tawasulAll;
//       case "tawasulApple":
//         return tawasulApple;
//       case "tawasulXiaomi":
//         return tawasulXiaomi;
//       case "tawasulSamsung":
//         return tawasulSamsung;
//       case "tawasulHuawei":
//         return tawasulHuawei;
//       case "streetAlKhototAlBaidaLibya":
//         return streetAlKhototAlBaidaLibya;
//       case "veniceBenghaziLibya":
//         return veniceBenghaziLibya;
//       case "benghaziLibya":
//         return benghaziLibya;
//       case "shariAlQayrawanBenghaziLibya":
//         return shariAlQayrawanBenghaziLibya;
//       case "almadarStreetSertLibya":
//         return almadarStreetSertLibya;
//       case "qadisiyahSquareTripoliLibya":
//         return qadisiyahSquareTripoliLibya;
//       case "binAshourStreetTripoliLibya":
//         return binAshourStreetTripoliLibya;
//       case "awladBinAlHajStreetTripoliLibya":
//         return awladBinAlHajStreetTripoliLibya;
//       case "alJarabaMallTripoliLibya":
//         return alJarabaMallTripoliLibya;
//       case "grandMallTripoliLibya":
//         return grandMallTripoliLibya;
//       case "regataVillageTripoliLibya":
//         return regataVillageTripoliLibya;
//       case "tripoliStreetTripoliLibya":
//         return tripoliStreetTripoliLibya;
//       case "investmentMarketMisurataLibya":
//         return investmentMarketMisurataLibya;
//       case "alMurqubDistrictMisurataLibya":
//         return alMurqubDistrictMisurataLibya;
//       case "aldisStreetMisurataLibya":
//         return aldisStreetMisurataLibya;
//       case "mon":
//         return mon;
//       case "tue":
//         return tue;
//       case "wed":
//         return wed;
//       case "thu":
//         return thu;
//       case "fri":
//         return fri;
//       case "sat":
//         return sat;
//       case "sun":
//         return sun;
//       default:
//         return key;
//     }
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
              padding: EdgeInsets.only(left: 12.w),
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
        padding: EdgeInsets.only(left: 12.w, right: 12.w, bottom: 12.w),
        child: ListView.separated(
          itemCount: shops.length,
          separatorBuilder: (context, index) => SizedBox(height: 12.h),
          itemBuilder: (context, index) {
            final shop = shops[index];
            return Container(
              padding: EdgeInsets.all(14.w),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12.r),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black12,
                    blurRadius: 4,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  /// Title + Expand icon
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        loc.getString(shop.nameKey),
                        style: TextStyle(
                          fontSize: 14.sp,
                          fontWeight: FontWeight.bold,
                          color: Colors.black87,
                        ),
                      ),
                      IconButton(
                        icon: Icon(
                          shop.isExpanded
                              ? Icons.keyboard_arrow_up
                              : Icons.keyboard_arrow_down,
                          color: Colors.black54,
                        ),
                        onPressed: () {
                          setState(() {
                            shop.isExpanded = !shop.isExpanded;
                          });
                        },
                      ),
                    ],
                  ),
                  SizedBox(height: 6.h),

                  /// addressKey with icon
                  Row(
                    children: [
                      const Icon(
                        Icons.place,
                        size: 18,
                        color: Colors.redAccent,
                      ),
                      SizedBox(width: 6.w),
                      Expanded(
                        child: Text(
                          loc.getString(shop.addressKey),
                          style: TextStyle(
                            fontSize: 13.sp,
                            color: Colors.black54,
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 6.h),

                  /// Phone with icon
                  if (shop.phone.isNotEmpty)
                    Row(
                      children: [
                        const Icon(Icons.phone, size: 18, color: Colors.green),
                        SizedBox(width: 6.w),
                        Text(
                          shop.phone,
                          style: TextStyle(
                            fontSize: 13.sp,
                            color: Colors.black54,
                          ),
                        ),
                      ],
                    ),
                  SizedBox(height: 6.h),

                  /// Email with icon
                  if (shop.email.isNotEmpty)
                    Row(
                      children: [
                        const Icon(Icons.email, size: 18, color: Colors.blue),
                        SizedBox(width: 6.w),
                        Expanded(
                          child: Text(
                            shop.email,
                            style: TextStyle(
                              fontSize: 13.sp,
                              color: Colors.blue,
                            ),
                          ),
                        ),
                      ],
                    ),

                  if (shop.isExpanded) ...[
                    SizedBox(height: 10.h),
                    Divider(color: Colors.grey[300]),
                    ...shop.scheduleKeys.entries.map(
                      (entry) => Padding(
                        padding: EdgeInsets.symmetric(vertical: 2.h),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              loc.getString(entry.key),
                              style: TextStyle(
                                fontWeight: FontWeight.w600,
                                fontSize: 13.sp,
                                color:
                                    entry.key == "fri"
                                        ? Colors.red
                                        : Colors.black87,
                              ),
                            ),
                            Text(
                              entry.value,
                              style: TextStyle(fontSize: 13.sp),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ],
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
    };

    return translations[key] ?? key;
  }
}
