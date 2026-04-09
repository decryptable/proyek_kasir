class BillCalculation {
  const BillCalculation({
    required this.menuName,
    required this.pricePerPortion,
    required this.quantity,
    required this.baseTotal,
    required this.tax,
    required this.discount,
    required this.finalTotal,
  });

  final String menuName;
  final int pricePerPortion;
  final int quantity;
  final int baseTotal;
  final double tax;
  final int discount;
  final double finalTotal;
}

class CashierCalculator {
  const CashierCalculator();

  BillCalculation calculate({
    required final String menuName,
    required final int pricePerPortion,
    required final int quantity,
  }) {
    // Kalkulasi aritmatika: total dasar = harga x jumlah porsi
    final int baseTotal = pricePerPortion * quantity;
    // Kalkulasi aritmatika: PPN = total dasar * 0.11
    final double tax = baseTotal * 0.11;
    int discount = 0;

    // Percabangan if-else eksplisit untuk aturan diskon (berdasarkan total dasar)
    if (baseTotal >= 100000) {
      discount = 10000;
    } else {
      discount = 0;
    }
    final double finalTotal = (baseTotal + tax) - discount;

    return BillCalculation(
      menuName: menuName,
      pricePerPortion: pricePerPortion,
      quantity: quantity,
      baseTotal: baseTotal,
      tax: tax,
      discount: discount,
      finalTotal: finalTotal,
    );
  }
}
