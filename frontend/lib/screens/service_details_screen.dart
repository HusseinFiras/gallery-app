import 'package:flutter/material.dart';
import '../models/clinic_category.dart';
import '../models/service.dart';

class ServiceDetailsScreen extends StatefulWidget {
  final ClinicCategory category;
  
  const ServiceDetailsScreen({
    Key? key,
    required this.category,
  }) : super(key: key);

  @override
  State<ServiceDetailsScreen> createState() => _ServiceDetailsScreenState();
}

class _ServiceDetailsScreenState extends State<ServiceDetailsScreen> with TickerProviderStateMixin {
  late PageController _pageController;
  late AnimationController _previewController;
  Service? _selectedService;
  double _currentPage = 0;
  
  @override
  void initState() {
    super.initState();
    _pageController = PageController(
      viewportFraction: 0.75,  // Reduced from 0.85 to make cards smaller
    )..addListener(() {
      setState(() {
        _currentPage = _pageController.page ?? 0;
      });
    });

    _previewController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );
  }

  Future<void> _handleServiceTap(Service service) async {
    if (_selectedService == service) {
      await _previewController.reverse();
      if (mounted) {
        setState(() => _selectedService = null);
      }
    } else {
      setState(() => _selectedService = service);
      _previewController.forward();
    }
  }

  Widget _buildServiceCard(Service service, int index) {
    final difference = (index - _currentPage).abs();
    final opacity = 1 - (difference * 0.3).clamp(0.0, 0.3);

    return Opacity(
      opacity: opacity,
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 8),
        width: 300,
        height: 450, // Adjusted for vertical image
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 8,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(20),
          child: Image.asset(
            service.imagePath,
            fit: BoxFit.cover,
          ),
        ),
      ),
    );
  }

  Widget _buildPreviewOverlay() {
    if (_selectedService == null) return const SizedBox.shrink();

    return AnimatedBuilder(
      animation: _previewController,
      builder: (context, child) {
        return Positioned.fill(
          child: GestureDetector(
            onTap: () => _handleServiceTap(_selectedService!),
            child: Container(
              color: Colors.black.withOpacity(_previewController.value * 0.5),
              child: Center(
                child: Hero(
                  tag: 'service_${_selectedService!.id}',
                  child: Container(
                    margin: const EdgeInsets.symmetric(horizontal: 32),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.2),
                          blurRadius: 20,
                          offset: const Offset(0, 10),
                        ),
                      ],
                    ),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        ClipRRect(
                          borderRadius: const BorderRadius.vertical(
                            top: Radius.circular(20),
                          ),
                          child: AspectRatio(
                            aspectRatio: 16 / 9,
                            child: Image.asset(
                              _selectedService!.imagePath,
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(16),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                _selectedService!.name,
                                style: const TextStyle(
                                  color: Color(0xFF1A374D),
                                  fontSize: 24,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Color(0xFF1A374D), Color(0xFF406882)],
        ),
      ),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: Stack(
          children: [
            SafeArea(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(24.0),
                    child: Row(
                      children: [
                        IconButton(
                          icon: const Icon(Icons.arrow_back_ios_new, 
                            color: Colors.white, 
                            size: 24,
                          ),
                          onPressed: () => Navigator.of(context).pop(),
                        ),
                        const SizedBox(width: 16),
                        Text(
                          widget.category.name.toUpperCase(),
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            letterSpacing: 1.2,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Expanded(
                    child: AnimatedBuilder(
                      animation: _pageController,
                      builder: (context, child) {
                        return TweenAnimationBuilder(
                          duration: const Duration(milliseconds: 300),
                          tween: Tween<double>(begin: 0, end: 1),
                          builder: (context, double value, child) {
                            return Transform.scale(
                              scale: 0.9 + (0.1 * value),
                              child: SizedBox(  // Added SizedBox with fixed height
                                height: 450,   // Match card height
                                child: PageView.builder(
                                  controller: _pageController,
                                  itemCount: widget.category.services.length,
                                  itemBuilder: (context, index) => _buildServiceCard(
                                    widget.category.services[index],
                                    index,
                                  ),
                                ),
                              ),
                            );
                          },
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
            _buildPreviewOverlay(),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _pageController.dispose();
    _previewController.dispose();
    super.dispose();
  }
}