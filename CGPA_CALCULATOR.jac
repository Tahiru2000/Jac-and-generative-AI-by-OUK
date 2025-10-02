
""" Student CGPA Calculator in Jac """

# Function to give advice based on CGPA
def give_advice(gpa: float) -> str {
    if gpa < 3.5 {
        return """
Your CGPA is low. You need to sit up on your academic performance, else you risk being sacked from the school.
Here are some tips to improve:
1. Attend all lectures and participate actively.
2. Form or join study groups with serious classmates.
3. Create a personal timetable and manage your time well.
4. Visit your lecturers for clarifications when in doubt.
5. Reduce distractions (social media, excessive outings).
6. Practice past questions and do regular revisions.
        """;
    } else {
        return """
Congratulations! Your CGPA is strong.
Keep the momentum burning and continue boosting your academic work.
Tips to maintain your performance:
1. Keep your study consistency high.
2. Challenge yourself with extra reading.
3. Help peers, teaching reinforces your knowledge.
4. Aim for excellence and push beyond comfort zones.
        """;
    }
}

# Function to convert raw score into grade point
def score_to_point(score: int) -> float {
    if score >= 80 {
        return 4.0;  # A
    } elif score >= 70 {
        return 3.5;  # B+
    } elif score >= 60 {
        return 3.0;  # B
    } elif score >= 50 {
        return 2.5;  # C+
    } elif score >= 40 {
        return 2.0;  # C
    } else {
        return 0.0;  # F
    }
}

with entry {
    print("===== STUDENT CGPA CALCULATOR =====");

    # Ask student name
    student_name: str = input("Enter student name: ");

    # Ask number of courses
    num_courses: int = int(input("Enter the number of courses you are offering: "));

    # Lists to store data
    courses: list[str] = [];
    scores: list[int] = [];
    credits: list[int] = [];

    # Collect details per course
    for i in range(num_courses) {
        course: str = input("Enter name of course " + str(i+1) + ": ");
        credit: int = int(input("Enter credit hours for " + course + ": "));
        score: int = int(input("Enter score for " + course + ": "));

        courses.append(course);
        credits.append(credit);
        scores.append(score);
    }

    # CGPA calculation
    total_points: float = 0.0;
    total_credits: int = 0;

    for i in range(num_courses) {
        point: float = score_to_point(scores[i]);
        total_points += point * credits[i];
        total_credits += credits[i];
    }

    gpa: float = total_points / total_credits;

    # Display results
    print("\n===== RESULT =====");
    print("Student: " + student_name);
    print("Total Courses: " + str(num_courses));
    print("Your CGPA is: " + str(gpa));
    print(give_advice(gpa));
}

