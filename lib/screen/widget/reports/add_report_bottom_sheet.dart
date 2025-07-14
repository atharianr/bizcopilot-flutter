import 'package:bizcopilot_flutter/data/model/add_report_model.dart';
import 'package:bizcopilot_flutter/data/model/response/product_response.dart';
import 'package:bizcopilot_flutter/style/typography/biz_text_styles.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

import '../../../provider/daily_reports/add_report_provider.dart';
import '../../../provider/list_product/list_product_provider.dart';
import '../../../static/reports/report_type.dart';
import '../../../static/state/add_report_result_state.dart';
import '../../../static/state/list_product_result_state.dart';
import '../../../style/color/biz_colors.dart';
import '../biz_drop_down.dart';
import '../biz_radio_button.dart';
import '../biz_text_input.dart';
import '../shimmer_card.dart';

class AddReportBottomSheet extends StatefulWidget {
  final bool isUpdate;

  const AddReportBottomSheet({super.key, this.isUpdate = false});

  @override
  State<AddReportBottomSheet> createState() => _AddReportBottomSheetState();
}

class _AddReportBottomSheetState extends State<AddReportBottomSheet> {
  late TextEditingController nameController;
  late TextEditingController descriptionController;
  late TextEditingController priceController;
  late TextEditingController dateController;

  @override
  void initState() {
    super.initState();
    final provider = context.read<AddReportProvider>();
    final model =
        widget.isUpdate
            ? provider.addReportModel ?? AddReportModel()
            : AddReportModel();

    provider.resetErrors();

    if (!widget.isUpdate) provider.resetReportModel();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<ListProductProvider>().getAllListProducts();
    });

    nameController = TextEditingController(text: model.name ?? '');
    descriptionController = TextEditingController(
      text: model.description ?? '',
    );
    priceController = TextEditingController(
      text: model.price?.toString() ?? '',
    );
    dateController = TextEditingController(text: model.date ?? '');
  }

  @override
  void dispose() {
    nameController.dispose();
    descriptionController.dispose();
    priceController.dispose();
    dateController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<AddReportProvider>(context);
    final productProvider = Provider.of<ListProductProvider>(context);
    final model = provider.addReportModel ?? AddReportModel();

    final primaryColor = BizColors.colorPrimary.getColor(context);
    final grayColor = BizColors.colorGrey.getColor(context);
    final blackColor = BizColors.colorBlack.getColor(context);

    bool isSales = model.type == ReportType.sales;

    final List<Products> productList =
        productProvider.resultState is ListProductLoadedState
            ? (productProvider.resultState as ListProductLoadedState).data
            : <Products>[];

    return Container(
      decoration: BoxDecoration(
        color: BizColors.colorBackground.getColor(context),
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(16),
          topRight: Radius.circular(16),
        ),
      ),
      child: SingleChildScrollView(
        padding: EdgeInsets.only(
          left: 16,
          right: 16,
          bottom: MediaQuery.of(context).viewInsets.bottom + 24,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Container(
                width: 40,
                height: 4,
                margin: const EdgeInsets.only(top: 12, bottom: 16),
                decoration: BoxDecoration(
                  color: grayColor,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ),
            Center(
              child: Text(
                model.date != null ? "Update Report" : "Add New Report",
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            const SizedBox(height: 16),

            Text(
              "Report Type",
              style: BizTextStyles.bodyLargeMedium.copyWith(color: blackColor),
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                BizRadioButton(
                  label: "Sales",
                  value: ReportType.sales,
                  selectedTag: model.type,
                  onTap: () {
                    provider.resetSaleReportModel();
                    provider.resetErrors();
                  },
                ),
                const SizedBox(width: 12),
                BizRadioButton(
                  label: "Expenses",
                  value: ReportType.expenses,
                  selectedTag: model.type,
                  onTap: () {
                    provider.resetExpenseReportModel();
                    provider.resetErrors();
                  },
                ),
              ],
            ),
            const SizedBox(height: 12),

            if (isSales) ...[
              Text(
                "Product",
                style: BizTextStyles.bodyLargeMedium.copyWith(
                  color: blackColor,
                ),
              ),
              const SizedBox(height: 8),
              productProvider.resultState is ListProductLoadingState
                  ? const ShimmerCard(height: 48)
                  : BizDropDown(
                    value: model.product,
                    hintText: "Product",
                    items: productList,
                    onChanged: (value) {
                      provider.setReportModel = AddReportModel(
                        name: value?.name,
                        description: model.description,
                        price: model.price,
                        product: value,
                        date: model.date,
                        type: ReportType.sales,
                      );
                    },
                    errorText: provider.productError,
                  ),
            ] else ...[
              Text(
                "Report Name",
                style: BizTextStyles.bodyLargeMedium.copyWith(
                  color: blackColor,
                ),
              ),
              const SizedBox(height: 8),
              BizTextInput(
                hintText: "Name",
                controller: nameController,
                errorText: provider.nameError,
                onChanged: (value) {
                  provider.setReportModel = AddReportModel(
                    name: value,
                    description: model.description,
                    price: model.price,
                    product: model.product,
                    date: model.date,
                    type: model.type,
                  );
                },
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
                errorText: provider.descriptionError,
                onChanged: (value) {
                  provider.setReportModel = AddReportModel(
                    name: model.name,
                    description: value,
                    price: model.price,
                    product: model.product,
                    date: model.date,
                    type: model.type,
                  );
                },
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
                keyboardType: TextInputType.number,
                inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                errorText: provider.priceError,
                onChanged: (value) {
                  provider.setReportModel = AddReportModel(
                    name: model.name,
                    description: model.description,
                    price: int.tryParse(value),
                    product: model.product,
                    date: model.date,
                    type: model.type,
                  );
                },
              ),
            ],

            const SizedBox(height: 12),
            Text(
              "Date",
              style: BizTextStyles.bodyLargeMedium.copyWith(color: blackColor),
            ),
            const SizedBox(height: 8),
            BizTextInput(
              hintText: "Date",
              controller: dateController,
              readOnly: true,
              errorText: provider.dateError,
              onTap: () async {
                DateTime? pickedDate = await showDatePicker(
                  context: context,
                  initialDate:
                      model.date != null && model.date!.isNotEmpty
                          ? DateTime.parse(model.date!)
                          : DateTime.now(),
                  firstDate: DateTime(2000),
                  lastDate: DateTime(2100),
                  builder: (context, child) {
                    return Theme(
                      data: Theme.of(context).copyWith(
                        colorScheme: ColorScheme.light(
                          primary: primaryColor,
                          onPrimary: Colors.white,
                          surface: BizColors.colorBackground.getColor(context),
                          onSurface: blackColor,
                        ),
                        dialogTheme: DialogThemeData(
                          backgroundColor: BizColors.colorBackground.color,
                        ),
                      ),
                      child: child!,
                    );
                  },
                );

                if (pickedDate != null) {
                  String formattedDate =
                      "${pickedDate.year}-${pickedDate.month.toString().padLeft(2, '0')}-${pickedDate.day.toString().padLeft(2, '0')}";
                  dateController.text = formattedDate;
                  provider.setReportModel = AddReportModel(
                    name: model.name,
                    description: model.description,
                    price: model.price,
                    product: model.product,
                    date: formattedDate,
                    type: model.type,
                  );
                }
              },
            ),
            const SizedBox(height: 20),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                style: ButtonStyle(
                  backgroundColor: WidgetStateProperty.all(primaryColor),
                ),
                onPressed:
                    provider.resultState is AddReportLoadingState
                        ? null
                        : () async {
                          if (provider.validateInputs()) {
                            await provider.addReport();
                            if (context.mounted) {
                              Navigator.pop(context);
                            }
                          }
                        },
                child:
                    provider.resultState is AddReportLoadingState
                        ? SizedBox(
                          height: 20,
                          width: 20,
                          child: CircularProgressIndicator(
                            color: BizColors.colorWhite.getColor(context),
                            strokeWidth: 2,
                          ),
                        )
                        : Text(
                          model.date != null ? "Update Report" : "Add Report",
                          style: BizTextStyles.button.copyWith(
                            color: BizColors.colorWhite.getColor(context),
                          ),
                        ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
