import 'package:flutter/material.dart';

class CustomPageTransitionsBuilder extends PageTransitionsBuilder {
  const CustomPageTransitionsBuilder();

  @override
  Widget buildTransitions<T>(
    PageRoute<T> route,
    BuildContext context,
    Animation<double> animation,
    Animation<double> secondaryAnimation,
    Widget child,
  ) {
    final tween = Tween(begin: 0.0, end: 1.0).chain(
      CurveTween(curve: Curves.easeOutCubic),
    );
    
    return Stack(
      children: [
        // Scale and fade the outgoing page
        ScaleTransition(
          scale: Tween<double>(
            begin: 1.0,
            end: 0.95,
          ).animate(
            CurvedAnimation(
              parent: secondaryAnimation,
              curve: Curves.easeOutCubic,
            ),
          ),
          child: FadeTransition(
            opacity: Tween<double>(
              begin: 1.0,
              end: 0.5,
            ).animate(
              CurvedAnimation(
                parent: secondaryAnimation,
                curve: Curves.easeOutCubic,
              ),
            ),
            child: Container(
              color: Theme.of(context).scaffoldBackgroundColor,
            ),
          ),
        ),
        
        // Slide and fade the incoming page
        SlideTransition(
          position: Tween<Offset>(
            begin: const Offset(0, 0.1),
            end: Offset.zero,
          ).animate(animation),
          child: FadeTransition(
            opacity: tween.animate(animation),
            child: child,
          ),
        ),
      ],
    );
  }
}

// Custom route for hero transitions with scale effect
class HeroDialogRoute<T> extends PageRoute<T> {
  HeroDialogRoute({
    required this.builder,
    this.onBackgroundTap,
  }) : super();

  final WidgetBuilder builder;
  final VoidCallback? onBackgroundTap;

  @override
  bool get opaque => false;

  @override
  bool get barrierDismissible => true;

  @override
  Duration get transitionDuration => const Duration(milliseconds: 400);

  @override
  bool get maintainState => true;

  @override
  Color get barrierColor => Colors.black54;

  @override
  String? get barrierLabel => null;

  @override
  Widget buildTransitions(
    BuildContext context,
    Animation<double> animation,
    Animation<double> secondaryAnimation,
    Widget child,
  ) {
    return Stack(
      children: [
        GestureDetector(
          onTap: onBackgroundTap,
          child: FadeTransition(
            opacity: CurvedAnimation(
              parent: animation,
              curve: Curves.easeOut,
            ),
            child: Container(
              color: barrierColor,
            ),
          ),
        ),
        ScaleTransition(
          scale: CurvedAnimation(
            parent: animation,
            curve: Curves.easeOutBack,
          ),
          child: FadeTransition(
            opacity: CurvedAnimation(
              parent: animation,
              curve: const Interval(0.0, 0.8),
            ),
            child: child,
          ),
        ),
      ],
    );
  }

  @override
  Widget buildPage(
    BuildContext context,
    Animation<double> animation,
    Animation<double> secondaryAnimation,
  ) {
    return builder(context);
  }
}

// Extension method for smooth navigation
extension NavigatorExtension on BuildContext {
  Future<T?> pushWithTransition<T extends Object?>(
    Widget page, {
    Duration duration = const Duration(milliseconds: 300),
    bool fullscreenDialog = false,
  }) {
    return Navigator.of(this).push<T>(
      PageRouteBuilder(
        fullscreenDialog: fullscreenDialog,
        transitionDuration: duration,
        pageBuilder: (context, animation, secondaryAnimation) => page,
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          final fadeAnimation = CurvedAnimation(
            parent: animation,
            curve: Curves.easeOutCubic,
          );

          return Stack(
            children: [
              FadeTransition(
                opacity: Tween<double>(
                  begin: 0.0,
                  end: 1.0,
                ).animate(fadeAnimation),
                child: child,
              ),
              FadeTransition(
                opacity: Tween<double>(
                  begin: 1.0,
                  end: 0.0,
                ).animate(fadeAnimation),
                child: Container(
                  color: Theme.of(context).scaffoldBackgroundColor,
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}