import 'package:flutter/material.dart';

class StartViewModel extends ChangeNotifier {
  final List<String> _texts = [
    "Welcome to",
    "Vision Fit",
  ];

  List<String> get texts => _texts;
  
  late AnimationController _firstTextController;
  late AnimationController _secondTextController;
  late AnimationController _firstSlideController;
  late AnimationController _secondSlideController;
  late AnimationController _buttonController;
  
  late Animation<double> _firstTextAnimation;
  late Animation<double> _secondTextAnimation;
  late Animation<Offset> _firstSlideAnimation;
  late Animation<Offset> _secondSlideAnimation;
  late Animation<double> _buttonAnimation;

  void initializeAnimations(TickerProvider vsync) {
    _firstTextController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: vsync,
    );

    _secondTextController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: vsync,
    );

    _firstTextAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _firstTextController,
      curve: Curves.easeInOut,
    ));

    _secondTextAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _secondTextController,
      curve: Curves.easeInOut,
    ));

    _firstSlideController = AnimationController(
      vsync: vsync,
      duration: const Duration(milliseconds: 1000),
    );

    _secondSlideController = AnimationController(
      vsync: vsync,
      duration: const Duration(milliseconds: 1000),
    );

    _buttonController = AnimationController(
      vsync: vsync,
      duration: const Duration(milliseconds: 1500),
    );

    _firstSlideAnimation = Tween<Offset>(
      begin: const Offset(-1.0, 0.0),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _firstSlideController,
      curve: Curves.easeOut,
    ));

    _secondSlideAnimation = Tween<Offset>(
      begin: const Offset(1.0, 0.0),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _secondSlideController,
      curve: Curves.easeOut,
    ));

    _buttonAnimation = CurvedAnimation(
      parent: _buttonController,
      curve: Curves.elasticOut,
    );

    // Animasyonları sırayla başlat
    Future.delayed(const Duration(milliseconds: 500), () {
      _firstSlideController.forward();
      _firstTextController.forward();
    });

    Future.delayed(const Duration(milliseconds: 1000), () {
      _secondSlideController.forward();
      _secondTextController.forward();
    });

    Future.delayed(const Duration(milliseconds: 1500), () {
      _buttonController.forward();
    });
  }

  Animation<double> get firstTextAnimation => _firstTextAnimation;
  Animation<double> get secondTextAnimation => _secondTextAnimation;
  Animation<Offset> get firstSlideAnimation => _firstSlideAnimation;
  Animation<Offset> get secondSlideAnimation => _secondSlideAnimation;
  Animation<double> get buttonAnimation => _buttonAnimation;

  @override
  void dispose() {
    _firstTextController.dispose();
    _secondTextController.dispose();
    _firstSlideController.dispose();
    _secondSlideController.dispose();
    _buttonController.dispose();
    super.dispose();
  }
} 