import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';

import 'profile_viewmodel.dart';

class ProfileView extends StackedView<ProfileViewModel> {
  const ProfileView({Key? key}) : super(key: key);

  @override
  Widget builder(
    BuildContext context,
    ProfileViewModel viewModel,
    Widget? child,
  ) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      body: Container(
        padding: const EdgeInsets.only(left: 25.0, right: 25.0),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              if (viewModel.percentage != null)
                Column(
                  children: [
                    // Image Placeholder Text
                    Text(
                      'Image Placeholder',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    // Progress Bar and Percentage
                    Stack(
                      children: [
                        LinearProgressIndicator(
                          value: viewModel.percentage! / 100,
                          minHeight: 20,
                          backgroundColor: Colors.grey[300],
                          valueColor:
                              AlwaysStoppedAnimation<Color>(Colors.green),
                        ),
                        Positioned.fill(
                          child: Align(
                            alignment: Alignment.center,
                            child: Text(
                              '${viewModel.percentage}%',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    // Buttons
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        ElevatedButton(
                          onPressed: () {
                            // Navigate to Settings page
                            viewModel.go_to_settings();
                          },
                          child: Text('Settings'),
                        ),
                        ElevatedButton(
                          onPressed: () {
                            // Navigate to Edit Profile page
                            viewModel.go_to_edit_profile();
                          },
                          child: Text('Edit Profile'),
                        ),
                      ],
                    ),
                  ],
                )
              else
                CircularProgressIndicator(), // Show loading indicator while waiting
            ],
          ),
        ),
      ),
    );
  }

  @override
  ProfileViewModel viewModelBuilder(
    BuildContext context,
  ) =>
      ProfileViewModel();
}
