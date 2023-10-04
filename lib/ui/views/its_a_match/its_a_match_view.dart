import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';

import 'its_a_match_viewmodel.dart';

class ItsAMatchView extends StackedView<ItsAMatchViewModel> {
  const ItsAMatchView({Key? key}) : super(key: key);

  @override
  Widget builder(
    BuildContext context,
    ItsAMatchViewModel viewModel,
    Widget? child,
  ) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Container(
        padding: const EdgeInsets.only(left: 25.0, right: 25.0, top: 300),
        child: Column(
          children: [
            Padding(
          padding: const EdgeInsets.only(top: 50.0),
          child: Column(children: [const Text(
            'its a match!',
            style: TextStyle(
              fontFamily: 'Switzer',
              fontSize: 25,
              fontWeight: FontWeight.w900,
            ),
          ),
        Text("you're cool, they're cool, chat!",
                          style: TextStyle(
                        fontFamily: 'Switzer', // Replace with your font if it's different
                        fontSize: 14, // Adjust the size as needed
                        //fontWeight: FontWeight.bold,
                      ),
                      ),
          ],
          )
        ),
        Row(
                  mainAxisAlignment:
                      MainAxisAlignment.spaceEvenly, // Center the buttons
                  children: [
                    ElevatedButton(
                      onPressed: () {
                        // "Keep swiping" button action here
                        viewModel.go_to_swiping();
                      },
                      child: Text("Keep swiping", style: TextStyle(color: Colors.black, fontFamily: "Switzer"),),
                      style: ElevatedButton.styleFrom(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30), // Rounded button
                        ), backgroundColor: Colors.white,
                      ),
                    ),
                    ElevatedButton(
                      onPressed: () {
                        // "Go to chats" button action here
                        viewModel.go_to_chats();
                      },
                      child: Text("Go to chats",style: TextStyle(color: Colors.white, fontFamily: "Switzer"),),
                      style: ElevatedButton.styleFrom(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30), // Rounded button
                      ), backgroundColor: Color(0xFF3439AB),
                    ),
                    ),
                  ],
                ),
                Spacer(),
                Container(
                      margin: EdgeInsets.only(bottom: 25), // Adjust as needed
                      child: _bottomNavigationBar(viewModel),
                ),
            ],
            
              )
            ),
            
          );

  }

  @override
  ItsAMatchViewModel viewModelBuilder(
    BuildContext context,
  ) =>
      ItsAMatchViewModel();
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
          onTap: () {viewModel.go_to_home();}, // Add your home action here
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
