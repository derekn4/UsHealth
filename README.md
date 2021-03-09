# UsHealth

## Motivation
During the pandemic, people have lost track of their schedule and lack a daily routine. With gyms closed and most work becoming virtual, people have lost motivation to keep themselves healthy. A healthy lifestyle that includes enough exercise is important while people try their best to live their most “normal” lives right now. A healthy lifestyle will help people maintain their best physical and mental health leading to overall health and well-being.

## Solution
The market is already saturated with mobile applications that track our daily biometrics to help with health goal efforts. Some of the popular features of wellness and diet applications are: calorie tracking, diet journal, and an overview of how the user has progressed. However, there are a lot of applications that do not focus on a personalized lifestyle that ensure the user is fulfilling each of their tasks to maintain a healthy lifestyle. Each of the specialized applications have a specific goal in mind, but may be too complex for an avid user who is trying to improve their lifestyle. There are very few applications that would provide reminders and a simple health journal for the user to utilize and incorporate into their Google calendars.

## Project Goal and Approach

We have built an iOS system utilizing SwiftUI which recommends the appropriate times and exercises based on user’s activity levels for the day, physical requirements and Google Calendar schedules. In addition, our system will append these times and exercises into User’s Google Calendar for reminder purposes. We use multiple data sources to build a personal model and contextual information as follows: 

Personal Model Data Sources:
- Initial User’s Survey (Questionnaires that our application will provide for users to fill out)
- User’s provided information of weight, height, age, gender and goals 
- Daily activity levels and sleep time based on iOS Health App
- User’s Google Calendar Schedules 

Our system will retrieve data sources of the user's schedule so our application can recommend when to workout based around their schedule. All potential information entities from the Google Calendar, along with user’s sleep time, height and weight retrieved from Health’s App in iOS devices will be collected using Google Calendar’s API where users will be required to sign into their account, and from iOS Health’s App. These data sources will be stored in Firebase Realtime Database which is a cloud-hosted NoSQL database that allows us to store and sync data between our users in real time.

## Learning Outcomes

By implementing this project, we learned a lot about personalized contextual recommendation and search engine. We’ve learned to collect live relevant information about a user from all sources such as the iOS Health App, Google Calendar information and from our Questionnaire form to build a personal model in order to recommend users the right time and activities to offer lifestyle guidance. In addition, we learned to implement an iOS application using Swift. 
