import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:provider/provider.dart';
import '../services/theme_service.dart';

class DashboardPage extends StatefulWidget {
  const DashboardPage({super.key});

  @override
  State<DashboardPage> createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  bool _showAllActivities = false;
  
  // Mock data for demonstration
  final List<Map<String, dynamic>> _activities = [
    {
      'icon': Icons.event,
      'title': 'اجتماع الفريق الأسبوعي',
      'subtitle': 'غداً الساعة 2:00 مساءً',
      'time': 'منذ ساعة',
      'color': Colors.blue,
      'type': 'event',
    },
    {
      'icon': Icons.assignment,
      'title': 'تقرير الفعالية الأخيرة',
      'subtitle': 'مطلوب تسليم التقرير النهائي',
      'time': 'منذ 3 ساعات',
      'color': Colors.orange,
      'type': 'task',
    },
    {
      'icon': Icons.celebration,
      'title': 'احتفالية نهاية العام',
      'subtitle': 'التحضير للفعالية الكبرى',
      'time': 'منذ يوم',
      'color': Colors.purple,
      'type': 'event',
    },
    {
      'icon': Icons.people,
      'title': 'انضمام عضو جديد',
      'subtitle': 'أحمد محمد انضم إلى الفريق',
      'time': 'منذ يومين',
      'color': Colors.green,
      'type': 'member',
    },
    {
      'icon': Icons.warning,
      'title': 'مهمة متأخرة',
      'subtitle': 'تقرير الشهرية لم يُسلم بعد',
      'time': 'منذ 3 أيام',
      'color': Colors.red,
      'type': 'warning',
    },
  ];

  final List<Map<String, dynamic>> _upcomingEvents = [
    {
      'title': 'ورشة العمل التدريبية',
      'date': '15 ديسمبر',
      'time': '10:00 صباحاً',
      'location': 'قاعة التدريب',
      'participants': 25,
      'color': Colors.blue,
    },
    {
      'title': 'اجتماع التخطيط الشهري',
      'date': '18 ديسمبر',
      'time': '2:00 مساءً',
      'location': 'قاعة الاجتماعات',
      'participants': 12,
      'color': Colors.green,
    },
    {
      'title': 'فعالية اليوم الوطني',
      'date': '20 ديسمبر',
      'time': '9:00 صباحاً',
      'location': 'الساحة الرئيسية',
      'participants': 150,
      'color': Colors.purple,
    },
  ];

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;
    final themeService = Provider.of<ThemeService>(context);
    final isDarkMode = themeService.isDarkMode;
    
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          // Enhanced Modern App Bar
          SliverAppBar.large(
            expandedHeight: 240,
            floating: true,
            pinned: true,
            backgroundColor: Theme.of(context).colorScheme.primary,
            foregroundColor: Colors.white,
            title: const Text('لوحة التحكم'),
            flexibleSpace: FlexibleSpaceBar(
              titlePadding: const EdgeInsetsDirectional.only(
                start: 16,
                bottom: 16,
              ),
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
                child: SafeArea(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const SizedBox(height: 20),
                      Hero(
                        tag: 'dashboard_icon',
                        child: Container(
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: Colors.white.withValues(alpha: 0.2),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: const Icon(
                            Icons.school,
                            size: 50,
                            color: Colors.white,
                          ),
                        ),
                      ),
                      const SizedBox(height: 16),
                      Text(
                        'أهلاً ${user?.displayName ?? 'بك'}',
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        '${DateTime.now().day} ${_getMonthName(DateTime.now().month)} ${DateTime.now().year}',
                        style: TextStyle(
                          color: Colors.white.withValues(alpha: 0.9),
                          fontSize: 14,
                        ),
                      ),
                      const SizedBox(height: 16),
                    ],
                  ),
                ),
              ),
            ),
          ),

          // Dashboard Content
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 8),
                  
                  // Enhanced Statistics Section
                  _buildSectionHeader(
                    title: 'نظرة عامة',
                    subtitle: 'إحصائيات سريعة عن أنشطة الفريق',
                    icon: Icons.analytics,
                  ),
                  const SizedBox(height: 16),
                  
                  // Modern Statistics Cards
                  Row(
                    children: [
                      Expanded(
                        child: _buildModernStatCard(
                          icon: Icons.event,
                          title: 'الفعاليات',
                          value: '24',
                          change: '+3',
                          changeColor: Colors.green,
                          color: Colors.blue,
                          onTap: () => _navigateToPage(context, 1),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: _buildModernStatCard(
                          icon: Icons.group,
                          title: 'الأعضاء',
                          value: '156',
                          change: '+12',
                          changeColor: Colors.green,
                          color: Colors.green,
                          onTap: () => _navigateToPage(context, 2),
                        ),
                      ),
                    ],
                  ),
                  
                  const SizedBox(height: 12),
                  
                  Row(
                    children: [
                      Expanded(
                        child: _buildModernStatCard(
                          icon: Icons.assignment_turned_in,
                          title: 'المهام المكتملة',
                          value: '89%',
                          change: '+5%',
                          changeColor: Colors.green,
                          color: Colors.orange,
                          onTap: () {},
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: _buildModernStatCard(
                          icon: Icons.star,
                          title: 'التقييم',
                          value: '4.8',
                          change: '+0.2',
                          changeColor: Colors.green,
                          color: Colors.purple,
                          onTap: () {},
                        ),
                      ),
                    ],
                  ),
                  
                  const SizedBox(height: 32),
                  
                  // Upcoming Events Section
                  _buildSectionHeader(
                    title: 'الفعاليات القادمة',
                    subtitle: 'لا تفوت أهم الفعاليات',
                    icon: Icons.calendar_today,
                  ),
                  const SizedBox(height: 16),
                  
                  ..._upcomingEvents.map((event) => Padding(
                    padding: const EdgeInsets.only(bottom: 12),
                    child: _buildEventCard(event, isDarkMode),
                  )).toList(),
                  
                  const SizedBox(height: 32),
                  
                  // Recent Activities Section
                  _buildSectionHeader(
                    title: 'آخر الأنشطة',
                    subtitle: 'تابع آخر تحديثات الفريق',
                    icon: Icons.history,
                  ),
                  const SizedBox(height: 16),
                  
                  ...(_showAllActivities ? _activities : _activities.take(3)).map((activity) => Padding(
                    padding: const EdgeInsets.only(bottom: 12),
                    child: _buildEnhancedActivityCard(activity, isDarkMode),
                  )).toList(),
                  
                  if (_activities.length > 3) ...[
                    const SizedBox(height: 8),
                    Center(
                      child: TextButton.icon(
                        onPressed: () {
                          setState(() {
                            _showAllActivities = !_showAllActivities;
                          });
                        },
                        icon: Icon(_showAllActivities ? Icons.expand_less : Icons.expand_more),
                        label: Text(_showAllActivities ? 'عرض أقل' : 'عرض الكل'),
                        style: TextButton.styleFrom(
                          foregroundColor: Theme.of(context).colorScheme.primary,
                        ),
                      ),
                    ),
                  ],
                  
                  const SizedBox(height: 32),
                  
                  // Quick Actions Section
                  _buildSectionHeader(
                    title: 'إجراءات سريعة',
                    subtitle: 'وصول سريع إلى أهم المهام',
                    icon: Icons.flash_on,
                  ),
                  const SizedBox(height: 16),
                  
                  GridView.count(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    crossAxisCount: 2,
                    childAspectRatio: 1.3,
                    mainAxisSpacing: 12,
                    crossAxisSpacing: 12,
                    children: [
                      _buildEnhancedQuickAction(
                        icon: Icons.add_circle,
                        title: 'إضافة فعالية',
                        subtitle: 'إنشاء فعالية جديدة',
                        color: Colors.blue,
                        onTap: () => _showAddEventDialog(context),
                      ),
                      _buildEnhancedQuickAction(
                        icon: Icons.person_add,
                        title: 'دعوة عضو',
                        subtitle: 'إرسال دعوة لعضو جديد',
                        color: Colors.green,
                        onTap: () => _showInviteMemberDialog(context),
                      ),
                      _buildEnhancedQuickAction(
                        icon: Icons.assignment_add,
                        title: 'إنشاء مهمة',
                        subtitle: 'تكليف عضو بمهمة جديدة',
                        color: Colors.orange,
                        onTap: () => _showAddTaskDialog(context),
                      ),
                      _buildEnhancedQuickAction(
                        icon: Icons.analytics,
                        title: 'تقرير سريع',
                        subtitle: 'إنشاء تقرير أداء',
                        color: Colors.purple,
                        onTap: () => _showQuickReportDialog(context),
                      ),
                    ],
                  ),
                  
                  const SizedBox(height: 24),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionHeader({
    required String title,
    required String subtitle,
    required IconData icon,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.primary.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(
              icon,
              color: Theme.of(context).colorScheme.primary,
              size: 20,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  subtitle,
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.grey[600],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildModernStatCard({
    required IconData icon,
    required String title,
    required String value,
    required String change,
    required Color changeColor,
    required Color color,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(20),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              color.withValues(alpha: 0.1),
              color.withValues(alpha: 0.05),
            ],
          ),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: color.withValues(alpha: 0.2),
            width: 1,
          ),
          boxShadow: [
            BoxShadow(
              color: color.withValues(alpha: 0.1),
              blurRadius: 8,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: color.withValues(alpha: 0.2),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(icon, color: color, size: 20),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                  decoration: BoxDecoration(
                    color: changeColor.withValues(alpha: 0.2),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    change,
                    style: TextStyle(
                      fontSize: 10,
                      fontWeight: FontWeight.bold,
                      color: changeColor,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Text(
              value,
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: color,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              title,
              style: TextStyle(
                fontSize: 12,
                color: Colors.grey[600],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEventCard(Map<String, dynamic> event, bool isDarkMode) {
    return InkWell(
      onTap: () => _showEventDetailsDialog(context, event),
      borderRadius: BorderRadius.circular(16),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.centerLeft,
            end: Alignment.centerRight,
            colors: [
              event['color'].withValues(alpha: 0.1),
              event['color'].withValues(alpha: 0.05),
            ],
          ),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: event['color'].withValues(alpha: 0.2),
            width: 1,
          ),
        ),
        child: Row(
          children: [
            Container(
              width: 4,
              height: 60,
              decoration: BoxDecoration(
                color: event['color'],
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    event['title'],
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      Icon(Icons.calendar_today, size: 14, color: Colors.grey[600]),
                      const SizedBox(width: 4),
                      Text(
                        event['date'],
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.grey[600],
                        ),
                      ),
                      const SizedBox(width: 12),
                      Icon(Icons.access_time, size: 14, color: Colors.grey[600]),
                      const SizedBox(width: 4),
                      Text(
                        event['time'],
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.grey[600],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      Icon(Icons.location_on, size: 14, color: Colors.grey[600]),
                      const SizedBox(width: 4),
                      Text(
                        event['location'],
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.grey[600],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: event['color'].withValues(alpha: 0.2),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.people, size: 14, color: event['color']),
                  const SizedBox(width: 4),
                  Text(
                    '${event['participants']}',
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                      color: event['color'],
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

  Widget _buildEnhancedActivityCard(Map<String, dynamic> activity, bool isDarkMode) {
    return InkWell(
      onTap: () => _showActivityDetailsDialog(context, activity),
      borderRadius: BorderRadius.circular(16),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: isDarkMode ? Colors.grey[850] : Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: activity['color'].withValues(alpha: 0.2),
            width: 1,
          ),
          boxShadow: [
            BoxShadow(
              color: activity['color'].withValues(alpha: 0.1),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: activity['color'].withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(activity['icon'], color: activity['color'], size: 24),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    activity['title'],
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    activity['subtitle'],
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.grey[600],
                    ),
                  ),
                ],
              ),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  activity['time'],
                  style: TextStyle(
                    fontSize: 11,
                    color: Colors.grey[500],
                  ),
                ),
                const SizedBox(height: 4),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: _getActivityTypeColor(activity['type']).withValues(alpha: 0.2),
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: Text(
                    _getActivityTypeText(activity['type']),
                    style: TextStyle(
                      fontSize: 10,
                      fontWeight: FontWeight.bold,
                      color: _getActivityTypeColor(activity['type']),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEnhancedQuickAction({
    required IconData icon,
    required String title,
    required String subtitle,
    required Color color,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(20),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              color.withValues(alpha: 0.15),
              color.withValues(alpha: 0.05),
            ],
          ),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: color.withValues(alpha: 0.3),
            width: 1,
          ),
          boxShadow: [
            BoxShadow(
              color: color.withValues(alpha: 0.1),
              blurRadius: 12,
              offset: const Offset(0, 6),
            ),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: color.withValues(alpha: 0.2),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(icon, color: color, size: 28),
            ),
            const SizedBox(height: 12),
            Text(
              title,
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.bold,
                color: color,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 4),
            Text(
              subtitle,
              style: TextStyle(
                fontSize: 10,
                color: Colors.grey[600],
              ),
              textAlign: TextAlign.center,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ),
    );
  }

  // Helper methods
  String _getMonthName(int month) {
    const months = [
      'يناير', 'فبراير', 'مارس', 'أبريل', 'مايو', 'يونيو',
      'يوليو', 'أغسطس', 'سبتمبر', 'أكتوبر', 'نوفمبر', 'ديسمبر'
    ];
    return months[month - 1];
  }

  void _navigateToPage(BuildContext context, int index) {
    // This would navigate to the corresponding page
    // For now, we'll just show a snackbar
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('الانتقال إلى ${index == 1 ? "الفعاليات" : "الفريق"}'),
        duration: const Duration(seconds: 1),
      ),
    );
  }

  Color _getActivityTypeColor(String type) {
    switch (type) {
      case 'event':
        return Colors.blue;
      case 'task':
        return Colors.orange;
      case 'member':
        return Colors.green;
      case 'warning':
        return Colors.red;
      default:
        return Colors.grey;
    }
  }

  String _getActivityTypeText(String type) {
    switch (type) {
      case 'event':
        return 'فعالية';
      case 'task':
        return 'مهمة';
      case 'member':
        return 'عضو';
      case 'warning':
        return 'تحذير';
      default:
        return 'نشاط';
    }
  }

  void _showEventDetailsDialog(BuildContext context, Map<String, dynamic> event) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(event['title']),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildDetailRow(Icons.calendar_today, 'التاريخ: ${event['date']}'),
            const SizedBox(height: 8),
            _buildDetailRow(Icons.access_time, 'الوقت: ${event['time']}'),
            const SizedBox(height: 8),
            _buildDetailRow(Icons.location_on, 'الموقع: ${event['location']}'),
            const SizedBox(height: 8),
            _buildDetailRow(Icons.people, 'عدد المشاركين: ${event['participants']}'),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('إغلاق'),
          ),
          ElevatedButton.icon(
            onPressed: () {
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('تم التسجيل في الفعالية')),
              );
            },
            icon: const Icon(Icons.check),
            label: const Text('التسجيل'),
          ),
        ],
      ),
    );
  }

  void _showActivityDetailsDialog(BuildContext context, Map<String, dynamic> activity) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(activity['title']),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(activity['subtitle']),
            const SizedBox(height: 16),
            _buildDetailRow(Icons.access_time, 'الوقت: ${activity['time']}'),
            const SizedBox(height: 8),
            _buildDetailRow(Icons.label, 'النوع: ${_getActivityTypeText(activity['type'])}'),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('إغلاق'),
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

  void _showInviteMemberDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('دعوة عضو جديد'),
        content: const Text('هنا سيتم فتح نموذج دعوة عضو جديد'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('إلغاء'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('تم إرسال الدعوة بنجاح')),
              );
            },
            child: const Text('إرسال'),
          ),
        ],
      ),
    );
  }

  void _showAddTaskDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('إنشاء مهمة جديدة'),
        content: const Text('هنا سيتم فتح نموذج إنشاء مهمة جديدة'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('إلغاء'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('تم إنشاء المهمة بنجاح')),
              );
            },
            child: const Text('إنشاء'),
          ),
        ],
      ),
    );
  }

  void _showQuickReportDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('تقرير أداء سريع'),
        content: const Text('هنا سيتم إنشاء تقرير أداء سريع للفريق'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('إلغاء'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('تم إنشاء التقرير بنجاح')),
              );
            },
            child: const Text('إنشاء'),
          ),
        ],
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