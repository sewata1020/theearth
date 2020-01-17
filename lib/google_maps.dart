import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';

class GoogleMaps extends StatefulWidget {
  @override
  _GoogleMapsState createState() => _GoogleMapsState();
}

class _GoogleMapsState extends State<GoogleMaps> {
  LocationData currentLocation;

  // StreamSubscription<LocationData> locationSubscription;

  Location _locationService = new Location();
  String error;

  @override
  void initState() {
    super.initState();

    initPlatformState();
    _locationService.onLocationChanged().listen((LocationData result) async {
      setState(() {
        currentLocation = result;
      });
    });
  }

  Completer<GoogleMapController> _controller = Completer();

  void _onMapCreated(GoogleMapController controller) {
    _controller.complete(controller);
  }

  @override
  Widget build(BuildContext context) {
    if (currentLocation == null) {
      return Center(
        child: CircularProgressIndicator(),
      );
    } else {
      return MaterialApp(
        home: Scaffold(
          appBar: AppBar(
            title: Text('The Earth'),
            backgroundColor: Colors.blue[500],
          ),
          drawer: Drawer(
            child: ListView(
              children: <Widget>[
                DrawerHeader(
                  child: Text(
                    'メニュー',
                    style: TextStyle(
                      fontSize: 50,
                      color: Colors.white,
                    ),
                  ),
                  decoration: BoxDecoration(
                    color: Colors.blue,
                  ),
                ),
                ListTile(
                  title: Text('図鑑'),
                  onTap: () {
                    Navigator.pop(context);
                  },
                ),
                ListTile(
                  title: Text('位置から検索'),
                  onTap: () {
                    Navigator.pop(context);
                  },
                ),
                ListTile(
                  title: Text('設定'),
                  onTap: () {
                    Navigator.pop(context);
                  },
                ),
                ListTile(
                  title: Text('ログアウト'),
                  onTap: () {
                    Navigator.pop(context);
                  },
                ),
                ListTile(
                  title: Text('ex'),
                  onTap: () {
                    Navigator.pop(context);
                  },
                ),
              ],
            ),
          ),
          body: GoogleMap(
            onMapCreated: _onMapCreated,
            initialCameraPosition: CameraPosition(
              target:
              LatLng(currentLocation.latitude, currentLocation.longitude),
              zoom: 17.0,
            ),
            myLocationEnabled: true,
          ),
        ),
      );
    }
  }

  void initPlatformState() async {
    LocationData myLocation;
    try {
      myLocation = await _locationService.getLocation();
      error = "";
    } on PlatformException catch (e) {
      if (e.code == 'PERMISSION_DENITED')
        error = 'Permission denited';
      else if (e.code == 'PERMISSION_DENITED_NEVER_ASK')
        error =
        'Permission denited - please ask the user to enable it from the app settings';
      myLocation = null;
    }
    setState(() {
      currentLocation = myLocation;
    });
  }
}