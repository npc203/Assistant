import 'package:flutter/material.dart';

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SliverAppBar(
            expandedHeight: 150.0,
            flexibleSpace: const FlexibleSpaceBar(
              title: Text('Available seats'),
            ),
            actions: <Widget>[
          IconButton(
            icon: const Icon(Icons.add_circle),
            tooltip: 'Add new entry',
            onPressed: () {/* ... */},
          ),
        ]));
  }
}
