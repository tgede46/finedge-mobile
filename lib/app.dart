import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import 'controllers/session_controller.dart';
import 'controllers/session_scope.dart';
import 'core/router/app_router.dart';
import 'core/theme/app_theme.dart';

class FinEdgeApp extends StatefulWidget {
  const FinEdgeApp({super.key, this.session, this.router});

  final SessionController? session;
  final GoRouter? router;

  @override
  State<FinEdgeApp> createState() => _FinEdgeAppState();
}

class _FinEdgeAppState extends State<FinEdgeApp> {
  late final SessionController _session;
  late final GoRouter _router;

  @override
  void initState() {
    super.initState();
    _session = widget.session ?? SessionController();
    _router = widget.router ?? createAppRouter(session: _session);
  }

  @override
  Widget build(BuildContext context) {
    return SessionScope(
      controller: _session,
      child: MaterialApp.router(
        title: 'FinEdge',
        debugShowCheckedModeBanner: false,
        theme: AppTheme.light,
        routerConfig: _router,
      ),
    );
  }
}
