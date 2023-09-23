import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';
import 'package:stacked_app/ui/common/app_colors.dart';
import 'package:stacked_app/ui/common/ui_helpers.dart';

import 'home_viewmodel.dart';

/*class HomeView extends StackedView<HomeViewModel> {
  const HomeView({Key? key}) : super(key: key);

  @override
  Widget builder(
    BuildContext context,
    HomeViewModel viewModel,
    Widget? child,
  ) {
    return Scaffold(
      backgroundColor: Colors.indigo,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 25.0),
          child: Center(
            child: Column(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                verticalSpaceLarge,
                Column(
                  children: [
                    const Text(
                      'Hello, in Qaabl!',
                      style: TextStyle(
                        fontSize: 35,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                    verticalSpaceMedium,
                    MaterialButton(
                      color: Colors.black,
                      onPressed: viewModel.getUsers,
                      child: Text(
                        viewModel.counterLabel,
                        style: const TextStyle(color: Colors.white),
                      ),
                    ),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    MaterialButton(
                      color: kcDarkGreyColor,
                      onPressed: viewModel.showDialog,
                      child: const Text(
                        'Show Dialog',
                        style: TextStyle(
                          color: Colors.white,
                        ),
                      ),
                    ),
                    MaterialButton(
                      color: kcDarkGreyColor,
                      onPressed: viewModel.showBottomSheet,
                      child: const Text(
                        'Show Bottom Sheet',
                        style: TextStyle(
                          color: Colors.white,
                        ),
                      ),
                    ),
                    MaterialButton(
                      color: Colors.white,
                      onPressed: viewModel.signOut,
                      child: Text('Sign out'))
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  @override
  HomeViewModel viewModelBuilder(
    BuildContext context,
  ) =>
      HomeViewModel();
}*/

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
          backgroundColor: Colors.indigo,
          body: SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 25.0),
              child: Stack(
                children: [
                  Center(
                    child: Column(
                      mainAxisSize: MainAxisSize.max,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        verticalSpaceLarge,
                        Column(
                          children: [
                            const Text(
                              'Hello, in Qaabl!',
                              style: TextStyle(
                                fontSize: 35,
                                fontWeight: FontWeight.w900,
                              ),
                            ),
                            verticalSpaceMedium,
                            if (nextUser != null &&
                                nextUser['interests'].isNotEmpty)
                              Column(
                                children: [
                                  Text(
                                      "Interest: ${nextUser['interests'][0]['name']}"),
                                  Text(
                                      "Interest: ${nextUser['interests'][0]['description']}"),
                                  ElevatedButton(
                                    onPressed: () {
                                      viewModel.like_user(nextUser['id'],
                                          nextUser['potential_match']);
                                    },
                                    style: ElevatedButton.styleFrom(
                                        backgroundColor: Colors.white),
                                    child: const Text("Like",
                                        style: TextStyle(color: Colors.black)),
                                  ),
                                  ElevatedButton(
                                    onPressed: () {
                                      viewModel.dislike_user(nextUser['id']);
                                    },
                                    style: ElevatedButton.styleFrom(
                                        backgroundColor: Colors.white),
                                    child: const Text("Dislike",
                                        style: TextStyle(color: Colors.black)),
                                  ),
                                  ElevatedButton(
                                    onPressed: () {
                                      showModalBottomSheet(
                                        context: context,
                                        builder: (context) => GestureDetector(
                                          onTap: () =>
                                              Navigator.of(context).pop(),
                                          behavior: HitTestBehavior.opaque,
                                          child: Container(
                                            height: MediaQuery.of(context)
                                                    .size
                                                    .height *
                                                0.5,
                                            child: UserProfileView(
                                              interests: List<
                                                      Map<String,
                                                          dynamic>>.from(
                                                  nextUser['interests']),
                                            ),
                                          ),
                                        ),
                                        isScrollControlled: true,
                                      );
                                    },
                                    child: Text("View Profile"),
                                  ),
                                ],
                              )
                            else if (viewModel.no_more_users)
                              Text("No more users to display.")
                            else
                              Text("Loading..."),
                          ],
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            // ... your existing buttons
                          ],
                        ),
                        MaterialButton(
                          color: Colors.white,
                          onPressed: viewModel.signOut,
                          child: Text('Sign out'),
                        ),
                        MaterialButton(
                          color: Colors.white,
                          onPressed: viewModel.go_to_profile,
                          child: Text('Profile'),
                        ),
                        MaterialButton(
                          color: Colors.white,
                          onPressed: viewModel.go_to_chats,
                          child: Text('Chats'),
                        ),
                      ],
                    ),
                  ),
                  // Positioned(
                  //   left: 0,
                  //   right: 0,
                  //   bottom: 0,
                  //   child: Container(
                  //     width: 390,
                  //     height: 96,
                  //     decoration: ShapeDecoration(
                  //       color: Color(0xFFEAEAEA),
                  //       shape: RoundedRectangleBorder(
                  //         borderRadius: BorderRadius.circular(20),
                  //       ),
                  //     ),
                  //   ),
                  // ),
                ],
              ),
            ),
          ),
        );
      },
    );
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
