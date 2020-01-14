import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:driver/pages/credits_page.dart';
import 'package:driver/utils/map_helper.dart';
import 'package:driver/utils/map_marker.dart';
import 'package:driver/utils/map_styles.dart';
import 'package:driver/utils/text_styles.dart';
import 'package:driver/utils/translations.dart';
import 'package:driver/utils/ui_helpers.dart';
import 'package:driver/widgets/fetching_location.dart';
import 'package:driver/widgets/no_connection.dart';
import 'package:dynamic_theme/dynamic_theme.dart';
import 'package:fluster/fluster.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_offline/flutter_offline.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MyMapViewPage extends StatefulWidget {
  final SharedPreferences helper;
  final String identity;
  final String language;

  MyMapViewPage(
      {Key key,
      @required this.helper,
      @required this.identity,
      @required this.language})
      : super(key: key);

  @override
  _MyMapViewPageState createState() => _MyMapViewPageState();
}

class _MyMapViewPageState extends State<MyMapViewPage> {
  /// Minimum zoom at which the markers will cluster
  final int _minClusterZoom = 0;

  /// Maximum zoom at which the markers will cluster
  final int _maxClusterZoom = 19;

  /// [Fluster] instance used to manage the clusters
  Fluster<Markers> _clusterManager;

  /// Url image used on cluster markers
  final String _clusterImageUrl =
      'https://i.ibb.co/XYJyqWs/arrow-256x256.png';

  var currentLocation;
  var markerColor = 165.0; // fliver green marker
  var locationAnimation = 0; // used to switch between 2 kinds of animations

  final zoom = [15.0, 17.5]; // zoom levels (0/1)
  final bearing = [0.0, 90.0]; // bearing level (0/1)
  final tilt = [0.0, 45.0]; // axis tilt (0/1)

  double _currentZoom = 15;

  final displayMarkersRadius = 10000.0; // radius up to which markers are loaded

  final markerRefreshInterval =
      Duration(seconds: 5); // timeout to repopulate markers
  final markerExpireInterval =
      Duration(minutes: 15); // timeout to delete old markers

  bool isFirstLaunch = true; // for dark mode fix
  bool isMarkerDeleted = false; // to check if marker was deleted

  GoogleMapController mapController;

  Future<Position> position;
  static Map<MarkerId, Marker> markers = <MarkerId, Marker>{};
  final Set<Marker> _markers = Set<Marker>.of(markers.values);

  Set<Circle> hotspots = {};
  GlobalKey<ScaffoldState> scaffoldKey =
      GlobalKey<ScaffoldState>(); // for snackbar

  @override
  void initState() {
    print('initState() called');
    super.initState();
    position = _setCurrentLocation();
    print('UUID is ${widget.identity}');
  } // gets current user location when the app launches

  void initCluster(List<Markers> markersListInit) async {
    _clusterManager = await MapHelper.initClusterManager(
      markersListInit,
      _minClusterZoom,
      _maxClusterZoom,
      _clusterImageUrl,
    );

    _updateMarkers();
  }

  /// Gets the markers and clusters to be displayed on the map for the current zoom level and
  /// updates state.
  void _updateMarkers([double updatedZoom]) {
    if (_clusterManager == null || updatedZoom == _currentZoom) return;

    if (updatedZoom != null) {
      _currentZoom = updatedZoom;
    }

    _markers
      ..clear()
      ..addAll(MapHelper.getClusterMarkers(_clusterManager, _currentZoom));
  }

  void _onMapCreated(GoogleMapController controller) {
    print('_onMapCreated() called');
    mapController = controller;

    if (isFirstLaunch) {
      _fetchMarkersFromDb();

      mapController
          .setMapStyle(isThemeCurrentlyDark(context) ? darkMap2 : lightMap2);
      isFirstLaunch = false;
    } else {
      mapController
          .setMapStyle(isThemeCurrentlyDark(context) ? lightMap2 : darkMap2);
    } // weird fix for broken dark mode

    Timer.periodic(markerRefreshInterval, (Timer t) {
      print('$markerRefreshInterval seconds over, refreshing...');
      _fetchMarkersFromDb(); // updates markers every 10 seconds
    });
  }

  Future<Position> _setCurrentLocation() async {
    print('_setCurrentLocation() called');
    currentLocation = await Geolocator().getCurrentPosition();
    return currentLocation;
  }

  void _fetchMarkersFromDb() {
    print('_fetchMarkersFromDb() called');
    Firestore.instance.collection('markers').getDocuments().then((docs) async {
      var docLength = docs.documents.length;
      var clients = List(docLength);
      for (int i = 0; i < docLength; i++) {
        clients[i] = docs.documents[i];
      }
      currentLocation = await Geolocator().getCurrentPosition();
      _populateMarkers(clients);
    });
  } // fetches markers from firestore

  void _deleteMarker(documentId) {
    print('_deleteMarker() called');
    print('Deleting marker $documentId...');
    //isMyMarkerFetched = false;
    Firestore.instance.collection('markers').document(documentId).delete();
    setState(() {
      markers.remove(MarkerId(documentId));
    });
  } // deletes markers from firestore

  Future _populateMarkers(clients) async {
    List<Markers> markersList = [];

    print('_populateMarkers() called');
    markers.clear();

    for (int i = 0; i < clients.length; i++) {
      print('_populateMarkers() loop ${i + 1}/${clients.length}');
      var documentId = clients[i].documentID;
      var markerId = MarkerId(documentId);
      var markerData = clients[i].data;

      var markerPosition = LatLng(markerData['position']['geopoint'].latitude,
          markerData['position']['geopoint'].longitude);
      var markerTimestamp = markerData['timestamp'].toDate();

      var timeDiff = DateTime.now().difference(markerTimestamp);

      markersList.add(
        Markers(
          id: MarkerId(documentId).toString(),
          position: LatLng(markerData['position']['geopoint'].latitude,
              markerData['position']['geopoint'].longitude),
          icon: BitmapDescriptor.defaultMarkerWithHue(markerColor),
        ),
      );

      var distance = await Geolocator().distanceBetween(
        currentLocation.latitude.toDouble(),
        currentLocation.longitude.toDouble(),
        markerPosition.latitude.toDouble(),
        markerPosition.longitude.toDouble(),
      ); // distance between my location and other markers

      if (timeDiff > markerExpireInterval) {
        // if the marker is expired, it gets deleted and doesn't continue
        print('Marker $markerId expired, deleting...');
        _deleteMarker(documentId);
        isMarkerDeleted = true;
      }
      var marker = Marker(
        markerId: markerId,
        position: markerPosition,
        icon: BitmapDescriptor.defaultMarkerWithHue(markerColor),
      );

      initCluster(markersList);

      setState(() {
        if (displayMarkersRadius >= distance) {
          markers[markerId] = marker;
        } // adds markers within 10km of my marker
      });
    }
  }

  void _animateToLocation(location, animation) {
    print('_animateToLocation called');
    mapController.animateCamera(
      CameraUpdate.newCameraPosition(
        CameraPosition(
          target: LatLng(location.latitude, location.longitude),
          zoom: zoom[animation],
          bearing: bearing[animation],
          tilt: tilt[animation],
        ),
      ),
    );
  } // dat cool animation tho

  @override
  Widget build(BuildContext context) {
    print('Widget build() called');

    return OfflineBuilder(connectivityBuilder: (
      BuildContext context,
      ConnectivityResult connectivity,
      Widget child,
    ) {
      if (connectivity == ConnectivityResult.none) {
        return NoConnection(language: widget.language);
      } else {
        return child;
      }
    }, builder: (BuildContext context) {
      // when there is proper internet
      return FutureBuilder(
          future: position,
          builder: (context, data) {
            if (!data.hasData) {
              return FetchingLocation(language: widget.language);
            } else {
              // when current location is obtained
              return Scaffold(
                key: scaffoldKey,
                body: Container(
                  child: Stack(
                    children: <Widget>[
                      GoogleMap(
                        onMapCreated: _onMapCreated,
                        myLocationEnabled: true,
                        myLocationButtonEnabled: false,
                        compassEnabled: false,
                        mapToolbarEnabled: false,
                        initialCameraPosition: CameraPosition(
                          target: LatLng(currentLocation.latitude,
                              currentLocation.longitude),
                          zoom: _currentZoom,
                          bearing: bearing[0],
                          tilt: tilt[0],
                        ),
                        markers: _markers,
                        onCameraMove: (position) =>
                            _updateMarkers(position.zoom),
                      ),
                      Positioned(
                        top: 45.0,
                        left: 20.0,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: <Widget>[
                            Container(
                              width: 95.0,
                              height: 30.0,
                              child: isThemeCurrentlyDark(context)
                                  ? Image.asset(
                                      'assets/logo/text-green.png',
                                      fit: BoxFit.cover,
                                    )
                                  : Image.asset(
                                      'assets/logo/text-black.png',
                                      fit: BoxFit.cover,
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
                  closeManually: false,
                  foregroundColor: invertInvertColorsTheme(context),
                  backgroundColor: invertColorsTheme(context),
                  animatedIcon: AnimatedIcons.menu_close,
                  elevation: 5.0,
                  children: [
                    SpeedDialChild(
                      child: Icon(Icons.my_location),
                      foregroundColor: invertColorsTheme(context),
                      backgroundColor: invertInvertColorsTheme(context),
                      label: speedial1(widget.language),
                      labelStyle: LabelStyles.black,
                      onTap: () async {
                        currentLocation =
                            await Geolocator().getCurrentPosition();
                        locationAnimation = 0;
                        _animateToLocation(currentLocation, locationAnimation);
                      },
                    ),
                    SpeedDialChild(
                      child: isThemeCurrentlyDark(context)
                          ? Icon(Icons.brightness_7)
                          : Icon(Icons.brightness_2),
                      foregroundColor: invertColorsTheme(context),
                      backgroundColor: invertInvertColorsTheme(context),
                      label: isThemeCurrentlyDark(context)
                          ? speedial2a(widget.language)
                          : speedial2b(widget.language),
                      labelStyle: LabelStyles.black,
                      onTap: () {
                        DynamicTheme.of(context).setBrightness(
                            Theme.of(context).brightness == Brightness.dark
                                ? Brightness.light
                                : Brightness.dark);
                        _onMapCreated(mapController);
                      },
                    ),
                    SpeedDialChild(
                      child: Icon(Icons.info),
                      foregroundColor: invertColorsTheme(context),
                      backgroundColor: invertInvertColorsTheme(context),
                      label: speedial3(widget.language),
                      labelStyle: LabelStyles.black,
                      onTap: () {
                        Navigator.push(context,
                            CupertinoPageRoute(builder: (context) {
                          return MyCreditsPage(
                            language: widget.language,
                          );
                        }));
                      },
                    ),
                  ],
                ),
              );
            }
          });
    });
  }
}
