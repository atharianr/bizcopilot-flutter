import 'package:bizcopilot_flutter/style/color/biz_colors.dart';
import 'package:bizcopilot_flutter/style/typography/biz_text_styles.dart';
import 'package:flutter/material.dart';

import '../../../style/color/biz_colors.dart';
import '../widget/biz_text_input.dart';

import '../list_product/list_product.dart';

import '../../data/model/response/product_response.dart';
import 'package:bizcopilot_flutter/static/navigation/navigation_route.dart';

class ProductDetailBottomSheet extends StatelessWidget {
  final Products product;

  const ProductDetailBottomSheet({super.key, required this.product});

  @override
  Widget build(BuildContext context) {
    final primaryColor = BizColors.colorPrimary.getColor(context);
    final deleteColor = BizColors.colorGrey.getColor(context);

    return SingleChildScrollView(
      child: Padding(
        padding: EdgeInsetsGeometry.directional(start: 24, end: 24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 12),
            Align(
              alignment: Alignment.center,
              child: Container(
                margin: const EdgeInsets.only(top: 12, bottom: 16),
                height: 6,
                width: MediaQuery.of(context).size.width * 0.1,
                decoration: BoxDecoration(
                  color: Colors.grey.shade400,
                  borderRadius: BorderRadius.circular(12),
                ),
                alignment: Alignment.center,
              ),
            ),

            const SizedBox(height: 29),
            Container(
              decoration: BoxDecoration(
                boxShadow: [
                  BoxShadow(
                    color: const Color(0x26000000),
                    blurRadius: 4,
                    offset: Offset(0, 0),
                  ),
                ],
                borderRadius: BorderRadius.circular(16),
              ),
              clipBehavior: Clip.hardEdge,
              child: AspectRatio(
                aspectRatio: 16 / 9,
                child: Image.asset(
                  "assets/images/testlistimage.png",
                  fit: BoxFit.cover,
                ),
              ),
            ),
            const SizedBox(height: 15),

            Text(
              product.name ?? "",
              style: BizTextStyles.titleLargeBold.copyWith(
                color: BizColors.colorBlack.getColor(context),
              ),
            ),
            const SizedBox(height: 17),

            Text(
              product.description ?? "",
              style: BizTextStyles.labelMedium.copyWith(
                color: BizColors.colorBlack.getColor(context),
              ),
              textAlign: TextAlign.justify,
            ),

            const SizedBox(height: 17),

            Text(
              "Rp ${product.price.toString() ?? ""}",
              style: BizTextStyles.labelLargeBold.copyWith(
                color: BizColors.colorBlack.getColor(context),
              ),
            ),

            const SizedBox(height: 15),

            Row(
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Cost Price",
                      style: BizTextStyles.labelMedium.copyWith(
                        color: BizColors.colorBlack.getColor(context),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Text(
                      "Created At",
                      style: BizTextStyles.labelMedium.copyWith(
                        color: BizColors.colorBlack.getColor(context),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Text(
                      "Terjual",
                      style: BizTextStyles.labelMedium.copyWith(
                        color: BizColors.colorBlack.getColor(context),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Text(
                      "Stok",
                      style: BizTextStyles.labelMedium.copyWith(
                        color: BizColors.colorBlack.getColor(context),
                      ),
                    ),
                  ],
                ),
                const SizedBox(width: 6),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Rp ${product.costPrice.toString() ?? ""}",
                      style: BizTextStyles.labelLargeBold.copyWith(
                        color: BizColors.colorBlack.getColor(context),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Text(
                      product.createdAt ?? "",
                      style: BizTextStyles.labelMedium.copyWith(
                        color: BizColors.colorBlack.getColor(context),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Text(
                      "${product.soldCount} pcs",
                      style: BizTextStyles.labelMedium.copyWith(
                        color: BizColors.colorBlack.getColor(context),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Text(
                      "${product.inventory} pcs",
                      style: BizTextStyles.labelMedium.copyWith(
                        color: BizColors.colorBlack.getColor(context),
                      ),
                    ),
                  ],
                ),
              ],
            ),

            const SizedBox(height: 30),

            Row(
              children: [
                Expanded(
                  child: ElevatedButton(
                    style: ButtonStyle(
                      backgroundColor: WidgetStateProperty.all(deleteColor),
                    ),
                    onPressed: () {},
                    child: Text(
                      "Delete Product",
                      style: BizTextStyles.button.copyWith(
                        color: BizColors.colorWhite.getColor(context),
                      ),
                    ),
                  ),
                ),

                const SizedBox(width: 20),

                Expanded(
                  child: ElevatedButton(
                    style: ButtonStyle(
                      backgroundColor: WidgetStateProperty.all(primaryColor),
                    ),
                    onPressed: () {
                      Navigator.pushNamed(
                        context,
                        NavigationRoute.editProductRoute.name,
                        arguments: product,
                      );
                    },
                    child: Text(
                      "Edit Product",
                      style: BizTextStyles.button.copyWith(
                        color: BizColors.colorWhite.getColor(context),
                      ),
                    ),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 88),
          ],
        ),
      ),
    );
  }
}
