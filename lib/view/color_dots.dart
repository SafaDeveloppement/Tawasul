
// import 'package:flutter/material.dart';

// class ColorDot extends StatelessWidget {
//   final Color color;
//   final bool isSelected;
//   final VoidCallback? onTap;

//   const ColorDot({
//     Key? key,
//     required this.color,
//     this.isSelected = false,
//     this.onTap,
//   }) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     return GestureDetector(
//       onTap: onTap,
//       child: Container(
//         width: 24,
//         height: 24,
//         decoration: BoxDecoration(
//           color: color,
//           shape: BoxShape.circle,
//           border: isSelected
//               ? Border.all(color: Colors.white, width: 2)
//               : null,
//           boxShadow: [
//             BoxShadow(
//               color: Colors.black.withOpacity(0.1),
//               blurRadius: 2,
//               offset: Offset(0, 1),
//             ),
//           ],
//         ),
//         child: isSelected
//             ? Icon(
//                 Icons.check,
//                 size: 16,
//                 color: color.computeLuminance() > 0.5 
//                     ? Colors.black 
//                     : Colors.white,
//               )
//             : null,
//       ),
//     );
//   }
// }