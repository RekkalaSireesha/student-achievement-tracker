import 'package:flutter/material.dart';

import '../models/achievement.dart';

class AchievementDetailsScreen
    extends StatelessWidget {
  final Achievement achievement;

  const AchievementDetailsScreen({
    super.key,
    required this.achievement,
  });

  String formatDate(DateTime date) {
    return '${date.day}/${date.month}/${date.year}';
  }

  IconData getCategoryIcon(String category) {
    switch (category) {
      case 'Academic':
        return Icons.school;

      case 'Coding':
        return Icons.code;

      case 'Certification':
        return Icons.card_membership;

      case 'Sports':
        return Icons.sports;

      case 'Hackathon':
        return Icons.groups;

      case 'Cultural':
        return Icons.theater_comedy;

      default:
        return Icons.emoji_events;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Achievement Details',
          style: TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
      ),

      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [

            // Achievement Icon
            CircleAvatar(
              radius: 45,
              backgroundColor:
                  Theme.of(context)
                      .colorScheme
                      .primaryContainer,
              child: Icon(
                getCategoryIcon(
                  achievement.category,
                ),
                size: 50,
                color: Theme.of(context)
                    .colorScheme
                    .primary,
              ),
            ),

            const SizedBox(height: 25),

            // Title
            Text(
              achievement.title,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 26,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 25),

            // Category
            detailCard(
              context,
              icon: Icons.category,
              title: 'Category',
              value: achievement.category,
            ),

            const SizedBox(height: 12),

            // Level
            detailCard(
              context,
              icon: Icons.military_tech,
              title: 'Achievement Level',
              value: achievement.level,
            ),

            const SizedBox(height: 12),

            // Date
            detailCard(
              context,
              icon: Icons.calendar_month,
              title: 'Achievement Date',
              value: formatDate(
                achievement.date,
              ),
            ),

            const SizedBox(height: 12),

            // Description
            Card(
              elevation: 2,
              child: Padding(
                padding: const EdgeInsets.all(18),
                child: Column(
                  crossAxisAlignment:
                      CrossAxisAlignment.start,
                  children: [

                    Row(
                      children: [
                        Icon(
                          Icons.description,
                          color: Theme.of(context)
                              .colorScheme
                              .primary,
                        ),

                        const SizedBox(width: 10),

                        const Text(
                          'Description',
                          style: TextStyle(
                            fontSize: 17,
                            fontWeight:
                                FontWeight.bold,
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 15),

                    Text(
                      achievement.description,
                      style: const TextStyle(
                        fontSize: 16,
                        height: 1.5,
                      ),
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 30),

            // Back button
            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton.icon(
                onPressed: () {
                  Navigator.pop(context);
                },
                icon: const Icon(
                  Icons.arrow_back,
                ),
                label: const Text(
                  'BACK TO ACHIEVEMENTS',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget detailCard(
    BuildContext context, {
    required IconData icon,
    required String title,
    required String value,
  }) {
    return Card(
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(18),
        child: Row(
          children: [

            CircleAvatar(
              backgroundColor:
                  Theme.of(context)
                      .colorScheme
                      .primaryContainer,
              child: Icon(
                icon,
                color: Theme.of(context)
                    .colorScheme
                    .primary,
              ),
            ),

            const SizedBox(width: 15),

            Expanded(
              child: Column(
                crossAxisAlignment:
                    CrossAxisAlignment.start,
                children: [

                  Text(
                    title,
                    style: const TextStyle(
                      color: Colors.grey,
                      fontSize: 14,
                    ),
                  ),

                  const SizedBox(height: 4),

                  Text(
                    value,
                    style: const TextStyle(
                      fontSize: 17,
                      fontWeight:
                          FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}