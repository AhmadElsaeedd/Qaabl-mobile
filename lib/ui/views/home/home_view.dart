import 'dart:math';
import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';
import 'package:stacked_app/ui/common/app_colors.dart';
import 'package:stacked_app/ui/common/ui_helpers.dart';
import 'package:swipe_cards/swipe_cards.dart';
import 'home_viewmodel.dart';

class HomeView extends StatefulWidget {
  const HomeView({Key? key}) : super(key: key);

  @override
  _HomeViewState createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  
  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<HomeViewModel>.reactive(
      viewModelBuilder: () => HomeViewModel(),
      onViewModelReady: (model) => model.getUsers(),
      builder: (context, viewModel, child) {
        Map<String, dynamic>? nextUser = viewModel.get_next_user();
        print("next user is: " + nextUser.toString());
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
                      if(nextUser != null) ... [
                            Container(
                                margin: EdgeInsets.only( top: 80),
                                child: Center(
                                  child: _userDetails(nextUser, viewModel, context),
                                ),
                              ),
                            Container(
                              margin: EdgeInsets.only( top: 5),
                              child: Center(
                                child: check_profile_button(nextUser,viewModel, context), 
                              ),
                            ),
                      ],
                      Spacer(),
                      Container(
                      margin: EdgeInsets.only(bottom: 20), // Adjust as needed
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

Widget _userDetails(nextUser, viewModel, context) {
  print("NEXT USER IS: " + nextUser.toString());
  SwipeItem swipeItem = SwipeItem(
      content: _userCard(nextUser, viewModel, context), 
      likeAction: () {
        //skip for now
        print("I am in like");
          viewModel.skip_user(nextUser['id']);
      },
      nopeAction: () {
        print("I am in dislike");
          viewModel.skip_user(nextUser['id']);
      }
      // Include other actions like superLike if you have them
  );

  print("CCCCCC");
  MatchEngine matchEngine = MatchEngine(swipeItems: [swipeItem]);
  print("IIIII");

  return Container(
    key: ValueKey(DateTime.now().millisecondsSinceEpoch),
    height: 400,
    child: SwipeCards(
      matchEngine: matchEngine,
      itemBuilder: (BuildContext context, int index) {
        return Container(
            alignment: Alignment.center,
            child: swipeItem.content // This displays the content of the SwipeItem
        );
      },
      onStackFinished: () {
        print("Stack finished");
        // Load more users or any action when all cards are swiped
      },
    ),
  );
}


}

Widget _helloText() {
  return Padding(
    padding: const EdgeInsets.only(top: 50.0),
    child: Column(children: [const Text(
      'Hello, in Qaabl!',
      style: TextStyle(
        fontFamily: 'Switzer',
        fontSize: 25,
        fontWeight: FontWeight.w900,
      ),
    ),
  Text("explore cool people, at your fingertips",
                    style: TextStyle(
                  fontFamily: 'Switzer', // Replace with your font if it's different
                  fontSize: 14, // Adjust the size as needed
                  //fontWeight: FontWeight.bold,
                ),
                ),
    ],
    )
    
    
  );
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
            physics: ClampingScrollPhysics(), // This will enable scrolling in the ListView
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
          color: Colors.grey[300],
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

Widget _userCard(nextUser, viewModel, context) {
  final duration = Duration(seconds: 30);
  ValueKey _tweenKey = ValueKey(DateTime.now());
  return Card(
    color: Color(0xFFAAAAAA),
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(10.0),
    ),
    elevation: 5,
    child: Padding(
      padding: EdgeInsets.all(10.0),
      child: SingleChildScrollView(child: Column(
        children: [
          Center( // Center the interests area
      child: Column(
          children: [
            Text(
              "I like ${nextUser['interests'][0]['name']}",
              style: TextStyle(
                fontFamily: 'Switzer', // Replace with your font if it's different
                fontSize: 25, // Adjust the size as needed
                fontWeight: FontWeight.bold,
              ),
            ),
            Image.asset('lib/assets/${nextUser['image_index']}.png', height: 200,),
            Container(
                height: 10,
                child: TweenAnimationBuilder(
                  duration: duration,
                  key: _tweenKey,
                  tween: Tween(begin: 1.0, end: 0.0),
                  builder: (_, double value, __) {
                    Color color;

                    if (value > 0.5) {
                      color = Colors.green;
                    } else if (value > 0.25) {
                      color = Colors.yellow;
                    } else {
                      color = Colors.red;
                    }

                    return CustomPaint(
                      painter: LinearProgressPainter(color: color, percentage: value),
                      size: Size(MediaQuery.of(context).size.width, 10),
                    );
                  },
                  onEnd: () {
                    print("Timer ended");
                    viewModel.skip_user(nextUser['id']);
                      _tweenKey = ValueKey(DateTime.now());
                  },
                ),
              ),
            Text(
              "And... ${nextUser['interests'][0]['description']}",
              style: TextStyle(
                fontFamily: 'Switzer', // Replace with your font if it's different
                fontSize: 18, // Adjust the size as needed
                fontWeight: FontWeight.bold,
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 20.0),
              child: Row( // Align Like and Dislike buttons horizontally
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
                      ), backgroundColor: Color(0xFF3439AB),
                    ),
                    child: Icon(Icons.check, color: Colors.white), // Check icon
                  ),
                ],
              ),
            ),
          ],
        ),
        ),
        ],
      ),
      )
      )
    );
}

Widget check_profile_button(nextUser, viewModel, context){
  if(nextUser != null && nextUser['interests'].isNotEmpty){
    return Column(children: [
                  Text("but I have ${nextUser['interests'].length} more interests, check me out",
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
                                  interests: List<Map<String, dynamic>>.from(
                                      nextUser['interests']),
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
  }
  else{
    return Text("No more users to display.");
  }
}