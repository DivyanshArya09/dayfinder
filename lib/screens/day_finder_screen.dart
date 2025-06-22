import 'package:dayfinder/components/custom_input.dart';
import 'package:dayfinder/logic/logic.dart';
import 'package:dayfinder/utils/validators.dart';
import 'package:flutter/material.dart';

class DayFinderScreen extends StatefulWidget {
  const DayFinderScreen({super.key});

  @override
  State<DayFinderScreen> createState() => _DayFinderScreenState();
}

class _DayFinderScreenState extends State<DayFinderScreen>
    with TickerProviderStateMixin {
  final _formKey = GlobalKey<FormState>();
  final dayController = TextEditingController();
  final monthController = TextEditingController();
  final yearController = TextEditingController();

  String? result;
  late AnimationController _fadeController;
  late AnimationController _slideController;
  late AnimationController _resultController;
  late AnimationController _buttonController;

  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;
  late Animation<double> _resultAnimation;
  late Animation<double> _buttonScaleAnimation;

  @override
  void initState() {
    super.initState();
    _fadeController = AnimationController(
      duration: const Duration(milliseconds: 1200),
      vsync: this,
    );
    _slideController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );
    _resultController = AnimationController(
      duration: const Duration(milliseconds: 600),
      vsync: this,
    );
    _buttonController = AnimationController(
      duration: const Duration(milliseconds: 200),
      vsync: this,
    );

    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _fadeController,
      curve: Curves.easeOutCubic,
    ));

    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.3),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _slideController,
      curve: Curves.easeOutCubic,
    ));

    _resultAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _resultController,
      curve: Curves.elasticOut,
    ));

    _buttonScaleAnimation = Tween<double>(
      begin: 1.0,
      end: 0.95,
    ).animate(CurvedAnimation(
      parent: _buttonController,
      curve: Curves.easeInOut,
    ));

    // Start initial animations
    _fadeController.forward();
    Future.delayed(const Duration(milliseconds: 300), () {
      _slideController.forward();
    });
  }

  @override
  void dispose() {
    _fadeController.dispose();
    _slideController.dispose();
    _resultController.dispose();
    _buttonController.dispose();
    dayController.dispose();
    monthController.dispose();
    yearController.dispose();
    super.dispose();
  }

  void findDay() async {
    if (_formKey.currentState?.validate() ?? false) {
      // Button press animation
      _buttonController.forward().then((_) {
        _buttonController.reverse();
      });

      final int day = int.parse(dayController.text);
      final int month = int.parse(monthController.text);
      final int year = int.parse(yearController.text);

      final inputDate = DateTime(year, month, day);
      final today = DateTime.now();
      final todayOnly =
          DateTime(today.year, today.month, today.day); // Normalize

      bool isToday = inputDate == todayOnly;
      bool isPast = inputDate.isBefore(todayOnly);
      bool isFuture = inputDate.isAfter(todayOnly);

      try {
        final weekday = Logic.calculateDay(year: year, month: month, day: day);

        setState(() {
          if (isToday) {
            result = "That's Today! ($weekday)";
          } else if (isPast) {
            result = "It was a $weekday.";
          } else if (isFuture) {
            result = "It will be a $weekday.";
          } else {
            result = "That's $weekday!";
          }
        });

        // Animate result appearance
        _resultController.reset();
        _resultController.forward();
      } catch (_) {
        setState(() => result = "Invalid date!");
        _resultController.reset();
        _resultController.forward();
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Scaffold(
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(height: 40),

              // Animated Title
              FadeTransition(
                opacity: _fadeAnimation,
                child: SlideTransition(
                  position: _slideAnimation,
                  child: Column(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(20),
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          gradient: LinearGradient(
                            colors: [
                              Colors.blue.shade400,
                              Colors.purple.shade400,
                            ],
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.blue.withOpacity(0.3),
                              blurRadius: 20,
                              offset: const Offset(0, 10),
                            ),
                          ],
                        ),
                        child: const Icon(
                          Icons.calendar_today_rounded,
                          size: 40,
                          color: Colors.white,
                        ),
                      ),
                      const SizedBox(height: 24),
                      ShaderMask(
                        shaderCallback: (bounds) => LinearGradient(
                          colors: [
                            Colors.blue.shade600,
                            Colors.purple.shade600,
                          ],
                        ).createShader(bounds),
                        child: const Text(
                          "DayFinder",
                          style: TextStyle(
                            fontSize: 36,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        "Discover what day it was, is, or will be—instantly!",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 16,
                          color: isDark
                              ? Colors.grey.shade400
                              : Colors.grey.shade600,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 60),

              // Animated Form Container
              FadeTransition(
                opacity: _fadeAnimation,
                child: SlideTransition(
                  position: _slideAnimation,
                  child: Container(
                    padding: const EdgeInsets.all(32),
                    decoration: BoxDecoration(
                      color: isDark
                          ? Colors.white.withOpacity(0.05)
                          : Colors.white.withOpacity(0.8),
                      borderRadius: BorderRadius.circular(24),
                      border: Border.all(
                        color: isDark
                            ? Colors.white.withOpacity(0.1)
                            : Colors.white.withOpacity(0.3),
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: isDark
                              ? Colors.black.withOpacity(0.3)
                              : Colors.black.withOpacity(0.1),
                          blurRadius: 30,
                          offset: const Offset(0, 15),
                        ),
                      ],
                    ),
                    child: Form(
                      key: _formKey,
                      child: Column(
                        children: [
                          Row(
                            children: [
                              Expanded(
                                child: CustomInputField(
                                  label: "Day",
                                  hint: "DD",
                                  controller: dayController,
                                  keyboardType: TextInputType.number,
                                  validator: DateValidators.validateDay,
                                  maxLength: 2,
                                ),
                              ),
                              const SizedBox(width: 16),
                              Expanded(
                                child: CustomInputField(
                                  label: "Month",
                                  hint: "MM",
                                  controller: monthController,
                                  keyboardType: TextInputType.number,
                                  validator: DateValidators.validateMonth,
                                  maxLength: 2,
                                ),
                              ),
                              const SizedBox(width: 16),
                              Expanded(
                                flex: 2,
                                child: CustomInputField(
                                  label: "Year",
                                  hint: "YYYY",
                                  controller: yearController,
                                  keyboardType: TextInputType.number,
                                  validator: DateValidators.validateYear,
                                  maxLength: 4,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 32),

                          // Animated Button
                          ScaleTransition(
                            scale: _buttonScaleAnimation,
                            child: Container(
                              width: double.infinity,
                              height: 56,
                              decoration: BoxDecoration(
                                gradient: LinearGradient(
                                  colors: [
                                    Colors.blue.shade500,
                                    Colors.purple.shade500,
                                  ],
                                ),
                                borderRadius: BorderRadius.circular(16),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.blue.withOpacity(0.3),
                                    blurRadius: 15,
                                    offset: const Offset(0, 8),
                                  ),
                                ],
                              ),
                              child: Material(
                                color: Colors.transparent,
                                child: InkWell(
                                  onTap: findDay,
                                  borderRadius: BorderRadius.circular(16),
                                  child: const Center(
                                    child: Text(
                                      "Find Day",
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 18,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 40),

              if (result != null)
                ScaleTransition(
                  scale: _resultAnimation,
                  child: FadeTransition(
                    opacity: _resultAnimation,
                    child: Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(32),
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: result!.contains("Invalid")
                              ? [
                                  Colors.red.shade400,
                                  Colors.orange.shade400,
                                ]
                              : [
                                  Colors.green.shade400,
                                  Colors.teal.shade400,
                                ],
                        ),
                        borderRadius: BorderRadius.circular(20),
                        boxShadow: [
                          BoxShadow(
                            color: (result!.contains("Invalid")
                                    ? Colors.red
                                    : Colors.green)
                                .withOpacity(0.3),
                            blurRadius: 20,
                            offset: const Offset(0, 10),
                          ),
                        ],
                      ),
                      child: Column(
                        children: [
                          Icon(
                            result!.contains("Invalid")
                                ? Icons.error_outline_rounded
                                : Icons.check_circle_outline_rounded,
                            color: Colors.white,
                            size: 40,
                          ),
                          const SizedBox(height: 16),
                          Text(
                            result!,
                            style: const TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              const SizedBox(height: 40),
              FadeTransition(
                opacity: _fadeAnimation,
                child: Container(
                  height: 4,
                  width: 60,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        Colors.blue.shade400,
                        Colors.purple.shade400,
                      ],
                    ),
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }
}
