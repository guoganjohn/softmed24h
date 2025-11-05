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
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 0,
        elevation: 0,
        automaticallyImplyLeading: false, // No back button on home page
      ),
      body: Row(
        children: [
          // Persistent Sidebar
          AnimatedContainer(
            duration: const Duration(milliseconds: 300), // Animation duration
            curve: Curves.easeInOut, // Animation curve
            width: _isSidebarExpanded ? 250 : 60, // Dynamic width
            color: Colors.blue[800],
            child: Column(
              children: <Widget>[
                // DrawerHeader with toggle button
                Container(
                  height: 120, // Standard DrawerHeader height
                  color: Colors.blue,
                  child: _isSidebarExpanded
                      ? Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Expanded(
                                child: const Text(
                                  'SoftMed24h',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 24,
                                  ),
                                  softWrap: false,
                                ),
                              ),
                              IconButton(
                                icon: const Icon(
                                  Icons.arrow_back_ios,
                                  color: Colors.white,
                                ),
                                padding: const EdgeInsets.only(
                                  left: 8.0,
                                ), // Shift right
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
                            padding: const EdgeInsets.only(
                              right: 8.0,
                            ), // Shift right
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

                Container(
                  margin: const EdgeInsets.symmetric(
                    horizontal: 8.0,
                    vertical: 4.0,
                  ),
                  decoration: BoxDecoration(
                    color: _selectedIndex == 0 ? Colors.white : null,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: ListTile(
                    leading: SizedBox(
                      width: 24, // Constrain the width of the leading icon
                      child: Icon(
                        Icons.person,
                        color: _selectedIndex == 0
                            ? Colors.blue[800]
                            : Colors.white,
                      ),
                    ),
                    title: _isSidebarExpanded
                        ? Text(
                            'Minha Conta',
                            style: TextStyle(
                              color: _selectedIndex == 0
                                  ? Colors.blue[800]
                                  : Colors.white,
                            ),
                            softWrap: false,
                            overflow: TextOverflow.ellipsis,
                          )
                        : null,
                    onTap: () {
                      setState(() {
                        _selectedIndex = 0;
                      });
                      context.go('/home/minha-conta');
                    },
                  ),
                ),
                Container(
                  margin: const EdgeInsets.symmetric(
                    horizontal: 8.0,
                    vertical: 4.0,
                  ),
                  decoration: BoxDecoration(
                    color: _selectedIndex == 1 ? Colors.white : null,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: ListTile(
                    leading: SizedBox(
                      width: 24, // Constrain the width of the leading icon
                      child: Icon(
                        Icons.calendar_today,
                        color: _selectedIndex == 1
                            ? Colors.blue[800]
                            : Colors.white,
                      ),
                    ),
                    title: _isSidebarExpanded
                        ? Text(
                            'Agendar Especialista',
                            style: TextStyle(
                              color: _selectedIndex == 1
                                  ? Colors.blue[800]
                                  : Colors.white,
                            ),
                            softWrap: false,
                            overflow: TextOverflow.ellipsis,
                          )
                        : null,
                    onTap: () {
                      setState(() {
                        _selectedIndex = 1;
                      });
                      context.go('/home/agendar-especialista');
                    },
                  ),
                ),
                Container(
                  margin: const EdgeInsets.symmetric(
                    horizontal: 8.0,
                    vertical: 4.0,
                  ),
                  decoration: BoxDecoration(
                    color: _selectedIndex == 2 ? Colors.white : null,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: ListTile(
                    leading: SizedBox(
                      width: 24, // Constrain the width of the leading icon
                      child: Icon(
                        Icons.video_call,
                        color: _selectedIndex == 2
                            ? Colors.blue[800]
                            : Colors.white,
                      ),
                    ),
                    title: _isSidebarExpanded
                        ? Text(
                            'Iniciar Consulta Médica',
                            style: TextStyle(
                              color: _selectedIndex == 2
                                  ? Colors.blue[800]
                                  : Colors.white,
                            ),
                            softWrap: false,
                            overflow: TextOverflow.ellipsis,
                          )
                        : null,
                    onTap: () {
                      setState(() {
                        _selectedIndex = 2;
                      });
                      context.go('/home/iniciar-consulta');
                    },
                  ),
                ),
                Container(
                  margin: const EdgeInsets.symmetric(
                    horizontal: 8.0,
                    vertical: 4.0,
                  ),
                  decoration: BoxDecoration(
                    color: _selectedIndex == 3 ? Colors.white : null,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: ListTile(
                    leading: SizedBox(
                      width: 24, // Constrain the width of the leading icon
                      child: Icon(
                        Icons.people,
                        color: _selectedIndex == 3
                            ? Colors.blue[800]
                            : Colors.white,
                      ),
                    ),
                    title: _isSidebarExpanded
                        ? Text(
                            'Convidar Amigos',
                            style: TextStyle(
                              color: _selectedIndex == 3
                                  ? Colors.blue[800]
                                  : Colors.white,
                            ),
                            softWrap: false,
                            overflow: TextOverflow.ellipsis,
                          )
                        : null,
                    onTap: () {
                      setState(() {
                        _selectedIndex = 3;
                      });
                      context.go('/home/convidar-amigos');
                    },
                  ),
                ),
                Container(
                  margin: const EdgeInsets.symmetric(
                    horizontal: 8.0,
                    vertical: 4.0,
                  ),
                  decoration: BoxDecoration(
                    color: _selectedIndex == 4 ? Colors.white : null,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: ListTile(
                    leading: SizedBox(
                      width: 24, // Constrain the width of the leading icon
                      child: Icon(
                        Icons.lock,
                        color: _selectedIndex == 4
                            ? Colors.blue[800]
                            : Colors.white,
                      ),
                    ),
                    title: _isSidebarExpanded
                        ? Text(
                            'Minha Senha',
                            style: TextStyle(
                              color: _selectedIndex == 4
                                  ? Colors.blue[800]
                                  : Colors.white,
                            ),
                            softWrap: false,
                            overflow: TextOverflow.ellipsis,
                          )
                        : null,
                    onTap: () {
                      setState(() {
                        _selectedIndex = 4;
                      });
                      context.go('/home/minha-senha');
                    },
                  ),
                ),
                const Divider(color: Colors.white),
                const Expanded(
                  child: SizedBox(),
                ), // Pushes the logout button to the bottom
                ListTile(
                  leading: SizedBox(
                    width: 24, // Constrain the width of the leading icon
                    child: const Icon(Icons.logout, color: Colors.white),
                  ),
                  title: _isSidebarExpanded
                      ? const Text(
                          'Sair',
                          style: TextStyle(color: Colors.white),
                          softWrap: false,
                          overflow: TextOverflow.ellipsis,
                        )
                      : null,
                  onTap: _logout,
                ),
              ],
            ),
          ),
          // Main Content
          Expanded(child: widget.child),
        ],
      ),
    );
  }

  void _logout() async {
    await SessionManager().clearToken();
    if (!mounted) return;
    context.go('/login');
  }
}
