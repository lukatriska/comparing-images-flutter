import 'package:flutter/material.dart';

import 'package:image/image.dart' as imeg;
import 'package:http/http.dart' as http;
import 'dart:io' as io;

import 'screens/comparison_screen.dart';

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      routes: {ComparisonScreen.routeName: (ctx) => ComparisonScreen()},
      home: Builder(
        builder: (context) => Scaffold(
            appBar: AppBar(
              title: const Text("Test Task"),
            ),
            body: Column(
              children: [
                Row(children: [
                  Expanded(
                    child: Image.asset('assets/img1.png'),
                  ),
                  Expanded(
                    child: Image.asset('assets/img2.png'),
                  ),
                ]),
                ElevatedButton(
                  child: Text("Compare the two images"),
                  onPressed: () {
                    Navigator.of(context).pushNamed(ComparisonScreen.routeName);
                  },
                ),
              ],
            )),
      ),
    );
  }
}

Uri imgUrl1 = Uri.parse(
    'https://raw.githubusercontent.com/lukatriska/comparing-images-flutter/master/assets/img1.png');
Uri imgUrl2 = Uri.parse(
    'https://raw.githubusercontent.com/lukatriska/comparing-images-flutter/master/assets/img2.png');

int selectColor(num diffAtPixel, int firstPixel, int secondPixel) {
  int result;

  var r1 = imeg.getRed(firstPixel);
  var g1 = imeg.getGreen(firstPixel);
  var b1 = imeg.getBlue(firstPixel);
  var r2 = imeg.getRed(secondPixel);
  var g2 = imeg.getGreen(secondPixel);
  var b2 = imeg.getBlue(secondPixel);

  if (diffAtPixel == 0) {
    result = imeg.Color.fromRgba(r1, g1, b1, 50);
  } else if (r1 == 0 && g1 == 0 && b1 == 0) {
    result = imeg.Color.fromRgba(r2, g2, b2, 50);
  } else if (r2 == 0 && g2 == 0 && b2 == 0) {
    result = imeg.Color.fromRgba(r1, g1, b1, 50);
  } else {
    result = imeg.Color.fromRgba(255, 0, 0, 255);
  }

  return result;
}

void compareImages(dynamic firstImgSrc, dynamic secondImgSrc) async {
  imeg.Image? img1;
  imeg.Image? img2;

  var response1 = await http.get(firstImgSrc);
  img1 = imeg.decodeImage(response1.bodyBytes);
  var response2 = await http.get(secondImgSrc);
  img2 = imeg.decodeImage(response2.bodyBytes);

  var width = img1?.width;
  var height = img1?.height;

  var diffImg = imeg.Image(width!, height!);

  for (var i = 0; i < width; i++) {
    int? p1, p2;
    num pDiff;

    for (var j = 0; j < height; j++) {
      p1 = img1!.getPixel(i, j);
      p2 = img2!.getPixel(i, j);

      var r1 = imeg.getRed(p1);
      var g1 = imeg.getGreen(p1);
      var b1 = imeg.getBlue(p1);
      var r2 = imeg.getRed(p2);
      var g2 = imeg.getGreen(p2);
      var b2 = imeg.getBlue(p2);

      pDiff = ((r1 - r2).abs() + (g1 - g2).abs() + (b1 - b2).abs() / 255) / 3;

      diffImg.setPixel(i, j, selectColor(pDiff, p1.toInt(), p2.toInt()));
    }
  }

  io.File('/Users/luka-marko/IdeaProjects/SS_test_task_2/assets/DiffImg.png')
      .writeAsBytes(
    imeg.encodePng(diffImg),
  );
}

void main() {
  compareImages(imgUrl1, imgUrl2);

  runApp(MyApp());
}
