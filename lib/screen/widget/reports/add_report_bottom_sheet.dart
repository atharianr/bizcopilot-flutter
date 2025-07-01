import 'package:bizcopilot_flutter/data/model/add_report_model.dart';
import 'package:bizcopilot_flutter/style/typography/biz_text_styles.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

import '../../../provider/daily_reports/add_report_provider.dart';
import '../../../static/reports/report_type.dart';
import '../../../static/state/add_report_result_state.dart';
import '../../../style/color/biz_colors.dart';
import '../biz_drop_down.dart';
import '../biz_radio_button.dart';
import '../biz_text_input.dart';

class AddReportBottomSheet extends StatefulWidget {
  const AddReportBottomSheet({super.key});

  @override
  State<AddReportBottomSheet> createState() => _AddReportBottomSheetState();
}

class _AddReportBottomSheetState extends State<AddReportBottomSheet> {
  late TextEditingController nameController;
  late TextEditingController descriptionController;
  late TextEditingController priceController;
  late TextEditingController dateController;

  final List<String> salesCategories = ["Food", "Drink", "Snack"];

  @override
  void initState() {
    super.initState();
    final model =
        context.read<AddReportProvider>().addReportModel ?? AddReportModel();
    nameController = TextEditingController(text: model.name ?? '');
    descriptionController = TextEditingController(
      text: model.description ?? '',
    );
    priceController = TextEditingController(
      text: model.price != null ? model.price.toString() : '',
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
    final model = provider.addReportModel ?? AddReportModel();
    final primaryColor = BizColors.colorPrimary.getColor(context);
    final grayColor = BizColors.colorGrey.getColor(context);
    final blackColor = BizColors.colorBlack.getColor(context);

    bool isSales = model.type == ReportType.sales;

    return Padding(
      padding: const EdgeInsets.only(left: 16, right: 16, bottom: 72),
      child: Container(
        decoration: BoxDecoration(
          color: BizColors.colorBackground.getColor(context),
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: BizColors.colorBlack.getColor(context).withOpacity(0.2),
              blurRadius: 16,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Container(
                  width: 40,
                  height: 4,
                  margin: const EdgeInsets.only(bottom: 16),
                  decoration: BoxDecoration(
                    color: grayColor,
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),
              const Center(
                child: Text(
                  "Add New Report",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
              ),
              const SizedBox(height: 16),

              Text(
                "Report Type",
                style: BizTextStyles.bodyLargeMedium.copyWith(
                  color: blackColor,
                ),
              ),
              const SizedBox(height: 8),
              Row(
                children: [
                  BizRadioButton(
                    label: "Sales",
                    value: ReportType.sales,
                    selectedTag: model.type,
                    onTap: () {
                      provider.setReportModel = AddReportModel(
                        name: null,
                        description: null,
                        price: null,
                        date: model.date,
                        type: ReportType.sales,
                      );
                    },
                  ),
                  const SizedBox(width: 12),
                  BizRadioButton(
                    label: "Expenses",
                    value: ReportType.expenses,
                    selectedTag: model.type,
                    onTap: () {
                      provider.setReportModel = AddReportModel(
                        name: null,
                        description: null,
                        price: null,
                        date: model.date,
                        type: ReportType.expenses,
                      );
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
                BizDropDown(
                  value: model.name,
                  hintText: "Product",
                  items: salesCategories,
                  onChanged: (value) {
                    provider.setReportModel = AddReportModel(
                      name: value,
                      description: null,
                      price: null,
                      date: model.date,
                      type: ReportType.sales,
                    );
                  },
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
                  onChanged: (value) {
                    provider.setReportModel = AddReportModel(
                      name: value,
                      description: model.description,
                      price: model.price,
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
                  onChanged: (value) {
                    provider.setReportModel = AddReportModel(
                      name: model.name,
                      description: value,
                      price: model.price,
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
                  onChanged: (value) {
                    provider.setReportModel = AddReportModel(
                      name: model.name,
                      description: model.description,
                      price: int.tryParse(value),
                      date: model.date,
                      type: model.type,
                    );
                  },
                ),
              ],

              const SizedBox(height: 12),
              Text(
                "Date",
                style: BizTextStyles.bodyLargeMedium.copyWith(
                  color: blackColor,
                ),
              ),
              const SizedBox(height: 8),
              BizTextInput(
                hintText: "Date",
                controller: dateController,
                readOnly: true,
                onTap: () async {
                  DateTime? pickedDate = await showDatePicker(
                    context: context,
                    initialDate: DateTime.now(),
                    firstDate: DateTime(2000),
                    lastDate: DateTime(2100),
                    builder: (context, child) {
                      return Theme(
                        data: Theme.of(context).copyWith(
                          colorScheme: ColorScheme.light(
                            primary: primaryColor,
                            onPrimary: Colors.white,
                            surface: BizColors.colorBackground.getColor(
                              context,
                            ),
                            onSurface: BizColors.colorBlack.getColor(context),
                          ),
                          dialogTheme: DialogTheme(
                            backgroundColor: BizColors.colorBackground.getColor(
                              context,
                            ),
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
                          ? null // Disable while loading
                          : () async {
                            await provider.addReport();
                            if (context.mounted) {
                              Navigator.pop(context);
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
                            "Add Report",
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
