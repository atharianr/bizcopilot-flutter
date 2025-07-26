import 'dart:io';
import 'package:bizcopilot_flutter/static/state/add_product_result_state.dart';
import 'package:bizcopilot_flutter/static/state/image_upload_state.dart';
import 'package:bizcopilot_flutter/style/typography/biz_text_styles.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

import '../../data/model/request/product_request_model.dart';
import '../../data/model/response/upload_image_response.dart';

import '../../../style/color/biz_colors.dart';
import '../widget/biz_text_input.dart';
import '../widget/upload_image_form_picker.dart';

import 'package:bizcopilot_flutter/provider/list_product/add_product_provider.dart';
import 'package:bizcopilot_flutter/provider/image_upload_provider.dart';

class AddProductScreen extends StatefulWidget {
  const AddProductScreen({super.key});

  @override
  State<AddProductScreen> createState() => _AddProductScreenState();
}

class _AddProductScreenState extends State<AddProductScreen> {
  late TextEditingController nameController;
  late TextEditingController descriptionController;
  late TextEditingController stockController;
  late TextEditingController costPriceController;
  late TextEditingController priceController;

  String? imageFileError;
  String? nameError;
  String? descriptionError;
  String? stockError;
  String? costPriceError;
  String? priceError;

  File? _selectedProductImage;

  // Add these variables to store consumer widgets
  Widget? _awsUploadConsumer;
  Widget? _addProductConsumer;

  @override
  void initState() {
    super.initState();
    nameController = TextEditingController();
    descriptionController = TextEditingController();
    stockController = TextEditingController();
    costPriceController = TextEditingController();
    priceController = TextEditingController();
    // WidgetsBinding.instance.addPostFrameCallback((_) {
    //   Provider.of<AddProductProvider>(context, listen: false)
    //       .addProduct();
    // });

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

  void _onImageSelected(File? image) {
    setState(() {
      _selectedProductImage = image;
    });
  }

  // FIXED: Make this method return the Consumer widget
  Widget _addProductAfterUpload(
    UploadImageResponse? uploadImageResponse,
    String name,
    String description,
    int stock,
    int costPrice,
    int price,
  ) {
    if (uploadImageResponse != null) {
      Provider.of<UploadImageProvider>(
        context,
        listen: false,
      ).uploadImageToAWS(uploadImageResponse.uploadUrl ?? "");

      return Consumer<UploadImageProvider>(
        builder: (context, value, child) {
          switch (value.resultState) {
            case ImageUploadLoadingState():
              return const Center(child: CircularProgressIndicator());
            case ImageUploadLoadedState(data: var data):
              WidgetsBinding.instance.addPostFrameCallback((_) {
                setState(() {
                  _addProductConsumer = _addProductToApi(
                    data!.publicUrl ?? "",
                    nameController.text,
                    descriptionController.text,
                    int.parse(stockController.text),
                    int.parse(costPriceController.text),
                    int.parse(priceController.text),
                  );
                });
              });
              return const SizedBox.shrink();
            case ImageUploadErrorState(error: var message):
              WidgetsBinding.instance.addPostFrameCallback((_) {
                ScaffoldMessenger.of(
                  context,
                ).showSnackBar(SnackBar(content: Text(message)));
              });
              return const SizedBox.shrink();
            default:
              return const SizedBox.shrink();
          }
        },
      );
    }
    return const SizedBox.shrink();
  }

  // FIXED: Make this method return the Consumer widget
  Widget _addProductToApi(
    String imagePath,
    String name,
    String description,
    int stock,
    int costPrice,
    int price,
  ) {
    Provider.of<AddProductProvider>(
      context,
      listen: false,
    ).setReportModel = ProductRequestModel(
      name: name,
      description: description,
      inventory: stock,
      costPrice: costPrice,
      price: price,
      imageUrl: imagePath,
    );

    Provider.of<AddProductProvider>(context, listen: false).addProduct();

    return Consumer<AddProductProvider>(
      builder: (context, value, child) {
        return switch (value.resultState) {
          AddProductLoadingState() => const Center(
            child: CircularProgressIndicator(),
          ),
          AddProductLoadedState(data: var data) => Builder(
            builder: (context) {
              WidgetsBinding.instance.addPostFrameCallback((_) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text("Product Added Successfully")),
                );
                Navigator.pop(context);
              });
              return const SizedBox.shrink();
            },
          ),
          AddProductErrorState(error: var message) => Builder(
            builder: (context) {
              WidgetsBinding.instance.addPostFrameCallback((_) {
                ScaffoldMessenger.of(
                  context,
                ).showSnackBar(SnackBar(content: Text(message)));
              });
              return const SizedBox.shrink();
            },
          ),
          _ => const SizedBox.shrink(),
        };
      },
    );
  }

  bool validateInputs() {
    bool isValid = true;
    setState(() {
      imageFileError = null;
      nameError = null;
      descriptionError = null;
      stockError = null;
      costPriceError = null;
      priceError = null;

      if (_selectedProductImage == null) {
        imageFileError = "Product image is required";
        isValid = false; // FIXED: set isValid to false
      }

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
            const Text("Add Product"),
          ],
        ),
      ),
      body: Stack(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  BizImagePicker(
                    onImageSelected: _onImageSelected,
                    initialImage: _selectedProductImage,
                    label: 'Add Product Image',
                    height: 200,
                  ),

                  const SizedBox(height: 12),

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
                      onPressed: () async {
                        if (validateInputs()) {
                          final name = nameController.text.trim();
                          final description = descriptionController.text.trim();
                          final stock = int.parse(stockController.text.trim());
                          final costPrice = int.parse(
                            costPriceController.text.trim(),
                          );
                          final price = int.parse(priceController.text.trim());

                          Provider.of<UploadImageProvider>(
                                context,
                                listen: false,
                              ).setReportModel =
                              _selectedProductImage!;

                          await Provider.of<UploadImageProvider>(
                            context,
                            listen: false,
                          ).uploadImage();

                          // FIXED: Store the returned Consumer widget in state
                          setState(() {
                            _awsUploadConsumer = Consumer<UploadImageProvider>(
                              builder: (context, value, child) {
                                switch (value.resultState) {
                                  case ImageUploadLoadingState():
                                    return SizedBox();
                                  case ImageUploadLoadedState(data: var data):
                                    // Store the AWS upload consumer
                                    WidgetsBinding.instance
                                        .addPostFrameCallback((_) {
                                          setState(() {
                                            _awsUploadConsumer =
                                                _addProductAfterUpload(
                                                  data,
                                                  name,
                                                  description,
                                                  stock,
                                                  costPrice,
                                                  price,
                                                );
                                          });
                                        });
                                    return SizedBox();
                                  case ImageUploadErrorState(error: var error):
                                    return SizedBox();
                                  default:
                                    return SizedBox();
                                }
                              },
                            );
                          });

                          // Remove the hardcoded success message
                          // ScaffoldMessenger.of(context).showSnackBar(
                          //   const SnackBar(
                          //     content: Text("Product Added Successfully"),
                          //   ),
                          // );

                          // Navigator.pop(context);
                        }
                      },
                      child: Text(
                        "Add Product",
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

          // ADDED: Render the consumer widgets in the widget tree
          if (_awsUploadConsumer != null) _awsUploadConsumer!,
          if (_addProductConsumer != null) _addProductConsumer!,
        ],
      ),
    );
  }
}
