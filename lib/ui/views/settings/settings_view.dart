import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:share_plus/share_plus.dart';
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
                style: GoogleFonts.lexend(
                  fontSize: 25,
                  fontWeight: FontWeight.w900,
                ),
              ),
            ),
            Expanded(
              child: ListView(
                children: <Widget>[
                  ListTile(
                    title: Text('edit password', style: GoogleFonts.lexend()),
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
                                    style: GoogleFonts.lexend(
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
                    title: Text('privacy policy', style: GoogleFonts.lexend()),
                    trailing: Icon(Icons.arrow_forward_ios, size: 14.0),
                    onTap: () {
                      showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return CupertinoAlertDialog(
                            title: Text("Privacy Policy"),
                            content: SingleChildScrollView(
                              child: Text(
                                "1. Introduction: Our Privacy Policy governs your use of Qaabl and explains how we collect, safeguard, and disclose information that results from your use of our product. 2. Information We Collect 2.1. Information you provide us directly: Email, Name, Interests. 2.2. Information we collect automatically through the use of Mixpanel: Our Service uses Mixpanel, an analytics service provided by Mixpanel Inc., to collect information that your device sends whenever you use our Service. This may include information such as: Device Information: Type of device, operating system, unique device identifiers, device settings, and geographical location data. Log Data: Includes the date and time you used our Service, the duration of usage, and error logs. Usage Data: Information about how you use our Service, which can include the frequency and scope of your use, the pages that you visit, and the resources that you access. Cookies: Mixpanel uses cookies to track the activity on our Service and holds certain information. 3. Use of Your Personal Information: Our product uses your personal information to enhance your experience and to help in communicating with other users. 4. Sharing Your Personal Information: We do not share your personal infromation. 5. Keeping Your Information Secure: We use Firebase which cannot be accessed by anyone except if they get access to our private key. 6. Data Retention: Your data is retained as long as you have an account on Qaabl. 7 Contact Information: If you have any questions or concerns regarding this Privacy Policy, please contact us at: team@qaabl.app",
                                style: GoogleFonts.lexend(),
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
                    title: Text('about us', style: GoogleFonts.lexend()),
                    trailing: Icon(Icons.arrow_forward_ios, size: 14.0),
                    onTap: () {
                      showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return CupertinoAlertDialog(
                            title: Text("About Us"),
                            content: SingleChildScrollView(
                              child: Text(
                                "we are 3 people who like working on cool stuff: Ahmad, Salem, and Guglielmo. we do this for fun (but are serious sometimes) and we work on qaabl to make it the best for you... alright, enjoy :*",
                                style: GoogleFonts.lexend(),
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
                    title: Text('feedback', style: GoogleFonts.lexend()),
                    trailing: Icon(Icons.arrow_forward_ios, size: 14.0),
                    onTap: () {
                      showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return FeedbackFormDialog(viewModel: viewModel);
                        },
                      );
                    },
                  ),
                  Divider(),
                  ListTile(
                    title: Text('share qaabl', style: GoogleFonts.lexend()),
                    trailing: Icon(Icons.arrow_forward_ios, size: 14.0),
                    onTap: () {
                      Share.share(
                          'im on qaabl, join me! https://testflight.apple.com/join/syEy5gAZ');
                    },
                  ),
                  Divider(),
                  ListTile(
                    title: Text('logout'),
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
                                style: GoogleFonts.lexend(),
                              ),
                            ),
                            actions: [
                              TextButton(
                                child: Text("Cancel",
                                    style: GoogleFonts.lexend(
                                        color: Color(0xFF3439AB))),
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
                    title: Text('delete account',
                        style: GoogleFonts.lexend(color: Colors.redAccent)),
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
                                    style: GoogleFonts.lexend(
                                        color: Color(0xFF3439AB))),
                                onPressed: () {
                                  Navigator.of(context)
                                      .pop(); // Close the alert dialog
                                },
                              ),
                              TextButton(
                                child: Text("Delete",
                                    style: GoogleFonts.lexend(
                                        color: Colors.redAccent)),
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

class FeedbackFormDialog extends StatelessWidget {
  final TextEditingController feedbackController = TextEditingController();
  final SettingsViewModel viewModel;
  FeedbackFormDialog({required this.viewModel});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(
          "we'd love to know what u think we could add, edit, or remove",
          style: GoogleFonts.lexend(fontSize: 14)),
      content: TextField(
        controller: feedbackController,
        maxLines: 4,
        decoration: InputDecoration(
          labelText: 'let us know here',
          border: OutlineInputBorder(),
        ),
      ),
      actions: <Widget>[
        TextButton(
          child: Text("cancel"),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
        TextButton(
          child: Text("submit"),
          onPressed: () {
            // Implement your feedback submission logic here
            // For example, you could call a function that sends the feedback to a server or database
            String feedback = feedbackController.text;
            if (feedback.isNotEmpty) {
              viewModel.submitFeedback(
                  feedback); // Uncomment and implement this function
              feedbackController.clear();
              Navigator.of(context).pop();
            }
          },
        ),
      ],
    );
  }
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
