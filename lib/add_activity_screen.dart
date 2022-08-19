import 'package:flutter/material.dart';

class AddActivityScreen extends StatelessWidget {
  const AddActivityScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Add new activity'),
      ),
      body: SafeArea(
        child: Padding(
          padding: 10,
          child: Column(
            children: [
              Text('Title'),
              TextField(),
              Text('Subtitle'),
              TextField()
            ],
          ),
        ),
      ),
    );
  }
}
