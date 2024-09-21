import ballerina/http;
import ballerina/io;
import ballerina/time;

// Define a record to store information about a course
type Course record {
    string course_name; // Name of the course
    string course_code; // Unique code for the course
    int nqf_level; // NQF level for the course
    string[] fun_facts = []; // Add fun facts about the course
};

// Define a record to store information about a programme
type Programme record {|
    readonly string code; // Unique code for the programme
    string faculty; // Faculty offering the programme
    string qualification_title; // Title of the qualification
     int nqf_level;
    string registration_date; // Registration date of the programme
    int reg_year; // Year the programme is due for review
    Course[] courses; // List of courses under this programme
    string mascot = ""; // Add a mascot for each programme
|};

// Table to store all programmes, keyed by programme code
table<Programme> key(code) programme_table = table [];

// Fun phrases to use in responses for adding some personality
string[] fun_phrases = [
    "Woohoo! ", 
    "Awesome sauce! ", 
    "Holy guacamole! ", 
    "Bazinga! ",
    "Cowabunga! "
];

// Simple random number generator to select a fun phrase or fact
function getRandomIndex(int max) returns int {
    time:Utc currentTime = time:utcNow(); // Get current time
    int nanoTime = currentTime[0]; // Get nanoseconds part of the time
    return nanoTime % max; // Use mod to get a random index
}

// Service to manage programmes, running on port 7500
service /programmeManagament on new http:Listener(7500) {

    // Resource to fetch all programmes
    resource function get all() returns Programme[] {
        io:println("🎉 Fetching all programmes! It's a knowledge party!");
        return programme_table.toArray(); // Convert table to an array
    }

    // Resource to fetch a programme by its code
    resource function get getByCode/[string code]() returns Programme|string {
        Programme? programme = programme_table.get(code); // Look up the programme by code
        if programme is Programme {
            io:println("🔍 Found the programme! It's like finding a needle in a haystack, but easier!");
            return programme; // Return the programme if found
        }
        return "😢 Oops! This programme is playing hide and seek. We couldn't find it!";
    }

    // Resource to fetch programmes by their faculty
    resource function get getByfaculty/[string faculty]() returns Programme[] {
        io:println("🏫 Searching for programmes in the " + faculty + " faculty. It's like a treasure hunt!");
        Programme[] result = from Programme programme in programme_table
                             where programme.faculty == faculty
                             select programme; // Filter programmes by faculty
        return result;
    }

    // Resource to add a new programme to the system
    resource function post add_new_programme(Programme programme) returns string {
        programme_table.add(programme); // Add the programme to the table
        string response = fun_phrases[getRandomIndex(fun_phrases.length())] + 
                          "The programme '" + programme.qualification_title + "' has joined the party!";
        io:println("🎊 " + response); // Print the fun response
        return response;
    }

    // Resource to update an existing programme by its code
    resource function put update_programme/[string code](Programme programme) returns string {
        if (programme_table.hasKey(code)) { // Check if the programme exists
            programme_table.put(programme); // Update the programme
            string response = "The programme got a makeover! It's now looking fabulous!";
            io:println("💅 " + response); // Print the fun response
            return response;
        }
        return "😱 Oh no! This programme is playing hide and seek. We couldn't find it to give it a makeover!";
    }

    // Resource to fetch programmes due for review in the current year
    resource function get getDueYear() returns Programme[]{
        time:Utc currentTime = time:utcNow(); // Get the current time
        time:Civil currentTime_Civil = time:utcToCivil(currentTime); // Convert to civil time
        int year = currentTime_Civil.year; // Get the current year

        table<Programme> due_programme = table[]; // Create a new table for due programmes
        foreach Programme programme in programme_table { // Iterate over programmes
            int programme_year = programme.reg_year;
            if((year - programme_year) >= 5){ // Check if the programme is due for review
                due_programme.add(programme); // Add to due programmes
            }
        }
        return due_programme.toArray(); // Convert the table to an array
    }

    // Resource to delete a programme by its code
    resource function delete delete_programme/[string code]() returns string {
        if (programme_table.hasKey(code)) { // Check if the programme exists
            Programme result = programme_table.remove(code); // Remove the programme
            string response = "Poof! The programme '" + result.qualification_title + "' has vanished into thin air!";
            io:println("🔮 " + response); // Print the fun response
            return response;
        }
        return "🕵️ Hmm... We couldn't find this programme. Maybe it already escaped?";
    }

    // New fun resource: Get a random fun fact about a course in a programme
    resource function get random_fun_fact/[string code]() returns string {
        Programme? programme = programme_table[code]; // Look up the programme by code
        if programme is Programme {
            if programme.courses.length() > 0 { // Check if the programme has courses
                int randomCourseIndex = getRandomIndex(programme.courses.length()); // Get a random course
                Course randomCourse = programme.courses[randomCourseIndex];
                if randomCourse.fun_facts.length() > 0 { // Check if the course has fun facts
                    int randomFactIndex = getRandomIndex(randomCourse.fun_facts.length()); // Get a random fun fact
                    return string `🎨 Fun fact about ${randomCourse.course_name}: ${randomCourse.fun_facts[randomFactIndex]}`;
                }
                return "🤔 Oops! We haven't added any fun facts to this course yet. It's a mystery!";
            }
            return "📚 This programme is shy and doesn't have any courses to share fun facts about!";
        }
        return "🕵️ Programme not found. It's playing hide and seek!";
    }

}
