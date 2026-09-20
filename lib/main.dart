import 'package:flutter/material.dart';

import 'models/achievement.dart';
import 'models/student_profile.dart';
import 'screens/add_achievement_screen.dart';
import 'screens/achievement_details_screen.dart';
import 'screens/profile_screen.dart';
import 'services/storage_service.dart';

void main() {
  runApp(
    const StudentAchievementTracker(),
  );
}

// ============================================================
// APP
// ============================================================

class StudentAchievementTracker
    extends StatelessWidget {
  const StudentAchievementTracker({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Student Achievement Tracker',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.indigo,
        ),
        useMaterial3: true,
      ),
      home: const HomeScreen(),
    );
  }
}

// ============================================================
// HOME SCREEN
// ============================================================

class HomeScreen extends StatefulWidget {
  const HomeScreen({
    super.key,
  });

  @override
  State<HomeScreen> createState() =>
      _HomeScreenState();
}

class _HomeScreenState
    extends State<HomeScreen> {
  List<Achievement> achievements = [];

  StudentProfile? studentProfile;

  String searchText = '';

  String selectedFilter = 'All';

  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    loadData();
  }

  // ============================================================
  // LOAD DATA
  // ============================================================

  Future<void> loadData() async {
    final List<Achievement>
        savedAchievements =
        await StorageService.loadAchievements();

    final StudentProfile? savedProfile =
        await StorageService.loadProfile();

    if (!mounted) {
      return;
    }

    setState(() {
      achievements = savedAchievements;
      studentProfile = savedProfile;
      isLoading = false;
    });
  }

  // ============================================================
  // ADD ACHIEVEMENT
  // ============================================================

  Future<void> addAchievement() async {
    final Achievement? newAchievement =
        await Navigator.push<Achievement>(
      context,
      MaterialPageRoute(
        builder: (context) =>
            const AddAchievementScreen(),
      ),
    );

    if (newAchievement == null) {
      return;
    }

    setState(() {
      achievements.add(newAchievement);
    });

    await StorageService.saveAchievements(
      achievements,
    );

    if (!mounted) {
      return;
    }

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        behavior: SnackBarBehavior.floating,
        content: Text(
          'Achievement added successfully!',
        ),
      ),
    );
  }

  // ============================================================
  // EDIT ACHIEVEMENT
  // ============================================================

  Future<void> editAchievement(
    int index,
  ) async {
    final Achievement? updatedAchievement =
        await Navigator.push<Achievement>(
      context,
      MaterialPageRoute(
        builder: (context) =>
            AddAchievementScreen(
          achievement: achievements[index],
        ),
      ),
    );

    if (updatedAchievement == null) {
      return;
    }

    setState(() {
      achievements[index] =
          updatedAchievement;
    });

    await StorageService.saveAchievements(
      achievements,
    );

    if (!mounted) {
      return;
    }

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        behavior: SnackBarBehavior.floating,
        content: Text(
          'Achievement updated successfully!',
        ),
      ),
    );
  }

  // ============================================================
  // DELETE ACHIEVEMENT
  // ============================================================

  Future<void> deleteAchievement(
    int index,
  ) async {
    final bool? confirm =
        await showDialog<bool>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text(
            'Delete Achievement',
          ),
          content: const Text(
            'Are you sure you want to delete this achievement?',
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(
                  context,
                  false,
                );
              },
              child: const Text(
                'CANCEL',
              ),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.pop(
                  context,
                  true,
                );
              },
              child: const Text(
                'DELETE',
              ),
            ),
          ],
        );
      },
    );

    if (confirm != true) {
      return;
    }

    setState(() {
      achievements.removeAt(index);
    });

    await StorageService.saveAchievements(
      achievements,
    );

    if (!mounted) {
      return;
    }

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        behavior: SnackBarBehavior.floating,
        content: Text(
          'Achievement deleted!',
        ),
      ),
    );
  }

  // ============================================================
  // PROFILE
  // ============================================================

  Future<void> editProfile() async {
    final StudentProfile? updatedProfile =
        await Navigator.push<StudentProfile>(
      context,
      MaterialPageRoute(
        builder: (context) =>
            ProfileScreen(
          profile: studentProfile,
        ),
      ),
    );

    if (updatedProfile == null) {
      return;
    }

    await StorageService.saveProfile(
      updatedProfile,
    );

    if (!mounted) {
      return;
    }

    setState(() {
      studentProfile = updatedProfile;
    });

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        behavior: SnackBarBehavior.floating,
        content: Text(
          'Profile saved successfully!',
        ),
      ),
    );
  }

  // ============================================================
  // DETAILS
  // ============================================================

  void openAchievementDetails(
    Achievement achievement,
  ) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) =>
            AchievementDetailsScreen(
          achievement: achievement,
        ),
      ),
    );
  }

  // ============================================================
  // FILTERED ACHIEVEMENTS
  // ============================================================

  List<Achievement>
      get filteredAchievements {
    return achievements.where(
      (achievement) {
        final String title =
            achievement.title.toLowerCase();

        final String description =
            achievement.description
                .toLowerCase();

        final String search =
            searchText.toLowerCase();

        final bool matchesSearch =
            title.contains(search) ||
            description.contains(search);

        final bool matchesFilter =
            selectedFilter == 'All' ||
            achievement.category ==
                selectedFilter;

        return matchesSearch &&
            matchesFilter;
      },
    ).toList();
  }

  // ============================================================
  // CATEGORY COUNT
  // ============================================================

  int getCategoryCount(
    String category,
  ) {
    return achievements
        .where(
          (achievement) =>
              achievement.category ==
              category,
        )
        .length;
  }

  // ============================================================
  // DATE
  // ============================================================

  String formatDate(DateTime date) {
    return '${date.day}/${date.month}/${date.year}';
  }

  // ============================================================
  // CATEGORY ICON
  // ============================================================

  IconData getCategoryIcon(
    String category,
  ) {
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

  // ============================================================
  // CATEGORY COLOR
  // ============================================================

  Color getCategoryColor(
    String category,
  ) {
    switch (category) {
      case 'Academic':
        return Colors.blue;

      case 'Coding':
        return Colors.deepPurple;

      case 'Certification':
        return Colors.green;

      case 'Sports':
        return Colors.orange;

      case 'Hackathon':
        return Colors.pink;

      case 'Cultural':
        return Colors.teal;

      default:
        return Colors.indigo;
    }
  }

  // ============================================================
  // BUILD
  // ============================================================

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor:
          const Color(0xfff5f7fb),

      appBar: AppBar(
        backgroundColor:
            const Color(0xfff5f7fb),
        elevation: 0,
        title: const Text(
          'My Achievements',
          style: TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
        actions: [
          IconButton(
            tooltip: 'Refresh',
            onPressed: loadData,
            icon: const Icon(
              Icons.refresh,
            ),
          ),
        ],
      ),

      floatingActionButton:
          FloatingActionButton.extended(
        onPressed: addAchievement,
        backgroundColor: Colors.indigo,
        foregroundColor: Colors.white,
        icon: const Icon(
          Icons.add,
        ),
        label: const Text(
          'Add Achievement',
          style: TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
      ),

      body: isLoading
          ? const Center(
              child:
                  CircularProgressIndicator(),
            )
          : RefreshIndicator(
              onRefresh: loadData,

              child: SingleChildScrollView(
                physics:
                    const AlwaysScrollableScrollPhysics(),

                padding:
                    const EdgeInsets.fromLTRB(
                  16,
                  8,
                  16,
                  100,
                ),

                child: Column(
                  crossAxisAlignment:
                      CrossAxisAlignment.start,

                  children: [

                    // ==================================================
                    // PROFILE HEADER
                    // ==================================================

                    profileHeader(),

                    const SizedBox(
                      height: 24,
                    ),

                    // ==================================================
                    // STATISTICS
                    // ==================================================

                    const Text(
                      'Your Progress',
                      style: TextStyle(
                        fontSize: 21,
                        fontWeight:
                            FontWeight.bold,
                      ),
                    ),

                    const SizedBox(
                      height: 12,
                    ),

                    SizedBox(
                      height: 120,

                      child: ListView(
                        scrollDirection:
                            Axis.horizontal,

                        children: [

                          statisticCard(
                            title: 'Total',
                            count:
                                achievements.length,
                            icon:
                                Icons.emoji_events,
                            color:
                                Colors.indigo,
                          ),

                          statisticCard(
                            title: 'Academic',
                            count:
                                getCategoryCount(
                              'Academic',
                            ),
                            icon:
                                Icons.school,
                            color:
                                Colors.blue,
                          ),

                          statisticCard(
                            title: 'Coding',
                            count:
                                getCategoryCount(
                              'Coding',
                            ),
                            icon:
                                Icons.code,
                            color:
                                Colors.deepPurple,
                          ),

                          statisticCard(
                            title:
                                'Certificates',
                            count:
                                getCategoryCount(
                              'Certification',
                            ),
                            icon:
                                Icons
                                    .card_membership,
                            color:
                                Colors.green,
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(
                      height: 28,
                    ),

                    // ==================================================
                    // SEARCH
                    // ==================================================

                    TextField(
                      decoration:
                          InputDecoration(
                        hintText:
                            'Search achievements...',

                        prefixIcon:
                            const Icon(
                          Icons.search,
                        ),

                        suffixIcon:
                            searchText.isNotEmpty
                                ? IconButton(
                                    onPressed:
                                        () {
                                      setState(
                                        () {
                                          searchText =
                                              '';
                                        },
                                      );
                                    },
                                    icon:
                                        const Icon(
                                      Icons.clear,
                                    ),
                                  )
                                : null,

                        filled: true,

                        fillColor:
                            Colors.white,

                        border:
                            OutlineInputBorder(
                          borderRadius:
                              BorderRadius.circular(
                            16,
                          ),
                          borderSide:
                              BorderSide.none,
                        ),

                        enabledBorder:
                            OutlineInputBorder(
                          borderRadius:
                              BorderRadius.circular(
                            16,
                          ),
                          borderSide:
                              BorderSide.none,
                        ),

                        focusedBorder:
                            OutlineInputBorder(
                          borderRadius:
                              BorderRadius.circular(
                            16,
                          ),
                          borderSide:
                              const BorderSide(
                            color:
                                Colors.indigo,
                            width: 2,
                          ),
                        ),
                      ),

                      onChanged: (value) {
                        setState(() {
                          searchText =
                              value;
                        });
                      },
                    ),

                    const SizedBox(
                      height: 18,
                    ),

                    // ==================================================
                    // CATEGORY CHIPS
                    // ==================================================

                    const Text(
                      'Categories',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight:
                            FontWeight.bold,
                      ),
                    ),

                    const SizedBox(
                      height: 10,
                    ),

                    SizedBox(
                      height: 45,

                      child: ListView(
                        scrollDirection:
                            Axis.horizontal,

                        children: [

                          categoryChip('All'),

                          categoryChip(
                            'Academic',
                          ),

                          categoryChip(
                            'Coding',
                          ),

                          categoryChip(
                            'Certification',
                          ),

                          categoryChip(
                            'Sports',
                          ),

                          categoryChip(
                            'Hackathon',
                          ),

                          categoryChip(
                            'Cultural',
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(
                      height: 24,
                    ),

                    // ==================================================
                    // ACHIEVEMENT TITLE
                    // ==================================================

                    Row(
                      mainAxisAlignment:
                          MainAxisAlignment
                              .spaceBetween,

                      children: [

                        const Text(
                          'Achievements',
                          style: TextStyle(
                            fontSize: 21,
                            fontWeight:
                                FontWeight.bold,
                          ),
                        ),

                        Text(
                          '${filteredAchievements.length} found',
                          style:
                              const TextStyle(
                            color: Colors.grey,
                            fontWeight:
                                FontWeight.w500,
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(
                      height: 12,
                    ),

                    // ==================================================
                    // ACHIEVEMENT LIST
                    // ==================================================

                    if (filteredAchievements
                        .isEmpty)

                      emptyState()

                    else

                      ListView.builder(
                        itemCount:
                            filteredAchievements
                                .length,

                        shrinkWrap: true,

                        physics:
                            const NeverScrollableScrollPhysics(),

                        itemBuilder:
                            (context, index) {

                          final Achievement
                              achievement =
                              filteredAchievements[
                                  index];

                          final int actualIndex =
                              achievements
                                  .indexOf(
                            achievement,
                          );

                          return achievementCard(
                            achievement,
                            actualIndex,
                          );
                        },
                      ),
                  ],
                ),
              ),
            ),
    );
  }

  // ============================================================
  // PROFILE HEADER
  // ============================================================

  Widget profileHeader() {
    return Container(
      width: double.infinity,

      padding:
          const EdgeInsets.all(20),

      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [
            Color(0xff4f46e5),
            Color(0xff6366f1),
            Color(0xff7c3aed),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),

        borderRadius:
            BorderRadius.circular(24),

        boxShadow: [
          BoxShadow(
            color: Colors.indigo
                .withValues(alpha:0.25),
            blurRadius: 18,
            offset:
                const Offset(0, 8),
          ),
        ],
      ),

      child: Row(
        children: [

          Container(
            width: 70,
            height: 70,

            decoration: BoxDecoration(
              color: Colors.white
                  .withValues(alpha:0.2),
              shape: BoxShape.circle,
              border: Border.all(
                color: Colors.white
                    .withValues(alpha:0.5),
                width: 2,
              ),
            ),

            child: const Icon(
              Icons.person,
              size: 40,
              color: Colors.white,
            ),
          ),

          const SizedBox(
            width: 16,
          ),

          Expanded(
            child: Column(
              crossAxisAlignment:
                  CrossAxisAlignment.start,

              children: [

                Text(
                  studentProfile?.name ??
                      'Student Name',

                  style:
                      const TextStyle(
                    color: Colors.white,
                    fontSize: 21,
                    fontWeight:
                        FontWeight.bold,
                  ),
                ),

                const SizedBox(
                  height: 5,
                ),

                Text(
                  studentProfile?.rollNumber ??
                      'Add your roll number',

                  style:
                      TextStyle(
                    color: Colors.white
                        .withValues(alpha:0.9),
                  ),
                ),

                const SizedBox(
                  height: 3,
                ),

                Text(
                  studentProfile?.department ??
                      'Information Technology',

                  style:
                      TextStyle(
                    color: Colors.white
                        .withValues(alpha:0.9),
                  ),
                ),
              ],
            ),
          ),

          IconButton(
            tooltip: 'Edit Profile',

            onPressed: editProfile,

            style: IconButton.styleFrom(
              backgroundColor:
                  Colors.white
                      .withValues(alpha:0.18),
              foregroundColor:
                  Colors.white,
            ),

            icon: const Icon(
              Icons.edit,
            ),
          ),
        ],
      ),
    );
  }

  // ============================================================
  // STATISTIC CARD
  // ============================================================

  Widget statisticCard({
    required String title,
    required int count,
    required IconData icon,
    required Color color,
  }) {
    return Container(
      width: 155,

      margin:
          const EdgeInsets.only(
        right: 12,
      ),

      padding:
          const EdgeInsets.all(16),

      decoration: BoxDecoration(
        color: Colors.white,

        borderRadius:
            BorderRadius.circular(20),

        border: Border.all(
          color: color.withValues(alpha:0.15),
        ),

        boxShadow: [
          BoxShadow(
            color:
                Colors.black.withValues(alpha:0.05),
            blurRadius: 10,
            offset:
                const Offset(0, 4),
          ),
        ],
      ),

      child: Row(
        children: [

          Container(
            width: 46,
            height: 46,

            decoration: BoxDecoration(
              color: color.withValues(alpha:0.12),
              borderRadius:
                  BorderRadius.circular(14),
            ),

            child: Icon(
              icon,
              color: color,
            ),
          ),

          const SizedBox(
            width: 10,
          ),

          Column(
            mainAxisAlignment:
                MainAxisAlignment.center,

            crossAxisAlignment:
                CrossAxisAlignment.start,

            children: [

              Text(
                '$count',

                style:
                    const TextStyle(
                  fontSize: 24,
                  fontWeight:
                      FontWeight.bold,
                ),
              ),

              Text(
                title,

                style:
                    const TextStyle(
                  color: Colors.grey,
                  fontSize: 12,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // ============================================================
  // CATEGORY CHIP
  // ============================================================

  Widget categoryChip(
    String category,
  ) {
    final bool isSelected =
        selectedFilter == category;

    return Padding(
      padding:
          const EdgeInsets.only(
        right: 8,
      ),

      child: FilterChip(
        selected: isSelected,

        label: Text(
          category,
        ),

        avatar: category == 'All'
            ? const Icon(
                Icons.apps,
                size: 18,
              )
            : Icon(
                getCategoryIcon(
                  category,
                ),
                size: 18,
              ),

        onSelected: (selected) {
          setState(() {
            selectedFilter = category;
          });
        },

        selectedColor:
            Colors.indigo.shade100,

        checkmarkColor:
            Colors.indigo,

        backgroundColor:
            Colors.white,

        side: BorderSide(
          color: isSelected
              ? Colors.indigo
              : Colors.grey.shade300,
        ),
      ),
    );
  }

  // ============================================================
  // ACHIEVEMENT CARD
  // ============================================================

  Widget achievementCard(
    Achievement achievement,
    int actualIndex,
  ) {
    final Color categoryColor =
        getCategoryColor(
      achievement.category,
    );

    return Card(
      elevation: 0,

      margin:
          const EdgeInsets.only(
        bottom: 14,
      ),

      shape: RoundedRectangleBorder(
        borderRadius:
            BorderRadius.circular(20),

        side: BorderSide(
          color: Colors.grey.shade200,
        ),
      ),

      child: InkWell(
        borderRadius:
            BorderRadius.circular(20),

        onTap: () {
          openAchievementDetails(
            achievement,
          );
        },

        child: Padding(
          padding:
              const EdgeInsets.all(16),

          child: Row(
            crossAxisAlignment:
                CrossAxisAlignment.start,

            children: [

              // Icon

              Container(
                width: 54,
                height: 54,

                decoration: BoxDecoration(
                  color: categoryColor
                      .withValues(alpha:0.12),

                  borderRadius:
                      BorderRadius.circular(
                    16,
                  ),
                ),

                child: Icon(
                  getCategoryIcon(
                    achievement.category,
                  ),

                  color:
                      categoryColor,

                  size: 28,
                ),
              ),

              const SizedBox(
                width: 14,
              ),

              // Content

              Expanded(
                child: Column(
                  crossAxisAlignment:
                      CrossAxisAlignment.start,

                  children: [

                    Text(
                      achievement.title,

                      maxLines: 2,

                      overflow:
                          TextOverflow.ellipsis,

                      style:
                          const TextStyle(
                        fontSize: 17,
                        fontWeight:
                            FontWeight.bold,
                      ),
                    ),

                    const SizedBox(
                      height: 8,
                    ),

                    Wrap(
                      spacing: 6,
                      runSpacing: 6,

                      children: [

                        Container(
                          padding:
                              const EdgeInsets
                                  .symmetric(
                            horizontal: 10,
                            vertical: 5,
                          ),

                          decoration:
                              BoxDecoration(
                            color: categoryColor
                                .withValues(alpha:
                              0.1,
                            ),

                            borderRadius:
                                BorderRadius
                                    .circular(
                              20,
                            ),
                          ),

                          child: Text(
                            achievement.category,

                            style: TextStyle(
                              color:
                                  categoryColor,
                              fontSize: 12,
                              fontWeight:
                                  FontWeight.bold,
                            ),
                          ),
                        ),

                        Container(
                          padding:
                              const EdgeInsets
                                  .symmetric(
                            horizontal: 10,
                            vertical: 5,
                          ),

                          decoration:
                              BoxDecoration(
                            color: Colors
                                .grey.shade100,

                            borderRadius:
                                BorderRadius
                                    .circular(
                              20,
                            ),
                          ),

                          child: Text(
                            achievement.level,

                            style:
                                const TextStyle(
                              fontSize: 12,
                              fontWeight:
                                  FontWeight.w600,
                            ),
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(
                      height: 8,
                    ),

                    Row(
                      children: [

                        const Icon(
                          Icons
                              .calendar_today,
                          size: 14,
                          color: Colors.grey,
                        ),

                        const SizedBox(
                          width: 5,
                        ),

                        Text(
                          formatDate(
                            achievement.date,
                          ),

                          style:
                              const TextStyle(
                            color: Colors.grey,
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(
                      height: 8,
                    ),

                    Text(
                      achievement.description,

                      maxLines: 2,

                      overflow:
                          TextOverflow.ellipsis,

                      style:
                          const TextStyle(
                        color: Colors.grey,
                        height: 1.4,
                      ),
                    ),

                    const SizedBox(
                      height: 8,
                    ),

                    const Row(
                      children: [

                        Text(
                          'View details',

                          style:
                              TextStyle(
                            color:
                                Colors.indigo,
                            fontSize: 12,
                            fontWeight:
                                FontWeight.bold,
                          ),
                        ),

                        SizedBox(
                          width: 4,
                        ),

                        Icon(
                          Icons
                              .arrow_forward,
                          size: 14,
                          color:
                              Colors.indigo,
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              // Actions

              PopupMenuButton<String>(
                onSelected: (value) {

                  if (value == 'edit') {
                    editAchievement(
                      actualIndex,
                    );
                  }

                  if (value == 'delete') {
                    deleteAchievement(
                      actualIndex,
                    );
                  }
                },

                itemBuilder: (context) => [

                  const PopupMenuItem(
                    value: 'edit',
                    child: Row(
                      children: [
                        Icon(
                          Icons.edit,
                        ),
                        SizedBox(
                          width: 10,
                        ),
                        Text(
                          'Edit',
                        ),
                      ],
                    ),
                  ),

                  const PopupMenuItem(
                    value: 'delete',
                    child: Row(
                      children: [
                        Icon(
                          Icons.delete,
                        ),
                        SizedBox(
                          width: 10,
                        ),
                        Text(
                          'Delete',
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  // ============================================================
  // EMPTY STATE
  // ============================================================

  Widget emptyState() {
    return Container(
      width: double.infinity,

      padding:
          const EdgeInsets.all(35),

      decoration: BoxDecoration(
        color: Colors.white,

        borderRadius:
            BorderRadius.circular(22),

        border: Border.all(
          color: Colors.grey.shade200,
        ),
      ),

      child: Column(
        children: [

          Container(
            width: 80,
            height: 80,

            decoration: BoxDecoration(
              color:
                  Colors.indigo.withValues(alpha:
                0.08,
              ),

              shape: BoxShape.circle,
            ),

            child: const Icon(
              Icons.emoji_events_outlined,
              size: 42,
              color: Colors.indigo,
            ),
          ),

          const SizedBox(
            height: 18,
          ),

          const Text(
            'No achievements found',

            style: TextStyle(
              fontSize: 18,
              fontWeight:
                  FontWeight.bold,
            ),
          ),

          const SizedBox(
            height: 8,
          ),

          Text(
            searchText.isNotEmpty ||
                    selectedFilter != 'All'
                ? 'Try changing your search or category filter.'
                : 'Start building your achievement portfolio today.',

            textAlign:
                TextAlign.center,

            style: const TextStyle(
              color: Colors.grey,
              height: 1.4,
            ),
          ),

          const SizedBox(
            height: 20,
          ),

          if (searchText.isEmpty &&
              selectedFilter == 'All')

            ElevatedButton.icon(
              onPressed:
                  addAchievement,

              icon: const Icon(
                Icons.add,
              ),

              label: const Text(
                'Add Achievement',
              ),
            ),
        ],
      ),
    );
  }
}