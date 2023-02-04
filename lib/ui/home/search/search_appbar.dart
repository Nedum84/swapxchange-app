import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:swapxchange/controllers/product_search_controller.dart';
import 'package:swapxchange/utils/colors.dart';

class SearchAppBar extends StatelessWidget {
  ProductSearchController searchController = ProductSearchController.to;

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
              // controller: TextEditingController()..text = searchController.queryString.value,
              controller: searchController.textController,
              focusNode: searchController.textFieldFocus,
              keyboardType: TextInputType.text,
              textInputAction: TextInputAction.search,
              onSubmitted: (str) {
                searchController.textFieldFocus.unfocus();
                searchController.hideSearchSuggestion(true);
                searchController.resetList(true);
                searchController.productList.clear();
                searchController.update();
                searchController.fetchProducts();
              },
              maxLines: 1,
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
              onChanged: (newString) => searchController.getSuggestions(),
            ),
          ),
          InkWell(
            onTap: () {
              searchController.productList.clear();
              searchController.resetList(true);
              searchController.fetchProducts();
            },
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
