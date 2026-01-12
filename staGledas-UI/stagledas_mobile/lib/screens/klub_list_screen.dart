import 'dart:convert';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:stagledas_mobile/layouts/master_layout.dart';
import 'package:stagledas_mobile/models/klub_filmova.dart';
import 'package:stagledas_mobile/providers/klub_filmova_provider.dart';
import 'package:stagledas_mobile/screens/klub_detail_screen.dart';
import 'package:stagledas_mobile/screens/premium_screen.dart';
import 'package:stagledas_mobile/utils/auth_util.dart';
import 'package:stagledas_mobile/widgets/loading_spinner_widget.dart';

class KlubListScreen extends StatefulWidget {
  const KlubListScreen({super.key});

  @override
  State<KlubListScreen> createState() => _KlubListScreenState();
}

class _KlubListScreenState extends State<KlubListScreen> {
  late KlubFilmovaProvider _klubProvider;
  List<KlubFilmova> _clubs = [];
  bool _isLoading = true;
  String _searchQuery = '';
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _klubProvider = context.read<KlubFilmovaProvider>();
    _loadClubs();
  }

  Future<void> _loadClubs() async {
    setState(() => _isLoading = true);
    try {
      Map<String, dynamic> filter = {
        'IsVlasnikIncluded': true,
        'IsClanoviIncluded': true,
      };
      if (_searchQuery.isNotEmpty) {
        filter['NazivGTE'] = _searchQuery;
      }
      var result = await _klubProvider.get(filter: filter);
      setState(() {
        _clubs = result.result;
        _isLoading = false;
      });
    } catch (e) {
      setState(() => _isLoading = false);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: $e'), backgroundColor: Colors.red),
        );
      }
    }
  }

  void _showCreateClubDialog() {
    if (!Authorization.isPremium) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Movie Clubs su dostupni samo premium korisnicima'),
          backgroundColor: Colors.orange,
        ),
      );
      return;
    }

    final nameController = TextEditingController();
    final descController = TextEditingController();
    final maxMembersController = TextEditingController();
    Uint8List? selectedImage;
    final ImagePicker imagePicker = ImagePicker();

    showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setDialogState) => AlertDialog(
          backgroundColor: Colors.white,
          title: const Text(
            'Kreiraj novi klub',
            style: TextStyle(color: Color(0xFF2D3748)),
          ),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                GestureDetector(
                  onTap: () async {
                    final XFile? image = await imagePicker.pickImage(
                      source: ImageSource.gallery,
                      maxWidth: 512,
                      maxHeight: 512,
                      imageQuality: 80,
                    );
                    if (image != null) {
                      final bytes = await image.readAsBytes();
                      setDialogState(() {
                        selectedImage = bytes;
                      });
                    }
                  },
                  child: Container(
                    width: 100,
                    height: 100,
                    decoration: BoxDecoration(
                      color: const Color(0xFFE2E8F0),
                      borderRadius: BorderRadius.circular(12),
                      image: selectedImage != null
                          ? DecorationImage(
                              image: MemoryImage(selectedImage!),
                              fit: BoxFit.cover,
                            )
                          : null,
                    ),
                    child: selectedImage == null
                        ? const Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(Icons.add_photo_alternate,
                                  color: Color(0xFF718096), size: 32),
                              SizedBox(height: 4),
                              Text(
                                'Dodaj sliku',
                                style: TextStyle(
                                  fontSize: 11,
                                  color: Color(0xFF718096),
                                ),
                              ),
                            ],
                          )
                        : null,
                  ),
                ),
                const SizedBox(height: 16),
                TextField(
                  controller: nameController,
                  style: const TextStyle(color: Color(0xFF2D3748)),
                  decoration: InputDecoration(
                    labelText: 'Naziv kluba',
                    labelStyle: const TextStyle(color: Color(0xFF718096)),
                    enabledBorder: OutlineInputBorder(
                      borderSide: const BorderSide(color: Color(0xFFE2E8F0)),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: const BorderSide(color: Color(0xFF4AB3EF)),
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                TextField(
                  controller: descController,
                  style: const TextStyle(color: Color(0xFF2D3748)),
                  maxLines: 3,
                  decoration: InputDecoration(
                    labelText: 'Opis',
                    labelStyle: const TextStyle(color: Color(0xFF718096)),
                    enabledBorder: OutlineInputBorder(
                      borderSide: const BorderSide(color: Color(0xFFE2E8F0)),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: const BorderSide(color: Color(0xFF4AB3EF)),
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                TextField(
                  controller: maxMembersController,
                  style: const TextStyle(color: Color(0xFF2D3748)),
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                    labelText: 'Max članova (opcionalno)',
                    hintText: 'npr. 50',
                    hintStyle: const TextStyle(color: Color(0xFFCBD5E0)),
                    labelStyle: const TextStyle(color: Color(0xFF718096)),
                    enabledBorder: OutlineInputBorder(
                      borderSide: const BorderSide(color: Color(0xFFE2E8F0)),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: const BorderSide(color: Color(0xFF4AB3EF)),
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Odustani', style: TextStyle(color: Color(0xFF718096))),
            ),
            ElevatedButton(
              onPressed: () async {
                if (nameController.text.trim().isEmpty) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Naziv je obavezan')),
                  );
                  return;
                }
                Navigator.pop(context);
                await _createClub(
                  nameController.text,
                  descController.text,
                  maxMembersController.text.isNotEmpty
                      ? int.tryParse(maxMembersController.text)
                      : null,
                  selectedImage,
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF4AB3EF),
              ),
              child: const Text('Kreiraj', style: TextStyle(color: Colors.white)),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _createClub(String name, String description, int? maxMembers, Uint8List? image) async {
    try {
      Map<String, dynamic> request = {
        'naziv': name,
        'opis': description,
        'isPrivate': false,
      };
      if (maxMembers != null) {
        request['maxClanova'] = maxMembers;
      }
      if (image != null) {
        request['slika'] = base64Encode(image);
      }
      await _klubProvider.insert(request);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Klub uspješno kreiran!'),
            backgroundColor: Color(0xFF99D6AC),
          ),
        );
      }
      _loadClubs();
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: $e'), backgroundColor: Colors.red),
        );
      }
    }
  }

  bool _isUserMember(KlubFilmova club) {
    if (club.clanovi == null) return false;
    return club.clanovi!.any((c) => c.korisnikId == Authorization.id);
  }

  @override
  Widget build(BuildContext context) {
    if (!Authorization.isPremium) {
      return MasterLayout(
        selectedIndex: 3,
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(32),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  width: 120,
                  height: 120,
                  decoration: BoxDecoration(
                    color: const Color(0xFF99D6AC).withOpacity(0.1),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.workspace_premium,
                    size: 60,
                    color: Color(0xFF99D6AC),
                  ),
                ),
                const SizedBox(height: 32),
                const Text(
                  'Movie Clubs',
                  style: TextStyle(
                    fontFamily: 'Inter',
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF2D3748),
                  ),
                ),
                const SizedBox(height: 12),
                const Text(
                  'Pridruži se ekskluzivnim filmskim klubovima, diskutuj o omiljenim filmovima i povezi se sa drugim ljubiteljima filma!',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontFamily: 'Inter',
                    fontSize: 15,
                    color: Color(0xFF718096),
                    height: 1.5,
                  ),
                ),
                const SizedBox(height: 32),
                Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.05),
                        blurRadius: 10,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Column(
                    children: [
                      _buildPremiumFeature(Icons.groups, 'Kreiraj i pridruži se klubovima'),
                      const SizedBox(height: 12),
                      _buildPremiumFeature(Icons.forum, 'Objavljuj i komentiraj'),
                      const SizedBox(height: 12),
                      _buildPremiumFeature(Icons.favorite, 'Lajkuj objave drugih članova'),
                      const SizedBox(height: 12),
                      _buildPremiumFeature(Icons.block, 'Bez reklama'),
                    ],
                  ),
                ),
                const SizedBox(height: 32),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const PremiumScreen(),
                        ),
                      ).then((_) => setState(() {}));
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF99D6AC),
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: const Text(
                      'Postani Premium',
                      style: TextStyle(
                        fontFamily: 'Inter',
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 12),
                Text(
                  'Samo 4.99 KM/mjesečno',
                  style: TextStyle(
                    fontFamily: 'Inter',
                    fontSize: 13,
                    color: Colors.grey.shade500,
                  ),
                ),
              ],
            ),
          ),
        ),
      );
    }

    return MasterLayout(
      selectedIndex: 3,
      child: Column(
        children: [
          const Padding(
            padding: EdgeInsets.fromLTRB(16, 16, 16, 8),
            child: Text(
              'Movie Clubs',
              style: TextStyle(
                fontFamily: 'Inter',
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: Color(0xFF2D3748),
              ),
            ),
          ),

          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: TextField(
              controller: _searchController,
              style: const TextStyle(color: Color(0xFF2D3748)),
              onChanged: (value) {
                setState(() {
                  _searchQuery = value;
                });
                Future.delayed(const Duration(milliseconds: 500), () {
                  if (_searchQuery == value) {
                    _loadClubs();
                  }
                });
              },
              onSubmitted: (value) {
                _searchQuery = value;
                _loadClubs();
              },
              decoration: InputDecoration(
                hintText: 'Pretraži klubove...',
                hintStyle: const TextStyle(color: Color(0xFF718096)),
                prefixIcon: const Icon(Icons.search, color: Color(0xFF718096)),
                suffixIcon: _searchController.text.isNotEmpty
                    ? IconButton(
                        icon: const Icon(Icons.clear, color: Color(0xFF718096)),
                        onPressed: () {
                          _searchController.clear();
                          setState(() {
                            _searchQuery = '';
                          });
                          _loadClubs();
                        },
                      )
                    : null,
                filled: true,
                fillColor: Colors.white,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: const BorderSide(color: Color(0xFFE2E8F0)),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: const BorderSide(color: Color(0xFFE2E8F0)),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: const BorderSide(color: Color(0xFF4AB3EF)),
                ),
              ),
            ),
          ),

          Expanded(
            child: _isLoading
                ? const LoadingSpinnerWidget(height: 200)
                : _clubs.isEmpty
                    ? Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.groups_outlined,
                              size: 64,
                              color: Colors.grey.shade400,
                            ),
                            const SizedBox(height: 16),
                            Text(
                              'Nema klubova',
                              style: TextStyle(
                                color: Colors.grey.shade500,
                                fontSize: 16,
                              ),
                            ),
                          ],
                        ),
                      )
                    : RefreshIndicator(
                        onRefresh: _loadClubs,
                        child: ListView.builder(
                          padding: const EdgeInsets.symmetric(horizontal: 16),
                          itemCount: _clubs.length,
                          itemBuilder: (context, index) {
                            final club = _clubs[index];
                            return _buildClubCard(club);
                          },
                        ),
                      ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _showCreateClubDialog,
        backgroundColor: const Color(0xFF4AB3EF),
        child: const Icon(Icons.add, color: Colors.white),
      ),
    );
  }

  Widget _buildPremiumFeature(IconData icon, String text) {
    return Row(
      children: [
        Icon(icon, color: const Color(0xFF99D6AC), size: 22),
        const SizedBox(width: 12),
        Expanded(
          child: Text(
            text,
            style: const TextStyle(
              fontFamily: 'Inter',
              fontSize: 14,
              color: Color(0xFF2D3748),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildClubCard(KlubFilmova club) {
    final isMember = _isUserMember(club);
    final isOwner = club.vlasnikId == Authorization.id;

    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => KlubDetailScreen(klubId: club.id!),
          ),
        ).then((_) => _loadClubs());
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          children: [
            Container(
              width: 56,
              height: 56,
              decoration: BoxDecoration(
                color: const Color(0xFF4AB3EF).withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: club.slika != null
                  ? ClipRRect(
                      borderRadius: BorderRadius.circular(12),
                      child: Image.memory(
                        base64Decode(club.slika!),
                        fit: BoxFit.cover,
                      ),
                    )
                  : const Icon(
                      Icons.groups,
                      color: Color(0xFF4AB3EF),
                      size: 28,
                    ),
            ),
            const SizedBox(width: 16),

            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          club.naziv ?? 'Klub',
                          style: const TextStyle(
                            fontFamily: 'Inter',
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            color: Color(0xFF2D3748),
                          ),
                        ),
                      ),
                      if (isOwner)
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 2,
                          ),
                          decoration: BoxDecoration(
                            color: const Color(0xFF99D6AC).withOpacity(0.2),
                            borderRadius: BorderRadius.circular(4),
                          ),
                          child: const Text(
                            'Vlasnik',
                            style: TextStyle(
                              fontSize: 10,
                              color: Color(0xFF99D6AC),
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      if (isMember && !isOwner)
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 2,
                          ),
                          decoration: BoxDecoration(
                            color: const Color(0xFF4AB3EF).withOpacity(0.2),
                            borderRadius: BorderRadius.circular(4),
                          ),
                          child: const Text(
                            'Član',
                            style: TextStyle(
                              fontSize: 10,
                              color: Color(0xFF4AB3EF),
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                    ],
                  ),
                  if (club.opis != null && club.opis!.isNotEmpty) ...[
                    const SizedBox(height: 4),
                    Text(
                      club.opis!,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        fontFamily: 'Inter',
                        fontSize: 13,
                        color: Color(0xFF718096),
                      ),
                    ),
                  ],
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      const Icon(
                        Icons.people,
                        size: 14,
                        color: Color(0xFF718096),
                      ),
                      const SizedBox(width: 4),
                      Text(
                        '${club.brojClanova ?? 0} članova',
                        style: const TextStyle(
                          fontFamily: 'Inter',
                          fontSize: 12,
                          color: Color(0xFF718096),
                        ),
                      ),
                      if (club.vlasnik != null) ...[
                        const SizedBox(width: 12),
                        const Icon(
                          Icons.person,
                          size: 14,
                          color: Color(0xFF718096),
                        ),
                        const SizedBox(width: 4),
                        Text(
                          club.vlasnik!.korisnickoIme ?? 'Unknown',
                          style: const TextStyle(
                            fontFamily: 'Inter',
                            fontSize: 12,
                            color: Color(0xFF718096),
                          ),
                        ),
                      ],
                    ],
                  ),
                ],
              ),
            ),

            const Icon(
              Icons.chevron_right,
              color: Color(0xFF718096),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }
}
