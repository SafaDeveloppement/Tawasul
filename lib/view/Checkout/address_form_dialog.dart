// import 'package:flutter/material.dart';

// class AddressFormDialog extends StatefulWidget {
//   final Map<String, dynamic>? existingAddress;

//   const AddressFormDialog({Key? key, this.existingAddress}) : super(key: key);

//   @override
//   _AddressFormDialogState createState() => _AddressFormDialogState();
// }

// class _AddressFormDialogState extends State<AddressFormDialog> {
//   final _formKey = GlobalKey<FormState>();
//   late TextEditingController _firstNameController;
//   late TextEditingController _lastNameController;
//   late TextEditingController _address1Controller;
//   late TextEditingController _address2Controller;
//   late TextEditingController _cityController;
//   late TextEditingController _postcodeController;
//   late TextEditingController _phoneController;

//   @override
//   void initState() {
//     super.initState();
//     _firstNameController = TextEditingController(
//       text: widget.existingAddress?['firstName'] ?? '',
//     );
//     _lastNameController = TextEditingController(
//       text: widget.existingAddress?['lastName'] ?? '',
//     );
//     _address1Controller = TextEditingController(
//       text: widget.existingAddress?['address1'] ?? '',
//     );
//     _address2Controller = TextEditingController(
//       text: widget.existingAddress?['address2'] ?? '',
//     );
//     _cityController = TextEditingController(
//       text: widget.existingAddress?['city'] ?? '',
//     );
//     _postcodeController = TextEditingController(
//       text: widget.existingAddress?['postcode'] ?? '',
//     );
//     _phoneController = TextEditingController(
//       text:
//           widget.existingAddress?['phoneNumber'] ??
//           widget.existingAddress?['phone'] ??
//           '',
//     );
//   }

//   @override
//   void dispose() {
//     _firstNameController.dispose();
//     _lastNameController.dispose();
//     _address1Controller.dispose();
//     _address2Controller.dispose();
//     _cityController.dispose();
//     _postcodeController.dispose();
//     _phoneController.dispose();
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return AlertDialog(
//       title: Text(
//         widget.existingAddress != null ? 'Edit Address' : 'Add New Address',
//       ),
//       content: SingleChildScrollView(
//         child: Form(
//           key: _formKey,
//           child: Column(
//             mainAxisSize: MainAxisSize.min,
//             children: [
//               TextFormField(
//                 controller: _firstNameController,
//                 decoration: InputDecoration(labelText: 'First Name'),
//                 validator: (value) {
//                   if (value == null || value.isEmpty) {
//                     return 'Please enter first name';
//                   }
//                   return null;
//                 },
//               ),
//               TextFormField(
//                 controller: _lastNameController,
//                 decoration: InputDecoration(labelText: 'Last Name'),
//                 validator: (value) {
//                   if (value == null || value.isEmpty) {
//                     return 'Please enter last name';
//                   }
//                   return null;
//                 },
//               ),
//               TextFormField(
//                 controller: _address1Controller,
//                 decoration: InputDecoration(labelText: 'Address Line 1'),
//                 validator: (value) {
//                   if (value == null || value.isEmpty) {
//                     return 'Please enter address';
//                   }
//                   return null;
//                 },
//               ),
//               TextFormField(
//                 controller: _address2Controller,
//                 decoration: InputDecoration(
//                   labelText: 'Address Line 2 (Optional)',
//                 ),
//               ),
//               TextFormField(
//                 controller: _cityController,
//                 decoration: InputDecoration(labelText: 'City'),
//                 validator: (value) {
//                   if (value == null || value.isEmpty) {
//                     return 'Please enter city';
//                   }
//                   return null;
//                 },
//               ),
//               TextFormField(
//                 controller: _postcodeController,
//                 decoration: InputDecoration(labelText: 'Postcode (Optional)'),
//               ),
//               TextFormField(
//                 controller: _phoneController,
//                 decoration: InputDecoration(labelText: 'Phone Number'),
//                 keyboardType: TextInputType.phone,
//                 validator: (value) {
//                   if (value == null || value.isEmpty) {
//                     return 'Please enter phone number';
//                   }
//                   return null;
//                 },
//               ),
//             ],
//           ),
//         ),
//       ),
//       actions: [
//         TextButton(
//           onPressed: () => Navigator.of(context).pop(),
//           child: Text('Cancel'),
//         ),
//         ElevatedButton(
//           onPressed: _submitForm,
//           child: Text(widget.existingAddress != null ? 'Update' : 'Add'),
//         ),
//       ],
//     );
//   }

//   void _submitForm() {
//     if (_formKey.currentState!.validate()) {
//       final addressData = {
//         'firstName': _firstNameController.text,
//         'lastName': _lastNameController.text,
//         'address1': _address1Controller.text,
//         'address2': _address2Controller.text,
//         'city': _cityController.text,
//         'postcode': _postcodeController.text,
//         'phoneNumber': _phoneController.text,
//         if (widget.existingAddress != null)
//           'code': widget.existingAddress!['code'],
//       };

//       Navigator.of(context).pop(addressData);
//     }
//   }
// }

import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class AddressFormDialog extends StatefulWidget {
  final Map<String, dynamic>? existingAddress;

  const AddressFormDialog({Key? key, this.existingAddress}) : super(key: key);

  @override
  _AddressFormDialogState createState() => _AddressFormDialogState();
}

class _AddressFormDialogState extends State<AddressFormDialog> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _firstNameController;
  late TextEditingController _lastNameController;
  late TextEditingController _address1Controller;
  late TextEditingController _address2Controller;
  late TextEditingController _cityController;
  late TextEditingController _postcodeController;
  late TextEditingController _phoneController;

  @override
  void initState() {
    super.initState();
    _firstNameController = TextEditingController(
      text: widget.existingAddress?['firstName'] ?? '',
    );
    _lastNameController = TextEditingController(
      text: widget.existingAddress?['lastName'] ?? '',
    );
    _address1Controller = TextEditingController(
      text: widget.existingAddress?['address1'] ?? '',
    );
    _address2Controller = TextEditingController(
      text: widget.existingAddress?['address2'] ?? '',
    );
    _cityController = TextEditingController(
      text: widget.existingAddress?['city'] ?? '',
    );
    _postcodeController = TextEditingController(
      text: widget.existingAddress?['postcode'] ?? '',
    );
    _phoneController = TextEditingController(
      text:
          widget.existingAddress?['phoneNumber'] ??
          widget.existingAddress?['phone'] ??
          '',
    );
  }

  @override
  void dispose() {
    _firstNameController.dispose();
    _lastNameController.dispose();
    _address1Controller.dispose();
    _address2Controller.dispose();
    _cityController.dispose();
    _postcodeController.dispose();
    _phoneController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final t = AppLocalizations.of(context)!;

    return AlertDialog(
      title: Text(
        widget.existingAddress != null ? t.editAddress : t.addNewAddress,
      ),
      content: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextFormField(
                controller: _firstNameController,
                decoration: InputDecoration(labelText: t.firstName),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return t.pleaseEnterFirstName;
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _lastNameController,
                decoration: InputDecoration(labelText: t.lastName),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return t.pleaseEnterLastName;
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _address1Controller,
                decoration: InputDecoration(labelText: t.addressLine1),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return t.pleaseEnterAddress;
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _address2Controller,
                decoration: InputDecoration(labelText: t.addressLine2Optional),
              ),
              TextFormField(
                controller: _cityController,
                decoration: InputDecoration(labelText: t.city),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return t.pleaseEnterCity;
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _postcodeController,
                decoration: InputDecoration(labelText: t.postcodeOptional),
              ),
              TextFormField(
                controller: _phoneController,
                decoration: InputDecoration(labelText: t.phoneNumber),
                keyboardType: TextInputType.phone,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return t.pleaseEnterPhoneNumber;
                  }
                  return null;
                },
              ),
            ],
          ),
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: Text(t.cancel),
        ),
        ElevatedButton(
          onPressed: _submitForm,
          child: Text(widget.existingAddress != null ? t.update : t.add),
        ),
      ],
    );
  }

  void _submitForm() {
    if (_formKey.currentState!.validate()) {
      final addressData = {
        'firstName': _firstNameController.text,
        'lastName': _lastNameController.text,
        'address1': _address1Controller.text,
        'address2': _address2Controller.text,
        'city': _cityController.text,
        'postcode': _postcodeController.text,
        'phoneNumber': _phoneController.text,
        if (widget.existingAddress != null)
          'code': widget.existingAddress!['code'],
      };

      Navigator.of(context).pop(addressData);
    }
  }
}
