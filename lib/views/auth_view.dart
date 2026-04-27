import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:screen2green/components/atoms/single_text_field.dart';
import 'package:screen2green/components/atoms/my_special_button.dart';

class AuthView extends StatefulWidget {
  const AuthView({super.key});

  @override
  State<AuthView> createState() => _AuthViewState();
}

class _AuthViewState extends State<AuthView> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _firstNameController = TextEditingController();
  final _lastNameController = TextEditingController();
  final supabase = Supabase.instance.client;

  bool? _screenMode;
  bool _isLoading = false;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _firstNameController.dispose();
    _lastNameController.dispose();
    super.dispose();
  }

  Future<void> _handleAuth() async {
    setState(() => _isLoading = true);

    try {
      if (_screenMode == true) {
        await supabase.auth.signInWithPassword(
          email: _emailController.text.trim(),
          password: _passwordController.text,
        );
      } else {
        final response = await supabase.auth.signUp(
          email: _emailController.text.trim(),
          password: _passwordController.text,
        );

        final userId = response.user?.id;
        if (userId != null) {
          await supabase.from('users').insert({
            'id': userId,
            'first_name': _firstNameController.text.trim(),
            'last_name': _lastNameController.text.trim(),
          });
        }
      }
    } on AuthException catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text(e.message)));
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('An error occurred: $e')));
      }
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                _isLogin ? 'Welcome back' : 'Create account',
                style: Theme.of(context).textTheme.displayLarge,
              ),
              const SizedBox(height: 32),
              SingleTextField(controller: _emailController, label: 'Email'),
              const SizedBox(height: 16),
              SingleTextField(
                controller: _passwordController,
                label: 'Password',
                obscureText: true,
              ),
              if (!_isLogin) ...[
                const SizedBox(height: 16),
                SingleTextField(
                  controller: _firstNameController,
                  label: 'First name',
                ),
                const SizedBox(height: 16),
                SingleTextField(
                  controller: _lastNameController,
                  label: 'Last name',
                ),
              ],
              const SizedBox(height: 24),
              _isLoading
                  ? const CircularProgressIndicator()
                  : MySpecialButton(
                      _isLogin ? 'Log in' : 'Register',
                      _handleAuth,
                    ),
              const SizedBox(height: 16),
              TextButton(
                onPressed: () => setState(() => _isLogin = !_isLogin),
                child: Text(
                  _isLogin
                      ? "Don't have an account? Register"
                      : 'Already have an account? Log in',
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildWelcomeScreen() {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 28),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 24),
            Expanded(
              child: ClipRRect(
                borderRadius: BorderRadius.circular(24),
                child: Image.asset(
                  'assets/images/auth_plant.png',
                  width: double.infinity,
                  fit: BoxFit.cover,
                ),
              ),
            ),

            const SizedBox(height: 36),

            RichText(
              text: const TextSpan(
                style: TextStyle(
                  fontWeight: FontWeight.w800,
                  fontSize: 40,
                  color: Color(0xFF2F342E),
                  height: 1.1,
                  letterSpacing: -1,
                ),
                children: [
                  TextSpan(text: 'Grow Your '),
                  TextSpan(
                    text: 'Focus',
                    style: TextStyle(
                      color: Color(0xFF50662B),
                      fontStyle: FontStyle.italic,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 12),
            const Text(
              'Convert your productivity into botanical life. Cultivate your digital garden by staying present.',
              style: TextStyle(
                color: Color(0xFF5C605A),
                height: 1.6,
                fontSize: 14,
              ),
            ),
            const SizedBox(height: 28),
            Row(
              children: [
                Expanded(
                  flex: 3,
                  child: _GradientButton(
                    'Create Account',
                    () => setState(() => _screenMode = false),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  flex: 2,
                  child: MySpecialButton(
                    'Log In',
                    () => setState(() => _screenMode = true),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 32),
          ],
        ),
      ),
    );
  }
}
