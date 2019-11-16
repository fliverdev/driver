import 'dart:async';

import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:rxdart/rxdart.dart';

var currentLocation;
var locationAnimation = 0; // used to switch between two kinds of animations

final zoom = [15.0, 17.5]; // zoom levels (0/1)
final bearing = [0.0, 90.0]; // bearing level (0/1)
final tilt = [0.0, 45.0]; // axis tilt (0/1)

final displayMarkersRadius = 5000.0; // radius up to which markers are loaded

final markerRefreshInterval =
    Duration(seconds: 5); // timeout to repopulate markers
final markerExpireInterval =
    Duration(minutes: 15); // timeout to delete old markers

final GlobalKey<ScaffoldState> scaffoldKey =
    GlobalKey<ScaffoldState>(); // for snackbar
final Map<MarkerId, Marker> markers = <MarkerId, Marker>{};
final Set<Circle> hotspots = {};

bool isFirstLaunch = true; // for dark mode fix
bool isPermissionGranted = false; // for location permission
bool isPermissionButtonVisible = true; // for intro page

String permissionStatusMessage = '';

GoogleMapController mapController;
StreamSubscription subscription;
BehaviorSubject<double> circleRadius = BehaviorSubject.seeded(100.0);
Future<Position> position;
