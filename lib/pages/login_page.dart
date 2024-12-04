import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class LoginSignupScreen extends StatefulWidget {
  const LoginSignupScreen({super.key});

  @override
  _LoginSignupScreenState createState() => _LoginSignupScreenState();
}

class _LoginSignupScreenState extends State<LoginSignupScreen>
    with SingleTickerProviderStateMixin {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  late TabController _tabController;

  final GlobalKey<FormState> _loginFormKey = GlobalKey<FormState>();
  final GlobalKey<FormState> _signupFormKey = GlobalKey<FormState>();

  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmPasswordController =
      TextEditingController();

  bool isSignup = false;
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _tabController.addListener(() {
      setState(() {
        isSignup = _tabController.index == 1;
      });
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    emailController.dispose();
    passwordController.dispose();
    confirmPasswordController.dispose();
    super.dispose();
  }

  void submit() async {
    final currentFormKey = isSignup ? _signupFormKey : _loginFormKey;

    if (currentFormKey.currentState!.validate()) {
      currentFormKey.currentState!.save();
      setState(() => isLoading = true);

      try {
        if (isSignup) {
          if (passwordController.text.trim() !=
              confirmPasswordController.text.trim()) {
            showErrorMessage('Passwords do not match');
            return;
          }
          await _auth.createUserWithEmailAndPassword(
            email: emailController.text.trim(),
            password: passwordController.text.trim(),
          );
        } else {
          await _auth.signInWithEmailAndPassword(
            email: emailController.text.trim(),
            password: passwordController.text.trim(),
          );
        }
        Navigator.pushReplacementNamed(context, '/home');
      } on FirebaseAuthException catch (e) {
        String errorMessage;
        if (e.code == 'user-not-found') {
          errorMessage =
              'No account found with this email. Please check and try again.';
        } else if (e.code == 'wrong-password') {
          errorMessage = 'Incorrect email or password. Please try again.';
        } else if (e.code == 'email-already-in-use') {
          errorMessage =
              'This email is already registered. Please use a different email.';
        } else if (e.code == 'weak-password') {
          errorMessage =
              'Your password is too weak. Please use a stronger password.';
        } else {
          errorMessage =
              // 'An unexpected error occurred. Please try again later.';
              "No account found with this email. Please sign in first.";
        }
        showErrorMessage(errorMessage);
      } catch (e) {
        showErrorMessage('An error occurred. Please try again later.');
      } finally {
        setState(() => isLoading = false);
      }
    }
  }

  void forgotPassword() async {
    if (emailController.text.isEmpty ||
        !RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(emailController.text)) {
      showErrorMessage('Enter a valid email to reset password');
      return;
    }

    try {
      await _auth.sendPasswordResetEmail(email: emailController.text.trim());
      showErrorMessage('Password reset email sent!');
    } catch (e) {
      showErrorMessage(e.toString());
    }
  }

  void showErrorMessage(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.red,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        centerTitle: true,
        title: const Text(
          'CryptoVault',
          style: TextStyle(
              color: Colors.white, fontSize: 24, fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.black,
      ),
      backgroundColor: Colors.black, // Set background color to black
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // App Icon Section
            // Center(
            //   child: Container(
            //     height: 130,
            //     width: 130,
            //     decoration: const BoxDecoration(
            //       shape: BoxShape.circle,
            //       // color: Colors.blueAccent,
            //       image: DecorationImage(
            //         image: AssetImage("assets/CryptoVaultLogo.png"),
            //       ),
            //     ),
            //   ),
            // ),
            // Container for login/signup form
            Container(
              width: double.infinity,
              height: MediaQuery.of(context).size.height * 0.56,
              decoration: BoxDecoration(
                color: Colors.black, // Set the form container to black
                border:
                    Border.all(color: const Color.fromARGB(255, 173, 173, 173)),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Column(
                children: [
                  _buildTabBar(),
                  Expanded(
                    child: TabBarView(
                      controller: _tabController,
                      children: [
                        buildLoginForm(),
                        buildSignupForm(),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
            Center(
              child: Container(
                height: 140,
                width: 140,
                decoration: const BoxDecoration(
                  shape: BoxShape.circle,
                  // color: Colors.blueAccent,
                  image: DecorationImage(
                    image: AssetImage("assets/CryptoVaultLogo.png"),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTabBar() {
    return TabBar(
      controller: _tabController,
      tabs: const [
        Tab(text: 'Login'),
        Tab(text: 'Signup'),
      ],
      indicator: BoxDecoration(
        gradient: LinearGradient(
          colors: [Colors.grey[800]!, Colors.grey[500]!],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(8),
      ),
      labelColor: Colors.white,
      unselectedLabelColor: Colors.grey[400],
      labelStyle: const TextStyle(fontWeight: FontWeight.bold),
      unselectedLabelStyle: const TextStyle(fontWeight: FontWeight.normal),
      indicatorSize: TabBarIndicatorSize.tab,
    );
  }

  Widget buildLoginForm() {
    return buildForm(
      formKey: _loginFormKey,
      fields: [
        buildTextField(
          'Email',
          controller: emailController,
        ),
        buildTextField(
          'Password',
          controller: passwordController,
          obscureText: true,
        ),
      ],
      extraActions: [
        TextButton(
          onPressed: forgotPassword,
          child: const Text('Forgot Password?',
              style: TextStyle(color: Colors.white)),
        ),
      ],
    );
  }

  Widget buildSignupForm() {
    return buildForm(
      formKey: _signupFormKey,
      fields: [
        buildTextField(
          'Email',
          controller: emailController,
        ),
        buildTextField(
          'Password',
          controller: passwordController,
          obscureText: true,
        ),
        buildTextField(
          'Confirm Password',
          controller: confirmPasswordController,
          obscureText: true,
        ),
      ],
    );
  }

  Widget buildForm({
    required GlobalKey<FormState> formKey,
    required List<Widget> fields,
    List<Widget>? extraActions,
  }) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Form(
        key: formKey,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            ...fields,
            if (isLoading)
              const CircularProgressIndicator(
                color: Colors.white,
              ),
            const SizedBox(height: 20),
            GestureDetector(
              onTap: submit,
              child: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [Colors.grey[800]!, Colors.grey[500]!],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(8),
                ),
                padding:
                    const EdgeInsets.symmetric(horizontal: 30, vertical: 15),
                child: Text(
                  isSignup ? 'Signup' : 'Login',
                  style: const TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.bold),
                ),
              ),
            ),
            if (extraActions != null) ...extraActions,
          ],
        ),
      ),
    );
  }

  Widget buildTextField(
    String labelText, {
    required TextEditingController controller,
    bool obscureText = false,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: TextFormField(
        controller: controller,
        decoration: InputDecoration(
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide:
                BorderSide(color: Colors.grey[400]!), // Light grey when focused
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: BorderSide(
                color: Colors.grey[600]!), // Darker grey when not focused
          ),
          hoverColor: Colors.grey,
          focusColor: Colors.grey,
          labelText: labelText,
          labelStyle: const TextStyle(color: Colors.white),
          filled: true,
          fillColor: Colors.grey[850], // Dark gray for background
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: const BorderSide(color: Colors.white),
          ),
        ),
        style: const TextStyle(color: Colors.white),
        obscureText: obscureText,
        cursorColor: const Color.fromARGB(255, 202, 202, 202),
        cursorWidth: 1.76,
        validator: (value) {
          if (value!.isEmpty) return 'Please enter $labelText';
          if (labelText == 'Email' &&
              !RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(value)) {
            return 'Enter a valid email';
          }
          return null;
        },
      ),
    );
  }
}
