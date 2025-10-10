""" Career Assistant in Jac """

def run_career() {
    field = input("Enter your field of interest: ");
    skills = input("Enter your skills (comma separated): ");

    print("\n--- Career Guidance ---");
    print("Field of Interest: " + field);
    print("Your Skills: " + skills);

    if field == "IT" {
        print("Suggested Careers: Software Engineer, Data Scientist, Cybersecurity Specialist.");
        print("Next Steps: Learn Python, Cloud Computing, and AI tools.");
    } elif field == "Business" {
        print("Suggested Careers: Business Analyst, Entrepreneur, Project Manager.");
        print("Next Steps: Study finance, management, and entrepreneurship.");
    } elif field == "Health" {
        print("Suggested Careers: Nurse, Medical Lab Scientist, Health Administrator.");
        print("Next Steps: Improve knowledge in biology, public health, and research.");
    } else {
        print("Suggested Careers: Explore further certifications and internships in " + field + ".");
    }
}
