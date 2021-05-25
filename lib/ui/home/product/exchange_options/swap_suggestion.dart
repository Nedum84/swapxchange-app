import 'package:flutter/material.dart';
import 'package:swapxchange/models/product_model.dart';
import 'package:swapxchange/ui/home/product/product_detail/product_detail.dart';
import 'package:swapxchange/ui/widgets/cached_image.dart';

class SwapSuggestion extends StatelessWidget {
  final Product suggestedProduct;
  final Product myProduct;
  final bool openProduct;
  SwapSuggestion({required this.suggestedProduct, required this.myProduct, this.openProduct = false});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 30),
      child: Row(
        children: [
          Column(
            children: [
              Container(
                height: 80,
                width: 80,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.all(Radius.circular(6)),
                ),
                child: CachedImage(
                  myProduct.images!.first.imagePath!,
                  fit: BoxFit.cover,
                  width: double.infinity,
                  height: double.infinity,
                  radius: 6,
                ),
              ),
              SizedBox(
                height: 4,
              ),
              Container(
                  width: 80,
                  child: Text(
                    myProduct.productName!,
                    style: TextStyle(color: Colors.black, fontSize: 13, fontWeight: FontWeight.bold),
                  )),
              SizedBox(
                height: 10,
              ),
            ],
          ),
          Expanded(
              child: Text(
            '- - -',
            textAlign: TextAlign.center,
          )),
          Icon(Icons.sync),
          Expanded(
              child: Text(
            '- - -',
            textAlign: TextAlign.center,
          )),
          Column(
            children: [
              GestureDetector(
                onTap: () {
                  if (openProduct)
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => ProductDetail(
                                  product: suggestedProduct,
                                )));
                },
                child: Container(
                  height: 80,
                  width: 80,
                  margin: EdgeInsets.symmetric(horizontal: 6),
                  child: Container(
                    height: double.infinity,
                    width: double.infinity,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.all(Radius.circular(6)),
                    ),
                    child: CachedImage(
                      ((suggestedProduct.images!.length != 0) ? suggestedProduct.images!.first.imagePath : '')!,
                      fit: BoxFit.cover,
                      width: double.infinity,
                      height: double.infinity,
                      radius: 6,
                    ),
                  ),
                ),
              ),
              SizedBox(
                height: 4,
              ),
              Container(
                  width: 80,
                  child: Text(
                    suggestedProduct.productName!,
                    style: TextStyle(color: Colors.black, fontSize: 13, fontWeight: FontWeight.bold),
                  )),
              SizedBox(
                height: 10,
              ),
            ],
          ),
        ],
      ),
    );
  }
}
