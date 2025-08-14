import 'package:flutter/material.dart';

class AddEventPage extends StatelessWidget {
  final int eventId;

  const AddEventPage({super.key, required this.eventId});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Add Event'),
      ),
      body: Center(
        child: Text('Event ID: $eventId'),
      ),
    );
  }
}
