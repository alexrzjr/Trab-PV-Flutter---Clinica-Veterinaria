import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../navigation/app_routes.dart';
import '../providers/auth_provider.dart';
import '../services/alertas_service.dart';
import '../theme/app_theme.dart';
import '../../pages/login_page.dart';

class MainShell extends StatefulWidget {
  const MainShell({super.key});

  @override
  State<MainShell> createState() => _MainShellState();
}

class _MainShellState extends State<MainShell> {
  AppSection _current = AppSection.dashboard;
  int _alertasCount = 0;
  final _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    _loadAlertas();
  }

  Future<void> _loadAlertas() async {
    final count = await AlertasService.instance.countAlertas();
    if (mounted) setState(() => _alertasCount = count);
  }

  void _navigate(AppSection section) {
    setState(() => _current = section);
    if (section == AppSection.alertas) _loadAlertas();
    final isWide = MediaQuery.sizeOf(context).width >= 900;
    if (!isWide) _scaffoldKey.currentState?.closeDrawer();
  }

  void _logout() {
    context.read<AuthProvider>().logout();
    Navigator.of(
      context,
    ).pushReplacement(MaterialPageRoute(builder: (_) => const LoginPage()));
  }

  @override
  Widget build(BuildContext context) {
    final auth = context.watch<AuthProvider>();
    final usuario = auth.usuario;
    final isWide = MediaQuery.sizeOf(context).width >= 900;
    final menuItems = AppRoutes.itemsForProfile(usuario?.perfil ?? 'recepcao');
    final groups = menuItems.map((m) => m.group).toSet().toList();

    final sidebar = _SidebarContent(
      usuario: usuario,
      menuItems: menuItems,
      groups: groups,
      current: _current,
      alertasCount: _alertasCount,
      onNavigate: _navigate,
      onLogout: _logout,
    );

    final body = Column(
      children: [
        Container(
          height: 64,
          padding: const EdgeInsets.symmetric(horizontal: 16),
          decoration: BoxDecoration(
            color: Colors.white,
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.05),
                blurRadius: 4,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Row(
            children: [
              if (!isWide)
                IconButton(
                  icon: const Icon(Icons.menu),
                  onPressed: () => _scaffoldKey.currentState?.openDrawer(),
                ),
              Text(
                AppRoutes.titleFor(_current),
                style: Theme.of(
                  context,
                ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w600),
              ),
              const Spacer(),
              if (_alertasCount > 0)
                Padding(
                  padding: const EdgeInsets.only(right: 8),
                  child: ActionChip(
                    avatar: Icon(
                      Icons.warning,
                      size: 16,
                      color: Colors.orange.shade800,
                    ),
                    label: Text('$_alertasCount alertas'),
                    onPressed: () => _navigate(AppSection.alertas),
                  ),
                ),
              Chip(
                avatar: Icon(
                  Icons.circle,
                  size: 10,
                  color: Colors.green.shade400,
                ),
                label: Text(usuario?.perfil ?? 'online'),
                backgroundColor: Colors.green.shade50,
              ),
            ],
          ),
        ),
        Expanded(
          child: AnimatedSwitcher(
            duration: const Duration(milliseconds: 200),
            child: KeyedSubtree(
              key: ValueKey(_current),
              child: AppRoutes.pageFor(_current),
            ),
          ),
        ),
      ],
    );

    if (isWide) {
      return Scaffold(
        body: Row(
          children: [
            SizedBox(width: 280, child: sidebar),
            Expanded(child: body),
          ],
        ),
      );
    }

    return Scaffold(
      key: _scaffoldKey,
      drawer: Drawer(
        width: 280,
        backgroundColor: AppTheme.sidebar,
        child: sidebar,
      ),
      body: body,
    );
  }
}

class _SidebarContent extends StatelessWidget {
  final dynamic usuario;
  final List<MenuItem> menuItems;
  final List<String> groups;
  final AppSection current;
  final int alertasCount;
  final ValueChanged<AppSection> onNavigate;
  final VoidCallback onLogout;

  const _SidebarContent({
    required this.usuario,
    required this.menuItems,
    required this.groups,
    required this.current,
    required this.alertasCount,
    required this.onNavigate,
    required this.onLogout,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppTheme.sidebar, // FUNDO DO MENU TODO
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: AppTheme.primary.withValues(alpha: 0.3),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: AppTheme.accent,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: const Icon(Icons.pets, color: Colors.white),
                    ),
                    const SizedBox(width: 12),
                    const Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'VetClinic',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text(
                            'Gestão Veterinária',
                            style: TextStyle(
                              color: Colors.white70,
                              fontSize: 12,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                if (usuario != null) ...[
                  const SizedBox(height: 16),
                  Text(
                    usuario.nome,
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  Text(
                    usuario.email,
                    style: const TextStyle(color: Colors.white60, fontSize: 12),
                  ),
                ],
              ],
            ),
          ),
          Expanded(
            child: ListView(
              padding: const EdgeInsets.symmetric(vertical: 8),
              children: [
                for (final group in groups) ...[
                  Padding(
                    padding: const EdgeInsets.fromLTRB(20, 16, 20, 8),
                    child: Text(
                      group.toUpperCase(),
                      style: const TextStyle(
                        color: Colors.white38,
                        fontSize: 11,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 1.2,
                      ),
                    ),
                  ),
                  for (final item in menuItems.where((m) => m.group == group))
                    _MenuTile(
                      item: item,
                      selected: current == item.section,
                      badge:
                          item.section == AppSection.alertas && alertasCount > 0
                          ? alertasCount
                          : null,
                      onTap: () => onNavigate(item.section),
                    ),
                ],
              ],
            ),
          ),
          const Divider(color: Colors.white24, height: 1),
          ListTile(
            leading: const Icon(Icons.logout, color: Colors.white70),
            title: const Text('Sair', style: TextStyle(color: Colors.white70)),
            onTap: onLogout,
          ),
        ],
      ),
    );
  }
}

class _MenuTile extends StatelessWidget {
  final MenuItem item;
  final bool selected;
  final int? badge;
  final VoidCallback onTap;

  const _MenuTile({
    required this.item,
    required this.selected,
    this.badge,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 2),
      child: Material(
        color: selected
            ? AppTheme.primaryLight.withValues(alpha: 0.5)
            : Colors.transparent,
        borderRadius: BorderRadius.circular(10),
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(10),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
            child: Row(
              children: [
                Icon(
                  item.icon,
                  color: selected ? Colors.white : Colors.white60,
                  size: 22,
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    item.label,
                    style: TextStyle(
                      color: selected ? Colors.white : Colors.white70,
                      fontWeight: selected
                          ? FontWeight.w600
                          : FontWeight.normal,
                    ),
                  ),
                ),
                if (badge != null)
                  CircleAvatar(
                    radius: 10,
                    backgroundColor: Colors.orange,
                    child: Text(
                      '$badge',
                      style: const TextStyle(fontSize: 10, color: Colors.white),
                    ),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
