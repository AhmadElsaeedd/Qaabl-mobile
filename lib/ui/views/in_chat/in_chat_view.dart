import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';

import 'in_chat_viewmodel.dart';

class InChatView extends StackedView<InChatViewModel> {
  const InChatView({Key? key}) : super(key: key);

  @override
  Widget builder(
    BuildContext context,
    InChatViewModel viewModel,
    Widget? child,
  ) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      body: Container(
        padding: const EdgeInsets.only(left: 25.0, right: 25.0),
      ),
    );
  }

  @override
  InChatViewModel viewModelBuilder(
    BuildContext context,
  ) =>
      InChatViewModel();
}
