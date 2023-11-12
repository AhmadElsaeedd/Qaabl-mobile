import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';
import 'package:qaabl_mobile/ui/common/ui_helpers.dart';

import 'edit_profile_viewmodel.dart';

class EditProfileView extends StatefulWidget {
  //List<String>? selected_interests;
  // ignore: non_constant_identifier_names
  EditProfileView({Key? key}) : super(key: key);

  @override
  _EditProfileViewState createState() => _EditProfileViewState();
}

class _EditProfileViewState extends State<EditProfileView> {
  late TextEditingController nameController;
  late TextEditingController aspirationController;
  late List<TextEditingController> interestControllers;
  late List<TextEditingController> interestNameControllers;
  late ValueNotifier<int> selectedImageNotifier;
  bool isSaving = false;

  @override
  void initState() {
    super.initState();
    selectedImageNotifier = ValueNotifier<int>(0);
    nameController = TextEditingController();
    aspirationController = TextEditingController();
    interestControllers = <TextEditingController>[];
    interestNameControllers = <TextEditingController>[];
  }

  @override
  void dispose() {
    nameController.dispose();
    aspirationController.dispose();
    for (var controller in interestControllers) {
      controller.dispose();
    }
    for (var controller in interestNameControllers) {
      controller.dispose();
    }
    selectedImageNotifier.dispose();
    super.dispose();
  }

  void _showInterestsDialog(EditProfileViewModel model) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Column(
            children: [
              Text(
                'Choose your interests',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w900,
                ),
              ),
              Text(
                "show us what ur all about!",
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
          content: StatefulBuilder(
            builder: (BuildContext context, StateSetter setState) {
              return SingleChildScrollView(
                child: Column(
                  children: model.predefined_interests.map((interest) {
                    bool isSelected = model.user_data['interests']
                        .any((map) => map['name'] == interest);
                    return ListTile(
                      title: Text(
                        interest,
                        style: TextStyle(
                          fontSize: 16,
                          color: isSelected
                              ? Colors.white
                              : Colors
                                  .black, // Change text color based on selection.
                        ),
                      ),
                      tileColor: isSelected
                          ? const Color(0xFF3439AB)
                          : Colors.transparent,
                      onTap: () {
                        model.toggleInterestSelection(interest);
                        setState(() {});
                      },
                    );
                  }).toList(),
                ),
              );
            },
          ),
          actions: [
            // This is the check mark button
            IconButton(
              icon: const Icon(
                Icons.check,
                color: Color(0xFF3439AB),
              ),
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
              },
            ),
          ],
        );
      },
    );
  }

  void _showAspirationDialog(EditProfileViewModel model) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Column(
            children: [
              Text(
                'Choose your aspiration',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w900,
                ),
              ),
              Text(
                "show us what ur all about!",
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
          content: StatefulBuilder(
            builder: (BuildContext context, StateSetter setState) {
              return SingleChildScrollView(
                child: Column(
                  children: model.predefined_aspirations.map((aspiration) {
                    bool isSelected =
                        model.user_data['aspiration'] == aspiration;
                    return ListTile(
                      title: Text(
                        aspiration,
                        style: TextStyle(
                          fontSize: 16,
                          color: isSelected
                              ? Colors.white
                              : Colors
                                  .black, // Change text color based on selection.
                        ),
                      ),
                      tileColor: isSelected
                          ? const Color(0xFF3439AB)
                          : Colors.transparent,
                      onTap: () {
                        print("aspiration clicked: " + aspiration);
                        model.toggleAspirationSelection(aspiration);
                        setState(() {});
                      },
                    );
                  }).toList(),
                ),
              );
            },
          ),
          actions: [
            // This is the check mark button
            IconButton(
              icon: const Icon(
                Icons.check,
                color: Color(0xFF3439AB),
              ),
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<EditProfileViewModel>.reactive(
      viewModelBuilder: () => EditProfileViewModel(),
      builder: (context, model, child) {
        Map<String, dynamic>? userData = model.user_data;

        if (userData.isNotEmpty) {
          selectedImageNotifier =
              ValueNotifier<int>(userData['image_index'] ?? 0);
          nameController = TextEditingController(text: userData['name'] ?? '');
          interestNameControllers = List.generate(
            (userData['interests']?.length ?? 0),
            (index) {
              String interestName = userData['interests'][index]['name'] ?? '';
              return TextEditingController(text: interestName);
            },
          );
          interestControllers = List.generate(
            (userData['interests']?.length ?? 0),
            (index) {
              String interestName = userData['interests'][index]['name'] ?? '';
              return TextEditingController(
                  text: userData['interests']
                          .any((interest) => interest['name'] == interestName)
                      ? userData['interests'].firstWhere((interest) =>
                              interest['name'] ==
                              interestName)['description'] ??
                          ''
                      : '');
            },
          );

          return Scaffold(
            backgroundColor: Colors.white,
            body: SafeArea(
                child: GestureDetector(
              onTap: () {
                //dismiss keyboard when tapped outside
                FocusScope.of(context).unfocus();
              },
              child: Stack(
                children: [
                  Padding(
                    padding:
                        const EdgeInsets.only(right: 25.0, left: 25, top: 10),
                    child: SingleChildScrollView(
                      child: Column(
                        children: [
                          const Text(
                            "Your Profile",
                            style: TextStyle(
                              fontSize: 25,
                              fontWeight: FontWeight.w900,
                            ),
                          ),
                          ValueListenableBuilder<int>(
                            valueListenable: selectedImageNotifier,
                            builder: (context, value, child) => GestureDetector(
                              onTap: () async {
                                int? chosenIndex = await showDialog<int>(
                                  context: context,
                                  builder: (context) => ImageChooserDialog(),
                                );
                                if (chosenIndex != null) {
                                  selectedImageNotifier.value =
                                      chosenIndex; // Set the new value
                                  model.user_data['image_index'] = chosenIndex;
                                }
                              },
                              child: Column(
                                children: [
                                  Image.asset(
                                    'lib/assets/$value.png',
                                    height: 200,
                                  ), // Use the value
                                  const Text(
                                    'edit your avatar',
                                    style: TextStyle(
                                      color: Color(0xFF3439AB),
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          TextField(
                            controller: nameController,
                            decoration:
                                const InputDecoration(labelText: 'Name'),
                            onChanged: (text) {
                              model.update_name(text);
                            },
                          ),
                          const Padding(padding: EdgeInsets.only(top: 10)),
                          const Align(
                            alignment: Alignment.centerLeft,
                            child: Text(
                              "Your Aspiration",
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ),
                          const Padding(padding: EdgeInsets.only(top: 5)),
                          const Align(
                            alignment: Alignment.centerLeft,
                            child: Text(
                              "what do u aspire to be?",
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                          const Padding(padding: EdgeInsets.only(top: 10)),
                          Align(
                            alignment: Alignment.centerLeft,
                            child: Text(
                              userData.containsKey('aspiration') &&
                                      userData['aspiration'].isNotEmpty
                                  ? "I aspire to be a: ${userData['aspiration']}"
                                  : "No aspiration chosen",
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w500,
                                color: Colors.black54,
                              ),
                            ),
                          ),
                          CupertinoButton(
                            onPressed: () {
                              _showAspirationDialog(model);
                            },
                            child: const Text(
                              'choose your aspiration ⚔️',
                              style: TextStyle(
                                color: Color(0xFF3439AB),
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                          const Padding(padding: EdgeInsets.only(top: 10)),
                          const Align(
                            alignment: Alignment.centerLeft,
                            child: Text(
                              "Your Interests",
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ),
                          const Padding(padding: EdgeInsets.only(top: 5)),
                          const Align(
                            alignment: Alignment.centerLeft,
                            child: Text(
                              "tell us what really interests u!",
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                          ...List.generate(
                            interestControllers.length,
                            (index) => TextField(
                              controller: interestControllers[index],
                              decoration: InputDecoration(
                                labelText: userData['interests'][index]['name'],
                              ),
                              onChanged: (text) {
                                model.update_interest_description(
                                    userData['interests'][index]['name'], text);
                              },
                            ),
                          ),
                          CupertinoButton(
                            onPressed: () {
                              _showInterestsDialog(model);
                            },
                            child: const Text(
                              'edit your interests',
                              style: TextStyle(
                                color: Color(0xFF3439AB),
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                          const SizedBox(height: 10),
                          CupertinoButton(
                            color: const Color(0xFF3439AB),
                            onPressed: () async {
                              setState(() {
                                isSaving =
                                    true; // Set isSaving to true when the button is pressed
                              });
                              String name = nameController.text;
                              List<Map<String, String>> interests =
                                  List.generate(
                                interestControllers.length,
                                (index) => {
                                  'name': interestNameControllers[index]
                                      .text, // Using the text from the name controller
                                  'description':
                                      interestControllers[index].text,
                                },
                              );
                              String aspiration = userData['aspiration'];
                              await model.save_and_back(name, interests,
                                  aspiration, selectedImageNotifier.value);
                              //show a circular progress bar while this await is done
                              setState(() {
                                isSaving =
                                    false; // Reset isSaving to false when the await is done
                              });
                            },
                            child: const Text('Save and back',
                                style: TextStyle(color: Colors.white)),
                            padding: const EdgeInsets.symmetric(
                                horizontal: 20, vertical: 10),
                          ),
                        ],
                      ),
                    ),
                  ),
                  if (isSaving)
                    const Positioned.fill(
                      child: Center(
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            SizedBox(
                              width: 16,
                              height: 16,
                              child: CircularProgressIndicator(
                                color: Colors.black,
                                strokeWidth: 6,
                              ),
                            )
                          ],
                        ),
                      ),
                    ),
                ],
              ),
            )),
            bottomNavigationBar: Padding(
              padding: const EdgeInsets.only(right: 25.0, left: 25, bottom: 30),
              child: _bottomNavigationBar(model),
            ),
          );
        } else {
          return const Scaffold(
            body: Center(
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text('Loading ...', style: TextStyle(fontSize: 16)),
                  horizontalSpaceSmall,
                  SizedBox(
                    width: 16,
                    height: 16,
                    child: CircularProgressIndicator(
                      color: Colors.black,
                      strokeWidth: 6,
                    ),
                  )
                ],
              ),
            ),
          );
        }
      },
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

class ImageChooserDialog extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Dialog(
      child: Container(
        width: double.maxFinite, // Take the maximum width available
        child: GridView.builder(
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2, // Put them in 2 columns next to each other
          ),
          itemCount: 10, // As you have images from 0.png to 11.png
          itemBuilder: (context, index) {
            return GestureDetector(
              onTap: () {
                Navigator.of(context).pop(index);
              },
              child: Image.asset(
                'lib/assets/$index.png',
                height: 100,
              ), // Increase the sizes of the images
            );
          },
        ),
      ),
    );
  }
}
