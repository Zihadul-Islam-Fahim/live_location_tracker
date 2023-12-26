import 'package:flutter/material.dart';
import 'package:google_map/location_screen.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late GoogleMapController _googleMapController;
  Location location = Location();

  Future<void> getCurrentLocation() async {
    final LocationData locationData = await location.getLocation();
    if (locationData == null) {
      return;
    }
    _googleMapController.moveCamera(CameraUpdate.newCameraPosition(
        CameraPosition(
            zoom: 17,
            target: LatLng(locationData.latitude!, locationData.longitude!))));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('GOOGLE MAP'),
        actions: [
          IconButton(
              onPressed: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const LocationScreen()));
              },
              icon: const Icon(Icons.location_on_rounded))
        ],
      ),
      body: GoogleMap(
        initialCameraPosition: const CameraPosition(
          zoom: 12,
          target: LatLng(24.071078701012397, 91.13862236673937),
          bearing: 15,
          tilt: 5,
        ),
        myLocationButtonEnabled: true,
        myLocationEnabled: true,
        markers: {
          Marker(
            markerId: const MarkerId("initialPosition"),
            position: const LatLng(24.071078701012397, 91.13862236673937),
            icon: BitmapDescriptor.defaultMarkerWithHue(
                BitmapDescriptor.hueViolet),
            infoWindow: const InfoWindow(
                title: "This is Home", snippet: 'this is snippet'),
            draggable: true,
            onDragStart: (LatLng position) {
              print(position);
            },
            onDrag: (LatLng position) {
              print(position);
            },
            onDragEnd: (LatLng position) {
              print(position);
            },
          ),
        },
        onMapCreated: (GoogleMapController controller) {
          _googleMapController = controller;
          getCurrentLocation();
        },
        polylines: {
          Polyline(
            polylineId: const PolylineId('First'),
            color: Colors.deepOrange,
            width: 2,
            endCap: Cap.roundCap,
            jointType: JointType.round,
            patterns: [
              PatternItem.gap(10),
              PatternItem.dash(10),
              PatternItem.dot,
              PatternItem.dash(10),
            ],
            points: const [
              LatLng(24.03529960502111, 91.10570311546326),
              LatLng(24.098524430146668, 91.09727427363396),
              LatLng(24.087892861407386, 91.15479324012995),
              LatLng(24.005077509826332, 91.14997532218695),
            ],
          ),
        },
        polygons: {
          Polygon(
            fillColor: Colors.orange,
            strokeColor: Colors.green,
            strokeWidth: 2,
            onTap: () {
              print("Clickeddddddddddddddd");
            },
            consumeTapEvents: true,
            polygonId: const PolygonId("basic-polygon"),
            points: const [
              LatLng(24.161222805044034, 91.25107616186142),
              LatLng(24.11361725681066, 91.2078332528472),
              LatLng(24.158945627582316, 91.16845238953829),
              LatLng(24.188678195420366, 91.2126424536109)
            ],
          )
        },
        circles: {
          Circle(
            circleId: const CircleId("Circle-id"),
            center: const LatLng(24.01616214813797, 90.98917588591576),
            radius: 10,
            fillColor: Colors.greenAccent,
            consumeTapEvents: true,
            onTap: () {
              print('hi');
            },
          )
        },
      ),
    );
  }
}
