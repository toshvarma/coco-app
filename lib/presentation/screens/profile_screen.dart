import 'package:flutter/material.dart';
import 'package:coco_app/core/constants/text_styles.dart';
import 'package:coco_app/core/widgets/custom_card.dart';
import 'package:provider/provider.dart';
import 'package:coco_app/data/services/theme_service.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return SafeArea(
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Profile',
              style: AppTextStyles.heading1,
            ),
            const SizedBox(height: 24),

            // Account Overview Card
            _buildAccountOverview(context),
            const SizedBox(height: 16),

            // Edit Personal Information
            _buildSectionCard(
              context,
              title: 'Personal Information',
              icon: Icons.person_outline,
              items: [
                _buildMenuItem(
                  context,
                  icon: Icons.edit_outlined,
                  title: 'Edit Name',
                  subtitle: 'Lena Hoffman',
                  onTap: () => _showEditDialog(context, 'Name'),
                ),
                _buildMenuItem(
                  context,
                  icon: Icons.email_outlined,
                  title: 'Email Address',
                  subtitle: 'Lena Hoffman@outlook.com',
                  onTap: () => _showEditDialog(context, 'Email'),
                ),
                _buildMenuItem(
                  context,
                  icon: Icons.lock_outline,
                  title: 'Change Password',
                  subtitle: '••••••••',
                  onTap: () => _showEditDialog(context, 'Password'),
                ),
              ],
            ),
            const SizedBox(height: 16),

            // Appearance Settings
            _buildAppearanceSection(context),
            const SizedBox(height: 16),

            // Connected Platforms
            _buildSectionCard(
              context,
              title: 'Connected Platforms',
              icon: Icons.link,
              items: [
                _buildPlatformItem(
                  context,
                  platform: 'Instagram',
                  isConnected: true,
                  username: '@Lena_Hoffman',
                  color: const Color(0xFFE4405F),
                ),
                _buildPlatformItem(
                  context,
                  platform: 'Facebook',
                  isConnected: true,
                  username: 'Lena Hoffman',
                  color: const Color(0xFF1877F2),
                ),
                _buildPlatformItem(
                  context,
                  platform: 'LinkedIn',
                  isConnected: true,
                  username: 'Lena Hoffman',
                  color: const Color(0xFF0A66C2),
                ),
                _buildPlatformItem(
                  context,
                  platform: 'TikTok',
                  isConnected: false,
                  color: Colors.black,
                ),
              ],
            ),
            const SizedBox(height: 16),

            // Subscription / Plan
            _buildSubscriptionCard(context),
            const SizedBox(height: 16),

            // Help & Support
            _buildSectionCard(
              context,
              title: 'Help & Support',
              icon: Icons.help_outline,
              items: [
                _buildMenuItem(
                  context,
                  icon: Icons.question_answer_outlined,
                  title: 'FAQ',
                  subtitle: 'Frequently asked questions',
                  onTap: () {},
                ),
                _buildMenuItem(
                  context,
                  icon: Icons.support_agent_outlined,
                  title: 'Contact Support',
                  subtitle: 'Get help from our team',
                  onTap: () {},
                ),
                _buildMenuItem(
                  context,
                  icon: Icons.bug_report_outlined,
                  title: 'Report a Problem',
                  subtitle: 'Tell us what went wrong',
                  onTap: () {},
                ),
              ],
            ),
            const SizedBox(height: 16),

            // Legal & Compliance
            _buildSectionCard(
              context,
              title: 'Legal & Compliance',
              icon: Icons.gavel_outlined,
              items: [
                _buildMenuItem(
                  context,
                  icon: Icons.privacy_tip_outlined,
                  title: 'Privacy Policy',
                  onTap: () {},
                ),
                _buildMenuItem(
                  context,
                  icon: Icons.description_outlined,
                  title: 'Terms of Service',
                  onTap: () {},
                ),
                _buildMenuItem(
                  context,
                  icon: Icons.info_outline,
                  title: 'Imprint',
                  onTap: () {},
                ),
              ],
            ),
            const SizedBox(height: 24),

            // Logout Button
            _buildLogoutButton(context),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  Widget _buildAccountOverview(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return CustomCard(
      padding: const EdgeInsets.all(20),
      child: Row(
        children: [
          // Profile Picture
          Container(
            width: 70,
            height: 70,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: LinearGradient(
                colors: [
                  colorScheme.primary,
                  colorScheme.primaryContainer,
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              boxShadow: [
                BoxShadow(
                  color: colorScheme.primary.withOpacity(0.3),
                  blurRadius: 12,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: const Icon(
              Icons.person,
              color: Colors.white,
              size: 36,
            ),
          ),
          const SizedBox(width: 16),

          // Name and Role
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Ichbin Architekt',
                  style: AppTextStyles.heading3.copyWith(
                    color: colorScheme.onSurface,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'Interior Designer',
                  style: AppTextStyles.bodySmall.copyWith(
                    color: colorScheme.onSurface.withOpacity(0.7),
                  ),
                ),
                const SizedBox(height: 8),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: colorScheme.primary.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: Text(
                    'Pro Plan',
                    style: AppTextStyles.caption.copyWith(
                      color: colorScheme.primary,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ),
          ),

          // Edit button
          IconButton(
            onPressed: () => _showEditDialog(context, 'Profile'),
            icon: const Icon(Icons.edit_outlined),
            color: colorScheme.primary,
          ),
        ],
      ),
    );
  }

  Widget _buildAppearanceSection(BuildContext context) {
    final themeService = Provider.of<ThemeService>(context);
    final colorScheme = Theme.of(context).colorScheme;

    return CustomCard(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: colorScheme.primary.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(
                  Icons.palette_outlined,
                  color: colorScheme.primary,
                  size: 20,
                ),
              ),
              const SizedBox(width: 12),
              Text(
                'Appearance',
                style: AppTextStyles.bodySmall.copyWith(
                  fontWeight: FontWeight.w600,
                  fontSize: 16,
                  color: colorScheme.onSurface,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),

          // Theme Toggle
          InkWell(
            onTap: () => themeService.toggleTheme(),
            borderRadius: BorderRadius.circular(8),
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
              child: Row(
                children: [
                  Icon(
                    themeService.isDarkMode
                        ? Icons.dark_mode_outlined
                        : Icons.light_mode_outlined,
                    color: colorScheme.onSurface.withOpacity(0.7),
                    size: 22,
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Theme',
                          style: AppTextStyles.bodySmall.copyWith(
                            fontWeight: FontWeight.w500,
                            color: colorScheme.onSurface,
                          ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          themeService.isDarkMode ? 'Dark Mode' : 'Light Mode',
                          style: AppTextStyles.caption.copyWith(
                            fontSize: 11,
                            color: colorScheme.onSurface.withOpacity(0.7),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Switch(
                    value: themeService.isDarkMode,
                    onChanged: (_) => themeService.toggleTheme(),
                    activeColor: colorScheme.primary,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionCard(
      BuildContext context, {
        required String title,
        required IconData icon,
        required List<Widget> items,
      }) {
    final colorScheme = Theme.of(context).colorScheme;

    return CustomCard(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: colorScheme.primary.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(
                  icon,
                  color: colorScheme.primary,
                  size: 20,
                ),
              ),
              const SizedBox(width: 12),
              Text(
                title,
                style: AppTextStyles.bodySmall.copyWith(
                  fontWeight: FontWeight.w600,
                  fontSize: 16,
                  color: colorScheme.onSurface,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          ...items,
        ],
      ),
    );
  }

  Widget _buildMenuItem(
      BuildContext context, {
        required IconData icon,
        required String title,
        String? subtitle,
        required VoidCallback onTap,
        bool showArrow = true,
      }) {
    final colorScheme = Theme.of(context).colorScheme;

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(8),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
        child: Row(
          children: [
            Icon(
              icon,
              color: colorScheme.onSurface.withOpacity(0.7),
              size: 22,
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: AppTextStyles.bodySmall.copyWith(
                      fontWeight: FontWeight.w500,
                      color: colorScheme.onSurface,
                    ),
                  ),
                  if (subtitle != null) ...[
                    const SizedBox(height: 2),
                    Text(
                      subtitle,
                      style: AppTextStyles.caption.copyWith(
                        fontSize: 11,
                        color: colorScheme.onSurface.withOpacity(0.6),
                      ),
                    ),
                  ],
                ],
              ),
            ),
            if (showArrow)
              Icon(
                Icons.chevron_right,
                color: colorScheme.onSurface.withOpacity(0.5),
                size: 20,
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildPlatformItem(
      BuildContext context, {
        required String platform,
        required bool isConnected,
        required Color color,
        String? username,
      }) {
    final colorScheme = Theme.of(context).colorScheme;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 8),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: color.withOpacity(0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(
              _getPlatformIcon(platform),
              color: color,
              size: 20,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  platform,
                  style: AppTextStyles.bodySmall.copyWith(
                    fontWeight: FontWeight.w500,
                    color: colorScheme.onSurface,
                  ),
                ),
                if (username != null) ...[
                  const SizedBox(height: 2),
                  Text(
                    username,
                    style: AppTextStyles.caption.copyWith(
                      fontSize: 11,
                      color: colorScheme.onSurface.withOpacity(0.6),
                    ),
                  ),
                ],
              ],
            ),
          ),
          if (isConnected)
            TextButton(
              onPressed: () {},
              style: TextButton.styleFrom(
                foregroundColor: colorScheme.error,
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              ),
              child: const Text('Disconnect'),
            )
          else
            TextButton(
              onPressed: () {},
              style: TextButton.styleFrom(
                foregroundColor: colorScheme.primary,
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              ),
              child: const Text('Connect'),
            ),
        ],
      ),
    );
  }

  Widget _buildSubscriptionCard(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return CustomCard(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: colorScheme.primary.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(
                  Icons.workspace_premium_outlined,
                  color: colorScheme.primary,
                  size: 20,
                ),
              ),
              const SizedBox(width: 12),
              Text(
                'Subscription',
                style: AppTextStyles.bodySmall.copyWith(
                  fontWeight: FontWeight.w600,
                  fontSize: 16,
                  color: colorScheme.onSurface,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),

          // Current Plan
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  colorScheme.primary.withOpacity(0.1),
                  colorScheme.primaryContainer.withOpacity(0.05),
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: colorScheme.primary.withOpacity(0.3),
              ),
            ),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Pro Plan',
                          style: AppTextStyles.heading3.copyWith(
                            color: colorScheme.primary,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          '\$29.99/month',
                          style: AppTextStyles.bodySmall.copyWith(
                            fontWeight: FontWeight.w600,
                            color: colorScheme.onSurface,
                          ),
                        ),
                      ],
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 6,
                      ),
                      decoration: BoxDecoration(
                        color: const Color(0xFF5A7D5C).withOpacity(0.2),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(
                        'Active',
                        style: AppTextStyles.caption.copyWith(
                          color: const Color(0xFF5A7D5C),
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                _buildPlanDetail(context, Icons.check_circle_outline, 'Unlimited posts'),
                _buildPlanDetail(context, Icons.check_circle_outline, 'All platforms'),
                _buildPlanDetail(context, Icons.check_circle_outline, 'AI assistance'),
                const SizedBox(height: 12),
                Row(
                  children: [
                    Icon(
                      Icons.calendar_today,
                      size: 16,
                      color: colorScheme.onSurface.withOpacity(0.7),
                    ),
                    const SizedBox(width: 8),
                    Text(
                      'Renews on February 28, 2026',
                      style: AppTextStyles.caption.copyWith(
                        fontSize: 11,
                        color: colorScheme.onSurface.withOpacity(0.6),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: 12),

          // Upgrade/Manage button
          SizedBox(
            width: double.infinity,
            child: OutlinedButton(
              onPressed: () {},
              style: OutlinedButton.styleFrom(
                foregroundColor: colorScheme.primary,
                side: BorderSide(color: colorScheme.primary),
                padding: const EdgeInsets.symmetric(vertical: 12),
              ),
              child: const Text('Manage Subscription'),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPlanDetail(BuildContext context, IconData icon, String text) {
    final colorScheme = Theme.of(context).colorScheme;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          Icon(
            icon,
            size: 18,
            color: const Color(0xFF5A7D5C),
          ),
          const SizedBox(width: 8),
          Text(
            text,
            style: AppTextStyles.bodySmall.copyWith(
              color: colorScheme.onSurface,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLogoutButton(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return SizedBox(
      width: double.infinity,
      child: ElevatedButton.icon(
        onPressed: () {
          _showLogoutDialog(context);
        },
        icon: const Icon(Icons.logout),
        label: const Text('Log Out'),
        style: ElevatedButton.styleFrom(
          backgroundColor: colorScheme.error,
          foregroundColor: Colors.white,
          padding: const EdgeInsets.symmetric(vertical: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
      ),
    );
  }

  IconData _getPlatformIcon(String platform) {
    switch (platform.toLowerCase()) {
      case 'instagram':
        return Icons.camera_alt;
      case 'facebook':
        return Icons.facebook;
      case 'linkedin':
        return Icons.work_outline;
      case 'tiktok':
        return Icons.music_note;
      default:
        return Icons.link;
    }
  }

  void _showEditDialog(BuildContext context, String field) {
    final colorScheme = Theme.of(context).colorScheme;

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Edit $field'),
        content: TextField(
          decoration: InputDecoration(
            labelText: field,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(context),
            style: ElevatedButton.styleFrom(
              backgroundColor: colorScheme.primary,
            ),
            child: const Text('Save'),
          ),
        ],
      ),
    );
  }

  void _showLogoutDialog(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Log Out'),
        content: const Text('Are you sure you want to log out?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              // TODO: Implement logout logic
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: colorScheme.error,
            ),
            child: const Text('Log Out'),
          ),
        ],
      ),
    );
  }
}