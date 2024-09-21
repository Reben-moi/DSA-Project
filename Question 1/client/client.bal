import ballerina/io;
import ballerina/http;

type Course record {
    string course_name;
    string course_code;
    int nqf_level;
    string[] fun_facts;
};

type Programme record {|
    readonly string code;
    string faculty;
    string qualification_title;
    int nqf_level;
    string registration_date;
    Course[] courses;
    string mascot;
|};

// Student information placeholders
string student_name = "<Your Name>";
string student_number = "<Your Student Number>";
string[] system_description = [
    "Welcome to the Fun Programme Management System!",
    "This system allows you to manage university programmes and courses.",
    "You can add, view, update, and delete programmes.",
    "Each programme has a unique code, faculty, qualification title, and mascot.",
    "Courses within programmes have names, codes, NQF levels, and fun facts.",
    "Enjoy managing your academic world with a touch of fun!",
    "Don't forget to rate your experience after each operation!"
];
function displayStars(int rating) returns string {
    string stars = "";
    foreach int i in 1...5 {
        stars += (i <= rating) ? "★" : "☆";
    }
    return stars;
}

public function main() returns error? {
    http:Client programmeClient = check new ("http://localhost:7500/programmeManagament");

    io:println("🎓 Fun Programme Management System 🎓");
    io:println("Student: " + student_name);
    io:println("Student Number: " + student_number);
    io:println("\n📚 System Description:");
    foreach var line in system_description {
        io:println("  " + line);
    }

    while true {
        io:println("\n🌟 What would you like to do? 🌟");
        io:println("1. View all programmes");
        io:println("2. Add a new programme");
        io:println("3. Update a programme");
        io:println("4. Delete a programme");
        io:println("5. Get a random fun fact");
        io:println("6. Exit");

        string choice = io:readln("Enter your choice (1-6): ");
