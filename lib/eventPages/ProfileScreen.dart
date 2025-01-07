import 'package:eventify/bloc/userBloc.dart';
import 'package:flutter/material.dart';
import 'package:eventify/service/authService.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ProfileScreen extends StatelessWidget {

  final String cardNumber = "**** **** **** 1234";

  @override
  Widget build(BuildContext context) {
    context.read<UserBloc>().add(FetchUserData());

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child:
        BlocBuilder<UserBloc, UserState>(
          builder: (context, state) {
            if (state is UserLoading) {

            } else if (state is UserLoaded) {
              final user = state.userData;

              return  Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: [
                    Card(
                      elevation: 8,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(20.0),
                        child: Column(
                          children: [
                            Stack(
                              alignment: Alignment.center,
                              children: [
                                Container(
                                  height: 120,
                                  width: 120,
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: Colors.blue.withOpacity(0.1),
                                  ),
                                ),
                                CircleAvatar(
                                  radius: 55,
                                  backgroundColor: Colors.white,
                                  child: CircleAvatar(
                                    radius: 50,
                                    backgroundImage: AssetImage('assets/profileicon.png'),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 20),
                            Text(
                              user.name,
                              style: const TextStyle(
                                fontSize: 24,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 5),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 12,
                                vertical: 4,
                              ),
                              decoration: BoxDecoration(
                                color: Colors.blue.withOpacity(0.1),
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: Text(
                                user.isOrganizer ? "Organizer" : "User",
                                style: TextStyle(
                                  color: Colors.blue[700],
                                  fontWeight: FontWeight.w500,
                                ),
                              )

                            ),
                            const SizedBox(height: 20),
                            _buildInfoRow(Icons.email, 'Email', user.email),
                            const Divider(height: 30),
                            _buildInfoRow(Icons.credit_card, 'Card Number', cardNumber),
                            const SizedBox(height: 30),
                            SizedBox(
                              width: double.infinity,
                              child: ElevatedButton.icon(
                                onPressed: () async {
                                  await AuthService().FirebaseSignOut();
                                  Navigator.pushReplacementNamed(context, '/login');
                                },
                                icon: const Icon(Icons.logout),
                                label: const Text(
                                  "Logout",
                                  style: TextStyle(fontSize: 16),
                                ),
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.red,
                                  foregroundColor: Colors.white,
                                  padding: const EdgeInsets.symmetric(vertical: 15),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              );
            } else if (state is UserError) {
              return Center(
                child: Text('Error: ${state.error}'),
              );
            }

            return const SizedBox.shrink();
          },
        )

      ),
      );

  }

  Widget _buildInfoRow(IconData icon, String label, String value) {
    return Row(
      children: [
        Icon(icon, color: Colors.grey[600], size: 20),
        const SizedBox(width: 10),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              label,
              style: TextStyle(
                color: Colors.grey[600],
                fontSize: 14,
              ),
            ),
            Text(
              value,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ],
    );
  }
}