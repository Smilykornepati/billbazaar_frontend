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
      'thumbnail': 'assets/video_thumbnails/getting_started.jpg',
      'videoUrl': 'https://example.com/video1.mp4',
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
      'thumbnail': 'assets/video_thumbnails/inventory.jpg',
      'videoUrl': 'https://example.com/video2.mp4',
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
      'thumbnail': 'assets/video_thumbnails/billing.jpg',
      'videoUrl': 'https://example.com/video3.mp4',
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
      'thumbnail': 'assets/video_thumbnails/reports.jpg',
      'videoUrl': 'https://example.com/video4.mp4',
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
      'thumbnail': 'assets/video_thumbnails/credit.jpg',
      'videoUrl': 'https://example.com/video5.mp4',
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
      'thumbnail': 'assets/video_thumbnails/printer.jpg',
      'videoUrl': 'https://example.com/video6.mp4',
      'difficulty': 'Beginner',
      'views': 1100,
      'isWatched': false,
    },
  ];

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

  void _playVideo(Map<String, dynamic> video) {
    setState(() {
      video['isWatched'] = true;
    });
    
    // In a real app, you would navigate to a video player screen
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(video['title']),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              height: 200,
              decoration: BoxDecoration(
                color: Colors.black,
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Center(
                child: Icon(
                  Icons.play_circle_filled,
                  size: 64,
                  color: Colors.white,
                ),
              ),
            ),
            const SizedBox(height: 16),
            Text(video['description']),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Close'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('Playing: ${video['title']}'),
                  backgroundColor: const Color(0xFF10B981),
                ),
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFFFF805D),
              foregroundColor: Colors.white,
            ),
            child: const Text('Play Video'),
          ),
        ],
      ),
    );
  }

  void _markAsWatched(int videoId) {
    setState(() {
      final index = _trainingVideos.indexWhere((video) => video['id'] == videoId);
      if (index != -1) {
        _trainingVideos[index]['isWatched'] = !_trainingVideos[index]['isWatched'];
      }
    });
  }

  Color _getDifficultyColor(String difficulty) {
    switch (difficulty.toLowerCase()) {
      case 'beginner':
        return const Color(0xFF10B981);
      case 'intermediate':
        return const Color(0xFFFF805D);
      case 'advanced':
        return const Color(0xFFE91E63);
      default:
        return const Color(0xFF6B7280);
    }
  }

  int get _watchedCount {
    return _trainingVideos.where((video) => video['isWatched']).length;
  }

  String get _totalDuration {
    int totalMinutes = 0;
    for (var video in _trainingVideos) {
      final duration = video['duration'].split(':');
      totalMinutes += int.parse(duration[0]) * 60 + int.parse(duration[1]);
    }
    final hours = totalMinutes ~/ 60;
    final minutes = totalMinutes % 60;
    return hours > 0 ? '${hours}h ${minutes}m' : '${minutes}m';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF7FAFC),
      body: SafeArea(
        child: Column(
          children: [
            _buildHeader(),
            _buildProgressCards(),
            _buildSearchAndFilter(),
            Expanded(child: _buildVideoList()),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
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
          padding: const EdgeInsets.fromLTRB(20, 18, 20, 24),
          child: Row(
            children: [
              IconButton(
                onPressed: () => Navigator.pop(context),
                icon: const Icon(Icons.arrow_back_ios, color: Colors.white),
                padding: EdgeInsets.zero,
                constraints: const BoxConstraints(),
              ),
              const SizedBox(width: 8),
              const Expanded(
                child: Text(
                  'Training Videos',
                  style: TextStyle(
                    fontSize: 18.0,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                    letterSpacing: 0.2,
                  ),
                ),
              ),
              IconButton(
                onPressed: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Downloading all videos...'),
                      backgroundColor: Color(0xFF5777B5),
                    ),
                  );
                },
                icon: const Icon(Icons.download, color: Colors.white),
                padding: EdgeInsets.zero,
                constraints: const BoxConstraints(),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildProgressCards() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Row(
        children: [
          Expanded(
            child: _buildProgressCard(
              'Videos Watched',
              '$_watchedCount/${_trainingVideos.length}',
              const Color(0xFF10B981),
              Icons.check_circle,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: _buildProgressCard(
              'Total Duration',
              _totalDuration,
              const Color(0xFFFF805D),
              Icons.schedule,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: _buildProgressCard(
              'Progress',
              '${((_watchedCount / _trainingVideos.length) * 100).toInt()}%',
              const Color(0xFF5777B5),
              Icons.trending_up,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProgressCard(String title, String value, Color color, IconData icon) {
    return Container(
      padding: const EdgeInsets.all(16),
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
          Icon(icon, color: color, size: 24),
          const SizedBox(height: 8),
          Text(
            value,
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            title,
            style: const TextStyle(
              fontSize: 10,
              color: Color(0xFF6B7280),
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildSearchAndFilter() {
    final categories = ['All', 'Basics', 'Billing', 'Inventory', 'Reports', 'Setup'];
    
    return Container(
      color: Colors.white,
      padding: const EdgeInsets.all(16.0),
      child: Column(
        children: [
          TextField(
            controller: _searchController,
            decoration: const InputDecoration(
              hintText: 'Search training videos...',
              prefixIcon: Icon(Icons.search, color: Color(0xFF6B7280)),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.all(Radius.circular(12)),
              ),
            ),
          ),
          const SizedBox(height: 12),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: categories.map((category) {
                final isSelected = _selectedCategory == category;
                return Padding(
                  padding: const EdgeInsets.only(right: 8),
                  child: FilterChip(
                    label: Text(category),
                    selected: isSelected,
                    onSelected: (selected) {
                      setState(() {
                        _selectedCategory = category;
                      });
                      _filterVideos();
                    },
                    selectedColor: const Color(0xFFFF805D).withOpacity(0.2),
                    checkmarkColor: const Color(0xFFFF805D),
                  ),
                );
              }).toList(),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildVideoList() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      child: ListView.builder(
        itemCount: _filteredVideos.length,
        itemBuilder: (context, index) {
          final video = _filteredVideos[index];
          return _buildVideoCard(video);
        },
      ),
    );
  }

  Widget _buildVideoCard(Map<String, dynamic> video) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: InkWell(
        onTap: () => _playVideo(video),
        borderRadius: BorderRadius.circular(8),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Video Thumbnail
              Container(
                width: 120,
                height: 80,
                decoration: BoxDecoration(
                  color: const Color(0xFF26344F),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    const Icon(
                      Icons.play_circle_filled,
                      color: Colors.white,
                      size: 32,
                    ),
                    Positioned(
                      bottom: 4,
                      right: 4,
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                        decoration: BoxDecoration(
                          color: Colors.black54,
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: Text(
                          video['duration'],
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 10,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 16),
              // Video Details
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            video['title'],
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: Color(0xFF26344F),
                            ),
                          ),
                        ),
                        if (video['isWatched'])
                          const Icon(
                            Icons.check_circle,
                            color: Color(0xFF10B981),
                            size: 20,
                          ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Text(
                      video['description'],
                      style: const TextStyle(
                        color: Color(0xFF6B7280),
                        fontSize: 12,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                          decoration: BoxDecoration(
                            color: _getDifficultyColor(video['difficulty']).withOpacity(0.1),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Text(
                            video['difficulty'],
                            style: TextStyle(
                              color: _getDifficultyColor(video['difficulty']),
                              fontSize: 10,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        const SizedBox(width: 8),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                          decoration: BoxDecoration(
                            color: const Color(0xFF5777B5).withOpacity(0.1),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Text(
                            video['category'],
                            style: const TextStyle(
                              color: Color(0xFF5777B5),
                              fontSize: 10,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        const Spacer(),
                        Text(
                          '${video['views']} views',
                          style: const TextStyle(
                            color: Color(0xFF6B7280),
                            fontSize: 10,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              // Action Button
              IconButton(
                onPressed: () => _markAsWatched(video['id']),
                icon: Icon(
                  video['isWatched'] ? Icons.check_circle : Icons.check_circle_outline,
                  color: video['isWatched'] ? const Color(0xFF10B981) : const Color(0xFF6B7280),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}