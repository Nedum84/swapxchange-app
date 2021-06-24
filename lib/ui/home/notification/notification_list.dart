import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:swapxchange/controllers/user_controller.dart';
import 'package:swapxchange/models/notification_model.dart';
import 'package:swapxchange/repository/notification_repo.dart';
import 'package:swapxchange/repository/repo_product.dart';
import 'package:swapxchange/ui/home/product/product_detail/product_detail.dart';
import 'package:swapxchange/ui/widgets/custom_button.dart';
import 'package:swapxchange/utils/colors.dart';
import 'package:swapxchange/utils/styles.dart';

class NotificationList extends StatelessWidget {
  onClick(NotificationModel item) async {
    if (item.data!.type == NotificationType.PRODUCT) {
      final product = await RepoProduct.getById(productId: int.parse(item.data!.id!));
      if (product != null) {
        NotificationRepo.markAsRead(docId: item.docId!);
        Get.to(() => ProductDetail(product: product));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: KColors.WHITE_GREY,
      appBar: AppBar(
        backgroundColor: Colors.white,
        shadowColor: Colors.transparent,
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back_ios,
            color: KColors.TEXT_COLOR_DARK,
          ),
          onPressed: () => Get.back(),
        ),
        title: Text(
          'Notifications',
          style: H1Style,
        ),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: NotificationRepo.getMyNotifications(myId: UserController.to.user!.userId!),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return Center(child: CircularProgressIndicator());
          }
          final data = snapshot.data!.docs;
          if (data.length == 0) {
            return Center(child: Text('No notification yet'));
          }

          var items = (data).map((data) => NotificationModel.fromMap({...data.data(), "doc_id": data.id})).toList();

          return ListView.separated(
            padding: EdgeInsets.all(16),
            itemCount: items.length,
            itemBuilder: (context, index) {
              final item = items[index];
              return Container(
                color: Colors.white70,
                padding: EdgeInsets.symmetric(horizontal: 6, vertical: 8),
                child: ListTile(
                  onTap: () => onClick(item),
                  title: Text(
                    "${item.notification!.title}",
                    style: StyleNormal.copyWith(
                      color: KColors.TEXT_COLOR_DARK,
                      fontSize: 16,
                    ),
                  ),
                  subtitle: Text(
                    "${item.notification!.body}",
                    style: StyleNormal,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  trailing: item.isRead!
                      ? Icon(
                          Icons.arrow_forward_ios,
                          color: KColors.TEXT_COLOR,
                        )
                      : ButtonSmall(
                          bgColor: KColors.PRIMARY,
                          textColor: Colors.white,
                          text: 'New',
                          onClick: () => null,
                        ),
                ),
              );
            },
            separatorBuilder: (BuildContext context, int index) => SizedBox(height: 8),
          );
        },
      ),
    );
  }
}
