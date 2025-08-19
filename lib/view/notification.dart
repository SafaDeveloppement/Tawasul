import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:tawasul_application/controller/product_controller.dart';
import 'package:tawasul_application/view/home_page.dart';
import 'package:tawasul_application/view/navbar.dart';

class NotificationPage extends StatefulWidget {
  const NotificationPage({super.key});

  @override
  State<NotificationPage> createState() => _NotificationPageState();
}

class _NotificationPageState extends State<NotificationPage> {
  int _currentNavIndex = 0;

  int selectedTab = 0;

  final List<String> tabs = ['All', 'Promotions', 'Orders', 'Alerts'];

  final Map<String, List<Map<String, String>>> categorizedNotifications = {
    'Promotions': [
      {
        "icon": "🎁",
        "title": "Big Sale Alert!✨",
        "subtitle": "Enjoy 50% off your favorite items today!",
        "time": "2 hours ago",
      },
      {
        "icon": "🎉",
        "title": "Exclusive Offer for You!",
        "subtitle": "Get a free gift on your next order",
        "time": "1 day ago",
      },
      {
        "icon": "📢",
        "title": "Flash Deal: Limited Time Only!",
        "subtitle": "Save 30% on electronics. Ends at midnight!",
        "time": "3 hours ago",
      },
    ],
    'Orders': [
      {
        "icon": "🚚",
        "title": "Order Shipped!",
        "subtitle": "Your order is on its way",
        "time": "4 hours ago",
      },
      {
        "icon": "📦",
        "title": "Order Delivered!",
        "subtitle": "Your order has been delivered successfully.",
        "time": "2 days ago",
      },
      {
        "icon": "💳",
        "title": "Payment Confirmed!",
        "subtitle": "Your payment for order has been successfully processed.",
        "time": "6 hours ago",
      },
    ],
    'Alerts': [
      {
        "icon": "🔔",
        "title": "Security Alert!",
        "subtitle": "New login detected on your account.",
        "time": "5 minutes ago",
      },
    ],
  };

  @override
  Widget build(BuildContext context) {
    List<Map<String, String>> currentList =
        selectedTab == 0
            ? [
              ...categorizedNotifications['Promotions']!,
              ...categorizedNotifications['Orders']!,
              ...?categorizedNotifications['Alerts'],
            ]
            : categorizedNotifications[tabs[selectedTab]] ?? [];

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 255, 255, 255),
        elevation: 0,
        toolbarHeight: 56.h,
        leadingWidth: 48.w,
        leading: Padding(
          padding: EdgeInsets.only(left: 18.w),
          child: GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => HomePage()),
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
        title: Text(
          "Notification",
          style: TextStyle(
            fontFamily: "Inter",
            fontSize: 18.sp,
            fontWeight: FontWeight.w500,
            color: const Color.fromARGB(255, 0, 0, 0),
          ),
        ),
        centerTitle: true,
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 18),
            child: Image.asset('assets/images/logo_tawasul.png', height: 40),
          ),
        ],
      ),
      body: SafeArea(
        child: Column(
          children: [
            _buildTabs(),
            SizedBox(height: 20),
            Expanded(
              child: ListView.builder(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                itemCount: currentList.length,
                itemBuilder: (context, index) {
                  final item = currentList[index];
                  return _buildNotificationCard(
                    icon: item['icon']!,
                    title: item['title']!,
                    subtitle: item['subtitle']!,
                    time: item['time']!,
                  );
                },
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: _buildBottomNavBar(),
    );
  }

  Widget _buildTabs() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: List.generate(tabs.length, (index) {
          final isSelected = selectedTab == index;
          return GestureDetector(
            onTap: () => setState(() => selectedTab = index),
            child: Text(
              tabs[index],
              style: TextStyle(
                fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                color: isSelected ? Colors.black : Colors.grey,
              ),
            ),
          );
        }),
      ),
    );
  }

  Widget _buildNotificationCard({
    required String icon,
    required String title,
    required String subtitle,
    required String time,
  }) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 6),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: const Color(0xFF6CA0BA),
        borderRadius: BorderRadius.circular(12),
        boxShadow: const [
          BoxShadow(color: Colors.black26, blurRadius: 4, offset: Offset(0, 2)),
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(icon, style: const TextStyle(fontSize: 24)),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 4),
                Text(subtitle, style: const TextStyle(color: Colors.white)),
                const SizedBox(height: 4),
                Align(
                  alignment: Alignment.bottomRight,
                  child: Text(
                    time,
                    style: const TextStyle(fontSize: 12, color: Colors.white70),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBottomNavBar() {
    return Positioned(
      bottom: 35,
      left: 20,
      right: 20,
      child: Consumer<ProductController>(
        builder: (context, productController, child) {
          return CustomBottomNavBar(
            currentIndex: _currentNavIndex,
            context: context,
          );
        },
      ),
    );
  }
}
