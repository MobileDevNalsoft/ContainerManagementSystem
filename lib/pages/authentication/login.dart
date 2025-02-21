import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';
import 'package:warehouse_3d/inits/init.dart';
import 'package:warehouse_3d/pages/customs/customs.dart';
import 'package:warehouse_3d/pages/customs/loginformfield.dart';
import 'package:warehouse_3d/responsive/responsive.dart';

import '../../bloc/authentication/authentication_bloc.dart';
import '../../navigations/navigator_service.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  // controllers
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  // Service to handle navigation within the app
  final NavigatorService navigator = getIt<NavigatorService>();

  late AuthenticationBloc _authBloc;

  @override
  void initState() {
    super.initState();
    _authBloc = context.read<AuthenticationBloc>();
    _authBloc.state.obscure = true;
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    double fontSize;
    Device device = getDevice(context);
    switch (device) {
      case Device.mobile:
        fontSize = 12;
        break;
      case Device.tab:
        fontSize = 14;
        break;
      case Device.desktop:
        fontSize = 16;
        break;
    }

    return Scaffold(
      body: Stack(
        alignment: AlignmentDirectional.centerStart,
        children: [
          Container(
              height: size.height,
              width: size.width,
              decoration: const BoxDecoration(color: Color.fromRGBO(173, 190, 214, 1)),
              child: Row(
                children: [
                  Image.asset('assets/images/login_decor.png',
                      height: size.height * 0.95, width: size.width * 0.55, alignment: Alignment.centerLeft, fit: BoxFit.fill),
                  Gap(size.width * 0.1),
                  Column(
                    children: [
                      Gap(size.height * 0.1),
                      Text(
                        "Digital Warehouse",
                        style: TextStyle(
                          fontWeight: FontWeight.w900,
                          fontSize: fontSize + 5,
                        ),
                      ),
                      Gap(size.height * 0.1),
                      // Custom text field for employee ID
                      CustomTextFormField(
                        hintText: 'employee id',
                        controller: _emailController,
                        prefixIcon: Icon(
                          Icons.person,
                          size: size.height * 0.03,
                        ),
                      ),
                      Gap(
                        size.height * 0.03,
                      ),
                      // Custom text field for password
                      BlocConsumer<AuthenticationBloc, AuthenticationState>(
                          listenWhen: (previous, current) =>
                              (current.authenticationStatus == AuthenticationStatus.invalidCredentials ||
                                  current.authenticationStatus == AuthenticationStatus.failure ||
                                  current.authenticationStatus == AuthenticationStatus.accessDenied) &&
                              previous.authenticationStatus != current.authenticationStatus,
                          listener: (context, state) => Customs.AnimatedDialog(
                                  context: context,
                                  header: const Icon(
                                    Icons.error,
                                    size: 35,
                                  ),
                                  content: [
                                    Text(
                                      state.authenticationStatus == AuthenticationStatus.invalidCredentials
                                          ? 'Invalid Credentials'
                                          : state.authenticationStatus == AuthenticationStatus.accessDenied
                                              ? 'Access Denied'
                                              : 'Error',
                                      style: const TextStyle(fontSize: 18),
                                    )
                                  ]),
                          builder: (context, state) {
                            return CustomTextFormField(
                              hintText: 'password',
                              controller: _passwordController,
                              onFieldSubmitted: (p0) {
                                _loginSubmitted(size, fontSize);
                              },
                              prefixIcon: Icon(
                                Icons.key,
                                size: size.height * 0.03,
                              ),
                              obscureText: state.obscure,
                              obscureChar: '*',
                              suffixIcon: IconButton(
                                iconSize: 20,
                                onPressed: () => {
                                  //triggers obscurepassword event to upadate the UI of obscure icon button to show or hide the password.
                                  context.read<AuthenticationBloc>().add(ObscurePasswordTapped())
                                },
                                icon: state.obscure!
                                    ? Icon(
                                        Icons.visibility_off,
                                        size: size.height * 0.025,
                                      )
                                    : Icon(
                                        Icons.visibility,
                                        size: size.height * 0.025,
                                      ),
                              ),
                            );
                          }),
                      Gap(
                        size.height * 0.05,
                      ),
                      ElevatedButton(
                          onPressed: () {
                            _loginSubmitted(size, fontSize);
                          },
                          style: ElevatedButton.styleFrom(
                              fixedSize: Size(size.width * 0.2, size.height * 0.06),
                              overlayColor: Colors.transparent,
                              backgroundColor: const Color.fromRGBO(68, 98, 136, 1),
                              foregroundColor: Colors.white,
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15))),
                          child: Text(
                            'Login',
                            style: TextStyle(fontSize: fontSize, fontWeight: FontWeight.bold),
                          ))
                    ],
                  )
                ],
              )),
          if (context.watch<AuthenticationBloc>().state.authenticationStatus == AuthenticationStatus.loading)
            Container(
              height: size.height,
              width: size.width,
              decoration: const BoxDecoration(color: Colors.white60),
              child: Center(
                child: CircularProgressIndicator(
                  color: Colors.blue.shade900,
                ),
              ),
            )
        ],
      ),
    );
  }

  void _loginSubmitted(Size size, double fontSize) {
    String? message = (_emailController.text.isEmpty ? "username cannot be empty" : null) ??
        // this method validates the password according to regex and gives instructions.
        _passwordValidator(_passwordController.text);

    // Show a snackbar with relevant message if needed
    if (message != null) {
      Customs.AnimatedDialog(
          context: context,
          header: const Icon(
            Icons.error,
            color: Colors.black,
            size: 35,
          ),
          content: [
            Text(
              message,
              style: TextStyle(fontSize: fontSize),
              textAlign: TextAlign.center,
            )
          ]);
    } else {
      // unfocuses all the focused fields
      FocusManager.instance.primaryFocus?.unfocus();
      // triggeres login event and authenticates user info with the info in DB and gets corresponding response
      _authBloc.add(LoginButtonPressed(username: _emailController.text.toLowerCase(), password: _passwordController.text));
    }
  }
}

/// This function validates a password string.
///
/// It checks for emptiness and minimum length (10 characters).
String? _passwordValidator(String value) {
  if (value.isEmpty) {
    return "password cannot be empty";
  } else if (value.length < 10) {
    return "password must contain atleast 10 characters";
  }
  return null;
}
