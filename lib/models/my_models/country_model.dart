
/// A [MayyaCountry] model represents an instance of a country which contains
/// information about the country
class MayyaCountry {
  /// The name of the [MayyaCountry]
  final String? name;

  /// The alpha 2 isoCode of the [MayyaCountry]
  final String? alpha2Code;

  /// The alpha 3 isoCode of the [MayyaCountry]
  final String? alpha3Code;

  /// The dialCode of the [MayyaCountry]
  final String? dialCode;

  /// The flagUri which links to the flag for the [MayyaCountry] in the library assets
  final String flagUri;

  /// The nameTranslation for translation
  final Map<String, String>? nameTranslations;

  MayyaCountry({
    required this.name,
    required this.alpha2Code,
    required this.alpha3Code,
    required this.dialCode,
    required this.flagUri,
    this.nameTranslations,
  });

  /// Convert [Countries.countryList] to [MayyaCountry] model
  factory MayyaCountry.fromJson(Map<String, dynamic> data) {
    return MayyaCountry(
      name: data['en_short_name'],
      alpha2Code: data['alpha_2_code'],
      alpha3Code: data['alpha_3_code'],
      dialCode: data['dial_code'],
      flagUri: 'assets/flags/${data['alpha_2_code'].toLowerCase()}.png',
      nameTranslations: data['nameTranslations'] != null
          ? Map<String, String>.from(data['nameTranslations'])
          : null,
    );
  }

  @override
  bool operator ==(Object other) {
    return other is MayyaCountry &&
        other.alpha2Code == alpha2Code &&
        other.alpha3Code == alpha3Code &&
        other.dialCode == dialCode;
  }

  @override
  int get hashCode => Object.hash(alpha2Code, alpha3Code, dialCode);

  @override
  String toString() => '[Country] { '
      'name: $name, '
      'alpha2: $alpha2Code, '
      'alpha3: $alpha3Code, '
      'dialCode: $dialCode '
      '}';
}
