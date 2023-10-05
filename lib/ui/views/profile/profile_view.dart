import 'package:flutter/cupertino.dart';
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
    late int image_index = 0;
    return Scaffold(
  backgroundColor: Colors.white,
  body: Container(
    padding: const EdgeInsets.only(left: 25.0, right: 25.0),
    child: Stack(
      children: [
        Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (viewModel.percentage != null)
              Column(
                children: [
                  // Image
                  Image.asset('lib/assets/${viewModel.image_index}.png', height: 200,), // Use the value
                  // Progress Bar and Percentage
                  Stack(
                    children: [
                      LinearProgressIndicator(
                        value: viewModel.percentage! / 100,
                        minHeight: 20,
                        backgroundColor: Colors.grey[300],
                        valueColor: AlwaysStoppedAnimation<Color>(Colors.green),
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
                  SizedBox(height: 40), // Add space between progress bar and buttons
                  // Buttons
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      //Rounded Cupertino Button with the color #3439AB
                        Flexible(
                          child: CupertinoButton(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(15.0),
                            onPressed: () {
                              viewModel.go_to_settings();
                            },
                            child: Text('Settings', style: TextStyle(color: Colors.black)),
                            padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                          ),
                        ),
                        Flexible(
                          child: CupertinoButton(
                            color: Color(0xFF3439AB),
                            borderRadius: BorderRadius.circular(15.0),
                            onPressed: () {
                              viewModel.go_to_edit_profile();
                            },
                            child: Text('Edit Profile', style: TextStyle(color: Colors.white)),
                            padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                          ),
                        ),
                    ],
                  ),
                ],
              )
            else
              CircularProgressIndicator(), // Show loading indicator while waiting
          ],
        ),
        Align(
          alignment: Alignment.bottomCenter,
          child: Container(
            margin: EdgeInsets.only(bottom: 20), // Add 20 pixels margin at the bottom
            child: _bottomNavigationBar(viewModel),
          ),
        )
      ],
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

Widget _bottomNavigationBar(viewModel) {
  return Stack(
    clipBehavior: Clip.none, // Allows the overflowing children to be visible
    alignment: Alignment.bottomCenter,
    children: [
      Container(
        height: 60,
        decoration: BoxDecoration(
          color: Color.fromARGB(255, 239, 239, 239),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            IconButton(
              iconSize: 30,
              icon: Icon(Icons.person), // Replace with your PNG
              onPressed: viewModel.go_to_profile,
            ),
            SizedBox(width: 50), // Leave space for the logo
            IconButton(
              iconSize: 30,
              icon: Icon(Icons.chat), // Replace with your PNG
              onPressed: viewModel.go_to_chats,
            ),
          ],
        ),
      ),
      Positioned(
        bottom: 10, // Adjust the value as needed to position the logo
        child: GestureDetector(
          onTap: () {viewModel.go_to_home();}, // Add your home action here
          child: Container(
            width: 70, // Adjust the width and height as needed
            height: 70,
            decoration: BoxDecoration(
                        border: Border.all(color: Color(0xFF3439AB)), // Border color
                        borderRadius: BorderRadius.circular(40), // Rounded corner radius
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black26, // Shadow color
                            offset: Offset(0, 3),  // Vertical offset
                            blurRadius: 5.0,      // Blur value
                            spreadRadius: 1.0,    // Spread value
                          ),
                        ],
                      ),
            child: CircleAvatar(backgroundImage: AssetImage('lib/assets/logo.png'),backgroundColor: Colors.white,)
          ),
        ),
      ),
    ],
  );
}
