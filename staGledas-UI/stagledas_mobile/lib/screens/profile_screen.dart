import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:stagledas_mobile/layouts/master_layout.dart';
import 'package:stagledas_mobile/providers/korisnik_provider.dart';
import 'package:stagledas_mobile/screens/login_screen.dart';
import 'package:stagledas_mobile/screens/network_screen.dart';
import 'package:stagledas_mobile/screens/premium_screen.dart';
import 'package:stagledas_mobile/screens/user_recenzije_screen.dart';
import 'package:stagledas_mobile/screens/watchlist_screen.dart';
import 'package:stagledas_mobile/utils/auth_util.dart';
import 'package:stagledas_mobile/widgets/loading_spinner_widget.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  late KorisnikProvider _korisnikProvider;
  final ImagePicker _imagePicker = ImagePicker();

  bool _isLoading = true;
  bool _isUploadingImage = false;
  Map<String, dynamic>? _statistics;

  @override
  void initState() {
    super.initState();
    _korisnikProvider = context.read<KorisnikProvider>();
    _loadProfile();
  }

  Future<void> _loadProfile() async {
    if (Authorization.id == null) {
      setState(() => _isLoading = false);
      return;
    }

    try {
      var statistics =
          await _korisnikProvider.getStatistics(Authorization.id!);
      setState(() {
        _statistics = statistics;
        _isLoading = false;
      });
    } catch (e) {
      setState(() => _isLoading = false);
    }
  }

  Future<void> _pickAndUploadImage() async {
    try {
      final XFile? image = await _imagePicker.pickImage(
        source: ImageSource.gallery,
        maxWidth: 512,
        maxHeight: 512,
        imageQuality: 80,
      );

      if (image == null) return;

      setState(() => _isUploadingImage = true);

      final bytes = await image.readAsBytes();
      final base64Image = base64Encode(bytes);

      final updatedUser = await _korisnikProvider.uploadImage(
        Authorization.id!,
        base64Image,
      );

      Authorization.slika = updatedUser.slika;

      setState(() => _isUploadingImage = false);

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Profile picture updated'),
            backgroundColor: Color(0xFF99D6AC),
          ),
        );
      }
    } catch (e) {
      setState(() => _isUploadingImage = false);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  void _logout() {
    Authorization.id = null;
    Authorization.username = null;
    Authorization.password = null;
    Authorization.fullName = null;
    Authorization.email = null;
    Authorization.slika = null;
    Authorization.isPremium = false;

    Navigator.of(context).pushAndRemoveUntil(
      MaterialPageRoute(builder: (context) => const LoginScreen()),
      (route) => false,
    );
  }

  void _showChangePasswordDialog() {
    final currentPasswordController = TextEditingController();
    final newPasswordController = TextEditingController();
    final confirmPasswordController = TextEditingController();
    bool isLoading = false;
    String? errorMessage;

    showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setDialogState) => AlertDialog(
          backgroundColor: Colors.white,
          title: const Text(
            'Promijeni lozinku',
            style: TextStyle(color: Color(0xFF2D3748)),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (errorMessage != null)
                Container(
                  padding: const EdgeInsets.all(8),
                  margin: const EdgeInsets.only(bottom: 12),
                  decoration: BoxDecoration(
                    color: Colors.red.shade50,
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: Colors.red.shade200),
                  ),
                  child: Row(
                    children: [
                      Icon(Icons.error_outline, color: Colors.red.shade700, size: 20),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          errorMessage!,
                          style: TextStyle(color: Colors.red.shade700, fontSize: 13),
                        ),
                      ),
                    ],
                  ),
                ),
              TextField(
                controller: currentPasswordController,
                obscureText: true,
                style: const TextStyle(color: Color(0xFF2D3748)),
                decoration: const InputDecoration(
                  labelText: 'Trenutna lozinka',
                  labelStyle: TextStyle(color: Color(0xFF718096)),
                  border: OutlineInputBorder(),
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Color(0xFFE2E8F0)),
                  ),
                ),
              ),
              const SizedBox(height: 12),
              TextField(
                controller: newPasswordController,
                obscureText: true,
                style: const TextStyle(color: Color(0xFF2D3748)),
                decoration: const InputDecoration(
                  labelText: 'Nova lozinka',
                  labelStyle: TextStyle(color: Color(0xFF718096)),
                  border: OutlineInputBorder(),
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Color(0xFFE2E8F0)),
                  ),
                ),
              ),
              const SizedBox(height: 12),
              TextField(
                controller: confirmPasswordController,
                obscureText: true,
                style: const TextStyle(color: Color(0xFF2D3748)),
                decoration: const InputDecoration(
                  labelText: 'Potvrdi novu lozinku',
                  labelStyle: TextStyle(color: Color(0xFF718096)),
                  border: OutlineInputBorder(),
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Color(0xFFE2E8F0)),
                  ),
                ),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: isLoading ? null : () => Navigator.pop(context),
              child: const Text('Odustani', style: TextStyle(color: Color(0xFF718096))),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF4AB3EF),
              ),
              onPressed: isLoading
                  ? null
                  : () async {
                      setDialogState(() => errorMessage = null);

                      if (newPasswordController.text != confirmPasswordController.text) {
                        setDialogState(() => errorMessage = 'Lozinke se ne podudaraju');
                        return;
                      }

                      setDialogState(() => isLoading = true);
                      try {
                        await _korisnikProvider.changePassword(
                          Authorization.id!,
                          currentPasswordController.text,
                          newPasswordController.text,
                          confirmPasswordController.text,
                        );
                        Authorization.password = newPasswordController.text;
                        if (mounted) {
                          Navigator.pop(context);
                          ScaffoldMessenger.of(this.context).showSnackBar(
                            const SnackBar(
                              content: Text('Lozinka uspješno promijenjena'),
                              backgroundColor: Color(0xFF99D6AC),
                            ),
                          );
                        }
                      } catch (e) {
                        setDialogState(() {
                          isLoading = false;
                          errorMessage = e.toString().replaceAll('Exception: ', '');
                        });
                      }
                    },
              child: isLoading
                  ? const SizedBox(
                      height: 16,
                      width: 16,
                      child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white),
                    )
                  : const Text('Spremi', style: TextStyle(color: Colors.white)),
            ),
          ],
        ),
      ),
    );
  }

  void _showDeleteAccountDialog() {
    final passwordController = TextEditingController();
    bool isLoading = false;
    String? errorMessage;

    showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setDialogState) => AlertDialog(
          backgroundColor: Colors.white,
          title: const Text(
            'Obriši račun',
            style: TextStyle(color: Color(0xFF2D3748)),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.red.shade50,
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: Colors.red.shade200),
                ),
                child: Row(
                  children: [
                    Icon(Icons.warning_amber_rounded, color: Colors.red.shade700, size: 24),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        'Ova akcija se ne može poništiti.',
                        style: TextStyle(color: Colors.red.shade700, fontSize: 13),
                      ),
                    ),
                  ],
                ),
              ),
              if (errorMessage != null)
                Container(
                  padding: const EdgeInsets.all(8),
                  margin: const EdgeInsets.only(top: 12),
                  decoration: BoxDecoration(
                    color: Colors.red.shade50,
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: Colors.red.shade200),
                  ),
                  child: Row(
                    children: [
                      Icon(Icons.error_outline, color: Colors.red.shade700, size: 20),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          errorMessage!,
                          style: TextStyle(color: Colors.red.shade700, fontSize: 13),
                        ),
                      ),
                    ],
                  ),
                ),
              const SizedBox(height: 16),
              TextField(
                controller: passwordController,
                obscureText: true,
                style: const TextStyle(color: Color(0xFF2D3748)),
                decoration: const InputDecoration(
                  labelText: 'Unesite lozinku za potvrdu',
                  labelStyle: TextStyle(color: Color(0xFF718096)),
                  border: OutlineInputBorder(),
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Color(0xFFE2E8F0)),
                  ),
                ),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: isLoading ? null : () => Navigator.pop(context),
              child: const Text('Odustani', style: TextStyle(color: Color(0xFF718096))),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
              onPressed: isLoading
                  ? null
                  : () async {
                      setDialogState(() => errorMessage = null);

                      if (passwordController.text.isEmpty) {
                        setDialogState(() => errorMessage = 'Unesite lozinku');
                        return;
                      }

                      setDialogState(() => isLoading = true);
                      try {
                        await _korisnikProvider.deleteAccount(
                          Authorization.id!,
                          passwordController.text,
                        );
                        if (mounted) {
                          Navigator.pop(context);
                          _logout();
                          ScaffoldMessenger.of(this.context).showSnackBar(
                            const SnackBar(
                              content: Text('Račun uspješno obrisan'),
                              backgroundColor: Color(0xFF718096),
                            ),
                          );
                        }
                      } catch (e) {
                        setDialogState(() {
                          isLoading = false;
                          errorMessage = e.toString().replaceAll('Exception: ', '');
                        });
                      }
                    },
              child: isLoading
                  ? const SizedBox(
                      height: 16,
                      width: 16,
                      child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white),
                    )
                  : const Text('Obriši', style: TextStyle(color: Colors.white)),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return MasterLayout(
      selectedIndex: 4,
      child: _isLoading
          ? const LoadingSpinnerWidget(height: 300)
          : SingleChildScrollView(
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.only(top: 10, right: 10),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        IconButton(
                          onPressed: _logout,
                          icon: const Icon(
                            Icons.logout,
                            color: Color(0xFF718096),
                            size: 24,
                          ),
                          tooltip: 'Odjava',
                        ),
                      ],
                    ),
                  ),

                  GestureDetector(
                    onTap: _isUploadingImage ? null : _pickAndUploadImage,
                    child: Stack(
                      children: [
                        Container(
                          width: 100,
                          height: 100,
                          decoration: const BoxDecoration(
                            shape: BoxShape.circle,
                          ),
                          child: _isUploadingImage
                              ? const CircleAvatar(
                                  radius: 47,
                                  backgroundColor: Color(0xFFE2E8F0),
                                  child: CircularProgressIndicator(
                                    color: Color(0xFF4AB3EF),
                                    strokeWidth: 2,
                                  ),
                                )
                              : CircleAvatar(
                                  radius: 47,
                                  backgroundColor: const Color(0xFFE2E8F0),
                                  backgroundImage: Authorization.slika != null
                                      ? MemoryImage(
                                          base64Decode(Authorization.slika!),
                                        )
                                      : null,
                                  child: Authorization.slika == null
                                      ? Text(
                                          (Authorization.username ?? 'K')[0]
                                              .toUpperCase(),
                                          style: const TextStyle(
                                            fontSize: 40,
                                            fontWeight: FontWeight.bold,
                                            color: Color(0xFF4AB3EF),
                                          ),
                                        )
                                      : null,
                                ),
                        ),
                        Positioned(
                          bottom: 0,
                          right: 0,
                          child: Container(
                            width: 32,
                            height: 32,
                            decoration: BoxDecoration(
                              color: const Color(0xFF4AB3EF),
                              shape: BoxShape.circle,
                              border: Border.all(
                                color: Colors.white,
                                width: 2,
                              ),
                            ),
                            child: const Icon(
                              Icons.camera_alt,
                              color: Colors.white,
                              size: 16,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),

                  Text(
                    Authorization.username ?? 'Korisnik',
                    style: const TextStyle(
                      fontFamily: "Inter",
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF2D3748),
                    ),
                  ),
                  const SizedBox(height: 24),

                  _buildMenuItemWithStats(
                    icon: Icons.rate_review,
                    iconColor: const Color(0xFF4AB3EF),
                    title: "Moje recenzije",
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const UserRecenzijeScreen(),
                        ),
                      );
                    },
                  ),
                  _buildMenuItemWithStats(
                    icon: Icons.visibility,
                    iconColor: const Color(0xFF4AB3EF),
                    title: "Watchlist",
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const WatchlistScreen(),
                        ),
                      );
                    },
                  ),
                  _buildMenuItemWithStats(
                    icon: Icons.people,
                    iconColor: const Color(0xFF4AB3EF),
                    title: "Network",
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const NetworkScreen(),
                        ),
                      );
                    },
                  ),
                  _buildMenuItemWithStats(
                    icon: Icons.star,
                    iconColor: const Color(0xFF99D6AC),
                    title: Authorization.isPremium ? "Premium (Aktivno)" : "Premium",
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const PremiumScreen(),
                        ),
                      ).then((_) => setState(() {}));
                    },
                  ),
                  _buildMenuItemWithStats(
                    icon: Icons.lock,
                    iconColor: const Color(0xFF718096),
                    title: "Promijeni lozinku",
                    onTap: _showChangePasswordDialog,
                  ),
                  _buildMenuItemWithStats(
                    icon: Icons.delete_forever,
                    iconColor: Colors.red,
                    title: "Obriši račun",
                    onTap: _showDeleteAccountDialog,
                  ),

                  const SizedBox(height: 16),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Divider(color: Colors.grey.shade300, height: 1),
                  ),
                  const SizedBox(height: 16),

                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Column(
                      children: [
                        _buildStatRow(
                          "Filmovi",
                          _statistics?['brojPogledanihFilmova']?.toString() ??
                              '0',
                        ),
                        const SizedBox(height: 8),
                        _buildStatRow(
                          "Recenzije",
                          _statistics?['brojRecenzija']?.toString() ?? '0',
                        ),
                        const SizedBox(height: 8),
                        _buildStatRow(
                          "Network",
                          _statistics?['brojPratioca']?.toString() ?? '0',
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 30),
                ],
              ),
            ),
    );
  }

  Widget _buildMenuItemWithStats({
    required IconData icon,
    required Color iconColor,
    required String title,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
        child: Row(
          children: [
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: iconColor.withOpacity(0.1),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(icon, color: iconColor, size: 22),
            ),
            const SizedBox(width: 16),
            Text(
              title,
              style: const TextStyle(
                fontFamily: "Inter",
                fontSize: 16,
                fontWeight: FontWeight.w500,
                color: Color(0xFF2D3748),
              ),
            ),
            const Spacer(),
            Icon(
              Icons.chevron_right,
              color: Colors.grey.shade400,
              size: 24,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatRow(String label, String value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontFamily: "Inter",
            fontSize: 14,
            color: Color(0xFF718096),
          ),
        ),
        Text(
          value,
          style: const TextStyle(
            fontFamily: "Inter",
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: Color(0xFF2D3748),
          ),
        ),
      ],
    );
  }
}
