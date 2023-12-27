import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<LatLng> stepList = [];

  late GoogleMapController _googleMapController;
  Location location = Location();
  LocationData? startLocation;

  Stream<LocationData> getCurrentLocation() async* {
    yield* Stream.periodic(
      const Duration(seconds: 10),
      (_) async {
        final LocationData locationData = await location.getLocation();
        stepList.add(LatLng(locationData.latitude!, locationData.longitude!));
        return locationData;
      },
    ).asyncMap((event) async => await event);
  }

  startUp() async {
    startLocation = await location.getLocation();
  }

 animateToCurrentLocation(){
    _googleMapController.animateCamera(CameraUpdate.newCameraPosition(
        CameraPosition(zoom: 17, target: LatLng(startLocation!.latitude!, startLocation!.longitude!))));
  }

  @override
  void initState() {
    getCurrentLocation();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('GOOGLE MAP'),
      ),

      floatingActionButton: Align(
        heightFactor: 1.8,
        widthFactor: 6.9,
        child: FloatingActionButton(
          backgroundColor: Colors.redAccent.withOpacity(0.8),
          splashColor: Colors.black,
          tooltip: 'Your Location',
          onPressed: () {
            animateToCurrentLocation();
          },
          child: const Icon(Icons.my_location),
        ),
      ),

      body: StreamBuilder(
        stream: getCurrentLocation(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return GoogleMap(
              initialCameraPosition: const CameraPosition(
                zoom: 10,
                target: LatLng(23.80860539167841, 90.41725361362947),
                bearing: 15,
                tilt: 5,
              ),
              onMapCreated: (GoogleMapController controller) {
                _googleMapController = controller;
                startUp();
              },
              myLocationButtonEnabled: true,
              myLocationEnabled: true,
              markers: {
                Marker(
                  markerId: const MarkerId("initialPosition"),
                  position: LatLng(
                      startLocation?.latitude! ?? 23.80860539167841, startLocation?.longitude! ?? 90.41725361362947),
                  icon: BitmapDescriptor.defaultMarkerWithHue(
                      BitmapDescriptor.hueViolet),
                  infoWindow: InfoWindow(
                      title: "Startup  Location",
                      snippet:
                          '${startLocation?.latitude! ?? 23.80860539167841},${startLocation?.longitude! ?? 90.41725361362947}'),
                  draggable: true,
                ),
                Marker(
                  markerId: const MarkerId('Current Location'),
                  position: LatLng(
                      snapshot.data!.latitude!, snapshot.data!.longitude!),
                  icon: BitmapDescriptor.defaultMarker,
                  draggable: true,
                  infoWindow: InfoWindow(
                    title: "Current Location",
                    snippet:
                        '${snapshot.data!.latitude!},${snapshot.data!.longitude!}',
                  ),
                )
              },

              polylines: {
                Polyline(
                  polylineId: const PolylineId('First'),
                  color: Colors.deepOrange,
                  width: 4,
                  endCap: Cap.roundCap,
                  jointType: JointType.round,
                  points: stepList,
                ),
              },
            );
          }

          else {
            return const Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CircularProgressIndicator(),
                  SizedBox(
                    height: 20,
                  ),
                  Text(
                    "Map is loading.Please wait...",
                    style: TextStyle(fontWeight: FontWeight.w200, fontSize: 20),
                  )
                ],
              ),
            );
          }
        },
      ),
    );
  }
}
