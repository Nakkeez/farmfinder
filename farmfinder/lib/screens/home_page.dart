import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';

import 'package:farmfinder/utils/determine_location.dart';
import 'package:farmfinder/widgets/map_widget.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key, required this.title});

  final String title;

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  Position? _position;

  void fetchCurrentPosition() async {
    var currentPosition = await determinePosition();
    setCurrentPosition(currentPosition);
  }

  void setCurrentPosition(Position pos) {
    setState(() {
      _position = pos;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),
      body: const Stack(children: [Map()]),
      floatingActionButton: FloatingActionButton(
        onPressed: fetchCurrentPosition,
        tooltip: 'Get Location',
        child: const Icon(Icons.add),
      ),
    );
  }
}
