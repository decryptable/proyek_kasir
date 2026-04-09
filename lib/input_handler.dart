import 'dart:io';

import 'package:interact/interact.dart';

import 'catalog.dart';
import 'ui.dart';

class OrderInput {
  const OrderInput({required this.menuName, required this.quantity});

  final String menuName;
  final int quantity;
}

class InputHandler {
  const InputHandler({required this.catalog, required this.ui});

  final MenuCatalog catalog;
  final ConsoleUi ui;

  bool get _hasTerminal {
    return stdin.hasTerminal && stdout.hasTerminal;
  }

  OrderInput? captureOrder() {
    if (!_hasTerminal) {
      ui.showMessage(
        'Input terminal tidak tersedia (non-TTY). Jalankan di terminal interaktif.',
        type: UiMessageType.error,
      );
      return null;
    }

    final String menuName = _readValidMenuName();
    final int quantity = _readValidQuantity();

    return OrderInput(menuName: menuName, quantity: quantity);
  }

  String _readValidMenuName() {
    final Map<String, String> normalizedToCanonical = <String, String>{
      for (final String menu in catalog.menuNames) menu.toLowerCase(): menu,
    };
    final int inputMode = Select(
      prompt: 'Pilih metode input menu',
      options: const <String>[
        'Pilih dari daftar (panah atas/bawah)',
        'Ketik nama menu (dengan autocomplete)',
      ],
    ).interact();

    if (inputMode == 0) {
      final int selectedIndex = Select(
        prompt: 'Pilih menu pesanan',
        options: catalog.menuNames,
      ).interact();
      return catalog.menuNames[selectedIndex];
    }

    while (true) {
      final String menuName = Input(
        prompt: 'Masukkan nama menu',
        validator: (final String value) {
          if (value.trim().isEmpty) {
            throw ValidationError('Nama menu tidak boleh kosong.');
          }
          return true;
        },
      ).interact();
      final String normalized = menuName.trim();

      final String lowercaseInput = normalized.toLowerCase();
      final String? exactInsensitive = normalizedToCanonical[lowercaseInput];
      if (exactInsensitive != null) {
        return exactInsensitive;
      }

      final List<String> prefixMatches = catalog.menuNames
          .where((final String item) =>
              item.toLowerCase().startsWith(lowercaseInput))
          .toList(growable: false);
      if (prefixMatches.length == 1) {
        ui.showMessage(
          'Autocomplete: "$normalized" -> "${prefixMatches.first}"',
          type: UiMessageType.success,
        );
        return prefixMatches.first;
      }

      final List<String> partialMatches = catalog.menuNames
          .where((final String item) =>
              item.toLowerCase().contains(lowercaseInput))
          .toList(growable: false);

      if (partialMatches.length > 1) {
        ui.showMessage(
          'Menu "$normalized" belum spesifik.',
          type: UiMessageType.warning,
        );
        ui.showMenuSuggestions(partialMatches);
        final int suggestedPick = Select(
          prompt: 'Pilih menu dari hasil autocomplete',
          options: partialMatches,
        ).interact();
        return partialMatches[suggestedPick];
      }

      if (!catalog.containsMenu(normalized)) {
        ui.showMessage(
          'Menu "$normalized" tidak ditemukan. Silakan pilih dari daftar.',
          type: UiMessageType.error,
        );
        continue;
      }

      return normalized;
    }
  }

  int _readValidQuantity() {
    while (true) {
      final String rawQuantity = Input(
        prompt: 'Masukkan jumlah porsi',
        defaultValue: '1',
      ).interact();
      final String normalized = rawQuantity.trim();

      // Konversi String ke int menggunakan int.tryParse()
      final int? quantity = int.tryParse(normalized);
      if (quantity == null) {
        ui.showMessage(
          'Jumlah porsi harus berupa angka.',
          type: UiMessageType.error,
        );
        continue;
      }

      if (quantity <= 0) {
        ui.showMessage(
          'Jumlah porsi harus lebih dari nol.',
          type: UiMessageType.error,
        );
        continue;
      }

      return quantity;
    }
  }
}
