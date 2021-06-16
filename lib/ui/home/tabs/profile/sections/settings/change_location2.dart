import 'dart:async';
import 'dart:math' show cos, sqrt, asin;
import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:geocoder/geocoder.dart';
import 'package:geolocator/geolocator.dart';
import 'package:geolocator_platform_interface/src/enums/location_accuracy.dart' as geo;
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location_tracker/model/map_point.dart';
import 'package:location_tracker/services/network.dart';
import 'package:location_tracker/utils/constants.dart';
import 'package:location_tracker/utils/firebase_transaction.dart';
import 'package:location_tracker/utils/gen_new_user.dart' as nUser;
import 'package:location_tracker/utils/map_transaction.dart';
import 'package:location_tracker/utils/widgets/modal_user_info.dart';
import 'package:swapxchange/ui/home/tabs/profile/sections/settings/user_addr_modal.dart';

class TrackUser extends StatefulWidget {
  TrackUser({@required this.title});

  static const id = 'track_user';

  final String title;

  @override
  _TrackUserState createState() => _TrackUserState();
}

class _TrackUserState extends State<TrackUser> {
  String _myAddress;
  String _myName;
  String _myEmail;
  bool zoomFlag = false;
  bool isFirstTime = true;
  var _totalDistance = '0.0';
  nUser.User _user = nUser.User();
  Set<Marker> markers = {};

  // Getting the placemarks

// Retrieving coordinates
  MapPoint startCoordinates = MapPoint(latitude: 0, longitude: 0);
  MapPoint destinationCoordinates = MapPoint(latitude: 6.4550651, longitude: 3.5197741, address: '');

// Initial location of the Map view
  CameraPosition _initialLocation = CameraPosition(
    target: LatLng(6.4550651, 3.5197741),
    zoom: 18,
  );

// For controlling the view of the Map
  GoogleMapController mapController;

  void _myLocationListener(GoogleMapController controller) {
    mapController = controller;
  }

  @override
  void initState() {
    super.initState();
    updateCurrentLocation();
  }

// For storing the current position
  Position _currentPosition;

  // Method for retrieving the current location
  void updateCurrentLocation() async {
    //GET MY CURRENT LOCATION
    await getCurrentPosition(desiredAccuracy: LocationAccuracy.high).then((Position position) async {
      _currentPosition = position;
      startCoordinates.latitude = _currentPosition.latitude;
      startCoordinates.longitude = _currentPosition.longitude;
      final coordinates = Coordinates(position.latitude, position.longitude); // From coordinates
      var addresses = await Geocoder.local.findAddressesFromCoordinates(coordinates);
      var first = addresses.first;

      setState(() {
        _myAddress = first.addressLine;
      });
      updateMarkers();
      calculateDistance();
      if (isFirstTime) {
        drawRoutes();
        setMarkerConstraints();
        isFirstTime = false;
      }

      await FirebaseTransaction.addUserToDb(position, _myEmail, first.addressLine).then((value) {}).catchError((e) {
        print(e);
      });
    }).catchError((e) {
      print(e);
    });
  }

  @override
  Widget build(BuildContext context) {
    Map arguments = ModalRoute.of(context).settings.arguments;
    // final Map arguments = ModalRoute.of(context).settings.arguments as Map;
    if (arguments != null) {
      try {
        _myName = arguments['my_name'];
        _myAddress = arguments['my_address'];
        _myEmail = arguments['my_email'];
        _user.email = arguments['email'];
        _user.name = arguments['name'];
        _user.address = arguments['address'];
        _user.latitude = arguments['latitude'];
        _user.longitude = arguments['longitude'];

        destinationCoordinates.latitude = _user.latitude;
        destinationCoordinates.longitude = _user.longitude;
      } catch (e) {
        print(e);
        Navigator.pop(context);
      }
    }
    // Determining the screen width & height
    var height = MediaQuery.of(context).size.height;
    var width = MediaQuery.of(context).size.width;

    return Scaffold(
      body: Stack(children: <Widget>[
        Container(
          width: width,
          height: height,
          color: Colors.blueGrey,
          child: GoogleMap(
            initialCameraPosition: _initialLocation,
            myLocationEnabled: true,
            myLocationButtonEnabled: false,
            mapType: MapType.normal,
            zoomGesturesEnabled: true,
            zoomControlsEnabled: false,
            markers: markers,
            polylines: Set<Polyline>.of(polylines.values),
            onMapCreated: (GoogleMapController controller) {
              _myLocationListener(controller);
            },
          ),
        ),
        Positioned(
          top: 60,
          right: 0,
          left: 0,
          child: Container(
            width: 400,
            padding: EdgeInsets.symmetric(vertical: 6, horizontal: 12),
            margin: EdgeInsets.only(top: 6, right: 20, left: 20),
            decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.all(Radius.circular(5)), border: Border.all(color: Colors.blueGrey[100], width: 1)),
            child: Row(
              children: [
                Icon(
                  Icons.location_on_sharp,
                  color: Colors.redAccent,
                  size: 20,
                ),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      _myAddress,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        color: Colors.blueGrey,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
        Positioned(
          top: 160,
          right: 0,
          left: 0,
          child: Container(
            padding: EdgeInsets.symmetric(vertical: 6, horizontal: 12),
            margin: EdgeInsets.only(top: 6, right: 60, left: 60),
            decoration: BoxDecoration(
              color: Colors.white70,
              borderRadius: BorderRadius.all(Radius.circular(25)),
            ),
            child: Expanded(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  'DISTANCE: $_totalDistance',
                  textAlign: TextAlign.center,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(color: Colors.black87, fontWeight: FontWeight.w500),
                ),
              ),
            ),
          ),
        ),
        Positioned(
          bottom: 30,
          right: 20,
          child: GestureDetector(
            onTap: () async {
              updateCurrentLocation();

              //for zooming and current location adjusting
              if (!isFirstTime) {
                if (!zoomFlag) {
                  zoomFlag = true;
                  setMarkerConstraints();
                } else {
                  zoomFlag = false;
                  mapController.animateCamera(CameraUpdate.newCameraPosition(CameraPosition(
                    target: LatLng(startCoordinates.latitude, startCoordinates.longitude),
                    zoom: (await mapController.getZoomLevel()) + 2,
                  )));
                }
              }
            },
            child: CircleAvatar(
              radius: 30,
              child: Icon(
                Icons.my_location,
                color: Colors.blueGrey,
                size: 28,
              ),
              backgroundColor: Colors.white,
            ),
          ),
        )
      ]),
    );
  }

  void updateMarkers() {
    markers.clear();

    // Start Location Marker
    Marker startMarker = Marker(
      markerId: MarkerId('$_currentPosition'),
      position: LatLng(
        startCoordinates.latitude,
        startCoordinates.longitude,
      ),
      onTap: () {
        showModalBottomSheet(
            context: context,
            builder: (builder) {
              return ModalUserInfo(
                name: _myName,
                from_address: _myAddress,
                to_address: _user.address,
                email: _myEmail,
                start_point: startCoordinates,
                destination_point: destinationCoordinates,
                status: "Start",
              );
            });
      },
      icon: BitmapDescriptor.defaultMarker,
    );

// Destination Location Marker
    Marker destinationMarker = Marker(
      markerId: MarkerId('$destinationCoordinates'),
      position: LatLng(
        destinationCoordinates.latitude,
        destinationCoordinates.longitude,
      ),
      onTap: () {
        showModalBottomSheet(
            context: context,
            builder: (builder) {
              return ModalUserInfo(
                name: _user.name,
                from_address: _user.address,
                to_address: _myAddress,
                email: _user.email,
                start_point: destinationCoordinates,
                destination_point: startCoordinates,
                status: "Destination",
              );
            });
      },
      icon: BitmapDescriptor.defaultMarker,
    );

    // Add the markers to the list
    setState(() {
      markers.add(startMarker);
      markers.add(destinationMarker);
    });
  }

  void setMarkerConstraints() async {
    var lats = [startCoordinates.latitude, destinationCoordinates.latitude];
    var longs = [startCoordinates.longitude, destinationCoordinates.longitude];
    lats.sort((a, b) => a.compareTo(b)); //asc
    longs.sort((a, b) => a.compareTo(b)); //asc

    setState(() {
      mapController.animateCamera(CameraUpdate.newLatLngBounds(
          LatLngBounds(
            southwest: LatLng(lats[0], longs[0]), // LatLng(latMin, longMin)
            northeast: LatLng(lats[1], longs[1]), // LatLng(latMax, longMax)
          ),
          50));
    });
  }

  void calculateDistance() async {
    // double distanceInMeters = distanceBetween(startCoordinates.latitude, startCoordinates.longitude, destinationCoordinates.latitude, destinationCoordinates.longitude,);
    // double distanceInMeters2 = MapTransaction.calcDistance(startCoordinates.latitude, startCoordinates.longitude, destinationCoordinates.latitude, destinationCoordinates.longitude);
    //
    // setState(() {
    //   _totalDistance = (distanceInMeters/1000).toStringAsFixed(2);//to 2 dp
    // });

    //using G-Map
    var mapResult = await NetworkHelper(startCoordinates, destinationCoordinates).getData();

    if (mapResult == null) {
      Navigator.of(context).pop();
      return;
    }

    var routes = mapResult['routes'];

    setState(() {
      _totalDistance = routes[0]['legs'][0]['distance']['text'];
      var total_duration = routes[0]['legs'][0]['duration']['text'];
    });
  }

  // Object for PolylinePoints
  PolylinePoints polylinePoints;
// List of coordinates to join
  List<LatLng> polylineCoordinates = [];
// Map storing polylines created by connecting two points
  Map<PolylineId, Polyline> polylines = {};
  // Create the polylines for showing the route between two places
  void drawRoutes() async {
    polylines.clear();
    // Initializing PolylinePoints
    polylinePoints = PolylinePoints();

    // Generating the list of coordinates to be used for
    // drawing the polylines
    PolylineResult result = await polylinePoints.getRouteBetweenCoordinates(
        API_KEY, // Google Maps API Key
        PointLatLng(_currentPosition.latitude, _currentPosition.longitude),
        PointLatLng(destinationCoordinates.latitude, destinationCoordinates.longitude));
    // Adding the coordinates to the list
    if (result.points.isNotEmpty) {
      result.points.forEach((PointLatLng point) {
        polylineCoordinates.add(LatLng(point.latitude, point.longitude));
      });
    }

    // Defining an ID
    PolylineId id = PolylineId('poly');

    setState(() {
      // Initializing Polyline
      Polyline polyline = Polyline(
        polylineId: id,
        color: Colors.red,
        points: polylineCoordinates,
        width: 3,
      );

      // Adding the polyline to the map
      polylines[id] = polyline;
    });
  }
}
