import 'package:flutter/material.dart';
import 'package:tawasul_application/view/Profile/profile.dart';

class OrderHistory extends StatelessWidget {
  const OrderHistory({super.key});

  final List<Map<String, dynamic>> orders = const [
    {
      "title": "MacBook Air I3 pouces Puce Apple M1 SSD 256 Go",
      "price": "4 499 LYD",
      "color": "Black",
      "qty": 1,
      "status": "Delivered",
      "date": "23rd March 2025",
      "image": "assets/images/macbook.png",
    },
    {
      "title": "Smartphone Xiaomi",
      "price": "1700 LYD",
      "color": "Blue",
      "qty": 1,
      "status": "Cancelled",
      "date": "23rd March 2025",
      "image": "assets/images/xiaomi_iphone.png",
    },
    {
      "title": "Tablet Samsung",
      "price": "1870 LYD",
      "color": "Black",
      "qty": 1,
      "status": "Delivered",
      "date": "23rd March 2025",
      "image": "assets/images/xiaomi_tablette.png",
    },
    {
      "title": "MacBook Air I3 pouces Puce Apple M1 SSD 256 Go",
      "price": "4 499 LYD",
      "color": "Black",
      "qty": 1,
      "status": "Delivered",
      "date": "23rd March 2025",
      "image": "assets/images/macbook.png",
    },
    {
      "title": "Tablet Samsung",
      "price": "1870 LYD",
      "color": "Black",
      "qty": 1,
      "status": "Delivered",
      "date": "23rd March 2025",
      "image": "assets/images/xiaomi_tablette.png",
    },
    {
      "title": "MacBook Air I3 pouces Puce Apple M1 SSD 256 Go",
      "price": "4 499 LYD",
      "color": "Black",
      "qty": 1,
      "status": "Delivered",
      "date": "23rd March 2025",
      "image": "assets/images/macbook.png",
    },
  ];

  Color getStatusColor(String status) {
    switch (status.toLowerCase()) {
      case "delivered":
        return Colors.green;
      case "cancelled":
        return Colors.red;
      default:
        return Colors.grey;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF008AD2),
      body: SafeArea(
        child: Column(
          children: [
            _buildHeader(context),
            Expanded(
              child: ListView.builder(
                padding: const EdgeInsets.all(16),
                itemCount: orders.length,
                itemBuilder: (context, index) {
                  final order = orders[index];
                  return _buildOrderCard(order, context);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Row(
        children: [
          Image.asset('assets/images/logo_tawasul.png', height: 40),
          const Spacer(),
          const Text(
            "Order History",
            style: TextStyle(
              fontSize: 20,
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
          const Spacer(),
          GestureDetector(
            onTap:
                () => Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => Profile()),
                ),
            child: const CircleAvatar(
              backgroundColor: Colors.white,
              child: Icon(Icons.arrow_back, color: Color(0xFF008AD2)),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildOrderCard(Map<String, dynamic> order, BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 14),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        boxShadow: const [
          BoxShadow(color: Colors.black12, blurRadius: 6, offset: Offset(0, 2)),
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Image.asset(
            order['image'],
            width: 70,
            height: 70,
            fit: BoxFit.contain,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  order['title'],
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 6),
                Text("Price : ${order['price']}"),
                Row(
                  children: [
                    const Text("Status "),
                    Text(
                      order['status'],
                      style: TextStyle(
                        color: getStatusColor(order['status']),
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                Text(
                  "Delivered expected by : ${order['date']}",
                  style: const TextStyle(fontSize: 12),
                ),
                const SizedBox(height: 6),
                Text("Color : ${order['color']}    Qty : ${order['qty']}"),
              ],
            ),
          ),
          const SizedBox(width: 8),
          GestureDetector(
            onTap: () {
              // Implement delete action if needed
            },
            child: const Icon(Icons.close, color: Colors.black),
          ),
        ],
      ),
    );
  }
}
