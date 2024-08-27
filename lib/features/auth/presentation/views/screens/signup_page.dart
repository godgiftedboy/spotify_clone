import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:spotify/core/pallete.dart';
import 'package:spotify/features/auth/data/models/login/login_response_model.dart';
import 'package:spotify/features/auth/data/models/signup/signup_request_model.dart';
import 'package:spotify/features/auth/presentation/logic/auth_controller.dart';
import 'package:spotify/features/auth/presentation/logic/auth_state.dart';
import 'package:spotify/features/auth/presentation/views/screens/login_page.dart';
import 'package:spotify/features/auth/presentation/views/widgets/custom_field.dart';
import 'package:spotify/features/auth/presentation/views/widgets/gradient_button.dart';

import '../../../../../core/utils.dart';

class SignupPage extends ConsumerStatefulWidget {
  const SignupPage({super.key});

  @override
  ConsumerState<SignupPage> createState() => _SignupPageState();
}

class _SignupPageState extends ConsumerState<SignupPage> {
  final nameController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    nameController.dispose();
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // final isLoading = ref
    //     .watch(authControllerProvider.select((val) => val.isLoading == true));
    final isLoading = ref.watch(authControllerProvider
        .select((val) => val == const AuthState.loading()));

    // ref.listen(
    //   authControllerProvider,
    //   (_, next) {
    //     next.when(
    //       data: (data) {
    // showSnackBar(
    //   context,
    //   'Account created successfully! Please  login.',
    // );
    //         Navigator.push(
    //           context,
    //           MaterialPageRoute(
    //             builder: (context) => const LoginPage(),
    //           ),
    //         );
    //       },
    //       error: (error, st) {
    //         showSnackBar(context, error.toString());
    //       },
    //       loading: () {},
    //     );
    //   },
    // );
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(),
      body: Padding(
        padding: const EdgeInsets.all(15.0),
        child: Form(
          key: formKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text(
                'Sign Up.',
                style: TextStyle(
                  fontSize: 50,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 30),
              CustomField(
                hintText: 'Name',
                controller: nameController,
              ),
              const SizedBox(height: 15),
              CustomField(
                hintText: 'Email',
                controller: emailController,
              ),
              const SizedBox(height: 15),
              CustomField(
                hintText: 'Password',
                controller: passwordController,
                isObscureText: true,
              ),
              const SizedBox(height: 20),
              isLoading
                  ? const Center(
                      child: CircularProgressIndicator(),
                    )
                  : AuthGradientButton(
                      buttonText: 'Sign up',
                      onTap: () async {
                        if (formKey.currentState!.validate()) {
                          LoginResponseModel response = await ref
                              .watch(authControllerProvider.notifier)
                              .signup(
                                SignUpRequestModel(
                                    emailController.text,
                                    passwordController.text,
                                    nameController.text),
                              );
                          if (!context.mounted) return;

                          response.isSuccess
                              ? {
                                  showSnackBar(
                                    context,
                                    'Account created successfully! Please  login.',
                                  ),
                                  Navigator.pushAndRemoveUntil(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => const LoginPage(),
                                    ),
                                    (_) => false,
                                  )
                                }
                              : showSnackBar(context, response.message);
                        }
                      },
                    ),
              const SizedBox(height: 20),
              GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const LoginPage(),
                    ),
                  );
                },
                child: RichText(
                  text: TextSpan(
                    text: 'Already have an account? ',
                    style: Theme.of(context).textTheme.titleMedium,
                    children: const [
                      TextSpan(
                        text: 'Sign In',
                        style: TextStyle(
                          color: Pallete.gradient2,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
