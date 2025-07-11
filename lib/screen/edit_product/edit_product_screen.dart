import 'package:bizcopilot_flutter/static/state/add_product_result_state.dart';
import 'package:bizcopilot_flutter/style/typography/biz_text_styles.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

import '../../data/model/request/product_request_model.dart';

import '../../../style/color/biz_colors.dart';
import '../widget/biz_text_input.dart';
import '../../data/model/response/product_response.dart';

import 'package:bizcopilot_flutter/provider/list_product/add_product_provider.dart';

class EditProductScreen extends StatefulWidget {
  final Products product;

  const EditProductScreen({super.key, required this.product});

  @override
  State<EditProductScreen> createState() => _EditProductScreenState();
}

class _EditProductScreenState extends State<EditProductScreen> {
  late TextEditingController nameController;
  late TextEditingController descriptionController;
  late TextEditingController stockController;
  late TextEditingController costPriceController;
  late TextEditingController priceController;

  String? nameError;
  String? descriptionError;
  String? stockError;
  String? costPriceError;
  String? priceError;

  @override
  void initState() {
    super.initState();
    nameController = TextEditingController(text: widget.product.name);
    descriptionController = TextEditingController(text: widget.product.description);
    stockController = TextEditingController(text: widget.product.inventory.toString());
    costPriceController = TextEditingController(text: widget.product.costPrice.toString());
    priceController = TextEditingController(text: widget.product.price.toString());
  }

  @override
  void dispose() {
    nameController.dispose();
    descriptionController.dispose();
    stockController.dispose();
    costPriceController.dispose();
    priceController.dispose();
    super.dispose();
  }

  bool validateInputs() {
    bool isValid = true;
    setState(() {
      nameError = null;
      descriptionError = null;
      stockError = null;
      costPriceError = null;
      priceError = null;

      if (nameController.text.isEmpty) {
        nameError = "Product name is required";
        isValid = false;
      }
      if (descriptionController.text.isEmpty) {
        descriptionError = "Description is required";
        isValid = false;
      }
      if (stockController.text.isEmpty) {
        stockError = "Stock is required";
        isValid = false;
      } else if (int.tryParse(stockController.text) == null) {
        stockError = "Stock must be a valid number";
        isValid = false;
      }
      if (costPriceController.text.isEmpty) {
        costPriceError = "Cost price is required";
        isValid = false;
      } else if (double.tryParse(costPriceController.text) == null) {
        costPriceError = "Cost price must be a valid number";
        isValid = false;
      }
      if (priceController.text.isEmpty) {
        priceError = "Price is required";
        isValid = false;
      } else if (double.tryParse(priceController.text) == null) {
        priceError = "Price must be a valid number";
        isValid = false;
      }
    });
    return isValid;
  }

  @override
  Widget build(BuildContext context) {
    final primaryColor = BizColors.colorPrimary.getColor(context);
    final blackColor = BizColors.colorBlack.getColor(context);

    return Scaffold(
      appBar: AppBar(
        titleSpacing: 0,
        automaticallyImplyLeading: false,
        title: Row(
          children: [
            IconButton(
              icon: const Icon(Icons.arrow_back),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
            const SizedBox(width: 4),
            const Text("Edit Product"),
          ],
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Product Name",
                style: BizTextStyles.bodyLargeMedium.copyWith(
                  color: blackColor,
                ),
              ),
              const SizedBox(height: 8),
              BizTextInput(
                hintText: "Name",
                controller: nameController,
                errorText: nameError,
              ),
              const SizedBox(height: 12),

              Text(
                "Description",
                style: BizTextStyles.bodyLargeMedium.copyWith(
                  color: blackColor,
                ),
              ),
              const SizedBox(height: 8),
              BizTextInput(
                hintText: "Description",
                controller: descriptionController,
                maxLines: 4,
                scrollPadding: const EdgeInsets.all(20),
                errorText: descriptionError,
              ),
              const SizedBox(height: 12),

              Text(
                "Stock",
                style: BizTextStyles.bodyLargeMedium.copyWith(
                  color: blackColor,
                ),
              ),
              const SizedBox(height: 8),
              BizTextInput(
                hintText: "Stock",
                controller: stockController,
                keyboardType: TextInputType.number,
                inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                errorText: stockError,
              ),
              const SizedBox(height: 12),

              Text(
                "Cost Price",
                style: BizTextStyles.bodyLargeMedium.copyWith(
                  color: blackColor,
                ),
              ),
              const SizedBox(height: 8),
              BizTextInput(
                hintText: "Cost Price",
                controller: costPriceController,
                keyboardType: const TextInputType.numberWithOptions(
                  decimal: true,
                ),
                errorText: costPriceError,
              ),
              const SizedBox(height: 12),

              Text(
                "Price",
                style: BizTextStyles.bodyLargeMedium.copyWith(
                  color: blackColor,
                ),
              ),
              const SizedBox(height: 8),
              BizTextInput(
                hintText: "Price",
                controller: priceController,
                keyboardType: const TextInputType.numberWithOptions(
                  decimal: true,
                ),
                errorText: priceError,
              ),
              const SizedBox(height: 20),

              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  style: ButtonStyle(
                    backgroundColor: WidgetStateProperty.all(primaryColor),
                  ),
                  onPressed: () {
                    if (validateInputs()) {
                      final name = nameController.text.trim();
                      final description = descriptionController.text.trim();
                      final stock = int.parse(stockController.text.trim());
                      final costPrice = int.parse(
                        costPriceController.text.trim(),
                      );
                      final price = int.parse(priceController.text.trim());

                      // TODO: Handle save logic
                      // print("Product Added:");
                      // print("Name: $name");
                      // print("Description: $description");
                      // print("Stock: $stock");
                      // print("Cost Price: $costPrice");
                      // print("Price: $price");
                      

                      // Provider.of<EditProductProvider>(context, listen: false)
                      //     .setReportModel = ProductRequestModel(
                      //       name: name,
                      //       description: description,
                      //       inventory: stock,
                      //       costPrice: costPrice,
                      //       price: price,
                      //     );

                      // Provider.of<EditProductProvider>(context, listen: false).EditProduct();

                      // Consumer<EditProductProvider>(builder: (context, value, child) {
                      //   return switch (value.resultState) {
                      //     EditProductLoadingState() => const Center(child: CircularProgressIndicator()),
                      //     EditProductLoadedState(data: var data) => Builder(builder: (context) {
                      //       ScaffoldMessenger.of(context).showSnackBar(
                      //           const SnackBar(content: Text("Product Edited Successfully")),
                      //       );
                      //       Navigator.pop(context);
                      //       return const SizedBox.shrink();
                      //     }),
                      //     EditProductErrorState(error: var message) => Builder(builder: (context) {
                      //       ScaffoldMessenger.of(context).showSnackBar(
                      //           SnackBar(content: Text(message)),
                      //       );
                      //       return const SizedBox.shrink();
                      //     }),
                      //     _ => const SizedBox.shrink(),
                      //   }; 
                      // });

                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text("Product Edited Successfully"),
                        ),
                      );

                      Navigator.pop(context);
                    }
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
        ),
      ),
    );
  }
}
