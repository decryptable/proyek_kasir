import 'dart:io';

import 'package:dart_console/dart_console.dart';
import 'package:interact/interact.dart';
import 'package:intl/intl.dart';

enum UiMessageType { info, warning, error, success }

class ConsoleUi {
  ConsoleUi()
      : _console = Console(),
        _currency = NumberFormat.currency(
          locale: 'id_ID',
          symbol: 'Rp ',
          decimalDigits: 0,
        );

  final Console _console;
  final NumberFormat _currency;

  String currency(final num amount) {
    return _currency.format(amount);
  }

  int get contentWidth {
    final int terminalWidth = stdout.hasTerminal ? stdout.terminalColumns : 80;
    final int safeWidth = terminalWidth > 0 ? terminalWidth : 80;
    return safeWidth.clamp(60, 100);
  }

  String line(final String char) {
    return char * contentWidth;
  }

  String fitText(final String text, final int width) {
    if (text.length <= width) {
      return text.padRight(width);
    }
    if (width <= 1) {
      return text.substring(0, width);
    }
    return '${text.substring(0, width - 1)}…';
  }

  void clear() {
    _console.clearScreen();
  }

  Future<void> showBootAnimation() async {
    final List<String> frames = <String>['|', '/', '-', r'\'];
    _console.setForegroundColor(ConsoleColor.cyan);
    for (int index = 0; index < 12; index++) {
      final String frame = frames[index % frames.length];
      stdout.write('\r$frame Memuat Kasir App...');
      await Future<void>.delayed(const Duration(milliseconds: 90));
    }
    stdout.write('\rSiap digunakan.          \n');
    _console.resetColorAttributes();
  }

  void showTitle() {
    _console.setForegroundColor(ConsoleColor.green);
    final String border = line('=');
    stdout.writeln(border);
    stdout.writeln(fitText(' SIMULASI APLIKASI KASIR CLI ', contentWidth));
    stdout.writeln(border);
    _console.resetColorAttributes();
  }

  void showMessage(
    final String message, {
    final UiMessageType type = UiMessageType.info,
  }) {
    final ConsoleColor color = switch (type) {
      UiMessageType.info => ConsoleColor.cyan,
      UiMessageType.warning => ConsoleColor.yellow,
      UiMessageType.error => ConsoleColor.red,
      UiMessageType.success => ConsoleColor.green,
    };
    _console.setForegroundColor(color);
    stdout.writeln(message);
    _console.resetColorAttributes();
  }

  void showMenuTable(final Map<String, int> menuPrices) {
    _console.setForegroundColor(ConsoleColor.magenta);
    final int totalWidth = contentWidth;
    final int noWidth = 4;
    final int priceWidth = 16;
    final int menuWidth = totalWidth - noWidth - priceWidth - 10;
    final String horizontal =
        '+${'-' * (noWidth + 2)}+${'-' * (menuWidth + 2)}+${'-' * (priceWidth + 2)}+';
    stdout.writeln(horizontal);
    stdout.writeln(
      '| ${fitText('No', noWidth)} | ${fitText('Menu', menuWidth)} | ${fitText('Harga', priceWidth)} |',
    );
    stdout.writeln(horizontal);
    int number = 1;
    for (final MapEntry<String, int> item in menuPrices.entries) {
      final String index = fitText(number.toString(), noWidth);
      final String name = fitText(item.key, menuWidth);
      final String price = fitText(currency(item.value), priceWidth);
      stdout.writeln('| $index | $name | $price |');
      number++;
    }
    stdout.writeln(horizontal);
    _console.resetColorAttributes();
  }

  void showMenuSuggestions(final List<String> matches) {
    _console.setForegroundColor(ConsoleColor.yellow);
    stdout.writeln('Saran menu (autocomplete):');
    for (final String menu in matches.take(5)) {
      stdout.writeln('- $menu');
    }
    _console.resetColorAttributes();
  }

  bool askCheckoutConfirmation() {
    return Confirm(
      prompt: 'Lanjutkan ke proses checkout?',
      defaultValue: true,
    ).interact();
  }
}
