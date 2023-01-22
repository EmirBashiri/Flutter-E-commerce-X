import 'package:flutter/cupertino.dart';
import 'package:flutter_application_ecommerce/Model/GetX/Controller/duplicate_controller.dart';
import 'package:flutter_application_ecommerce/Model/Tools/JsonParse/product_parse.dart';
import 'package:flutter_application_ecommerce/Model/Widget/widget.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:get/get.dart';

class OrderDetailScreen extends StatelessWidget {
  const OrderDetailScreen({super.key, required this.productList});
  final List<ProductEntity> productList;
  @override
  Widget build(BuildContext context) {
    final duplicateController = Get.find<DuplicateController>();
    final colors = duplicateController.colors;
    final textStyle = duplicateController.textStyle;

    return DuplicateTemplate(
      colors: colors,
      textStyle: textStyle,
      title: "Order detail",
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            height: Get.height * 0.8,
            margin:
                const EdgeInsets.only(top: 12, right: 15, bottom: 12, left: 15),
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
                color: colors.gray, borderRadius: BorderRadius.circular(15)),
            child: AlignedGridView.count(
              physics: duplicateController.uiDuplicate.defaultScroll,
              crossAxisCount: 2,
              mainAxisSpacing: 5,
              crossAxisSpacing: 10,
              itemCount: productList.length,
              itemBuilder: (context, index) {
                final product = productList[index];
                return Container(
                  height: 250,
                  decoration: BoxDecoration(
                      color: colors.whiteColor,
                      borderRadius: BorderRadius.circular(15)),
                  child: Column(
                    children: [
                      Container(
                          margin: const EdgeInsets.only(top: 10, bottom: 10),
                          width: 130,
                          child: networkImage(imageUrl: product.imageUrl)),
                      Column(
                        children: [
                          Text(
                            product.name,
                            style: textStyle.bodyNormal,
                            maxLines: 1,
                            overflow: TextOverflow.clip,
                            textAlign: TextAlign.center,
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          Text(
                            "€${product.price}",
                            style: textStyle.bodyNormal,
                          ),
                        ],
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
