import 'package:flutter/material.dart';

class DetailScreen extends StatelessWidget {
  final String entryId;
  const DetailScreen({super.key, required this.entryId});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('विवरण')),
      body: Center(child: Text('Detail for entry: $entryId')),
    );
  }
}
