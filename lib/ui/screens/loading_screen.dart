import 'package:flutter/material.dart';

import '../dialog/loader_dialog.dart';

class LoadingScreen extends StatelessWidget {
  const LoadingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(child: LoadingWidget(context, "Downloading Config")),
    );
  }
}
