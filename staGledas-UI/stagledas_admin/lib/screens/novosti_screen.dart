import 'dart:convert';
import 'dart:typed_data';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:stagledas_admin/models/novost.dart';
import 'package:stagledas_admin/providers/novost_provider.dart';
import 'package:stagledas_admin/utils/util.dart';
import 'package:stagledas_admin/widgets/custom_button.dart';
import 'package:stagledas_admin/widgets/loading_spinner.dart';
import 'package:stagledas_admin/widgets/master_screen.dart';
import 'package:intl/intl.dart';

class NovostiScreen extends StatefulWidget {
  const NovostiScreen({super.key});

  @override
  State<NovostiScreen> createState() => _NovostiScreenState();
}

class _NovostiScreenState extends State<NovostiScreen> {
  late NovostProvider _novostProvider;
  List<Novost> _novosti = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _novostProvider = context.read<NovostProvider>();
    _loadData();
  }

  Future<void> _loadData() async {
    setState(() => _isLoading = true);
    try {
      var result = await _novostProvider.get();
      setState(() {
        _novosti = result.result;
        _isLoading = false;
      });
    } catch (e) {
      setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return MasterScreen(
      selectedIndex: 4,
      headerTitle: "Novosti",
      headerDescription: "Ovdje možete ažurirati novosti.",
      child: Stack(
        children: [
          _isLoading
              ? const LoadingSpinner()
              : _buildContent(),
          Positioned(
            bottom: 20,
            right: 20,
            child: CustomButton(
              buttonText: "Kreiraj vijest",
              icon: Icons.add,
              onPress: () => _showCreateDialog(),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildContent() {
    if (_novosti.isEmpty) {
      return const Center(
        child: Text("Nema novosti za prikaz."),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.only(bottom: 80),
      itemCount: _novosti.length,
      itemBuilder: (context, index) {
        final novost = _novosti[index];
        return _buildNewsCard(novost);
      },
    );
  }

  Widget _buildNewsCard(Novost novost) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  novost.datumKreiranja != null
                      ? DateFormat('d. MMMM yyyy', 'hr').format(novost.datumKreiranja!)
                      : '',
                  style: TextStyle(
                    fontSize: 12,
                    color: AppColors.textMuted,
                  ),
                ),
                const SizedBox(height: 12),
                Text(
                  novost.naslov ?? '',
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  novost.sadrzaj ?? '',
                  maxLines: 3,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontSize: 14,
                    color: AppColors.textMuted,
                  ),
                ),
                const SizedBox(height: 12),
                Text(
                  novost.autor?.ime != null
                      ? "${novost.autor?.ime} ${novost.autor?.prezime}"
                      : "Nepoznat autor",
                  style: TextStyle(
                    fontSize: 13,
                    color: AppColors.textDark,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 16),
          if (novost.slika != null)
            ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: _buildImage(novost.slika!),
            )
          else
            Container(
              width: 120,
              height: 100,
              decoration: BoxDecoration(
                color: AppColors.sidebarBg,
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Icon(Icons.image, color: AppColors.textMuted),
            ),
          const SizedBox(width: 16),
          Column(
            children: [
              IconButton(
                icon: const Icon(Icons.edit),
                color: AppColors.primaryBlue,
                onPressed: () => _showEditDialog(novost),
                tooltip: "Uredi",
              ),
              IconButton(
                icon: const Icon(Icons.delete),
                color: AppColors.error,
                onPressed: () => _confirmDelete(novost),
                tooltip: "Obriši",
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildImage(String imageData) {
    try {
      Uint8List bytes = base64Decode(imageData);
      return Image.memory(
        bytes,
        width: 120,
        height: 100,
        fit: BoxFit.cover,
        errorBuilder: (context, error, stackTrace) => _buildImagePlaceholder(),
      );
    } catch (e) {
      return _buildImagePlaceholder();
    }
  }

  Widget _buildImagePlaceholder() {
    return Container(
      width: 120,
      height: 100,
      decoration: BoxDecoration(
        color: AppColors.sidebarBg,
        borderRadius: BorderRadius.circular(8),
      ),
      child: const Icon(Icons.image, color: AppColors.textMuted),
    );
  }

  void _showCreateDialog() {
    final formKey = GlobalKey<FormState>();
    final naslovController = TextEditingController();
    final sadrzajController = TextEditingController();
    Uint8List? selectedImageBytes;

    showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setDialogState) => AlertDialog(
          title: const Text("Kreiraj vijest"),
          content: SizedBox(
            width: 500,
            child: Form(
              key: formKey,
              child: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    TextFormField(
                      controller: naslovController,
                      decoration: const InputDecoration(
                        labelText: "Naslov",
                        border: OutlineInputBorder(),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Naslov je obavezan';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 16),
                    TextFormField(
                      controller: sadrzajController,
                      maxLines: 6,
                      decoration: const InputDecoration(
                        labelText: "Sadržaj",
                        border: OutlineInputBorder(),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Sadržaj je obavezan';
                        }
                        if (value.length < 10) {
                          return 'Sadržaj mora imati najmanje 10 znakova';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 16),
                    GestureDetector(
                      onTap: () async {
                        FilePickerResult? result = await FilePicker.platform.pickFiles(
                          type: FileType.image,
                          withData: true,
                        );
                        if (result != null && result.files.single.bytes != null) {
                          setDialogState(() {
                            selectedImageBytes = result.files.single.bytes;
                          });
                        }
                      },
                      child: Container(
                        width: double.infinity,
                        height: 150,
                        decoration: BoxDecoration(
                          color: AppColors.sidebarBg,
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(color: Colors.grey.shade300),
                        ),
                        child: selectedImageBytes != null
                            ? Stack(
                                children: [
                                  ClipRRect(
                                    borderRadius: BorderRadius.circular(8),
                                    child: Image.memory(
                                      selectedImageBytes!,
                                      width: double.infinity,
                                      height: 150,
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                  Positioned(
                                    top: 8,
                                    right: 8,
                                    child: GestureDetector(
                                      onTap: () {
                                        setDialogState(() {
                                          selectedImageBytes = null;
                                        });
                                      },
                                      child: Container(
                                        padding: const EdgeInsets.all(4),
                                        decoration: const BoxDecoration(
                                          color: Colors.red,
                                          shape: BoxShape.circle,
                                        ),
                                        child: const Icon(
                                          Icons.close,
                                          color: Colors.white,
                                          size: 16,
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              )
                            : Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(Icons.add_photo_alternate, size: 40, color: AppColors.textMuted),
                                  const SizedBox(height: 8),
                                  Text(
                                    "Klikni za dodavanje slike",
                                    style: TextStyle(color: AppColors.textMuted),
                                  ),
                                ],
                              ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text("Odustani"),
            ),
            TextButton(
              onPressed: () async {
                if (!formKey.currentState!.validate()) return;
                final scaffoldMessenger = ScaffoldMessenger.of(context);
                Navigator.pop(context);
                try {
                  final request = {
                    'naslov': naslovController.text,
                    'sadrzaj': sadrzajController.text,
                  };
                  if (selectedImageBytes != null) {
                    request['slika'] = base64Encode(selectedImageBytes!);
                  }
                  await _novostProvider.insert(request);
                  _loadData();
                  scaffoldMessenger.showSnackBar(
                    const SnackBar(content: Text("Vijest uspješno kreirana.")),
                  );
                } catch (e) {
                  scaffoldMessenger.showSnackBar(
                    const SnackBar(content: Text("Greška pri kreiranju vijesti.")),
                  );
                }
              },
              child: Text("Kreiraj", style: TextStyle(color: AppColors.success)),
            ),
          ],
        ),
      ),
    );
  }

  void _showEditDialog(Novost novost) {
    final formKey = GlobalKey<FormState>();
    final naslovController = TextEditingController(text: novost.naslov ?? '');
    final sadrzajController = TextEditingController(text: novost.sadrzaj ?? '');
    Uint8List? selectedImageBytes;
    bool imageRemoved = false;

    if (novost.slika != null) {
      try {
        selectedImageBytes = base64Decode(novost.slika!);
      } catch (e) {
      }
    }

    showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setDialogState) => AlertDialog(
          title: const Text("Uredi vijest"),
          content: SizedBox(
            width: 500,
            child: Form(
              key: formKey,
              child: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    TextFormField(
                      controller: naslovController,
                      decoration: const InputDecoration(
                        labelText: "Naslov",
                        border: OutlineInputBorder(),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Naslov je obavezan';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 16),
                    TextFormField(
                      controller: sadrzajController,
                      maxLines: 6,
                      decoration: const InputDecoration(
                        labelText: "Sadržaj",
                        border: OutlineInputBorder(),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Sadržaj je obavezan';
                        }
                        if (value.length < 10) {
                          return 'Sadržaj mora imati najmanje 10 znakova';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 16),
                    GestureDetector(
                      onTap: () async {
                        FilePickerResult? result = await FilePicker.platform.pickFiles(
                          type: FileType.image,
                          withData: true,
                        );
                        if (result != null && result.files.single.bytes != null) {
                          setDialogState(() {
                            selectedImageBytes = result.files.single.bytes;
                            imageRemoved = false;
                          });
                        }
                      },
                      child: Container(
                        width: double.infinity,
                        height: 150,
                        decoration: BoxDecoration(
                          color: AppColors.sidebarBg,
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(color: Colors.grey.shade300),
                        ),
                        child: selectedImageBytes != null && !imageRemoved
                            ? Stack(
                                children: [
                                  ClipRRect(
                                    borderRadius: BorderRadius.circular(8),
                                    child: Image.memory(
                                      selectedImageBytes!,
                                      width: double.infinity,
                                      height: 150,
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                  Positioned(
                                    top: 8,
                                    right: 8,
                                    child: GestureDetector(
                                      onTap: () {
                                        setDialogState(() {
                                          selectedImageBytes = null;
                                          imageRemoved = true;
                                        });
                                      },
                                      child: Container(
                                        padding: const EdgeInsets.all(4),
                                        decoration: const BoxDecoration(
                                          color: Colors.red,
                                          shape: BoxShape.circle,
                                        ),
                                        child: const Icon(
                                          Icons.close,
                                          color: Colors.white,
                                          size: 16,
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              )
                            : Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(Icons.add_photo_alternate, size: 40, color: AppColors.textMuted),
                                  const SizedBox(height: 8),
                                  Text(
                                    "Klikni za dodavanje slike",
                                    style: TextStyle(color: AppColors.textMuted),
                                  ),
                                ],
                              ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text("Odustani"),
            ),
            TextButton(
              onPressed: () async {
                if (!formKey.currentState!.validate()) return;
                final scaffoldMessenger = ScaffoldMessenger.of(context);
                Navigator.pop(context);
                try {
                  final request = {
                    'naslov': naslovController.text,
                    'sadrzaj': sadrzajController.text,
                  };
                  if (imageRemoved) {
                    request['slika'] = '';
                  } else if (selectedImageBytes != null) {
                    request['slika'] = base64Encode(selectedImageBytes!);
                  }
                  await _novostProvider.update(novost.id!, request);
                  _loadData();
                  scaffoldMessenger.showSnackBar(
                    const SnackBar(content: Text("Vijest uspješno ažurirana.")),
                  );
                } catch (e) {
                  scaffoldMessenger.showSnackBar(
                    const SnackBar(content: Text("Greška pri ažuriranju vijesti.")),
                  );
                }
              },
              child: Text("Spremi", style: TextStyle(color: AppColors.primaryBlue)),
            ),
          ],
        ),
      ),
    );
  }

  void _confirmDelete(Novost novost) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Potvrda brisanja"),
        content: Text("Da li ste sigurni da želite obrisati vijest '${novost.naslov}'?"),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Odustani"),
          ),
          TextButton(
            onPressed: () async {
              final scaffoldMessenger = ScaffoldMessenger.of(context);
              Navigator.pop(context);
              try {
                await _novostProvider.delete(novost.id!);
                _loadData();
                scaffoldMessenger.showSnackBar(
                  const SnackBar(content: Text("Vijest uspješno obrisana.")),
                );
              } catch (e) {
                scaffoldMessenger.showSnackBar(
                  const SnackBar(content: Text("Greška pri brisanju vijesti.")),
                );
              }
            },
            child: Text("Obriši", style: TextStyle(color: AppColors.error)),
          ),
        ],
      ),
    );
  }
}
