import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';

import 'edit_profile_viewmodel.dart';

class EditProfileView extends StatefulWidget {
  List<String>? selected_interests;
  // ignore: non_constant_identifier_names
  EditProfileView({Key? key}) : super(key: key);

  @override
  _EditProfileViewState createState() => _EditProfileViewState();
}

class _EditProfileViewState extends State<EditProfileView> {
  late TextEditingController nameController;
  late List<TextEditingController> interestControllers;
  late List<TextEditingController> interestNameControllers;
  late ValueNotifier<int> selectedImageNotifier;
  bool isSaving = false;

  @override
  void initState() {
    super.initState();
    selectedImageNotifier = ValueNotifier<int>(0);
    nameController = TextEditingController();
    interestControllers = <TextEditingController>[];
    interestNameControllers = <TextEditingController>[];
  }

  @override
  void dispose() {
    nameController.dispose();
    interestControllers.forEach((controller) => controller.dispose());
    interestNameControllers.forEach((controller) => controller.dispose());
    selectedImageNotifier.dispose();
    super.dispose();
  }

  void _showInterestsDialog(EditProfileViewModel model) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Column(
            children: [
              const Text(
                'Choose your interests',
                style: TextStyle(
                  fontFamily: 'Switzer',
                  fontSize: 20,
                  fontWeight: FontWeight.w900,
                ),
              ),
              Text(
                "show us what you're all about!",
                style: TextStyle(
                  fontSize: 12, // Adjust the size as needed
                  //fontWeight: FontWeight.bold,
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
                      tileColor:
                          isSelected ? Color(0xFF3439AB) : Colors.transparent,
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
          print("I am rebuilding");
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
              body: Stack(children: [
                Container(
                  padding:
                      const EdgeInsets.only(left: 25.0, right: 25.0, top: 50),
                  child: Column(
                    children: [
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
                              Text(
                                'edit your avatar',
                                style: TextStyle(
                                  color: Color(0xFF3439AB),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      TextField(
                        controller: nameController,
                        decoration: InputDecoration(labelText: 'Name'),
                        onChanged: (text) {
                          model.update_name(text);
                        },
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
                        child: Text(
                          'edit your interests',
                          style: TextStyle(
                            color: Color(0xFF3439AB),
                          ),
                        ),
                      ),
                      ElevatedButton(
                        onPressed: () async {
                          setState(() {
                            isSaving =
                                true; // Set isSaving to true when the button is pressed
                          });
                          String name = nameController.text;
                          List<Map<String, String>> interests = List.generate(
                            interestControllers.length,
                            (index) => {
                              'name': interestNameControllers[index]
                                  .text, // Using the text from the name controller
                              'description': interestControllers[index].text,
                            },
                          );
                          print("Save with image index: " +
                              selectedImageNotifier.value.toString());
                          await model.save_and_back(
                              name, interests, selectedImageNotifier.value);
                          //show a circular progress bar while this await is done
                          setState(() {
                            isSaving =
                                false; // Reset isSaving to false when the await is done
                          });
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Color(0xFF3439AB),
                        ),
                        child: Text('Save and Back'),
                      ),
                      Spacer(),
                      Container(
                        margin: EdgeInsets.only(bottom: 25), // Adjust as needed
                        child: _bottomNavigationBar(model),
                      ),
                    ],
                  ),
                ),
                if (isSaving)
                  Positioned.fill(
                    child: Container(
                      color: Colors.black45,
                      child: Center(
                        child: CircularProgressIndicator(),
                      ),
                    ),
                  ),
              ]));
        } else {
          return Scaffold(
            body: Center(
              child: CircularProgressIndicator(),
            ),
          );
        }
      },
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
            viewModel.go_to_home();
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

class ImageChooserDialog extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Dialog(
      child: Container(
        width: double.maxFinite, // Take the maximum width available
        child: GridView.builder(
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
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
