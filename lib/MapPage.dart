import 'dart:async';
import 'dart:math' as math;
import 'dart:typed_data';
import 'dart:ui' as ui;

import 'package:flutter/services.dart';
import 'package:fluster/fluster.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:the_earth/MapMarker.dart';
import 'package:the_earth/setting.dart';
import 'package:location/location.dart';


class MapPage extends StatefulWidget {
  const MapPage({Key key}) : super(key: key);

  @override
  _MapPageState createState() => _MapPageState();
}

class _MapPageState extends State<MapPage> {
  LocationData currentLocation;

  Location _locationService = new Location();
  String error;

  @override
  void initState() {
    super.initState();
    initPlatformState();
    _locationService.onLocationChanged().listen((LocationData result)async{
      setState((){
        currentLocation = result;
      });
    });
    _createRandomPoints().then((value) async {
      await _createCluster();
      await _updateMarkers();
    });

    _currentPosition = _kInitialPosition;
  }

  void initPlatformState() async {
    LocationData myLocation;
    try {
      myLocation = await _locationService.getLocation();
      error = "";
    }on PlatformException catch(e){
      if(e.code == 'PERMISSION_DENITED')
        error = 'Permission denited';
      else if(e.code == 'PERMISSION_DENITED_NEVER_ASK')
        error = 'Permission denited - please ask the user to enable it from the app settings';
      myLocation = null;
    }
    setState(() {
      currentLocation = myLocation;
    });
  }


  Completer<GoogleMapController> _controller = Completer();
  Fluster<MapMarker> _fluster;
  List<MapMarker> _points = List<MapMarker>();
  CameraPosition _currentPosition;
  StreamController<Map<MarkerId, Marker>> _markers = StreamController();
  static final CameraPosition _kInitialPosition = CameraPosition(
    target: LatLng(34.694685,135.194933),
    zoom: 17.0,
  );


  double mapPixelWidth;
  double mapPixelHeight;



  @override
  void dispose() {
    super.dispose();
    _markers.close();
  }

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    final double ratio = MediaQuery.of(context).devicePixelRatio;
    mapPixelWidth = size.width * ratio;
    mapPixelHeight = size.height * ratio;
    return Scaffold(
      appBar: AppBar(
        title: Text('The Earth'),
        backgroundColor: Colors.green[500],
      ),drawer: Drawer(
      child: ListView(
        children: <Widget>[
          DrawerHeader(
            child: Text(
              'メニュー',
              style: TextStyle(
                fontSize: 40,
                color: Colors.white,
              ),
            ),
            decoration: BoxDecoration(
              color: Colors.grey[600],
            ),
          ),
          ListTile(
            title: Text('図鑑'),
            onTap: () {
              Navigator.pushNamed(context,'/entry');
            },
          ),
          ListTile(
            title: Text('追加'),
            onTap: () {
              _onTapMarker();
            },
          ),
          ListTile(
            title: Text('設定'),
            onTap: () {
              Navigator.pushNamed(context,'/setting');
            },
          ),
          ListTile(
            title: Text('マイページ'),
            onTap: () {
              Navigator.pushNamed(context,'/bear');
            },
          ),
          ListTile(
            title: Text('アプリを終了する'),
            onTap: () {
              SystemNavigator.pop();
            },
          ),
        ],
      ),
    ),

      body: Container(
        child: StreamBuilder<Map<MarkerId, Marker>>(
          initialData: {},
          stream: _markers.stream,
          builder: (_, AsyncSnapshot<Map<MarkerId, Marker>> snapshot) {
            return GoogleMap(
              initialCameraPosition: CameraPosition(
                target:
                LatLng(currentLocation.latitude, currentLocation.longitude),
                zoom: 17.0,),
              mapType: MapType.normal,
              myLocationEnabled: true,
              myLocationButtonEnabled: false,
              rotateGesturesEnabled: false,
              onCameraMove: _onCameraMove,
              onCameraIdle: _onCameraIdle,
              onTap: _onTap,
              onMapCreated: (GoogleMapController controller) {
                _controller.complete(controller);
              },
              gestureRecognizers: <Factory<OneSequenceGestureRecognizer>>[
                Factory<OneSequenceGestureRecognizer>(
                      () => EagerGestureRecognizer(),
                ),
              ].toSet(),
              markers: Set<Marker>.of(snapshot.data.values),
            );
          },
        ),
      ),
    );
  }

  void _onCameraMove(CameraPosition cameraPosition) {
    setState(() {
      _currentPosition = cameraPosition;
    });
  }

  void _onCameraIdle() {
    _updateMarkers();
  }


  void _onTap(LatLng target) {
    _controller.future.then((controller) {
      controller.animateCamera(CameraUpdate.newLatLng(LatLng(target.latitude, target.longitude)));
    });
  }

  void _onTapMarker(){
     showDialog<int>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('周辺の生物'),
          content: Text('ホッキョクグマ'),
          actions: <Widget>[
            FlatButton(
              child: Text('OK'),
              onPressed: () => Navigator.of(context).pop(1),
            ),
          ],
        );
      },
    );
  }

  Future<void> _createCluster() async {
    _fluster = Fluster<MapMarker>(
        minZoom: 0,
        maxZoom: 21,
        radius: 210,
        extent: 512,
        nodeSize: 64,
        points: _points,
        createCluster: (BaseCluster cluster, double longitude, double latitude) =>
            MapMarker(
                latitude: latitude,
                longitude: longitude,
                isCluster: true,
                clusterId: cluster.id,
                pointsSize: cluster.pointsSize,
                markerId: cluster.id.toString(),
                onTap:(){
                  Navigator.pushNamed(context,'/bear');
                },
                childMarkerId: cluster.childMarkerId
            )
    );

  }

  Future<void> _updateMarkers() async {
    if (_fluster == null || _points == null) {
      return;
    }

    Map<MarkerId, Marker> markers = Map();
    int zoom = _currentPosition.zoom.round();
    markers = await _createMarkers(_currentPosition.target, zoom);
    _markers.sink.add(markers);
  }

  Future<Map<MarkerId, Marker>> _createMarkers(LatLng location, int zoom) async {
    LatLng northeast = _calculateLatLon(mapPixelWidth, 0);
    LatLng southwest = _calculateLatLon(0, mapPixelHeight);
    var bounds = [
      southwest.longitude,
      southwest.latitude,
      northeast.longitude,
      northeast.latitude
    ];
    List<MapMarker> clusters = _fluster.clusters(bounds, zoom);
    Map<MarkerId, Marker> markers = Map();
    for (MapMarker feature in clusters) {
      final Uint8List markerIcon = await _getBytesFromCanvas(feature);
      BitmapDescriptor bitmapDescriptor = BitmapDescriptor.fromBytes(markerIcon);
      Marker marker = Marker(
          markerId: MarkerId(feature.markerId),
          position: LatLng(feature.latitude, feature.longitude),
          icon: bitmapDescriptor,
        onTap:(){
            _onTapMarker();
        },
      );
      markers.putIfAbsent(MarkerId(feature.markerId), () => marker);
    }
    return markers;
  }

  LatLng _calculateLatLon(x, y) {
    double parallelMultiplier = math.cos(_currentPosition.target.latitude * math.pi / 180);
    double degreesPerPixelX = 360 / math.pow(2, _currentPosition.zoom + 8);
    double degreesPerPixelY = 360 / math.pow(2, _currentPosition.zoom + 8) * parallelMultiplier;
    var lat = _currentPosition.target.latitude - degreesPerPixelY * (y - mapPixelHeight / 2);
    var lng = _currentPosition.target.longitude + degreesPerPixelX * (x  - mapPixelWidth / 2);
    LatLng latLng = LatLng(lat, lng);
    return latLng;
  }

  Future<Uint8List> _getBytesFromCanvas(MapMarker feature) async {
    Color color = Colors.blue[300];
    String text = "1";
    int size = 80;

    if (feature.pointsSize != null) {
      text = feature.pointsSize.toString();
      if (feature.pointsSize >= 100) {
        color = Colors.red[400];
        size = 110;
      } else if (feature.pointsSize >= 10) {
        color = Colors.yellow[600];
        size = 90;
      }
    }

    final ui.PictureRecorder pictureRecorder = ui.PictureRecorder();
    final Canvas canvas = Canvas(pictureRecorder);
    final Paint paint2 = Paint()..color = Colors.white;
    final Paint paint1 = Paint()..color = color;
    canvas.drawCircle(Offset(size / 2, size / 2), size / 3.0, paint2);
    canvas.drawCircle(Offset(size / 2, size / 2), size / 3.3, paint1);
    TextPainter painter = TextPainter(textDirection: TextDirection.ltr);
    painter.text = TextSpan(
      text: text,
      style: TextStyle(
          fontSize: size / 4, color: Colors.black, fontWeight: FontWeight.bold),
    );
    painter.layout();
    painter.paint(
      canvas,
      Offset(size / 2 - painter.width / 2, size / 2 - painter.height / 2),
    );

    final img = await pictureRecorder.endRecording().toImage(size, size);
    final data = await img.toByteData(format: ui.ImageByteFormat.png);
    return data.buffer.asUint8List();
  }

  Future _createRandomPoints() async {
    List<MapMarker> data = [];
    for (double i = 0; i < 1000; i++) {
      final String markerId = i.toString();

      math.Random rand = math.Random();
      int negative = rand.nextBool() ? -1 : 1;
      double lat = _kInitialPosition.target.latitude + (rand.nextInt(10000) / 10000 * negative);
      negative = rand.nextBool() ? -1 : 1;
      double lng = _kInitialPosition.target.longitude + (rand.nextInt(10000) / 10000 * negative);
      MapMarker point = MapMarker(
        latitude: lat,
        longitude: lng,
        markerId: markerId
      );
      data.add(point);
    }
    _points = data;
  }

}