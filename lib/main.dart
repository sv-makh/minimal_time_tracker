import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:minimal_time_tracker/data/mock_data.dart';
import 'package:minimal_time_tracker/add_activity_screen.dart';
import 'package:minimal_time_tracker/activity_card.dart';
import 'package:minimal_time_tracker/activity_bloc.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Minimal Time Tracker',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(), //title: 'Minimal Time Tracker'),
    );
  }
}

class MyHomePage extends StatelessWidget {
  const MyHomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => ActivitiesBloc(activities),
      child: const ActivitiesView(),
    );
  }
}

class ActivitiesView extends StatelessWidget {
  const ActivitiesView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ActivitiesBloc, ActivitiesState>(
      builder: (context, ActivitiesState state) {
        return Scaffold(
          appBar: AppBar(
            title: Text('Minimal Time Tracker'),
          ),
          body: SafeArea(
            child: ListView.builder(
              itemCount: state.activitiesState.length,
              itemBuilder: (BuildContext context, int index) {
                return ActivityCard(
                  activity: state.activitiesState[index],
                );
              },
            ),
          ),
          floatingActionButton: FloatingActionButton(
            child: Icon(Icons.add),
            onPressed: () {
              _addActivity(context);
            },
          ),
        );
      },
    );
  }

  Future<void> _addActivity(BuildContext context) async {
    await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => AddActivityScreen()),
    ).then((value) => BlocProvider.of<ActivitiesBloc>(context)
        .add(ActivityAdded(activity: value)));

    /*setState(() {
      activities.add(value);
    }));*/
  }
}
