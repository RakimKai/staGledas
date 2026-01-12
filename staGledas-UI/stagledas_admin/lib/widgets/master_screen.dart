import 'package:flutter/material.dart';
import 'package:flutter_side_menu/flutter_side_menu.dart';
import 'package:stagledas_admin/main.dart';
import 'package:stagledas_admin/screens/analitika_screen.dart';
import 'package:stagledas_admin/screens/filmovi_screen.dart';
import 'package:stagledas_admin/screens/home_screen.dart';
import 'package:stagledas_admin/screens/korisnici_screen.dart';
import 'package:stagledas_admin/screens/novosti_screen.dart';
import 'package:stagledas_admin/screens/zalbe_screen.dart';
import 'package:stagledas_admin/utils/util.dart';

class MasterScreen extends StatefulWidget {
  final Widget? child;
  final int selectedIndex;
  final String? headerTitle;
  final String? headerDescription;
  final Widget? backButton;

  const MasterScreen({
    super.key,
    this.child,
    required this.selectedIndex,
    this.headerTitle,
    this.headerDescription,
    this.backButton,
  });

  @override
  State<MasterScreen> createState() => _MasterScreenState();
}

class _MasterScreenState extends State<MasterScreen> {
  int? selectedItem;

  final List<Map<String, dynamic>> menuItems = [
    {'title': 'Pregled', 'icon': Icons.dashboard_rounded, 'route': const HomeScreen()},
    {'title': 'Analitika', 'icon': Icons.pie_chart_rounded, 'route': const AnalitikaScreen()},
    {'title': 'Korisnici', 'icon': Icons.people_rounded, 'route': const KorisniciScreen()},
    {'title': 'Filmovi', 'icon': Icons.movie_rounded, 'route': const FilmoviScreen()},
    {'title': 'Novosti', 'icon': Icons.newspaper_rounded, 'route': const NovostiScreen()},
    {'title': 'Zalbe', 'icon': Icons.flag_rounded, 'route': const ZalbeScreen()},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.scaffoldBg,
      body: Row(
        children: [
          Padding(
            padding: const EdgeInsets.all(20),
            child: Container(
              clipBehavior: Clip.hardEdge,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
              ),
              child: SideMenu(
                mode: SideMenuMode.open,
                backgroundColor: AppColors.sidebarBg,
                hasResizer: false,
                hasResizerToggle: false,
                builder: (data) => SideMenuData(
                  header: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Row(
                      children: [
                        CircleAvatar(
                          backgroundColor: AppColors.primaryBlue,
                          child: Icon(
                            Icons.person,
                            color: Colors.white,
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Text(
                            Authorization.fullName ?? "Admin",
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                              color: AppColors.textDark,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                        PopupMenuButton<int>(
                          tooltip: "Meni",
                          iconColor: AppColors.primaryBlue,
                          initialValue: selectedItem,
                          onSelected: (int item) {
                            setState(() {
                              selectedItem = item;
                            });
                          },
                          itemBuilder: (BuildContext context) => [
                            PopupMenuItem<int>(
                              value: 1,
                              child: const Text('Odjavi se'),
                              onTap: () {
                                Authorization.password = null;
                                Authorization.username = null;
                                Authorization.fullName = null;
                                Authorization.id = null;

                                Navigator.of(context).pushAndRemoveUntil(
                                  MaterialPageRoute(
                                    builder: (context) => const LoginPage(),
                                  ),
                                  (route) => false,
                                );
                              },
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  items: menuItems.map((item) {
                    final isSelected = menuItems.indexOf(item) == widget.selectedIndex;
                    return SideMenuItemDataTile(
                      isSelected: isSelected,
                      hasSelectedLine: false,
                      highlightSelectedColor: AppColors.primaryBlue.withOpacity(0.15),
                      selectedTitleStyle: const TextStyle(fontWeight: FontWeight.w600),
                      onTap: () {
                        Navigator.of(context).pushReplacement(
                          PageRouteBuilder(
                            pageBuilder: (_, __, ___) => item['route'],
                            transitionDuration: const Duration(milliseconds: 200),
                            transitionsBuilder: (context, animation, secondaryAnimation, child) =>
                                FadeTransition(
                              opacity: Tween<double>(begin: 0.0, end: 1.0).animate(animation),
                              child: child,
                            ),
                          ),
                        );
                      },
                      title: item['title'],
                      titleStyle: TextStyle(color: AppColors.textDark),
                      icon: Icon(
                        item['icon'],
                        color: AppColors.primaryBlue,
                      ),
                    );
                  }).toList(),
                ),
              ),
            ),
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (widget.backButton != null)
                    IconButton(
                      tooltip: "Nazad",
                      onPressed: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (context) => widget.backButton!,
                          ),
                        );
                      },
                      icon: const Icon(Icons.arrow_back_rounded),
                      iconSize: 30,
                    ),
                  if (widget.headerTitle != null || widget.headerDescription != null)
                    Padding(
                      padding: const EdgeInsets.only(bottom: 20),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          if (widget.headerTitle != null)
                            Text(
                              widget.headerTitle!,
                              style: TextStyle(
                                fontSize: 24,
                                fontWeight: FontWeight.bold,
                                color: AppColors.primaryBlue,
                              ),
                            ),
                          if (widget.headerDescription != null) ...[
                            const SizedBox(height: 4),
                            Text(
                              widget.headerDescription!,
                              style: TextStyle(
                                fontSize: 14,
                                color: AppColors.textMuted,
                              ),
                            ),
                          ],
                        ],
                      ),
                    ),
                  Expanded(
                    child: widget.child ?? const SizedBox(),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
