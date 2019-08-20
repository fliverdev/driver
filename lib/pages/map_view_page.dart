import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:driver/utils/functions.dart';
import 'package:flutter/services.dart' show rootBundle;

class MyMapViewPage extends StatefulWidget {
  @override
  _MyMapViewPageState createState() => _MyMapViewPageState();
}

class _MyMapViewPageState extends State<MyMapViewPage> {
  String _mapStyle;
  var currentLocation;
  BitmapDescriptor myIcon;
  GoogleMapController mapController;
  Map<MarkerId, Marker> markers = <MarkerId, Marker>{};

  void initState() {
    super.initState();
    _getCurrentLocation();
    BitmapDescriptor.fromAssetImage(
        ImageConfiguration(size: Size(48, 48)), 'assets/icons/taxi.png')
        .then((onValue) {
      myIcon = onValue;
    });
    rootBundle.loadString('assets/maps_style/maps_style.txt').then((string) {
      _mapStyle = string;
    });
  } // gets current user location when the app loads

  void _onMapCreated(GoogleMapController controller) {
    mapController = controller;
    mapController.setMapStyle(_mapStyle);
  }

  _getCurrentLocation() {
    Geolocator().getCurrentPosition().then((currLoc) {
      setState(() {
        currentLocation = currLoc;
      });
    });
    return currentLocation;
  }

  void _addMarker() {
    var marker = Marker(
      position: LatLng(currentLocation.latitude, currentLocation.longitude),
      icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueGreen),
      infoWindow: InfoWindow(title: 'Marker Title', snippet: 'Marker Snipper'),
    );
  }

  void _animateToUser() async {
    mapController.animateCamera(
      CameraUpdate.newCameraPosition(
        CameraPosition(
          target: LatLng(currentLocation.latitude, currentLocation.longitude),
          zoom: 17.0,
          bearing: 90.0,
          tilt: 0.0,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        child: Stack(
          children: <Widget>[
            GoogleMap(
              onMapCreated: _onMapCreated,
              mapToolbarEnabled: true,
              myLocationEnabled: true,
              myLocationButtonEnabled: false, //replace with a custom button
              compassEnabled: false,
              initialCameraPosition: CameraPosition(
                target:
                    LatLng(currentLocation.latitude, currentLocation.longitude),
                zoom: 15.0,
              ),
            ),
            Padding(
              padding: EdgeInsets.only(
                left: 10.0,
                top: 40.0,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  IconButton(
                    icon: Icon(Icons.menu),
                    tooltip: 'Menu',
                    color: invertColorsMild(context),
                    iconSize: 22.0,
                    onPressed: doNothing,
                  ),
                  Text(
                    'Fliver Driver',
                    style: TextStyle(
//                    fontFamily: '',
                      fontWeight: FontWeight.w600,
                      fontSize: 24.0,
                      fontStyle: FontStyle.italic,
                      color: invertColorsMild(context),
                    ),
                  ),
                ],
              ),
            ),
            Positioned(
              bottom: 10.0,
              right: 15.0,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  RaisedButton(
                    child: Text('Button 1'),
                    onPressed: doNothing,
                  ),
                  SizedBox(
                    width: 10.0,
                  ),
                  RaisedButton(
                    child: Text('Get location'),
                    onPressed: _animateToUser,
                  ),
                  SizedBox(
                    width: 10.0,
                  ),
                  RaisedButton(
                    child: Text('Button 3'),
                    onPressed: doNothing,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
