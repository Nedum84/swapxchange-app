import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:swapxchange/controllers/product_search_controller.dart';
import 'package:swapxchange/utils/styles.dart';

class SuggestionsContainer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Positioned(
      top: 0,
      left: 0,
      right: 0,
      child: GetBuilder<ProductSearchController>(
        autoRemove: false,
        init: ProductSearchController(),
        builder: (searchController) {
          if (searchController.hideSearchSuggestion.value) return Container();
          return ConstrainedBox(
            constraints: BoxConstraints(maxHeight: 100),
            child: (searchController.searchSuggestions.isEmpty)
                ? Container()
                : Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      border: Border.all(color: Colors.black26.withOpacity(.1)),
                    ),
                    child: ListView.separated(
                      padding: EdgeInsets.zero,
                      itemCount: searchController.searchSuggestions.length,
                      physics: BouncingScrollPhysics(),
                      itemBuilder: (context, index) {
                        final item = searchController.searchSuggestions[index];
                        return InkWell(
                          onTap: () {
                            searchController.textFieldFocus.unfocus();
                            searchController.hideSearchSuggestion(true);
                            searchController.textController.text = item;
                            searchController.setQueryString(item);
                            searchController.resetList(true);
                            searchController.update();
                            searchController.fetchProducts();
                          },
                          child: Container(
                            padding: EdgeInsets.symmetric(vertical: 4, horizontal: 4),
                            child: Text(
                              item,
                              style: StyleNormal.copyWith(fontSize: 12),
                            ),
                          ),
                        );
                      },
                      separatorBuilder: (BuildContext context, int index) => Divider(color: Colors.black26),
                    ),
                  ),
          );
        },
      ),
    );
  }
}
