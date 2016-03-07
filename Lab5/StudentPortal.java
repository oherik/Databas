/* This is the driving engine of the program. It parses the command-line
 * arguments and calls the appropriate methods in the other classes.
 *
 * You should edit this file in two ways:
 * 1) Insert your database username and password in the proper places.
 * 2) Implement the three functions getInformation, registerStudent
 *    and unregisterStudent.
 */
import java.sql.*; // JDBC stuff.
import java.util.Properties;
import java.util.Scanner;
import java.io.*;  // Reading user input.

public class StudentPortal
{
    /* TODO Here you should put your database name, username and password */
    static final String USERNAME = "tda357_053";
    static final String PASSWORD = "UqkUyZpd";

    /* Print command usage.
     * /!\ you don't need to change this function! */
    public static void usage () {
        System.out.println("Usage:");
        System.out.println("    i[nformation]");
        System.out.println("    r[egister] <course>");
        System.out.println("    u[nregister] <course>");
        System.out.println("    q[uit]");
    }

    /* main: parses the input commands.
     * /!\ You don't need to change this function! */
    public static void main(String[] args) throws Exception
    {
        try {
            Class.forName("org.postgresql.Driver");
            String url = "jdbc:postgresql://ate.ita.chalmers.se/";
            Properties props = new Properties();
            props.setProperty("user",USERNAME);
            props.setProperty("password",PASSWORD);
            Connection conn = DriverManager.getConnection(url, props);

            String student = args[0]; // This is the identifier for the student.

            Console console = System.console();
            usage();
            System.out.println("Welcome!");
            while(true) {
                String mode = console.readLine("? > ");
                String[] cmd = mode.split(" +");
                cmd[0] = cmd[0].toLowerCase();
                if ("information".startsWith(cmd[0]) && cmd.length == 1) {
                    /* Information mode */
                    getInformation(conn, student);
                } else if ("register".startsWith(cmd[0]) && cmd.length == 2) {
                    /* Register student mode */
                    registerStudent(conn, student, cmd[1]);
                } else if ("unregister".startsWith(cmd[0]) && cmd.length == 2) {
                    /* Unregister student mode */
                    unregisterStudent(conn, student, cmd[1]);
                } else if ("quit".startsWith(cmd[0])) {
                    break;
                } else usage();
            }
            System.out.println("Goodbye!");
            conn.close();
        } catch (SQLException e) {
            System.err.println(e);
            System.exit(2);
        }
    }

    /* Given a student identification number, ths function should print
     * - the name of the student, the students national identification number
     *   and their issued login name (something similar to a CID)
     * - the programme and branch (if any) that the student is following.
     * - the courses that the student has read, along with the grade.
     * - the courses that the student is registered to. (queue position if the student is waiting for the course)
     * - the number of mandatory courses that the student has yet to read.
     * - whether or not the student fulfills the requirements for graduation
     */
    static void getInformation(Connection conn, String student) throws SQLException
    {
        System.out.println("Information for student " + student);
        System.out.println("------------------------------------");
        Statement st = conn.createStatement(); // start new statement *
        ResultSet rs = // get the query results 
        st.executeQuery("SELECT * FROM StudentsFollowing WHERE NationalID = '" + student + "'") ;

        while (rs.next()) { // loop through all results *
            System.out.println("Name: " +rs.getString("Name"));
            System.out.println("StudentID: " +rs.getString("SchoolID"));
            System.out.println("Line: " + rs.getString("Programme"));
            String branch = rs.getString("Branch");
            if(branch != null && !branch.equals(""))
                System.out.println("Branch:\t" + branch);
            System.out.println("");

        }
        rs.close(); // get ready for new query *
        System.out.println("Read courses (name (code), credits: grade):");
        rs = st.executeQuery("SELECT * FROM FinishedCourses WHERE Student = '" + student + "'") ;

        while (rs.next()) { // loop through all results *
            System.out.println(" " + rs.getString("CourseName") + " (" + rs.getString("CourseCode") + "), " +
                    rs.getString("Credit") +"p: "+ rs.getString("Grade"));        }
        rs.close(); // get ready for new query *
        System.out.println("");
        System.out.println("Registered courses (name (code): status):");
        rs = st.executeQuery("SELECT * FROM Registrations FULL JOIN IsOnWaitingList ON Registrations.Student = IsOnWaitingList.Student AND Registrations.CourseCode = IsOnWaitingList.RestrictedCourse WHERE Registrations.Student = '" + student + "'");

        while (rs.next()) { // loop through all results *
            if(rs.getString(4).equals("Waiting")){
                System.out.println(" " +rs.getString("CourseName") + " (" + rs.getString("CourseCode") + "): " + rs.getString("Status") + " as nr " + rs.getString(7) );
            } else{
                System.out.println(" " +rs.getString("CourseName") + " (" + rs.getString("CourseCode") + "): " + rs.getString("Status"));
            }
        }
        rs.close(); // get ready for new query *
        System.out.println("");
        rs = st.executeQuery("SELECT * FROM PathToGraduation WHERE Student = '" + student + "'");

        while (rs.next()) { // loop through all results *
            System.out.println("Seminar courses taken: " + rs.getString(6));
            System.out.println("Math credits taken: " + rs.getString(4));
            System.out.println("Research credits taken: " + rs.getString(5));
            System.out.println("Total credits taken: " + rs.getString(2));
            System.out.println("Fulfills the requirements for graduation: " + rs.getString(8));
        }
        rs.close(); // get ready for new query *
        System.out.println("------------------------------------");
        st.close(); // get ready for new statement *
    }

    /* Register: Given a student id number and a course code, this function
     * should try to register the student for that course.
     */
    static void registerStudent(Connection conn, String student, String course)
    throws SQLException
    {
        PreparedStatement st =
                conn.prepareStatement("INSERT INTO Registrations VALUES (?,?)") ;
        st.setString(1,student) ;
        st.setString(2,course) ;
        st.executeUpdate() ;
        if(st.getWarnings() != null){
            System.out.println(st.getWarnings());
        } else {
            System.out.println("Student sucessfully registered to " + course);
        }

        st.close();
    }

    /* Unregister: Given a student id number and a course code, this function
     * should unregister the student from that course.
     */
    static void unregisterStudent(Connection conn, String student, String course)
    throws SQLException
    {
        PreparedStatement st = conn.prepareStatement("SELECT * FROM Registrations WHERE Student = ? AND " +
            "CourseCode = ?");
        st.setString(1,student);
        st.setString(2,course);
        ResultSet rs = st.executeQuery();
        if(!rs.next())
            System.out.println("The student " + student + " is not registered on or on a waiting list for " +
                "the course " + course + ".");
        else{
            st = conn.prepareStatement("DELETE FROM Registrations WHERE Student = ? AND " +
                "CourseCode = ?");
            st.setString(1,student) ;
            st.setString(2,course) ;
            st.executeUpdate();
            SQLWarning warning = st.getWarnings();
            if (warning != null){
                System.out.println("Warning: " + warning.getMessage());
            } else {
                System.out.println("The student" + student + " is no longer registered on " + course + ".");
            }
            st.close();
        }
    }
}
