import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:stagledas_mobile/screens/home_screen.dart';
import 'package:stagledas_mobile/screens/klub_list_screen.dart';
import 'package:stagledas_mobile/screens/profile_screen.dart';
import 'package:stagledas_mobile/screens/recenzije_screen.dart';
import 'package:stagledas_mobile/screens/search_screen.dart';

class MasterLayout extends StatefulWidget {
  final Widget child;
  final int selectedIndex;
  final String? header;
  final String? headerDescription;
  final Color? headerColor;
  final bool showBackButton;
  final Widget? floatingActionButton;

  const MasterLayout({
    super.key,
    required this.child,
    required this.selectedIndex,
    this.header,
    this.headerDescription,
    this.headerColor,
    this.showBackButton = false,
    this.floatingActionButton,
  });

  @override
  State<MasterLayout> createState() => _MasterLayoutState();
}

class _MasterLayoutState extends State<MasterLayout> {
  final List<Map<String, dynamic>> menuItems = [
    {'title': 'Početna', 'icon': Icons.home_rounded, 'route': const HomeScreen()},
    {'title': 'Recenzije', 'icon': Icons.star_rate_rounded, 'route': const RecenzijeScreen()},
    {'title': 'Pretraži', 'icon': Icons.search_rounded, 'route': const SearchScreen()},
    {'title': 'Klubovi', 'icon': Icons.groups_rounded, 'route': const KlubListScreen()},
    {'title': 'Profil', 'icon': Icons.person_rounded, 'route': const ProfileScreen()},
  ];

  void _onItemTapped(int index) {
    Navigator.of(context).pushReplacement(
      PageRouteBuilder(
        pageBuilder: (context, animation1, animation2) =>
            menuItems[index]['route'] as Widget,
        transitionDuration: Duration.zero,
        reverseTransitionDuration: Duration.zero,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: true,
      child: Scaffold(
        backgroundColor: const Color(0xFFF2FCFB),
        floatingActionButton: widget.floatingActionButton,
        body: SafeArea(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (widget.showBackButton)
                Padding(
                  padding: const EdgeInsets.only(top: 10, left: 10),
                  child: IconButton(
                    onPressed: () => Navigator.of(context).pop(),
                    iconSize: 30,
                    icon: const Icon(Icons.chevron_left, color: Color(0xFF2D3748)),
                  ),
                ),
              if (widget.header != null)
                Container(
                  margin: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(15),
                    color: (widget.headerColor ?? const Color(0xFF4AB3EF))
                        .withOpacity(0.2),
                  ),
                  alignment: Alignment.centerLeft,
                  child: Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          widget.header ?? '',
                          style: TextStyle(
                            fontFamily: "Inter",
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: widget.headerColor ?? const Color(0xFF4AB3EF),
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                        if (widget.headerDescription != null)
                          Text(
                            widget.headerDescription ?? '',
                            style: const TextStyle(
                              fontFamily: "Inter",
                              fontSize: 13,
                              fontWeight: FontWeight.normal,
                              color: Color(0xFF718096),
                            ),
                            overflow: TextOverflow.ellipsis,
                          ),
                      ],
                    ),
                  ),
                ),
              Expanded(child: widget.child),
            ],
          ),
        ),
        bottomNavigationBar: Container(
          decoration: BoxDecoration(
            color: Colors.white,
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.05),
                blurRadius: 10,
                offset: const Offset(0, -2),
              ),
            ],
          ),
          child: CupertinoTabBar(
            backgroundColor: Colors.white,
            items: menuItems
                .map((e) => BottomNavigationBarItem(
                      icon: Icon(e['icon'], size: 28),
                      activeIcon: Icon(
                        e['icon'],
                        color: const Color(0xFF4AB3EF),
                        size: 28,
                      ),
                      label: e['title'],
                    ))
                .toList(),
            inactiveColor: const Color(0xFF718096),
            currentIndex: widget.selectedIndex,
            onTap: (value) => _onItemTapped(value),
            activeColor: const Color(0xFF4AB3EF),
          ),
        ),
      ),
    );
  }
}
