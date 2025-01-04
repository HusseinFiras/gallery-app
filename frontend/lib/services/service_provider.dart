// lib/providers/service_provider.dart
import 'package:flutter/foundation.dart';
import '../models/clinic_category.dart';
import '../models/service.dart';
import '../services/local_service_repository.dart';

class ServiceProvider with ChangeNotifier {
  final ServiceRepository _repository = ServiceRepository();

  // State variables
  List<ClinicCategory> _categories = [];
  List<Service> _currentCategoryServices = [];
  Service? _selectedService;
  bool _isLoading = false;
  String? _error;

  // Getters
  List<ClinicCategory> get categories => _categories;
  List<Service> get currentCategoryServices => _currentCategoryServices;
  Service? get selectedService => _selectedService;
  bool get isLoading => _isLoading;
  String? get error => _error;

  // Load all categories
  Future<void> loadCategories() async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      _categories = await _repository.getCategories();
      _isLoading = false;
    } catch (e) {
      _isLoading = false;
      _error = 'Failed to load categories: ${e.toString()}';
    }
    notifyListeners();
  }

  // Load services for a specific category
  Future<void> loadServicesByCategory(String categoryId) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      _currentCategoryServices = await _repository.getServicesByCategory(categoryId);
      _isLoading = false;
    } catch (e) {
      _isLoading = false;
      _error = 'Failed to load services: ${e.toString()}';
    }
    notifyListeners();
  }

  // Select a specific service
  void selectService(Service service) {
    _selectedService = service;
    notifyListeners();
  }

  // Clear selected service
  void clearSelectedService() {
    _selectedService = null;
    notifyListeners();
  }

  // Add a new category (optional)
  Future<void> addCategory(ClinicCategory category) async {
    try {
      await _repository.addCategory(category);
      _categories.add(category);
      notifyListeners();
    } catch (e) {
      _error = 'Failed to add category: ${e.toString()}';
      notifyListeners();
    }
  }

  // Add a new service to a category (optional)
  Future<void> addService(Service service) async {
    try {
      await _repository.addService(service);
      // Find the category and add the service
      final categoryIndex = _categories.indexWhere((cat) => cat.id == service.categoryId);
      if (categoryIndex != -1) {
        _categories[categoryIndex].services.add(service);
      }
      notifyListeners();
    } catch (e) {
      _error = 'Failed to add service: ${e.toString()}';
      notifyListeners();
    }
  }
}