import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:swapxchange/controllers/product_controller.dart';
import 'package:swapxchange/models/product_model2.dart';
import 'package:swapxchange/ui/components/loading_overlay.dart';

class SplashScreen extends StatelessWidget {
  // without the binding
  // final ProductController countController = Get.put(ProductController());
  final ProductController productController = Get.find<ProductController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Splash'),
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios),
          onPressed: () => Get.back(),
        ),
      ),
      body: Center(
        child: Column(
          children: [
            Expanded(
              child: GetX<ProductController>(
                builder: (controller) {
                  return LoadingOverlay(
                    isLoading: controller.isLoading.value,
                    child: ListView.builder(
                      itemCount: controller.productList.length,
                      itemBuilder: (context, index) => PostsListItem(
                        key: ValueKey(controller.productList[index]),
                        product: controller.productList[index],
                        index: index,
                      ),
                    ),
                  );
                },
              ),
            ),
            GetX<ProductController>(
              // init:
              //     ProductController(), // can initialize inside GetX instead of .put
              builder: (controller) => Text('Increment: ${controller.inc}'),
            ),
            Obx(
              //Obx is very similar to GetX except 'lighter' so no parameters for init, dispose, etc
              () => Text('Loading: ${Get.find<ProductController>().isLoading.value}'),
            ),
            RaisedButton(
              child: Text("Inc Count1"),
              onPressed: () {
                Get.find<ProductController>().increment(); //using Get.find locates the controller that was created in 'init' in GetX
              },
            ),
            RaisedButton(
              child: Text("Fetch Again"),
              onPressed: () {
                productController.fetchProducts();
              },
            ),
            Obx(() => Text('Inc Val: ${productController.inc}')),
            SizedBox(
              height: 20,
            ),
          ],
        ),
      ),
    );
  }
}

class PostsListItem extends StatelessWidget {
  // Product product = Get.find<Product>();
  final Product2 product;
  final int index;

  const PostsListItem({Key? key, required this.product, required this.index}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Dismissible(
      key: UniqueKey(),
      onDismissed: (direction) {
        print(direction);
      },
      child: InkWell(
        // onTap: () => product.updateProduct(),
        onTap: () => Get.find<ProductController>().updateProduct(index, product),
        // child: GetBuilder<Product>(
        //     // stream: null,
        //     builder: (pro) {
        child: Container(
          padding: EdgeInsets.all(24),
          child: Text(
            '${product.id} - ${product.title}',
            style: TextStyle(fontSize: 18),
          ),
        ),
        // )
        // }),
      ),
    );
  }
}
