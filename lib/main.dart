import 'package:flutter/material.dart';

void main() {
  runApp(const AegiraApp());
}

// ============================================================
// AEGIRA COLORS
// ============================================================

const Color background = Color(0xFF0B1120);
const Color cardColor = Color(0xFF111C2E);
const Color blue = Color(0xFF3B82F6);
const Color muted = Color(0xFF94A3B8);
const Color borderColor = Color(0xFF263449);
const Color sidebarColor = Color(0xFF0F1929);
const Color green = Color(0xFF22C55E);
const Color orange = Color(0xFFF59E0B);
const Color red = Color(0xFFEF4444);

// ============================================================
// APP
// ============================================================

class AegiraApp extends StatelessWidget {
  const AegiraApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Aegira',
      theme: ThemeData.dark(useMaterial3: true).copyWith(
        scaffoldBackgroundColor: background,
        colorScheme: ColorScheme.fromSeed(
          seedColor: blue,
          brightness: Brightness.dark,
        ),
      ),
      home: const DashboardScreen(),
    );
  }
}

// ============================================================
// MAIN SCREEN + NAVIGATION STATE
// ============================================================

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  int selectedIndex = 0;

  final List<String> pageTitles = [
    'Dashboard',
    'Cloud Assets',
    'Security Findings',
    'Reports',
    'Settings',
  ];

  void changePage(int index) {
    setState(() {
      selectedIndex = index;
    });
  }

  Widget getCurrentPage() {
    switch (selectedIndex) {
      case 1:
        return const CloudAssetsPage();
      case 2:
        return const SecurityFindingsPage();
      case 3:
        return const ReportsPage();
      case 4:
        return const SettingsPage();
      default:
        return const HomePage();
    }
  }

  @override
  Widget build(BuildContext context) {
    final bool desktop = MediaQuery.of(context).size.width >= 850;

    return Scaffold(
      backgroundColor: background,

      // Mobile navigation drawer
      drawer: desktop
          ? null
          : Drawer(
              backgroundColor: sidebarColor,
              child: SafeArea(
                child: SideBar(
                  selectedIndex: selectedIndex,
                  onItemSelected: (index) {
                    changePage(index);
                    Navigator.pop(context);
                  },
                ),
              ),
            ),

      body: Row(
        children: [
          if (desktop)
            SideBar(
              selectedIndex: selectedIndex,
              onItemSelected: changePage,
            ),

          Expanded(
            child: Column(
              children: [
                // Mobile top bar
                if (!desktop)
                  Container(
                    height: 65,
                    padding: const EdgeInsets.symmetric(horizontal: 18),
                    decoration: const BoxDecoration(
                      color: sidebarColor,
                      border: Border(
                        bottom: BorderSide(color: borderColor),
                      ),
                    ),
                    child: Row(
                      children: [
                        Builder(
                          builder: (context) {
                            return IconButton(
                              icon: const Icon(Icons.menu),
                              onPressed: () {
                                Scaffold.of(context).openDrawer();
                              },
                            );
                          },
                        ),
                        const SizedBox(width: 8),
                        const Icon(Icons.shield, color: blue),
                        const SizedBox(width: 8),
                        const Text(
                          'Aegira',
                          style: TextStyle(
                            fontSize: 19,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),

                Expanded(
                  child: AnimatedSwitcher(
                    duration: const Duration(milliseconds: 250),
                    transitionBuilder: (child, animation) {
                      return FadeTransition(
                        opacity: animation,
                        child: child,
                      );
                    },
                    child: KeyedSubtree(
                      key: ValueKey(selectedIndex),
                      child: getCurrentPage(),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// ============================================================
// SIDEBAR
// ============================================================

class SideBar extends StatelessWidget {
  final int selectedIndex;
  final ValueChanged<int> onItemSelected;

  const SideBar({
    super.key,
    required this.selectedIndex,
    required this.onItemSelected,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 235,
      color: sidebarColor,
      padding: const EdgeInsets.symmetric(
        horizontal: 18,
        vertical: 30,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Row(
            children: [
              Icon(
                Icons.shield,
                color: blue,
                size: 32,
              ),
              SizedBox(width: 10),
              Text(
                'Aegira',
                style: TextStyle(
                  fontSize: 21,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),

          const SizedBox(height: 45),

          NavItem(
            icon: Icons.dashboard,
            label: 'Dashboard',
            selected: selectedIndex == 0,
            onTap: () => onItemSelected(0),
          ),

          NavItem(
            icon: Icons.cloud_outlined,
            label: 'Cloud Assets',
            selected: selectedIndex == 1,
            onTap: () => onItemSelected(1),
          ),

          NavItem(
            icon: Icons.security,
            label: 'Security Findings',
            selected: selectedIndex == 2,
            onTap: () => onItemSelected(2),
          ),

          NavItem(
            icon: Icons.analytics_outlined,
            label: 'Reports',
            selected: selectedIndex == 3,
            onTap: () => onItemSelected(3),
          ),

          NavItem(
            icon: Icons.settings_outlined,
            label: 'Settings',
            selected: selectedIndex == 4,
            onTap: () => onItemSelected(4),
          ),

          const Spacer(),

          const Divider(color: borderColor),

          const SizedBox(height: 12),

          const Row(
            children: [
              CircleAvatar(
                backgroundColor: blue,
                child: Icon(
                  Icons.person,
                  color: Colors.white,
                ),
              ),
              SizedBox(width: 10),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Admin User'),
                  SizedBox(height: 3),
                  Text(
                    'Security Analyst',
                    style: TextStyle(
                      color: muted,
                      fontSize: 11,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}

// ============================================================
// NAV ITEM
// ============================================================

class NavItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final bool selected;
  final VoidCallback onTap;

  const NavItem({
    super.key,
    required this.icon,
    required this.label,
    required this.onTap,
    this.selected = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(10),
          onTap: onTap,
          child: Container(
            padding: const EdgeInsets.all(13),
            decoration: BoxDecoration(
              color: selected
                  ? const Color(0xFF1D3A65)
                  : Colors.transparent,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Row(
              children: [
                Icon(
                  icon,
                  color: selected ? blue : muted,
                  size: 20,
                ),
                const SizedBox(width: 13),
                Expanded(
                  child: Text(
                    label,
                    style: TextStyle(
                      color: selected
                          ? Colors.white
                          : muted,
                      fontWeight: selected
                          ? FontWeight.bold
                          : FontWeight.normal,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// ============================================================
// HEADER
// ============================================================

class Header extends StatelessWidget {
  final String subtitle;

  const Header({
    super.key,
    this.subtitle = 'Here is your cloud security status.',
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Welcome back, Admin 👋',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 5),
              Text(
                subtitle,
                style: const TextStyle(
                  color: muted,
                  fontSize: 13,
                ),
              ),
            ],
          ),
        ),
        IconButton(
          onPressed: () {},
          icon: const Icon(
            Icons.notifications_none,
            color: muted,
          ),
        ),
        const CircleAvatar(
          backgroundColor: Color(0xFF1D3A65),
          child: Icon(
            Icons.person,
            color: Colors.white,
          ),
        ),
      ],
    );
  }
}

// ============================================================
// PAGE CONTAINER
// ============================================================

class PageContainer extends StatelessWidget {
  final Widget child;

  const PageContainer({
    super.key,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(28),
      child: child,
    );
  }
}

// ============================================================
// DASHBOARD HOME
// ============================================================

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return PageContainer(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Header(),

          const SizedBox(height: 35),

          const Text(
            'Security Overview',
            style: TextStyle(
              fontSize: 27,
              fontWeight: FontWeight.bold,
            ),
          ),

          const SizedBox(height: 8),

          const Text(
            'Monitor your cloud infrastructure security.',
            style: TextStyle(color: muted),
          ),

          const SizedBox(height: 25),

          Wrap(
            spacing: 18,
            runSpacing: 18,
            children: const [
              MetricCard(
                title: 'Total Assets',
                value: '128',
                subtitle: 'Cloud resources',
                icon: Icons.cloud_outlined,
                color: blue,
              ),
              MetricCard(
                title: 'Security Issues',
                value: '24',
                subtitle: 'Needs attention',
                icon: Icons.shield_outlined,
                color: red,
              ),
              MetricCard(
                title: 'Risk Score',
                value: '68/100',
                subtitle: 'Moderate risk',
                icon: Icons.warning_amber_rounded,
                color: orange,
              ),
              MetricCard(
                title: 'Resolved',
                value: '76%',
                subtitle: 'Issues fixed',
                icon: Icons.check_circle_outline,
                color: green,
              ),
            ],
          ),

          const SizedBox(height: 35),

          const Text(
            'Security Findings',
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
            ),
          ),

          const SizedBox(height: 18),

          const FindingCard(
            title: 'Public Storage Bucket',
            description:
                'Storage bucket is publicly accessible.',
            severity: 'CRITICAL',
            color: red,
            asset: 'cloud-storage-01',
          ),

          const FindingCard(
            title: 'Weak Password Policy',
            description:
                'Password requirements are not strong enough.',
            severity: 'HIGH',
            color: orange,
            asset: 'identity-service-02',
          ),

          const FindingCard(
            title: 'Unencrypted Database',
            description:
                'Database encryption is not enabled.',
            severity: 'MEDIUM',
            color: blue,
            asset: 'database-prod-03',
          ),

          const SizedBox(height: 35),

          const Text(
            'Cloud Infrastructure',
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
            ),
          ),

          const SizedBox(height: 18),

          const AssetCard(
            name: 'Production Server',
            type: 'Virtual Machine',
            status: 'Active',
          ),

          const AssetCard(
            name: 'Cloud Storage',
            type: 'Storage Account',
            status: 'Needs Review',
          ),

          const SizedBox(height: 30),

          const Center(
            child: Text(
              'Aegira • Security Monitoring Dashboard',
              style: TextStyle(
                color: muted,
                fontSize: 12,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ============================================================
// CLOUD ASSETS PAGE
// ============================================================

class CloudAssetsPage extends StatefulWidget {
  const CloudAssetsPage({super.key});

  @override
  State<CloudAssetsPage> createState() =>
      _CloudAssetsPageState();
}

class _CloudAssetsPageState
    extends State<CloudAssetsPage> {
  String search = '';

  final List<Map<String, String>> assets = [
    {
      'name': 'Production Server',
      'type': 'Virtual Machine',
      'status': 'Active',
    },
    {
      'name': 'Cloud Storage',
      'type': 'Storage Account',
      'status': 'Needs Review',
    },
    {
      'name': 'Production Database',
      'type': 'Managed Database',
      'status': 'Active',
    },
    {
      'name': 'Identity Service',
      'type': 'Authentication',
      'status': 'Active',
    },
    {
      'name': 'Development Server',
      'type': 'Virtual Machine',
      'status': 'Needs Review',
    },
    {
      'name': 'Backup Storage',
      'type': 'Object Storage',
      'status': 'Active',
    },
  ];

  @override
  Widget build(BuildContext context) {
    final filteredAssets = assets.where((asset) {
      final name = asset['name']!.toLowerCase();
      final type = asset['type']!.toLowerCase();
      final query = search.toLowerCase();

      return name.contains(query) ||
          type.contains(query);
    }).toList();

    return PageContainer(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Header(
            subtitle:
                'Manage and monitor your cloud resources.',
          ),

          const SizedBox(height: 35),

          Row(
            children: [
              const Expanded(
                child: Text(
                  'Cloud Assets',
                  style: TextStyle(
                    fontSize: 27,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              ElevatedButton.icon(
                onPressed: () {
                  ScaffoldMessenger.of(context)
                      .showSnackBar(
                    const SnackBar(
                      content: Text(
                        'Add Asset form will be connected next.',
                      ),
                    ),
                  );
                },
                icon: const Icon(Icons.add),
                label: const Text('Add Asset'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: blue,
                  foregroundColor: Colors.white,
                ),
              ),
            ],
          ),

          const SizedBox(height: 20),

          TextField(
            onChanged: (value) {
              setState(() {
                search = value;
              });
            },
            decoration: InputDecoration(
              hintText: 'Search cloud assets...',
              prefixIcon: const Icon(Icons.search),
              filled: true,
              fillColor: cardColor,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: const BorderSide(
                  color: borderColor,
                ),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: const BorderSide(
                  color: borderColor,
                ),
              ),
            ),
          ),

          const SizedBox(height: 20),

          Text(
            '${filteredAssets.length} assets found',
            style: const TextStyle(
              color: muted,
              fontSize: 13,
            ),
          ),

          const SizedBox(height: 15),

          ...filteredAssets.map(
            (asset) => AssetCard(
              name: asset['name']!,
              type: asset['type']!,
              status: asset['status']!,
            ),
          ),
        ],
      ),
    );
  }
}

// ============================================================
// SECURITY FINDINGS PAGE
// ============================================================

class SecurityFindingsPage extends StatefulWidget {
  const SecurityFindingsPage({super.key});

  @override
  State<SecurityFindingsPage> createState() =>
      _SecurityFindingsPageState();
}

class _SecurityFindingsPageState
    extends State<SecurityFindingsPage> {
  String selectedSeverity = 'All';

  final List<Map<String, dynamic>> findings = [
    {
      'title': 'Public Storage Bucket',
      'description':
          'Storage bucket is publicly accessible.',
      'severity': 'CRITICAL',
      'asset': 'cloud-storage-01',
      'resolved': false,
    },
    {
      'title': 'Weak Password Policy',
      'description':
          'Password requirements are not strong enough.',
      'severity': 'HIGH',
      'asset': 'identity-service-02',
      'resolved': false,
    },
    {
      'title': 'Unencrypted Database',
      'description':
          'Database encryption is not enabled.',
      'severity': 'MEDIUM',
      'asset': 'database-prod-03',
      'resolved': true,
    },
    {
      'title': 'Open Security Group',
      'description':
          'Network access is broader than recommended.',
      'severity': 'HIGH',
      'asset': 'production-server-01',
      'resolved': false,
    },
    {
      'title': 'Unused IAM Account',
      'description':
          'An inactive identity account remains enabled.',
      'severity': 'LOW',
      'asset': 'identity-service-03',
      'resolved': true,
    },
  ];

  Color severityColor(String severity) {
    switch (severity) {
      case 'CRITICAL':
        return red;
      case 'HIGH':
        return orange;
      case 'MEDIUM':
        return blue;
      default:
        return green;
    }
  }

  @override
  Widget build(BuildContext context) {
    final filtered = selectedSeverity == 'All'
        ? findings
        : findings
            .where(
              (finding) =>
                  finding['severity'] ==
                  selectedSeverity,
            )
            .toList();

    return PageContainer(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Header(
            subtitle:
                'Identify and manage cloud security risks.',
          ),

          const SizedBox(height: 35),

          const Text(
            'Security Findings',
            style: TextStyle(
              fontSize: 27,
              fontWeight: FontWeight.bold,
            ),
          ),

          const SizedBox(height: 8),

          const Text(
            'Review security misconfigurations and remediation status.',
            style: TextStyle(color: muted),
          ),

          const SizedBox(height: 22),

          Wrap(
            spacing: 10,
            runSpacing: 10,
            children: [
              'All',
              'CRITICAL',
              'HIGH',
              'MEDIUM',
              'LOW',
            ].map((severity) {
              final selected =
                  selectedSeverity == severity;

              return ChoiceChip(
                label: Text(severity),
                selected: selected,
                onSelected: (_) {
                  setState(() {
                    selectedSeverity = severity;
                  });
                },
                selectedColor: severity == 'All'
                    ? blue
                    : severityColor(severity)
                        .withValues(alpha: 0.25),
              );
            }).toList(),
          ),

          const SizedBox(height: 22),

          ...filtered.map(
            (finding) {
              return FindingCard(
                title: finding['title'],
                description: finding['description'],
                severity: finding['severity'],
                color: severityColor(
                  finding['severity'],
                ),
                asset: finding['asset'],
                resolved: finding['resolved'],
                onResolve: () {
                  setState(() {
                    finding['resolved'] =
                        !finding['resolved'];
                  });
                },
              );
            },
          ),
        ],
      ),
    );
  }
}

// ============================================================
// REPORTS PAGE
// ============================================================

class ReportsPage extends StatelessWidget {
  const ReportsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return PageContainer(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Header(
            subtitle:
                'Analyze your cloud security posture.',
          ),

          const SizedBox(height: 35),

          const Text(
            'Security Reports',
            style: TextStyle(
              fontSize: 27,
              fontWeight: FontWeight.bold,
            ),
          ),

          const SizedBox(height: 8),

          const Text(
            'Security analytics based on demonstration data.',
            style: TextStyle(color: muted),
          ),

          const SizedBox(height: 25),

          Wrap(
            spacing: 18,
            runSpacing: 18,
            children: const [
              MetricCard(
                title: 'Risk Score',
                value: '68/100',
                subtitle: 'Moderate risk',
                icon: Icons.warning_amber_rounded,
                color: orange,
              ),
              MetricCard(
                title: 'Critical',
                value: '3',
                subtitle: 'Immediate attention',
                icon: Icons.dangerous_outlined,
                color: red,
              ),
              MetricCard(
                title: 'Resolved',
                value: '76%',
                subtitle: 'Issues fixed',
                icon: Icons.check_circle_outline,
                color: green,
              ),
            ],
          ),

          const SizedBox(height: 35),

          const SectionTitle(
            title: 'Issues by Severity',
          ),

          const SizedBox(height: 18),

          const SeverityBar(
            label: 'Critical',
            value: 0.25,
            count: '3',
            color: red,
          ),

          const SeverityBar(
            label: 'High',
            value: 0.50,
            count: '6',
            color: orange,
          ),

          const SeverityBar(
            label: 'Medium',
            value: 0.75,
            count: '9',
            color: blue,
          ),

          const SeverityBar(
            label: 'Low',
            value: 0.50,
            count: '6',
            color: green,
          ),

          const SizedBox(height: 35),

          const SectionTitle(
            title: 'Security Posture',
          ),

          const SizedBox(height: 18),

          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(22),
            decoration: BoxDecoration(
              color: cardColor,
              borderRadius: BorderRadius.circular(15),
              border: Border.all(color: borderColor),
            ),
            child: const Column(
              crossAxisAlignment:
                  CrossAxisAlignment.start,
              children: [
                Text(
                  'Overall Security Status',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 17,
                  ),
                ),
                SizedBox(height: 12),
                Text(
                  'Aegira currently reports a moderate security risk. '
                  'Several findings require attention before the '
                  'environment can be considered secure.',
                  style: TextStyle(
                    color: muted,
                    height: 1.5,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// ============================================================
// SETTINGS PAGE
// ============================================================

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  State<SettingsPage> createState() =>
      _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  bool notificationsEnabled = true;
  bool emailAlertsEnabled = true;
  bool darkModeEnabled = true;

  @override
  Widget build(BuildContext context) {
    return PageContainer(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Header(
            subtitle: 'Manage your application preferences.',
          ),

          const SizedBox(height: 35),

          const Text(
            'Settings',
            style: TextStyle(
              fontSize: 27,
              fontWeight: FontWeight.bold,
            ),
          ),

          const SizedBox(height: 25),

          const SectionTitle(
            title: 'Profile Settings',
          ),

          const SizedBox(height: 15),

          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: cardColor,
              borderRadius: BorderRadius.circular(15),
              border: Border.all(color: borderColor),
            ),
            child: const Row(
              children: [
                CircleAvatar(
                  radius: 28,
                  backgroundColor: blue,
                  child: Icon(
                    Icons.person,
                    color: Colors.white,
                    size: 28,
                  ),
                ),
                SizedBox(width: 15),
                Column(
                  crossAxisAlignment:
                      CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Admin User',
                      style: TextStyle(
                        fontSize: 17,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 5),
                    Text(
                      'admin@aegira.com',
                      style: TextStyle(
                        color: muted,
                        fontSize: 13,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),

          const SizedBox(height: 30),

          const SectionTitle(
            title: 'Preferences',
          ),

          const SizedBox(height: 15),

          _buildSettingTile(
            title: 'Push Notifications',
            subtitle: 'Receive security alerts in the app.',
            value: notificationsEnabled,
            onChanged: (value) {
              setState(() {
                notificationsEnabled = value;
              });
            },
          ),

          _buildSettingTile(
            title: 'Email Alerts',
            subtitle: 'Receive important alerts by email.',
            value: emailAlertsEnabled,
            onChanged: (value) {
              setState(() {
                emailAlertsEnabled = value;
              });
            },
          ),

          _buildSettingTile(
            title: 'Dark Mode',
            subtitle: 'Use the dark dashboard appearance.',
            value: darkModeEnabled,
            onChanged: (value) {
              setState(() {
                darkModeEnabled = value;
              });
            },
          ),

          const SizedBox(height: 30),

          const Text(
            'Aegira Version 1.0.0',
            style: TextStyle(
              color: muted,
              fontSize: 12,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSettingTile({
    required String title,
    required String subtitle,
    required bool value,
    required ValueChanged<bool> onChanged,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.symmetric(
        horizontal: 18,
        vertical: 12,
      ),
      decoration: BoxDecoration(
        color: cardColor,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: borderColor),
      ),
      child: SwitchListTile(
        contentPadding: EdgeInsets.zero,
        title: Text(
          title,
          style: const TextStyle(
            fontWeight: FontWeight.w600,
          ),
        ),
        subtitle: Text(
          subtitle,
          style: const TextStyle(
            color: muted,
            fontSize: 12,
          ),
        ),
        value: value,
        activeThumbColor: blue,
        onChanged: onChanged,
      ),
    );
  }
}

// ============================================================
// SECTION TITLE
// ============================================================

class SectionTitle extends StatelessWidget {
  final String title;

  const SectionTitle({
    super.key,
    required this.title,
  });

  @override
  Widget build(BuildContext context) {
    return Text(
      title,
      style: const TextStyle(
        fontSize: 19,
        fontWeight: FontWeight.bold,
      ),
    );
  }
}

// ============================================================
// METRIC CARD
// ============================================================

class MetricCard extends StatelessWidget {
  final String title;
  final String value;
  final String subtitle;
  final IconData icon;
  final Color color;

  const MetricCard({
    super.key,
    required this.title,
    required this.value,
    required this.subtitle,
    required this.icon,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 230,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: cardColor,
        borderRadius: BorderRadius.circular(15),
        border: Border.all(color: borderColor),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment:
                MainAxisAlignment.spaceBetween,
            children: [
              Text(
                title,
                style: const TextStyle(
                  color: muted,
                  fontSize: 13,
                ),
              ),
              Icon(
                icon,
                color: color,
                size: 22,
              ),
            ],
          ),

          const SizedBox(height: 18),

          Text(
            value,
            style: const TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.bold,
            ),
          ),

          const SizedBox(height: 7),

          Text(
            subtitle,
            style: const TextStyle(
              color: muted,
              fontSize: 11,
            ),
          ),
        ],
      ),
    );
  }
}

// ============================================================
// FINDING CARD
// ============================================================

class FindingCard extends StatelessWidget {
  final String title;
  final String description;
  final String severity;
  final Color color;
  final String asset;
  final bool resolved;
  final VoidCallback? onResolve;

  const FindingCard({
    super.key,
    required this.title,
    required this.description,
    required this.severity,
    required this.color,
    required this.asset,
    this.resolved = false,
    this.onResolve,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.only(bottom: 13),
      padding: const EdgeInsets.all(17),
      decoration: BoxDecoration(
        color: cardColor,
        borderRadius: BorderRadius.circular(13),
        border: Border.all(color: borderColor),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.12),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(
              Icons.warning_amber_rounded,
              color: color,
            ),
          ),

          const SizedBox(width: 14),

          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                  ),
                ),

                const SizedBox(height: 6),

                Text(
                  description,
                  style: const TextStyle(
                    color: muted,
                    fontSize: 12,
                  ),
                ),

                const SizedBox(height: 8),

                Text(
                  'Asset: $asset',
                  style: const TextStyle(
                    color: muted,
                    fontSize: 11,
                  ),
                ),

                if (onResolve != null) ...[
                  const SizedBox(height: 10),
                  TextButton(
                    onPressed: onResolve,
                    child: Text(
                      resolved ? 'Reopen' : 'Mark as Resolved',
                    ),
                  ),
                ],
              ],
            ),
          ),

          const SizedBox(width: 8),

          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 9,
                  vertical: 5,
                ),
                decoration: BoxDecoration(
                  color: color.withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Text(
                  severity,
                  style: TextStyle(
                    color: color,
                    fontSize: 10,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),

              if (resolved) ...[
                const SizedBox(height: 8),
                const Text(
                  'Resolved',
                  style: TextStyle(
                    color: green,
                    fontSize: 10,
                  ),
                ),
              ],
            ],
          ),
        ],
      ),
    );
  }
}

// ============================================================
// ASSET CARD
// ============================================================

class AssetCard extends StatelessWidget {
  final String name;
  final String type;
  final String status;

  const AssetCard({
    super.key,
    required this.name,
    required this.type,
    required this.status,
  });

  @override
  Widget build(BuildContext context) {
    final bool active = status == 'Active';

    return Container(
      width: double.infinity,
      margin: const EdgeInsets.only(bottom: 13),
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: cardColor,
        borderRadius: BorderRadius.circular(13),
        border: Border.all(color: borderColor),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: blue.withValues(alpha: 0.12),
              borderRadius: BorderRadius.circular(10),
            ),
            child: const Icon(
              Icons.cloud_outlined,
              color: blue,
              size: 23,
            ),
          ),

          const SizedBox(width: 15),

          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  name,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                  ),
                ),

                const SizedBox(height: 5),

                Text(
                  type,
                  style: const TextStyle(
                    color: muted,
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ),

          Container(
            padding: const EdgeInsets.symmetric(
              horizontal: 10,
              vertical: 6,
            ),
            decoration: BoxDecoration(
              color: (active ? green : orange)
                  .withValues(alpha: 0.12),
              borderRadius: BorderRadius.circular(7),
            ),
            child: Text(
              status,
              style: TextStyle(
                color: active ? green : orange,
                fontSize: 11,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ============================================================
// SEVERITY BAR
// ============================================================

class SeverityBar extends StatelessWidget {
  final String label;
  final double value;
  final String count;
  final Color color;

  const SeverityBar({
    super.key,
    required this.label,
    required this.value,
    required this.count,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 18),
      child: Column(
        crossAxisAlignment:
            CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  label,
                  style: const TextStyle(
                    color: muted,
                  ),
                ),
              ),
              Text(
                count,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),

          const SizedBox(height: 8),

          ClipRRect(
            borderRadius:
                BorderRadius.circular(10),
            child: LinearProgressIndicator(
              value: value,
              minHeight: 10,
              backgroundColor:
                  const Color(0xFF1E293B),
              valueColor:
                  AlwaysStoppedAnimation<Color>(
                color,
              ),
            ),
          ),
        ],
      ),
    );
  }
}