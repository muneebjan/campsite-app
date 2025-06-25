import 'package:flutter/material.dart';

class CampsiteListScreen extends StatelessWidget {
  const CampsiteListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Campsites')),
      body: const Center(child: Text('Welcome to Campsite List')),
    );
  }
}
