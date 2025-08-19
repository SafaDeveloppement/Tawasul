import 'package:flutter/material.dart';
import 'package:tawasul_application/view/Checkout/card_payment.dart';

class Checkout extends StatefulWidget {
  const Checkout({super.key});

  @override
  State<Checkout> createState() => _CheckoutState();
}

class _CheckoutState extends State<Checkout> {
  String? selectedPaymentMethod;
  bool termsAccepted = false;
  bool showError = false;

  final double totalAmount = 16551;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        centerTitle: true,
        elevation: 0.5,
        title: const Text(
          'Checkout',
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.w500),
        ),
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back_ios_new,
            color: Color(0xFF008AD2),
            size: 22,
          ),
          onPressed: () => Navigator.pop(context),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 12.0),
            child: Image.asset(
              'assets/images/logo_tawasul.png',
              width: 28,
              height: 28,
            ),
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        children: [
          const SizedBox(height: 16),

          // Total Price Box
          Container(
            padding: const EdgeInsets.symmetric(vertical: 24),
            decoration: BoxDecoration(
              color: const Color(0xFF008AD2),
              borderRadius: BorderRadius.circular(12),
            ),
            alignment: Alignment.center,
            child: Text(
              'Total\n${totalAmount.toStringAsFixed(0)}LYD',
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 24,
                color: Colors.white,
                fontWeight: FontWeight.bold,
                height: 1.5,
              ),
            ),
          ),

          const SizedBox(height: 20),

          // Correct Radio for "Pay in store"
          RadioListTile<String>(
            value: 'store',
            groupValue: selectedPaymentMethod,
            onChanged: (val) => setState(() => selectedPaymentMethod = val),
            activeColor: const Color(0xFF008AD2),
            contentPadding: EdgeInsets.zero,
            title: Text(
              "Pay in store",
              //style: TextStyle(height: 1.4)
            ),
            subtitle: const Text(
              "Order remain valid 24h",
              //style: TextStyle(height: 1.4),
            ),
          ),
          SizedBox(height: 16),
          Text("You pay in store cash", style: TextStyle(height: 1)),

          SizedBox(height: 16),

          // Online payment options
          Row(
            children: [
              _paymentGatewayOption('sdad', 'assets/images/saded.png'),
              const SizedBox(width: 12),
              _paymentGatewayOption('maamalat', 'assets/images/moamalat.png'),
            ],
          ),

          const SizedBox(height: 16),

          const Text("Commission fees (1.00%) : 38LYD"),
          const Text("Commission fees (1.50%) : 57LYD"),

          const SizedBox(height: 16),

          // Terms and conditions
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Checkbox(
                value: termsAccepted,
                activeColor: const Color(0xFF008AD2),
                onChanged: (val) => setState(() => termsAccepted = val!),
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.only(
                    top: 6.0,
                  ), // Adjust this value if needed
                  child: RichText(
                    text: TextSpan(
                      style: const TextStyle(color: Colors.black),
                      children: [
                        const TextSpan(text: "I agree to the "),
                        TextSpan(
                          text: "terms of service",
                          style: const TextStyle(
                            color: Color(0xFF008AD2),
                            decoration: TextDecoration.underline,
                          ),
                        ),
                        const TextSpan(
                          text: " and will adhere to them unconditionally.",
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
          // Error message
          if (showError)
            Container(
              margin: const EdgeInsets.only(top: 8),
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: const Color(0xFF7CA9BA),
                borderRadius: BorderRadius.circular(8),
              ),
              child: RichText(
                text: TextSpan(
                  style: const TextStyle(color: Colors.white),
                  children: [
                    const TextSpan(text: "Please make sure you've chosen a "),
                    TextSpan(
                      text: "payment method",
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        decoration: TextDecoration.underline,
                      ),
                    ),
                    const TextSpan(text: " and accepted the "),
                    TextSpan(
                      text: "terms and conditions.",
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        decoration: TextDecoration.underline,
                      ),
                    ),
                  ],
                ),
              ),
            ),

          const SizedBox(height: 20),

          // Buy button
          SizedBox(
            width: double.infinity,
            height: 48,
            child: ElevatedButton(
              onPressed: () {
                if (selectedPaymentMethod == null || !termsAccepted) {
                  setState(() => showError = true);
                } else {
                  setState(() => showError = false);
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => CardPayment()),
                  );
                }
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF008AD2),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: const Text(
                "Buy",
                style: TextStyle(fontSize: 18, color: Colors.white),
              ),
            ),
          ),
          SizedBox(height: 32),
        ],
      ),
    );
  }

  Widget _paymentGatewayOption(String value, String assetPath) {
    final isSelected = selectedPaymentMethod == value;
    return Expanded(
      child: GestureDetector(
        onTap: () => setState(() => selectedPaymentMethod = value),
        child: Container(
          height: 100,
          decoration: BoxDecoration(
            border: Border.all(
              color: isSelected ? const Color(0xFF008AD2) : Colors.grey,
              width: 1.5,
            ),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Stack(
            alignment: Alignment.topLeft,
            children: [
              Positioned(
                left: 4,
                top: 4,
                child: Radio<String>(
                  value: value,
                  groupValue: selectedPaymentMethod,
                  onChanged:
                      (val) => setState(() => selectedPaymentMethod = val!),
                  activeColor: const Color(0xFF008AD2),
                ),
              ),
              Center(
                child: Padding(
                  padding: const EdgeInsets.only(top: 12.0),
                  child: Image.asset(
                    assetPath,
                    width: 135,
                    height: 75,
                    fit: BoxFit.contain,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
