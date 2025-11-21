// user_model.dart
import 'package:cloud_firestore/cloud_firestore.dart';

class UserModel {
  final String? id;
  final String email;
  final String? name;
  final String? photoUrl;
  final String? localImagePath; // Keeping this for UI state if needed, but not storing in Firestore

  UserModel({
    this.id,
    required this.email,
    this.name,
    this.photoUrl,
    this.localImagePath,
  });

  // Method to convert model to a map for saving to Firestore
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'email': email,
      'name': name,
      'photoUrl': photoUrl,
      // 'localImagePath' is for temporary/local use and not stored in Firestore
    };
  }

  // Factory method to create model from a map, useful for fetching from Firestore
  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'],
      email: json['email'],
      name: json['name'],
      photoUrl: json['photoUrl'],
      // localImagePath is not loaded from Firestore
    );
  }

  // Factory method to create model from a Firestore DocumentSnapshot
  factory UserModel.fromDocumentSnapshot(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return UserModel(
      id: doc.id,
      email: data['email'] ?? '',
      name: data['name'],
      photoUrl: data['photoUrl'],
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

// app_info_model.dart (No change needed)
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