import 'dart:math';

import 'package:assignment_sankar_group/screens/authenticate_bloc/authenticate_bloc.dart';
import 'package:assignment_sankar_group/screens/authenticate_bloc/authenticate_event.dart';
import 'package:assignment_sankar_group/screens/authenticate_bloc/authenticate_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../constants/routes/app_routes.dart';

class LoginPage extends StatefulWidget {
  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  bool isLogin=true;
  bool isLoading = false;
  bool isPasswordHidden = true;

  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  final TextEditingController emailController = TextEditingController();
  final TextEditingController passController = TextEditingController();
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
                          "Welcome Back 👋",
                          style: TextStyle(
                            fontSize: 26,
                            fontWeight: FontWeight.bold,
                          ),
                        ),

                        SizedBox(height: 25),

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
                            if (value == null || value.isEmpty) {
                              return "Enter Your Email";
                            }
                            return null;
                          },
                        ),

                        SizedBox(height: 15),

                        // Password
                        TextFormField(
                          controller: passController,
                          obscureText: isPasswordHidden,
                          decoration: InputDecoration(
                            labelText: "Password",
                            prefixIcon: Icon(Icons.lock),
                            suffixIcon: IconButton(
                              onPressed: () {
                                setState(() {
                                  isPasswordHidden = !isPasswordHidden;
                                });
                              },
                              icon: Icon(
                                isPasswordHidden
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
                              return "Enter Password";
                            }
                            return null;
                          },
                        ),

                        SizedBox(height: 25),
                        SizedBox(
                          width: double.infinity,
                          height: 50,
                          child: BlocConsumer<AuthenticateBloc,
                              AuthenticateState>(
                            builder: (_, state) {
                              return ElevatedButton(
                                onPressed: () {
                                  if (formKey.currentState!.validate()) {
                                    context.read<AuthenticateBloc>().add(
                                      LoginUserEvent(
                                        email: emailController.text,
                                        pass: passController.text,
                                      ),
                                    );
                                  }
                                },
                                style: ElevatedButton.styleFrom(
                                  foregroundColor: Colors.white,
                                  shape: RoundedRectangleBorder(
                                    borderRadius:
                                    BorderRadius.circular(12),
                                  ),
                                  backgroundColor: Colors.blue,
                                ),
                                child: isLoading
                                    ? CircularProgressIndicator(
                                  color: Colors.white,
                                )
                                    : Text(
                                  "Login",
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
                                    content: Text(state.errMsg.toString()),
                                    backgroundColor: Colors.red,
                                  ),
                                );
                                setState(() => isLoading = false);
                              } else if (state
                              is AuthenticateLoginSuccessState) {
                                Navigator.pushReplacementNamed(context, AppRoutes.taskPage);
                                ScaffoldMessenger.of(context)
                                    .showSnackBar(
                                  SnackBar(
                                    content: Text("Login Successful"),
                                    backgroundColor: Colors.green,
                                  ),
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
                              AppRoutes.signupPage,
                            );
                          },
                          child: Text("Don't have an account? Sign Up"),
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