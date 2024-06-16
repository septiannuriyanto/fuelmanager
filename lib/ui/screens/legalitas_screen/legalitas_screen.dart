import 'package:flutter/material.dart';

import 'menpower_screen.dart';
import 'unit_screen.dart';

class LegalitasScreen extends StatelessWidget {
  const LegalitasScreen({super.key});
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: Text('Monitoring Legalitas'),
          bottom: TabBar(
            tabs: [
              Tab(text: 'Unit'),
              Tab(text: 'Menpower'),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            UnitScreen(),
            MenpowerScreen(),
          ],
        ),
      ),
    );
  }
}
