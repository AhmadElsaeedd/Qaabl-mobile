// import 'dart:math';
import 'package:flutter/cupertino.dart';
import 'package:qaabl_mobile/ui/common/ui_helpers.dart';
// import 'package:flutter/scheduler.dart';
import 'package:stacked/stacked.dart';
// import 'package:qaabl_mobile/ui/common/app_colors.dart';
// import 'package:qaabl_mobile/ui/common/ui_helpers.dart';
import 'package:flutter/material.dart';
import 'package:swipe_cards/draggable_card.dart';
import 'package:swipe_cards/swipe_cards.dart';
import 'home_viewmodel.dart';
import 'dart:async';

class HomeView extends StatefulWidget {
  const HomeView({Key? key}) : super(key: key);

  @override
  _HomeViewState createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> with TickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<Offset> _slideAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration:
          const Duration(milliseconds: 500), // Duration of the slide animation
    );

    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, -20), // Start position (from the top)
      end: const Offset(0, 0), // End position (final position)
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeOut,
    ));

    // Start the animation
    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<HomeViewModel>.reactive(
      viewModelBuilder: () => HomeViewModel(),
      builder: (context, viewModel, child) {
        Map<String, dynamic>? nextUser = viewModel.get_next_user();

        // Reset and start the animation for the new user
        _animationController.reset();
        _animationController.forward();

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
                      if (nextUser != null) ...[
                        Container(
                          //margin: EdgeInsets.only(top: 20),
                          child: Center(
                            child: _userDetails(
                                nextUser, viewModel, context, _slideAnimation),
                          ),
                        ),
                        Container(
                          margin: const EdgeInsets.only(top: 0),
                          child: Center(
                            child: check_profile_button(
                                nextUser, viewModel, context),
                          ),
                        ),
                      ] else if (viewModel.user_continues == false) ...[
                        Container(
                          margin: const EdgeInsets.only(top: 200),
                          child: const Column(
                            children: [
                              Text(
                                'fill your profile!',
                                style: TextStyle(
                                  fontSize: 25,
                                  fontWeight: FontWeight.w900,
                                ),
                              ),
                              SizedBox(height: 10),
                              Text(
                                "why?",
                                style: TextStyle(
                                  fontSize: 18, // Adjust the size as needed
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                              SizedBox(height: 10),
                              Text(
                                "rn ur not visible, less chances of meeting ppl :(",
                                style: TextStyle(
                                  fontSize: 14, // Adjust the size as needed
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ],
                          ),
                        )
                      ] else if (nextUser == null &&
                          viewModel.no_more_users == false) ...[
                        Container(
                          margin: const EdgeInsets.only(top: 200),
                          child: const Column(
                            children: [
                              Text(
                                'Finding people!',
                                style: TextStyle(
                                  fontSize: 25,
                                  fontWeight: FontWeight.w900,
                                ),
                              ),
                              Text(
                                "give us a sec :)",
                                style: TextStyle(
                                  fontSize: 14, // Adjust the size as needed
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ],
                          ),
                        )
                      ] else if (viewModel.no_more_users == true) ...[
                        Container(
                          margin: const EdgeInsets.only(top: 200),
                          child: const Column(
                            children: [
                              Text(
                                'No more users',
                                style: TextStyle(
                                  fontFamily: 'Switzer',
                                  fontSize: 25,
                                  fontWeight: FontWeight.w900,
                                ),
                              ),
                              Text(
                                "come back in a bit, see u :*",
                                style: TextStyle(
                                  fontSize: 14, // Adjust the size as needed
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ],
                          ),
                        )
                      ],
                      const Spacer(),
                      Container(
                        margin: const EdgeInsets.only(
                            bottom: 0), // Adjust as needed
                        child: _bottomNavigationBar(viewModel),
                      ),
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

//   @override
//   Widget build(BuildContext context) {
//     return ViewModelBuilder<HomeViewModel>.reactive(
//       viewModelBuilder: () => HomeViewModel(),
//       onViewModelReady: (model) {
//         model.set_token_by_waiting_for_document();
//         // Trigger the animation when the view model is ready
//         _animationController.reset();
//         _animationController.forward();
//       },
//       builder: (context, viewModel, child) {
//         // Use FutureBuilder to handle the async operation
//         return Scaffold(
//           backgroundColor: Colors.white,
//           body: SafeArea(
//             child: Padding(
//               padding: const EdgeInsets.symmetric(horizontal: 25.0),
//               child: Stack(
//                 children: [
//                   Column(
//                     children: [
//                       _helloText(),
//                       FutureBuilder<Map<String, dynamic>?>(
//                         future:
//                             viewModel.get_next_user(), // Call the async method
//                         builder: (context, snapshot) {
//                           if (snapshot.connectionState ==
//                               ConnectionState.waiting) {
//                             // Show loading indicator while waiting for data
//                             return const Center(
//                               child: Row(
//                                 mainAxisSize: MainAxisSize.min,
//                                 children: [
//                                   Text('Loading ...',
//                                       style: TextStyle(fontSize: 16)),
//                                   horizontalSpaceSmall,
//                                   SizedBox(
//                                     width: 16,
//                                     height: 16,
//                                     child: CircularProgressIndicator(
//                                       color: Colors.black,
//                                       strokeWidth: 6,
//                                     ),
//                                   )
//                                 ],
//                               ),
//                             );
//                           } else if (snapshot.hasError) {
//                             // Handle error state
//                             return Text('Error: ${snapshot.error}');
//                           } else if (snapshot.hasData) {
//                             // Data is available, build the user details widget
//                             Map<String, dynamic>? nextUser = snapshot.data;
//                             return _userDetails(
//                                 nextUser, viewModel, context, _slideAnimation);
//                           } else {
//                             // Handle when no more users are available
//                             print("I am here");
//                             return _noMoreUsersWidget(viewModel);
//                           }
//                         },
//                       ),
//                       Spacer(),
//                       Container(
//                         margin: EdgeInsets.only(bottom: 0), // Adjust as needed
//                         child: _bottomNavigationBar(viewModel),
//                       ),
//                     ],
//                   )
//                 ],
//               ),
//             ),
//           ),
//         );
//       },
//     );
//   }

// // Helper method to create the "No more users" widget
//   Widget _noMoreUsersWidget(HomeViewModel viewModel) {
//     if (viewModel.no_more_users) {
//       return _noMoreUsersAvailable();
//     } else if (!viewModel.user_continues) {
//       return _fillYourProfile();
//     } else {
//       return Text('');
//     }
//   }

//   Widget _noMoreUsersAvailable() {
//     return Container(
//       margin: EdgeInsets.only(top: 200),
//       child: Column(
//         children: [
//           const Text(
//             'No more users',
//             style: TextStyle(
//               fontFamily: 'Switzer',
//               fontSize: 25,
//               fontWeight: FontWeight.w900,
//             ),
//           ),
//           Text(
//             "come back in a bit, see u :*",
//             style: TextStyle(
//               fontSize: 14, // Adjust the size as needed
//               fontWeight: FontWeight.w500,
//             ),
//           ),
//         ],
//       ),
//     );
//   }

//   Widget _fillYourProfile() {
//     return Container(
//       margin: EdgeInsets.only(top: 200),
//       child: Column(
//         children: [
//           const Text(
//             'fill your profile!',
//             style: TextStyle(
//               fontSize: 25,
//               fontWeight: FontWeight.w900,
//             ),
//           ),
//           SizedBox(height: 10),
//           Text(
//             "why?",
//             style: TextStyle(
//               fontSize: 18, // Adjust the size as needed
//               fontWeight: FontWeight.w500,
//             ),
//           ),
//           SizedBox(height: 10),
//           Text(
//             "rn ur not visible, less chances of meeting ppl :(",
//             style: TextStyle(
//               fontSize: 14, // Adjust the size as needed
//               fontWeight: FontWeight.w500,
//             ),
//           ),
//         ],
//       ),
//     );
//   }

  Widget _userDetails(
      nextUser, viewModel, context, Animation<Offset> slideAnimation) {
    SwipeItem? swipeItem; // Declare swipeItem as nullable
    // final Completer<MatchEngine> matchEngineCompleter =
    //     Completer<MatchEngine>(); //completer to set it later
    final GlobalKey<_UserCardState> userCardKey = GlobalKey<_UserCardState>();

    // Define the callback outside of swipeItem
    Future<void> onSlideUpdateCallback(SlideRegion? region) async {
      if (region.toString() == "SlideRegion.inNopeRegion") {
        // show dislike feedback
        userCardKey.currentState!.showFeedback("Dislike");
      } else if (region.toString() == "SlideRegion.inLikeRegion") {
        // show like feedback
        userCardKey.currentState!.showFeedback("Like");
      } else {
        // hide feedback for other cases
        userCardKey.currentState!.hideFeedback();
      }
    }

    swipeItem = SwipeItem(
        content:
            UserCard(nextUser, viewModel, context, slideAnimation, userCardKey),
        // , matchEngineCompleter.future),
        likeAction: () {
          // viewModel.skip_user(nextUser['id']);
          viewModel.like_user(nextUser['id'], nextUser['potential_match']);
        },
        nopeAction: () {
          // viewModel.skip_user(nextUser['id']);
          viewModel.dislike_user(nextUser['id']);
        },
        onSlideUpdate: onSlideUpdateCallback
        // Include other actions like superLike if you have them
        );

    MatchEngine matchEngine = MatchEngine(swipeItems: [swipeItem]);
    // matchEngineCompleter.complete(_matchEngine);
    // print("MatchEngine Completed with Swipe Item: ${_matchEngine.currentItem}");

    // SchedulerBinding.instance.addPostFrameCallback((_) {
    //   (userCardKey.currentState as _UserCardState).setMatchEngine(_matchEngine);
    // });

    return Container(
      key: ValueKey(DateTime.now().millisecondsSinceEpoch),
      height: 500,
      child: SwipeCards(
        matchEngine: matchEngine,
        itemBuilder: (BuildContext context, int index) {
          return Container(
              alignment: Alignment.center,
              child: swipeItem!
                  .content // This displays the content of the SwipeItem
              );
        },
        onStackFinished: () {
          // Load more users or any action when all cards are swiped
        },
      ),
    );
  }
}

Widget _helloText() {
  return const Padding(
      padding: EdgeInsets.only(top: 50.0),
      child: Column(
        children: [
          Text(
            'Hello, in Qaabl!',
            style: TextStyle(
              fontSize: 25,
              fontWeight: FontWeight.w900,
            ),
          ),
          Text(
            "explore cool people, at ur fingertips",
            style: TextStyle(
              fontSize: 14, // Adjust the size as needed
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ));
}

class UserInterestsWidget extends StatefulWidget {
  final List<Map<String, dynamic>> interests;

  const UserInterestsWidget({Key? key, required this.interests})
      : super(key: key);

  @override
  _UserInterestsWidgetState createState() => _UserInterestsWidgetState();
}

class _UserInterestsWidgetState extends State<UserInterestsWidget> {
  int? selectedIndex;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          ListView.builder(
            shrinkWrap: true, // This will size the ListView to its content
            physics:
                const ClampingScrollPhysics(), // This will enable scrolling in the ListView
            itemCount: widget.interests.length,
            itemBuilder: (context, index) {
              final interest = widget.interests[index];
              return ExpansionTile(
                title: Text(interest['name']),
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(interest['description'] ?? ''),
                  ),
                ],
                initiallyExpanded: index == selectedIndex,
                onExpansionChanged: (isExpanded) {
                  if (isExpanded) {
                    setState(() {
                      selectedIndex = index;
                    });
                  }
                },
              );
            },
          ),
        ],
      ),
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
        backgroundColor: const Color(0xFF3439AB),
        title: const Text('More about me...'),
        leading: IconButton(
          icon: const Icon(Icons.close),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: UserInterestsWidget(interests: interests),
    );
  }
}

Widget _bottomNavigationBar(viewModel) {
  Color profileColor = (viewModel.current_page == "profile" ||
          viewModel.current_page == "edit_profile" ||
          viewModel.current_page == "settings")
      ? const Color(0xFF3439AB)
      : const Color.fromARGB(255, 104, 104, 104);

  Color chatColor = (viewModel.current_page == "chats")
      ? const Color(0xFF3439AB)
      : const Color.fromARGB(255, 104, 104, 104);

  return Stack(
    clipBehavior: Clip.none, // Allows the overflowing children to be visible
    alignment: Alignment.bottomCenter,
    children: [
      Container(
        height: 60,
        decoration: BoxDecoration(
          color: const Color.fromARGB(255, 239, 239, 239),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            IconButton(
              iconSize: 30,
              icon: const Icon(Icons.person),
              color: profileColor,
              onPressed: viewModel.go_to_profile,
            ),
            const SizedBox(width: 50), // Leave space for the logo
            IconButton(
              iconSize: 30,
              icon: const Icon(Icons.chat),
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
            // viewModel.signOut();
          }, // Add your home action here
          child: Container(
              width: 70, // Adjust the width and height as needed
              height: 70,
              decoration: BoxDecoration(
                border:
                    Border.all(color: const Color(0xFF3439AB)), // Border color
                borderRadius:
                    BorderRadius.circular(40), // Rounded corner radius
                boxShadow: [
                  const BoxShadow(
                    color: Colors.black26, // Shadow color
                    offset: Offset(0, 3), // Vertical offset
                    blurRadius: 5.0, // Blur value
                    spreadRadius: 1.0, // Spread value
                  ),
                ],
              ),
              child: const CircleAvatar(
                backgroundImage: AssetImage('lib/assets/logo.png'),
                backgroundColor: Colors.white,
              )),
        ),
      ),
    ],
  );
}

class LinearProgressPainter extends CustomPainter {
  final Color color;
  final double percentage;

  LinearProgressPainter({required this.color, required this.percentage});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..strokeWidth = 10.0
      ..style = PaintingStyle.fill;

    final path = Path()
      ..moveTo(0, size.height)
      ..lineTo(size.width * percentage, size.height)
      ..lineTo(size.width * percentage, 0)
      ..lineTo(0, 0)
      ..close();

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return true;
  }
}

class UserCard extends StatefulWidget {
  final nextUser;
  final viewModel;
  final context;
  final slideAnimation;
  final key;
  //final Future<MatchEngine> setMatchEngine;

  UserCard(this.nextUser, this.viewModel, this.context, this.slideAnimation,
      this.key)
      // , this.setMatchEngine)
      : super(key: key);

  @override
  _UserCardState createState() => _UserCardState();
}

class _UserCardState extends State<UserCard> {
  String? feedback; // this variable will store the feedback "Like" or "Dislike"
  Color? feedbackColor;
  IconData? feedbackIcon;

  // MatchEngine? matchEngine;

  // @override
  // void initState() {
  //   super.initState();
  //   widget.setMatchEngine.then((engine) {
  //     setMatchEngine(engine);
  //   });
  // }

  // void setMatchEngine(MatchEngine engine) {
  //   print("Setting Match Engine: $engine");
  //   setState(() {
  //     matchEngine = engine;
  //   });
  // }

  @override
  Widget build(BuildContext context) {
    // code for _userCard, but wrapped inside a stateful widget
    return SlideTransition(
      position: widget.slideAnimation,
      child: Stack(children: [
        Card(
            color: const Color.fromARGB(255, 239, 239, 239),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10.0),
            ),
            elevation: 5,
            child: Padding(
                padding: const EdgeInsets.all(10.0),
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      Center(
                        // Center the interests area
                        child: Column(
                          children: [
                            const Padding(padding: EdgeInsets.only(top: 25)),
                            const Text(
                              "One of my interests is:",
                              style: TextStyle(
                                fontSize: 22, // Adjust the size as needed
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            Text(
                              "${widget.nextUser['interests'][0]['name']}",
                              style: const TextStyle(
                                fontSize: 25, // Adjust the size as needed
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                            Image.asset(
                              'lib/assets/${widget.nextUser['image_index']}.png',
                              height: 200,
                            ),
                            const Padding(padding: EdgeInsets.only(top: 5)),
                            const Text(
                              "And that's what I like about it:",
                              style: TextStyle(
                                fontSize: 14, // Adjust the size as needed
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            Text(
                              "${widget.nextUser['interests'][0]['description']}",
                              style: const TextStyle(
                                fontSize: 18, // Adjust the size as needed
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(top: 10.0),
                              child: Row(
                                // Align Like and Dislike buttons horizontally
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                children: [
                                  ElevatedButton(
                                    onPressed: () async {
                                      showFeedback("Dislike");
                                      await Future.delayed(
                                          const Duration(milliseconds: 400));
                                      widget.viewModel
                                          .dislike_user(widget.nextUser['id']);
                                    },
                                    style: ElevatedButton.styleFrom(
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(
                                            30), // Rounded button
                                      ),
                                      backgroundColor: Colors.white,
                                    ),
                                    child: const Icon(Icons.thumb_down,
                                        color: Colors.black), // Close icon
                                  ),
                                  ElevatedButton(
                                    onPressed: () async {
                                      showFeedback("Like");
                                      await Future.delayed(
                                          const Duration(milliseconds: 400));
                                      widget.viewModel.like_user(
                                          widget.nextUser['id'],
                                          widget.nextUser['potential_match']);
                                    },
                                    style: ElevatedButton.styleFrom(
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(
                                            30), // Rounded button
                                      ),
                                      backgroundColor: const Color(0xFF3439AB),
                                    ),
                                    child: const Icon(Icons.thumb_up,
                                        color: Colors.white), // Check icon
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ))),
        if (feedback != null)
          Positioned(
            top: 50, // adjust as needed
            left: feedback == "Like" ? 20 : null, // 20px from left if "Like"
            right: feedback == "Dislike"
                ? 20
                : null, // 20px from right if "Dislike"
            child: Container(
              padding: const EdgeInsets.all(8.0),
              decoration: BoxDecoration(
                color: feedbackColor!.withOpacity(0.7),
                borderRadius: BorderRadius.circular(30.0), // rounded corners
              ),
              child: Icon(
                feedbackIcon,
                size: 30,
                color: Colors.white,
              ),
            ),
          )
      ]),
    );
  }

  void showFeedback(String feedbackText) {
    print("I am showing feedback");
    setState(() {
      feedback = feedbackText;
      if (feedbackText == "Like") {
        feedbackColor = const Color(0xFF3439AB);
        feedbackIcon = Icons.thumb_up; // change this to your "like" icon
      } else if (feedbackText == "Dislike") {
        feedbackColor = Colors.black;
        feedbackIcon = Icons.thumb_down; // change this to your "dislike" icon
      }
    });
  }

  void hideFeedback() {
    setState(() {
      feedback = null;
      feedbackColor = null;
      feedbackIcon = null;
    });
  }
}

Widget check_profile_button(nextUser, viewModel, context) {
  if (nextUser != null && nextUser['interests'].isNotEmpty) {
    return Column(
      children: [
        Text(
          "I have ${nextUser['interests'].length} interests, check me out",
          style: const TextStyle(
            fontSize: 14, // Adjust the size as needed
          ),
        ),
        ElevatedButton(
          onPressed: () {
			viewModel.trackProfileViewEvent(nextUser['id']);
			other
            showModalBottomSheet(
              context: context,
              builder: (context) => GestureDetector(
                onTap: () => Navigator.of(context).pop(),
                behavior: HitTestBehavior.opaque,
                child: Container(
                  height: MediaQuery.of(context).size.height * 0.35,
                  child: UserProfileView(
                    interests:
                        List<Map<String, dynamic>>.from(nextUser['interests']),
                  ),
                ),
              ),
              isScrollControlled: true,
            );
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFF3439AB), // Background color
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(30), // Rounded button
            ),
          ),
          child: const Text("View Profile"),
        ),
      ],
    );
  } else {
    return const Text("No more users to display.");
  }
}
