import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:tawasul_application/view/home_page.dart';

class Shop {
  final String name;
  final String address;
  final String phone;
  final String email;
  final Map<String, String> schedule;
  bool isExpanded;

  Shop({
    required this.name,
    required this.address,
    required this.phone,
    required this.email,
    required this.schedule,
    this.isExpanded = false,
  });
}

class FindTawasul extends StatefulWidget {
  @override
  _FindTawasulState createState() => _FindTawasulState();
}

class _FindTawasulState extends State<FindTawasul> {
  final List<Shop> shops = [
    Shop(
      name: "Tawasul All",
      address: "Street Al Khotot, Al Baida, Libya",
      phone: "+218922559400",
      email: "Albaidaa.shop@tawasul-world.com",
      schedule: {
        "Mon": "10:30AM - 09:00PM",
        "Tue": "10:30AM - 09:00PM",
        "Wed": "10:30AM - 09:00PM",
        "Thu": "10:30AM - 09:00PM",
        "Fri": "Closed",
        "Sat": "10:30AM - 09:00PM",
        "Sun": "10:30AM - 09:00PM",
      },
    ),
    Shop(
      name: "Tawasul Apple",
      address: "Venice, Benghazi, Libya",
      phone: "+218922559300",
      email: "applealijud.shop@tawasul-world.com",
      schedule: {
        "Mon": "09:30AM - 09:30PM",
        "Tue": "09:30AM - 09:30PM",
        "Wed": "09:30AM - 09:30PM",
        "Thu": "09:30AM - 09:30PM",
        "Fri": "Closed",
        "Sat": "09:30AM - 09:30PM",
        "Sun": "09:30AM - 09:30PM",
      },
    ),
    Shop(
      name: "Tawasul Xiaomi",
      address: "Benghazi, Libya",
      phone: "+218915558900",
      email: "Xiaomivenicia.shop@tawasul-world.com",
      schedule: {
        "Mon": "10:00AM - 10:00PM",
        "Tue": "10:00AM - 10:00PM",
        "Wed": "10:00AM - 10:00PM",
        "Thu": "10:00AM - 10:00PM",
        "Fri": "Closed",
        "Sat": "10:00AM - 10:00PM",
        "Sun": "10:00AM - 10:00PM",
      },
    ),
    Shop(
      name: "Tawasul All",
      address: "Shari Al Qayrawan, Benghazi, Libya",
      phone: "+218915559800",
      email: "Wekalat.shop@tawasul-world.com",
      schedule: {
        "Mon": "09:00AM - 07:00PM",
        "Tue": "09:00AM - 07:00PM",
        "Wed": "09:00AM - 07:00PM",
        "Thu": "09:00AM - 07:00PM",
        "Fri": "Closed",
        "Sat": "10:00AM - 04:00PM",
        "Sun": "10:00AM - 04:00PM",
      },
    ),
    Shop(
      name: "Tawasul Samsung",
      address: "Street Al-Riwayat ard Ben Ali, Benghazi, Libya",
      phone: "",
      email: "",
      schedule: {
        "Mon": "09:30AM - 09:30PM",
        "Tue": "09:30AM - 09:30PM",
        "Wed": "09:30AM - 09:30PM",
        "Thu": "09:30AM - 09:30PM",
        "Fri": "Closed",
        "Sat": "09:30AM - 09:30PM",
        "Sun": "09:30AM - 09:30PM",
      },
    ),
    Shop(
      name: "Tawasul Samsung",
      address: "Venice, Benghazi, Libya",
      phone: "+218923071800",
      email: "Samsungvenicia.shop@tawasul-libya.com",
      schedule: {
        "Mon": "09:30AM - 09:30PM",
        "Tue": "09:30AM - 09:30PM",
        "Wed": "09:30AM - 09:30PM",
        "Thu": "09:30AM - 09:30PM",
        "Fri": "Closed",
        "Sat": "09:30AM - 09:30PM",
        "Sun": "09:30AM - 09:30PM",
      },
    ),
    Shop(
      name: "Tawasul All",
      address: "Almadar Street, in front of the city Square, Sert, Libya",
      phone: "+218915559700",
      email: "Sirt.shop@tawasul-world.com",
      schedule: {
        "Mon": "11:00AM - 09:00PM",
        "Tue": "11:00AM - 09:00PM",
        "Wed": "11:00AM - 09:00PM",
        "Thu": "11:00AM - 09:00PM",
        "Fri": "Closed",
        "Sat": "11:00AM - 09:00PM",
        "Sun": "11:00AM - 09:00PM",
      },
    ),
    Shop(
      name: "Tawasul Apple",
      address: "Qadisiyah Square, Tripoli, Libya",
      phone: "+218922559100",
      email: "Appleqadisya.shop@tawasul-world.com",
      schedule: {
        "Mon": "10:30AM - 09:30PM",
        "Tue": "10:30AM - 09:30PM",
        "Wed": "10:30AM - 09:30PM",
        "Thu": "10:30AM - 09:30PM",
        "Fri": "Closed",
        "Sat": "10:30AM - 09:30PM",
        "Sun": "10:30AM - 09:30PM",
      },
    ),
    Shop(
      name: "Tawasul Huawei",
      address: "Bin Ashour Street, Tripoli, Libya",
      phone: "+218915559900",
      email: "Benashour.shop@tawasul-world.com",
      schedule: {
        "Mon": "10:00AM - 09:30PM",
        "Tue": "10:00AM - 09:30PM",
        "Wed": "10:00AM - 09:30PM",
        "Thu": "10:00AM - 09:30PM",
        "Fri": "Closed",
        "Sat": "10:00AM - 09:30PM",
        "Sun": "10:00AM - 09:30PM",
      },
    ),
    Shop(
      name: "Tawasul Xiaomi",
      address: "Awlad Bin al Haj Street, Tripoli, Libya",
      phone: "+218915559100",
      email: "Xiaomisoqjumaa.shop@tawasul-world.com",
      schedule: {
        "Mon": "10:00AM - 10:00PM",
        "Tue": "10:00AM - 10:00PM",
        "Wed": "10:00AM - 10:00PM",
        "Thu": "10:00AM - 10:00PM",
        "Fri": "Closed",
        "Sat": "10:00AM - 10:00PM",
        "Sun": "10:00AM - 10:00PM",
      },
    ),
    Shop(
      name: "Tawasul All",
      address: "Al-Jaraba Mall, Tripoli, Libya",
      phone: "+218915559600",
      email: "Jrabamall.shop@tawasul-world.com",
      schedule: {
        "Mon": "10:00AM - 10:00PM",
        "Tue": "10:00AM - 10:00PM",
        "Wed": "10:00AM - 10:00PM",
        "Thu": "10:00AM - 10:00PM",
        "Fri": "04:00AM - 09:30PM",
        "Sat": "10:00AM - 10:00PM",
        "Sun": "10:00AM - 10:00PM",
      },
    ),
    Shop(
      name: "Tawasul Xiaomi",
      address: "Grand Mall, Tripoli, Libya",
      phone: "+218913844320",
      email: "Xiaomiainzara.shop@tawasul-world.com",
      schedule: {
        "Mon": "10:30AM - 10:00PM",
        "Tue": "10:30AM - 10:00PM",
        "Wed": "10:30AM - 10:00PM",
        "Thu": "10:30AM - 10:00PM",
        "Fri": "05:00AM - 10:00PM",
        "Sat": "10:30AM - 10:00PM",
        "Sun": "10:30AM - 10:00PM",
      },
    ),
    Shop(
      name: "Tawasul Samsung",
      address: "Al Jamahirriyah Street, Tripoli, Libya",
      phone: "+218923071900",
      email: "Samsungjumhoria.shop@tawasul-libya.com",
      schedule: {
        "Mon": "09:00AM - 09:00PM",
        "Tue": "09:00AM - 09:00PM",
        "Wed": "09:00AM - 09:00PM",
        "Thu": "09:00AM - 09:00PM",
        "Fri": "Closed",
        "Sat": "09:00AM - 09:00PM",
        "Sun": "09:00AM - 09:00PM",
      },
    ),
    Shop(
      name: "Tawasul Samsung",
      address: "Regata Village, Tripoli, Libya",
      phone: "+218923071900",
      email: "Samsungsiahya.shop@tawasul-libya.com",
      schedule: {
        "Mon": "11:00AM - 09:00PM",
        "Tue": "11:00AM - 09:00PM",
        "Wed": "11:00AM - 09:00PM",
        "Thu": "11:00AM - 09:00PM",
        "Fri": "Closed",
        "Sat": "11:00AM - 09:00PM",
        "Sun": "11:00AM - 09:00PM",
      },
    ),
    Shop(
      name: "Tawasul Apple",
      address: "Tripoli Street, Tripoli, Libya",
      phone: "+218922559200",
      email: "Appletripolistreet.shop@tawasul-world.com",
      schedule: {
        "Mon": "10:30AM - 09:30PM",
        "Tue": "10:30AM - 09:30PM",
        "Wed": "10:30AM - 09:30PM",
        "Thu": "10:30AM - 09:30PM",
        "Fri": "Closed",
        "Sat": "10:30AM - 09:30PM",
        "Sun": "10:30AM - 09:30PM",
      },
    ),
    Shop(
      name: "Tawasul All",
      address:
          "Investment market, Sana Street, near The High mosque, Misurata, Libya",
      phone: "+218915559400",
      email: "Sanaastreet.shop@tawasul-world.com",
      schedule: {
        "Mon": "10:30AM - 09:30PM",
        "Tue": "10:30AM - 09:30PM",
        "Wed": "10:30AM - 09:30PM",
        "Thu": "10:30AM - 09:30PM",
        "Fri": "Closed",
        "Sat": "10:30AM - 09:30PM",
        "Sun": "10:30AM - 09:30PM",
      },
    ),
    Shop(
      name: "Tawasul All",
      address: "Al Murqub District, Misurata, Libya",
      phone: "+218915559300",
      email: "Mgawbaa.shop@tawasul-world.com",
      schedule: {
        "Mon": "10:30AM - 09:30PM",
        "Tue": "10:30AM - 09:30PM",
        "Wed": "10:30AM - 09:30PM",
        "Thu": "10:30AM - 09:30PM",
        "Fri": "Closed",
        "Sat": "10:30AM - 09:30PM",
        "Sun": "10:30AM - 09:30PM",
      },
    ),
    Shop(
      name: "Tawasul Samsung",
      address: "Aldis Street, Misurata, Libya",
      phone: "+218923073600",
      email: "Samsungdiees.shop@tawasul-libya.com",
      schedule: {
        "Mon": "10:30AM - 09:30PM",
        "Tue": "10:30AM - 09:30PM",
        "Wed": "10:30AM - 09:30PM",
        "Thu": "10:30AM - 09:30PM",
        "Fri": "Closed",
        "Sat": "10:30AM - 09:30PM",
        "Sun": "10:30AM - 09:30PM",
      },
    ),
  ];

  @override
  Widget build(BuildContext context) {
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
              "Find Tawasul",
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
                        shop.name,
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

                  /// Address with icon
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
                          shop.address,
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
                    ...shop.schedule.entries.map(
                      (entry) => Padding(
                        padding: EdgeInsets.symmetric(vertical: 2.h),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              entry.key,
                              style: TextStyle(
                                fontWeight: FontWeight.w600,
                                fontSize: 13.sp,
                                color:
                                    entry.key == "Fri"
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
