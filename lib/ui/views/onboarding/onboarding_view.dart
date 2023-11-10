import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';
import 'onboarding_viewmodel.dart';

// class OnboardingView extends StackedView<OnboardingViewModel> {
//   const OnboardingView({Key? key}) : super(key: key);

//   @override
//   Widget builder(
//     BuildContext context,
//     OnboardingViewModel viewModel,
//     Widget? child,
//   ) {
//     int current_step = 1;
//     return Scaffold(
//       backgroundColor: Colors.white,
//       body: SafeArea(
//         child: Center(
//           child: Container(
//             padding: const EdgeInsets.symmetric(horizontal: 25.0),
//             child: Column(
//               mainAxisAlignment: MainAxisAlignment.center,
//               children: [
//                 Image.asset(
//                   'lib/assets/logo.png',
//                   height: 150,
//                 ),
//                 const SizedBox(height: 10),
//                 const Text(
//                   "welcome to Qaabl.",
//                   style: TextStyle(
//                     fontSize: 24,
//                     fontWeight: FontWeight.bold,
//                   ),
//                 ),
//                 if (current_step == 1) ...[
//                   //ToDo: show that it's in the first step of 3
//                 ] else if (current_step == 2) ...[
//                   //ToDo: show that it's in the second step of 3
//                 ] else if (current_step == 3) ...[
//                   //ToDo: show that it's in the third step of 3
//                 ],
//                 //ToDo: next step to the bottom right of the screen
//                 //ToDo: skip tutorial button to the bottom left of the screen
//               ],
//             ),
//           ),
//         ),
//       ),
//     );
//   }

//   @override
//   OnboardingViewModel viewModelBuilder(
//     BuildContext context,
//   ) =>
//       OnboardingViewModel();
// }

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
                      const Text(
                        "welcome to Qaabl.",
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      // Onboarding steps
                      ..._buildOnboardingSteps(),
                      const SizedBox(height: 20),
                      // Step indicator
                      Text('Step $current_step of 3'),
                      // Navigation and action buttons
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          TextButton(
                            onPressed: viewModel.go_to_home,
                            style: TextButton.styleFrom(
                              foregroundColor: Colors.grey,
                            ),
                            child: const Text('Skip Tutorial'),
                          ),
                          TextButton(
                            onPressed: _nextStep,
                            style: TextButton.styleFrom(
                              foregroundColor: Color(0xFF3439AB),
                            ),
                            child: const Text('Next'),
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

  // @override
  // Widget build(BuildContext context) {
  //   return Scaffold(
  //     backgroundColor: Colors.white,
  //     body: SafeArea(
  //       child: Center(
  //         child: Container(
  //           padding: const EdgeInsets.symmetric(horizontal: 25.0),
  //           child: Column(
  //             mainAxisAlignment: MainAxisAlignment.center,
  //             children: [
  //               Image.asset(
  //                 'lib/assets/logo.png',
  //                 height: 150,
  //               ),
  //               const SizedBox(height: 10),
  //               const Text(
  //                 "welcome to Qaabl.",
  //                 style: TextStyle(
  //                   fontSize: 24,
  //                   fontWeight: FontWeight.bold,
  //                 ),
  //               ),
  //               // Onboarding steps
  //               ..._buildOnboardingSteps(),
  //               const SizedBox(height: 20),
  //               // Step indicator
  //               Text('Step $current_step of 3'),
  //               // Navigation and action buttons
  //               Row(
  //                 mainAxisAlignment: MainAxisAlignment.spaceBetween,
  //                 children: [
  //                   TextButton(
  //                     onPressed: _skipTutorial,
  //                     style: TextButton.styleFrom(
  //                       foregroundColor: Colors.grey,
  //                     ),
  //                     child: const Text('Skip Tutorial'),
  //                   ),
  //                   TextButton(
  //                     onPressed: _nextStep,
  //                     style: TextButton.styleFrom(
  //                       foregroundColor: Color(0xFF3439AB),
  //                     ),
  //                     child: const Text('Next'),
  //                   ),
  //                 ],
  //               ),
  //             ],
  //           ),
  //         ),
  //       ),
  //     ),
  //   );
  // }

  List<Widget> _buildOnboardingSteps() {
    switch (current_step) {
      case 1:
        return [
          const Padding(
              padding: EdgeInsets.only(top: 30.0, bottom: 15),
              child: Column(
                children: [
                  Text(
                    "enter ur interests",
                    style: TextStyle(
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
          const Padding(
              padding: EdgeInsets.only(top: 30.0, bottom: 15),
              child: Column(
                children: [
                  Text(
                    "discover people",
                    style: TextStyle(
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
          const Padding(
              padding: EdgeInsets.only(top: 30.0, bottom: 15),
              child: Column(
                children: [
                  Text(
                    "chat & make friends :)",
                    style: TextStyle(
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
