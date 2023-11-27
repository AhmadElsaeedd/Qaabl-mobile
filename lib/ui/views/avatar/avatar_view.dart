import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';

import 'avatar_viewmodel.dart';

class AvatarView extends StackedView<AvatarViewModel> {
  const AvatarView({Key? key}) : super(key: key);

  @override
  Widget builder(
    BuildContext context,
    AvatarViewModel viewModel,
    Widget? child,
  ) {
    viewModel.initializeCamera();

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        // padding: const EdgeInsets.only(left: 25.0, right: 25.0),
        child: Column(
          children: [
            const Text(
              "Your Avatar",
              style: TextStyle(
                fontSize: 25,
                fontWeight: FontWeight.w900,
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  AvatarViewModel viewModelBuilder(
    BuildContext context,
  ) =>
      AvatarViewModel();
}
