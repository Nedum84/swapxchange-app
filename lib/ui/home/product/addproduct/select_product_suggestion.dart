import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:swapxchange/controllers/add_product_controller.dart';
import 'package:swapxchange/controllers/category_controller.dart';
import 'package:swapxchange/ui/components/custom_button.dart';
import 'package:swapxchange/ui/home/product/addproduct/widgets/bottomsheet_container.dart';
import 'package:swapxchange/utils/colors.dart';

class SelectProductSuggestion extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return GetBuilder<AddProductController>(builder: (addController) {
      return BottomSheetContainer(
        title: 'Your Interest',
        subtitle: 'What would you like to exchange your product for?',
        child: Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              Expanded(
                child: ListView.builder(
                  itemCount: CategoryController.to.categoryList.length,
                  itemBuilder: (context, index) {
                    final cat = CategoryController.to.categoryList[index];

                    bool isSelected = addController.suggestions.indexWhere((element) => element.categoryId == cat.categoryId) != -1;

                    return Container(
                      margin: EdgeInsets.only(bottom: 16),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.all(Radius.circular(12)),
                        border: Border.all(
                          width: 2,
                          color: (isSelected) ? KColors.PRIMARY : Colors.blueGrey.withOpacity(.2),
                        ),
                      ),
                      child: ListTile(
                        onTap: () => addController.updateSuggestions(cat),
                        title: Text(cat.categoryName ?? ""),
                        leading: Container(
                          padding: EdgeInsets.all(1),
                          decoration: BoxDecoration(
                              color: (isSelected) ? KColors.PRIMARY : Colors.transparent,
                              border: Border.all(
                                color: (isSelected) ? KColors.PRIMARY : Colors.blueGrey.withOpacity(.2),
                                width: 2,
                              ),
                              borderRadius: BorderRadius.all(Radius.circular(20))),
                          child: Icon(Icons.check, color: (isSelected) ? Colors.white : Colors.transparent),
                        ),
                      ),
                    );
                  },
                ),
              ),
              SizedBox(
                height: 10,
              ),
              Center(
                child: PrimaryButton(
                  onClick: () => Get.back(),
                  btnText: 'DONE',
                ),
              ),
            ],
          ),
        ),
      );
    });
  }
}
