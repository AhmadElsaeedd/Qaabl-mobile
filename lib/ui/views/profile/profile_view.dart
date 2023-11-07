import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';
import 'package:qaabl_mobile/ui/common/ui_helpers.dart';

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
                      Image.asset(
                        'lib/assets/${viewModel.image_index}.png',
                        height: 200,
                      ),
                      //Padding(padding: const EdgeInsets.only(bottom: 10)),
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
                      SizedBox(height: 10),
                      Text(
                        "add more stuff to ur profile, much better :)",
                        style: TextStyle(
                          fontSize: 14, // Adjust the size as needed
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      SizedBox(
                          height:
                              30), // Add space between progress bar and buttons
                      // Buttons
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          //Rounded Cupertino Button with the color #3439AB
                          Flexible(
                            child: CupertinoButton(
                              color: Color.fromARGB(255, 239, 239, 239),
                              onPressed: () {
                                viewModel.go_to_settings();
                              },
                              child: Text('Settings',
                                  style: TextStyle(color: Colors.black)),
                              padding: EdgeInsets.symmetric(
                                  horizontal: 20, vertical: 10),
                            ),
                          ),
                          Flexible(
                            child: CupertinoButton(
                              color: Color(0xFF3439AB),
                              onPressed: () {
                                viewModel.go_to_edit_profile();
                              },
                              child: Text('Edit Profile',
                                  style: TextStyle(color: Colors.white)),
                              padding: EdgeInsets.symmetric(
                                  horizontal: 20, vertical: 10),
                            ),
                          ),
                        ],
                      ),
                    ],
                  )
                else
                  Center(
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text('Loading ...', style: TextStyle(fontSize: 16)),
                        horizontalSpaceSmall,
                        SizedBox(
                          width: 16,
                          height: 16,
                          child: CircularProgressIndicator(
                            color: Colors.black,
                            strokeWidth: 6,
                          ),
                        )
                      ],
                    ),
                  )
              ],
            ),
            Align(
              alignment: Alignment.bottomCenter,
              child: Container(
                margin: EdgeInsets.only(
                    bottom: 30), // Add 20 pixels margin at the bottom
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
  Color profileColor = (viewModel.current_page == "profile" ||
          viewModel.current_page == "edit_profile" ||
          viewModel.current_page == "settings")
      ? Color(0xFF3439AB)
      : const Color.fromARGB(255, 104, 104, 104);

  Color chatColor = (viewModel.current_page == "chats")
      ? Color(0xFF3439AB)
      : const Color.fromARGB(255, 104, 104, 104);

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
              icon: Icon(Icons.person),
              color: profileColor,
              onPressed: viewModel.go_to_profile,
            ),
            SizedBox(width: 50), // Leave space for the logo
            IconButton(
              iconSize: 30,
              icon: Icon(Icons.chat),
              color: chatColor,
              onPressed: viewModel.go_to_chats,
            ),
          ],
        ),
      ),
      Positioned(
        bottom: 10, // Adjust the value as needed to position the logo
        child: GestureDetector(
          onTap: () {
            viewModel.go_to_home();
          }, // Add your home action here
          child: Container(
              width: 70, // Adjust the width and height as needed
              height: 70,
              decoration: BoxDecoration(
                border: Border.all(color: Color(0xFF3439AB)), // Border color
                borderRadius:
                    BorderRadius.circular(40), // Rounded corner radius
                boxShadow: [
                  BoxShadow(
                    color: Colors.black26, // Shadow color
                    offset: Offset(0, 3), // Vertical offset
                    blurRadius: 5.0, // Blur value
                    spreadRadius: 1.0, // Spread value
                  ),
                ],
              ),
              child: CircleAvatar(
                backgroundImage: AssetImage('lib/assets/logo.png'),
                backgroundColor: Colors.white,
              )),
        ),
      ),
    ],
  );
}
