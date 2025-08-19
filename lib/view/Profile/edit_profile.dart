// import 'package:flutter/material.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';
// import 'dart:io';
// import 'package:image_picker/image_picker.dart';
// import 'package:tawasul_application/view/Profile/profile.dart';

// class EditProfile extends StatefulWidget {
//   const EditProfile({super.key});

//   @override
//   State<EditProfile> createState() => _EditProfileState();
// }

// class _EditProfileState extends State<EditProfile> {
//   File? _profileImage;
//   final ImagePicker _picker = ImagePicker();

//   final nameController = TextEditingController(text: 'Lobna Bechikh');
//   final emailController = TextEditingController(text: 'lobna@gmail.com');
//   final phoneController = TextEditingController(text: '+21899218487');
//   final passwordController = TextEditingController(text: '********');

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
//     print('Saved: ${nameController.text}, ${emailController.text}');
//     ScaffoldMessenger.of(
//       context,
//     ).showSnackBar(SnackBar(content: Text("Profile saved successfully")));
//   }

//   @override
//   Widget build(BuildContext context) {
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
//           "Edit profile",
//           style: TextStyle(
//             fontSize: 18.sp,
//             fontWeight: FontWeight.w500,
//             color: const Color.fromARGB(255, 0, 0, 0),
//           ),
//         ),
//         centerTitle: true,
//       ),
//       body: Stack(
//         children: [
//           SafeArea(
//             child: Column(
//               children: [
//                 SizedBox(height: 15.h),
//                 // Profile Image
//                 CircleAvatar(
//                   radius: 60,
//                   backgroundImage:
//                       _profileImage != null
//                           ? FileImage(_profileImage!)
//                           : const AssetImage('assets/images/homme.jpg')
//                               as ImageProvider,
//                 ),
//                 const SizedBox(height: 10),
//                 Row(
//                   mainAxisAlignment: MainAxisAlignment.center,
//                   children: [
//                     Container(
//                       decoration: BoxDecoration(
//                         border: Border.all(color: Colors.black),
//                         borderRadius: BorderRadius.circular(8),
//                       ),
//                       child: ElevatedButton(
//                         onPressed: _uploadImage,
//                         style: ElevatedButton.styleFrom(
//                           backgroundColor: Colors.white,
//                           foregroundColor: Colors.black,
//                           elevation: 0,
//                           shape: RoundedRectangleBorder(
//                             borderRadius: BorderRadius.circular(8),
//                           ),
//                           padding: EdgeInsets.symmetric(
//                             horizontal: 12,
//                             vertical: 8,
//                           ), // Reduced padding
//                           minimumSize: Size(
//                             0,
//                             0,
//                           ), // Removes minimum size constraints
//                           tapTargetSize:
//                               MaterialTapTargetSize
//                                   .shrinkWrap, // Reduces tap target size
//                         ),
//                         child: Text(
//                           'Upload',
//                           style: TextStyle(
//                             fontFamily: "Inter",
//                             fontSize: 14,
//                             fontWeight: FontWeight.normal,
//                           ),
//                         ),
//                       ),
//                     ),
//                     const SizedBox(width: 10),
//                     Container(
//                       decoration: BoxDecoration(
//                         border: Border.all(color: Colors.black),
//                         borderRadius: BorderRadius.circular(8),
//                       ),
//                       child: ElevatedButton(
//                         onPressed: _deleteImage,
//                         style: ElevatedButton.styleFrom(
//                           backgroundColor: Colors.white,
//                           foregroundColor: Colors.black,
//                           elevation: 0,
//                           shape: RoundedRectangleBorder(
//                             borderRadius: BorderRadius.circular(8),
//                           ),
//                           padding: EdgeInsets.symmetric(
//                             horizontal: 12,
//                             vertical: 8,
//                           ),
//                           minimumSize: Size(0, 0),
//                           tapTargetSize: MaterialTapTargetSize.shrinkWrap,
//                         ),
//                         child: const Text(
//                           'Delete',
//                           style: TextStyle(
//                             fontFamily: "Inter",
//                             fontSize: 14,
//                             fontWeight: FontWeight.normal,
//                           ),
//                         ),
//                       ),
//                     ),
//                   ],
//                 ),

//                 const SizedBox(height: 10),

//                 // Editable Fields
//                 Padding(
//                   padding: const EdgeInsets.all(16.0),
//                   child: Column(
//                     children: [
//                       _buildField(
//                         label: 'Your Name',
//                         controller: nameController,
//                       ),
//                       const SizedBox(height: 12),
//                       _buildField(
//                         label: 'Your Email',
//                         controller: emailController,
//                       ),
//                       const SizedBox(height: 12),
//                       _buildField(
//                         label: 'Your Phone Number',
//                         controller: phoneController,
//                       ),
//                       const SizedBox(height: 12),
//                       _buildField(
//                         label: 'Your Password',
//                         controller: passwordController,
//                         obscureText: true,
//                       ),
//                     ],
//                   ),
//                 ),
//                 SizedBox(height: 30.h),
//                 Center(
//                   child: SizedBox(
//                     width: 320.w,
//                     height: 45.h,
//                     child: Row(
//                       mainAxisAlignment: MainAxisAlignment.end,
//                       children: [
//                         ElevatedButton(
//                           onPressed: _saveProfile,
//                           style: ElevatedButton.styleFrom(
//                             backgroundColor: Color(0xFF008AD2),
//                             shape: RoundedRectangleBorder(
//                               borderRadius: BorderRadius.circular(6),
//                             ),
//                           ),
//                           child: const Text(
//                             "Save modification",
//                             style: TextStyle(color: Colors.white),
//                           ),
//                         ),
//                       ],
//                     ),
//                   ),
//                 ),
//               ],
//             ),
//           ),
//         ],
//       ),
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
//           height: 40.h, // Reduced container height
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
//               contentPadding: EdgeInsets.symmetric(
//                 horizontal: 8,
//                 vertical: 10,
//               ), // Very compact
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
import 'package:tawasul_application/view/Profile/profile.dart';

class EditProfile extends StatefulWidget {
  const EditProfile({super.key});

  @override
  State<EditProfile> createState() => _EditProfileState();
}

class _EditProfileState extends State<EditProfile> {
  File? _profileImage;
  final ImagePicker _picker = ImagePicker();

  final nameController = TextEditingController(text: 'Med Bechikh');
  final emailController = TextEditingController(text: 'Med@gmail.com');
  final phoneController = TextEditingController(text: '+21899218487');
  final passwordController = TextEditingController(text: '********');

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
    // Implement save logic here (e.g., send to backend)
    print('Saved: ${nameController.text}, ${emailController.text}');
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text("Profile saved successfully")));
  }

  @override
  Widget build(BuildContext context) {
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
                MaterialPageRoute(builder: (context) => Profile()),
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
          "Edit profile",
          style: TextStyle(
            fontSize: 18.sp,
            fontWeight: FontWeight.w500,
            color: const Color.fromARGB(255, 0, 0, 0),
          ),
        ),
        centerTitle: true,
      ),
      body: Stack(
        children: [
          SafeArea(
            child: Column(
              children: [
                SizedBox(height: 15.h),
                // Profile Image
                CircleAvatar(
                  radius: 60,
                  backgroundImage:
                      _profileImage != null
                          ? FileImage(_profileImage!)
                          : const AssetImage('assets/images/homme.jpg')
                              as ImageProvider,
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
                          padding: EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 8,
                          ), // Reduced padding
                          minimumSize: Size(
                            0,
                            0,
                          ), // Removes minimum size constraints
                          tapTargetSize:
                              MaterialTapTargetSize
                                  .shrinkWrap, // Reduces tap target size
                        ),
                        child: Text(
                          'Upload',
                          style: TextStyle(
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
                          padding: EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 8,
                          ),
                          minimumSize: Size(0, 0),
                          tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                        ),
                        child: const Text(
                          'Delete',
                          style: TextStyle(
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

                // Editable Fields
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    children: [
                      _buildField(
                        label: 'Your Name',
                        controller: nameController,
                      ),
                      const SizedBox(height: 12),
                      _buildField(
                        label: 'Your Email',
                        controller: emailController,
                      ),
                      const SizedBox(height: 12),
                      _buildField(
                        label: 'Your Phone Number',
                        controller: phoneController,
                      ),
                      const SizedBox(height: 12),
                      _buildField(
                        label: 'Your Password',
                        controller: passwordController,
                        obscureText: true,
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
                        backgroundColor: Color(0xFF008AD2),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        minimumSize: Size(
                          320.w,
                          45.h,
                        ), // Ensure full width/height
                      ),
                      child: const Text(
                        "Save modification",
                        style: TextStyle(color: Colors.white),
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
          height: 40.h, // Reduced container height
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
              contentPadding: EdgeInsets.symmetric(
                horizontal: 8,
                vertical: 10,
              ), // Very compact
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: BorderSide.none,
              ),
              isDense: true,
            ),
            style: TextStyle(
              fontSize: 14,
              color: const Color.fromARGB(255, 184, 184, 184),
            ),
          ),
        ),
      ],
    );
  }
}
