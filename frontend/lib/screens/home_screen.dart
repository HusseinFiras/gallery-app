import 'package:flutter/material.dart';
import '../models/clinic_category.dart';
import '../services/local_service_repository.dart';
import 'service_details_screen.dart';
import 'dart:async';
import 'package:animations/animations.dart';  // Add this import

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with TickerProviderStateMixin {
  List<ClinicCategory> _categories = [];
  int _currentIndex = 0;
  late PageController _pageController;
  double _currentPage = 0;
  Timer? _autoScrollTimer;
  bool _isUserInteracting = false;

  @override
  void initState() {
    super.initState();
    _loadCategories();
    _pageController = PageController(
      initialPage: 1000,
      viewportFraction: 0.93,
    )..addListener(() {
        setState(() {
          _currentPage = _pageController.page ?? 0;
        });
      });
    
    // Start auto-scroll after a brief delay
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _startAutoScroll();
    });
  }

  void _startAutoScroll() {
    // Cancel any existing timer
    _autoScrollTimer?.cancel();
    
    // Create new timer for auto-scroll with longer interval (5 seconds)
    _autoScrollTimer = Timer.periodic(const Duration(milliseconds: 5000), (timer) {
      if (!_isUserInteracting && _pageController.hasClients) {
        final nextPage = _pageController.page! + 1;
        _pageController.animateToPage(
          nextPage.toInt(),
          duration: const Duration(milliseconds: 600), // Reduced animation duration
          curve: Curves.easeInOutCubic,
        );
      }
    });
  }

  Future<void> _loadCategories() async {
    final repository = ServiceRepository();
    final loadedCategories = await repository.getCategories();
    setState(() {
      _categories = loadedCategories;
    });
  }

  Widget _buildPageIndicator() {
    if (_categories.isEmpty) return const SizedBox.shrink();
    return SizedBox(
      height: 16,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: List.generate(_categories.length, (index) {
          final currentRealIndex = _currentIndex % _categories.length;
          return Container(
            margin: const EdgeInsets.symmetric(horizontal: 6),
            child: TweenAnimationBuilder<double>(
              duration: const Duration(milliseconds: 300),
              curve: Curves.easeOutCubic,
              tween: Tween<double>(
                begin: 0,
                end: index == currentRealIndex ? 1.0 : 0.0,
              ),
              builder: (context, value, child) {
                return Container(
                  width: value * 36 + 16,
                  height: 16,
                  decoration: BoxDecoration(
                    color: index == currentRealIndex 
                        ? Colors.white 
                        : Colors.white.withOpacity(0.4),
                    borderRadius: BorderRadius.circular(4),
                    boxShadow: index == currentRealIndex ? [
                      BoxShadow(
                        color: Colors.white.withOpacity(0.2),
                        blurRadius: 4,
                        spreadRadius: 1,
                      )
                    ] : null,
                  ),
                );
              },
            ),
          );
        }),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Color(0xFF1A374D),
            Color(0xFF406882),
          ],
        ),
      ),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(
                height: 1200,
                child: Listener(
                  onPointerDown: (_) {
                    _isUserInteracting = true;
                    _autoScrollTimer?.cancel();
                  },
                  onPointerUp: (_) {
                    _isUserInteracting = false;
                    _startAutoScroll();
                  },
                  child: PageView.builder(
                    controller: _pageController,
                    onPageChanged: (index) {
                      setState(() {
                        _currentIndex = index;
                      });
                    },
                    itemBuilder: (context, index) {
                      if (_categories.isEmpty) return const SizedBox.shrink();
                      final category = _categories[index % _categories.length];
                      double difference = (index - _currentPage);
                      
                      return Transform(
                        transform: Matrix4.identity()
                          ..translate(0.0, 0.0, 0.0)
                          ..scale(1.0 - (difference.abs() * 0.2))
                          ..translate(difference * 100),
                        child: Opacity(
                          opacity: 1 - difference.abs().clamp(0.0, 0.7),
                          child: GestureDetector(
                            onTap: () {
                              Navigator.of(context).push(
                                PageRouteBuilder(
                                  pageBuilder: (context, animation, secondaryAnimation) {
                                    return ServiceDetailsScreen(category: category);
                                  },
                                  transitionsBuilder: (context, animation, secondaryAnimation, child) {
                                    var begin = 0.0;
                                    var end = 1.0;
                                    var curve = Curves.easeInOutCubic;

                                    var fadeAnimation = Tween(
                                      begin: begin,
                                      end: end,
                                    ).animate(CurvedAnimation(
                                      parent: animation,
                                      curve: curve,
                                    ));

                                    return FadeTransition(
                                      opacity: fadeAnimation,
                                      child: child,
                                    );
                                  },
                                  transitionDuration: const Duration(milliseconds: 400),
                                ),
                              );
                            },
                            child: Container(
                              margin: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(30),
                                image: index % _categories.length == 0 ? const DecorationImage(
                                  image: AssetImage('assets/images/general_medicine_bg.jpg'),
                                  fit: BoxFit.cover,
                                  colorFilter: ColorFilter.mode(
                                    Colors.black54,
                                    BlendMode.darken,
                                  ),
                                ) : null,
                                gradient: index % _categories.length != 0 ? LinearGradient(
                                  begin: Alignment.topLeft,
                                  end: Alignment.bottomRight,
                                  colors: [
                                    Colors.blue.shade600,
                                    Colors.purple.shade900,
                                  ],
                                ) : null,
                              ),
                              child: Stack(
                                children: [
                                  Positioned(
                                    left: 30,
                                    bottom: 50,
                                    right: 30,
                                    child: Transform.translate(
                                      offset: Offset(
                                        difference * 100,
                                        0,
                                      ),
                                      child: Opacity(
                                        opacity: 1 - difference.abs().clamp(0.0, 0.7),
                                        child: Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            Text(
                                              category.name.toUpperCase(),
                                              style: const TextStyle(
                                                color: Colors.white,
                                                fontSize: 64,
                                                fontWeight: FontWeight.w700,
                                                letterSpacing: 1.5,
                                              ),
                                            ),
                                            const SizedBox(height: 25),
                                            Container(
                                              padding: const EdgeInsets.symmetric(
                                                horizontal: 20,
                                                vertical: 10,
                                              ),
                                              decoration: BoxDecoration(
                                                color: Colors.white24,
                                                borderRadius: BorderRadius.circular(20),
                                              ),
                                              child: Row(
                                                mainAxisSize: MainAxisSize.min,
                                                children: [
                                                  const Icon(
                                                    Icons.medical_services,
                                                    color: Colors.white,
                                                    size: 24,
                                                  ),
                                                  const SizedBox(width: 8),
                                                  Text(
                                                    '${category.services.length}',
                                                    style: const TextStyle(
                                                      color: Colors.white,
                                                      fontSize: 20,
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
                                ],
                              ),
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ),
              const SizedBox(height: 20),
              _buildPageIndicator(),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _autoScrollTimer?.cancel();
    _pageController.dispose();
    super.dispose();
  }
}