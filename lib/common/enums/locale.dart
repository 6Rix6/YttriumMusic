enum Language {
  en('English', 'en'),
  ja('Japanese', 'ja');

  final String name;
  final String code;
  const Language(this.name, this.code);
}

enum Country {
  us('United States', 'US'),
  jp('Japan', 'JP');

  final String name;
  final String code;
  const Country(this.name, this.code);
}
