import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image/image.dart' as img;

void main() {
  runApp(MyApp());
}

class ImgDetails {

  final int? width;
  final int? height;

  /// Returns the pixel color from its coordinates:
  /// (0,0) top-left; To (width-1, height-1) bottom-right.
  final Color Function(int x, int y)? pixelColorAt;

  /// Returns the pixel color from its coordinates:
  /// (-1, -1) top-left; To (1, 1) bottom-right.
  final Color Function(Alignment alignment)? pixelColorAtAlignment;

  /// The image itself, as a ui.Image.
  /// Usually you should not read from the image directly, but through
  /// the helper methods `pixelColorAt` and `pixelColorAtAlignment`.
  // final ui.Image? uiImage;

  /// The image itself as a ByteData.
  /// Usually you should not read from the image directly, but through
  /// the helper methods `pixelColorAt` and `pixelColorAtAlignment`.
  // final ByteData? byteData;

  /// Returns true when the image is downloaded and available.
  // bool get hasImage => uiImage != null;

  ImgDetails({
    this.width,
    this.height,
    // this.uiImage,
    // this.byteData,
    this.pixelColorAt,
    this.pixelColorAtAlignment,
  });
}

class MyApp extends StatelessWidget {

  late img.Image photo;

  void setImageBytes(imageBytes) {
    print("setImageBytes");
    List<int> values = imageBytes.buffer.asUint8List();
    print(values);
    photo = img.decodeImage(values)!;
  }

  // image lib uses uses KML color format, convert #AABBGGRR to regular #AARRGGBB
  int abgrToArgb(int argbColor) {
    print("abgrToArgb");
    int r = (argbColor >> 16) & 0xFF;
    int b = argbColor & 0xFF;
    return (argbColor & 0xFF00FF00) | (b << 16) | r;
  }

  // FUNCTION

  Future<Color> _getColor() async {
    print("_getColor");
    Uint8List data;

    data = (await rootBundle.load('packages/SS_test_task_2/assets/img1.png')).buffer.asUint8List();


    print("setImageBytes....");
    setImageBytes(data);

//FractionalOffset(1.0, 0.0); //represents the top right of the [Size].
    double px = 1.0;
    double py = 0.0;

    int pixel32 = photo.getPixelSafe(px.toInt(), py.toInt());
    int hex = abgrToArgb(pixel32);
    print("Value of int: $hex ");

    return Color(hex);
  }


  Future<void> someFunc() async {
    var img1 = Image.asset('assets/img1.png');
    var img2 = Image.asset('assets/img2.png');
    // img1
    // .
    // DefaultAssetBundle.of(context);

    // final Uint8List inputImg1 = (await rootBundle.load("assets/img1.png"))
    //     .buffer.asUint8List();
    // final Uint8List inputImg2 = (await rootBundle.load("assets/img2.png"))
    //     .buffer.asUint8List();
    // final decoder = img.PngDecoder();
    // final decodedImg1 = decoder.decodeImage(inputImg1);
    // final decodedBytes1 = decodedImg1?.getBytes(format: img.Format.rgb);
    // final decodedImg2 = decoder.decodeImage(inputImg2);
    // final decodedBytes2 = decodedImg2?.getBytes(format: img.Format.rgb);

    // print("decodedImg2");
  }

  @override
  Widget build(BuildContext context) {
    someFunc();
    _getColor();
    // const imgData = context.get
    // AssetBundle bundle = DefaultAssetBundle.of(context);
    // final Uint8List inputImg1 = (bundle.load("assets/img1.png"))
    //     .buffer.asUint8List();

    // print(img1.hashCode);

    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: Scaffold(
        appBar: AppBar(
          title: const Text("Test Task"),
        ),
        body: Center(
          child: Text("TEXT"),
        ),
      ),
    );
  }
}
