import 'package:flutter/material.dart';

class GigPreviewScreen extends StatelessWidget {
  const GigPreviewScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Preview Gig')),
      body: const Center(
        child: Text('Gig Preview — Coming Soon'),
      ),
    );
  }
}
