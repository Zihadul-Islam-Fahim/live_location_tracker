import 'dart:async';
import 'package:flutter/material.dart';
import 'package:location/location.dart';

class LocationScreen extends StatefulWidget {
  const LocationScreen({super.key});

  @override
  State<LocationScreen> createState() => _LocationScreenState();
}

class _LocationScreenState extends State<LocationScreen> {
  Location location = Location();

  late LocationData currentLocation;
  LocationData? myLocation;

  late StreamSubscription locationSubscription;

  void listenToLocation() async {
    locationSubscription =
        location.onLocationChanged.listen((locationData) async {
      myLocation = locationData;
      if (mounted) {
        setState(() {});
      }
    });
  }

  @override
  void initState() {
    listenToLocation();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Location"),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            StreamBuilder(
              stream: location.onLocationChanged,
              builder: (context, snapshot) {
                return Text(
                  "StreamBuilder : ${snapshot.data?.longitude ?? ''}",
                  style: const TextStyle(color: Colors.red, fontSize: 25),
                );
              },
            ),
            Text(
              myLocation?.longitude.toString() ?? '',
              style: const TextStyle(color: Colors.green, fontSize: 25),
            ),
            ElevatedButton(
              onPressed: () async {
                currentLocation = await location.getLocation();
              },
              child: const Text("Get Current Location"),
            ),
            ElevatedButton(
              onPressed: () async {
                PermissionStatus status = await location.hasPermission();
                if (status == PermissionStatus.denied ||
                    status == PermissionStatus.deniedForever) {
                  location.requestPermission();
                }
              },
              child: const Text('Permission'),
            ),
          ],
        ),
      ),
    );
  }
}
