from flask import Flask, render_template, request
import subprocess

app = Flask(__name__)

# ===========================
# INDEX ROUTE
# ===========================
@app.route("/", methods=["GET"])
def index():
    return render_template("index.html")


# ===========================
# ACADEMIC ROUTE
@app.route("/academic", methods=["GET", "POST"])
def academic():
    result = None

    if request.method == "POST":
        # Step 1: If user submitted only name and number of courses
        if "num_courses" in request.form and f"course_1" not in request.form:
            student_name = request.form["student_name"]
            num_courses = int(request.form["num_courses"])
            return render_template(
                "academic.html",
                student_name=student_name,
                num_courses=num_courses
            )

        # Step 2: User submitted all course details
        student_name = request.form["student_name"]
        num_courses = int(request.form["num_courses"])

        courses = []
        credits = []
        scores = []

        for i in range(1, num_courses + 1):
            courses.append(request.form.get(f"course_{i}"))
            credits.append(request.form.get(f"credit_{i}"))
            scores.append(request.form.get(f"score_{i}"))

        # Prepare Jac input exactly as Jac expects (line by line)
        input_lines = [student_name, str(num_courses)]
        for i in range(num_courses):
            input_lines.append(str(scores[i]))   # Jac expects score first
            input_lines.append(str(credits[i]))  # Then credit
        input_str = "\n".join(input_lines) + "\n"

        try:
            # Run Jac script and pass input_str to stdin
            process = subprocess.run(
                ["jac", "run", "academic.jac"],
                input=input_str,
                capture_output=True,
                text=True
            )
            # Capture stdout or stderr
            result = process.stdout.strip() or process.stderr.strip() or "No response."
        except Exception as e:
            result = f"Error: {e}"

    return render_template(
        "academic.html",
        result=result,
        student_name=request.form.get("student_name", ""),
        num_courses=request.form.get("num_courses", "")
    )


# ===========================
# BANKING ROUTE
# ===========================
@app.route("/banking", methods=["GET", "POST"])
def banking():
    result = None
    if request.method == "POST":
        acc_type = request.form.get("acc_type")
        balance = request.form.get("balance")

        input_str = f"{acc_type}\n{balance}\n"

        try:
            process = subprocess.run(
                ["jac", "run", "banking.jac"],
                input=input_str,
                capture_output=True,
                text=True
            )
            result = process.stdout if process.stdout else "No response."
        except Exception as e:
            result = f"Error: {e}"

    return render_template("banking.html", result=result)


# ===========================
# CAREER ROUTE
# ===========================
@app.route("/career", methods=["GET", "POST"])
def career():
    result = None
    if request.method == "POST":
        field = request.form.get("field")
        skills = request.form.get("skills")

        input_str = f"{field}\n{skills}\n"

        try:
            process = subprocess.run(
                ["jac", "run", "career.jac"],
                input=input_str,
                capture_output=True,
                text=True
            )
            result = process.stdout if process.stdout else "No response."
        except Exception as e:
            result = f"Error: {e}"

    return render_template("career.html", result=result)


# ===========================
# MAIN
# ===========================
if __name__ == "__main__":
    app.run(debug=True)
