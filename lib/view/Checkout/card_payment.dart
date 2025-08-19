import 'package:flutter/material.dart';
import 'package:tawasul_application/view/Checkout/order_success.dart';

class CardPayment extends StatelessWidget {
  const CardPayment({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        elevation: 0.5,
        backgroundColor: Colors.white,
        automaticallyImplyLeading: false,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        child: ListView(
          children: [
            const Text(
              'Order Details',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Color(0xFF008AD2),
              ),
            ),
            const Divider(color: Color(0xFF008AD2), thickness: 1.0),
            const SizedBox(height: 8),

            // Merchant & Amount
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: const [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Merchant',
                      style: TextStyle(fontWeight: FontWeight.w500),
                    ),
                    SizedBox(height: 4),
                    Text('TAWASUL LIBYA COMPANY'),
                  ],
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      'Amount',
                      style: TextStyle(fontWeight: FontWeight.w500),
                    ),
                    SizedBox(height: 4),
                    Text('LYD 36003'),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 16),
            const Text(
              'Merchant Ref#',
              style: TextStyle(fontWeight: FontWeight.w500),
            ),
            const SizedBox(height: 4),
            const Text('6114'),

            const SizedBox(height: 24),
            const Text(
              'Card Payment',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Color(0xFF008AD2),
              ),
            ),
            const Divider(color: Color(0xFF008AD2), thickness: 1.0),
            const SizedBox(height: 16),

            // Card Number
            _inputField(label: 'Card number', icon: Icons.credit_card),
            const SizedBox(height: 16),

            // Expiration + CVV
            Row(
              children: [
                Expanded(
                  child: _inputField(
                    label: 'Expiration date',
                    icon: Icons.calendar_today,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _inputField(
                    label: 'CVV',
                    icon: Icons.credit_card_outlined,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),

            // Cardholder
            _inputField(label: 'Cardholder', icon: Icons.person_outline),

            const SizedBox(height: 32),

            // Pay Button
            SizedBox(
              height: 48,
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => OrderSuccess()),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF008AD2),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(6),
                  ),
                ),
                child: const Text(
                  'Pay 16 551 LYD',
                  style: TextStyle(fontSize: 18, color: Colors.white),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _inputField({required String label, required IconData icon}) {
    return TextField(
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: Icon(icon, color: Color(0xFF008AD2)),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 12,
          vertical: 14,
        ),
      ),
    );
  }
}
