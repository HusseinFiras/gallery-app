import 'package:flutter/material.dart';
import '../models/clinic_category.dart';
import '../services/local_service_repository.dart';
import 'dart:math' as math;

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with TickerProviderStateMixin {
  List<ClinicCategory> categories = [];
  double _dragPosition = 0;
  double _dragPercentage = 0;
  late AnimationController _swipeController;
  late Animation<Offset> _swipeAnimation;
  int _currentIndex = 0;

  @override
  void initState() {
    super.initState();
    _swipeController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
    _swipeAnimation = Tween<Offset>(
      begin: Offset.zero,
      end: Offset.zero,
    ).animate(_swipeController);
    _loadCategories();
  }

  Future<void> _loadCategories() async {
    final repository = ServiceRepository();
    final loadedCategories = await repository.getCategories();
    setState(() {
      categories = loadedCategories;
    });
  }

  void _onHorizontalDragUpdate(DragUpdateDetails details) {
    final size = context.size;
    if (size == null) return;
    
    setState(() {
      _dragPosition += details.delta.dx;
      _dragPercentage = _dragPosition / size.width;
    });
  }

  void _onHorizontalDragEnd(DragEndDetails details) {
    final size = context.size;
    if (size == null) return;

    final velocity = details.velocity.pixelsPerSecond.dx;
    if (_dragPosition.abs() > size.width * 0.4 || velocity.abs() > 1000) {
      double endPosition = size.width * _dragPosition.sign;
      _swipeAnimation = Tween<Offset>(
        begin: Offset(_dragPosition, 0),
        end: Offset(endPosition, 0),
      ).animate(_swipeController);
      
      _swipeController.forward().then((_) {
        setState(() {
          if (_currentIndex < categories.length - 1) {
            _currentIndex++;
          }
          _dragPosition = 0;
          _dragPercentage = 0;
          _swipeController.reset();
        });
      });
    } else {
      _swipeAnimation = Tween<Offset>(
        begin: Offset(_dragPosition, 0),
        end: Offset.zero,
      ).animate(_swipeController);
      
      _swipeController.forward().then((_) {
        setState(() {
          _dragPosition = 0;
          _dragPercentage = 0;
        });
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: categories.isEmpty
          ? const Center(child: CircularProgressIndicator())
          : Stack(
              children: [
                // Background
                Container(
                  decoration: const BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [Color(0xFF1A1A1A), Colors.black],
                    ),
                  ),
                ),
                // Content
                SafeArea(
                  child: Column(
                    children: [
                      const SizedBox(height: 20),
                      // App Bar
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text(
                              'Medical Services',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 28,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            IconButton(
                              icon: const Icon(Icons.settings, color: Colors.white),
                              onPressed: () {},
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 20),
                      // Swipeable Cards
                      Expanded(
                        child: Stack(
                          alignment: Alignment.center,
                          children: List.generate(2, (index) {
                            final itemIndex = _currentIndex + index;
                            if (itemIndex >= categories.length) return const SizedBox();
                            
                            final category = categories[itemIndex];
                            final isTop = index == 0;
                            
                            return AnimatedBuilder(
                              animation: _swipeController,
                              builder: (context, child) {
                                final slideOffset = isTop ? _swipeAnimation.value : Offset.zero;
                                return _buildCard(
                                  category,
                                  isTop,
                                  index,
                                  slideOffset,
                                );
                              },
                            );
                          }),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
    );
  }

  Widget _buildCard(ClinicCategory category, bool isTop, int index, Offset slideOffset) {
    final screenSize = MediaQuery.of(context).size;
    final cardWidth = screenSize.width * 0.9;
    final cardHeight = screenSize.height * 0.6;

    return Positioned(
      top: 0,
      child: GestureDetector(
        onHorizontalDragUpdate: isTop ? _onHorizontalDragUpdate : null,
        onHorizontalDragEnd: isTop ? _onHorizontalDragEnd : null,
        child: Transform.translate(
          offset: isTop ? Offset(_dragPosition + slideOffset.dx, 0) : Offset.zero,
          child: Transform.rotate(
            angle: isTop ? _dragPercentage * 0.3 : 0,
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 300),
              width: cardWidth,
              height: cardHeight,
              margin: EdgeInsets.only(top: index * 20),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.3),
                    blurRadius: 10,
                    spreadRadius: 2,
                  ),
                ],
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    Colors.blue.withOpacity(0.8),
                    Colors.purple.withOpacity(0.8),
                  ],
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Category Image/Icon
                  Expanded(
                    flex: 3,
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.1),
                        borderRadius: const BorderRadius.only(
                          topLeft: Radius.circular(20),
                          topRight: Radius.circular(20),
                        ),
                      ),
                      child: Center(
                        child: Icon(
                          _getCategoryIcon(category.name),
                          size: 80,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                  // Category Details
                  Expanded(
                    flex: 2,
                    child: Padding(
                      padding: const EdgeInsets.all(20),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            category.name,
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 32,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 10),
                          Text(
                            '${category.services.length} Services Available',
                            style: TextStyle(
                              color: Colors.white.withOpacity(0.8),
                              fontSize: 18,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  IconData _getCategoryIcon(String categoryName) {
    switch (categoryName.toLowerCase()) {
      case 'general medicine':
        return Icons.medical_services;
      case 'pediatrics':
        return Icons.child_care;
      case 'cardiology':
        return Icons.favorite;
      case 'dermatology':
        return Icons.face;
      case 'neurology':
        return Icons.psychology;
      case 'orthopedics':
        return Icons.accessibility_new;
      default:
        return Icons.local_hospital;
    }
  }

  @override
  void dispose() {
    _swipeController.dispose();
    super.dispose();
  }
}