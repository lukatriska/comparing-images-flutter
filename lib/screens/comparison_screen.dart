import 'package:flutter/material.dart';

class ComparisonScreen extends StatelessWidget {

  static const routeName = '/comparison';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Difference is red"),
      ),
      body: Image.asset('assets/DiffImg.png'),
    );
  }
}
