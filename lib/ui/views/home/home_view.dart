import 'dart:math';
import 'package:stacked/stacked.dart';
import 'package:stacked_app/ui/common/app_colors.dart';
import 'package:stacked_app/ui/common/ui_helpers.dart';
import 'package:flutter/material.dart';
import 'package:swipe_cards/draggable_card.dart';
import 'package:swipe_cards/swipe_cards.dart';
import 'home_viewmodel.dart';

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
      duration: Duration(milliseconds: 500), // Duration of the slide animation
    );

    _slideAnimation = Tween<Offset>(
      begin: Offset(0, -20), // Start position (from the top)
      end: Offset(0, 0), // End position (final position)
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
      onViewModelReady: (model) {
        model.getUsers();
        model.set_token_by_waiting_for_document();
      },
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
                          margin: EdgeInsets.only(top: 80),
                          child: Center(
                            child: _userDetails(
                                nextUser, viewModel, context, _slideAnimation),
                          ),
                        ),
                        Container(
                          margin: EdgeInsets.only(top: 5),
                          child: Center(
                            child: check_profile_button(
                                nextUser, viewModel, context),
                          ),
                        ),
                      ] else if (nextUser == null &&
                          viewModel.no_more_users == false) ...[
                        Container(
                          margin: EdgeInsets.only(top: 200),
                          child: Column(
                            children: [
                              const Text(
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
                                  //fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                        )
                      ] else ...[
                        Container(
                          margin: EdgeInsets.only(top: 200),
                          child: Column(
                            children: [
                              const Text(
                                'No more users  :(',
                                style: TextStyle(
                                  fontFamily: 'Switzer',
                                  fontSize: 25,
                                  fontWeight: FontWeight.w900,
                                ),
                              ),
                              Text(
                                "come back in a bit, see u",
                                style: TextStyle(
                                  fontSize: 14, // Adjust the size as needed
                                  //fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                        )
                      ],
                      Spacer(),
                      Container(
                        margin: EdgeInsets.only(bottom: 0), // Adjust as needed
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

  Widget _userDetails(
      nextUser, viewModel, context, Animation<Offset> slideAnimation) {
    SwipeItem? swipeItem; // Declare swipeItem as nullable
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
        likeAction: () {
          //skip for now
          print("I am in like");
          viewModel.skip_user(nextUser['id']);
          //viewModel.like_user(nextUser['id'], nextUser['potential_match']);
        },
        nopeAction: () {
          print("I am in dislike");
          viewModel.skip_user(nextUser['id']);
        },
        onSlideUpdate: onSlideUpdateCallback
        // Include other actions like superLike if you have them
        );

    MatchEngine matchEngine = MatchEngine(swipeItems: [swipeItem]);

    return Container(
      key: ValueKey(DateTime.now().millisecondsSinceEpoch),
      height: 400,
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
  return Padding(
      padding: const EdgeInsets.only(top: 50.0),
      child: Column(
        children: [
          const Text(
            'Hello, in Qaabl!',
            style: TextStyle(
              fontFamily: 'Switzer',
              fontSize: 25,
              fontWeight: FontWeight.w900,
            ),
          ),
          Text(
            "explore cool people, at your fingertips",
            style: TextStyle(
              fontFamily: 'Switzer', // Replace with your font if it's different
              fontSize: 14, // Adjust the size as needed
              //fontWeight: FontWeight.bold,
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
                ClampingScrollPhysics(), // This will enable scrolling in the ListView
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
        backgroundColor: Color(0xFF3439AB),
        //title: Text('User Profile'),
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
            viewModel.signOut();
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

  UserCard(this.nextUser, this.viewModel, this.context, this.slideAnimation,
      this.key)
      : super(key: key);

  @override
  _UserCardState createState() => _UserCardState();
}

class _UserCardState extends State<UserCard> {
  String? feedback; // this variable will store the feedback "Like" or "Dislike"
  Color? feedbackColor;
  IconData? feedbackIcon;

  @override
  Widget build(BuildContext context) {
    // This is your current code for _userCard, but wrapped inside a stateful widget
    return SlideTransition(
      position: widget.slideAnimation,
      child: Stack(children: [
        Card(
            color: Color.fromARGB(255, 239, 239, 239),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10.0),
            ),
            elevation: 5,
            child: Padding(
                padding: EdgeInsets.all(10.0),
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      Center(
                        // Center the interests area
                        child: Column(
                          children: [
                            Padding(padding: EdgeInsets.only(top: 25)),
                            Text(
                              "I like ${widget.nextUser['interests'][0]['name']}",
                              style: TextStyle(
                                fontSize: 25, // Adjust the size as needed
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Image.asset(
                              'lib/assets/${widget.nextUser['image_index']}.png',
                              height: 200,
                            ),
                            Text(
                              "And... ${widget.nextUser['interests'][0]['description']}",
                              style: TextStyle(
                                fontSize: 18, // Adjust the size as needed
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(top: 20.0),
                              child: Row(
                                // Align Like and Dislike buttons horizontally
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                children: [
                                  ElevatedButton(
                                    onPressed: () {
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
                                    child: Icon(Icons.thumb_down,
                                        color: Colors.black), // Close icon
                                  ),
                                  ElevatedButton(
                                    onPressed: () {
                                      widget.viewModel.like_user(
                                          widget.nextUser['id'],
                                          widget.nextUser['potential_match']);
                                    },
                                    style: ElevatedButton.styleFrom(
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(
                                            30), // Rounded button
                                      ),
                                      backgroundColor: Color(0xFF3439AB),
                                    ),
                                    child: Icon(Icons.thumb_up,
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
              padding: EdgeInsets.all(8.0),
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
    setState(() {
      feedback = feedbackText;
      if (feedbackText == "Like") {
        feedbackColor = Color(0xFF3439AB);
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
          "but I have ${nextUser['interests'].length} more interests, check me out",
          style: TextStyle(
            fontFamily: 'Switzer', // Replace with your font if it's different
            fontSize: 14, // Adjust the size as needed
          ),
        ),
        ElevatedButton(
          onPressed: () {
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
            backgroundColor: Color(0xFF3439AB), // Background color
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(30), // Rounded button
            ),
          ),
          child: Text("View Profile"),
        ),
      ],
    );
  } else {
    return Text("No more users to display.");
  }
}
