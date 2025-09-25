import 'package:flutter/material.dart';

class MessageScreen extends StatelessWidget {
  final String vendorName;

  const MessageScreen({super.key, this.vendorName = 'Vendor'});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Message with $vendorName'),
      ),
      body: Center(
        child: Text('Chat with $vendorName goes here'),
      ),
    );
  }
}