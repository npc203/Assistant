import 'package:flutter/material.dart';
import 'package:Assistant/main.dart';

class AddTask extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      //drawer: NavBar(),
      appBar: AppBar(
        title: Text('Add Task'),
      ),
      body: Center(
        child: Text('New Task'),
      ),
    );
  }
}
