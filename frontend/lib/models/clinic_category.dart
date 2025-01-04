import 'package:flutter/foundation.dart';
import 'service.dart';

class ClinicCategory {
  final String id;
  final String name;
  final String iconPath;
  final List<Service> services;

  const ClinicCategory({
    required this.id,
    required this.name,
    required this.iconPath,
    this.services = const [],
  });

  // Optional: Convert from JSON
  factory ClinicCategory.fromJson(Map<String, dynamic> json) {
    return ClinicCategory(
      id: json['id'] as String,
      name: json['name'] as String,
      iconPath: json['iconPath'] as String,
      services: (json['services'] as List?)
          ?.map((serviceJson) => Service.fromJson(serviceJson))
          .toList() ?? [],
    );
  }

  // Optional: Convert to JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'iconPath': iconPath,
      'services': services.map((service) => service.toJson()).toList(),
    };
  }
}