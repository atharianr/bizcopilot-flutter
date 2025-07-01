import 'package:bizcopilot_flutter/data/model/add_report_model.dart';
import 'package:bizcopilot_flutter/style/typography/biz_text_styles.dart';
import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';

import '../../../provider/daily_reports/add_report_provider.dart';
import '../../../static/reports/report_type.dart';
import '../../../static/state/add_report_result_state.dart';
import '../../../style/color/biz_colors.dart';
import '../biz_drop_down.dart';
import '../biz_radio_button.dart';
import '../biz_text_input.dart';

// TODO: Need to change state to using Provider
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
  String? nameError;
  String? descriptionError;
  String? priceError;
  String? productError;
  String? dateError;

  CameraController? _cameraController;
  bool _isCameraInitialized = false;
  bool _isCameraPermissionGranted = false;
  bool _isOcrMode = false;

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
      text: model.price?.toString() ?? '',
    );
    dateController = TextEditingController(text: model.date ?? '');
  }

  Future<void> requestCameraPermissionAndInitialize() async {
    final status = await Permission.camera.request();
    if (status.isGranted) {
      await initializeCamera();
      setState(() {
        _isCameraPermissionGranted = true;
      });
    } else {
      setState(() {
        _isCameraPermissionGranted = false;
      });
    }
  }

  Future<void> initializeCamera() async {
    await SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
    final cameras = await availableCameras();
    _cameraController = CameraController(
      cameras.first,
      ResolutionPreset.medium,
    );
    await _cameraController!.initialize();
    if (mounted) {
      setState(() {
        _isCameraInitialized = true;
      });
    }
  }

  Future<void> disposeCamera() async {
    await _cameraController?.dispose();
    _cameraController = null;
    _isCameraInitialized = false;
    await SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
      DeviceOrientation.landscapeLeft,
      DeviceOrientation.landscapeRight,
    ]);
  }

  @override
  void dispose() {
    nameController.dispose();
    descriptionController.dispose();
    priceController.dispose();
    dateController.dispose();
    disposeCamera();
    super.dispose();
  }

  bool validateInputs(AddReportModel model) {
    bool isValid = true;
    setState(() {
      nameError = null;
      descriptionError = null;
      priceError = null;
      productError = null;
      dateError = null;

      if (model.type == ReportType.sales) {
        if (model.name == null || model.name!.isEmpty) {
          productError = "Please select a product";
          isValid = false;
        }
      } else {
        if (nameController.text.isEmpty) {
          nameError = "Name is required";
          isValid = false;
        }
        if (descriptionController.text.isEmpty) {
          descriptionError = "Description is required";
          isValid = false;
        }
        if (priceController.text.isEmpty) {
          priceError = "Price is required";
          isValid = false;
        }
      }

      if (dateController.text.isEmpty) {
        dateError = "Date is required";
        isValid = false;
      }
    });
    return isValid;
  }

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<AddReportProvider>(context);
    final model = provider.addReportModel ?? AddReportModel();
    final primaryColor = BizColors.colorPrimary.getColor(context);
    final grayColor = BizColors.colorGrey.getColor(context);
    final blackColor = BizColors.colorBlack.getColor(context);

    bool isSales = model.type == ReportType.sales;
    bool isExpenses = model.type == ReportType.expenses;

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
          child: SingleChildScrollView(
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

                if (isExpenses)
                  Container(
                    padding: EdgeInsets.only(bottom: 16),
                    width: double.infinity,
                    child: ElevatedButton(
                      style: ButtonStyle(
                        backgroundColor: WidgetStateProperty.all(primaryColor),
                      ),
                      onPressed: () async {
                        if (_isOcrMode) {
                          await disposeCamera();
                        } else {
                          await requestCameraPermissionAndInitialize();
                        }
                        setState(() {
                          _isOcrMode = !_isOcrMode;
                        });
                      },
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            _isOcrMode
                                ? Icons.edit_rounded
                                : Icons.camera_alt_rounded,
                            color: BizColors.colorWhite.getColor(context),
                            size: 18,
                          ),
                          const SizedBox(width: 8),
                          Text(
                            _isOcrMode
                                ? "Switch to Manual Input"
                                : "Use Camera to Scan Receipt",
                            style: BizTextStyles.button.copyWith(
                              color: BizColors.colorWhite.getColor(context),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),

                if (isExpenses && _isOcrMode) ...[
                  Center(
                    child: Container(
                      width: double.infinity,
                      height: 350,
                      decoration: BoxDecoration(
                        border: Border.all(color: primaryColor, width: 2),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(10),
                        child:
                            _isCameraPermissionGranted
                                ? (_isCameraInitialized &&
                                        _cameraController != null
                                    ? CameraPreview(_cameraController!)
                                    : const Center(
                                      child: CircularProgressIndicator(),
                                    ))
                                : Center(
                                  child: Text(
                                    "Camera permission denied",
                                    style: BizTextStyles.bodyLargeMedium
                                        .copyWith(
                                          color: BizColors.colorGrey.getColor(
                                            context,
                                          ),
                                        ),
                                    textAlign: TextAlign.center,
                                  ),
                                ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                ],

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
                      onTap: () async {
                        if (_isOcrMode) {
                          await disposeCamera();
                          _isOcrMode = false;
                        }
                        provider.setReportModel = AddReportModel(
                          name: null,
                          description: null,
                          price: null,
                          date: model.date,
                          type: ReportType.sales,
                        );
                        setState(() {});
                      },
                    ),
                    const SizedBox(width: 12),
                    BizRadioButton(
                      label: "Expenses",
                      value: ReportType.expenses,
                      selectedTag: model.type,
                      onTap: () async {
                        if (_isOcrMode) {
                          await disposeCamera();
                          _isOcrMode = false;
                        }
                        provider.setReportModel = AddReportModel(
                          name: null,
                          description: null,
                          price: null,
                          date: model.date,
                          type: ReportType.expenses,
                        );
                        setState(() {});
                      },
                    ),
                  ],
                ),

                const SizedBox(height: 12),

                if (!_isOcrMode) ...[
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
                      errorText: productError,
                    ),
                  ] else if (isExpenses) ...[
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
                      errorText: nameError,
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
                      errorText: descriptionError,
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
                      errorText: priceError,
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
                    errorText: dateError,
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
                                onSurface: BizColors.colorBlack.getColor(
                                  context,
                                ),
                              ),
                              dialogTheme: DialogTheme(
                                backgroundColor: BizColors.colorBackground
                                    .getColor(context),
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
                              ? null
                              : () async {
                                if (validateInputs(
                                  provider.addReportModel ?? AddReportModel(),
                                )) {
                                  await provider.addReport();
                                  if (context.mounted) {
                                    Navigator.pop(context);
                                  }
                                }
                              },
                      child:
                          provider.resultState is AddReportLoadingState
                              ? const SizedBox(
                                height: 20,
                                width: 20,
                                child: CircularProgressIndicator(
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
              ],
            ),
          ),
        ),
      ),
    );
  }
}
