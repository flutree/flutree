import 'package:flutter/material.dart';

class QrCodeFullScreen extends StatelessWidget {
  QrCodeFullScreen(this._qrImage);
  final Widget _qrImage;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Hero(
          tag: 'qrcode',
          child: _qrImage,
        ),
      ),
    );
  }
}
