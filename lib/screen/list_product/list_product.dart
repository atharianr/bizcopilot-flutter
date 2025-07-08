import 'package:bizcopilot_flutter/extension/List+Extensions.dart';
import 'package:bizcopilot_flutter/provider/daily_reports/daily_reports_provider.dart';
import 'package:bizcopilot_flutter/provider/daily_reports/home_widgets_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../style/color/biz_colors.dart';
import '../../../style/typography/biz_text_styles.dart';

import '../../static/navigation/navigation_route.dart';
import '../widget/gradient_button.dart';
// import '../product_detail/product_detail_bottom_sheet.dart';

// Provider
import '../../provider/list_product/list_product_provider.dart';

// State
import '../../static/state/list_product_result_state.dart';

// Model
import '../../data/model/response/product_response.dart';

class ListProduct extends StatefulWidget {
  const ListProduct({super.key});

  @override
  State<ListProduct> createState() => _ListProductState();
}

class _ListProductState extends State<ListProduct> {

    void initState() {
      super.initState();
      WidgetsBinding.instance.addPostFrameCallback((_) {
        final productProvider = Provider.of<ListProductProvider>(
          context,
          listen: false,
        ).getAllListProducts();
      });
    }

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
                    onPressed: () {
                      Navigator.pushNamed(
                        context,
                        NavigationRoute.addProductRoute.name,
                      );
                    },
                  ),
                ],
              ),
              SizedBox(height: 16),
              InkWell(
                onTap: () async {
                  final SortingType? selectedSorting = await showModalBottomSheet(
                    context: context, 
                    isScrollControlled: true,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(16))),
                    builder: (context) => FilterProductSheet()
                  );
                  if (selectedSorting != null) {
                    final productProvider = Provider.of<ListProductProvider>(context, listen: false);
                    productProvider.sortProducts(type: selectedSorting, order: SortingOrder.ascending);
                  }
                },
                child: Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(8),
                    boxShadow: [
                      BoxShadow(
                        color: const Color(0x26000000),
                        blurRadius: 4,
                        offset: const Offset(0, 0),
                      ),
                    ]
                  ),
                  child: Icon(Icons.sort),
                )
              ),
              SizedBox(height: 8),
              Consumer<ListProductProvider>(builder: (context, value, child) {
                switch (value.resultState) {
                  case ListProductLoadingState(): 
                    return const CircularProgressIndicator();
                  case ListProductLoadedState(data: var data):
                    final products = context.read<ListProductProvider>().sortedAllProducts;
                    return Expanded(child: MediaQuery.removePadding(context: context, removeTop: true, child: _listProductView(products)));
                  case ListProductErrorState(error: var message): 
                    return Text(message);
                  default:
                    return const SizedBox();
                };
              },),
            ],
          )
        ),
    );
  }

Widget _listProductView(List<Products> allProducts) {
    
    return ListView.builder(
        itemCount: allProducts.length,
        itemBuilder: (context, index) {
          double spacePadding = 21.0;
          if (index == allProducts.length - 1) {
            spacePadding = 0.0;
          }
            final itemData = allProducts[index];
            return ListProductCell(
              product: itemData, 
              spacePadding: spacePadding, 
              onPressed: () {
                // showModalBottomSheet<dynamic>(
                //   context: context,
                //   isScrollControlled: true,
                //   shape: RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(16))),
                //   builder: (context) => ProductDetailBottomSheet(product: itemData)
                // );
              },
            );
        }
    );
  }
}

class ListProductCell extends StatelessWidget {
  final Products product;
  final double spacePadding;
  final VoidCallback onPressed;


  const ListProductCell({required this.product, required this.spacePadding, required this.onPressed, super.key});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPressed,
      child: Padding(
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
                            "assets/images/testlistimage.png",
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
                          Text("${product.name}",
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
      ),
    );
  }
}

class FilterProductSheet extends StatefulWidget {
  const FilterProductSheet({super.key});

  @override
  State<FilterProductSheet> createState() => _ProductFilterState();
}

enum SortingType { nothing, name, price, time, stock }
enum SortingOrder { ascending, descending } 

class _ProductFilterState extends State<FilterProductSheet> {
  SortingType? _character = SortingType.nothing;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: EdgeInsetsGeometry.directional(start: 24, end: 24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text("Sort Data"),
            ListTile(
              title: const Text('Nothing'),
              leading: Radio<SortingType>(
                value: SortingType.nothing,
                groupValue: _character,
                onChanged: (SortingType? value) {
                  setState(() {
                    _character = value;
                  });
                },
              ),
            ),
            ListTile(
              title: const Text('Name'),
              leading: Radio<SortingType>(
                value: SortingType.stock,
                groupValue: _character,
                onChanged: (SortingType? value) {
                  setState(() {
                    _character = value;
                  });
                },
              ),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context, _character);
              },
              child: const Text("Apply Sorting"),
            )
          ],
        ),
      )
    );
  }
}