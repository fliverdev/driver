import 'dart:async';

import 'package:driver/pages/about_page.dart';
import 'package:driver/services/map.dart';
import 'package:driver/utils/map_style.dart';
import 'package:driver/utils/text_styles.dart';
import 'package:driver/utils/ui_helpers.dart';
import 'package:driver/utils/variables.dart';
import 'package:driver/widgets/fetching_location.dart';
import 'package:driver/widgets/no_connection.dart';
import 'package:dynamic_theme/dynamic_theme.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_offline/flutter_offline.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class MyMapViewPage extends StatefulWidget {
  @override
  _MyMapViewPageState createState() => _MyMapViewPageState();
}

class _MyMapViewPageState extends State<MyMapViewPage> {
  @override
  void initState() {
    super.initState();
    position = _setCurrentLocation();
  } // gets current user location when the app launches

  void _onMapCreated(GoogleMapController controller) {
    mapController = controller;

    if (isFirstLaunch) {
//      _fetchMarkersFromDb();
      mapController
          .setMapStyle(isThemeCurrentlyDark(context) ? darkMap : lightMap);
      isFirstLaunch = false;
    } else {
      mapController
          .setMapStyle(isThemeCurrentlyDark(context) ? lightMap : darkMap);
    } // weird fix for broken dark mode

    Timer.periodic(markerRefreshInterval, (Timer t) {
      print('$markerRefreshInterval seconds over, refreshing...');
//      _fetchMarkersFromDb(); // updates markers every 10 seconds
    });
  }

  Future<Position> _setCurrentLocation() async {
    currentLocation = await Geolocator().getCurrentPosition();
    return currentLocation;
  }

  @override
  Widget build(BuildContext context) {
    Icon toggleLightsIcon = isThemeCurrentlyDark(context)
        ? Icon(Icons.brightness_7)
        : Icon(Icons.brightness_2);
    String toggleLightsText =
        isThemeCurrentlyDark(context) ? 'प्रकाश मोड' : 'डार्क मोड';

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
                        mapToolbarEnabled: true,
                        myLocationEnabled: true,
                        myLocationButtonEnabled: false,
                        compassEnabled: false,
                        initialCameraPosition: CameraPosition(
                          target: LatLng(currentLocation.latitude,
                              currentLocation.longitude),
                          zoom: zoom[0],
                          bearing: bearing[0],
                          tilt: tilt[0],
                        ),
                        markers: Set<Marker>.of(markers.values),
                        circles: hotspots,
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
                      label: 'आपका स्थान',
                      labelStyle: MyTextStyles.labelStyle,
                      onTap: () {
                        if (locationAnimation == 0) {
                          locationAnimation = 1;
                        } else if (locationAnimation == 1) {
                          locationAnimation = 0;
                        }
                        animateToCurrentLocation(locationAnimation);
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
                      label: 'जानकारी',
                      labelStyle: MyTextStyles.labelStyle,
                      onTap: () {
                        Navigator.push(context,
                            CupertinoPageRoute(builder: (context) {
                          return MyAboutPage();
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

  @override
  void dispose() {
    subscription.cancel();
    super.dispose();
  }
}
