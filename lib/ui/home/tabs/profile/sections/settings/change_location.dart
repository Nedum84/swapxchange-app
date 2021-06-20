import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:permission_handler/permission_handler.dart' as pHandler;
import 'package:swapxchange/controllers/user_controller.dart';
import 'package:swapxchange/models/app_user.dart';
import 'package:swapxchange/repository/address_change_methods.dart';
import 'package:swapxchange/repository/auth_repo.dart';
import 'package:swapxchange/ui/home/tabs/profile/sections/settings/address_modal_info.dart';
import 'package:swapxchange/ui/widgets/loading_progressbar.dart';
import 'package:swapxchange/utils/alert_utils.dart';
import 'package:swapxchange/utils/colors.dart';
import 'package:swapxchange/utils/helpers.dart';
import 'package:swapxchange/utils/permissions.dart';
import 'package:swapxchange/utils/styles.dart';

class MapPoint {
  MapPoint({required this.latitude, required this.longitude, this.address});
  double latitude;
  double longitude;
  String? address;
}

class ChangeLocation extends StatefulWidget {
  @override
  _ChangeLocationState createState() => _ChangeLocationState();
}

class _ChangeLocationState extends State<ChangeLocation> {
  TextEditingController? _addressController;
  AppUser user = UserController.to.user!;
  AppUser updatedUser = AppUser();
  Set<Marker> markers = {};
  String searchAddress = '';
  bool showSuggestion = false;

// Retrieving coordinates
  late MapPoint startCoordinates;

// Initial location of the Map view
  CameraPosition _initialLocation = CameraPosition(
    target: LatLng(
      double.tryParse(UserController.to.user!.addressLat!) ?? 6.4550651,
      double.tryParse(UserController.to.user!.addressLong!) ?? 3.5197741,
    ),
    zoom: 11,
  );

// For controlling the view of the Map
  GoogleMapController? mapController;

  void _myLocationListener(GoogleMapController controller) {
    mapController = controller;
  }

  @override
  void initState() {
    super.initState();
    startCoordinates = MapPoint(
      latitude: double.tryParse(user.addressLat!) ?? 0,
      longitude: double.tryParse(user.addressLong!) ?? 0,
    );
    updatedUser.name = user.name;
    updatedUser.address = user.address;
    updatedUser.state = user.state;
    updatedUser.addressLat = user.addressLat;
    updatedUser.addressLong = user.addressLong;
    updateMarkers();
  }

  _updateAddress() async {
    AlertUtils.showProgressDialog(title: null);
    AuthRepo().updateAddress(
      address: updatedUser.address!,
      address_lat: updatedUser.addressLat,
      address_long: updatedUser.addressLong,
      state: updatedUser.state!,
      onSuccess: (appUser) {
        AlertUtils.hideProgressDialog();
        if (appUser != null) {
          UserController.to.setUser(appUser);
          AlertUtils.toast('Address updated successfully');
          Get.back(closeOverlays: true);
        }
      },
      onError: (er) {
        AlertUtils.hideProgressDialog();
        AlertUtils.toast("$er");
      },
    );
  }

  _grantLocationAccess() async {
    AlertUtils.showProgressDialog(title: null);
    Permissions.locationPermission().then((isPermGranted) async {
      if (isPermGranted) {
        await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high).then((Position position) async {
          List<Placemark> addresses = await placemarkFromCoordinates(position.latitude, position.longitude);
          AlertUtils.hideProgressDialog();

          var placeMark = addresses.first;
          String address = "${placeMark.street} ${placeMark.subLocality}, ${placeMark.locality}";
          String state = placeMark.subLocality ?? "";
          double lat = position.latitude;
          double long = position.longitude;

          updatedUser.address = address;
          updatedUser.state = state;
          updatedUser.addressLong = lat.toString();
          updatedUser.addressLat = long.toString();
          updateMarkers();
          _showBottomSheet();

          mapController!.animateCamera(
            CameraUpdate.newCameraPosition(
              CameraPosition(
                target: LatLng(lat, long),
                // zoom: (await mapController!.getZoomLevel()) + 2,/**/
              ),
            ),
          );
        }).catchError((e) {
          AlertUtils.hideProgressDialog();
          print(e);
          AlertUtils.toast('$e');
        });
      } else {
        AlertUtils.hideProgressDialog();
        pHandler.openAppSettings();
        AlertUtils.toast("Access denied");
      }
    });
  }

  _showBottomSheet() {
    Get.bottomSheet(
      AddressModalInfo(
        name: updatedUser.name!,
        city: updatedUser.state!,
        address: updatedUser.address!,
        lat: updatedUser.addressLat!,
        long: updatedUser.addressLong!,
        onUpdate: _updateAddress,
      ),
    );
  }

  _findLagLongFromAddress(Suggestion suggestion) async {
    AlertUtils.showProgressDialog(title: null);
    final addressDetails = await AddressChangeMethods().fetchDetails(suggestion: suggestion);
    AlertUtils.hideProgressDialog();
    if (addressDetails == null) {
      AlertUtils.alert("Couldn't find the address");
    } else {
      setState(() => showSuggestion = false);
      updatedUser.address = addressDetails.address;
      updatedUser.state = Helpers.getAddressCity(address: addressDetails.address!);
      updatedUser.addressLong = addressDetails.longitude.toString();
      updatedUser.addressLat = addressDetails.latitude.toString();
      updateMarkers();
      _showBottomSheet();

      mapController!.animateCamera(
        CameraUpdate.newCameraPosition(
          CameraPosition(
            target: LatLng(addressDetails.latitude, addressDetails.longitude),
            // zoom: (await mapController!.getZoomLevel()) + 2,
          ),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    // Determining the screen width & height
    var height = MediaQuery.of(context).size.height;
    var width = MediaQuery.of(context).size.width;

    return Scaffold(
      body: Stack(children: <Widget>[
        Container(
          width: width,
          height: height,
          color: KColors.WHITE_GREY,
          child: GoogleMap(
            initialCameraPosition: _initialLocation,
            myLocationEnabled: true,
            myLocationButtonEnabled: false,
            mapType: MapType.satellite,
            zoomGesturesEnabled: true,
            zoomControlsEnabled: false,
            markers: markers,
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
            margin: EdgeInsets.only(top: 6, right: 20, left: 20),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.all(Radius.circular(5)),
              border: Border.all(
                color: Colors.blueGrey[100]!,
                width: 1,
              ),
            ),
            child: Row(
              children: [
                SizedBox(width: 12),
                Icon(
                  Icons.location_on_sharp,
                  color: Colors.redAccent,
                  size: 20,
                ),
                SizedBox(width: 8),
                Expanded(
                  child: TextFormField(
                    initialValue: user.address,
                    keyboardType: TextInputType.streetAddress,
                    maxLines: 1,
                    style: TextStyle(
                      color: KColors.TEXT_COLOR_DARK,
                      fontWeight: FontWeight.w600,
                    ),
                    onChanged: (string) {
                      setState(() {
                        searchAddress = string.trim().toString();
                        showSuggestion = true;
                      });
                    },
                    cursorColor: Colors.blueGrey,
                    decoration: InputDecoration(
                      hintText: 'Enter your address...',
                      hintStyle: StyleNormal.copyWith(
                        color: KColors.TEXT_COLOR,
                        fontWeight: FontWeight.w500,
                      ),
                      floatingLabelBehavior: FloatingLabelBehavior.never,
                      border: InputBorder.none,
                      focusedBorder: InputBorder.none,
                      enabledBorder: InputBorder.none,
                      errorBorder: InputBorder.none,
                      disabledBorder: InputBorder.none,
                      contentPadding: EdgeInsets.only(left: 8, bottom: 2, top: 2, right: 8),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
        Positioned(
          top: 115,
          right: 0,
          left: 0,
          child: Container(
            width: 400,
            height: 400,
            margin: EdgeInsets.only(top: 0, right: 20, left: 20),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.all(Radius.circular(0)),
            ),
            child: FutureBuilder<List<Suggestion>>(
                future: AddressChangeMethods().fetchSuggestions(address: searchAddress),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Center(child: LoadingProgressMultiColor(showBg: false));
                  }
                  if (!snapshot.hasData || searchAddress.isEmpty || !showSuggestion || snapshot.data!.length == 0) {
                    return Container();
                  }
                  if (snapshot.data!.length == 0 && searchAddress.isNotEmpty) {
                    Center(
                      child: Text('No address found', style: StyleNormal),
                    );
                  }

                  return Container(
                    color: Colors.white70,
                    padding: EdgeInsets.symmetric(vertical: 6, horizontal: 12),
                    child: ListView.builder(
                      padding: EdgeInsets.symmetric(horizontal: 4),
                      itemCount: snapshot.data!.length,
                      physics: BouncingScrollPhysics(),
                      itemBuilder: (context, index) {
                        return ListTile(
                          trailing: Icon(
                            Icons.arrow_forward_ios,
                            color: KColors.TEXT_COLOR,
                            size: 16,
                          ),
                          title: Text(
                            snapshot.data![index].description,
                            style: StyleNormal,
                          ),
                          onTap: () => _findLagLongFromAddress(snapshot.data![index]),
                        );
                      },
                    ),
                  );
                }),
          ),
        ),
        Positioned(
          bottom: 30,
          right: 20,
          child: GestureDetector(
            onTap: () async {
              _grantLocationAccess();
            },
            child: CircleAvatar(
              radius: 30,
              child: Icon(
                Icons.my_location,
                color: KColors.TEXT_COLOR,
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
      markerId: MarkerId('${user.userId}'),
      position: LatLng(double.parse(updatedUser.addressLat!), double.parse(updatedUser.addressLong!)),
      onTap: _showBottomSheet,
      icon: BitmapDescriptor.defaultMarker,
    );

    // Add the markers to the list
    setState(() {
      markers.add(startMarker);
    });
  }
}
