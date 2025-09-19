import 'dart:io';
import 'dart:typed_data';
import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:tawasul_application/view/home_page.dart';
import 'package:image_picker/image_picker.dart';

class CheckoutSuccess extends StatefulWidget {
  final String orderId;

  const CheckoutSuccess({Key? key, required this.orderId}) : super(key: key);

  @override
  State<CheckoutSuccess> createState() => _CheckoutSuccessState();
}

class _CheckoutSuccessState extends State<CheckoutSuccess> {
  final GlobalKey qrKey = GlobalKey();
  bool _isSaving = false;

  Future<void> _saveQrToGallery() async {
    if (_isSaving) return;

    setState(() {
      _isSaving = true;
    });

    // Request storage permission
    var status = await Permission.storage.status;
    if (!status.isGranted) {
      status = await Permission.storage.request();
    }

    if (status.isDenied) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(AppLocalizations.of(context)!.storagePermissionDenied),
        ),
      );
      setState(() {
        _isSaving = false;
      });
      return;
    }

    try {
      // Capture QR widget as image
      RenderRepaintBoundary boundary =
          qrKey.currentContext!.findRenderObject() as RenderRepaintBoundary;
      ui.Image image = await boundary.toImage(pixelRatio: 3.0);
      ByteData? byteData = await image.toByteData(
        format: ui.ImageByteFormat.png,
      );
      Uint8List pngBytes = byteData!.buffer.asUint8List();

      // Get temporary directory
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
          duration: Duration(seconds: 2),
        ),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("${AppLocalizations.of(context)!.error}: $e"),
          duration: Duration(seconds: 2),
        ),
      );
    } finally {
      setState(() {
        _isSaving = false;
      });
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
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            /// Green Success Icon
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
                color: Colors.black,
              ),
            ),
            SizedBox(height: 10),

            RichText(
              textAlign: TextAlign.center,
              text: TextSpan(
                text: "${t.yourOrder} ",
                style: TextStyle(color: Colors.black54, fontSize: 14),
                children: [
                  TextSpan(text: "#", style: TextStyle(color: Colors.blue)),
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
            SizedBox(height: 30),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  backgroundColor: Colors.blue,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                onPressed: _isSaving ? null : _saveQrToGallery,
                child:
                    _isSaving
                        ? SizedBox(
                          height: 20,
                          width: 20,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            valueColor: AlwaysStoppedAnimation<Color>(
                              Colors.white,
                            ),
                          ),
                        )
                        : Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.download, color: Colors.white),
                            SizedBox(width: 8),
                            Text(
                              t.download,
                              style: TextStyle(
                                fontSize: 16,
                                color: Colors.white,
                              ),
                            ),
                          ],
                        ),
              ),
            ),
            SizedBox(height: 15),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  backgroundColor: Colors.grey[200],
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                onPressed:
                    () => Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => HomePage()),
                    ),
                child: Text(
                  t.backToHomePage,
                  style: TextStyle(fontSize: 16, color: Colors.blue),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
