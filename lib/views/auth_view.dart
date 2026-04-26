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
  bool _isLogin = true;
  bool _isLoading = false;
  final supabase = Supabase.instance.client;

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
      if (_isLogin) {
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
          await supabase.from('profiles').insert({
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
}
