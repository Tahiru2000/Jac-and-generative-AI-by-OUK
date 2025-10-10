""" Smart Assistant Main Menu """

import academic;
import banking;
import career;

with entry {
    while True {
        print("\n===== SMART ASSISTANT =====");
        print("1. Academic Assistant");
        print("2. Banking Assistant");
        print("3. Career Assistant");
        print("4. Exit");

        choice: str = input("Choose an option (1-4): ");

        if choice == "1" {
            academic.run_academic();
        } elif choice == "2" {
            banking.run_banking();
        } elif choice == "3" {
            career.run_career();
        } elif choice == "4" {
            print("Goodbye!");
            break;
        } else {
            print("Invalid choice, try again.");
        }
    }
}
