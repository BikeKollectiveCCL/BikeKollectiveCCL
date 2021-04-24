import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import '../models/bike.dart';
import '../screens/sign_in.dart';

class SingleBikeMap extends StatefulWidget {
  static const routeName = 'singleBikeMap';
  @override
  _SingleBikeMap createState() => _SingleBikeMap();
}

class _SingleBikeMap extends State<SingleBikeMap> {
  Future<void> _onMapCreated(GoogleMapController controller) async {
    setState(() {});
  }

  Widget build(BuildContext context) {
    final Bike thisBike = ModalRoute.of(context).settings.arguments;
    final firebaseUser = context.watch<User>();
    if (firebaseUser != null) {
      return Scaffold(
        appBar: AppBar(
          title: Text('${thisBike.bikeName}'),
          backgroundColor: Colors.green[700],
        ),
        body: GoogleMap(
          onMapCreated: _onMapCreated,
          initialCameraPosition: CameraPosition(
            target: LatLng(thisBike.latitude, thisBike.longitude),
            zoom: 10,
          ),
          markers: [
            Marker(
                markerId: MarkerId(thisBike.bikeName),
                position: LatLng(thisBike.latitude, thisBike.longitude),
                infoWindow: InfoWindow(
                    title: thisBike.bikeName,
                    snippet: thisBike.bikeDescription))
          ].toSet(),
        ),
      );
    } else {
      return SignIn();
    }
  }
}
