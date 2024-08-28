import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:spotify/core/firebase_auth/auth_services.dart';
import 'package:spotify/core/pallete.dart';
import 'package:spotify/features/auth/data/models/login/login_request_model.dart';
import 'package:spotify/features/auth/presentation/logic/auth_controller.dart';
import 'package:spotify/features/auth/presentation/logic/auth_state.dart';
import 'package:spotify/features/auth/presentation/views/screens/signup_page.dart';
import 'package:spotify/features/auth/presentation/views/widgets/custom_field.dart';
import 'package:spotify/features/auth/presentation/views/widgets/gradient_button.dart';
import 'package:spotify/features/home/presentation/views/screens/home_page.dart';

import '../../../../../core/utils.dart';

class LoginPage extends ConsumerStatefulWidget {
  const LoginPage({super.key});

  @override
  ConsumerState<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends ConsumerState<LoginPage> {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final formKey = GlobalKey<FormState>();
  bool isGoogleLoading = false;

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isLoading = ref.watch(authControllerProvider
        .select((val) => val == const AuthState.loading()));
    // ref.listen(authControllerProvider, (prev, next) {
    // ref.listen(authControllerProvider, (_, next) {
    //   next.when(
    //     data: (data) {
    // Navigator.pushAndRemoveUntil(
    //   context,
    //   MaterialPageRoute(
    //     builder: (context) => const HomePage(),
    //   ),
    //   (_) => false,
    // );
    //     },
    //     error: (error, st) {
    //       showSnackBar(context, error.toString());
    //     },
    //     loading: () {},
    //   );
    // });
    return Scaffold(
      appBar: AppBar(),
      body: Padding(
        padding: const EdgeInsets.all(15.0),
        child: Form(
          key: formKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text(
                'Sign In.',
                style: TextStyle(
                  fontSize: 50,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 30),
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
                      buttonText: 'Sign in',
                      onTap: () async {
                        if (formKey.currentState!.validate()) {
                          var response = await ref
                              .read(authControllerProvider.notifier)
                              .login(LoginRequestModel(
                                emailController.text,
                                passwordController.text,
                              ));

                          if (!context.mounted) return;
                          response.isSuccess
                              ? {
                                  showSnackBar(
                                    context,
                                    'Welcome ${response.data!.name}! Logged in successfully.',
                                  ),
                                  Navigator.pushAndRemoveUntil(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => const HomePage(),
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
                      builder: (context) => const SignupPage(),
                    ),
                  );
                },
                child: RichText(
                  text: TextSpan(
                    text: 'Don\'t have an account? ',
                    style: Theme.of(context).textTheme.titleMedium,
                    children: const [
                      TextSpan(
                        text: 'Sign Up',
                        style: TextStyle(
                          color: Pallete.gradient2,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              isGoogleLoading
                  ? const CircularProgressIndicator()
                  : ElevatedButton.icon(
                      style: ButtonStyle(
                        backgroundColor:
                            WidgetStateProperty.all(const Color(0xffDB4437)),
                      ),
                      onPressed: () async {
                        // setState(() {
                        //   isGoogleLoading = true;
                        // });

                        final data = await ref
                            .read(authServicesProvider)
                            .authSignWithGoogle(context);
                        if (data != null) {
                          if (context.mounted) {
                            var response = await ref
                                .watch(authControllerProvider.notifier)
                                .login(
                                  LoginRequestModel(
                                    data.user!.email.toString(),
                                    "googlelogin",
                                    photoUrl: data.user!.photoURL.toString(),
                                    name: data.user!.displayName.toString(),
                                    isGoogle: true,
                                  ),
                                );
                            if (!context.mounted) return;
                            response.isSuccess
                                ? {
                                    showSnackBar(
                                      context,
                                      'Welcome ${response.data!.name}! Logged in successfully.',
                                    ),
                                    Navigator.pushAndRemoveUntil(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => const HomePage(),
                                      ),
                                      (_) => false,
                                    )
                                  }
                                : showSnackBar(context, response.message);
                          }
                        }
                        // setState(() {
                        //   isGoogleLoading = false;
                        // });
                      },
                      icon: const Icon(
                        Icons.textsms_sharp,
                        color: Colors.white,
                      ),
                      label: const Text("Login with Google"),
                    ),
            ],
          ),
        ),
      ),
    );
  }
}
