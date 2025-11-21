// lib/models/terms_model.dart

class ScreenTitleModel {
  final String title;
  final String description;

  ScreenTitleModel({
    required this.title,
    required this.description,
  });

  factory ScreenTitleModel.fromMap(Map<String, dynamic> map) {
    return ScreenTitleModel(
      title: map['title'] ?? '',
      description: map['description'] ?? '',
    );
  }
}

class TermsContentModel {
  final String description;
  final String language;
  final DateTime? lastUpdated;

  TermsContentModel({
    required this.description,
    required this.language,
    this.lastUpdated,
  });

  factory TermsContentModel.fromMap(Map<String, dynamic> map) {
    return TermsContentModel(
      description: map['description'] ?? '',
      language: map['language'] ?? '',
      lastUpdated: map['lastUpdated']?.toDate(),
    );
  }
}