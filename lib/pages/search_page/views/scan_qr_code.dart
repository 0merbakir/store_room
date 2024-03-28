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

  static bool? isCamPaused;

  @override
  void initState() {
    isCamPaused = false;
    super.initState();
  }

  // In order to get hot reload to work we need to pause the camera if the platform
  // is android, or resume the camera if the platform is iOS.
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
                    Text(
                      'Code Format: ${truncateText(describeEnum(result!.format))}   Veri: ${truncateText(result!.code!)}',
                      style: const TextStyle(
                        color: Colors.white, // Set text color to white
                        fontSize: 16, // Adjust font size as needed
                        fontWeight:
                            FontWeight.bold, // Apply font weight if desired
                      ),
                    )
                  else
                    const Text(
                      'Taranıyor...',
                      style: TextStyle(
                        color: Colors.white, // Set text color to white
                        fontSize: 16, // Adjust font size as needed
                        fontWeight:
                            FontWeight.bold, // Apply font weight if desired
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
                        margin: const EdgeInsets.all(8),
                        child: ElevatedButton(
                          onPressed: () async {
                            await controller!.toggleFlash();
                            setState(() {});
                          },
                          style: ElevatedButton.styleFrom(
                            padding: EdgeInsets.zero, // Remove padding

                            backgroundColor: Colors
                                .transparent, // Set button background color to transparent
                          ),
                          child: FutureBuilder(
                            future: controller != null
                                ? controller!.getFlashStatus()
                                : Future.value(false),
                            builder: (context, AsyncSnapshot<bool?> snapshot) {
                              if (snapshot.hasData && snapshot.data != null) {
                                return Icon(
                                  Icons.flash_on,
                                  color: snapshot.data!
                                      ? const Color.fromARGB(255, 11, 153, 247)
                                      : Colors.white,
                                );
                              } else {
                                return const CircularProgressIndicator(); // Future is not complete yet or data is null
                              }
                            },
                          ),
                        ),
                      ),
                      Container(
                        margin: const EdgeInsets.all(8),
                        child: ElevatedButton(
                            onPressed: () async {
                              await controller?.flipCamera();
                              setState(() {});
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors
                                  .transparent, // Set button background color to transparent
                            ),
                            child: FutureBuilder(
                              future: controller?.getCameraInfo(),
                              builder: (context, snapshot) {
                                if (snapshot.data != null) {
                                  return const Icon(
                                    IconData(0xe62b,
                                        fontFamily: 'MaterialIcons'),
                                    color: Colors.white,
                                  );
                                } else {
                                  return const CircularProgressIndicator( color: Colors.white,);
                                }
                              },
                            )),
                      ),
                      Container(
                        margin: const EdgeInsets.all(8),
                        child: ElevatedButton(
                          onPressed: () async {
                            if (isCamPaused!) {
                              // Check if camera is not paused
                              await controller?.resumeCamera();
                              setState(() {
                                isCamPaused = false;
                              });
                            } else {
                              await controller?.pauseCamera();
                              setState(() {
                                isCamPaused = true;
                              });
                            }
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors
                                .transparent, // Set button background color to transparent
                          ),
                          child: isCamPaused!
                              ? const Icon(
                                  Icons.pause_sharp,
                                  color: Colors.white,
                                )
                              : const Icon(Icons.stop_sharp,
                                  color: Colors.white),
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
    // For this example we check how width or tall the device is and change the scanArea and overlay accordingly.
    var scanArea = (MediaQuery.of(context).size.width < 400 ||
            MediaQuery.of(context).size.height < 400)
        ? 175.0
        : 325.0;
    // To ensure the Scanner view is properly sizes after rotation
    // we need to listen for Flutter SizeChanged notification and update controller
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
