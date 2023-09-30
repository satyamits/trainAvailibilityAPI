// ignore_for_file: library_private_types_in_public_api, use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:train_app/train_details.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Train App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        fontFamily: 'Roboto',
      ),
      home: const MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  String authorizationToken = '';
  List<dynamic> trains = [];
  bool isLoading = true;

  Future<void> registerCompany() async {
    final response = await http.post(
      'http://20.244.56.144/train/register' as Uri,
      headers: {'Content-Type': 'application/json'},
      body: json.encode({
        "companyName": "Train Central",
        "ownerName": "Rahul",
        "rollNo": "1",
        "ownerEmail": "rahul@abc.edu",
        "accessCode": "FKDLjg"
      }),
    );

    if (response.statusCode == 200) {
      final credentials = json.decode(response.body);
      authorizationToken = credentials['clientSecret'];
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Failed to register company. Please try again.'),
        ),
      );
      print('Error registering company: ${response.reasonPhrase}');
    }
  }

  Future<void> fetchData() async {
    final response = await http.get(
      'http://20.244.56.144/train/trains' as Uri,
      headers: {'Authorization': 'Bearer $authorizationToken'},
    );

    if (response.statusCode == 200) {
      setState(() {
        trains = json.decode(response.body);
      });
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Failed to fetch train data. Please try again.'),
        ),
      );
      print('Error fetching data: ${response.reasonPhrase}');
    }
  }

  @override
  void initState() {
    super.initState();
    registerCompany().then((_) {
      fetchData().then((_) {
        setState(() {
          isLoading = false;
        });
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Train Schedule',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        elevation: 0,
      ),
      body: isLoading
          ? Center(
              child: CircularProgressIndicator(),
            )
          : ListView.builder(
              itemCount: trains.length,
              itemBuilder: (context, index) {
                final train = trains[index];
                return Card(
                  elevation: 4,
                  margin: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                  child: ListTile(
                    title: Text(
                      train['trainName'],
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
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
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) =>
                              TrainDetailsScreen(train: trains[index]),
                        ),
                      );
                    },
                  ),
                );
              },
            ),
    );
  }
}
