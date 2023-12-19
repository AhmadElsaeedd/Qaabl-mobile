import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'dart:io' show Platform;
import 'package:stacked/stacked.dart';

import 'register_viewmodel.dart';

// ignore: must_be_immutable
class RegisterView extends StackedView<RegisterViewModel> {
  RegisterView({Key? key}) : super(key: key);

  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  bool _isPasswordVisible = false;

  @override
  Widget builder(
    BuildContext context,
    RegisterViewModel viewModel,
    Widget? child,
  ) {
    return Scaffold(
        backgroundColor: Colors.white,
        body: SafeArea(
            child: GestureDetector(
          onTap: () {
            //dismiss keyboard when tapped outside
            FocusScope.of(context).unfocus();
          },
          child: Container(
              padding:
                  const EdgeInsets.symmetric(horizontal: 25.0, vertical: 20.0),
              child: SingleChildScrollView(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Container(
                      height: MediaQuery.of(context).size.height / 3,
                      child: Center(
                        child: Image.asset(
                          'lib/assets/logo.png',
                          height: 200,
                        ),
                      ),
                    ),
                    // SizedBox(height: 10),
                    Padding(
                        padding: const EdgeInsets.symmetric(vertical: 10.0),
                        child: Column(
                          children: [
                            Text(
                              "only cool people, at your fingertips",
                              style: GoogleFonts.lexend(
                                fontSize: 14, // Adjust the size as needed
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        )),
                    Container(
                      child: Column(
                        children: [
                          Platform.isIOS
                              ? CupertinoTextField(
                                  placeholder: 'Email',
                                  controller: emailController,
                                  keyboardType: TextInputType.emailAddress,
                                  padding: EdgeInsets.symmetric(
                                      vertical: 10, horizontal: 12),
                                )
                              : TextField(
                                  controller: emailController,
                                  decoration:
                                      InputDecoration(labelText: 'Email'),
                                  keyboardType: TextInputType.emailAddress,
                                ),
                          SizedBox(height: 20),
                          Platform.isIOS
                              ? StatefulBuilder(
                                  builder: (BuildContext context,
                                      StateSetter setCupertinoState) {
                                    return Stack(
                                      alignment: Alignment.centerRight,
                                      children: [
                                        CupertinoTextField(
                                          placeholder: 'Password',
                                          controller: passwordController,
                                          obscureText: !_isPasswordVisible,
                                          padding: EdgeInsets.symmetric(
                                              vertical: 10.0,
                                              horizontal:
                                                  12.0), // make room for the button
                                        ),
                                        IconButton(
                                          icon: Icon(
                                            _isPasswordVisible
                                                ? Icons.visibility
                                                : Icons.visibility_off,
                                          ),
                                          onPressed: () {
                                            setCupertinoState(() {
                                              _isPasswordVisible =
                                                  !_isPasswordVisible;
                                            });
                                          },
                                        ),
                                      ],
                                    );
                                  },
                                )
                              : TextField(
                                  controller: passwordController,
                                  obscureText: !_isPasswordVisible,
                                  decoration: InputDecoration(
                                    labelText: 'Password',
                                    // 2. Use suffixIcon to add the "eye" icon.
                                    suffixIcon: IconButton(
                                      icon: Icon(
                                        // Depending on the state, show the appropriate icon.
                                        _isPasswordVisible
                                            ? Icons.visibility
                                            : Icons.visibility_off,
                                      ),
                                      onPressed: () {
                                        _isPasswordVisible =
                                            !_isPasswordVisible;
                                      },
                                    ),
                                  ),
                                ),
                          SizedBox(height: 20),
                          Platform.isIOS
                              ? CupertinoButton(
                                  color: Color(0xFF3439AB),
                                  onPressed: () =>
                                      viewModel.createUserWithEmailAndPassword(
                                          emailController.text,
                                          passwordController.text),
                                  child: Text(
                                    'Create Account',
                                    style: GoogleFonts.lexend(fontSize: 20),
                                  ),
                                  padding: EdgeInsets.symmetric(
                                      horizontal: 20, vertical: 10),
                                )
                              : ElevatedButton(
                                  onPressed: () =>
                                      viewModel.createUserWithEmailAndPassword(
                                          emailController.text,
                                          passwordController.text),
                                  child: Text(
                                    'Create Account',
                                    style: GoogleFonts.lexend(fontSize: 20),
                                  ),
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Color(0xFF3439AB),
                                    padding: EdgeInsets.symmetric(
                                        horizontal: 20, vertical: 10),
                                  ),
                                ),
                          SizedBox(height: 20),
                        ],
                      ),
                    ),
                    Row(
                      children: [
                        Expanded(
                          child: Divider(
                            color: Colors.black,
                            height: 20,
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 10),
                          child: Text("or", style: GoogleFonts.lexend()),
                        ),
                        Expanded(
                          child: Divider(
                            color: Colors.black,
                            height: 20,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 20),
                    Container(
                      margin: EdgeInsets.only(bottom: 10),
                      child: Platform.isIOS
                          ? CupertinoButton(
                              onPressed: viewModel.signInWithGoogle,
                              child: Image.asset(
                                'lib/assets/googlebutton.png',
                                fit: BoxFit.fill,
                                scale: 2,
                              ),
                              padding: EdgeInsets.zero,
                              pressedOpacity: 0.7,
                            )
                          : ElevatedButton(
                              onPressed: viewModel.signInWithGoogle,
                              child: Image.asset(
                                'lib/assets/googlebutton.png',
                                fit: BoxFit.fill,
                                scale: 2,
                              ),
                              style: ElevatedButton.styleFrom(
                                padding: EdgeInsets.zero,
                                backgroundColor: Colors.transparent,
                              ),
                            ),
                    ),
                    Container(
                      margin: EdgeInsets.only(bottom: 10),
                      child: Platform.isIOS
                          ? CupertinoButton(
                              onPressed: viewModel.signInWithApple,
                              child: Image.asset(
                                'lib/assets/applebutton.png',
                                fit: BoxFit.fill,
                                scale: 2,
                              ),
                              padding: EdgeInsets.zero,
                              pressedOpacity: 0.7,
                            )
                          : ElevatedButton(
                              onPressed: viewModel.signInWithApple,
                              child: Image.asset(
                                'lib/assets/applebutton.png',
                                fit: BoxFit.fill,
                                scale: 2,
                              ),
                              style: ElevatedButton.styleFrom(
                                padding: EdgeInsets.zero,
                                backgroundColor: Colors.transparent,
                              ),
                            ),
                    ),
                    Container(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text('Already have an account?',
                              style: GoogleFonts.lexend()),
                          TextButton(
                            onPressed: viewModel.navigateToLogin,
                            child: Text(
                              'Login Now',
                              style: GoogleFonts.lexend(
                                  decoration: TextDecoration.underline),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              )),
        )));
  }

  @override
  RegisterViewModel viewModelBuilder(
    BuildContext context,
  ) =>
      RegisterViewModel();
}
