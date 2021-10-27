import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:swapxchange/controllers/saved_product_controller.dart';
import 'package:swapxchange/models/product_model.dart';
import 'package:swapxchange/repository/repo_saved_products.dart';

class SaveBtn extends StatefulWidget {
  final Product product;

  const SaveBtn({Key? key, required this.product}) : super(key: key);
  @override
  _SaveBtnState createState() => _SaveBtnState();
}

class _SaveBtnState extends State<SaveBtn> {
  bool isSaved = false;

  @override
  void initState() {
    super.initState();
    _checkSaved();
  }

  _checkSaved() async {
    final checkIsSaved = await RepoSavedProducts.checkSaved(productId: widget.product.productId!);
    setState(() => isSaved = checkIsSaved);
  }

  _toggleSaved() async {
    if (isSaved) {
      final unSave = await RepoSavedProducts.removeSaved(productId: widget.product.productId!);
      if (unSave) {
        setState(() => isSaved = false);
      }
    } else {
      final savedProduct = await RepoSavedProducts.savedProduct(productId: widget.product.productId!);

      if (savedProduct) {
        setState(() => isSaved = true);
      }
    }
    //refresh
    SavedProductController.to.fetchAll(reset: true);
  }

  @override
  Widget build(BuildContext context) {
    return Positioned(
      top: context.mediaQueryPadding.top,
      right: context.mediaQueryPadding.left + 4,
      child: CircleAvatar(
        backgroundColor: Color.fromRGBO(0, 0, 0, 0.0),
        child: IconButton(
          onPressed: _toggleSaved,
          icon: Icon(
            Icons.favorite,
            color: isSaved ? Colors.white : Colors.white30,
          ),
        ),
      ),
    );
  }
}
