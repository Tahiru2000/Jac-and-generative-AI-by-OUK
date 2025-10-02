


#obj Student{
   # has name: str;
    #has age: int;
    #has gpa: any;

#def get_student() -> str{
        #return f"{self.name},{self.age},{self.gpa}";
    #}
#}
#with entry{
    #Student: Student = Student("Tahiru",25,4.90)
    #print(Student.get_student())
#}


#def classify_grade(score: int) -> str {
    #if score >= 90 {
        #return "A+";
    #} elif score >= 80 {
      #  return "A";
    #} elif score >= 70 {
       # return "B+";
    #} elif score >= 60 {
        #return "B";
    #} elif score >= 50{
        #return "C+";
    #} elif score >= 40{
      #  return "C";
    #} else {
       # return "F";
    #}
#}

#with entry {
    # Raw test scores
    #test_scores: list[int] = [78, 85, 92, 69, 88, 95, 72,45,30,60,68,45];

    # Get passing grades (70 and above)
    #passing_scores: list[int] = [score for score in test_scores if score >= 70];
    #print(f"Passing scores: {passing_scores}");

    
    # Apply curve (+5 points)
    #curved_scores: list[int] = [score + 5 for score in test_scores];
    #print(f"Curved scores: {curved_scores}");

    # Classify each score
    #grades: list[str] = [classify_grade(score) for score in test_scores];
    #print(f"Grades: {grades}");

    # Students scoring below average
    #below_average: list[int] = [score for score in test_scores if score < 70];
    #print(f"scores below average: {below_average}");

    #advice
    #advice: str = [ score for score in test_scores if score < 50];
    #print(f"We advice you to retake the course. You score: {advice}");
#}

#"""A Number Guessing Game"""

#import random;

#walker GuessGame {
    #has guess: int;

    #can start with `root entry;
    #can process_guess with turn entry;
#}

#node turn {
    #has correct_number: int = random.randint(1, 10);
#}

# Will run when in CLI mode (not in cloud)
 #with entry:__main__ {
    #root spawn GuessGame(3);
    #root spawn GuessGame(4);
    #root spawn GuessGame(5);
    #root spawn GuessGame(6);
#}
 def name()->{
    return "hello world";
 }

 with entry{
    print(f"{name()}");
 }