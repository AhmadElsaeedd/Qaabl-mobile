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
                        if (nextUser != null && nextUser['interests'].isNotEmpty)
                          Column(
                            children: [
                              Text("Interest: ${nextUser['interests'][0]['name']}"), // Assuming interests is a list
                              Text("Interest: ${nextUser['interests'][0]['description']}"),
                              // Add buttons or gestures to like or dislike
                              ElevatedButton(
                                onPressed: () {
                                  // TODO: Implement like functionality
                                  viewModel.like_user(nextUser['id']);
                                },
                                style: ElevatedButton.styleFrom(backgroundColor: Colors.white),
                                child: const Text("Like", style:TextStyle(color: Colors.black)),
                              ),
                              ElevatedButton(
                                onPressed: () {
                                  // TODO: Implement dislike functionality
                                  // viewModel.dislike_user(nextUser['id']);
                                },
                                style: ElevatedButton.styleFrom(backgroundColor: Colors.white),
                                child: const Text("Dislike", style:TextStyle(color: Colors.black)),
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
                      child: Text('Sign out'))
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}

