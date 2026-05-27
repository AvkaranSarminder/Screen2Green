import 'package:flutter/material.dart';
import 'package:screen2green/components/atoms/my_special_button.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class ProfileView extends StatelessWidget {
  const ProfileView({super.key});

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
            Image.asset('assets/images/male_pfp.png', width: 200),
            const SizedBox(height: 6),
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
