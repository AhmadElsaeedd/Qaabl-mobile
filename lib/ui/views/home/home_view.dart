import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';
import 'package:stacked_app/ui/common/app_colors.dart';
import 'package:stacked_app/ui/common/ui_helpers.dart';

import 'home_viewmodel.dart';

class HomeView extends StatelessWidget {
  const HomeView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<HomeViewModel>.reactive(
      viewModelBuilder: () => HomeViewModel(),
      onViewModelReady: (model) => model.getUsers(),
      builder: (context, viewModel, child) {
        Map<String, dynamic>? nextUser = viewModel.get_next_user();
        return Scaffold(
          backgroundColor: Colors.white,
          body: SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 25.0),
              child: Stack(
                children: [
                  Column(
                    children: [
                      _helloText(),
                      Expanded(
                        child: Center(
                          child: _userDetails(nextUser, viewModel, context),
                        ),
                      ),
                      _bottomNavigationBar(viewModel),
                    ],
                  )
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}

Widget _helloText() {
  return Padding(
    padding: const EdgeInsets.only(top: 50.0),
    child: const Text(
      'Hello, in Qaabl!',
      style: TextStyle(
        fontSize: 25,
        fontWeight: FontWeight.w900,
      ),
    ),
  );
}

Widget _userDetails(nextUser, viewModel, context) {
  if (nextUser != null && nextUser['interests'].isNotEmpty) {
    return Center( // Center the interests area
    child: SingleChildScrollView(
      child: Column(
        children: [
          Text("Interest: ${nextUser['interests'][0]['name']}"),
          Text("Description: ${nextUser['interests'][0]['description']}"),
          Row( // Align Like and Dislike buttons horizontally
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              ElevatedButton(
                onPressed: () {
                  viewModel.dislike_user(nextUser['id']);
                },
                style: ElevatedButton.styleFrom(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30), // Rounded button
                  ), backgroundColor: Colors.white,
                ),
                child: Icon(Icons.close, color: Colors.black), // Close icon
              ),
              ElevatedButton(
                onPressed: () {
                  viewModel.like_user(nextUser['id'], nextUser['potential_match']);
                },
                style: ElevatedButton.styleFrom(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30), // Rounded button
                  ), backgroundColor: Colors.white,
                ),
                child: Icon(Icons.check, color: Colors.black), // Check icon
              ),
            ],
          ),
          ElevatedButton(
            onPressed: () {
              showModalBottomSheet(
                context: context,
                builder: (context) => GestureDetector(
                  onTap: () => Navigator.of(context).pop(),
                  behavior: HitTestBehavior.opaque,
                  child: Container(
                    height: MediaQuery.of(context).size.height * 0.5,
                    child: UserProfileView(
                      interests: List<Map<String, dynamic>>.from(
                          nextUser['interests']),
                    ),
                  ),
                ),
                isScrollControlled: true,
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Color(0xFF3439AB), // Change color of View Profile button
            ),
            child: Text("View Profile"),
          ),
        ],
      ),
      ),
    );
  }
    // return Column(
    //   children: [
    //     Text("Interest: ${nextUser['interests'][0]['name']}"),
    //     Text("Interest: ${nextUser['interests'][0]['description']}"),
    //     ElevatedButton(
    //       onPressed: () {
    //         viewModel.like_user(nextUser['id'], nextUser['potential_match']);
    //       },
    //       style: ElevatedButton.styleFrom(backgroundColor: Colors.white),
    //       child: const Text("Like", style: TextStyle(color: Colors.black)),
    //     ),
    //     ElevatedButton(
    //       onPressed: () {
    //         viewModel.dislike_user(nextUser['id']);
    //       },
    //       style: ElevatedButton.styleFrom(backgroundColor: Colors.white),
    //       child: const Text("Dislike", style: TextStyle(color: Colors.black)),
    //     ),
    //     ElevatedButton(
    //       onPressed: () {
    //         showModalBottomSheet(
    //           context: context,
    //           builder: (context) => GestureDetector(
    //             onTap: () => Navigator.of(context).pop(),
    //             behavior: HitTestBehavior.opaque,
    //             child: Container(
    //               height: MediaQuery.of(context).size.height * 0.5,
    //               child: UserProfileView(
    //                 interests: List<Map<String, dynamic>>.from(
    //                     nextUser['interests']),
    //               ),
    //             ),
    //           ),
    //           isScrollControlled: true,
    //         );
    //       },
    //       child: Text("View Profile"),
    //     ),
    //   ],
    // );
  else if (viewModel.no_more_users) {
    return Text("No more users to display.");
  } else {
    return Text("Loading...");
  }
}

class UserInterestsWidget extends StatefulWidget {
  final List<Map<String, dynamic>> interests;

  const UserInterestsWidget({Key? key, required this.interests})
      : super(key: key);

  @override
  _UserInterestsWidgetState createState() => _UserInterestsWidgetState();
}

class _UserInterestsWidgetState extends State<UserInterestsWidget> {
  String? selectedInterestDescription;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ListView.builder(
          shrinkWrap: true, // to give the ListView a height
          itemCount: widget.interests.length,
          itemBuilder: (context, index) {
            final interest = widget.interests[index];
            return ListTile(
              title: Text(interest['name']),
              onTap: () {
                setState(() {
                  selectedInterestDescription = interest['description'];
                });
              },
            );
          },
        ),
        if (selectedInterestDescription != null)
          Card(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(selectedInterestDescription!),
            ),
          ),
      ],
    );
  }
}

class UserProfileView extends StatelessWidget {
  final List<Map<String, dynamic>> interests;

  const UserProfileView({Key? key, required this.interests}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('User Profile'),
        leading: IconButton(
          icon: Icon(Icons.close),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: UserInterestsWidget(interests: interests),
    );
  }
}

Widget _bottomNavigationBar(viewModel) {
  return Stack(
    clipBehavior: Clip.none, // Allows the overflowing children to be visible
    alignment: Alignment.bottomCenter,
    children: [
      Container(
        height: 60,
        decoration: BoxDecoration(
          color: Colors.grey[300],
          borderRadius: BorderRadius.circular(10),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            IconButton(
              icon: Icon(Icons.person), // Replace with your PNG
              onPressed: viewModel.go_to_profile,
            ),
            SizedBox(width: 50), // Leave space for the logo
            IconButton(
              icon: Icon(Icons.chat), // Replace with your PNG
              onPressed: viewModel.go_to_chats,
            ),
          ],
        ),
      ),
      Positioned(
        bottom: 10, // Adjust the value as needed to position the logo
        child: GestureDetector(
          onTap: () {viewModel.signOut();}, // Add your home action here
          child: Container(
            width: 70, // Adjust the width and height as needed
            height: 70,
            child: Image.asset('lib/assets/logo.png'),
          ),
        ),
      ),
    ],
  );
}
