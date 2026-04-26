import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    final supabase = Supabase.instance.client;

    return Center(
      child: OutlinedButton(
        onPressed: () async {
          await supabase.auth.signOut();
        },
        style: OutlinedButton.styleFrom(
          foregroundColor: Colors.red,
          backgroundColor: const Color.fromARGB(0, 239, 159, 159),
        ),
        child: const Text('Log out'),
      ),
    );
  }
}
