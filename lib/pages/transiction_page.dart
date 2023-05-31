import 'package:flutter/material.dart';

import 'package:tricount/model/transiction.dart';

class TransictionPage extends StatefulWidget {
  final Transiction transiction;

  const TransictionPage({Key? key, required this.transiction})
      : super(key: key);

  @override
  TransictionPageState createState() => TransictionPageState();
}

class TransictionPageState extends State<TransictionPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.transiction.description),
      ),
      body: Center(
        child: Text(widget.transiction.description),
      )
    );
  }
}
