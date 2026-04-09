import 'dart:io';

import 'package:kasir_app/calculator.dart';
import 'package:kasir_app/catalog.dart';
import 'package:kasir_app/input_handler.dart';
import 'package:kasir_app/receipt_printer.dart';
import 'package:kasir_app/ui.dart';

Future<void> main() async {
  final ConsoleUi ui = ConsoleUi();
  final MenuCatalog catalog = const MenuCatalog();
  final InputHandler inputHandler = InputHandler(catalog: catalog, ui: ui);
  final CashierCalculator calculator = const CashierCalculator();
  final ReceiptPrinter receiptPrinter = ReceiptPrinter(ui);

  ui.clear();
  ui.showTitle();
  ui.showMenuTable(MenuCatalog.menuPrices);

  final bool proceed = ui.askCheckoutConfirmation();
  if (!proceed) {
    ui.showMessage(
      'Checkout dibatalkan oleh pengguna.',
      type: UiMessageType.warning,
    );
    exitCode = 0;
    return;
  }

  final OrderInput? order = inputHandler.captureOrder();
  if (order == null) {
    exitCode = 1;
    return;
  }

  final int? selectedPrice = catalog.getPrice(order.menuName);
  if (selectedPrice == null) {
    ui.showMessage(
      'Terjadi kesalahan internal saat mengambil harga menu.',
      type: UiMessageType.error,
    );
    exitCode = 1;
    return;
  }

  final BillCalculation bill = calculator.calculate(
    menuName: order.menuName,
    pricePerPortion: selectedPrice,
    quantity: order.quantity,
  );

  ui.showMessage('Pesanan berhasil diproses.', type: UiMessageType.success);
  receiptPrinter.printReceipt(bill);
}
