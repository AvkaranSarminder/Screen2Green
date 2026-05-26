import 'package:flutter/material.dart';
import 'package:screen2green/components/atoms/my_special_button.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class ProfileView extends StatelessWidget {
  const ProfileView({super.key});

  @override
  Widget build(BuildContext context) {
    final supabase = Supabase.instance.client;

    return Center(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
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
    );
  }
}
