import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:driver/pages/credits_page.dart';
import 'package:driver/utils/locale.dart';
import 'package:driver/utils/map_styles.dart';
import 'package:driver/utils/text_styles.dart';
import 'package:driver/utils/ui_helpers.dart';
import 'package:driver/widgets/fetching_location.dart';
import 'package:driver/widgets/no_connection.dart';
import 'package:dynamic_theme/dynamic_theme.dart';
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
  MyMapViewPage({Key key, @required this.helper, @required this.identity})
      : super(key: key);
  @override
  _MyMapViewPageState createState() => _MyMapViewPageState();
}

class _MyMapViewPageState extends State<MyMapViewPage> {
  var currentLocation;
  var markerColor;
  var locationAnimation = 0; // used to switch between 2 kinds of animations
  var previousMarkersWithinRadius = 0;
  var currentMarkersWithinRadius = 0;
  var allMarkersWithinRadius = [];

  final zoom = [15.0, 17.5]; // zoom levels (0/1)
  final bearing = [0.0, 90.0]; // bearing level (0/1)
  final tilt = [0.0, 45.0]; // axis tilt (0/1)

  final displayMarkersRadius = 10000.0; // radius up to which markers are loaded

  final markerRefreshInterval =
      Duration(seconds: 5); // timeout to repopulate markers
  final markerExpireInterval =
      Duration(minutes: 15); // timeout to delete old markers

  bool isFirstLaunch = true; // for dark mode fix
  bool isMarkerDeleted = false; // to check if marker was deleted
  bool isMarkerWithinRadius = false; // to identify nearby markers

  GoogleMapController mapController;
  Future<Position> position;
  Map<MarkerId, Marker> markers = <MarkerId, Marker>{};
  GlobalKey<ScaffoldState> scaffoldKey =
      GlobalKey<ScaffoldState>(); // for snackbar

  @override
  void initState() {
    super.initState();
    position = _setCurrentLocation();
    print('UUID is ${widget.identity}');
  } // gets current user location when the app launches

  void _onMapCreated(GoogleMapController controller) {
    mapController = controller;

    if (isFirstLaunch) {
      _fetchMarkersFromDb();
      mapController
          .setMapStyle(isThemeCurrentlyDark(context) ? darkMap : lightMap);
      isFirstLaunch = false;
    } else {
      mapController
          .setMapStyle(isThemeCurrentlyDark(context) ? lightMap : darkMap);
    } // weird fix for broken dark mode

    Timer.periodic(markerRefreshInterval, (Timer t) {
      print('$markerRefreshInterval seconds over, refreshing...');
      _fetchMarkersFromDb(); // updates markers every 10 seconds
    });
  }

  Future<Position> _setCurrentLocation() async {
    currentLocation = await Geolocator().getCurrentPosition();
    return currentLocation;
  }

  void _fetchMarkersFromDb() {
    Firestore.instance.collection('markers').getDocuments().then((docs) {
      var docLength = docs.documents.length;
      var clients = List(docLength);
      for (int i = 0; i < docLength; i++) {
        clients[i] = docs.documents[i];
      }
//      _populateMarkers(clients);
    });
  } // fetches markers from firestore

  void _animateToLocation(location, animation) async {
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
    Icon toggleLightsIcon = isThemeCurrentlyDark(context)
        ? Icon(Icons.brightness_7)
        : Icon(Icons.brightness_2);
    String toggleLightsText = isThemeCurrentlyDark(context)
        ? AppLocalizations.of(context).translate('speedDial2.1')
        : AppLocalizations.of(context).translate('speedDial2.2');

    return OfflineBuilder(connectivityBuilder: (
      BuildContext context,
      ConnectivityResult connectivity,
      Widget child,
    ) {
      if (connectivity == ConnectivityResult.none) {
        return NoConnection();
      } else {
        return child;
      }
    }, builder: (BuildContext context) {
      // when there is proper internet
      return FutureBuilder(
          future: position,
          builder: (context, data) {
            if (!data.hasData) {
              return FetchingLocation();
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
                          zoom: zoom[0],
                          bearing: bearing[0],
                          tilt: tilt[0],
                        ),
                        markers: Set<Marker>.of(markers.values),
                      ),
                      Positioned(
                        top: 10.0,
                        left: 20.0,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: <Widget>[
                            Container(
                              width: 90.0,
                              height: 90.0,
                              child: isThemeCurrentlyDark(context)
                                  ? Image.asset(
                                      'assets/logo/fliver-green.png',
                                      fit: BoxFit.cover,
                                    )
                                  : Image.asset(
                                      'assets/logo/fliver-black.png',
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
                      label:
                          AppLocalizations.of(context).translate('speedDial1'),
                      labelStyle: MyTextStyles.labelStyle,
                      onTap: () async {
                        currentLocation =
                            await Geolocator().getCurrentPosition();
                        locationAnimation == 0
                            ? locationAnimation = 1
                            : locationAnimation = 0;
                        _animateToLocation(currentLocation, locationAnimation);
                      },
                    ),
                    SpeedDialChild(
                      child: toggleLightsIcon,
                      foregroundColor: invertColorsTheme(context),
                      backgroundColor: invertInvertColorsTheme(context),
                      label: toggleLightsText,
                      labelStyle: MyTextStyles.labelStyle,
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
                      label:
                          AppLocalizations.of(context).translate('speedDial3'),
                      labelStyle: MyTextStyles.labelStyle,
                      onTap: () async {
                        SharedPreferences prefs =
                            await SharedPreferences.getInstance();
                        bool isTipShown3 =
                            prefs.getBool('isTipShown3') ?? false;

                        if (isTipShown3) {
                          Navigator.push(context,
                              CupertinoPageRoute(builder: (context) {
                            return MyCreditsPage();
                          }));
                        } else {
                          // display a tip only once
                          prefs.setBool('isTipShown3', true);
                          showDialog(
                            context: context,
                            child: AlertDialog(
                              shape: RoundedRectangleBorder(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(10.0))),
                              title: Text(
                                AppLocalizations.of(context)
                                    .translate('titleCredits'),
                                style: isThemeCurrentlyDark(context)
                                    ? MyTextStyles.titleStyleLight
                                    : MyTextStyles.titleStyleDark,
                              ),
                              content: Text(
                                AppLocalizations.of(context)
                                    .translate('creditsPopupBody'),
                                style: isThemeCurrentlyDark(context)
                                    ? MyTextStyles.bodyStyleLight
                                    : MyTextStyles.bodyStyleDark,
                              ),
                              actions: <Widget>[
                                RaisedButton(
                                  child: Text(AppLocalizations.of(context)
                                      .translate('creditsPopupButton')),
                                  color: invertColorsTheme(context),
                                  textColor: invertInvertColorsStrong(context),
                                  elevation: 3.0,
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.all(
                                          Radius.circular(5.0))),
                                  onPressed: () {
                                    Navigator.pop(context);
                                    Navigator.push(context,
                                        CupertinoPageRoute(builder: (context) {
                                      return MyCreditsPage();
                                    }));
                                  },
                                ),
                              ],
                            ),
                          );
                        }
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
