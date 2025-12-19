import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import '../theme/app_theme.dart';
import '../widgets/section_header.dart';
import '../widgets/project_card.dart';

class ProjectsSection extends StatefulWidget {
  const ProjectsSection({super.key});

  @override
  State<ProjectsSection> createState() => _ProjectsSectionState();
}

class _ProjectsSectionState extends State<ProjectsSection> {
  final ScrollController _scrollController = ScrollController();

  static const List<ProjectData> _projects = [
    ProjectData(
      title: 'Meal Planner App',
      description:
          'A recipe meal planner app featuring a Tinder-style swiping interface '
          'with external API integration and a calendar view to plan meals. '
          'Incorporated CRUD operations for recipes and unit-testing for business logic.',
      imageUrl: 'assets/images/MealplannerApp.png',
      technologies: ['Swift', 'SwiftUI', 'SwiftData', 'MVVM'],
      githubUrl: 'https://github.com/Nazlizamanian/iOS_Development_TISK18',
    ),
    ProjectData(
      title: 'Weather App',
      description:
          'A weather application created in iOS using the Open-Meteo API. '
          'Displays current weather conditions and forecasts with a clean, '
          'intuitive user interface built with Swift.',
      imageUrl: 'assets/images/WeatherApp.png',
      technologies: ['Swift', 'iOS', 'Open-Meteo API', 'SwiftUI'],
      githubUrl: 'https://github.com/Nazlizamanian/weather-app',
      imageAlignment: Alignment.center,
    ),
    ProjectData(
      title: 'JKPG - City Page',
      description:
          'A webpage built with JavaScript and HTML, featuring interactive elements '
          'and dynamic content updates. Demonstrates web development skills in creating '
          'engaging, responsive user interfaces with Docker and PostgreSQL.',
      imageUrl: 'assets/images/JKPGCity.png',
      technologies: ['JavaScript', 'HTML/CSS', 'Docker', 'PostgreSQL'],
      githubUrl: 'https://github.com/Nazlizamanian/Web-Development-Advanced-Concepts-Project-Jkpg-City',
    ),
    ProjectData(
      title: 'Tic Tac Toe',
      description:
          'A multiplayer Tic Tac Toe game built in Android using Kotlin. '
          'Features real-time gameplay through Firebase Realtime Database for '
          'seamless updates. Play with other players by sending invites in real time.',
      imageUrl: '',
      technologies: ['Kotlin', 'Android', 'Firebase', 'Realtime DB'],
      githubUrl: 'https://github.com/Nazlizamanian/TicTacToe',
    ),
  ];

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isMobile = AppTheme.isMobile(context);

    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(
        vertical: isMobile ? 60 : 100,
      ),
      decoration: BoxDecoration(
        color: AppTheme.secondaryDark.withValues(alpha: 0.5),
      ),
      child: Column(
        children: [
          Padding(
            padding: EdgeInsets.symmetric(
              horizontal: AppTheme.getHorizontalPadding(context),
            ),
            child: const SectionHeader(
              title: 'Projects',
              subtitle: 'Some of my recent work',
            ),
          ),
          _buildHorizontalScroll(context, isMobile),
        ],
      ),
    );
  }

  Widget _buildHorizontalScroll(BuildContext context, bool isMobile) {
    final cardHeight = isMobile ? 480.0 : 520.0;
    const hoverOffset = 12.0; // Extra space for hover effect

    return Column(
      children: [
        SizedBox(
          height: cardHeight + hoverOffset,
          child: ScrollConfiguration(
            behavior: ScrollConfiguration.of(context).copyWith(
              dragDevices: {
                PointerDeviceKind.touch,
                PointerDeviceKind.mouse,
              },
            ),
            child: ListView.builder(
              controller: _scrollController,
              scrollDirection: Axis.horizontal,
              physics: const BouncingScrollPhysics(),
              padding: EdgeInsets.only(
                left: AppTheme.getHorizontalPadding(context),
                right: AppTheme.getHorizontalPadding(context),
                top: hoverOffset,
              ),
              itemCount: _projects.length,
              itemBuilder: (context, index) {
                return Padding(
                  padding: EdgeInsets.only(
                    right: index < _projects.length - 1 ? 24 : 0,
                  ),
                  child: ProjectCard(
                    project: _projects[index],
                    isMobile: isMobile,
                  ),
                );
              },
            ),
          ),
        ),
      ],
    );
  }
}
