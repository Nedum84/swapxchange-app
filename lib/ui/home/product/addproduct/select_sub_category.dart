import 'package:flutter/material.dart';
import 'package:swapxchange/controllers/add_product_controller.dart';
import 'package:swapxchange/controllers/sub_category_controller.dart';
import 'package:swapxchange/models/sub_category_model.dart';
import 'package:swapxchange/utils/styles.dart';

class SelectSubCategory extends StatelessWidget {
  final addController = AddProductController.to;

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Color(0xff757575),
      child: Container(
        height: MediaQuery.of(context).size.height - 60,
        padding: EdgeInsets.all(12.0),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(20.0),
            topRight: Radius.circular(20.0),
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            ListTile(
              trailing: CircleAvatar(
                backgroundColor: Colors.blueGrey.withOpacity(.1),
                radius: 16,
                child: IconButton(
                  iconSize: 14,
                  onPressed: () => Navigator.pop(context),
                  icon: Icon(
                    Icons.close,
                    color: Colors.grey,
                  ),
                ),
              ),
              title: Text(addController.category.value.categoryName ?? ""),
              subtitle: Text('Select sub category'),
            ),
            Divider(
              thickness: 1,
              color: Colors.blueGrey.withOpacity(.2),
            ),
            Expanded(
              child: FutureBuilder(
                future: SubCategoryController.to.fetchByCategoryId(catId: addController.category.value.categoryId!),
                builder: (BuildContext context, AsyncSnapshot<List<SubCategory>> snapshot) {
                  if (snapshot.hasData) {
                    if (snapshot.data!.isEmpty || snapshot.data!.length == 0) {
                      return Center(
                        child: Text(
                          'No category found',
                          style: StyleNormal.copyWith(fontSize: 18),
                        ),
                      );
                    }
                    var subCats = snapshot.data;

                    return ListView.builder(
                      itemCount: subCats!.length,
                      itemBuilder: (context, index) {
                        final subCat = subCats[index];

                        return ListTile(
                          onTap: () {
                            final product = addController.product;
                            product.value.subCategory = subCat.subCategoryId;
                            addController.subCategory(subCat);
                          },
                          leading: Icon(Icons.category),
                          title: Text(subCat.subCategoryName ?? ""),
                        );
                      },
                    );
                  }
                  return Center(child: CircularProgressIndicator());
                },
              ),
            )
          ],
        ),
      ),
    );
  }
}
