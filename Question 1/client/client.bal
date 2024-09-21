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

        match choice {
            "1" => {
                Programme[] programmes = check programmeClient->/all();
                io:println("\n📚 All Programmes:");
                foreach var prog in programmes {
                    io:println(string ${prog.code}: ${prog.qualification_title} (${prog.faculty}) (${prog.nqf_level}) - Mascot: ${prog.mascot});
                }
            }
            "2" => {
                Programme newProg = {
                    code: io:readln("Enter programme code: "),
                    faculty: io:readln("Enter faculty: "),
                    nqf_level: check int:fromString(io:readln("Enter NQF Level: ")), // NQF level as integer
                    qualification_title: io:readln("Enter qualification title: "),
                    registration_date: io:readln("Enter registration date: "),
                    courses: [],
                    mascot: io:readln("Enter programme mascot: ")
                };
                string result = check programmeClient->/add_new_programme.post(newProg);
                io:println(result);
            }
            "3" => {
                string code = io:readln("Enter programme code to update: ");
                Programme updateProg = {
                    code: code,
                    faculty: io:readln("Enter new faculty: "),
                    qualification_title: io:readln("Enter new qualification title: "),
                    nqf_level: check int:fromString(io:readln("Enter NQF Level: ")), // NQF level as integer
                    registration_date: io:readln("Enter new registration date: "),
                    courses: [],
                    mascot: io:readln("Enter new programme mascot: ")
                };
                string result = check programmeClient->/update_programme/[code].put(updateProg);
                io:println(result);
            }

            "4" => {
                string code = io:readln("Enter programme code to delete: ");
                string result = check programmeClient->/delete_programme/[code].delete();
                io:println(result);
            }
            "5" => {
                string code = io:readln("Enter programme code for a random fun fact: ");
                string result = check programmeClient->/random_fun_fact/[code];
                io:println(result);
            }
            "6" => {
                io:println("👋 Thanks for using the Fun Programme Management System! Have a great day!");
                return;
            }
            _ => {
                io:println("❌ Invalid choice. Please try again.");
            }
        }

        // Star rating after each operation
        if choice != "6" {
            int rating = check int:fromString(io:readln("\nRate your experience (1-5 stars): "));
            io:println("Your rating: " + displayStars(rating));
            io:println("Thank you for your feedback!");
        }
    }
}
