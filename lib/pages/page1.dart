import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';

class Page1 extends StatelessWidget {
  Page1({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Page 1'),
      ),
      body: Padding(
          padding: EdgeInsets.only(left: 8, right: 8),
          child: Column(children: <Widget>[])
      )
    );
  }
}
