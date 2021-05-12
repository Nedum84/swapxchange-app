import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:swapxchange/utils/colors.dart';

class SearchAppBar extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Row(
        children: [
          InkWell(
            onTap: () => Get.back(),
            child: Icon(
              Icons.arrow_back_ios_outlined,
              color: KColors.TEXT_COLOR,
            ),
          ),
          Expanded(
            child: TextField(
              // controller: phoneNumberController,
              // focusNode: textFieldFocusPhone,
              keyboardType: TextInputType.text,
              maxLines: 1,
              autofocus: true,
              style: TextStyle(
                color: KColors.TEXT_COLOR,
                fontWeight: FontWeight.w600,
              ),
              cursorColor: KColors.TEXT_COLOR,
              decoration: InputDecoration(
                counterText: '',
                hintText: 'Search here...',
                floatingLabelBehavior: FloatingLabelBehavior.never,
                hintStyle: TextStyle(
                  color: KColors.TEXT_COLOR,
                  fontWeight: FontWeight.w500,
                ),
                border: InputBorder.none,
                focusedBorder: InputBorder.none,
                enabledBorder: InputBorder.none,
                errorBorder: InputBorder.none,
                disabledBorder: InputBorder.none,
                contentPadding: EdgeInsets.all(0).copyWith(left: 16),
              ),
            ),
          ),
          InkWell(
            child: Icon(
              Icons.search,
              color: KColors.TEXT_COLOR,
              size: 30,
            ),
          )
        ],
      ),
    );
  }
}
