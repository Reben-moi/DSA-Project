import ballerina/io;
import ballerina/http;

// Define a record to store information about a course
type Course record {
    string course_name; 
    string course_code; 
    int nqf_level; 
    string[] fun_facts; 
};

// Define a record to store information about a programme
type Programme record {| 
    readonly string code; 
    string faculty; 
    string qualification_title;
    int nqf_level;
    string registration_date;
    int reg_year;
    Course[] courses; 
    string description;
|};

// Placeholder variables for student information
string student_name = "<Your Name>"; 
string student_number = "<Your Student Number>"; 

// Description of the system that will be displayed to users
string[] system_description = [
    "Welcome to the Fun Programme Management System!", 
    "This system allows you to manage university programmes and courses.", 
    "You can add, view, update, and delete programmes.", 
    "Each programme has a unique code, faculty, qualification title, and description.", 
    "Courses within programmes have names, codes, NQF levels, and fun facts.", 
    "Enjoy managing your academic world with a touch of fun!", 
    "Don't forget to rate your experience after each operation!" 
];

// Main function to manage the programme operations
public function main() returns error? {
    // Create an HTTP client to interact with the programme management service
    http:Client programmeClient = check new ("http://localhost:7500/programmeManagament");

    // Print welcome message and student details
    io:println("🎓 Fun Programme Management System 🎓");
    io:println("Student: " + student_name);
    io:println("Student Number: " + student_number);

    // Display the system description to the user
    io:println("\n📚 System Description:");
    foreach var line in system_description { // Loop through each line of the system description
        io:println("  " + line); // Print the line
    }

    // Start an infinite loop to allow continuous user input
    while true {
        io:println("\n🌟 What would you like to do? 🌟");
        // Display the options for the user
        io:println("1. View all programmes: ");
        io:println("2. Add a new programme: ");
        io:println("3. Update a programme: ");
        io:println("4. Delete a programme: ");
        io:println("5. Get Programme by code: ");
        io:println("6. Get Programme by Faculty: ");
        io:println("7. Get Programme that are due: ");
        io:println("8. Get a random fun fact: ");
        io:println("9. Exit");

        // Get the user's choice
        string choice = io:readln("Enter your choice (1-9): ");

        // Handle the user's choice using match
        match choice {
            "1" => {
                // Fetch and display all programmes
                Programme[] programmes = check programmeClient->/all();
                io:println("\n📚 All Programmes:");
                foreach var prog in programmes {
                    io:println(string `${prog.code}: ${prog.qualification_title} (${prog.faculty}) (${prog.nqf_level}) - Mascot: ${prog.description}`);
                }
            }
            "2" => {
                // Add a new programme
                string year = io:readln("Enter the year of registration of the Programme: ");
                int year_int = check int:fromString(year); // Convert input to integer
                Programme newProg = {
                    code: io:readln("Enter programme code: "),
                    faculty: io:readln("Enter faculty: "),
                    qualification_title: io:readln("Enter qualification title: "),
                     nqf_level: check int:fromString(io:readln("Enter NQF Level: ")), 
                    registration_date: io:readln("Enter registration date: "),
                    courses: [], 
                    description: io:readln("Enter programme description: "),
                    reg_year: year_int 
                };
                // Send the new programme to the server and print the response
                string result = check programmeClient->/add_new_programme.post(newProg);
                io:println(result);
            }
            "3" => {
                // Update an existing programme
                string code = io:readln("Enter programme code to update: ");
                string year = io:readln("Enter the year of registration of the Programme: ");
                int year_int = check int:fromString(year); // Convert input to integer
                Programme updateProg = {
                    code: code,
                    faculty: io:readln("Enter new faculty: "),
                    qualification_title: io:readln("Enter new qualification title: "),
                     nqf_level: check int:fromString(io:readln("Enter NQF Level: ")), 
                    registration_date: io:readln("Enter new registration date: "),
                    courses: [], // Initialize an empty course array
                    description: io:readln("Enter new programme description: "),
                    reg_year: year_int // Assign the updated year
                };
                // Send the updated programme to the server and print the response
                string result = check programmeClient->/update_programme/[code].put(updateProg);
                io:println(result);
            }
            "4" => {
                // Delete a programme
                string code = io:readln("Enter programme code to delete: ");
                // Send the delete request to the server and print the response
                string result = check programmeClient->/delete_programme/[code].delete();
                io:println(result);
            }
            "5" => {
                // Fetch a programme by code
                string code = io:readln("Enter programme code to retrieve the data: ");
                Programme programmes = check programmeClient->/getByCode/[code]();
                io:println("\n📚 Programme:");
                
                io:println("Code: ", programmes.code );
                io:println("Qualification Title: ", programmes.qualification_title);
                io:println("Faculty: ", programmes.faculty);
                io:println("Registration Date: ", programmes.registration_date);
                io:println("Mascot: ", programmes.description);
                io:println("Registration Year: ", programmes.reg_year);
            }
            "6" => {
                // Fetch programmes by faculty
                string faculty = io:readln("Enter programme code to retrieve the data: ");
                Programme[] programmes = check programmeClient->/getByfaculty/[faculty]();
                io:println("\n📚 Programme:");
                foreach var prog in programmes {
                    io:println(string `${prog.code}: ${prog.qualification_title} (${prog.faculty}) ${prog.registration_date}- Mascot: ${prog.description}`);
                }
            }
            "7" => {
                // Fetch programmes that are due for review
                Programme[] programmes = check programmeClient->/getDueYear();
                io:println("\n📚 Programme that are due:");
                foreach var prog in programmes {
                    io:println(string `${prog.code}: ${prog.qualification_title} (${prog.faculty}) ${prog.registration_date}- Mascot: ${prog.description}`);
                }
            }
            "8" => {
                // Fetch a random fun fact about a course in a programme
                string code = io:readln("Enter programme code for a random fun fact: ");
                string result = check programmeClient->/random_fun_fact/[code];
                io:println(result);
            }
            "9" => {
                // Exit the system
                io:println("👋 Thanks for using the Fun Programme Management System! Have a great day!");
                return;
            }
            _ => {
                // Handle invalid input
                io:println("❌ Invalid choice. Please try again.");
            }
        }

    }
}
