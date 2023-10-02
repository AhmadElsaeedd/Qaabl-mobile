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
        padding: const EdgeInsets.only(left: 25.0, right: 25.0),
        child: Column(
          children: [Padding(
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
                      child: Text("Keep swiping"),
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
                      child: Text("Go to chats"),
                      style: ElevatedButton.styleFrom(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30), // Rounded button
                      ), backgroundColor: Color(0xFF3439AB),
                    ),
                    ),
                  ],
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
