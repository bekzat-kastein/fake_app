import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class TestPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Container(
          child: Center(
        child: Text('Pushed'),
      )),
    );
  }
}
