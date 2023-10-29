import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'dart:io' show Platform;
import 'package:stacked/stacked.dart';

import 'register_viewmodel.dart';

class RegisterView extends StackedView<RegisterViewModel> {
  const RegisterView({Key? key}) : super(key: key);

  @override
  Widget builder(
    BuildContext context,
    RegisterViewModel viewModel,
    Widget? child,
  ) {
    final emailController = TextEditingController();
    final passwordController = TextEditingController();

    return Scaffold(
        backgroundColor: Colors.white,
        body: SafeArea(
          child: Container(
              padding: const EdgeInsets.only(left: 25.0, right: 25.0),
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
                    Padding(
                        padding: const EdgeInsets.only(top: 0.0),
                        child: Column(
                          children: [
                            Text(
                              "only cool people, at your fingertips",
                              style: TextStyle(
                                fontFamily:
                                    Platform.isIOS ? '.SF UI Text' : 'Switzer',
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
                                )
                              : TextField(
                                  controller: emailController,
                                  decoration:
                                      InputDecoration(labelText: 'Email'),
                                ),
                          SizedBox(height: 20),
                          Platform.isIOS
                              ? CupertinoTextField(
                                  placeholder: 'Password',
                                  controller: passwordController,
                                  obscureText: true,
                                )
                              : TextField(
                                  controller: passwordController,
                                  decoration:
                                      InputDecoration(labelText: 'Password'),
                                  obscureText: true,
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
                                    style: TextStyle(fontSize: 20),
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
                                    style: TextStyle(fontSize: 20),
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
                          child: Text("or"),
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
                              ),
                              padding: EdgeInsets.zero,
                              pressedOpacity: 0.7,
                            )
                          : ElevatedButton(
                              onPressed: viewModel.signInWithGoogle,
                              child: Image.asset(
                                'lib/assets/googlebutton.png',
                                fit: BoxFit.fill,
                              ),
                              style: ElevatedButton.styleFrom(
                                padding: EdgeInsets.zero,
                                primary: Colors.transparent,
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
                              ),
                              padding: EdgeInsets.zero,
                              pressedOpacity: 0.7,
                            )
                          : ElevatedButton(
                              onPressed: viewModel.signInWithApple,
                              child: Image.asset(
                                'lib/assets/applebutton.png',
                                fit: BoxFit.fill,
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
                          Text('Already have an account?'),
                          TextButton(
                            onPressed: viewModel.navigateToLogin,
                            child: Text(
                              'Login Now',
                              style: TextStyle(
                                  decoration: TextDecoration.underline),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              )),
        ));
  }

  @override
  RegisterViewModel viewModelBuilder(
    BuildContext context,
  ) =>
      RegisterViewModel();
}
