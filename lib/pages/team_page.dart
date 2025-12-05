import 'package:flutter/material.dart';

class TeamPage extends StatelessWidget {
  const TeamPage({super.key});

  // SOT Team Members Data - Administrative Hierarchy
  final List<Map<String, dynamic>> teamMembers = const [
    // المشرف العام
    {
      'name': 'د/ إيمان محمد حسن',
      'position': 'رئيس الإدارة المركزية',
      'description': 'تشرف على أعمال الفريق وتقدم التوجيهات، وتضمن التزام الفريق بمعايير الإدارة المركزية.',
      'level': 1,
      'imagePath': 'assets/team_images/member_1.png',
      'color': Colors.purple,
      'icon': Icons.supervisor_account,
    },
    // القائد العام
    {
      'name': 'حسين يحيى حسين',
      'position': 'القائد العام للفريق',
      'description': 'يشرف على جميع أعمال الفريق، يتواصل مع الإدارة المركزية، ويقود الاجتماعات الرسمية.',
      'level': 2,
      'imagePath': 'assets/team_images/member_2.png',
      'color': Colors.blue,
      'icon': Icons.star,
    },
    // نائب القائد العام
    {
      'name': 'يوسف محمد حازم',
      'position': 'نائب القائد العام',
      'description': 'ينسق بين الأقسام، يتابع تنفيذ الخطط، ويقود الجانب التقني وتطوير منصة الأنشطة الطلابية.',
      'level': 3,
      'imagePath': 'assets/team_images/member_3.jpg',
      'color': Colors.indigo,
      'icon': Icons.star_half,
    },
    // باقي أعضاء الفريق - حسب الترتيب الإداري
    {
      'name': 'أحمد محمد عبدالعليم',
      'position': 'مدير التنظيم الميداني',
      'description': 'ينظم الفعاليات على الأرض، يوزع المهام، ويتأكد من سير الحدث حسب الخطة.',
      'level': 4,
      'imagePath': 'assets/team_images/member_4.jpg',
      'color': Colors.green,
      'icon': Icons.event_seat,
    },
    {
      'name': 'حسن عمرو عبدالعليم',
      'position': 'مدير الاستقبال',
      'description': 'مسؤول عن استقبال الضيوف، تنظيم الجلسات الرسمية، ومراعاة البروتوكول الوزاري.',
      'level': 5,
      'imagePath': 'assets/team_images/member_5.png',
      'color': Colors.orange,
      'icon': Icons.waving_hand,
    },
    {
      'name': 'أحمد فايز حسان',
      'position': 'مدير الدعم التقني',
      'description': 'يشرف على التجهيزات التقنية (الصوت، الشاشات، العروض)، ويتابع تشغيل المنصة.',
      'level': 6,
      'imagePath': 'assets/team_images/member_6.jpeg',
      'color': Colors.red,
      'icon': Icons.computer,
    },
    {
      'name': 'زياد محمد عبدالعزيز',
      'position': 'مدير الإعلام',
      'description': 'يتولى التغطية الإعلامية، إعداد المحتوى الرسمي، وتوثيق الفعاليات بالصور والفيديو.',
      'level': 7,
      'imagePath': 'assets/team_images/member_7.png',
      'color': Colors.teal,
      'icon': Icons.campaign,
    },
    {
      'name': 'يس محمد حازم',
      'position': 'مدير الأرشيف',
      'description': 'مسؤول عن حفظ الملفات والتقارير الرسمية، وتنظيم الأرشيف الإلكتروني والورقي للفريق.',
      'level': 8,
      'imagePath': 'assets/team_images/member_8.jpg',
      'color': Colors.brown,
      'icon': Icons.folder_shared,
    },
    {
      'name': 'شذا عبدالحميد عمران',
      'position': 'مديرة العلاقات والتواصل',
      'description': 'تشرف على التواصل مع الإدارات والجهات المختلفة، وتدير العلاقات العامة للفريق.',
      'level': 9,
      'imagePath': 'assets/team_images/member_9.png',
      'color': Colors.pink,
      'icon': Icons.connect_without_contact,
    },
    {
      'name': 'ملك عبدالعزيز محمد',
      'position': 'مديرة الجودة',
      'description': 'تتابع جودة العمل داخل الفريق، وتعد تقارير تقييم الأداء والمخرجات النهائية لكل فعالية.',
      'level': 10,
      'imagePath': 'assets/team_images/member_10.png',
      'color': Colors.cyan,
      'icon': Icons.analytics,
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          // Enhanced App Bar
          SliverAppBar(
            floating: true,
            pinned: true,
            expandedHeight: 140,
            backgroundColor: Theme.of(context).colorScheme.primary,
            foregroundColor: Colors.white,
            title: const Text('فريق التنظيم الطلابي'),
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
                      const SizedBox(height: 10),
                      Text(
                        'SOT - Student Orientational Team',
                        style: TextStyle(
                          color: Colors.white.withValues(alpha: 0.8),
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'وزارة التربية والتعليم',
                        style: TextStyle(
                          color: Colors.white.withValues(alpha: 0.7),
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            actions: [
              IconButton(
                icon: const Icon(Icons.info_outline),
                onPressed: () => _showTeamInfoDialog(context),
                tooltip: 'عن الفريق',
              ),
            ],
          ),

          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Team Mission Statement
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: [
                          Colors.blue.withValues(alpha: 0.1),
                          Colors.purple.withValues(alpha: 0.1),
                        ],
                      ),
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(
                        color: Colors.blue.withValues(alpha: 0.2),
                        width: 1,
                      ),
                    ),
                    child: const Column(
                      children: [
                        Text(
                          'رسالة الفريق',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.blue,
                          ),
                        ),
                        SizedBox(height: 8),
                        Text(
                          'تنظيم الفعاليات واللقاءات الرسمية بوزارة التربية والتعليم والتعليم الفني بأعلى معايير الجودة والاحترافية',
                          style: TextStyle(
                            fontSize: 14,
                            height: 1.5,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 24),

                  // Team Hierarchy Header
                  const Row(
                    children: [
                      Icon(Icons.account_tree, color: Colors.blue),
                      SizedBox(width: 8),
                      Text(
                        'الهيكل الإداري',
                        style: TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),

                  // Team Members List - Administrative Hierarchy
                  ...teamMembers.map((member) => _buildTeamMemberCard(
                    context,
                    member,
                  )),

                  const SizedBox(height: 24),

                  // Team Statistics
                  const Row(
                    children: [
                      Icon(Icons.analytics, color: Colors.green),
                      SizedBox(width: 8),
                      Text(
                        'إحصائيات الفريق',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),

                  Row(
                    children: [
                      Expanded(
                        child: _buildTeamStat(
                          icon: Icons.groups,
                          title: 'إجمالي الأعضاء',
                          value: '${teamMembers.length}',
                          color: Colors.blue,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: _buildTeamStat(
                          icon: Icons.star,
                          title: 'القادة',
                          value: '3',
                          color: Colors.purple,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: _buildTeamStat(
                          icon: Icons.badge,
                          title: 'المديرين',
                          value: '${teamMembers.length - 3}',
                          color: Colors.green,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTeamMemberCard(BuildContext context, Map<String, dynamic> member) {
    final level = member['level'] as int;
    final isSupervisor = level == 1;
    final isLeader = level == 2;
    final isViceLeader = level == 3;
    final isManager = level > 3;
    
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      child: Column(
        children: [
          // Administrative Level Indicator
          if (isSupervisor)
            _buildLevelIndicator('المشرف العام', Colors.purple, Icons.supervisor_account),
          if (isLeader)
            _buildLevelIndicator('القائد العام', Colors.blue, Icons.star),
          if (isViceLeader)
            _buildLevelIndicator('نائب القائد العام', Colors.indigo, Icons.star_half),
          if (isManager && level == 4)
            _buildLevelIndicator('المديرين', Colors.green, Icons.badge),
          
          Card(
            elevation: 4,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
            ),
            child: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    (member['color'] as Color).withValues(alpha: 0.05),
                    (member['color'] as Color).withValues(alpha: 0.1),
                  ],
                ),
                borderRadius: BorderRadius.circular(20),
                border: Border.all(
                  color: (member['color'] as Color).withValues(alpha: 0.2),
                  width: 1,
                ),
              ),
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Member Image
                    Container(
                      width: 80,
                      height: 80,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: (member['color'] as Color).withValues(alpha: 0.3),
                          width: 2,
                        ),
                      ),
                      child: ClipOval(
                        child: _buildMemberImage(member['imagePath'] as String, member['name'] as String),
                      ),
                    ),
                    const SizedBox(width: 16),
                    
                    // Member Details
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Expanded(
                                child: Text(
                                  member['name'] as String,
                                  style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                    color: (member['color'] as Color),
                                  ),
                                ),
                              ),
                              if (isSupervisor)
                                Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                  decoration: BoxDecoration(
                                    color: Colors.purple.withValues(alpha: 0.1),
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  child: const Text(
                                    'مشرف',
                                    style: TextStyle(
                                      fontSize: 10,
                                      color: Colors.purple,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              if (isLeader)
                                Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                  decoration: BoxDecoration(
                                    color: Colors.blue.withValues(alpha: 0.1),
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  child: const Text(
                                    'قائد',
                                    style: TextStyle(
                                      fontSize: 10,
                                      color: Colors.blue,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              if (isViceLeader)
                                Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                  decoration: BoxDecoration(
                                    color: Colors.indigo.withValues(alpha: 0.1),
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  child: const Text(
                                    'نائب',
                                    style: TextStyle(
                                      fontSize: 10,
                                      color: Colors.indigo,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                            ],
                          ),
                          const SizedBox(height: 8),
                          
                          // Position
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                            decoration: BoxDecoration(
                              color: (member['color'] as Color).withValues(alpha: 0.1),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(
                                  member['icon'] as IconData,
                                  size: 16,
                                  color: (member['color'] as Color),
                                ),
                                const SizedBox(width: 6),
                                Text(
                                  member['position'] as String,
                                  style: TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w600,
                                    color: (member['color'] as Color),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 12),
                          
                          // Description
                          Text(
                            member['description'] as String,
                            style: TextStyle(
                              fontSize: 13,
                              color: Colors.grey[700],
                              height: 1.4,
                            ),
                          ),
                          const SizedBox(height: 12),
                          
                          // Details Button
                          SizedBox(
                            width: double.infinity,
                            child: OutlinedButton.icon(
                              onPressed: () => _showMemberDetails(context, member),
                              icon: const Icon(Icons.info_outline, size: 16),
                              label: const Text('عرض التفاصيل'),
                              style: OutlinedButton.styleFrom(
                                padding: const EdgeInsets.symmetric(vertical: 10),
                                side: BorderSide(color: (member['color'] as Color).withValues(alpha: 0.5)),
                                foregroundColor: (member['color'] as Color),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMemberImage(String imagePath, String memberName) {
    try {
      return Image.asset(
        imagePath,
        fit: BoxFit.cover,
        width: 80,
        height: 80,
        errorBuilder: (context, error, stackTrace) {
          // If asset loading fails, show placeholder with initials
          final initials = _getInitials(memberName);
          return Container(
            color: Colors.grey[300],
            child: Center(
              child: Text(
                initials,
                style: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ),
          );
        },
      );
    } catch (e) {
      // If asset loading fails, show placeholder with initials
      final initials = _getInitials(memberName);
      return Container(
        color: Colors.grey[300],
        child: Center(
          child: Text(
            initials,
            style: const TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
        ),
      );
    }
  }

  String _getInitials(String name) {
    final parts = name.split(' ');
    if (parts.length >= 2) {
      return '${parts[0][0]}${parts[1][0]}';
    }
    return name.substring(0, 2);
  }

  Widget _buildLevelIndicator(String title, Color color, IconData icon) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: color.withValues(alpha: 0.3)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, color: color, size: 16),
          const SizedBox(width: 8),
          Text(
            title,
            style: TextStyle(
              color: color,
              fontWeight: FontWeight.bold,
              fontSize: 14,
            ),
          ),
        ],
      ),
    );
  }

  void _showMemberDetails(BuildContext context, Map<String, dynamic> member) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(member['name'] as String),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Container(
                  width: 100,
                  height: 100,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: (member['color'] as Color).withValues(alpha: 0.3),
                      width: 2,
                    ),
                  ),
                  child: ClipOval(
                    child: Image.asset(
                      member['imagePath'] as String,
                      width: 100,
                      height: 100,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) {
                        final initials = _getInitials(member['name'] as String);
                        return Container(
                          width: 100,
                          height: 100,
                          color: Colors.grey[300],
                          child: Center(
                            child: Text(
                              initials,
                              style: const TextStyle(
                                fontSize: 28,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              _buildDetailRow(Icons.work_outline, 'المنصب: ${member['position']}'),
              const SizedBox(height: 8),
              _buildDetailRow(Icons.info_outline, 'الوصف: ${member['description']}'),
              const SizedBox(height: 8),
              _buildDetailRow(Icons.grade, 'المستوى الإداري: ${_getLevelName(member['level'] as int)}'),
            ],
          ),
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

  void _showTeamInfoDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('عن فريق التنظيم الطلابي'),
        content: const SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'فريق التنظيم الطلابي (SOT) هو الفريق الوزاري الأول لتنظيم الفعاليات واللقاءات الرسمية بوزارة التربية والتعليم والتعليم الفني.',
                style: TextStyle(fontSize: 14, height: 1.5),
              ),
              SizedBox(height: 12),
              Text(
                'تأسس الفريق تحت إشراف الإدارة المركزية للأنشطة الطلابية، ويضم نخبة من الطلاب المتميزين في مجالات التنظيم والإدارة والتقنية.',
                style: TextStyle(fontSize: 14, height: 1.5),
              ),
              SizedBox(height: 12),
              Text(
                'يشرف الفريق على تنظيم أكثر من 50 فعالية سنوياً، بما في ذلك الاحتفالات الرسمية، الورش التدريبية، واللقاءات الوزارية.',
                style: TextStyle(fontSize: 14, height: 1.5),
              ),
            ],
          ),
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

  Widget _buildTeamStat({
    required IconData icon,
    required String title,
    required String value,
    required Color color,
  }) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color.withValues(alpha: 0.3)),
      ),
      child: Column(
        children: [
          Icon(icon, color: color, size: 24),
          const SizedBox(height: 4),
          Text(
            value,
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
          const SizedBox(height: 2),
          Text(
            title,
            style: TextStyle(
              fontSize: 12,
              color: Colors.grey[600],
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  String _getLevelName(int level) {
    switch (level) {
      case 1:
        return 'المشرف العام';
      case 2:
        return 'القائد العام';
      case 3:
        return 'نائب القائد العام';
      default:
        return 'مدير';
    }
  }

  Widget _buildDetailRow(IconData icon, String text) {
    return Row(
      children: [
        Icon(icon, size: 16, color: Colors.grey[600]),
        const SizedBox(width: 8),
        Expanded(
          child: Text(
            text,
            style: const TextStyle(fontSize: 14, height: 1.4),
          ),
        ),
      ],
    );
  }
}