import 'package:flutter/material.dart';
import 'package:coco_app/core/constants/colors.dart';
import 'package:coco_app/core/constants/text_styles.dart';
import 'package:coco_app/domain/models/scheduled_post_model.dart';

class AddPostDialog extends StatefulWidget {
  final DateTime selectedDate;
  final ScheduledPost? existingPost;

  const AddPostDialog({
    super.key,
    required this.selectedDate,
    this.existingPost,
  });

  @override
  State<AddPostDialog> createState() => _AddPostDialogState();
}

class _AddPostDialogState extends State<AddPostDialog> {
  final _formKey = GlobalKey<FormState>();
  final _topicController = TextEditingController();
  final _noteController = TextEditingController();
  final _timeController = TextEditingController();

  String _selectedPlatform = 'Instagram';
  bool _isDraft = false;

  final List<String> _platforms = [
    'Instagram',
    'Facebook',
    'LinkedIn',
  ];

  @override
  void initState() {
    super.initState();
    if (widget.existingPost != null) {
      _topicController.text = widget.existingPost!.topic;
      _noteController.text = widget.existingPost!.note ?? '';
      _timeController.text = widget.existingPost!.time ?? '';
      _selectedPlatform = widget.existingPost!.platform;
      _isDraft = widget.existingPost!.isDraft;
    }
  }

  @override
  void dispose() {
    _topicController.dispose();
    _noteController.dispose();
    _timeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: Container(
        constraints: const BoxConstraints(maxWidth: 500),
        padding: const EdgeInsets.all(24),
        child: SingleChildScrollView(
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header
                Text(
                  widget.existingPost != null ? 'Edit Post' : 'Add New Post',
                  style: AppTextStyles.heading2,
                ),
                const SizedBox(height: 8),
                Text(
                  '${widget.selectedDate.day} ${_getMonthName(widget.selectedDate.month)}, ${widget.selectedDate.year}',
                  style: AppTextStyles.bodySmall,
                ),
                const SizedBox(height: 24),

                // Platform Dropdown
                Text(
                  'Platform',
                  style: AppTextStyles.bodySmall.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 8),
                DropdownButtonFormField<String>(
                  value: _selectedPlatform,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 12,
                    ),
                  ),
                  items: _platforms
                      .map((platform) => DropdownMenuItem(
                    value: platform,
                    child: Text(platform),
                  ))
                      .toList(),
                  onChanged: (value) {
                    setState(() {
                      _selectedPlatform = value!;
                    });
                  },
                ),
                const SizedBox(height: 16),

                // Topic/Content
                Text(
                  'Topic / Content',
                  style: AppTextStyles.bodySmall.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 8),
                TextFormField(
                  controller: _topicController,
                  maxLines: 3,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    hintText: 'What will you post about?',
                    contentPadding: const EdgeInsets.all(16),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter a topic';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),

                // Time
                Text(
                  'Time (optional)',
                  style: AppTextStyles.bodySmall.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 8),
                TextFormField(
                  controller: _timeController,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    hintText: 'e.g., 10:00 AM',
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 12,
                    ),
                  ),
                ),
                const SizedBox(height: 16),

                // Notes
                Text(
                  'Notes (optional)',
                  style: AppTextStyles.bodySmall.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 8),
                TextFormField(
                  controller: _noteController,
                  maxLines: 2,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    hintText: 'Add any notes or reminders',
                    contentPadding: const EdgeInsets.all(16),
                  ),
                ),
                const SizedBox(height: 16),

                // Draft Checkbox
                CheckboxListTile(
                  value: _isDraft,
                  onChanged: (value) {
                    setState(() {
                      _isDraft = value ?? false;
                    });
                  },
                  title: Text(
                    'Save as draft',
                    style: AppTextStyles.bodySmall,
                  ),
                  controlAffinity: ListTileControlAffinity.leading,
                  contentPadding: EdgeInsets.zero,
                  activeColor: AppColors.primary,
                ),
                const SizedBox(height: 24),

                // Buttons
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    TextButton(
                      onPressed: () => Navigator.pop(context),
                      child: Text(
                        'Cancel',
                        style: AppTextStyles.button.copyWith(
                          color: AppColors.textSecondary,
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    ElevatedButton(
                      onPressed: _savePost,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primary,
                        foregroundColor: AppColors.textWhite,
                        padding: const EdgeInsets.symmetric(
                          horizontal: 24,
                          vertical: 12,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: Text(
                        widget.existingPost != null ? 'Update' : 'Save',
                        style: AppTextStyles.button,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _savePost() {
    if (_formKey.currentState!.validate()) {
      final post = ScheduledPost(
        id: widget.existingPost?.id ?? DateTime.now().millisecondsSinceEpoch.toString(),
        platform: _selectedPlatform,
        topic: _topicController.text,
        note: _noteController.text.isEmpty ? null : _noteController.text,
        time: _timeController.text.isEmpty ? null : _timeController.text,
        isDraft: _isDraft,
        date: widget.selectedDate,
      );

      Navigator.pop(context, post);
    }
  }

  String _getMonthName(int month) {
    const months = [
      'January', 'February', 'March', 'April', 'May', 'June',
      'July', 'August', 'September', 'October', 'November', 'December'
    ];
    return months[month - 1];
  }
}