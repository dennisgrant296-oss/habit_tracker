import 'package:flutter/material.dart';
import 'package:habit_tracker/controllers/signupcontroller.dart';
import 'package:get/get.dart';

Signupcontroller signupController = Get.find<Signupcontroller>();
TextEditingController fullNameController = TextEditingController();
TextEditingController emailController = TextEditingController();
TextEditingController passwordController = TextEditingController();
TextEditingController confirmPasswordController = TextEditingController();

class SignupScreen extends StatefulWidget {
  const SignupScreen({super.key});

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [Color(0xFF1A2A3A), Color(0xFF0D1B2A), Color(0xFF1B263B)],
          ),
        ),
        child: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.bolt, size: 60, color: Colors.greenAccent),
                const SizedBox(height: 10),
                const Text(
                  "JOIN THE FORGE",
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 3,
                    color: Colors.white,
                  ),
                ),
                const Text(
                  "Start your transformation today",
                  style: TextStyle(fontSize: 14, color: Colors.white70),
                ),
                const SizedBox(height: 40),

                // Full Name
                _buildInputField(
                  controller: fullNameController,
                  hint: "Full Name",
                  icon: Icons.person_outline,
                ),
                const SizedBox(height: 15),

                // Email
                _buildInputField(
                  controller: emailController,
                  hint: "Email Address",
                  icon: Icons.email_outlined,
                ),
                const SizedBox(height: 15),

                // Password
                Obx(
                  () => _buildPasswordField(
                    controller: passwordController,
                    hint: "Password (min. 8 chars)",
                    isVisible: signupController.passwordVisible.value,
                    onToggle: () => signupController.togglePassword(),
                  ),
                ),
                const SizedBox(height: 15),

                // Confirm Password
                Obx(
                  () => _buildPasswordField(
                    controller: confirmPasswordController,
                    hint: "Confirm Password",
                    isVisible: signupController.passwordVisible.value,
                    onToggle: () => signupController.togglePassword(),
                  ),
                ),
                const SizedBox(height: 30),

                // Sign Up Button
                SizedBox(
                  width: double.infinity,
                  height: 55,
                  child: Obx(
                    () => ElevatedButton(
                      onPressed: signupController.isLoading.value
                          ? null
                          : () async {
                              String fullName = fullNameController.text;
                              String email = emailController.text;
                              String password = passwordController.text;
                              String confirmPassword =
                                  confirmPasswordController.text;

                              if (password != confirmPassword) {
                                Get.snackbar("Error", "Passwords do not match");
                                return;
                              }
                              if (password.length < 8) {
                                Get.snackbar(
                                  "Error",
                                  "Password must be 8+ characters",
                                );
                                return;
                              }
                              if (!email.contains('@')) {
                                Get.snackbar("Error", "Enter valid email");
                                return;
                              }
                              if (fullName.isEmpty ||
                                  email.isEmpty ||
                                  password.isEmpty) {
                                Get.snackbar("Error", "Fill all fields");
                                return;
                              }

                              String username = email.split('@')[0];
                              bool success = await signupController.signup(
                                fullName,
                                email,
                                password,
                                username,
                              );
                              if (success) {
                                Get.offAllNamed("/login");
                              }
                            },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.greenAccent,
                        foregroundColor: Colors.black,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15),
                        ),
                      ),
                      child: signupController.isLoading.value
                          ? const CircularProgressIndicator(color: Colors.black)
                          : const Text(
                              "CREATE ACCOUNT",
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                letterSpacing: 2,
                              ),
                            ),
                    ),
                  ),
                ),
                const SizedBox(height: 20),

                // Login Link
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text(
                      "Already have an account? ",
                      style: TextStyle(color: Colors.white70),
                    ),
                    GestureDetector(
                      onTap: () => Get.toNamed("/login"),
                      child: const Text(
                        "LOGIN",
                        style: TextStyle(
                          color: Colors.greenAccent,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 1,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildInputField({
    required TextEditingController controller,
    required String hint,
    required IconData icon,
  }) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(15),
        boxShadow: [
          BoxShadow(
            color: Colors.black26,
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: TextField(
        controller: controller,
        style: const TextStyle(color: Colors.white),
        decoration: InputDecoration(
          hintText: hint,
          hintStyle: const TextStyle(color: Colors.white54),
          filled: true,
          fillColor: Colors.white.withOpacity(0.1),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(15),
            borderSide: BorderSide.none,
          ),
          prefixIcon: Icon(icon, color: Colors.greenAccent),
        ),
      ),
    );
  }

  Widget _buildPasswordField({
    required TextEditingController controller,
    required String hint,
    required bool isVisible,
    required VoidCallback onToggle,
  }) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(15),
        boxShadow: [
          BoxShadow(
            color: Colors.black26,
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: TextField(
        controller: controller,
        obscureText: !isVisible,
        style: const TextStyle(color: Colors.white),
        decoration: InputDecoration(
          hintText: hint,
          hintStyle: const TextStyle(color: Colors.white54),
          filled: true,
          fillColor: Colors.white.withOpacity(0.1),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(15),
            borderSide: BorderSide.none,
          ),
          prefixIcon: const Icon(Icons.lock_outline, color: Colors.greenAccent),
          suffixIcon: IconButton(
            icon: Icon(
              isVisible ? Icons.visibility_off : Icons.visibility,
              color: Colors.greenAccent,
            ),
            onPressed: onToggle,
          ),
        ),
      ),
    );
  }
}
