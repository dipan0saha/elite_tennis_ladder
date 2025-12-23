import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import '../models/user_profile.dart';
import '../services/profile_service.dart';

/// User profile screen with avatar, bio, and tennis stats
/// Allows users to view and edit their profile information
class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final _profileService = ProfileService();
  final _formKey = GlobalKey<FormState>();
  final _bioController = TextEditingController();
  final _fullNameController = TextEditingController();
  final _phoneController = TextEditingController();

  UserProfile? _profile;
  bool _isLoading = true;
  bool _isSaving = false;
  String? _selectedSkillLevel;
  File? _selectedImage;
  final _imagePicker = ImagePicker();

  // Skill level options matching the database constraint
  final List<String> _skillLevels = [
    'beginner',
    'intermediate',
    'advanced',
    'expert',
  ];

  @override
  void initState() {
    super.initState();
    _loadProfile();
  }

  @override
  void dispose() {
    _bioController.dispose();
    _fullNameController.dispose();
    _phoneController.dispose();
    super.dispose();
  }

  /// Load the current user's profile
  Future<void> _loadProfile() async {
    try {
      final profile = await _profileService.getCurrentUserProfile();
      if (mounted) {
        setState(() {
          _profile = profile;
          _bioController.text = profile?.bio ?? '';
          _fullNameController.text = profile?.fullName ?? '';
          _phoneController.text = profile?.phone ?? '';
          _selectedSkillLevel = profile?.skillLevel;
          _isLoading = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() => _isLoading = false);
        _showErrorSnackBar('Failed to load profile: $e');
      }
    }
  }

  /// Pick an image from gallery
  Future<void> _pickImage() async {
    try {
      final XFile? image = await _imagePicker.pickImage(
        source: ImageSource.gallery,
        maxWidth: 1024,
        maxHeight: 1024,
        imageQuality: 85,
      );

      if (image != null) {
        setState(() {
          _selectedImage = File(image.path);
        });
      }
    } catch (e) {
      _showErrorSnackBar('Failed to pick image: $e');
    }
  }

  /// Save profile changes
  Future<void> _saveProfile() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    if (_profile == null) {
      _showErrorSnackBar('Profile not loaded');
      return;
    }

    setState(() => _isSaving = true);

    try {
      String? avatarUrl = _profile!.avatarUrl;

      // Upload new avatar if selected
      if (_selectedImage != null) {
        final fileName = 'avatar_${DateTime.now().millisecondsSinceEpoch}.jpg';
        avatarUrl = await _profileService.uploadAvatar(
          userId: _profile!.id,
          imageFile: _selectedImage!,
          fileName: fileName,
        );
      }

      // Update profile
      final updatedProfile = await _profileService.updateProfile(
        userId: _profile!.id,
        fullName: _fullNameController.text.trim(),
        phone: _phoneController.text.trim().isEmpty
            ? null
            : _phoneController.text.trim(),
        bio: _bioController.text.trim().isEmpty
            ? null
            : _bioController.text.trim(),
        skillLevel: _selectedSkillLevel,
        avatarUrl: avatarUrl,
      );

      if (mounted) {
        setState(() {
          _profile = updatedProfile;
          _selectedImage = null;
          _isSaving = false;
        });
        _showSuccessSnackBar('Profile updated successfully');
      }
    } catch (e) {
      if (mounted) {
        setState(() => _isSaving = false);
        _showErrorSnackBar('Failed to save profile: $e');
      }
    }
  }

  void _showErrorSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Theme.of(context).colorScheme.error,
      ),
    );
  }

  void _showSuccessSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.green,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile'),
        actions: [
          if (!_isLoading && !_isSaving)
            IconButton(
              icon: const Icon(Icons.save),
              tooltip: 'Save Profile',
              onPressed: _saveProfile,
            ),
        ],
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              padding: const EdgeInsets.all(16.0),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    // Avatar section
                    _buildAvatarSection(),
                    const SizedBox(height: 32),

                    // Full Name field
                    TextFormField(
                      controller: _fullNameController,
                      decoration: const InputDecoration(
                        labelText: 'Full Name',
                        prefixIcon: Icon(Icons.person),
                      ),
                      validator: (value) {
                        if (value == null || value.trim().isEmpty) {
                          return 'Please enter your full name';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 16),

                    // Username field (read-only)
                    TextFormField(
                      initialValue: _profile?.username ?? '',
                      decoration: const InputDecoration(
                        labelText: 'Username',
                        prefixIcon: Icon(Icons.account_circle),
                      ),
                      enabled: false,
                    ),
                    const SizedBox(height: 16),

                    // Email field (read-only)
                    TextFormField(
                      initialValue: _profile?.email ?? '',
                      decoration: const InputDecoration(
                        labelText: 'Email',
                        prefixIcon: Icon(Icons.email),
                      ),
                      enabled: false,
                    ),
                    const SizedBox(height: 16),

                    // Phone field
                    TextFormField(
                      controller: _phoneController,
                      decoration: const InputDecoration(
                        labelText: 'Phone (Optional)',
                        prefixIcon: Icon(Icons.phone),
                      ),
                      keyboardType: TextInputType.phone,
                    ),
                    const SizedBox(height: 16),

                    // Bio field
                    TextFormField(
                      controller: _bioController,
                      decoration: const InputDecoration(
                        labelText: 'Bio',
                        prefixIcon: Icon(Icons.description),
                        hintText: 'Tell us about yourself...',
                      ),
                      maxLines: 4,
                      maxLength: 500,
                    ),
                    const SizedBox(height: 16),

                    // Skill level dropdown
                    DropdownButtonFormField<String>(
                      value: _selectedSkillLevel,
                      decoration: const InputDecoration(
                        labelText: 'Skill Level',
                        prefixIcon: Icon(Icons.sports_tennis),
                      ),
                      items: _skillLevels.map((level) {
                        return DropdownMenuItem(
                          value: level,
                          child: Text(
                            level[0].toUpperCase() + level.substring(1),
                          ),
                        );
                      }).toList(),
                      onChanged: (value) {
                        setState(() {
                          _selectedSkillLevel = value;
                        });
                      },
                    ),
                    const SizedBox(height: 32),

                    // Save button
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: _isSaving ? null : _saveProfile,
                        child: _isSaving
                            ? const SizedBox(
                                height: 20,
                                width: 20,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                  valueColor: AlwaysStoppedAnimation<Color>(
                                    Colors.white,
                                  ),
                                ),
                              )
                            : const Text('Save Profile'),
                      ),
                    ),
                  ],
                ),
              ),
            ),
    );
  }

  /// Get the appropriate avatar image provider
  ImageProvider? _getAvatarImage() {
    if (_selectedImage != null) {
      return FileImage(_selectedImage!);
    } else if (_profile?.avatarUrl != null) {
      return NetworkImage(_profile!.avatarUrl!);
    }
    return null;
  }

  /// Build the avatar section with image picker
  Widget _buildAvatarSection() {
    return Column(
      children: [
        GestureDetector(
          onTap: _pickImage,
          child: Stack(
            children: [
              CircleAvatar(
                radius: 60,
                backgroundColor: Theme.of(context).colorScheme.primaryContainer,
                backgroundImage: _getAvatarImage(),
                child: (_selectedImage == null && _profile?.avatarUrl == null)
                    ? Icon(
                        Icons.person,
                        size: 60,
                        color: Theme.of(context).colorScheme.onPrimaryContainer,
                      )
                    : null,
              ),
              Positioned(
                bottom: 0,
                right: 0,
                child: CircleAvatar(
                  radius: 18,
                  backgroundColor: Theme.of(context).colorScheme.primary,
                  child: const Icon(
                    Icons.camera_alt,
                    size: 18,
                    color: Colors.white,
                  ),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 8),
        Text(
          'Tap to change avatar',
          style: Theme.of(context).textTheme.bodySmall,
        ),
      ],
    );
  }
}
