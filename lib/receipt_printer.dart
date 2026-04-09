import 'dart:io';

import 'calculator.dart';
import 'ui.dart';

class ReceiptPrinter {
  const ReceiptPrinter(this.ui);

  final ConsoleUi ui;

  void printReceipt(final BillCalculation bill) {
    // String interpolation ($) untuk seluruh output struk
    final int innerWidth = ui.contentWidth - 2;
    final String border = '=' * ui.contentWidth;
    stdout.writeln(border);
    stdout.writeln('==== STRUK PEMBAYARAN ====');
    stdout.writeln(border);
    stdout.writeln(
        '| ${ui.fitText('Menu         : ${bill.menuName}', innerWidth)}|');
    stdout.writeln(
        '| ${ui.fitText('Harga/Porsi  : ${ui.currency(bill.pricePerPortion)}', innerWidth)}|');
    stdout.writeln(
        '| ${ui.fitText('Jumlah Porsi : ${bill.quantity}', innerWidth)}|');
    stdout.writeln(
        '| ${ui.fitText('Total Dasar  : ${ui.currency(bill.baseTotal)}', innerWidth)}|');
    stdout.writeln(
        '| ${ui.fitText('PPN 11%      : ${ui.currency(bill.tax)}', innerWidth)}|');
    stdout.writeln(
        '| ${ui.fitText('Diskon       : ${ui.currency(bill.discount)}', innerWidth)}|');
    stdout.writeln(
        '| ${ui.fitText('Total Bayar  : ${ui.currency(bill.finalTotal)}', innerWidth)}|');
    stdout.writeln(border);
    stdout.writeln(
        '| ${ui.fitText('Terima kasih sudah berbelanja :)', innerWidth)}|');
    stdout.writeln(border);
  }
}
