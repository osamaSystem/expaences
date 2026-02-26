class CurrencyOption {
  const CurrencyOption({
    required this.code,
    required this.symbol,
    required this.name,
  });

  final String code;
  final String symbol;
  final String name;
}

class AppCurrencies {
  static const List<CurrencyOption> supported = [
    CurrencyOption(code: 'USD', symbol: r'$', name: 'US Dollar'),
    CurrencyOption(code: 'EUR', symbol: 'EUR', name: 'Euro'),
    CurrencyOption(code: 'GBP', symbol: 'GBP', name: 'British Pound'),
    CurrencyOption(code: 'SAR', symbol: 'SAR', name: 'Saudi Riyal'),
    CurrencyOption(code: 'AED', symbol: 'AED', name: 'UAE Dirham'),
    CurrencyOption(code: 'INR', symbol: 'INR', name: 'Indian Rupee'),
    CurrencyOption(code: 'JPY', symbol: 'JPY', name: 'Japanese Yen'),
  ];

  static CurrencyOption byCode(String code) {
    return supported.firstWhere(
      (currency) => currency.code == code,
      orElse: () => supported.first,
    );
  }
}
