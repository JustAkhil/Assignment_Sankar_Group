import 'package:assignment_sankar_group/models/user_model.dart';
import 'package:assignment_sankar_group/screens/authenticate_bloc/authenticate_event.dart';
import 'package:assignment_sankar_group/screens/authenticate_bloc/authenticate_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../constants/routes/app_routes.dart';
import 'authenticate_bloc/authenticate_bloc.dart';

class SignUpPage extends StatefulWidget {
  @override
  State<SignUpPage> createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  bool isLoading = false;
  bool isPassHidden = true;
  bool isConfirmPassHidden = true;
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  final TextEditingController nameController = TextEditingController();

  final TextEditingController emailController = TextEditingController();

  final TextEditingController passController = TextEditingController();

  final TextEditingController confirmPassController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.blue.shade400, Colors.blue.shade900],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Center(
          child: SingleChildScrollView(
            child: Padding(
              padding:  EdgeInsets.all(16),
              child: Card(
                elevation: 10,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Padding(
                  padding:  EdgeInsets.all(20),
                  child: Form(
                    key: formKey,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          "Create Account",
                          style: TextStyle(
                            fontSize: 26,
                            fontWeight: FontWeight.bold,
                          ),
                        ),

                        SizedBox(height: 25),

                        // Name
                        TextFormField(
                          controller: nameController,
                          decoration: InputDecoration(
                            labelText: "Name",
                            prefixIcon: Icon(Icons.person),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return "Enter Your Name";
                            }
                            return null;
                          },
                        ),

                        SizedBox(height: 15),

                        // Email
                        TextFormField(
                          controller: emailController,
                          decoration: InputDecoration(
                            labelText: "Email",
                            prefixIcon: Icon(Icons.email),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          validator: (value) {
                            RegExp emailReg = RegExp(
                              r'^[a-zA-Z0-9]+([._%+-]?[a-zA-Z0-9]+)*@[a-zA-Z0-9-]+(\.[a-zA-Z]{2,})+$',
                            );
                            if (value == null || value.isEmpty) {
                              return "Enter Your Email";
                            } else if (!emailReg.hasMatch(value)) {
                              return "Enter a Valid Email";
                            }
                            return null;
                          },
                        ),

                        SizedBox(height: 15),

                        // Password
                        TextFormField(
                          controller: passController,
                          obscureText: isPassHidden,
                          decoration: InputDecoration(
                            labelText: "Password",
                            prefixIcon: Icon(Icons.lock),
                            suffixIcon: IconButton(
                              onPressed: () {
                                setState(() {
                                  isPassHidden = !isPassHidden;
                                });
                              },
                              icon: Icon(
                                isPassHidden
                                    ? Icons.visibility_off
                                    : Icons.visibility,
                              ),
                            ),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          validator: (value) {
                            RegExp passReg = RegExp(
                              r'^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9])(?=.*?[!@#\$&*~]).{8,}$',
                            );
                            if (value == null || value.isEmpty) {
                              return "Enter a password";
                            } else if (!passReg.hasMatch(value)) {
                              return "Weak Password";
                            }
                            return null;
                          },
                        ),

                        SizedBox(height: 15),

                        // Confirm Password
                        TextFormField(
                          controller: confirmPassController,
                          obscureText: isConfirmPassHidden,
                          decoration: InputDecoration(
                            labelText: "Confirm Password",
                            prefixIcon: Icon(Icons.lock_outline),
                            suffixIcon: IconButton(
                              onPressed: () {
                                setState(() {
                                  isConfirmPassHidden =
                                  !isConfirmPassHidden;
                                });
                              },
                              icon: Icon(
                                isConfirmPassHidden
                                    ? Icons.visibility_off
                                    : Icons.visibility,
                              ),
                            ),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return "Confirm Password";
                            } else if (value != passController.text) {
                              return "Password Does Not Match";
                            }
                            return null;
                          },
                        ),

                        SizedBox(height: 25),

                        // Button
                        SizedBox(
                          width: double.infinity,
                          height: 50,
                          child: BlocConsumer<AuthenticateBloc,
                              AuthenticateState>(
                            builder: (_, state) {
                              return ElevatedButton(
                                onPressed: () {
                                  if (formKey.currentState!.validate()) {
                                    UserModel user = UserModel(
                                      email: emailController.text,
                                      name: nameController.text,
                                    );
                                    context
                                        .read<AuthenticateBloc>()
                                        .add(
                                      CreateUserEvent(
                                        userModel: user,
                                        pass: passController.text,
                                      ),
                                    );
                                  }
                                },
                                style: ElevatedButton.styleFrom(
                                  shape: RoundedRectangleBorder(
                                    borderRadius:
                                    BorderRadius.circular(12),
                                  ),
                                  backgroundColor: Colors.blue,
                                  foregroundColor: Colors.white
                                ),
                                child: isLoading
                                    ? CircularProgressIndicator(
                                  color: Colors.white,
                                )
                                    : Text(
                                  "Sign Up",
                                  style: TextStyle(fontSize: 16),
                                ),
                              );
                            },
                            listener: (_, state) {
                              if (state is AuthenticateLoadingState) {
                                setState(() => isLoading = true);
                              } else if (state
                              is AuthenticateFailureState) {
                                ScaffoldMessenger.of(context)
                                    .showSnackBar(
                                  SnackBar(
                                    content: Text(
                                        state.errMsg.toString()),
                                    backgroundColor: Colors.red,
                                  ),
                                );
                                setState(() => isLoading = false);
                              } else if (state
                              is AuthenticateSignupSuccessState) {
                                ScaffoldMessenger.of(context)
                                    .showSnackBar(
                                  SnackBar(
                                    content: Text(
                                        "Account Created Successfully"),
                                    backgroundColor: Colors.green,
                                  ),
                                );

                                Navigator.pushReplacementNamed(
                                  context,
                                  AppRoutes.loginPage,
                                );

                                setState(() => isLoading = false);
                              }
                            },
                          ),
                        ),

                        SizedBox(height: 15),

                        TextButton(
                          onPressed: () {
                            Navigator.pushReplacementNamed(
                              context,
                              AppRoutes.loginPage,
                            );
                          },
                          child: Text("Already have an account? Login"),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
