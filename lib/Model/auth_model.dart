// user_model.dart
class UserModel {
  final String? id;
  final String email;
  final String? name;
  final String? photoUrl;
  final String? localImagePath;

  UserModel({
    this.id,
    required this.email,
    this.name,
    this.photoUrl,
    this.localImagePath,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'email': email,
      'name': name,
      'photoUrl': photoUrl,
    };
  }

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'],
      email: json['email'],
      name: json['name'],
      photoUrl: json['photoUrl'],
    );
  }

  UserModel copyWith({
    String? id,
    String? email,
    String? name,
    String? photoUrl,
    String? localImagePath,
  }) {
    return UserModel(
      id: id ?? this.id,
      email: email ?? this.email,
      name: name ?? this.name,
      photoUrl: photoUrl ?? this.photoUrl,
      localImagePath: localImagePath ?? this.localImagePath,
    );
  }
}

// app_info_model.dart
class AppInfoModel {
  final String? termsAndConditions;
  final String? privacyPolicy;
  final String? about;
  final String? version;

  AppInfoModel({
    this.termsAndConditions,
    this.privacyPolicy,
    this.about,
    this.version,
  });

  factory AppInfoModel.fromJson(Map<String, dynamic> json) {
    return AppInfoModel(
      termsAndConditions: json['termsAndConditions'],
      privacyPolicy: json['privacyPolicy'],
      about: json['about'],
      version: json['version'],
    );
  }
}