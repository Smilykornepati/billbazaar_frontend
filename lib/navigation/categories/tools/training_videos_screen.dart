import 'package:flutter/material.dart';

class TrainingVideosScreen extends StatefulWidget {
  const TrainingVideosScreen({super.key});

  @override
  State<TrainingVideosScreen> createState() => _TrainingVideosScreenState();
}

class _TrainingVideosScreenState extends State<TrainingVideosScreen> {
  final TextEditingController _searchController = TextEditingController();
  String _selectedCategory = 'All';
  
  final List<Map<String, dynamic>> _trainingVideos = [
    {
      'id': 1,
      'title': 'Getting Started with BillBazar',
      'description': 'Learn the basics of using BillBazar for your business',
      'category': 'Basics',
      'duration': '5:30',
      'difficulty': 'Beginner',
      'views': 1250,
      'isWatched': false,
    },
    {
      'id': 2,
      'title': 'Inventory Management',
      'description': 'Master inventory tracking and stock management',
      'category': 'Inventory',
      'duration': '8:45',
      'difficulty': 'Intermediate',
      'views': 980,
      'isWatched': true,
    },
    {
      'id': 3,
      'title': 'Creating Professional Bills',
      'description': 'Learn to create and customize professional bills',
      'category': 'Billing',
      'duration': '6:20',
      'difficulty': 'Beginner',
      'views': 1500,
      'isWatched': false,
    },
    {
      'id': 4,
      'title': 'Advanced Reporting Features',
      'description': 'Generate detailed reports and analytics',
      'category': 'Reports',
      'duration': '12:15',
      'difficulty': 'Advanced',
      'views': 750,
      'isWatched': false,
    },
    {
      'id': 5,
      'title': 'Credit Management',
      'description': 'Track and manage customer credit effectively',
      'category': 'Billing',
      'duration': '7:30',
      'difficulty': 'Intermediate',
      'views': 890,
      'isWatched': true,
    },
    {
      'id': 6,
      'title': 'Printer Setup and Configuration',
      'description': 'Set up thermal printers and customize settings',
      'category': 'Setup',
      'duration': '4:45',
      'difficulty': 'Beginner',
      'views': 1100,
      'isWatched': false,
    },
  ];

  final List<String> _categories = ['All', 'Basics', 'Inventory', 'Billing', 'Reports', 'Setup'];
  List<Map<String, dynamic>> _filteredVideos = [];

  @override
  void initState() {
    super.initState();
    _filteredVideos = List.from(_trainingVideos);
    _searchController.addListener(_filterVideos);
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _filterVideos() {
    setState(() {
      _filteredVideos = _trainingVideos.where((video) {
        final matchesSearch = video['title'].toLowerCase().contains(_searchController.text.toLowerCase()) ||
                             video['description'].toLowerCase().contains(_searchController.text.toLowerCase());
        final matchesCategory = _selectedCategory == 'All' || video['category'] == _selectedCategory;
        return matchesSearch && matchesCategory;
      }).toList();
    });
  }

  void _toggleWatched(int id) {
    setState(() {
      final index = _trainingVideos.indexWhere((video) => video['id'] == id);
      if (index != -1) {
        _trainingVideos[index]['isWatched'] = !_trainingVideos[index]['isWatched'];
        _filterVideos();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF7FAFC),
      body: LayoutBuilder(
        builder: (context, constraints) {
          final isSmallScreen = constraints.maxWidth < 400;
          
          return Column(
            children: [
              _buildHeader(isSmallScreen),
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      _buildProgressCards(isSmallScreen),
                      _buildSearchAndFilter(isSmallScreen),
                      _buildVideoGrid(isSmallScreen),
                    ],
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildHeader(bool isSmallScreen) {
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [Color(0xFF5777B5), Color(0xFF26344F)],
        ),
      ),
      child: SafeArea(
        bottom: false,
        child: Padding(
          padding: EdgeInsets.fromLTRB(
            isSmallScreen ? 12 : 16,
            isSmallScreen ? 8 : 12,
            isSmallScreen ? 12 : 16,
            isSmallScreen ? 12 : 16,
          ),
          child: Row(
            children: [
              IconButton(
                onPressed: () => Navigator.pop(context),
                icon: Icon(
                  Icons.arrow_back_ios,
                  color: Colors.white,
                  size: isSmallScreen ? 20 : 24,
                ),
                padding: EdgeInsets.zero,
                constraints: const BoxConstraints(),
              ),
              SizedBox(width: isSmallScreen ? 6 : 8),
              Expanded(
                child: Text(
                  'Training Videos',
                  style: TextStyle(
                    fontSize: isSmallScreen ? 16.0 : 18.0,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                    letterSpacing: 0.2,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              IconButton(
                onPressed: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Video Filters'),
                      backgroundColor: Color(0xFF5777B5),
                    ),
                  );
                },
                icon: Icon(
                  Icons.video_library,
                  color: Colors.white,
                  size: isSmallScreen ? 20 : 24,
                ),
                padding: EdgeInsets.zero,
                constraints: const BoxConstraints(),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildProgressCards(bool isSmallScreen) {
    final watchedVideos = _trainingVideos.where((v) => v['isWatched']).length;
    final totalVideos = _trainingVideos.length;
    final completionPercentage = ((watchedVideos / totalVideos) * 100).round();

    return Container(
      margin: EdgeInsets.all(isSmallScreen ? 12 : 16),
      child: Row(
        children: [
          Expanded(
            flex: 2,
            child: _buildStatsCard(
              'Progress',
              '$completionPercentage%',
              Icons.trending_up,
              const Color(0xFF4CAF50),
              isSmallScreen,
            ),
          ),
          SizedBox(width: isSmallScreen ? 8 : 12),
          Expanded(
            child: _buildStatsCard(
              'Watched',
              '$watchedVideos',
              Icons.check_circle,
              const Color(0xFF5777B5),
              isSmallScreen,
            ),
          ),
          SizedBox(width: isSmallScreen ? 8 : 12),
          Expanded(
            child: _buildStatsCard(
              'Total',
              '$totalVideos',
              Icons.video_library,
              const Color(0xFFFF9800),
              isSmallScreen,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatsCard(String title, String value, IconData icon, Color color, bool isSmallScreen) {
    return Container(
      padding: EdgeInsets.all(isSmallScreen ? 12 : 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            spreadRadius: 1,
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: [
          Icon(
            icon,
            color: color,
            size: isSmallScreen ? 20 : 24,
          ),
          SizedBox(height: isSmallScreen ? 4 : 8),
          Text(
            value,
            style: TextStyle(
              fontSize: isSmallScreen ? 16 : 20,
              fontWeight: FontWeight.bold,
              color: const Color(0xFF26344F),
            ),
          ),
          Text(
            title,
            style: TextStyle(
              fontSize: isSmallScreen ? 10 : 12,
              color: Colors.grey[600],
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildSearchAndFilter(bool isSmallScreen) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: isSmallScreen ? 12 : 16),
      padding: EdgeInsets.all(isSmallScreen ? 12 : 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            spreadRadius: 1,
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: [
          // Search Bar
          TextField(
            controller: _searchController,
            style: TextStyle(fontSize: isSmallScreen ? 14 : 16),
            decoration: InputDecoration(
              hintText: 'Search training videos...',
              hintStyle: TextStyle(fontSize: isSmallScreen ? 12 : 14),
              prefixIcon: Icon(
                Icons.search,
                size: isSmallScreen ? 18 : 22,
                color: Colors.grey[600],
              ),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: BorderSide(color: Colors.grey[300]!),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: const BorderSide(color: Color(0xFF5777B5)),
              ),
              contentPadding: EdgeInsets.symmetric(
                horizontal: isSmallScreen ? 12 : 16,
                vertical: isSmallScreen ? 8 : 12,
              ),
            ),
          ),
          SizedBox(height: isSmallScreen ? 8 : 12),
          
          // Category Filter
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: _categories.map((category) {
                final isSelected = _selectedCategory == category;
                return Container(
                  margin: const EdgeInsets.only(right: 8),
                  child: GestureDetector(
                    onTap: () {
                      setState(() {
                        _selectedCategory = category;
                        _filterVideos();
                      });
                    },
                    child: Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: isSmallScreen ? 12 : 16,
                        vertical: isSmallScreen ? 6 : 8,
                      ),
                      decoration: BoxDecoration(
                        color: isSelected ? const Color(0xFF5777B5) : Colors.grey[200],
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(
                        category,
                        style: TextStyle(
                          fontSize: isSmallScreen ? 12 : 14,
                          fontWeight: FontWeight.w500,
                          color: isSelected ? Colors.white : Colors.grey[700],
                        ),
                      ),
                    ),
                  ),
                );
              }).toList(),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildVideoGrid(bool isSmallScreen) {
    if (_filteredVideos.isEmpty) {
      return Container(
        margin: EdgeInsets.all(isSmallScreen ? 12 : 16),
        height: 200,
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.video_library_outlined,
                size: isSmallScreen ? 48 : 64,
                color: Colors.grey[400],
              ),
              SizedBox(height: isSmallScreen ? 12 : 16),
              Text(
                'No videos found',
                style: TextStyle(
                  fontSize: isSmallScreen ? 14 : 16,
                  color: Colors.grey[600],
                ),
              ),
            ],
          ),
        ),
      );
    }

    return Container(
      margin: EdgeInsets.all(isSmallScreen ? 12 : 16),
      child: GridView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: isSmallScreen ? 1 : 2,
          crossAxisSpacing: isSmallScreen ? 8 : 12,
          mainAxisSpacing: isSmallScreen ? 8 : 12,
          childAspectRatio: isSmallScreen ? 3.0 : 2.5,
        ),
        itemCount: _filteredVideos.length,
        itemBuilder: (context, index) {
          final video = _filteredVideos[index];
          return _buildVideoCard(video, isSmallScreen);
        },
      ),
    );
  }

  Widget _buildVideoCard(Map<String, dynamic> video, bool isSmallScreen) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            spreadRadius: 1,
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: InkWell(
        onTap: () {
          _showVideoDialog(video, isSmallScreen);
        },
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: EdgeInsets.all(isSmallScreen ? 12 : 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header with difficulty and watched status
              Row(
                children: [
                  Container(
                    padding: EdgeInsets.symmetric(
                      horizontal: isSmallScreen ? 6 : 8,
                      vertical: isSmallScreen ? 2 : 4,
                    ),
                    decoration: BoxDecoration(
                      color: _getDifficultyColor(video['difficulty']),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      video['difficulty'],
                      style: TextStyle(
                        fontSize: isSmallScreen ? 9 : 10,
                        fontWeight: FontWeight.w500,
                        color: Colors.white,
                      ),
                    ),
                  ),
                  const Spacer(),
                  if (video['isWatched'])
                    Icon(
                      Icons.check_circle,
                      color: const Color(0xFF4CAF50),
                      size: isSmallScreen ? 16 : 18,
                    ),
                ],
              ),
              SizedBox(height: isSmallScreen ? 8 : 12),
              
              // Video Title
              Text(
                video['title'],
                style: TextStyle(
                  fontSize: isSmallScreen ? 14 : 16,
                  fontWeight: FontWeight.w600,
                  color: const Color(0xFF26344F),
                ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
              SizedBox(height: isSmallScreen ? 4 : 6),
              
              // Description
              Text(
                video['description'],
                style: TextStyle(
                  fontSize: isSmallScreen ? 11 : 12,
                  color: Colors.grey[600],
                ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
              const Spacer(),
              
              // Bottom row with duration and views
              Row(
                children: [
                  Icon(
                    Icons.play_circle_outline,
                    size: isSmallScreen ? 14 : 16,
                    color: Colors.grey[600],
                  ),
                  SizedBox(width: isSmallScreen ? 4 : 6),
                  Text(
                    video['duration'],
                    style: TextStyle(
                      fontSize: isSmallScreen ? 11 : 12,
                      color: Colors.grey[600],
                    ),
                  ),
                  const Spacer(),
                  Icon(
                    Icons.visibility,
                    size: isSmallScreen ? 14 : 16,
                    color: Colors.grey[600],
                  ),
                  SizedBox(width: isSmallScreen ? 4 : 6),
                  Text(
                    '${video['views']}',
                    style: TextStyle(
                      fontSize: isSmallScreen ? 11 : 12,
                      color: Colors.grey[600],
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

  Color _getDifficultyColor(String difficulty) {
    switch (difficulty) {
      case 'Beginner':
        return const Color(0xFF4CAF50);
      case 'Intermediate':
        return const Color(0xFFFF9800);
      case 'Advanced':
        return const Color(0xFFE91E63);
      default:
        return Colors.grey;
    }
  }

  void _showVideoDialog(Map<String, dynamic> video, bool isSmallScreen) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(
          video['title'],
          style: TextStyle(fontSize: isSmallScreen ? 16 : 18),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              video['description'],
              style: TextStyle(fontSize: isSmallScreen ? 14 : 16),
            ),
            SizedBox(height: isSmallScreen ? 12 : 16),
            Row(
              children: [
                Icon(Icons.timer, size: isSmallScreen ? 16 : 18),
                SizedBox(width: isSmallScreen ? 4 : 6),
                Text(
                  'Duration: ${video['duration']}',
                  style: TextStyle(fontSize: isSmallScreen ? 12 : 14),
                ),
              ],
            ),
            SizedBox(height: isSmallScreen ? 4 : 6),
            Row(
              children: [
                Icon(Icons.bar_chart, size: isSmallScreen ? 16 : 18),
                SizedBox(width: isSmallScreen ? 4 : 6),
                Text(
                  'Level: ${video['difficulty']}',
                  style: TextStyle(fontSize: isSmallScreen ? 12 : 14),
                ),
              ],
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(
              'Close',
              style: TextStyle(fontSize: isSmallScreen ? 12 : 14),
            ),
          ),
          ElevatedButton(
            onPressed: () {
              _toggleWatched(video['id']);
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(
                    video['isWatched'] ? 'Marked as unwatched' : 'Marked as watched',
                  ),
                  backgroundColor: const Color(0xFF4CAF50),
                ),
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF5777B5),
              foregroundColor: Colors.white,
            ),
            child: Text(
              'Watch Now',
              style: TextStyle(fontSize: isSmallScreen ? 12 : 14),
            ),
          ),
        ],
      ),
    );
  }
}