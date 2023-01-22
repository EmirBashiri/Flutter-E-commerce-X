import 'package:barcode/barcode.dart';

class PaymentFunctions {
  String createBarcode() {
    final bar = Barcode.qrCode();
    final svg = bar.toSvg("emirbashiri@gmail.com", width: 300, height: 100);
    return svg;
  }
}
