import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:softmed24h/src/utils/session_manager.dart';

class HomePage extends StatefulWidget {
  final Widget child;

  const HomePage({super.key, required this.child});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  bool _isSidebarExpanded = true; // State to manage sidebar expansion
  int _selectedIndex = 0;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _updateSelectedIndex();
  }

  void _updateSelectedIndex() {
    final String location = GoRouter.of(
      context,
    ).routerDelegate.currentConfiguration.uri.path;
    int newIndex = 0; // Default to Minha Conta

    if (location.startsWith('/home/minha-conta')) {
      newIndex = 0;
    } else if (location.startsWith('/home/agendar-especialista')) {
      newIndex = 1;
    } else if (location.startsWith('/home/iniciar-consulta')) {
      newIndex = 2;
    } else if (location.startsWith('/home/convidar-amigos')) {
      newIndex = 3;
    } else if (location.startsWith('/home/minha-senha')) {
      newIndex = 4;
    }

    if (_selectedIndex != newIndex) {
      setState(() {
        _selectedIndex = newIndex;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final isMobile = constraints.maxWidth < 800;

        if (isMobile) {
          return Scaffold(
            appBar: AppBar(
              title: const Text('SoftMed24h'),
              backgroundColor: Colors.blue[800],
              elevation: 0,
              iconTheme: const IconThemeData(color: Colors.white),
              titleTextStyle: const TextStyle(
                color: Colors.white,
                fontSize: 20,
              ),
            ),
            drawer: Drawer(
              child: Container(
                color: Colors.blue[800],
                child: _buildSidebarList(isMobile: true),
              ),
            ),
            body: widget.child,
          );
        } else {
          // Desktop layout
          return Scaffold(
            appBar: AppBar(
              toolbarHeight: 0,
              elevation: 0,
              automaticallyImplyLeading: false,
            ),
            body: Row(
              children: [
                AnimatedContainer(
                  duration: const Duration(milliseconds: 300),
                  curve: Curves.easeInOut,
                  width: _isSidebarExpanded ? 250 : 60,
                  color: Colors.blue[800],
                  child: _buildSidebarList(isMobile: false),
                ),
                Expanded(child: widget.child),
              ],
            ),
          );
        }
      },
    );
  }

  Widget _buildSidebarList({required bool isMobile}) {
    final bool isExpanded = isMobile ? true : _isSidebarExpanded;

    void onItemTapped(int index, String route) {
      if (isMobile) {
        Navigator.of(context).pop(); // Close the drawer on mobile
      }
      setState(() {
        _selectedIndex = index;
      });
      context.go(route);
    }

    return Column(
      children: <Widget>[
        Container(
          height: 120,
          color: Colors.blue,
          child: isExpanded
              ? Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Expanded(
                        child: Text(
                          'SoftMed24h',
                          style: TextStyle(color: Colors.white, fontSize: 24),
                          softWrap: false,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      if (!isMobile)
                        IconButton(
                          icon: const Icon(
                            Icons.arrow_back_ios,
                            color: Colors.white,
                          ),
                          padding: const EdgeInsets.only(left: 8.0),
                          onPressed: () {
                            setState(() {
                              _isSidebarExpanded = false;
                            });
                          },
                        ),
                    ],
                  ),
                )
              : Center(
                  child: Padding(
                    padding: const EdgeInsets.only(right: 8.0),
                    child: SizedBox(
                      width: 40,
                      height: 40,
                      child: IconButton(
                        icon: const Icon(
                          Icons.arrow_forward_ios,
                          color: Colors.white,
                        ),
                        onPressed: () {
                          setState(() {
                            _isSidebarExpanded = true;
                          });
                        },
                      ),
                    ),
                  ),
                ),
        ),
        _buildMenuItem(
          index: 0,
          icon: Icons.person,
          title: 'Minha Conta',
          isExpanded: isExpanded,
          onTap: () => onItemTapped(0, '/home/minha-conta'),
        ),
        _buildMenuItem(
          index: 1,
          icon: Icons.calendar_today,
          title: 'Agendar Especialista',
          isExpanded: isExpanded,
          onTap: () => onItemTapped(1, '/home/agendar-especialista'),
        ),
        _buildMenuItem(
          index: 2,
          icon: Icons.video_call,
          title: 'Iniciar Consulta Médica',
          isExpanded: isExpanded,
          onTap: () => onItemTapped(2, '/home/iniciar-consulta'),
        ),
        _buildMenuItem(
          index: 3,
          icon: Icons.people,
          title: 'Convidar Amigos',
          isExpanded: isExpanded,
          onTap: () => onItemTapped(3, '/home/convidar-amigos'),
        ),
        _buildMenuItem(
          index: 4,
          icon: Icons.lock,
          title: 'Minha Senha',
          isExpanded: isExpanded,
          onTap: () => onItemTapped(4, '/home/minha-senha'),
        ),
        const Divider(color: Colors.white),
        const Expanded(
          child: SizedBox(),
        ), // Pushes the logout button to the bottom
        ListTile(
          leading: const SizedBox(
            width: 24, // Constrain the width of the leading icon
            child: Icon(Icons.logout, color: Colors.white),
          ),
          title: isExpanded
              ? const Text(
                  'Sair',
                  style: TextStyle(color: Colors.white),
                  softWrap: false,
                  overflow: TextOverflow.ellipsis,
                )
              : null,
          onTap: () {
            if (isMobile) {
              Navigator.of(context).pop();
            }
            _logout();
          },
        ),
      ],
    );
  }

  Widget _buildMenuItem({
    required int index,
    required IconData icon,
    required String title,
    required bool isExpanded,
    required VoidCallback onTap,
  }) {
    final bool isSelected = _selectedIndex == index;
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
      decoration: BoxDecoration(
        color: isSelected ? Colors.white : null,
        borderRadius: BorderRadius.circular(10),
      ),
      child: ListTile(
        leading: SizedBox(
          width: 24, // Constrain the width of the leading icon
          child: Icon(
            icon,
            color: isSelected ? Colors.blue[800] : Colors.white,
          ),
        ),
        title: isExpanded
            ? Text(
                title,
                style: TextStyle(
                  color: isSelected ? Colors.blue[800] : Colors.white,
                ),
                softWrap: false,
                overflow: TextOverflow.ellipsis,
              )
            : null,
        onTap: onTap,
      ),
    );
  }

  void _logout() async {
    await SessionManager().clearToken();
    if (!mounted) return;
    context.go('/login');
  }
}
