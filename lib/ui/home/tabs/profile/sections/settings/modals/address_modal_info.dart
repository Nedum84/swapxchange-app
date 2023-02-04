import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:swapxchange/ui/home/product/addproduct/widgets/bottomsheet_container.dart';
import 'package:swapxchange/ui/widgets/custom_button.dart';
import 'package:swapxchange/utils/colors.dart';
import 'package:swapxchange/utils/constants.dart';
import 'package:swapxchange/utils/styles.dart';

class AddressModalInfo extends StatelessWidget {
  AddressModalInfo({
    required this.name,
    required this.address,
    required this.city,
    required this.lat,
    required this.long,
    required this.onUpdate,
  });

  final String name;
  final String address;
  final String city;
  final double lat;
  final double long;
  final Function() onUpdate;

  @override
  Widget build(BuildContext context) {
    return BottomSheetContainer(
      title: name,
      child: Expanded(
        child: ListView(
          children: [
            InfoList(title: address, icon: Icons.location_on_sharp),
            InfoList(title: "City: $city", icon: Icons.location_on_sharp),
            InfoList(title: "Latitude: $lat", icon: Icons.location_on_sharp),
            InfoList(title: "Longitude: $long", icon: Icons.location_on_sharp),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: Constants.PADDING, vertical: 2),
              child: Text(
                'All your offers will be published with this address. Other users will see the distance to this location.',
                style: StyleNormal.copyWith(
                  color: KColors.TEXT_COLOR_LIGHT,
                ),
                textAlign: TextAlign.center,
              ),
            ),
            SizedBox(height: 8),
            PrimaryButton(
              onClick: onUpdate,
              btnText: 'update address',
              bgColor: KColors.PRIMARY,
              textColor: Colors.white,
            )
          ],
        ),
      ),
    );
  }
}

class InfoList extends StatelessWidget {
  InfoList({required this.title, required this.icon});

  final String title;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Icon(
        icon,
        color: KColors.TEXT_COLOR,
      ),
      title: Text(
        title,
        style: StyleNormal.copyWith(color: KColors.TEXT_COLOR),
      ),
    );
  }
}
