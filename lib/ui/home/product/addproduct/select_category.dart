import 'package:flutter/material.dart';
import 'package:swapxchange/controllers/add_product_controller.dart';
import 'package:swapxchange/controllers/category_controller.dart';

class SelectCategory extends StatelessWidget {
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
              title: Text('Select Category'),
            ),
            Divider(
              thickness: 1,
              color: Colors.blueGrey.withOpacity(.2),
            ),
            Expanded(
              child: ListView.builder(
                itemCount: CategoryController.to.categoryList.length,
                itemBuilder: (context, index) {
                  final cat = CategoryController.to.categoryList[index];

                  return ListTile(
                    onTap: () {
                      final product = addController.product;
                      product.value.category = cat.categoryId;
                      addController.category(cat);
                      addController.updateProduct(product.value);
                    },
                    leading: Icon(Icons.category),
                    title: Text(cat.categoryName ?? ""),
                  );
                },
              ),
            )
          ],
        ),
      ),
    );
  }
}
