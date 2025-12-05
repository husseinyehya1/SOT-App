import 'package:flutter/material.dart';

class EventsPage extends StatefulWidget {
  const EventsPage({super.key});

  @override
  State<EventsPage> createState() => _EventsPageState();
}

class _EventsPageState extends State<EventsPage> {
  String _selectedCategory = 'الكل';
  String _searchQuery = '';
  
  final List<Map<String, dynamic>> _events = [
    {
      'title': 'اجتماع التخطيط الشهري',
      'date': '15 نوفمبر 2024',
      'time': '2:00 مساءً',
      'location': 'قاعة الاجتماعات الرئيسية',
      'status': 'قادمة',
      'color': Colors.blue,
      'icon': Icons.calendar_today,
      'description': 'اجتماع دوري للتخطيط للفعاليات الشهرية القادمة',
      'participants': 25,
      'maxParticipants': 30,
    },
    {
      'title': 'فعالية اليوم العالمي للطفل',
      'date': '20 نوفمبر 2024',
      'time': '10:00 صباحاً',
      'location': 'بهو الوزارة',
      'status': 'قادمة',
      'color': Colors.green,
      'icon': Icons.celebration,
      'description': 'فعالية احتفالية بمناسبة اليوم العالمي للطفل',
      'participants': 150,
      'maxParticipants': 200,
    },
    {
      'title': 'ورشة عمل: مهارات التنظيم',
      'date': '25 نوفمبر 2024',
      'time': '3:00 مساءً',
      'location': 'قاعة التدريب',
      'status': 'قادمة',
      'color': Colors.orange,
      'icon': Icons.school,
      'description': 'ورشة تدريبية لتطوير مهارات التنظيم لدى الأعضاء',
      'participants': 20,
      'maxParticipants': 25,
    },
    {
      'title': 'اجتماع تقييم الفعاليات',
      'date': '10 نوفمبر 2024',
      'time': '1:00 مساءً',
      'location': 'قاعة الاجتماعات',
      'status': 'منتهية',
      'color': Colors.grey,
      'icon': Icons.assessment,
      'description': 'اجتماع لتقييم الفعاليات السابقة واستخراج الدروس المستفادة',
      'participants': 15,
      'maxParticipants': 20,
    },
    {
      'title': 'احتفالية التفوق الدراسي',
      'date': '5 نوفمبر 2024',
      'time': '11:00 صباحاً',
      'location': 'المسرح الرئيسي',
      'status': 'منتهية',
      'color': Colors.purple,
      'icon': Icons.emoji_events,
      'description': 'احتفالية لتكريم الطلاب المتفوقين دراسياً',
      'participants': 300,
      'maxParticipants': 300,
    },
    {
      'title': 'ورشة عمل: التواصل الفعال',
      'date': '30 نوفمبر 2024',
      'time': '4:00 مساءً',
      'location': 'قاعة التدريب',
      'status': 'قادمة',
      'color': Colors.teal,
      'icon': Icons.record_voice_over,
      'description': 'ورشة لتطوير مهارات التواصل والعرض التقديمي',
      'participants': 18,
      'maxParticipants': 25,
    },
  ];

  List<Map<String, dynamic>> get _filteredEvents {
    return _events.where((event) {
      final matchesCategory = _selectedCategory == 'الكل' || event['status'] == _selectedCategory;
      final matchesSearch = _searchQuery.isEmpty || 
          event['title'].toString().toLowerCase().contains(_searchQuery.toLowerCase()) ||
          event['description'].toString().toLowerCase().contains(_searchQuery.toLowerCase());
      return matchesCategory && matchesSearch;
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: NestedScrollView(
        headerSliverBuilder: (context, innerBoxIsScrolled) {
          return [
            SliverAppBar(
              floating: true,
              pinned: true,
              expandedHeight: 120,
              backgroundColor: Theme.of(context).colorScheme.primary,
              foregroundColor: Colors.white,
              title: const Text('الفعاليات'),
              flexibleSpace: FlexibleSpaceBar(
                background: Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [
                        Theme.of(context).colorScheme.primary,
                        Theme.of(context).colorScheme.primaryContainer,
                      ],
                    ),
                  ),
                ),
              ),
              actions: [
                IconButton(
                  icon: const Icon(Icons.add_circle_outline),
                  onPressed: () => _showAddEventDialog(context),
                  tooltip: 'إضافة فعالية جديدة',
                ),
                IconButton(
                  icon: const Icon(Icons.filter_list),
                  onPressed: () => _showFilterOptions(context),
                  tooltip: 'خيارات التصفية',
                ),
              ],
            ),
          ];
        },
        body: Column(
          children: [
            // Enhanced Search Bar
            Padding(
              padding: const EdgeInsets.all(16),
              child: SearchBar(
                hintText: 'ابحث عن فعالية...',
                leading: const Icon(Icons.search),
                trailing: [
                  if (_searchQuery.isNotEmpty)
                    IconButton(
                      icon: const Icon(Icons.clear),
                      onPressed: () {
                        setState(() {
                          _searchQuery = '';
                        });
                      },
                    ),
                ],
                onChanged: (value) {
                  setState(() {
                    _searchQuery = value;
                  });
                },
              ),
            ),

            // Enhanced Event Categories
            SizedBox(
              height: 50,
              child: ListView(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(horizontal: 16),
                children: [
                  _buildEnhancedCategoryChip('الكل', _selectedCategory == 'الكل'),
                  _buildEnhancedCategoryChip('قادمة', _selectedCategory == 'قادمة'),
                  _buildEnhancedCategoryChip('منتهية', _selectedCategory == 'منتهية'),
                ],
              ),
            ),

            const SizedBox(height: 8),

            // Events Statistics
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Row(
                children: [
                  _buildStatCard('الفعاليات القادمة', _events.where((e) => e['status'] == 'قادمة').length.toString(), Colors.green),
                  const SizedBox(width: 12),
                  _buildStatCard('الفعاليات المنتهية', _events.where((e) => e['status'] == 'منتهية').length.toString(), Colors.grey),
                ],
              ),
            ),

            const SizedBox(height: 16),

            // Enhanced Events List
            Expanded(
              child: _filteredEvents.isEmpty
                  ? _buildEmptyState()
                  : ListView.builder(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      itemCount: _filteredEvents.length,
                      itemBuilder: (context, index) {
                        return _buildEnhancedEventCard(context, _filteredEvents[index]);
                      },
                    ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _showAddEventDialog(context),
        icon: const Icon(Icons.add),
        label: const Text('إضافة فعالية'),
        backgroundColor: Theme.of(context).colorScheme.primary,
        foregroundColor: Colors.white,
      ),
    );
  }

  Widget _buildEnhancedCategoryChip(String label, bool isSelected) {
    return Padding(
      padding: const EdgeInsets.only(right: 8),
      child: ChoiceChip(
        label: Text(label),
        selected: isSelected,
        onSelected: (selected) {
          if (selected) {
            setState(() {
              _selectedCategory = label;
            });
          }
        },
        selectedColor: Theme.of(context).colorScheme.primary.withValues(alpha: 0.2),
        backgroundColor: Colors.grey.withValues(alpha: 0.1),
        labelStyle: TextStyle(
          color: isSelected ? Theme.of(context).colorScheme.primary : Colors.grey[700],
          fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
        ),
      ),
    );
  }

  Widget _buildStatCard(String title, String count, Color color) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: color.withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: color.withValues(alpha: 0.3)),
        ),
        child: Column(
          children: [
            Text(
              count,
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: color,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              title,
              style: TextStyle(
                fontSize: 12,
                color: color.withValues(alpha: 0.8),
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.event_available,
            size: 64,
            color: Colors.grey[400],
          ),
          const SizedBox(height: 16),
          Text(
            'لا توجد فعاليات',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.grey[600],
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'لا توجد فعاليات مطابقة لمعايير البحث',
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey[500],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEnhancedEventCard(BuildContext context, Map<String, dynamic> event) {
    final isUpcoming = event['status'] == 'قادمة';
    final participationRate = (event['participants'] as int) / (event['maxParticipants'] as int);
    
    return Card(
      elevation: 3,
      margin: const EdgeInsets.only(bottom: 16),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
      child: InkWell(
        onTap: () => _showEventDetailsDialog(context, event),
        borderRadius: BorderRadius.circular(20),
        child: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                (event['color'] as Color).withValues(alpha: 0.05),
                (event['color'] as Color).withValues(alpha: 0.1),
              ],
            ),
            borderRadius: BorderRadius.circular(20),
            border: Border.all(
              color: (event['color'] as Color).withValues(alpha: 0.2),
              width: 1,
            ),
          ),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(12),
                        boxShadow: [
                          BoxShadow(
                            color: (event['color'] as Color).withValues(alpha: 0.2),
                            blurRadius: 8,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      child: Icon(
                        event['icon'] as IconData,
                        color: event['color'] as Color,
                        size: 28,
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            event['title'] as String,
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 6),
                          Row(
                            children: [
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                decoration: BoxDecoration(
                                  color: isUpcoming ? Colors.green.withValues(alpha: 0.1) : Colors.grey.withValues(alpha: 0.1),
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Icon(
                                      Icons.circle,
                                      size: 8,
                                      color: isUpcoming ? Colors.green : Colors.grey,
                                    ),
                                    const SizedBox(width: 4),
                                    Text(
                                      event['status'] as String,
                                      style: TextStyle(
                                        fontSize: 12,
                                        color: isUpcoming ? Colors.green : Colors.grey,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              if (isUpcoming) ...[
                                const SizedBox(width: 8),
                                Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                  decoration: BoxDecoration(
                                    color: Colors.orange.withValues(alpha: 0.1),
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  child: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Icon(
                                        Icons.people,
                                        size: 12,
                                        color: Colors.orange,
                                      ),
                                      const SizedBox(width: 2),
                                      Text(
                                        '${event['participants']}/${event['maxParticipants']}',
                                        style: TextStyle(
                                          fontSize: 10,
                                          color: Colors.orange,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ],
                          ),
                        ],
                      ),
                    ),
                    if (isUpcoming)
                      Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(10),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.orange.withValues(alpha: 0.2),
                              blurRadius: 6,
                              offset: const Offset(0, 2),
                            ),
                          ],
                        ),
                        child: IconButton(
                          icon: const Icon(Icons.notifications_active),
                          onPressed: () => _showNotificationDialog(context, event),
                          color: Colors.orange,
                          iconSize: 20,
                        ),
                      ),
                  ],
                ),
                const SizedBox(height: 16),
                
                // Description
                Text(
                  event['description'] as String,
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey[700],
                    height: 1.4,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 16),
                
                // Event Details
                Row(
                  children: [
                    Expanded(
                      child: _buildEnhancedEventDetail(
                        icon: Icons.calendar_today,
                        text: event['date'] as String,
                        color: event['color'] as Color,
                      ),
                    ),
                    Expanded(
                      child: _buildEnhancedEventDetail(
                        icon: Icons.access_time,
                        text: event['time'] as String,
                        color: event['color'] as Color,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                _buildEnhancedEventDetail(
                  icon: Icons.location_on,
                  text: event['location'] as String,
                  color: event['color'] as Color,
                ),
                
                if (isUpcoming) ...[
                  const SizedBox(height: 16),
                  
                  // Participation Progress
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'نسبة الاشتراك',
                            style: TextStyle(
                              fontSize: 12,
                              color: Colors.grey[600],
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          Text(
                            '${(participationRate * 100).toInt()}%',
                            style: TextStyle(
                              fontSize: 12,
                              color: event['color'] as Color,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 6),
                      ClipRRect(
                        borderRadius: BorderRadius.circular(8),
                        child: LinearProgressIndicator(
                          value: participationRate,
                          backgroundColor: Colors.grey[200],
                          valueColor: AlwaysStoppedAnimation<Color>(event['color'] as Color),
                          minHeight: 6,
                        ),
                      ),
                    ],
                  ),
                  
                  const SizedBox(height: 16),
                  
                  // Action Buttons
                  Row(
                    children: [
                      Expanded(
                        child: ElevatedButton.icon(
                          onPressed: () => _handleAttendance(context, event, true),
                          icon: const Icon(Icons.check_circle_outline),
                          label: const Text('سأحضر'),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.green,
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(vertical: 12),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: OutlinedButton.icon(
                          onPressed: () => _handleAttendance(context, event, false),
                          icon: const Icon(Icons.cancel_outlined),
                          label: const Text('لن أحضر'),
                          style: OutlinedButton.styleFrom(
                            foregroundColor: Colors.red,
                            padding: const EdgeInsets.symmetric(vertical: 12),
                            side: const BorderSide(color: Colors.red),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildEnhancedEventDetail({
    required IconData icon,
    required String text,
    required Color color,
  }) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(
          icon,
          size: 16,
          color: color.withValues(alpha: 0.7),
        ),
        const SizedBox(width: 6),
        Flexible(
          child: Text(
            text,
            style: TextStyle(
              fontSize: 13,
              color: Colors.grey[700],
            ),
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    );
  }

  Widget _buildEventDetail({
    required IconData icon,
    required String text,
  }) {
    return Row(
      children: [
        Icon(
          icon,
          size: 16,
          color: Colors.grey[600],
        ),
        const SizedBox(width: 8),
        Text(
          text,
          style: TextStyle(
            fontSize: 14,
            color: Colors.grey[800],
          ),
        ),
      ],
    );
  }

  void _showEventDetailsDialog(BuildContext context, Map<String, dynamic> event) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(event['title'] as String),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildDetailRow(Icons.calendar_today, 'التاريخ: ${event['date']}'),
              const SizedBox(height: 8),
              _buildDetailRow(Icons.access_time, 'الوقت: ${event['time']}'),
              const SizedBox(height: 8),
              _buildDetailRow(Icons.location_on, 'الموقع: ${event['location']}'),
              const SizedBox(height: 8),
              _buildDetailRow(Icons.people, 'عدد المشاركين: ${event['participants']}/${event['maxParticipants']}'),
              const SizedBox(height: 8),
              _buildDetailRow(Icons.info_outline, 'الوصف: ${event['description']}'),
              const SizedBox(height: 8),
              _buildDetailRow(Icons.circle, 'الحالة: ${event['status']}'),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('إغلاق'),
          ),
          if (event['status'] == 'قادمة')
            ElevatedButton.icon(
              onPressed: () {
                Navigator.pop(context);
                _handleAttendance(context, event, true);
              },
              icon: const Icon(Icons.check),
              label: const Text('سأحضر'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green,
                foregroundColor: Colors.white,
              ),
            ),
        ],
      ),
    );
  }

  void _showNotificationDialog(BuildContext context, Map<String, dynamic> event) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('تذكير بالفعالية'),
        content: Text('هل ترغب في تفعيل التذكير لهذه الفعالية: "${event['title']}"؟'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('إلغاء'),
          ),
          ElevatedButton.icon(
            onPressed: () {
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('تم تفعيل التذكير لفعالية: ${event['title']}'),
                  backgroundColor: Colors.green,
                ),
              );
            },
            icon: const Icon(Icons.notifications_active),
            label: const Text('تفعيل التذكير'),
          ),
        ],
      ),
    );
  }

  void _showAddEventDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('إضافة فعالية جديدة'),
        content: const Text('هنا سيتم فتح نموذج إضافة فعالية جديدة'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('إلغاء'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('تم إضافة الفعالية بنجاح')),
              );
            },
            child: const Text('إضافة'),
          ),
        ],
      ),
    );
  }

  void _showFilterOptions(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('خيارات التصفية'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              title: const Text('الفعاليات القادمة'),
              leading: const Icon(Icons.upcoming),
              onTap: () {
                Navigator.pop(context);
                setState(() {
                  _selectedCategory = 'قادمة';
                });
              },
            ),
            ListTile(
              title: const Text('الفعاليات المنتهية'),
              leading: const Icon(Icons.history),
              onTap: () {
                Navigator.pop(context);
                setState(() {
                  _selectedCategory = 'منتهية';
                });
              },
            ),
            ListTile(
              title: const Text('عرض الكل'),
              leading: const Icon(Icons.list),
              onTap: () {
                Navigator.pop(context);
                setState(() {
                  _selectedCategory = 'الكل';
                });
              },
            ),
          ],
        ),
      ),
    );
  }

  void _handleAttendance(BuildContext context, Map<String, dynamic> event, bool willAttend) {
    final message = willAttend 
        ? 'تم تأكيد حضورك لفعالية: ${event["title"]}'
        : 'تم إلغاء حضورك لفعالية: ${event["title"]}';
    
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: willAttend ? Colors.green : Colors.orange,
      ),
    );
  }

  Widget _buildDetailRow(IconData icon, String text) {
    return Row(
      children: [
        Icon(icon, size: 16, color: Colors.grey[600]),
        const SizedBox(width: 8),
        Expanded(child: Text(text)),
      ],
    );
  }
}