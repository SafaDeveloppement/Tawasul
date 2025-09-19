// import 'package:flutter/material.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';
// import 'dart:io';
// import 'package:image_picker/image_picker.dart';
// import 'package:tawasul_application/Services/api_service.dart';
// import 'package:tawasul_application/view/Profile/profile.dart';
// import 'package:flutter_gen/gen_l10n/app_localizations.dart';

// class EditProfile extends StatefulWidget {
//   const EditProfile({super.key});

//   @override
//   State<EditProfile> createState() => _EditProfileState();
// }

// class _EditProfileState extends State<EditProfile> {
//   File? _profileImage;
//   final ImagePicker _picker = ImagePicker();

//   final firstNameController = TextEditingController();
//   final lastNameController = TextEditingController();
//   final emailController = TextEditingController();
//   final phoneController = TextEditingController();
//   final passwordController = TextEditingController(text: '********');

//   bool _isLoading = true;
//   bool _hasError = false;
//   Map<String, dynamic>? _customerData;

//   @override
//   void initState() {
//     super.initState();
//     _loadCustomerDetails();
//   }

//   Future<void> _loadCustomerDetails() async {
//     setState(() {
//       _isLoading = true;
//       _hasError = false;
//     });

//     try {
//       final customerDetails = await ApiService.getCustomerDetails();

//       if (customerDetails != null && mounted) {
//         setState(() {
//           _customerData = customerDetails;

//           // Extract first name and last name from the API response
//           firstNameController.text =
//               customerDetails['firstName'] ??
//               customerDetails['first_name'] ??
//               '';
//           lastNameController.text =
//               customerDetails['lastName'] ?? customerDetails['last_name'] ?? '';
//           emailController.text = customerDetails['email'] ?? '';
//           phoneController.text =
//               customerDetails['phone'] ?? customerDetails['mobile'] ?? '';
//         });
//       } else {
//         setState(() {
//           _hasError = true;
//         });
//       }
//     } catch (e) {
//       print("Error loading customer details: $e");
//       setState(() {
//         _hasError = true;
//       });
//     } finally {
//       if (mounted) {
//         setState(() {
//           _isLoading = false;
//         });
//       }
//     }
//   }

//   Future<void> _uploadImage() async {
//     final picked = await _picker.pickImage(source: ImageSource.gallery);
//     if (picked != null) {
//       setState(() {
//         _profileImage = File(picked.path);
//       });
//     }
//   }

//   void _deleteImage() {
//     setState(() {
//       _profileImage = null;
//     });
//   }

//   void _saveProfile() {
//     // Implement save logic here (e.g., send to backend)
//     print(
//       'Saved: ${firstNameController.text} ${lastNameController.text}, ${emailController.text}, ${phoneController.text}',
//     );
//     ScaffoldMessenger.of(
//       context,
//     ).showSnackBar(SnackBar(content: Text("Profile saved successfully")));
//   }

//   @override
//   Widget build(BuildContext context) {
//     final t = AppLocalizations.of(context)!;
//     return Scaffold(
//       backgroundColor: Colors.white,
//       appBar: AppBar(
//         backgroundColor: const Color.fromARGB(255, 255, 255, 255),
//         elevation: 0,
//         toolbarHeight: 56.h,
//         leadingWidth: 48.w,
//         leading: Padding(
//           padding: EdgeInsets.only(left: 12.w),
//           child: GestureDetector(
//             onTap: () {
//               Navigator.push(
//                 context,
//                 MaterialPageRoute(builder: (context) => Profile()),
//               );
//             },
//             child: Container(
//               width: 36.w,
//               height: 36.w,
//               decoration: const BoxDecoration(
//                 color: Color(0xFF008AD2),
//                 shape: BoxShape.circle,
//               ),
//               child: Center(
//                 child: Icon(
//                   Icons.arrow_back_ios_new,
//                   color: Colors.white,
//                   size: 18.sp,
//                 ),
//               ),
//             ),
//           ),
//         ),
//         title: Text(
//           t.editProfile,
//           style: TextStyle(
//             fontSize: 18.sp,
//             fontWeight: FontWeight.w500,
//             color: const Color.fromARGB(255, 0, 0, 0),
//           ),
//         ),
//         centerTitle: true,
//       ),
//       body:
//           _isLoading
//               ? Center(child: CircularProgressIndicator())
//               : _hasError
//               ? Center(
//                 child: Column(
//                   mainAxisAlignment: MainAxisAlignment.center,
//                   children: [
//                     Text("Failed to load profile data"),
//                     SizedBox(height: 16),
//                     ElevatedButton(
//                       onPressed: _loadCustomerDetails,
//                       child: Text("Retry"),
//                     ),
//                   ],
//                 ),
//               )
//               : Stack(
//                 children: [
//                   SafeArea(
//                     child: Column(
//                       children: [
//                         SizedBox(height: 15.h),
//                         // Profile Image
//                         CircleAvatar(
//                           radius: 60,
//                           backgroundColor: Colors.grey, // Grey background color
//                           backgroundImage:
//                               _profileImage != null
//                                   ? FileImage(_profileImage!)
//                                   : (_customerData?['profile_image'] != null
//                                       ? NetworkImage(
//                                         _customerData!['profile_image'],
//                                       )
//                                       : null), // Remove the fallback to asset image
//                         ),
//                         SizedBox(height: 10),
//                         Row(
//                           mainAxisAlignment: MainAxisAlignment.center,
//                           children: [
//                             Container(
//                               decoration: BoxDecoration(
//                                 border: Border.all(color: Colors.black),
//                                 borderRadius: BorderRadius.circular(8),
//                               ),
//                               child: ElevatedButton(
//                                 onPressed: _uploadImage,
//                                 style: ElevatedButton.styleFrom(
//                                   backgroundColor: Colors.white,
//                                   foregroundColor: Colors.black,
//                                   elevation: 0,
//                                   shape: RoundedRectangleBorder(
//                                     borderRadius: BorderRadius.circular(8),
//                                   ),
//                                   padding: EdgeInsets.symmetric(
//                                     horizontal: 12,
//                                     vertical: 8,
//                                   ),
//                                   minimumSize: Size(0, 0),
//                                   tapTargetSize:
//                                       MaterialTapTargetSize.shrinkWrap,
//                                 ),
//                                 child: Text(
//                                   'Upload',
//                                   style: TextStyle(
//                                     fontFamily: "Inter",
//                                     fontSize: 14,
//                                     fontWeight: FontWeight.normal,
//                                   ),
//                                 ),
//                               ),
//                             ),
//                             const SizedBox(width: 10),
//                             Container(
//                               decoration: BoxDecoration(
//                                 border: Border.all(color: Colors.black),
//                                 borderRadius: BorderRadius.circular(8),
//                               ),
//                               child: ElevatedButton(
//                                 onPressed: _deleteImage,
//                                 style: ElevatedButton.styleFrom(
//                                   backgroundColor: Colors.white,
//                                   foregroundColor: Colors.black,
//                                   elevation: 0,
//                                   shape: RoundedRectangleBorder(
//                                     borderRadius: BorderRadius.circular(8),
//                                   ),
//                                   padding: EdgeInsets.symmetric(
//                                     horizontal: 12,
//                                     vertical: 8,
//                                   ),
//                                   minimumSize: Size(0, 0),
//                                   tapTargetSize:
//                                       MaterialTapTargetSize.shrinkWrap,
//                                 ),
//                                 child: const Text(
//                                   'Delete',
//                                   style: TextStyle(
//                                     fontFamily: "Inter",
//                                     fontSize: 14,
//                                     fontWeight: FontWeight.normal,
//                                   ),
//                                 ),
//                               ),
//                             ),
//                           ],
//                         ),

//                         const SizedBox(height: 10),

//                         // Editable Fields
//                         Padding(
//                           padding: const EdgeInsets.all(16.0),
//                           child: Column(
//                             children: [
//                               _buildField(
//                                 label: 'First Name',
//                                 controller: firstNameController,
//                               ),
//                               const SizedBox(height: 12),
//                               _buildField(
//                                 label: 'Last Name',
//                                 controller: lastNameController,
//                               ),
//                               const SizedBox(height: 12),
//                               _buildField(
//                                 label: 'Your Email',
//                                 controller: emailController,
//                               ),
//                               const SizedBox(height: 12),
//                               _buildField(
//                                 label: 'Your Phone Number',
//                                 controller: phoneController,
//                               ),
//                             ],
//                           ),
//                         ),
//                         SizedBox(height: 30.h),
//                         Center(
//                           child: SizedBox(
//                             width: 335.w,
//                             height: 45.h,
//                             child: ElevatedButton(
//                               onPressed: _saveProfile,
//                               style: ElevatedButton.styleFrom(
//                                 backgroundColor: Color(0xFF008AD2),
//                                 shape: RoundedRectangleBorder(
//                                   borderRadius: BorderRadius.circular(10),
//                                 ),
//                                 minimumSize: Size(320.w, 45.h),
//                               ),
//                               child: const Text(
//                                 "Save modification",
//                                 style: TextStyle(color: Colors.white),
//                               ),
//                             ),
//                           ),
//                         ),
//                       ],
//                     ),
//                   ),
//                 ],
//               ),
//     );
//   }

//   Widget _buildField({
//     required String label,
//     required TextEditingController controller,
//     bool obscureText = false,
//   }) {
//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         Text(
//           label,
//           style: const TextStyle(
//             fontSize: 14,
//             fontWeight: FontWeight.w400,
//             color: Color.fromARGB(255, 0, 0, 0),
//           ),
//         ),
//         const SizedBox(height: 6),
//         Container(
//           width: 350.w,
//           height: 40.h,
//           decoration: BoxDecoration(
//             border: Border.all(color: Colors.black),
//             borderRadius: BorderRadius.circular(8),
//           ),
//           child: TextFormField(
//             controller: controller,
//             obscureText: obscureText,
//             decoration: InputDecoration(
//               filled: true,
//               fillColor: const Color.fromARGB(255, 255, 255, 255),
//               contentPadding: EdgeInsets.symmetric(horizontal: 8, vertical: 10),
//               border: OutlineInputBorder(
//                 borderRadius: BorderRadius.circular(8),
//                 borderSide: BorderSide.none,
//               ),
//               isDense: true,
//             ),
//             style: TextStyle(
//               fontSize: 14,
//               color: const Color.fromARGB(255, 184, 184, 184),
//             ),
//           ),
//         ),
//       ],
//     );
//   }
// }

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'package:tawasul_application/Services/api_service.dart';
import 'package:tawasul_application/view/Profile/profile.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class EditProfile extends StatefulWidget {
  const EditProfile({super.key});

  @override
  State<EditProfile> createState() => _EditProfileState();
}

class _EditProfileState extends State<EditProfile> {
  File? _profileImage;
  final ImagePicker _picker = ImagePicker();

  final firstNameController = TextEditingController();
  final lastNameController = TextEditingController();
  final emailController = TextEditingController();
  final phoneController = TextEditingController();
  final passwordController = TextEditingController(text: '********');

  bool _isLoading = true;
  bool _hasError = false;
  Map<String, dynamic>? _customerData;

  @override
  void initState() {
    super.initState();
    _loadCustomerDetails();
  }

  Future<void> _loadCustomerDetails() async {
    setState(() {
      _isLoading = true;
      _hasError = false;
    });

    try {
      final customerDetails = await ApiService.getCustomerDetails();

      if (customerDetails != null && mounted) {
        setState(() {
          _customerData = customerDetails;

          firstNameController.text =
              customerDetails['firstName'] ??
              customerDetails['first_name'] ??
              '';
          lastNameController.text =
              customerDetails['lastName'] ?? customerDetails['last_name'] ?? '';
          emailController.text = customerDetails['email'] ?? '';
          phoneController.text =
              customerDetails['phone'] ?? customerDetails['mobile'] ?? '';
        });
      } else {
        setState(() {
          _hasError = true;
        });
      }
    } catch (e) {
      print("Error loading customer details: $e");
      setState(() {
        _hasError = true;
      });
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  Future<void> _uploadImage() async {
    final picked = await _picker.pickImage(source: ImageSource.gallery);
    if (picked != null) {
      setState(() {
        _profileImage = File(picked.path);
      });
    }
  }

  void _deleteImage() {
    setState(() {
      _profileImage = null;
    });
  }

  void _saveProfile() {
    print(
      'Saved: ${firstNameController.text} ${lastNameController.text}, ${emailController.text}, ${phoneController.text}',
    );
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(AppLocalizations.of(context)!.profileSavedSuccessfully),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final t = AppLocalizations.of(context)!;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 255, 255, 255),
        elevation: 0,
        toolbarHeight: 56.h,
        leadingWidth: 48.w,
        leading: Padding(
          padding: EdgeInsets.only(left: 12.w),
          child: GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const Profile()),
              );
            },
            child: Container(
              width: 36.w,
              height: 36.w,
              decoration: const BoxDecoration(
                color: Color(0xFF008AD2),
                shape: BoxShape.circle,
              ),
              child: Center(
                child: Icon(
                  Icons.arrow_back_ios_new,
                  color: Colors.white,
                  size: 18.sp,
                ),
              ),
            ),
          ),
        ),
        title: Text(
          t.editProfile,
          style: TextStyle(
            fontSize: 18.sp,
            fontWeight: FontWeight.w500,
            color: const Color.fromARGB(255, 0, 0, 0),
          ),
        ),
        centerTitle: true,
      ),
      body:
          _isLoading
              ? const Center(child: CircularProgressIndicator())
              : _hasError
              ? Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(t.failedToLoadProfileData),
                    const SizedBox(height: 16),
                    ElevatedButton(
                      onPressed: _loadCustomerDetails,
                      child: Text(t.retry),
                    ),
                  ],
                ),
              )
              : Stack(
                children: [
                  SafeArea(
                    child: Column(
                      children: [
                        SizedBox(height: 15.h),
                        CircleAvatar(
                          radius: 60,
                          backgroundColor: Colors.grey,
                          backgroundImage:
                              _profileImage != null
                                  ? FileImage(_profileImage!)
                                  : (_customerData?['profile_image'] != null
                                      ? NetworkImage(
                                        _customerData!['profile_image'],
                                      )
                                      : null),
                        ),
                        const SizedBox(height: 10),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Container(
                              decoration: BoxDecoration(
                                border: Border.all(color: Colors.black),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: ElevatedButton(
                                onPressed: _uploadImage,
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.white,
                                  foregroundColor: Colors.black,
                                  elevation: 0,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 12,
                                    vertical: 8,
                                  ),
                                  minimumSize: const Size(0, 0),
                                  tapTargetSize:
                                      MaterialTapTargetSize.shrinkWrap,
                                ),
                                child: Text(
                                  t.upload,
                                  style: const TextStyle(
                                    fontFamily: "Inter",
                                    fontSize: 14,
                                    fontWeight: FontWeight.normal,
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(width: 10),
                            Container(
                              decoration: BoxDecoration(
                                border: Border.all(color: Colors.black),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: ElevatedButton(
                                onPressed: _deleteImage,
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.white,
                                  foregroundColor: Colors.black,
                                  elevation: 0,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 12,
                                    vertical: 8,
                                  ),
                                  minimumSize: const Size(0, 0),
                                  tapTargetSize:
                                      MaterialTapTargetSize.shrinkWrap,
                                ),
                                child: Text(
                                  t.delete,
                                  style: const TextStyle(
                                    fontFamily: "Inter",
                                    fontSize: 14,
                                    fontWeight: FontWeight.normal,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 10),
                        Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Column(
                            children: [
                              _buildField(
                                label: t.firstName,
                                controller: firstNameController,
                              ),
                              const SizedBox(height: 12),
                              _buildField(
                                label: t.lastName,
                                controller: lastNameController,
                              ),
                              const SizedBox(height: 12),
                              _buildField(
                                label: t.yourEmail,
                                controller: emailController,
                              ),
                              const SizedBox(height: 12),
                              _buildField(
                                label: t.yourPhoneNumber,
                                controller: phoneController,
                              ),
                            ],
                          ),
                        ),
                        SizedBox(height: 30.h),
                        Center(
                          child: SizedBox(
                            width: 335.w,
                            height: 45.h,
                            child: ElevatedButton(
                              onPressed: _saveProfile,
                              style: ElevatedButton.styleFrom(
                                backgroundColor: const Color(0xFF008AD2),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                minimumSize: Size(320.w, 45.h),
                              ),
                              child: Text(
                                t.saveModification,
                                style: const TextStyle(color: Colors.white),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
    );
  }

  Widget _buildField({
    required String label,
    required TextEditingController controller,
    bool obscureText = false,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w400,
            color: Color.fromARGB(255, 0, 0, 0),
          ),
        ),
        const SizedBox(height: 6),
        Container(
          width: 350.w,
          height: 40.h,
          decoration: BoxDecoration(
            border: Border.all(color: Colors.black),
            borderRadius: BorderRadius.circular(8),
          ),
          child: TextFormField(
            controller: controller,
            obscureText: obscureText,
            decoration: InputDecoration(
              filled: true,
              fillColor: const Color.fromARGB(255, 255, 255, 255),
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 8,
                vertical: 10,
              ),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: BorderSide.none,
              ),
              isDense: true,
            ),
            style: const TextStyle(
              fontSize: 14,
              color: Color.fromARGB(255, 184, 184, 184),
            ),
          ),
        ),
      ],
    );
  }
}
