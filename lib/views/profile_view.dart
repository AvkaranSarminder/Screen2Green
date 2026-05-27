import 'package:flutter/material.dart';
import 'package:screen2green/components/atoms/my_special_button.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class ProfileView extends StatelessWidget {
  final String firstName;
  final String lastName;
  final String email;
  final bool isLoading;

  const ProfileView({
    super.key,
    required this.firstName,
    required this.lastName,
    required this.email,
    required this.isLoading,
  });

  Widget _buildProfileRow(
    String label,
    String value,
    TextTheme textTheme,
    ColorScheme colorScheme,
  ) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: textTheme.bodyMedium?.copyWith(
              color: colorScheme.onSurfaceVariant,
              fontWeight: FontWeight.w500,
            ),
          ),
          Text(
            value,
            style: textTheme.bodyLarge?.copyWith(
              color: colorScheme.onSurface,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDivider(ColorScheme colorScheme) {
    return Divider(
      height: 1,
      thickness: 0.5,
      color: colorScheme.outlineVariant.withValues(alpha: 0.5),
    );
  }

  @override
  Widget build(BuildContext context) {
    final supabase = Supabase.instance.client;
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              'Profile',
              style: textTheme.displayLarge?.copyWith(
                color: colorScheme.onSurface,
                fontSize: 32,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 6),
            Image.asset('assets/images/male_pfp.png', width: 160),
            const SizedBox(height: 24),
            isLoading
                ? const Padding(
                    padding: EdgeInsets.symmetric(vertical: 24.0),
                    child: CircularProgressIndicator(),
                  )
                : Container(
                    width: double.infinity,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 24,
                      vertical: 12,
                    ),
                    decoration: BoxDecoration(
                      color: colorScheme.surfaceContainerLow,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Column(
                      children: [
                        _buildProfileRow(
                          'First name',
                          firstName,
                          textTheme,
                          colorScheme,
                        ),
                        _buildDivider(colorScheme),
                        _buildProfileRow(
                          'Last name',
                          lastName,
                          textTheme,
                          colorScheme,
                        ),
                        _buildDivider(colorScheme),
                        _buildProfileRow(
                          'Email',
                          email,
                          textTheme,
                          colorScheme,
                        ),
                      ],
                    ),
                  ),
            const SizedBox(height: 24),
            MySpecialButton(
              'Log out',
              () async {
                await supabase.auth.signOut();
              },
              danger: true,
              icon: const Icon(Icons.logout_rounded, color: Colors.white),
            ),
          ],
        ),
      ),
    );
  }
}
