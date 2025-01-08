import '../models/clinic_category.dart';
import '../models/service.dart';

class ServiceRepository {
  // Hardcoded initial data
  static final List<ClinicCategory> _hardcodedCategories = [
    ClinicCategory(
      id: '1',
      name: 'General Medicine',
      iconPath: 'assets/icons/general_medicine.png',
      services: [
        Service(
          id: 'gm001',
          name: 'Basic Consultation',
          description: 'Initial medical checkup with a general physician',
          price: 50.00,
          durationMinutes: 30,
          categoryId: '1',
          imagePath: 'assets/images/general_medicine_bg.jpg',
        ),
        Service(
          id: 'gm002',
          name: 'Follow-up Consultation',
          description: 'Detailed follow-up medical consultation',
          price: 75.00,
          durationMinutes: 45,
          categoryId: '1',
          imagePath: 'assets/images/general_medicine_bg.jpg',
        ),
        Service(
          id: 'gm003',
          name: 'Annual Checkup',
          description: 'Comprehensive annual health examination',
          price: 120.00,
          durationMinutes: 60,
          categoryId: '1',
          imagePath: 'assets/images/general_medicine_bg.jpg',
        ),
        Service(
          id: 'gm004',
          name: 'Lab Tests Review',
          description: 'Review and interpretation of laboratory results',
          price: 65.00,
          durationMinutes: 30,
          categoryId: '1',
          imagePath: 'assets/images/general_medicine_bg.jpg',
        ),
        Service(
          id: 'gm005',
          name: 'Specialized Consultation',
          description: 'In-depth consultation for specific conditions',
          price: 90.00,
          durationMinutes: 45,
          categoryId: '1',
          imagePath: 'assets/images/general_medicine_bg.jpg',
        ),
        Service(
          id: 'gm006',
          name: 'Health Screening',
          description: 'Preventive health screening and assessment',
          price: 150.00,
          durationMinutes: 75,
          categoryId: '1',
          imagePath: 'assets/images/general_medicine_bg.jpg',
        ),
        Service(
          id: 'gm007',
          name: 'Vaccination Service',
          description: 'Routine and travel vaccination services',
          price: 45.00,
          durationMinutes: 20,
          categoryId: '1',
          imagePath: 'assets/images/general_medicine_bg.jpg',
        ),
        Service(
          id: 'gm008',
          name: 'Medical Certificate',
          description: 'Medical fitness certification and documentation',
          price: 40.00,
          durationMinutes: 25,
          categoryId: '1',
          imagePath: 'assets/images/general_medicine_bg.jpg',
        ),
      ],
    ),
    ClinicCategory(
      id: '2',
      name: 'Pediatrics',
      iconPath: 'assets/icons/pediatrics.png',
      services: [
        Service(
          id: 'pd001',
          name: 'Child Wellness Check',
          description: 'Comprehensive health checkup for children',
          price: 100.00,
          durationMinutes: 60,
          categoryId: '2',
          imagePath: 'assets/images/general_medicine_bg.jpg',
        )
      ],
    ),
    ClinicCategory(
      id: '3',
      name: 'Cardiology',
      iconPath: 'assets/icons/cardiology.png',
      services: [
        Service(
          id: 'cd001',
          name: 'Heart Check',
          description: 'Complete cardiac evaluation and assessment',
          price: 150.00,
          durationMinutes: 45,
          categoryId: '3',
          imagePath: 'assets/images/general_medicine_bg.jpg',
        ),
        Service(
          id: 'cd002',
          name: 'ECG Test',
          description: 'Electrocardiogram with detailed report',
          price: 80.00,
          durationMinutes: 30,
          categoryId: '3',
          imagePath: 'assets/images/general_medicine_bg.jpg',
        )
      ],
    ),
    ClinicCategory(
      id: '4',
      name: 'Dermatology',
      iconPath: 'assets/icons/dermatology.png',
      services: [
        Service(
          id: 'dm001',
          name: 'Skin Consultation',
          description: 'Complete skin examination and treatment plan',
          price: 120.00,
          durationMinutes: 30,
          categoryId: '4',
          imagePath: 'assets/images/general_medicine_bg.jpg',
        ),
        Service(
          id: 'dm002',
          name: 'Acne Treatment',
          description: 'Specialized acne assessment and treatment',
          price: 90.00,
          durationMinutes: 45,
          categoryId: '4',
          imagePath: 'assets/images/general_medicine_bg.jpg',
        )
      ],
    ),
    ClinicCategory(
      id: '5',
      name: 'Orthopedics',
      iconPath: 'assets/icons/orthopedics.png',
      services: [
        Service(
          id: 'or001',
          name: 'Joint Assessment',
          description: 'Complete joint and bone examination',
          price: 130.00,
          durationMinutes: 40,
          categoryId: '5',
          imagePath: 'assets/images/general_medicine_bg.jpg',
        ),
        Service(
          id: 'or002',
          name: 'Physical Therapy',
          description: 'Therapeutic exercise and rehabilitation session',
          price: 85.00,
          durationMinutes: 60,
          categoryId: '5',
          imagePath: 'assets/images/general_medicine_bg.jpg',
        )
      ],
    ),
    ClinicCategory(
      id: '6',
      name: 'Neurology',
      iconPath: 'assets/icons/neurology.png',
      services: [
        Service(
          id: 'nr001',
          name: 'Neurological Exam',
          description: 'Comprehensive nervous system evaluation',
          price: 180.00,
          durationMinutes: 60,
          categoryId: '6',
          imagePath: 'assets/images/general_medicine_bg.jpg',
        ),
        Service(
          id: 'nr002',
          name: 'Headache Consultation',
          description: 'Specialized headache assessment and treatment plan',
          price: 120.00,
          durationMinutes: 45,
          categoryId: '6',
          imagePath: 'assets/images/general_medicine_bg.jpg',
        )
      ],
    ),
  ];

  // Method to get all categories
  Future<List<ClinicCategory>> getCategories() async {
    // Simulate network delay
    await Future.delayed(const Duration(milliseconds: 300));
    return _hardcodedCategories;
  }

  // Method to get services by category
  Future<List<Service>> getServicesByCategory(String categoryId) async {
    // Simulate network delay
    await Future.delayed(const Duration(milliseconds: 300));
    return _hardcodedCategories
        .firstWhere((category) => category.id == categoryId)
        .services;
  }

  // Future expansion points for database/API integration
  Future<void> addCategory(ClinicCategory category) async {
    // Placeholder for adding a new category
    _hardcodedCategories.add(category);
  }

  Future<void> addService(Service service) async {
    // Placeholder for adding a new service
    final category = _hardcodedCategories
        .firstWhere((cat) => cat.id == service.categoryId);
    category.services.add(service);
  }
}