import 'package:caresync_hms/Screens%20&%20Features/User/User%20List/list_of_user.dart';
import 'package:flutter/material.dart';

class AdminDashboard extends StatelessWidget {
  const AdminDashboard({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Admin Dashboard'),
        backgroundColor: Colors.teal,
        automaticallyImplyLeading: false,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildOverviewCards(context),
            const SizedBox(height: 20),
            _buildSectionTitle('Quick Access'),
            _buildQuickAccessGrid(context),
            const SizedBox(height: 20),
            _buildSectionTitle('Recent Activity'),
            _buildActivityList(),
          ],
        ),
      ),
    );
  }

  Widget _buildOverviewCards(BuildContext context) {
    return Wrap(
      spacing: 16,
      runSpacing: 16,
      children: [
        _overviewCard(context, 'doctor', 'Total Doctors', '42', Icons.person, Colors.blue),
        _overviewCard(context, 'patient', 'Total Patients', '180', Icons.personal_injury, Colors.green),
        _overviewCard(context, 'appointments', 'Appointments Today', '23', Icons.calendar_month, Colors.orange),
        _overviewCard(context, 'doctor', 'Pending Verifications', '5', Icons.lock_clock, Colors.red),
      ],
    );
  }

  Widget _overviewCard(BuildContext context, String userType, String title, String count, IconData icon, Color color) {
    return GestureDetector(
      onTap: () {
        Navigator.of(context).push(
          MaterialPageRoute(builder: (context) => ListOfUser(userType: userType),)
        );
      },
      child: Card(
        elevation: 4,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        child: Container(
          width: 160,
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              Icon(icon, size: 32, color: color),
              const SizedBox(height: 10),
              Text(count, style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
              Text(title, textAlign: TextAlign.center, style: const TextStyle(fontSize: 14)),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Text(
      title,
      style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
    );
  }

  Widget _buildQuickAccessGrid(BuildContext context) {
    return GridView.count(
      shrinkWrap: true,
      crossAxisCount: 2,
      physics: const NeverScrollableScrollPhysics(),
      childAspectRatio: 3 / 2,
      crossAxisSpacing: 16,
      mainAxisSpacing: 16,
      children: [
        _quickAccessTile('Verify Doctors', Icons.person_add, Colors.teal,
                () {
                  Navigator.of(context).push(
                      MaterialPageRoute(builder: (context) => ListOfUser(userType: 'doctor'),)
                  );
                }
        ),
        _quickAccessTile('Manage Employees', Icons.settings, Colors.purple, () {}),
        _quickAccessTile('Medical Records', Icons.record_voice_over, Colors.indigo, () {}),
        _quickAccessTile('Analytics', Icons.analytics, Colors.deepOrange, () {}),
      ],
    );
  }

  Widget _quickAccessTile(String label, IconData icon, Color color, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Card(
        elevation: 3,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        child: Container(
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, size: 30, color: color),
              const SizedBox(height: 10),
              Text(label, textAlign: TextAlign.center, style: const TextStyle(fontSize: 14)),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildActivityList() {
    return ListView.builder(
      shrinkWrap: true,
      itemCount: 5,
      physics: const NeverScrollableScrollPhysics(),
      itemBuilder: (context, index) {
        return ListTile(
          leading: const Icon(Icons.notifications_active),
          title: Text('Activity #$index'),
          subtitle: Text('Performed on ${DateTime.now().toLocal()}'),
          trailing: const Icon(Icons.arrow_forward_ios, size: 16),
        );
      },
    );
  }
}
