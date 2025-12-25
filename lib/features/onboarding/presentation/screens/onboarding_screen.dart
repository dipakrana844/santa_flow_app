import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/utils/shared_preferences_helper.dart';
import '../widgets/onboarding_page.dart';
import '../../../../core/constants/app_constants.dart';

/// Screen for onboarding flow
class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final PageController _pageController = PageController();
  int _currentPage = 0;

  final List<OnboardingPage> _pages = [
    const OnboardingPage(
      title: 'Welcome to Secret Santa!',
      description:
          'Organize your Secret Santa gift exchange with ease. Add participants, generate matches, and reveal them with QR codes.',
      icon: Icons.card_giftcard,
      color: Colors.red,
    ),
    const OnboardingPage(
      title: 'Add Participants',
      description:
          'Start by adding all participants to your event. Each person needs a name and email address.',
      icon: Icons.people,
      color: Colors.green,
    ),
    const OnboardingPage(
      title: 'Generate Matches',
      description:
          'Once you have at least 3 participants, generate random matches. The algorithm ensures no one gets themselves!',
      icon: Icons.shuffle,
      color: Colors.blue,
    ),
    const OnboardingPage(
      title: 'Reveal with QR Codes',
      description:
          'Each participant gets a unique QR code. Scan it to reveal your Secret Santa match!',
      icon: Icons.qr_code,
      color: Colors.orange,
    ),
  ];

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void _nextPage() {
    if (_currentPage < _pages.length - 1) {
      _pageController.nextPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    } else {
      _completeOnboarding();
    }
  }

  void _skipOnboarding() {
    _completeOnboarding();
  }

  Future<void> _completeOnboarding() async {
    await SharedPreferencesHelper.setOnboardingCompleted();
    if (mounted) {
      context.go(AppConstants.homeRoute);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            // Skip button
            Align(
              alignment: Alignment.topRight,
              child: TextButton(
                onPressed: _skipOnboarding,
                child: const Text('Skip'),
              ),
            ),

            // Page view
            Expanded(
              child: PageView.builder(
                controller: _pageController,
                onPageChanged: (index) {
                  setState(() {
                    _currentPage = index;
                  });
                },
                itemCount: _pages.length,
                itemBuilder: (context, index) => _pages[index],
              ),
            ),

            // Page indicator
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(
                _pages.length,
                (index) => Container(
                  margin: const EdgeInsets.symmetric(horizontal: 4),
                  width: _currentPage == index ? 24 : 8,
                  height: 8,
                  decoration: BoxDecoration(
                    color: _currentPage == index
                        ? Theme.of(context).colorScheme.primary
                        : Colors.grey.shade300,
                    borderRadius: BorderRadius.circular(4),
                  ),
                ),
              ),
            ),

            const SizedBox(height: 32),

            // Next/Get Started button
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
              child: SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _nextPage,
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                  ),
                  child: Text(
                    _currentPage == _pages.length - 1 ? 'Get Started' : 'Next',
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
