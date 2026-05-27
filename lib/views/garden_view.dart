import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:screen2green/components/molecules/social_media_post.dart';

class GardenView extends StatelessWidget {
  const GardenView({super.key});

  @override
  Widget build(BuildContext context) {
    final supabase = Supabase.instance.client;
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    final postsFuture = supabase
        .from('social_media_posts')
        .select('''
          id,
          created_at,
          description,
          thumbnail,
          users:author_id (
            first_name
          )
        ''')
        .order('created_at', ascending: false);

    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              'Community Garden',
              style: textTheme.displayLarge?.copyWith(
                color: colorScheme.onSurface,
                fontSize: 32,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),
            FutureBuilder<dynamic>(
              future: postsFuture,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Padding(
                    padding: EdgeInsets.symmetric(vertical: 40.0),
                    child: CircularProgressIndicator(),
                  );
                }

                if (snapshot.hasError) {
                  return const Center(
                    child: Padding(
                      padding: EdgeInsets.symmetric(vertical: 40.0),
                      child: Text(
                        'No community posts yet. Be the first to share!',
                        style: TextStyle(color: Colors.grey),
                      ),
                    ),
                  );
                }

                final posts = snapshot.data as List<dynamic>? ?? [];
                if (posts.isEmpty) {
                  return const Center(
                    child: Padding(
                      padding: EdgeInsets.symmetric(vertical: 40.0),
                      child: Text(
                        'No community posts yet. Be the first to share!',
                        style: TextStyle(color: Colors.grey),
                      ),
                    ),
                  );
                }

                return GridView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    crossAxisSpacing: 16,
                    mainAxisSpacing: 16,
                    childAspectRatio: 0.75,
                  ),
                  itemCount: posts.length,
                  itemBuilder: (context, index) {
                    final post = posts[index] as Map<String, dynamic>;
                    final imageUrl = post['thumbnail'] as String? ?? '';
                    final description = post['description'] as String? ?? '';
                    final createdAtStr = post['created_at'] as String? ?? '';

                    final usersData = post['users'] as Map<String, dynamic>?;
                    final authorFirstName =
                        usersData?['first_name'] as String? ?? 'Anonymous';

                    String date = 'N/A';
                    if (createdAtStr.isNotEmpty) {
                      try {
                        final parsedDate = DateTime.parse(createdAtStr);
                        date =
                            '${parsedDate.day}/${parsedDate.month}/${parsedDate.year}';
                      } catch (_) {}
                    }

                    return SocialMediaPost(
                      imageUrl: imageUrl,
                      description: description,
                      date: date,
                      authorFirstName: authorFirstName,
                    );
                  },
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
