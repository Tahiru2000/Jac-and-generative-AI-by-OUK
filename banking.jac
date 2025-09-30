""" Banking Advice System in Jac """

def run_banking() {
    acc_type: str = input("Enter account type (savings/current): ");
    balance: float = float(input("Enter your balance: "));

    print("\n--- Banking Advice ---\n");

    if acc_type == "savings" {
        if balance < 1000 {
            print("Warning: Low savings balance. Try to save more to avoid account charges.");
        } else {
            print("Good! Your savings are growing. Consider fixed deposits or investments.");
        }
    } elif acc_type == "current" {
        if balance < 500 {
            print("Your current account balance is too low. You may incur overdraft fees.");
        } else {
            print("Great! Your account is healthy. Keep good records for business transactions.");
        }
    } else {
        print("Invalid account type. Choose either 'savings' or 'current'.");
    }
}
