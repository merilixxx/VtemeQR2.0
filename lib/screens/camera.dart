// import 'dart:html';

// import 'package:flutter/foundation.dart';
// import 'package:flutter/gestures.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter/rendering.dart';
// import 'package:flutter/services.dart';

// class PlatformView extends StatefulWidget {
//   const PlatformView({Key? key}) : super(key: key);

//   @override
//   State<PlatformView> createState() => _PlatformViewState();
// }

// class _PlatformViewState extends State<PlatformView> {
//   final MethodChannel platformMethodChannel = MethodChannel('flashlight');
//   bool isFlashOn = false;
//   bool permissionIsGranted = false;
//   String result = '';

//   void _handleQRcodeResult() {
//     const EventChannel _stream = EventChannel('qrcodeResultStream');
//     _stream.receiveBroadcastStream().listen((onData) {
//       print('EventChannel onData = $onData');
//       result = onData;
//       setState(() {});
//     });
//   }

//   Future<void> _onFlash() async {
//     try {
//       dynamic result = await platformMethodChannel.invokeMethod('onFlash');
//       setState(() {
//         isFlashOn = true;
//       });
//     } on PlatformException catch (e) {
//       debugPrint('PlatformException ${e.message}');
//     }
//   }

//   Future<void> _offFlash() async {
//     try {
//       dynamic result = await platformMethodChannel.invokeMethod('offFlash');
//       setState(() {
//         isFlashOn = false;
//       });
//     } on PlatformException catch (e) {
//       debugPrint('PlatformException ${e.message}');
//     }
//   }

//   @override
//   void initState() {
//     super.initState();
//     _handleQRcodeResult();
//     _checkPermissions();
//   }

//   _requestAppPermissions() {
//     showDialog(
//         context: context,
//         builder: (BuildContext context) => AlertDialog(
//               title: const Text('Permission required'),
//               content: const Text('Allow camera permissions'),
//               actions: <Widget>[
//                 TextButton(
//                   onPressed: () {
//                     _checkPermissions();
//                     Navigator.pop(context, 'OK');
//                   },
//                   child: const Text('OK'),
//                 ),
//               ],
//             ));
//   }

//   _checkPermissions() async {
//     var status = await Permission.camera.status;
//     if (!status.isGranted) {
//       final PermissionStatus permissionStatus = await Permission.camera.request();
//       if (!permissionStatus.isGranted) {
//         _requestAppPermissions();
//       }
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     const String viewType = '<platform-view-type>';
//     final Map<String, dynamic> creationParams = <String, dynamic>{};
//     return result.isEmpty
//         ? Stack(
//             alignment: Alignment.center,
//             children: [
//               PlatformViewLink(
//                 viewType: viewType,
//                 surfaceFactory: (BuildContext context, PlatformViewController controller) {
//                   return Container(
//                     child: AndroidViewSurface(
//                       controller: controller as AndroidViewController,
//                       gestureRecognizers: const <Factory<OneSequenceGestureRecognizer>>{},
//                       hitTestBehavior: PlatformViewHitTestBehavior.opaque,
//                     ),
//                   );
//                 },
//                 onCreatePlatformView: (PlatformViewCreationParams params) {
//                   return PlatformViewsService.initSurfaceAndroidView(
//                     id: params.id,
//                     viewType: viewType,
//                     layoutDirection: TextDirection.ltr,
//                     creationParams: creationParams,
//                     creationParamsCodec: StandardMessageCodec(),
//                   )
//                     ..addOnPlatformViewCreatedListener(params.onPlatformViewCreated)
//                     ..create();
//                 },
//               ),
//               Align(
//                   alignment: Alignment.topCenter,
//                   child: ElevatedButton(
//                       onPressed: () {
//                         if (!isFlashOn) {
//                           _onFlash();
//                         } else {
//                           _offFlash();
//                         }
//                       },
//                       child: isFlashOn ? Text('off flashlight') : Text('on flashlight'))),
//               Align(
//                 alignment: Alignment.center,
//                 child: Container(
//                   height: 200,
//                   width: 200,
//                   decoration: BoxDecoration(
//                       color: Colors.transparent,
//                       border: Border.all(
//                         color: Colors.blueAccent,
//                         width: 5,
//                       )),
//                 ),
//               )
//             ],
//           )
//         : Container(
//             child: Center(child: Text('QR code result:\n$result')),
//           );
//   }
// }