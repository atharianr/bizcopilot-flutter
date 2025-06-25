class CurrencyUtils {
  static String formatCurrency(String? currency, int? value) {
    if (value == null) {
      return "${currency ?? ''}0";
    }

    final formatted = value.toString().replaceAllMapped(
      RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'),
      (Match m) => '${m[1]}.',
    );

    return "${currency ?? ''}$formatted";
  }
}
