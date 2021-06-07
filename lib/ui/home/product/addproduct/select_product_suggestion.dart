import 'package:flutter/material.dart';
import 'package:swapxchange/controllers/add_product_controller.dart';
import 'package:swapxchange/controllers/category_controller.dart';
import 'package:swapxchange/models/category_model.dart';
import 'package:swapxchange/utils/colors.dart';

class SelectProductSuggestion extends StatefulWidget {
  final List<Category> productSuggestions;
  final Function(List<Category>) updatedSuggestions;

  SelectProductSuggestion({required this.productSuggestions, required this.updatedSuggestions});

  @override
  _SelectProductSuggestionState createState() => _SelectProductSuggestionState();
}

class _SelectProductSuggestionState extends State<SelectProductSuggestion> {
  final addController = AddProductController.to;
  late List<Category> _productSuggestions;

  @override
  void initState() {
    super.initState();
    _productSuggestions = widget.productSuggestions;
  }

  _updateSuggestions(category) {
    bool isSelected = _productSuggestions.indexWhere((element) => element.categoryId == category.categoryId) != -1;
    if (isSelected) {
      setState(() {
        _productSuggestions.removeWhere((element) => element.categoryId == category.categoryId);
      });
    } else {
      setState(() {
        _productSuggestions.add(category);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        widget.updatedSuggestions(_productSuggestions);
        return true;
      },
      child: Container(
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
                    onPressed: () => widget.updatedSuggestions(_productSuggestions),
                    icon: Icon(
                      Icons.close,
                      color: Colors.grey,
                    ),
                  ),
                ),
                title: Text(
                  'Your Interest',
                  style: TextStyle(fontSize: 18),
                ),
                subtitle: Text('What would you like to exchange your product for?'),
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

                    bool isSelected = _productSuggestions.indexWhere((element) => element.categoryId == cat.categoryId) != -1;

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
                        onTap: () => _updateSuggestions(cat),
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
                          child: Icon(Icons.check, color: (isSelected) ? Colors.black : Colors.transparent),
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
                child: GestureDetector(
                  onTap: () => widget.updatedSuggestions(_productSuggestions),
                  child: Container(
                    width: double.infinity,
                    padding: EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.all(Radius.circular(12.00)),
                      color: KColors.PRIMARY,
                    ),
                    child: Text(
                      'DONE',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 18,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
