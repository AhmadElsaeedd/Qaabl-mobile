import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:stacked/stacked.dart';
import 'onboarding_viewmodel.dart';

class OnboardingView extends StatefulWidget {
  const OnboardingView({Key? key}) : super(key: key);

  @override
  _OnboardingViewState createState() => _OnboardingViewState();
}

class _OnboardingViewState extends State<OnboardingView> {
  int current_step = 1;

  late OnboardingViewModel viewModel; // Declare the view model

  @override
  void initState() {
    super.initState();
    viewModel = OnboardingViewModel(); // Initialize the view model
  }

  void _nextStep() {
    setState(() {
      if (current_step < 3) {
        current_step++;
      } else {
        viewModel.go_to_home();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<OnboardingViewModel>.reactive(
        viewModelBuilder: () => viewModel,
        builder: (context, viewModel, child) {
          return Scaffold(
            backgroundColor: Colors.white,
            body: SafeArea(
              child: Center(
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 25.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Image.asset(
                        'lib/assets/logo.png',
                        height: 150,
                      ),
                      const SizedBox(height: 10),
                      Text(
                        "welcome to Qaabl.",
                        style: GoogleFonts.lexend(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      // Onboarding steps
                      ..._buildOnboardingSteps(),
                      const SizedBox(height: 20),
                      // Step indicator
                      Text('step $current_step of 3',
                          style: GoogleFonts.lexend()),
                      // Navigation and action buttons
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          TextButton(
                            onPressed: viewModel.go_to_home,
                            style: TextButton.styleFrom(
                              foregroundColor: Colors.grey,
                            ),
                            child: Text('Skip Tutorial',
                                style: GoogleFonts.lexend()),
                          ),
                          TextButton(
                            onPressed: _nextStep,
                            style: TextButton.styleFrom(
                              foregroundColor: Color(0xFF3439AB),
                            ),
                            child: Text(
                              'Next',
                              style: GoogleFonts.lexend(),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
        });
  }

  List<Widget> _buildOnboardingSteps() {
    switch (current_step) {
      case 1:
        return [
          Padding(
              padding: EdgeInsets.only(top: 30.0, bottom: 15),
              child: Column(
                children: [
                  Text(
                    "enter ur interests",
                    style: GoogleFonts.lexend(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              )),
          Image.asset(
            'lib/assets/onboarding1.png',
            height: 400,
          ),
        ];
      case 2:
        return [
          Padding(
              padding: EdgeInsets.only(top: 30.0, bottom: 15),
              child: Column(
                children: [
                  Text(
                    "discover people",
                    style: GoogleFonts.lexend(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              )),
          Image.asset(
            'lib/assets/onboarding2.png',
            height: 400,
          ),
        ];
      case 3:
        return [
          Padding(
              padding: EdgeInsets.only(top: 30.0, bottom: 15),
              child: Column(
                children: [
                  Text(
                    "chat & make friends :)",
                    style: GoogleFonts.lexend(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              )),
          Image.asset(
            'lib/assets/onboarding3.png',
            height: 400,
          ),
        ];
      default:
        return [];
    }
  }
}
