import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:swapxchange/models/product_model.dart';
import 'package:swapxchange/utils/alert_utils.dart';

class MapView extends StatelessWidget {
  final Product product;

  const MapView({Key? key, required this.product}) : super(key: key);

  Set<Marker> markers() {
    final Set<Marker> markers = {};

    // Start Location Marker
    Marker startMarker = Marker(
      markerId: MarkerId('${product.productId}'),
      position: LatLng(double.tryParse(product.userAddressLat!) ?? 6.4550651, double.tryParse(product.userAddressLong!) ?? 3.5197741),
      icon: BitmapDescriptor.defaultMarker,
      onTap: () => AlertUtils.toast('${product.userAddress}'),
    );

    markers.add(startMarker);
    return markers;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: 100,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(4),
        child: GoogleMap(
          initialCameraPosition: CameraPosition(
            target: LatLng(
              double.tryParse(product.userAddressLat!) ?? 6.4550651,
              double.tryParse(product.userAddressLong!) ?? 3.5197741,
            ),
            zoom: 18,
          ),
          myLocationEnabled: false,
          myLocationButtonEnabled: false,
          mapType: MapType.normal,
          zoomGesturesEnabled: false,
          zoomControlsEnabled: false,
          scrollGesturesEnabled: false,
          markers: markers(),
        ),
      ),
    );
  }
}
