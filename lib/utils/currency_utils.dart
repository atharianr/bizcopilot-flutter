class CurrencyUtils {
  static String formatCurrency(String? currency, dynamic value) {
    if (value == null) {
      return "${currency ?? ''}0";
    }

    int number;

    if (value is int) {
      number = value;
    } else if (value is String) {
      number = int.tryParse(value.replaceAll(RegExp(r'[^0-9]'), '')) ?? 0;
    } else {
      return "${currency ?? ''}0";
    }

    final formatted = number.toString().replaceAllMapped(
      RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'),
      (Match m) => '${m[1]}.',
    );

    return "${currency ?? ''}$formatted";
  }
}
