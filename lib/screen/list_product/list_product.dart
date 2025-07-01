import 'package:bizcopilot_flutter/provider/daily_reports/daily_reports_provider.dart';
import 'package:bizcopilot_flutter/provider/daily_reports/home_widgets_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../style/color/biz_colors.dart';
import '../../../style/typography/biz_text_styles.dart';

import '../widget/gradient_button.dart';

class ListProduct extends StatefulWidget {
  const ListProduct({super.key});

  @override
  State<ListProduct> createState() => _ListProductState();
}

class _ListProductState extends State<ListProduct> {
    final tempData = [
        ProductModel(title: "Shibal Sekiya", 
        description: "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum.", 
        price: "Rp. 696969...", 
        image: "assets/images/testlistimage.png"),
        ProductModel(title: "Shibal Sekiya", 
        description: "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum.", 
        price: "Rp. 696969...", 
        image: "assets/images/testlistimage.png"),
        ProductModel(title: "Shibal Sekiya", 
        description: "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum.", 
        price: "Rp. 696969...", 
        image: "assets/images/testlistimage.png")
    ];

  @override
  Widget build(BuildContext context) {
    final double statusBarHeight = MediaQuery.of(context).padding.top;

    return Scaffold(
        body: Padding(
          padding: EdgeInsets.only(top: statusBarHeight + 24, left: 24, right: 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start, 
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "List Product",
                    style: BizTextStyles.titleLargeBold.copyWith(
                      color: BizColors.colorText.getColor(context),
                      fontSize: 24,
                    ),
                  ),
                  GradientButton(
                    label: 'Add Product',
                    icon: Icons.add,
                    borderRadius: BorderRadiusGeometry.all(Radius.circular(8)),
                    padding: EdgeInsetsGeometry.all(8),
                    gradient: LinearGradient(
                      colors: [BizColors.colorPrimary.getColor(context), BizColors.colorPrimaryDark.getColor(context)],
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: const Color(0x26000000),
                        blurRadius: 4,
                        offset: Offset(0, 0),
                      ),
                    ],
                    onPressed: () => print('Share tapped'),
                  ),
                ],
              ),
              SizedBox(height: 16),
              Expanded(child: MediaQuery.removePadding(context: context, removeTop: true, child: _listProductView())),
            ],
          )
        ),
    );
  }

Widget _listProductView() {
    return ListView.builder(
        itemCount: tempData.length,
        itemBuilder: (context, index) {
          double spacePadding = 21.0;
          if (index == tempData.length - 1) {
            spacePadding = 0.0;
          }
            final itemData = tempData[index];
            return ListProductCell(product: itemData, spacePadding: spacePadding);
        }
    );
  }
}

class ListProductCell extends StatelessWidget {
    final ProductModel product;
    final double spacePadding;

    const ListProductCell({required this.product, required this.spacePadding, super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: EdgeInsets.only(bottom: spacePadding),
        child: Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: const Color(0x26000000),
                  blurRadius: 4,
                  offset: const Offset(0, 0),
                ),
              ]
            ),
            child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                    ClipRRect(
                        borderRadius: BorderRadius.circular(8),
                        child: Image.asset(
                            product.image,
                            width: 100,
                            height: 100,
                            fit: BoxFit.fill,
                        )
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: 
                        Column(crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text("${product.title}",
                              style: BizTextStyles.titleMediumBold.copyWith(
                                  color: BizColors.colorText.getColor(context),
                              ),
                          ),
                          const SizedBox(height: 4),
                          Text("${product.description}",
                              overflow: TextOverflow.ellipsis,
                              maxLines: 3,
                              textAlign: TextAlign.justify,
                              style: BizTextStyles.titleSmall.copyWith(
                                  color: BizColors.colorText.getColor(context),
                              ),
                          ),
                          const SizedBox(height: 18),
                          Text("${product.price}",
                              style: BizTextStyles.titleSmallBold.copyWith(
                                  color: BizColors.colorText.getColor(context),
                              ),
                          ),
                        ],
                      )
                    )
                ],
            ),
        )
    );
  }
}

class ProductModel {
  final String title;
  final String description;
  final String price;
  final String image;

  ProductModel({
    required this.title,
    required this.description,
    required this.price,
    required this.image,
  });
}