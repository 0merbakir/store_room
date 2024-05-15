import 'dart:developer';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';

class ScanQRCode extends StatefulWidget {
  const ScanQRCode({super.key});

  @override
  State<StatefulWidget> createState() => _ScanQRCodeState();
}

class _ScanQRCodeState extends State<ScanQRCode> {
  Barcode? result;
  QRViewController? controller;
  final GlobalKey qrKey = GlobalKey(debugLabel: 'QR');

  @override
  void reassemble() {
    super.reassemble();
    if (Platform.isAndroid) {
      controller!.pauseCamera();
    }
    controller!.resumeCamera();
  }

  String truncateText(String text, {int maxLength = 10}) {
    if (text.length <= maxLength) {
      return text;
    } else {
      return '${text.substring(0, maxLength)}...';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        clipBehavior: Clip.antiAlias,
        children: <Widget>[
          Positioned(child: _buildQrView(context)),
          Positioned(
            bottom: 10,
            left: 40,
            height: 300,
            width: 300,
            child: FittedBox(
              fit: BoxFit.contain,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  if (result != null)
                    Column(
                      children: [
                        Row(
                          children: [
                            const Text(
                              'Format:',
                              style: TextStyle(
                                color: Color.fromARGB(224, 255, 255, 255),
                                fontSize: 12,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Text(
                              '  ${truncateText(describeEnum(result!.format))}',
                              style: const TextStyle(
                                color: Color.fromARGB(148, 255, 255, 255),
                                fontSize: 12,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),

                        const SizedBox(
                            height: 10), // Add space between text items
                        Row(
                          children: [
                            const Text(
                              'Kod: ',
                              style: TextStyle(
                                color: Color.fromARGB(221, 255, 255, 255),
                                fontSize: 12,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Text(
                              '${truncateText(result!.code!)}',
                              style: const TextStyle(
                                color: Color.fromARGB(179, 255, 255, 255),
                                fontSize: 12,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        )
                      ],
                    )
                  else
                    const Text(
                      'Taranıyor...',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  const SizedBox(
                    height: 16,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      Container(
                        margin: const EdgeInsets.all(4), // Reduce margin
                        child: ElevatedButton(
                          onPressed: () async {
                            await controller!.toggleFlash();
                            setState(() {});
                          },
                          style: ElevatedButton.styleFrom(
                            padding: const EdgeInsets.all(4), // Reduce padding
                            backgroundColor: Colors.transparent,
                          ),
                          child: FutureBuilder(
                            future: controller != null
                                ? controller!.getFlashStatus()
                                : Future.value(false),
                            builder: (context, AsyncSnapshot<bool?> snapshot) {
                              if (snapshot.hasData && snapshot.data != null) {
                                return Icon(
                                  Icons.flash_on,
                                  size: 16,
                                  color: snapshot.data!
                                      ? const Color.fromARGB(255, 11, 153, 247)
                                      : Colors.white,
                                );
                              } else {
                                return const CircularProgressIndicator();
                              }
                            },
                          ),
                        ),
                      ),
                      Container(
                        margin: const EdgeInsets.all(4), // Reduce margin
                        child: ElevatedButton(
                          onPressed: () async {
                            if (result != null) {
                              Navigator.pop(context, result!.code);
                            }
                          },
                          style: ElevatedButton.styleFrom(
                            padding: const EdgeInsets.all(4), // Reduce padding
                            backgroundColor: Colors.transparent,
                          ),
                          child: const Icon(
                            Icons.done_sharp,
                            size: 16,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildQrView(BuildContext context) {
    var scanArea = (MediaQuery.of(context).size.width < 400 ||
            MediaQuery.of(context).size.height < 400)
        ? 175.0
        : 325.0;
    return QRView(
      key: qrKey,
      onQRViewCreated: _onQRViewCreated,
      overlay: QrScannerOverlayShape(
          borderColor: Colors.red,
          borderRadius: 10,
          borderLength: 30,
          borderWidth: 10,
          cutOutSize: scanArea),
      onPermissionSet: (ctrl, p) => _onPermissionSet(context, ctrl, p),
    );
  }

  void _onQRViewCreated(QRViewController controller) {
    setState(() {
      this.controller = controller;
    });
    controller.scannedDataStream.listen((scanData) {
      setState(() {
        result = scanData;
        // Automatically close the page and return the detected QR code to the previous page
      });
    });
  }

  void _onPermissionSet(BuildContext context, QRViewController ctrl, bool p) {
    log('${DateTime.now().toIso8601String()}_onPermissionSet $p');
    if (!p) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('İzin Verilmedi!')),
      );
    }
  }

  @override
  void dispose() {
    controller?.dispose();
    super.dispose();
  }
}
