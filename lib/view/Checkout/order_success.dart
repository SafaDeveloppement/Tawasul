// import 'dart:io';
// import 'dart:typed_data';
// import 'dart:ui' as ui;
// import 'package:flutter/material.dart';
// import 'package:flutter/rendering.dart';
// import 'package:pdf/pdf.dart';
// import 'package:qr_flutter/qr_flutter.dart';
// import 'package:path_provider/path_provider.dart';
// import 'package:permission_handler/permission_handler.dart';
// import 'package:flutter_gen/gen_l10n/app_localizations.dart';
// import 'package:tawasul_application/view/home_page.dart';
// import 'package:image_picker/image_picker.dart';
// import 'package:pdf/widgets.dart' as pw;

// void main() {
//   runApp(MyApp());
// }

// class MyApp extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       title: 'API Login Demo',
//       theme: ThemeData(primarySwatch: Colors.blue, useMaterial3: true),
//       home: CheckoutSuccess(orderId: '2135'),

//       // Localisation activée
//       localizationsDelegates: AppLocalizations.localizationsDelegates,
//       supportedLocales: AppLocalizations.supportedLocales,
//     );
//   }
// }

// class CheckoutSuccess extends StatefulWidget {
//   final String orderId;

//   const CheckoutSuccess({Key? key, required this.orderId}) : super(key: key);

//   @override
//   State<CheckoutSuccess> createState() => _CheckoutSuccessState();
// }

// class _CheckoutSuccessState extends State<CheckoutSuccess> {
//   final GlobalKey qrKey = GlobalKey();
//   final GlobalKey pageKey = GlobalKey();
//   bool _isSaving = false;

//   Future<bool> _checkPermission() async {
//     var status = await Permission.storage.status;
//     if (!status.isGranted) {
//       status = await Permission.storage.request();
//     }

//     if (status.isDenied || status.isPermanentlyDenied) {
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(
//           content: Text(AppLocalizations.of(context)!.storagePermissionDenied),
//           action: SnackBarAction(
//             label: "Settings",
//             onPressed: () async {
//               await openAppSettings(); // Navigue vers les paramètres
//             },
//           ),
//         ),
//       );
//       return false;
//     }
//     return true;
//   }

//   Future<void> _saveQrToGallery() async {
//     if (_isSaving) return;

//     setState(() => _isSaving = true);

//     if (!await _checkPermission()) {
//       setState(() => _isSaving = false);
//       return;
//     }

//     try {
//       RenderRepaintBoundary? boundary =
//           qrKey.currentContext?.findRenderObject() as RenderRepaintBoundary?;
//       if (boundary == null) throw Exception("QR widget not found");

//       ui.Image image = await boundary.toImage(pixelRatio: 3.0);
//       ByteData? byteData = await image.toByteData(
//         format: ui.ImageByteFormat.png,
//       );
//       if (byteData == null) throw Exception("Failed to convert QR image");

//       Uint8List pngBytes = byteData.buffer.asUint8List();

//       final directory = await getTemporaryDirectory();
//       String filePath = '${directory.path}/qr_${widget.orderId}.png';
//       File imgFile = File(filePath);
//       await imgFile.writeAsBytes(pngBytes);

//       if (Platform.isAndroid) {
//         final ImagePicker picker = ImagePicker();
//         XFile? xFile = XFile(filePath);
//         await Future.delayed(Duration(milliseconds: 500));
//       }

//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(
//           content: Text(AppLocalizations.of(context)!.qrCodeSavedToGallery),
//         ),
//       );
//     } catch (e) {
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(content: Text("${AppLocalizations.of(context)!.error}: $e")),
//       );
//     } finally {
//       setState(() => _isSaving = false);
//     }
//   }

//   Future<void> _captureAndSavePDF() async {
//     if (_isSaving) return;

//     setState(() => _isSaving = true);

//     if (!await _checkPermission()) {
//       setState(() => _isSaving = false);
//       return;
//     }

//     try {
//       RenderRepaintBoundary? boundary =
//           pageKey.currentContext?.findRenderObject() as RenderRepaintBoundary?;
//       if (boundary == null) throw Exception("Page widget not found");

//       ui.Image image = await boundary.toImage(pixelRatio: 2.0);
//       ByteData? byteData = await image.toByteData(
//         format: ui.ImageByteFormat.png,
//       );
//       if (byteData == null) throw Exception('Failed to capture screenshot');

//       Uint8List imageBytes = byteData.buffer.asUint8List();

//       final pdf = pw.Document();
//       final pdfImage = pw.MemoryImage(imageBytes);

//       pdf.addPage(
//         pw.Page(
//           pageFormat: PdfPageFormat.a4,
//           build: (pw.Context context) => pw.Center(child: pw.Image(pdfImage)),
//         ),
//       );

//       Directory downloadsDir;
//       if (Platform.isAndroid) {
//         downloadsDir = Directory("/storage/emulated/0/Download");
//         if (!await downloadsDir.exists()) {
//           downloadsDir =
//               await getExternalStorageDirectory() ??
//               await getApplicationDocumentsDirectory();
//         }
//       } else {
//         downloadsDir = await getApplicationDocumentsDirectory();
//       }

//       final fileName =
//           "order_${widget.orderId}_${DateTime.now().millisecondsSinceEpoch}.pdf";
//       final path = "${downloadsDir.path}/$fileName";
//       final file = File(path);
//       await file.writeAsBytes(await pdf.save());

//       ScaffoldMessenger.of(
//         context,
//       ).showSnackBar(SnackBar(content: Text("PDF saved to: $path")));
//     } catch (e) {
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(content: Text("${AppLocalizations.of(context)!.error}: $e")),
//       );
//     } finally {
//       setState(() => _isSaving = false);
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     final t = AppLocalizations.of(context)!;

//     return Scaffold(
//       backgroundColor: Colors.white,
//       appBar: AppBar(
//         elevation: 0,
//         backgroundColor: Colors.white,
//         centerTitle: true,
//         title: Text(
//           t.checkout,
//           style: TextStyle(color: Colors.black, fontWeight: FontWeight.w600),
//         ),
//         leading: IconButton(
//           icon: Icon(Icons.arrow_back, color: Colors.blue),
//           onPressed: () => Navigator.pop(context),
//         ),
//       ),
//       body: RepaintBoundary(
//         key: pageKey,
//         child: Container(
//           color: Colors.white,
//           padding: const EdgeInsets.all(20),
//           child: Column(
//             mainAxisAlignment: MainAxisAlignment.center,
//             children: [
//               Container(
//                 decoration: BoxDecoration(
//                   shape: BoxShape.circle,
//                   color: Colors.green,
//                 ),
//                 padding: const EdgeInsets.all(16),
//                 child: Icon(Icons.check, color: Colors.white, size: 48),
//               ),
//               SizedBox(height: 20),

//               Text(
//                 t.orderPlaced,
//                 style: TextStyle(fontSize: 22, fontWeight: FontWeight.w700),
//               ),

//               SizedBox(height: 10),

//               RichText(
//                 textAlign: TextAlign.center,
//                 text: TextSpan(
//                   text: "${t.yourOrder} ",
//                   style: TextStyle(color: Colors.black54, fontSize: 14),
//                   children: [
//                     TextSpan(text: "#", style: TextStyle(color: Colors.blue)),
//                     TextSpan(
//                       text: widget.orderId,
//                       style: TextStyle(
//                         color: Colors.blue,
//                         fontWeight: FontWeight.w600,
//                       ),
//                     ),
//                     TextSpan(text: " ${t.wasPlacedSuccessfully}"),
//                   ],
//                 ),
//               ),

//               SizedBox(height: 8),
//               Text(
//                 t.checkOrdersForDetails,
//                 textAlign: TextAlign.center,
//                 style: TextStyle(color: Colors.black45, fontSize: 13),
//               ),

//               SizedBox(height: 30),

//               RepaintBoundary(
//                 key: qrKey,
//                 child: Container(
//                   padding: EdgeInsets.all(10),
//                   decoration: BoxDecoration(
//                     color: Colors.white,
//                     borderRadius: BorderRadius.circular(10),
//                     boxShadow: [
//                       BoxShadow(
//                         color: Colors.black12,
//                         blurRadius: 5,
//                         offset: Offset(0, 2),
//                       ),
//                     ],
//                   ),
//                   child: QrImageView(
//                     data: widget.orderId,
//                     version: QrVersions.auto,
//                     size: 160.0,
//                     backgroundColor: Colors.white,
//                   ),
//                 ),
//               ),

//               SizedBox(height: 30),

//               _buildButton(
//                 color: Colors.blue,
//                 icon: Icons.download,
//                 text: t.download,
//                 onTap: _saveQrToGallery,
//               ),

//               SizedBox(height: 15),

//               _buildButton(
//                 color: Colors.orange,
//                 icon: Icons.picture_as_pdf,
//                 text: "Download PDF",
//                 onTap: _captureAndSavePDF,
//               ),

//               SizedBox(height: 15),

//               _buildButton(
//                 color: Colors.grey[200]!,
//                 icon: Icons.home,
//                 text: t.backToHomePage,
//                 textColor: Colors.blue,
//                 onTap:
//                     () => Navigator.push(
//                       context,
//                       MaterialPageRoute(builder: (_) => HomePage()),
//                     ),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }

//   Widget _buildButton({
//     required Color color,
//     required IconData icon,
//     required String text,
//     Color textColor = Colors.white,
//     required VoidCallback onTap,
//   }) {
//     return SizedBox(
//       width: double.infinity,
//       child: ElevatedButton(
//         style: ElevatedButton.styleFrom(
//           padding: const EdgeInsets.symmetric(vertical: 14),
//           backgroundColor: color,
//           shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
//         ),
//         onPressed: _isSaving ? null : onTap,
//         child:
//             _isSaving
//                 ? SizedBox(
//                   height: 20,
//                   width: 20,
//                   child: CircularProgressIndicator(
//                     strokeWidth: 2,
//                     valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
//                   ),
//                 )
//                 : Row(
//                   mainAxisAlignment: MainAxisAlignment.center,
//                   children: [
//                     Icon(icon, color: textColor),
//                     SizedBox(width: 8),
//                     Text(
//                       text,
//                       style: TextStyle(fontSize: 16, color: textColor),
//                     ),
//                   ],
//                 ),
//       ),
//     );
//   }
// }

import 'dart:io';
import 'dart:typed_data';
import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:pdf/pdf.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:tawasul_application/view/home_page.dart';
import 'package:image_picker/image_picker.dart';
import 'package:pdf/widgets.dart' as pw;

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'API Login Demo',
      theme: ThemeData(primarySwatch: Colors.blue, useMaterial3: true),
      home: CheckoutSuccess(orderId: '2135'),

      // Localisation activée
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
    );
  }
}

class CheckoutSuccess extends StatefulWidget {
  final String orderId;

  const CheckoutSuccess({Key? key, required this.orderId}) : super(key: key);

  @override
  State<CheckoutSuccess> createState() => _CheckoutSuccessState();
}

class _CheckoutSuccessState extends State<CheckoutSuccess> {
  final GlobalKey qrKey = GlobalKey();
  final GlobalKey contentKey = GlobalKey(); // Renamed for clarity
  bool _isSaving = false;

  Future<bool> _checkPermission() async {
    var status = await Permission.storage.status;
    if (!status.isGranted) {
      status = await Permission.storage.request();
    }

    if (status.isDenied || status.isPermanentlyDenied) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(AppLocalizations.of(context)!.storagePermissionDenied),
          action: SnackBarAction(
            label: "Settings",
            onPressed: () async {
              await openAppSettings(); // Navigue vers les paramètres
            },
          ),
        ),
      );
      return false;
    }
    return true;
  }

  Future<void> _saveQrToGallery() async {
    if (_isSaving) return;

    setState(() => _isSaving = true);

    if (!await _checkPermission()) {
      setState(() => _isSaving = false);
      return;
    }

    try {
      RenderRepaintBoundary? boundary =
          qrKey.currentContext?.findRenderObject() as RenderRepaintBoundary?;
      if (boundary == null) throw Exception("QR widget not found");

      ui.Image image = await boundary.toImage(pixelRatio: 3.0);
      ByteData? byteData = await image.toByteData(
        format: ui.ImageByteFormat.png,
      );
      if (byteData == null) throw Exception("Failed to convert QR image");

      Uint8List pngBytes = byteData.buffer.asUint8List();

      final directory = await getTemporaryDirectory();
      String filePath = '${directory.path}/qr_${widget.orderId}.png';
      File imgFile = File(filePath);
      await imgFile.writeAsBytes(pngBytes);

      if (Platform.isAndroid) {
        final ImagePicker picker = ImagePicker();
        XFile? xFile = XFile(filePath);
        await Future.delayed(Duration(milliseconds: 500));
      }

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(AppLocalizations.of(context)!.qrCodeSavedToGallery),
        ),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("${AppLocalizations.of(context)!.error}: $e")),
      );
    } finally {
      setState(() => _isSaving = false);
    }
  }

  Future<void> _captureAndSavePDF() async {
    if (_isSaving) return;

    setState(() => _isSaving = true);

    if (!await _checkPermission()) {
      setState(() => _isSaving = false);
      return;
    }

    try {
      // Use contentKey instead of pageKey to exclude buttons
      RenderRepaintBoundary? boundary =
          contentKey.currentContext?.findRenderObject()
              as RenderRepaintBoundary?;
      if (boundary == null) throw Exception("Content widget not found");

      ui.Image image = await boundary.toImage(pixelRatio: 2.0);
      ByteData? byteData = await image.toByteData(
        format: ui.ImageByteFormat.png,
      );
      if (byteData == null) throw Exception('Failed to capture screenshot');

      Uint8List imageBytes = byteData.buffer.asUint8List();

      final pdf = pw.Document();
      final pdfImage = pw.MemoryImage(imageBytes);

      pdf.addPage(
        pw.Page(
          pageFormat: PdfPageFormat.a4,
          build: (pw.Context context) => pw.Center(child: pw.Image(pdfImage)),
        ),
      );

      Directory downloadsDir;
      if (Platform.isAndroid) {
        downloadsDir = Directory("/storage/emulated/0/Download");
        if (!await downloadsDir.exists()) {
          downloadsDir =
              await getExternalStorageDirectory() ??
              await getApplicationDocumentsDirectory();
        }
      } else {
        downloadsDir = await getApplicationDocumentsDirectory();
      }

      final fileName =
          "order_${widget.orderId}_${DateTime.now().millisecondsSinceEpoch}.pdf";
      final path = "${downloadsDir.path}/$fileName";
      final file = File(path);
      await file.writeAsBytes(await pdf.save());

      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text("PDF saved to: $path")));
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("${AppLocalizations.of(context)!.error}: $e")),
      );
    } finally {
      setState(() => _isSaving = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final t = AppLocalizations.of(context)!;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        centerTitle: true,
        title: Text(
          t.checkout,
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.w600),
        ),
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.blue),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Container(
        color: Colors.white,
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Content that will be captured in PDF (excluding buttons)
            RepaintBoundary(
              key: contentKey,
              child: Container(
                color: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 20),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.green,
                      ),
                      padding: const EdgeInsets.all(16),
                      child: Icon(Icons.check, color: Colors.white, size: 48),
                    ),
                    SizedBox(height: 20),

                    Text(
                      t.orderPlaced,
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.w700,
                      ),
                    ),

                    SizedBox(height: 10),

                    RichText(
                      textAlign: TextAlign.center,
                      text: TextSpan(
                        text: "${t.yourOrder} ",
                        style: TextStyle(color: Colors.black54, fontSize: 14),
                        children: [
                          TextSpan(
                            text: "#",
                            style: TextStyle(color: Colors.blue),
                          ),
                          TextSpan(
                            text: widget.orderId,
                            style: TextStyle(
                              color: Colors.blue,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          TextSpan(text: " ${t.wasPlacedSuccessfully}"),
                        ],
                      ),
                    ),

                    SizedBox(height: 8),
                    Text(
                      t.checkOrdersForDetails,
                      textAlign: TextAlign.center,
                      style: TextStyle(color: Colors.black45, fontSize: 13),
                    ),

                    SizedBox(height: 30),

                    RepaintBoundary(
                      key: qrKey,
                      child: Container(
                        padding: EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(10),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black12,
                              blurRadius: 5,
                              offset: Offset(0, 2),
                            ),
                          ],
                        ),
                        child: QrImageView(
                          data: widget.orderId,
                          version: QrVersions.auto,
                          size: 160.0,
                          backgroundColor: Colors.white,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),

            SizedBox(height: 30),

            // _buildButton(
            //   color: Colors.blue,
            //   icon: Icons.download,
            //   text: t.download,
            //   onTap: _saveQrToGallery,
            // ),
            SizedBox(height: 15),

            _buildButton(
              color: Colors.orange,
              icon: Icons.picture_as_pdf,
              text: t.download,
              onTap: _captureAndSavePDF,
            ),

            SizedBox(height: 15),

            _buildButton(
              color: Colors.grey[200]!,
              icon: Icons.home,
              text: t.backToHomePage,
              textColor: Colors.blue,
              onTap:
                  () => Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => HomePage()),
                  ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildButton({
    required Color color,
    required IconData icon,
    required String text,
    Color textColor = Colors.white,
    required VoidCallback onTap,
  }) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          padding: const EdgeInsets.symmetric(vertical: 14),
          backgroundColor: color,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        ),
        onPressed: _isSaving ? null : onTap,
        child:
            _isSaving
                ? SizedBox(
                  height: 20,
                  width: 20,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                  ),
                )
                : Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(icon, color: textColor),
                    SizedBox(width: 8),
                    Text(
                      text,
                      style: TextStyle(fontSize: 16, color: textColor),
                    ),
                  ],
                ),
      ),
    );
  }
}
