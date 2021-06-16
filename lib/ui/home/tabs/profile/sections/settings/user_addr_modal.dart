import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:location_tracker/model/map_point.dart';
import 'package:location_tracker/utils/colors.dart';
import 'package:location_tracker/utils/widgets/show_direction.dart';


class ModalUserInfo extends StatelessWidget {
  ModalUserInfo({this.name, this.email, this.from_address, this.to_address, this.start_point, this.destination_point, this.status});

  final String name;
  final String email;
  final String from_address;
  final String to_address;
  final MapPoint start_point;
  final MapPoint destination_point;
  final String status;//start or destination

  @override
  Widget build(BuildContext context) {
    return Container(
      // height: MediaQuery.of(context).size.height,
      decoration: BoxDecoration(
        color: kColorWhite,
      ),
      child: Column(
        children: [
          Container(
            width: MediaQuery.of(context).size.width,
            padding: EdgeInsets.symmetric(vertical: 14, horizontal: 12),
            decoration: BoxDecoration(
                color: kColorPrimary
            ),
            child: Column(
              children: [
                Text(
                  name,
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 25,
                      fontWeight: FontWeight.bold
                  ),
                ),
                Text(
                    from_address,
                    style: TextStyle(
                      color: Colors.white,
                    )
                )

              ],
            ),
          ),
          InfoList(title: status, icon: Icons.car_rental),
          InfoList(title: from_address, icon: Icons.location_on_sharp),
          InfoList(title: "${start_point.latitude.toStringAsFixed(3)}, ${start_point.longitude.toStringAsFixed(3)}", icon: Icons.local_florist_outlined),
          InfoList(title: "Available", icon: Icons.where_to_vote),
          Container(
            width: 200,
            margin: EdgeInsets.only(top: 12),
            decoration: BoxDecoration(
              color: kColorPrimary,
              border: Border.all(width: 1, color: Colors.transparent),
              borderRadius: BorderRadius.all(Radius.circular(30)),
            ),
            child: MaterialButton(
              onPressed: () {
                showModalBottomSheet(context: context, isScrollControlled: true, builder: (BuildContext bCtx){
                  return ShowDirection(
                    from_address: from_address,
                    to_address: to_address,
                    start_point: start_point,
                    destination_point: destination_point,
                  );
                });
              },
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.view_day, color: kColorWhite,),
                  SizedBox(width: 5,),
                  Text(
                    "SHOW DIRECTION",
                    style: TextStyle(
                        color: kColorWhite
                    ),
                  ),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}

class InfoList extends StatelessWidget {
  InfoList({@required this.title, @required this.icon});

  final String title;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Icon(
        icon,
        color: kColorPrimaryDark,
        size: 20,
      ),
      title: Text(
        title,
        style: TextStyle(
            color: kColorPrimaryDark
        ),
      ),
    );
  }
}