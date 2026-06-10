import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../bloc/auth_bloc.dart';
import '../bloc/auth_event.dart';
import '../bloc/auth_state.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AuthBloc, AuthState>(
      builder: (context, state) {
        final user = state.user;

        return Scaffold(
          appBar: AppBar(
            title: const Text('Book My Venue'),
            actions: [
              TextButton(
                onPressed: state.isSubmitting
                    ? null
                    : () => context.read<AuthBloc>().add(
                        const AuthSignOutRequested(),
                      ),
                child: const Text('Sign out'),
              ),
            ],
          ),
          body: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Home', style: Theme.of(context).textTheme.headlineMedium),
                const SizedBox(height: 12),
                Text('Signed in as ${user?.email ?? 'Unknown user'}'),
                if (user?.displayName case final displayName?
                    when displayName.isNotEmpty) ...[
                  const SizedBox(height: 8),
                  Text('Name: $displayName'),
                ],
              ],
            ),
          ),
        );
      },
    );
  }
}
