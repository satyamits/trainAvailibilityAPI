import 'package:flutter/material.dart';

class TrainDetailsScreen extends StatelessWidget {
  final Map<String, dynamic> train;

  const TrainDetailsScreen({super.key, required this.train});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Train Details',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        elevation: 0,
      ),
      body: Card(
        elevation: 4,
        margin: const EdgeInsets.all(16),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Train Name: ${train['trainName']}'),
              Text('Train Number: ${train['trainNumber']}'),
              Text(
                'Departure Time: ${train['departureTime']['Hours']}:${train['departureTime']['Minutes']}',
              ),
              Text(
                'Seats Available - Sleeper: ${train['seatsAvailable']['sleeper']}, AC: ${train['seatsAvailable']['AC']}',
              ),
              Text(
                'Price - Sleeper: ${train['price']['sleeper']}, AC: ${train['price']['AC']}',
              ),
              Text('Delayed By: ${train['delayedBy']} minutes'),
            ],
          ),
        ),
      ),
    );
  }
}
