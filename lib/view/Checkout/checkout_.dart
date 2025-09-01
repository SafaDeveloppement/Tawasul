// import 'package:flutter/material.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';
// import 'package:tawasul_application/view/Checkout/address_selection.dart';
// import 'package:tawasul_application/view/shopping_cart.dart';

// class Checkout extends StatefulWidget {
//   const Checkout({Key? key}) : super(key: key);

//   @override
//   State<Checkout> createState() => _CheckoutState();
// }

// class _CheckoutState extends State<Checkout> {
//   bool isBillingSame = true;
//   String? selectedCity;

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         leading: Padding(
//           padding: EdgeInsets.only(left: 18.w),
//           child: GestureDetector(
//             onTap: () {
//               Navigator.push(
//                 context,
//                 MaterialPageRoute(builder: (context) => ShoppingCart()),
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
//         title: const Text("Checkout", style: TextStyle(color: Colors.black)),
//       ),
//       body: SingleChildScrollView(
//         padding: const EdgeInsets.all(16),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             const Text(
//               "ADD YOUR DETAILS",
//               style: TextStyle(fontWeight: FontWeight.bold),
//             ),
//             const SizedBox(height: 20),
//             const Text("Delivery address:"),
//             const SizedBox(height: 10),
//             _buildTextField("First name"),
//             _buildTextField("Last name"),
//             _buildTextField("Phone number", keyboardType: TextInputType.phone),
//             const SizedBox(height: 20),
//             const Text("Set your localisation"),
//             const SizedBox(height: 10),
//             _buildLocationPicker(),
//             const SizedBox(height: 20),
//             const Text("Or set all your information below"),
//             const SizedBox(height: 10),
//             _buildTextField("Adresse"),
//             _buildTextField("Additional address", hint: "Optional"),
//             Row(
//               children: [
//                 Expanded(child: _buildDropdownCity()),
//                 const SizedBox(width: 10),
//                 Expanded(child: _buildTextField("Zip code", hint: "Optional")),
//               ],
//             ),
//             const SizedBox(height: 20),
//             _buildBillingCheckbox(),
//             const SizedBox(height: 30),
//             _buildValidateButton(),
//           ],
//         ),
//       ),
//     );
//   }

//   Widget _buildTextField(
//     String label, {
//     String? hint,
//     TextInputType? keyboardType,
//   }) {
//     return Padding(
//       padding: const EdgeInsets.only(bottom: 12),
//       child: TextFormField(
//         keyboardType: keyboardType,
//         decoration: InputDecoration(
//           hintText: hint ?? label,
//           border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
//           contentPadding: const EdgeInsets.symmetric(
//             horizontal: 16,
//             vertical: 14,
//           ),
//         ),
//       ),
//     );
//   }

//   Widget _buildLocationPicker() {
//     return Container(
//       decoration: BoxDecoration(
//         border: Border.all(color: Colors.black45),
//         borderRadius: BorderRadius.circular(8),
//       ),
//       child: ListTile(
//         title: Text("Choose your location"),
//         trailing: const Icon(Icons.my_location),
//         onTap: () {
//           // TODO: handle location picker
//         },
//       ),
//     );
//   }

//   Widget _buildDropdownCity() {
//     return DropdownButtonFormField<String>(
//       decoration: InputDecoration(
//         border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
//         contentPadding: const EdgeInsets.symmetric(horizontal: 12),
//       ),
//       hint: const Text("City"),
//       value: selectedCity,
//       onChanged: (value) {
//         setState(() {
//           selectedCity = value;
//         });
//       },
//       items:
//           ["Tunis", "Sfax", "Sousse", "Ariana"]
//               .map((city) => DropdownMenuItem(value: city, child: Text(city)))
//               .toList(),
//     );
//   }

//   Widget _buildBillingCheckbox() {
//     return Container(
//       padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
//       decoration: BoxDecoration(
//         border: Border.all(color: Colors.black26),
//         borderRadius: BorderRadius.circular(8),
//       ),
//       child: Row(
//         children: [
//           Checkbox(
//             value: isBillingSame,
//             onChanged: (val) {
//               setState(() {
//                 isBillingSame = val ?? true;
//               });
//             },
//             activeColor: Colors.orange,
//           ),
//           const Expanded(
//             child: Text.rich(
//               TextSpan(
//                 children: [
//                   TextSpan(
//                     text: "MY BILLING ADDRESS\n",
//                     style: TextStyle(fontWeight: FontWeight.bold),
//                   ),
//                   TextSpan(text: "is the same as my delivery address"),
//                 ],
//               ),
//             ),
//           ),
//         ],
//       ),
//     );
//   }

//   Widget _buildValidateButton() {
//     return SizedBox(
//       width: double.infinity,
//       height: 48,
//       child: ElevatedButton(
//         style: ElevatedButton.styleFrom(
//           backgroundColor: Color(0xFF008AD2),
//           shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
//         ),
//         onPressed: () {
//           Navigator.push(
//             context,
//             MaterialPageRoute(builder: (context) => AddressSelection()),
//           );
//         },
//         child: const Text(
//           "Validate and continue",
//           style: TextStyle(fontSize: 16, color: Colors.white),
//         ),
//       ),
//     );
//   }
// }


import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:tawasul_application/view/Checkout/address_selection.dart';
import 'package:tawasul_application/view/shopping_cart.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class Checkout extends StatefulWidget {
  const Checkout({Key? key}) : super(key: key);

  @override
  State<Checkout> createState() => _CheckoutState();
}

class _CheckoutState extends State<Checkout> {
  bool isBillingSame = true;
  String? selectedCity;

  @override
  Widget build(BuildContext context) {
    final t = AppLocalizations.of(context)!;

    return Scaffold(
      appBar: AppBar(
        leading: Padding(
          padding: EdgeInsets.only(left: 18.w),
          child: GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => ShoppingCart()),
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
            Text(
              t.addYourDetails,
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),
            Text(t.deliveryAddress),
            const SizedBox(height: 10),
            _buildTextField(t.firstName),
            _buildTextField(t.lastName),
            _buildTextField(t.phoneNumber, keyboardType: TextInputType.phone),
            const SizedBox(height: 20),
            Text(t.setYourLocalisation),
            const SizedBox(height: 10),
            _buildLocationPicker(t),
            const SizedBox(height: 20),
            Text(t.orSetAllYourInformationBelow),
            const SizedBox(height: 10),
            _buildTextField(t.address),
            _buildTextField(t.additionalAddress, hint: t.optional),
            Row(
              children: [
                Expanded(child: _buildDropdownCity(t)),
                const SizedBox(width: 10),
                Expanded(child: _buildTextField(t.zipCode, hint: t.optional)),
              ],
            ),
            const SizedBox(height: 20),
            _buildBillingCheckbox(t),
            const SizedBox(height: 30),
            _buildValidateButton(t),
          ],
        ),
      ),
    );
  }

  Widget _buildTextField(
    String label, {
    String? hint,
    TextInputType? keyboardType,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: TextFormField(
        keyboardType: keyboardType,
        decoration: InputDecoration(
          hintText: hint ?? label,
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 16,
            vertical: 14,
          ),
        ),
      ),
    );
  }

  Widget _buildLocationPicker(AppLocalizations t) {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(color: Colors.black45),
        borderRadius: BorderRadius.circular(8),
      ),
      child: ListTile(
        title: Text(t.chooseYourLocation),
        trailing: const Icon(Icons.my_location),
        onTap: () {
          // TODO: handle location picker
        },
      ),
    );
  }

  Widget _buildDropdownCity(AppLocalizations t) {
    return DropdownButtonFormField<String>(
      decoration: InputDecoration(
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
        contentPadding: const EdgeInsets.symmetric(horizontal: 12),
      ),
      hint: Text(t.city),
      value: selectedCity,
      onChanged: (value) {
        setState(() {
          selectedCity = value;
        });
      },
      items: [
        t.tripoli,
        t.benghazi,
        t.misrata,
        t.bayda,
        t.zawiya,
        t.gharyan,
        t.tobruk,
        t.ajdabiya,
        t.zleiten,
        t.derna,
        t.sirte,
        t.sabha,
        t.khoms,
        t.bani_walid,
        t.sabratha,
        t.zuwara,
        t.kufra,
        t.marj,
        t.tocra,
        t.tarhuna,
        t.msallata,
        t.jumayl,
        t.sorman,
        t.al_gseibat,
        t.shahat,
        t.ubari,
        t.asbia,
        t.jadid,
        t.waddan,
        t.el_agheila,
        t.abyar,
        t.nofaliya,
        t.regdalin,
        t.gasr_akhyar,
        t.al_qubah,
        t.tawergha,
        t.al_maya,
        t.murzuk,
        t.brega,
        t.teghsat,
        t.hun,
        t.jalu,
        t.ajaylat,
        t.nalut,
        t.suluq,
        t.shuhada_al_buerat,
        t.zaltan,
        t.mizda,
        t.ras_lanuf,
        t.al_urban,
        t.yafran,
        t.ar_rayaniya,
        t.umm_al_rizam,
        t.taucheira,
        t.brak,
        t.abu_ghlasha,
        t.ad_dawoon,
        t.teji,
        t.qaminis,
        t.qatrun,
        t.benina,
        t.kikla,
        t.al_rheibat,
        t.sokna,
        t.massa,
        t.bin_jawad,
        t.umm_al_aranib,
        t.jadu,
        t.gadames,
        t.ar_rabta,
        t.ghat,
        t.al_abraq,
        t.sidi_as_said,
        t.ar_rajban,
        t.awjila,
        t.ras_al_hamam,
        t.tolmeita,
        t.zella,
        t.wadi_utba,
        t.al_barkat,
        t.martuba,
        t.traghan,
        t.al_hashan,
        t.el_bayyada,
        t.qayqab,
        t.mashashita,
        t.bu_fakhra,
        t.musaid,
        t.tacnis,
        t.susa,
        t.wadi_zem_zem,
        t.batta,
        t.tazirbu,
        t.farzougha,
        t.qaryat_umar_al_mukhtar,
        t.bir_al_ashhab,
      ].map((city) => DropdownMenuItem(value: city, child: Text(city))).toList(),
    );
  }

  Widget _buildBillingCheckbox(AppLocalizations t) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.black26),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        children: [
          Checkbox(
            value: isBillingSame,
            onChanged: (val) {
              setState(() {
                isBillingSame = val ?? true;
              });
            },
            activeColor: Colors.orange,
          ),
          Expanded(
            child: Text.rich(
              TextSpan(
                children: [
                  TextSpan(
                    text: t.myBillingAddress + "\n",
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  TextSpan(text: t.isTheSameAsMyDeliveryAddress),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildValidateButton(AppLocalizations t) {
    return SizedBox(
      width: double.infinity,
      height: 48,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: Color(0xFF008AD2),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        ),
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => AddressSelection()),
          );
        },
        child: Text(
          t.validateAndContinue,
          style: TextStyle(fontSize: 16, color: Colors.white),
        ),
      ),
    );
  }
}