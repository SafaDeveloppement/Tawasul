import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:tawasul_application/view/Checkout/address_selection.dart';
import 'package:tawasul_application/view/Checkout/checkout_.dart';
import 'package:tawasul_application/view/store_location.dart';

class Delivery extends StatefulWidget {
  const Delivery({super.key});

  @override
  State<Delivery> createState() => _DeliveryState();
}

class _DeliveryState extends State<Delivery> {
  String deliveryMethod = 'pickup';
  bool agreedToTerms = false;
  String selectedCity = 'Misrata';
  String selectedStore = 'Misratah Mgaowba';
  DateTime selectedDate = DateTime.now();
  TimeOfDay selectedTime = TimeOfDay.now();

  final cities = ['Misrata', 'Tripoli'];
  final stores = ['Misratah Mgaowba', 'Tripoli Center'];

  final storeSchedule = {
    'Monday': '10:30AM - 09:30PM',
    'Tuesday': '10:30AM - 09:30PM',
    'Wednesday': '10:30AM - 09:30PM',
    'Thursday': '10:30AM - 09:30PM',
    'Friday': 'Closed',
    'Saturday': '10:30AM - 09:30PM',
    'Sunday': '10:30AM - 09:30PM',
  };

  Future<void> pickDate() async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: selectedDate,
      firstDate: DateTime.now(),
      lastDate: DateTime(2026),
    );
    if (picked != null && picked != selectedDate) {
      setState(() {
        selectedDate = picked;
      });
    }
  }

  Future<void> pickTime() async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: selectedTime,
    );
    if (picked != null && picked != selectedTime) {
      setState(() {
        selectedTime = picked;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: const Text("Delivery", style: TextStyle(color: Colors.black)),
        centerTitle: true,
        elevation: 0.5,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Color(0xFF008AD2)),
          onPressed:
              () => Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => AddressSelection()),
              ),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Image.asset('assets/images/logo_tawasul.png', width: 30),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(10.0),
        child: ListView(
          children: [
            // Info Box
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: const Color(0xFF7CA9BA),
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Text(
                'All list of products is available in your city, you can order using store pickup',
                style: TextStyle(color: Colors.white),
              ),
            ),
            const SizedBox(height: 16),

            // Delivery Options
            _buildDeliveryOption("Store pickup delivery", 'pickup'),
            const SizedBox(height: 8),
            _buildDeliveryOption("DHL Shipping", 'dhl'),
            const SizedBox(height: 16),

            // Terms Checkbox
            Row(
              children: [
                Checkbox(
                  value: agreedToTerms,
                  onChanged: (val) => setState(() => agreedToTerms = val!),
                ),
                Text("I agree to the"),
                GestureDetector(
                  onTap: () {},
                  child: Text(
                    "terms of service",
                    style: TextStyle(
                      color: Color(0xFF008AD2),
                      decoration: TextDecoration.underline,
                    ),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 16),

            // City Dropdown
            _buildDropdown(
              label: 'City',
              value: selectedCity,
              items: cities,
              onChanged: (val) => setState(() => selectedCity = val!),
            ),
            const SizedBox(height: 16),

            // Store Dropdown
            _buildDropdown(
              label: 'Store',
              value: selectedStore,
              items: stores,
              onChanged: (val) => setState(() => selectedStore = val!),
            ),
            const SizedBox(height: 16),

            // Store Schedule Table
            _buildStoreSchedule(),

            const SizedBox(height: 16),

            // Date Picker
            TextField(
              readOnly: true,
              onTap: pickDate,
              decoration: InputDecoration(
                labelText: 'Day',
                suffixIcon: const Icon(Icons.calendar_today_outlined),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: const BorderSide(color: Color(0xFF008AD2)),
                ),
              ),
              controller: TextEditingController(
                text: DateFormat('dd/MM/yyyy').format(selectedDate),
              ),
            ),
            const SizedBox(height: 16),

            // Time Picker
            TextField(
              readOnly: true,
              onTap: pickTime,
              decoration: InputDecoration(
                labelText: 'Hour',
                suffixIcon: const Icon(Icons.access_time),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: const BorderSide(color: Color(0xFF008AD2)),
                ),
              ),
              controller: TextEditingController(
                text: selectedTime.format(context),
              ),
            ),
            const SizedBox(height: 30),

            Row(
              children: [
                Expanded(
                  child: SizedBox(
                    height: 45,
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const StoreLocation(),
                          ),
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.white,
                        side: const BorderSide(color: Color(0xFF008AD2)),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      child: const Text(
                        "See Map",
                        style: TextStyle(
                          fontSize: 16,
                          color: Color(0xFF008AD2),
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: SizedBox(
                    height: 45,
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) =>Checkout(),
                          ),
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF008AD2),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      child: const Text(
                        "Continue",
                        style: TextStyle(fontSize: 16, color: Colors.white),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDeliveryOption(String title, String value) {
    return Container(
      decoration: BoxDecoration(
        color: deliveryMethod == value ? Colors.grey[200] : Colors.grey[100],
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.black12),
      ),
      child: RadioListTile(
        value: value,
        groupValue: deliveryMethod,
        onChanged: (val) => setState(() => deliveryMethod = val!),
        title: Text(title),
        activeColor: const Color(0xFF008AD2),
      ),
    );
  }

  Widget _buildDropdown({
    required String label,
    required String value,
    required List<String> items,
    required void Function(String?) onChanged,
  }) {
    return InputDecorator(
      decoration: InputDecoration(
        labelText: label,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: Color(0xFF008AD2)),
        ),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          value: value,
          isExpanded: true,
          items:
              items
                  .map(
                    (item) => DropdownMenuItem(value: item, child: Text(item)),
                  )
                  .toList(),
          onChanged: onChanged,
        ),
      ),
    );
  }

  Widget _buildStoreSchedule() {
    return Table(
      border: TableBorder.all(color: Colors.blueAccent.shade100),
      children:
          storeSchedule.entries
              .map(
                (entry) => TableRow(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(entry.key),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(entry.value),
                    ),
                  ],
                ),
              )
              .toList(),
    );
  }
}
