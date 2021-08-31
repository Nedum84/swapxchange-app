import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:swapxchange/models/product_model.dart';
import 'package:swapxchange/utils/alert_utils.dart';
import 'package:swapxchange/utils/colors.dart';
import 'package:url_launcher/url_launcher.dart';

class MapView extends StatelessWidget {
  final Product product;

  const MapView({Key? key, required this.product}) : super(key: key);

  Set<Marker> markers() {
    final Set<Marker> markers = {};

    // Start Location Marker
    Marker startMarker = Marker(
      markerId: MarkerId('${product.productId}'),
      position: LatLng(double.tryParse(product.userAddressLat!) ?? 6.4550651, double.tryParse(product.userAddressLong!) ?? 3.5197741),
      // icon: BitmapDescriptor.defaultMarker,
      onTap: () => AlertUtils.toast('${product.userAddress}'),
    );

    markers.add(startMarker);
    return markers;
  }

  Future<void> openMap() async {
    final latitude = double.tryParse(product.userAddressLat!) ?? 6.4550651;
    final longitude = double.tryParse(product.userAddressLong!) ?? 3.5197741;
    String googleUrl = 'https://www.google.com/maps/search/?api=1&query=$latitude,$longitude';
    if (await canLaunch(googleUrl)) {
      await launch(googleUrl);
    } else {
      throw 'Could not open the map.';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: 100,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(4),
        child: Stack(
          children: [
            GoogleMap(
              initialCameraPosition: CameraPosition(
                target: LatLng(
                  double.tryParse(product.userAddressLat!) ?? 6.4550651,
                  double.tryParse(product.userAddressLong!) ?? 3.5197741,
                ),
                zoom: 15,
              ),
              myLocationEnabled: false,
              myLocationButtonEnabled: false,
              mapType: MapType.normal,
              zoomGesturesEnabled: false,
              zoomControlsEnabled: false,
              scrollGesturesEnabled: false,
              onTap: (latLong) {
                openMap();
              },
              // markers: markers(),
            ),
            Align(
              alignment: Alignment.center,
              child: Container(
                width: 50,
                height: 50,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(40),
                  border: Border.all(width: 2, color: KColors.SECONDARY),
                  color: KColors.SECONDARY.withOpacity(.15),
                ),
                // child: Column(
                //   mainAxisAlignment: MainAxisAlignment.center,
                //   crossAxisAlignment: CrossAxisAlignment.center,
                //   children: [
                //     Container(
                //       width: 5,
                //       height: 5,
                //       decoration: BoxDecoration(
                //         borderRadius: BorderRadius.circular(4),
                //         color: Color(0xffCD4F4E).withOpacity(.3),
                //       ),
                //     ),
                //   ],
                // ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
