import 'dart:async';
import 'dart:math';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:driver/utils/ui_helpers.dart';
import 'package:dynamic_theme/dynamic_theme.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:geoflutterfire/geoflutterfire.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:driver/utils/colors.dart';
import 'package:driver/utils/map_style.dart';
import 'package:driver/pages/about_page.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:random_string/random_string.dart';


class MyMapViewPage extends StatefulWidget {
  @override
  _MyMapViewPageState createState() => _MyMapViewPageState();
}

class _MyMapViewPageState extends State<MyMapViewPage> {
  var currentLocation;
  var clients = [];
  final Set<Circle> _circle = {};

  final Map<MarkerId, Marker> markers = <MarkerId, Marker>{};

  GoogleMapController mapController;
  Firestore firestore = Firestore.instance;
  Geoflutterfire geo = Geoflutterfire();

  void initState() {
    super.initState();
    _getCurrentLocation();
    _populateClients();
  } // gets current user location when the app loads

  void _onMapCreated(GoogleMapController controller) {
    mapController = controller;
    mapController.setMapStyle(isThemeCurrentlyDark(context)
        ? retro
        : aubergine);
  }

  void _getCurrentLocation() {
    Geolocator().getCurrentPosition().then((currLoc) {
      setState(() {
        currentLocation = currLoc;
        _circle.add(Circle(
          circleId: CircleId(
              LatLng(currentLocation.latitude, currentLocation.longitude)
                  .toString()),
          center: LatLng(currentLocation.latitude, currentLocation.longitude),
          radius: 75,
          fillColor: MyColors.translucentColor,
          strokeColor: MyColors.primaryColor,
          visible: true,
        ));
        _populateClients();
      });
    });
    return currentLocation;
  }

  void _initMarkersFromFirestore(client) {
    var markerIdVal = randomString(7); // TODO: don't use Random()
    final MarkerId markerId = MarkerId(markerIdVal);

    var marker = Marker(
      markerId: markerId,
      position: LatLng(client['position']['geopoint'].latitude,
          client['position']['geopoint'].longitude),
      icon: BitmapDescriptor.defaultMarkerWithHue(147.5),
      // closest color i
      // could get
      infoWindow: InfoWindow(title: 'Marker Title', snippet: 'Marker Snippet'),
      onTap: null,
    );

    setState(() {
      markers[markerId] = marker;
    });
  } // creates markers from firestore on the map

  void _populateClients() {
    clients = [];
    Firestore.instance.collection('locations').getDocuments().then((docs) {
      if (docs.documents.isNotEmpty) {
        for (int i = 0; i < docs.documents.length; i++) {
          clients.add(docs.documents[i].data);
          _initMarkersFromFirestore(docs.documents[i].data);
        }
      }
    });
  }

  void _animateToCurrentLocation() async {
    mapController.animateCamera(
      CameraUpdate.newCameraPosition(
        CameraPosition(
          target: LatLng(currentLocation.latitude, currentLocation.longitude),
          zoom: 17.5,
          bearing: 90.0,
          tilt: 45.0,
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
              myLocationButtonEnabled: false,
              compassEnabled: false,
              initialCameraPosition: CameraPosition(
                target:
                LatLng(currentLocation.latitude, currentLocation.longitude),
                zoom: 15.0,
              ),
              markers: Set<Marker>.of(markers.values),
              circles: _circle,
            ),
            Positioned(
              top: 40.0,
              left: 20.0,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  Text(
                    'Fliver Driver',
                    style: TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 24.0,
                      fontStyle: FontStyle.italic,
                      color: invertColorsStrong(context),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: SpeedDial(
        heroTag: 'fab',
        tooltip: 'Actions menu',
        closeManually: false,
        foregroundColor: invertInvertColorsTheme(context),
        backgroundColor: invertColorsTheme(context),
        animatedIcon: AnimatedIcons.menu_close,
        elevation: 5.0,
        children: [
          SpeedDialChild(
            child: Icon(Icons.location_on),
            foregroundColor: invertColorsTheme(context),
            backgroundColor: invertInvertColorsTheme(context),
            label: 'Mark location',
            labelStyle: TextStyle(
                color: MyColors.accentColor, fontWeight: FontWeight.w500),
            onTap: () {
              _animateToCurrentLocation();
            },
          ),
          SpeedDialChild(
            child: Icon(Icons.lightbulb_outline),
            foregroundColor: invertColorsTheme(context),
            backgroundColor: invertInvertColorsTheme(context),
            label: 'Toggle lights',
            labelStyle: TextStyle(
                color: MyColors.accentColor, fontWeight: FontWeight.w500),
            onTap: () {
              DynamicTheme.of(context).setBrightness(
                  Theme
                      .of(context)
                      .brightness == Brightness.dark
                      ? Brightness.light
                      : Brightness.dark);
              _onMapCreated(mapController); //buggy
            },
          ),
          SpeedDialChild(
            child: Icon(Icons.info_outline),
            foregroundColor: invertColorsTheme(context),
            backgroundColor: invertInvertColorsTheme(context),
            label: 'About',
            labelStyle: TextStyle(
                color: MyColors.accentColor, fontWeight: FontWeight.w500),
            onTap: () {
              Navigator.push(context, CupertinoPageRoute(builder: (context) {
                return MyAboutPage();
              }));
            },
          ),
        ],
      ),
    );
  }
}