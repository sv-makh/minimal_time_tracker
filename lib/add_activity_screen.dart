import 'package:flutter/material.dart';
import 'package:minimal_time_tracker/data/mock_data.dart';
import 'package:minimal_time_tracker/data/activity.dart';

class AddActivityScreen extends StatelessWidget {
  AddActivityScreen({Key? key}) : super(key: key);
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _subtitleController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Add new activity'),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.save),
            onPressed: () {
              Navigator.pop(
                context,
                Activity(
                  title: _titleController.text,
                  subtitle: _subtitleController.text,
                ),
              );
            },
          ),
        ],
      ),
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.all(10),
          child: Column(
            children: [
              Text('Title'),
              TextField(
                controller: _titleController,
              ),
              Text('Subtitle'),
              TextField(
                controller: _subtitleController,
              ),
              //adding buttons with duration
              //colorpicker
            ],
          ),
        ),
      ),
    );
  }
}
