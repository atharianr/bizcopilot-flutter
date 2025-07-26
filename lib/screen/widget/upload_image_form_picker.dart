import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import '../../../style/color/biz_colors.dart';
import '../../../style/typography/biz_text_styles.dart';

class BizImagePicker extends StatefulWidget {
  final Function(File?) onImageSelected;
  final File? initialImage;
  final String? label;
  final double height;
  final double? width;

  const BizImagePicker({
    super.key,
    required this.onImageSelected,
    this.initialImage,
    this.label = 'Add Product Image',
    this.height = 200,
    this.width,
  });

  @override
  State<BizImagePicker> createState() => _BizImagePickerState();
}

class _BizImagePickerState extends State<BizImagePicker> {
  File? _selectedImage;
  final ImagePicker _picker = ImagePicker();
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _selectedImage = widget.initialImage;
  }

  Future<void> _pickImageFromGallery() async {
    try {
      setState(() => _isLoading = true);

      final pickedFile = await _picker.pickImage(
        source: ImageSource.gallery,
        maxWidth: 800,
        maxHeight: 600,
        imageQuality: 85,
      );

      if (pickedFile != null) {
        final imageFile = File(pickedFile.path);
        setState(() {
          _selectedImage = imageFile;
          _isLoading = false;
        });
        widget.onImageSelected(imageFile);
      } else {
        setState(() => _isLoading = false);
      }
    } catch (e) {
      setState(() => _isLoading = false);
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Error picking image: $e')));
      }
    }
  }

  Future<void> _pickImageFromCamera() async {
    try {
      setState(() => _isLoading = true);

      final pickedFile = await _picker.pickImage(
        source: ImageSource.camera,
        maxWidth: 800,
        maxHeight: 600,
        imageQuality: 85,
      );

      if (pickedFile != null) {
        final imageFile = File(pickedFile.path);
        setState(() {
          _selectedImage = imageFile;
          _isLoading = false;
        });
        widget.onImageSelected(imageFile);
      } else {
        setState(() => _isLoading = false);
      }
    } catch (e) {
      setState(() => _isLoading = false);
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Error taking photo: $e')));
      }
    }
  }

  void _removeImage() {
    setState(() {
      _selectedImage = null;
    });
    widget.onImageSelected(null);
  }

  void _showImagePicker() {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (BuildContext context) {
        return SafeArea(
          child: Container(
            padding: const EdgeInsets.all(20),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 40,
                  height: 4,
                  decoration: BoxDecoration(
                    color: Colors.grey[300],
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
                const SizedBox(height: 20),
                Text(
                  'Select Image',
                  style: BizTextStyles.bodyLargeMedium.copyWith(
                    color: BizColors.colorBlack.getColor(context),
                  ),
                ),
                const SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    _buildPickerOption(
                      icon: Icons.photo_library,
                      label: 'Gallery',
                      onTap: () {
                        Navigator.pop(context);
                        _pickImageFromGallery();
                      },
                    ),
                    _buildPickerOption(
                      icon: Icons.camera_alt,
                      label: 'Camera',
                      onTap: () {
                        Navigator.pop(context);
                        _pickImageFromCamera();
                      },
                    ),
                    if (_selectedImage != null)
                      _buildPickerOption(
                        icon: Icons.delete,
                        label: 'Remove',
                        onTap: () {
                          Navigator.pop(context);
                          _removeImage();
                        },
                        isDestructive: true,
                      ),
                  ],
                ),
                const SizedBox(height: 20),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildPickerOption({
    required IconData icon,
    required String label,
    required VoidCallback onTap,
    bool isDestructive = false,
  }) {
    return Column(
      children: [
        Container(
          decoration: BoxDecoration(
            color:
                isDestructive
                    ? Colors.red.withOpacity(0.1)
                    : BizColors.colorPrimary.getColor(context).withOpacity(0.1),
            borderRadius: BorderRadius.circular(12),
          ),
          child: IconButton(
            onPressed: onTap,
            icon: Icon(icon, size: 30),
            color:
                isDestructive
                    ? Colors.red
                    : BizColors.colorPrimary.getColor(context),
            padding: const EdgeInsets.all(16),
          ),
        ),
        const SizedBox(height: 8),
        Text(
          label,
          style: BizTextStyles.bodyLargeRegular.copyWith(
            color:
                isDestructive
                    ? Colors.red
                    : BizColors.colorBlack.getColor(context),
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: widget.width ?? double.infinity,
      height: widget.height,
      decoration: BoxDecoration(
        border: Border.all(
          color: BizColors.colorPrimary.getColor(context),
          width: 2,
        ),
        borderRadius: BorderRadius.circular(8),
      ),
      child:
          _isLoading
              ? Center(
                child: CircularProgressIndicator(
                  color: BizColors.colorPrimary.getColor(context),
                ),
              )
              : _selectedImage == null
              ? InkWell(
                onTap: _showImagePicker,
                borderRadius: BorderRadius.circular(6),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.add_a_photo,
                      size: 50,
                      color: BizColors.colorPrimary.getColor(context),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      widget.label!,
                      style: BizTextStyles.bodyLargeRegular.copyWith(
                        color: BizColors.colorPrimary.getColor(context),
                      ),
                    ),
                  ],
                ),
              )
              : Stack(
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(6),
                    child: Image.file(
                      _selectedImage!,
                      width: double.infinity,
                      height: double.infinity,
                      fit: BoxFit.cover,
                    ),
                  ),
                  Positioned(
                    top: 8,
                    right: 8,
                    child: GestureDetector(
                      onTap: _showImagePicker,
                      child: Container(
                        padding: const EdgeInsets.all(6),
                        decoration: BoxDecoration(
                          color: Colors.black54,
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: const Icon(
                          Icons.edit,
                          color: Colors.white,
                          size: 18,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
    );
  }
}
