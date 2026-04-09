class MenuCatalog {
  // Map<String, int> untuk katalog menu
  static final Map<String, int> menuPrices = <String, int>{
    'Nasi Goreng': 25000,
    'Mie Ayam': 18000,
    'Sate Ayam': 30000,
    'Es Teh': 7000,
  };

  const MenuCatalog();

  bool containsMenu(final String menuName) {
    return menuPrices.containsKey(menuName);
  }

  int? getPrice(final String menuName) {
    return menuPrices[menuName];
  }

  List<String> get menuNames {
    return menuPrices.keys.toList(growable: false);
  }
}
