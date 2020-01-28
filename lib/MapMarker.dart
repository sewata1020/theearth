import 'package:fluster/fluster.dart';
import 'package:meta/meta.dart';

class MapMarker extends Clusterable {
  MapMarker({
    @required latitude,
    @required longitude,
    isCluster = false,
    clusterId,
    pointsSize,
    markerId,
    onTap,
    childMarkerId,
  }) : super(
    latitude: latitude,
    longitude: longitude,
    isCluster: isCluster,
    clusterId: clusterId,
    pointsSize: pointsSize,
    markerId: markerId,
    childMarkerId: childMarkerId);

}