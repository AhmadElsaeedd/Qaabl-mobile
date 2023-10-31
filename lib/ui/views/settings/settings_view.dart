import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';

import 'settings_viewmodel.dart';

class SettingsView extends StackedView<SettingsViewModel> {
  const SettingsView({Key? key}) : super(key: key);

  @override
  Widget builder(
    BuildContext context,
    SettingsViewModel viewModel,
    Widget? child,
  ) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
          child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 25),
        child: Column(
          children: [
            Container(
              padding: EdgeInsets.only(top: 25, bottom: 20),
              child: Text(
                "Settings",
                style: TextStyle(
                  fontFamily: 'Switzer',
                  fontSize: 25,
                  fontWeight: FontWeight.w900,
                ),
              ),
            ),
            Expanded(
              child: ListView(
                children: <Widget>[
                  ListTile(
                    title: Text('Edit Password',
                        style: TextStyle(fontFamily: 'Switzer')),
                    trailing: Icon(Icons.arrow_forward_ios, size: 14.0),
                    onTap: () {
                      // ToDo: Implement action for Edit Password
                      showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return CupertinoAlertDialog(
                            title: Text("Password change email"),
                            content: Text(
                                "we'll send u an email to edit ur password, ok?."),
                            actions: [
                              TextButton(
                                child: Text("Send",
                                    style: TextStyle(
                                        fontFamily: "Switzer",
                                        color: Color(0xFF3439AB))),
                                onPressed: () {
                                  viewModel.edit_password_email();
                                  Navigator.of(context)
                                      .pop(); // Close the alert dialog
                                },
                              ),
                            ],
                          );
                        },
                      );
                    },
                  ),
                  Divider(), // Adds a separator
                  ListTile(
                    title: Text('Privacy Policy',
                        style: TextStyle(fontFamily: 'Switzer')),
                    trailing: Icon(Icons.arrow_forward_ios, size: 14.0),
                    onTap: () {
                      showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return CupertinoAlertDialog(
                            title: Text("Privacy Policy"),
                            content: SingleChildScrollView(
                              child: Text(
                                "privacy policy content here...", //Replace with your actual privacy policy text
                                style: TextStyle(fontFamily: 'Switzer'),
                              ),
                            ),
                            actions: [
                              TextButton(
                                child: Text("Close"),
                                onPressed: () {
                                  Navigator.of(context)
                                      .pop(); // Close the dialog
                                },
                              ),
                            ],
                          );
                        },
                      );
                    },
                  ),
                  Divider(),
                  ListTile(
                    title: Text('About Us',
                        style: TextStyle(fontFamily: 'Switzer')),
                    trailing: Icon(Icons.arrow_forward_ios, size: 14.0),
                    onTap: () {
                      showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return CupertinoAlertDialog(
                            title: Text("About Us"),
                            content: SingleChildScrollView(
                              child: Text(
                                "info about us", //Replace with your actual about us text
                                style: TextStyle(fontFamily: 'Switzer'),
                              ),
                            ),
                            actions: [
                              TextButton(
                                child: Text("Close"),
                                onPressed: () {
                                  Navigator.of(context)
                                      .pop(); // Close the dialog
                                },
                              ),
                            ],
                          );
                        },
                      );
                    },
                  ),
                  Divider(),
                  ListTile(
                    title: Text('Logout', style: TextStyle()),
                    trailing: Icon(Icons.arrow_forward_ios, size: 14.0),
                    onTap: () {
                      showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return CupertinoAlertDialog(
                            title: Text("Logout"),
                            content: SingleChildScrollView(
                              child: Text(
                                "sure, wanna logout?",
                                style: TextStyle(),
                              ),
                            ),
                            actions: [
                              TextButton(
                                child: Text("Cancel",
                                    style: TextStyle(color: Color(0xFF3439AB))),
                                onPressed: () {
                                  Navigator.of(context)
                                      .pop(); // Close the alert dialog
                                },
                              ),
                              TextButton(
                                child: Text("yes"),
                                onPressed: () {
                                  viewModel.signOut();
                                  Navigator.of(context).pop();
                                },
                              ),
                            ],
                          );
                        },
                      );
                    },
                  ),
                  Divider(),
                  ListTile(
                    title: Text('Delete Account',
                        style: TextStyle(color: Colors.redAccent)),
                    trailing: Icon(Icons.arrow_forward_ios,
                        size: 14.0, color: Colors.redAccent),
                    onTap: () {
                      // Show an alert dialog
                      showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return CupertinoAlertDialog(
                            title: Text("Confirm Deletion"),
                            content: Text(
                                "Are you sure you want to delete your account? This action is irreversible."),
                            actions: [
                              TextButton(
                                child: Text("Cancel",
                                    style: TextStyle(
                                        fontFamily: "Switzer",
                                        color: Color(0xFF3439AB))),
                                onPressed: () {
                                  Navigator.of(context)
                                      .pop(); // Close the alert dialog
                                },
                              ),
                              TextButton(
                                child: Text("Delete",
                                    style: TextStyle(color: Colors.redAccent)),
                                onPressed: () {
                                  //Call the function that deletes from the viewmodel
                                  viewModel.delete_account(viewModel.uid);
                                  viewModel.signOut();
                                  Navigator.of(context)
                                      .pop(); // Close the alert dialog after deleting
                                },
                              ),
                            ],
                          );
                        },
                      );
                    },
                  ),
                  Divider(),
                ],
              ),
            ),
            Container(
              margin: EdgeInsets.only(bottom: 5),
              child: _bottomNavigationBar(viewModel),
            ),
          ],
        ),
      )),
    );
  }

  @override
  SettingsViewModel viewModelBuilder(
    BuildContext context,
  ) =>
      SettingsViewModel();
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
