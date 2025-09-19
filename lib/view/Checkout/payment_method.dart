import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:tawasul_application/view/Checkout/delivery_methode.dart';
import 'package:tawasul_application/view/Checkout/order_success.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class PaymentMethod extends StatefulWidget {
  const PaymentMethod({Key? key}) : super(key: key);

  @override
  State<PaymentMethod> createState() => _PaymentMethodState();
}

class _PaymentMethodState extends State<PaymentMethod> {
  String? selectedMain; // "store" | "online"
  String? selectedSub;

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
                MaterialPageRoute(builder: (context) => DeliveryMethod()),
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
        title: Text(t.paymentMethod, style: TextStyle(color: Colors.black)),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Expanded(
              child: ListView(
                children: [
                  /// Pay in Store
                  PaymentOptionCard(
                    icon: Icons.store,
                    title: t.payInStore,
                    expanded: selectedMain == "store",
                    onTap: () {
                      setState(() {
                        selectedMain = selectedMain == "store" ? null : "store";
                        selectedSub = null;
                      });
                    },
                    children: [
                      PaymentSubOptionTile(
                        title: t.cashOnStore,
                        value: "cash",
                        groupValue: selectedSub,
                        onChanged: (val) {
                          setState(() => selectedSub = val);
                        },
                      ),
                      PaymentSubOptionTile(
                        title: t.posOnlinePayment,
                        value: "pos",
                        groupValue: selectedSub,
                        onChanged: (val) {
                          setState(() => selectedSub = val);
                        },
                      ),
                    ],
                  ),

                  /// Online Payment
                  PaymentOptionCard(
                    icon: Icons.credit_card,
                    title: t.onlinePayment,
                    expanded: selectedMain == "online",
                    onTap: () {
                      setState(() {
                        selectedMain =
                            selectedMain == "online" ? null : "online";
                        selectedSub = null;
                      });
                    },
                    children: [
                      PaymentSubOptionTile(
                        title: t.sadadPayment,
                        value: "sadad",
                        groupValue: selectedSub,
                        logo: "assets/images/sadad.png",
                        onChanged: (val) {
                          setState(() => selectedSub = val);
                        },
                      ),
                      PaymentSubOptionTile(
                        title: t.mooamalatPayment,
                        value: "mooamalat",
                        groupValue: selectedSub,
                        logo: "assets/images/Mooamalet.png",
                        onChanged: (val) {
                          setState(() => selectedSub = val);
                        },
                      ),
                    ],
                  ),
                ],
              ),
            ),

            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  padding: EdgeInsets.symmetric(vertical: 14),
                  backgroundColor:
                      (selectedSub != null)
                          ? Color(0xFF008AD2)
                          : Color(0xFF008AD2),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                onPressed:
                    () => Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => CheckoutSuccess(orderId: ''),
                      ),
                    ),
                child: Text(
                  t.validateAndContinue,
                  style: TextStyle(fontSize: 16, color: Colors.white),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Main expandable option card
class PaymentOptionCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final bool expanded;
  final VoidCallback onTap;
  final List<Widget> children;

  const PaymentOptionCard({
    Key? key,
    required this.icon,
    required this.title,
    required this.expanded,
    required this.onTap,
    required this.children,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Colors.white,
      margin: const EdgeInsets.only(bottom: 12),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8),
          border: Border.all(
            color: const Color.fromARGB(255, 0, 0, 0),
            width: 1,
          ),
        ),
        child: Column(
          children: [
            ListTile(
              leading: Icon(icon, color: Colors.blue),
              title: Text(
                title,
                style: const TextStyle(fontWeight: FontWeight.w600),
              ),
              trailing: Icon(
                expanded ? Icons.keyboard_arrow_up : Icons.chevron_right,
                color: Colors.grey,
              ),
              onTap: onTap,
            ),
            if (expanded) Column(children: children),
          ],
        ),
      ),
    );
  }
}

class PaymentSubOptionTile extends StatelessWidget {
  final String title;
  final String value;
  final String? groupValue;
  final String? logo;
  final ValueChanged<String?> onChanged;

  const PaymentSubOptionTile({
    Key? key,
    required this.title,
    required this.value,
    required this.groupValue,
    this.logo,
    required this.onChanged,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final selected = value == groupValue;
    return InkWell(
      onTap: () => onChanged(value),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
        margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8),
          border: Border.all(
            color:
                selected ? Colors.orange : const Color.fromARGB(255, 0, 0, 0),
            width: 1,
          ),
        ),
        child: Row(
          children: [
            Radio<String>(
              value: value,
              groupValue: groupValue,
              onChanged: onChanged,
              activeColor: Colors.orange,
            ),
            Expanded(
              child: Text(
                title,
                style: TextStyle(
                  fontWeight: FontWeight.w500,
                  color: selected ? Colors.black : Colors.grey[700],
                ),
              ),
            ),
            if (logo != null) Image.asset(logo!, height: 24),
          ],
        ),
      ),
    );
  }
}
