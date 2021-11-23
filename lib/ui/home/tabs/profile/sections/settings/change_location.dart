import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:permission_handler/permission_handler.dart' as pHandler;
import 'package:swapxchange/controllers/category_controller.dart';
import 'package:swapxchange/controllers/product_controller.dart';
import 'package:swapxchange/controllers/sub_category_controller.dart';
import 'package:swapxchange/controllers/user_controller.dart';
import 'package:swapxchange/models/app_user.dart';
import 'package:swapxchange/repository/address_change_methods.dart';
import 'package:swapxchange/repository/auth_repo.dart';
import 'package:swapxchange/ui/home/tabs/profile/sections/settings/modals/address_modal_info.dart';
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
  TextEditingController addressController = TextEditingController(text: UserController.to.user!.address);

// Retrieving coordinates
  late MapPoint startCoordinates;

// Initial location of the Map view
  CameraPosition _initialLocation = CameraPosition(
    target: LatLng(
      UserController.to.user!.addressLat ?? 6.4550651,
      UserController.to.user!.addressLong ?? 3.5197741,
    ),
    zoom: 18,
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
      latitude: user.addressLat ?? 0,
      longitude: user.addressLong ?? 0,
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
      onSuccess: (appUser) async {
        if (appUser != null) {
          UserController.to.setUser(appUser);
          ProductController.to.fetchAll(reset: true);
          CategoryController.to.fetch();
          SubCategoryController.to.fetch();
          await Future.delayed(Duration(seconds: 2));
          AlertUtils.toast('Address updated successfully');
          AlertUtils.hideProgressDialog();
          Get.back(closeOverlays: true, result: appUser);
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
          _addressFromLatLong(position.latitude, position.longitude);
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

  _addressFromLatLong(double lat, double long) async {
    List<Placemark> addresses = await placemarkFromCoordinates(lat, long);
    AlertUtils.hideProgressDialog();

    var placeMark = addresses.first;
    String address = "${placeMark.street} ${placeMark.subLocality}, ${placeMark.locality}";
    String? state = placeMark.subLocality == null || placeMark.subLocality!.isEmpty ? placeMark.locality : placeMark.subLocality;

    updatedUser.address = address;
    updatedUser.state = state ?? address;
    updatedUser.addressLong = lat;
    updatedUser.addressLat = long;
    updateMarkers();
    _showBottomSheet();

    mapController!.animateCamera(
      CameraUpdate.newCameraPosition(
        CameraPosition(
          target: LatLng(lat, long),
          zoom: 18, /**/
        ),
      ),
    );
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
      updatedUser.addressLong = addressDetails.longitude;
      updatedUser.addressLat = addressDetails.latitude;
      updateMarkers();
      _showBottomSheet();

      mapController!.animateCamera(
        CameraUpdate.newCameraPosition(
          CameraPosition(
            target: LatLng(addressDetails.latitude, addressDetails.longitude),
            zoom: 18,
          ),
        ),
      );
    }
  }

  //--> Without google map
  _findLagLongFromAddress2(String addr) async {
    try {
      AlertUtils.showProgressDialog(title: null);
      List<Location> locations = await locationFromAddress(addr);
      _addressFromLatLong(locations[0].latitude, locations[0].longitude);
    } catch (e) {
      AlertUtils.hideProgressDialog();
      AlertUtils.toast('address not found');
      print(e);
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
            mapType: MapType.normal,
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
                  child: TextField(
                    // initialValue: user.address,
                    controller: addressController,
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
                    textInputAction: TextInputAction.search,
                    onSubmitted: (str) => _findLagLongFromAddress2(str),
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
                  width: 400,
                  height: 400,
                  margin: EdgeInsets.only(top: 0, right: 20, left: 20),
                  decoration: BoxDecoration(
                    color: Colors.white70,
                    borderRadius: BorderRadius.all(Radius.circular(0)),
                  ),
                  padding: EdgeInsets.symmetric(vertical: 6, horizontal: 12),
                  child: ListView.separated(
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
                        onTap: () {
                          _findLagLongFromAddress(snapshot.data![index]);
                          addressController.text = snapshot.data![index].description;
                        },
                      );
                    },
                    separatorBuilder: (BuildContext context, int index) {
                      return Container(
                        height: 1,
                        color: KColors.WHITE_GREY,
                      );
                    },
                  ),
                );
              }),
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
      position: LatLng(updatedUser.addressLat ?? 06.4550651, updatedUser.addressLong ?? 3.5197741),
      onTap: () => _showBottomSheet(),
      icon: BitmapDescriptor.defaultMarker,
    );

    // Add the markers to the list
    setState(() {
      markers.add(startMarker);
    });
  }
}
