class NumberFormatter {
  /// Format số tiền với dấu chấm (1000000 -> 1.000.000)
  static String formatCurrency(double amount) {
    final formatter = RegExp(r'(\d)(?=(\d{3})+(?!\d))');
    String intPart = amount.toStringAsFixed(0);
    return intPart.replaceAllMapped(formatter, (Match match) => '${match[1]}.');
  }

  /// Format số tiền kèm ký hiệu đ (1000000 -> 1.000.000 đ)
  static String formatPrice(double amount) {
    return '${formatCurrency(amount)} đ';
  }
}
