import 'package:flutter/cupertino.dart';
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
              const Padding(
                  padding: EdgeInsets.symmetric(vertical: 20.0),
                  child: Column(
                    children: [
                      Text(
                        'its a match!',
                        style: TextStyle(
                          fontFamily: 'Switzer',
                          fontSize: 25,
                          fontWeight: FontWeight.w900,
                        ),
                      ),
                      Text(
                        "ur cool, they're cool, chat!",
                        style: TextStyle(
                          fontFamily:
                              'Switzer', // Replace with your font if it's different
                          fontSize: 14, // Adjust the size as needed
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  )),
              Row(
                mainAxisAlignment:
                    MainAxisAlignment.spaceEvenly, // Center the buttons
                children: [
                  Flexible(
                      child: CupertinoButton(
                    color: const Color.fromARGB(255, 239, 239, 239),
                    onPressed: () {
                      // "Keep swiping" button action here
                      viewModel.go_to_swiping();
                    },
                    child: const Text(
                      "Keep Swiping",
                      style:
                          TextStyle(color: Colors.black, fontFamily: "Switzer"),
                    ),
                    padding: const EdgeInsets.symmetric(
                        horizontal: 20, vertical: 10),
                  )
                      // style: ElevatedButton.styleFrom(
                      //   shape: RoundedRectangleBorder(
                      //     borderRadius:
                      //         BorderRadius.circular(30), // Rounded button
                      //   ),
                      //   backgroundColor: Colors.white,
                      // ),
                      ),
                  Flexible(
                      child: CupertinoButton(
                    color: const Color(0xFF3439AB),
                    onPressed: () {
                      // "Go to chats" button action here
                      viewModel.go_to_chats();
                    },
                    child: const Text(
                      "Chats",
                      style: TextStyle(color: Colors.white),
                    ),
                    padding: const EdgeInsets.symmetric(
                        horizontal: 20, vertical: 10),
                  )
                      // style: ElevatedButton.styleFrom(
                      //   shape: RoundedRectangleBorder(
                      //     borderRadius:
                      //         BorderRadius.circular(30), // Rounded button
                      //   ),
                      //   backgroundColor: Color(0xFF3439AB),
                      // ),
                      ),
                ],
              ),
              const Spacer(),
              Container(
                margin: const EdgeInsets.only(bottom: 25), // Adjust as needed
                child: _bottomNavigationBar(viewModel),
              ),
            ],
          )),
    );
  }

  @override
  ItsAMatchViewModel viewModelBuilder(
    BuildContext context,
  ) =>
      ItsAMatchViewModel();
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
            viewModel.go_to_home();
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
