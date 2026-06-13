import 'dart:async';
import 'package:flutter/material.dart';
import 'package:lr16_firebase_auth/controllers/home_actions_controller.dart';
import 'package:lr16_firebase_auth/repositories/auth_repository.dart';
import 'package:lr16_firebase_auth/repositories/notes_repository.dart';
import 'package:lr16_firebase_auth/repositories/storage_repository.dart';

import 'package:lr16_firebase_auth/constants/home_strings.dart';
import 'package:lr16_firebase_auth/constants/notes_strings.dart';
import 'package:lr16_firebase_auth/screens/notes_screen.dart';
import 'package:lr16_firebase_auth/widgets/home/account_actions_section.dart';
import 'package:lr16_firebase_auth/widgets/home/home_header.dart';
import 'package:lr16_firebase_auth/widgets/home/logout_button.dart';
import 'package:lr16_firebase_auth/widgets/home/notes_navigation_section.dart';
import 'package:lr16_firebase_auth/widgets/home/protected_routes_section.dart';
import 'package:lr16_firebase_auth/widgets/home/session_card.dart';
import 'package:lr16_firebase_auth/widgets/section_title.dart';

class HomeScreen extends StatefulWidget {
  final AuthRepository authRepository;
  final NotesRepository notesRepository;
  final StorageRepository storageRepository;

  const HomeScreen({
    super.key,
    required this.authRepository,
    required this.notesRepository,
    required this.storageRepository,
  });

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late final HomeActionsController _controller;

  /// Cached display name and email that are refreshed whenever the auth state
  /// stream emits.  This replaces the empty `setState(() {})` anti-pattern
  /// that forced a rebuild without actually reading new data from the stream.
  String? _displayName;
  String? _email;
  bool _emailVerified = false;

  late final StreamSubscription<bool> _authSub;

  @override
  void initState() {
    super.initState();
    _controller = HomeActionsController(
      authCredentialsRepository: widget.authRepository,
      accountRepository: widget.authRepository,
      authStateRepository: widget.authRepository,
    );

    // Seed initial values synchronously.
    _syncUserInfo();

    // Re-read user info whenever auth state changes (e.g. after
    // updateDisplayName, sendEmailVerification, etc.).
    _authSub = widget.authRepository.authStateChanges.listen((_) {
      if (mounted) _syncUserInfo();
    });
  }

  void _syncUserInfo() {
    setState(() {
      _displayName = widget.authRepository.currentDisplayName;
      _email = widget.authRepository.currentEmail;
      _emailVerified = widget.authRepository.isEmailVerified;
    });
  }

  @override
  void dispose() {
    _authSub.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(HomeStrings.appBarTitle),
        actions: [
          IconButton(
            tooltip: NotesStrings.screenTitle,
            icon: const Icon(Icons.note_alt_outlined),
            onPressed: _openNotes,
          ),
          LogoutButton(controller: _controller),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          children: [
            const SizedBox(height: 20),
            HomeHeader(
              displayName: _displayName,
              email: _email,
              isEmailVerified: _emailVerified,
            ),
            const SizedBox(height: 24),
            SizedBox(
              width: double.infinity,
              child: FilledButton.icon(
                onPressed: _openNotes,
                icon: const Icon(Icons.note_alt_outlined),
                label: const Text(NotesStrings.screenTitle),
              ),
            ),
            const SizedBox(height: 32),
            const SessionCard(),
            const SizedBox(height: 32),
            SectionTitle(title: NotesStrings.myNotesNavTitle),
            const SizedBox(height: 16),
            NotesNavigationSection(
              notesRepository: widget.notesRepository,
              storageRepository: widget.storageRepository,
            ),
            const SizedBox(height: 32),
            SectionTitle(title: HomeStrings.sectionProtectedScreens),
            const SizedBox(height: 16),
            ProtectedRoutesSection(authStateRepository: widget.authRepository),
            const SizedBox(height: 32),
            SectionTitle(title: HomeStrings.sectionAccountActions),
            const SizedBox(height: 16),
            AccountActionsSection(
              authStateRepository: widget.authRepository,
              controller: _controller,
              // _syncUserInfo reads fresh data from the repository and triggers
              // a real rebuild - no more empty setState.
              onAccountChanged: _syncUserInfo,
            ),
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }

  void _openNotes() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => NotesScreen(
          notesRepository: widget.notesRepository,
          storageRepository: widget.storageRepository,
        ),
      ),
    );
  }
}
