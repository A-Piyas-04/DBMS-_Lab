import java.sql.*;

public class Main {
    public static void main(String[] args) {
        String username = "root";
        String password = "12345678";
        String url = "jdbc:mysql://localhost:3306/";

        // SQL queries to create the table and insert data
        String createTableQuery = "CREATE TABLE IF NOT EXISTS customer (" +
                "id INT AUTO_INCREMENT PRIMARY KEY, " +
                "name VARCHAR(100), " +
                "age INT)";

        String insertDataQuery = "INSERT INTO customer (name, age) VALUES " +
                "('Alice', 30), " +
                "('Bob', 25), " +
                "('Charlie', 35), " +
                "('David', 40), " +
                "('Eva', 29)";

        // Query to calculate average age
        String sqlQuery = "SELECT AVG(age) AS avg_age FROM customer";
        double avgAge = 0;

        try {
            // 1) Register the driver class
            Class.forName("com.mysql.cj.jdbc.Driver");

            // 2) Create the connection object
            Connection con = DriverManager.getConnection(url, username, password);
            System.out.println("Connection to database successful");

            // 3) Create the statement object
            Statement statement = con.createStatement();

            // 4) Create the table if not exists
            statement.executeUpdate(createTableQuery);
            System.out.println("Customer table created or already exists.");

            // 5) Insert sample data
            statement.executeUpdate(insertDataQuery);
            System.out.println("Sample data inserted into customer table.");

            // 6) Execute the query to calculate average age
            ResultSet result = statement.executeQuery(sqlQuery);
            if (result.next()) {
                avgAge = result.getDouble("avg_age");
            }
            System.out.println("Average age: " + avgAge);

            // 7) Close the connection, statement, and result set
            result.close();
            statement.close();
            con.close();

        } catch (SQLException e) {
            System.out.println("Error while connecting to database. Exception: " + e);
        } catch (ClassNotFoundException e) {
            System.out.println("Failed to register driver. Exception: " + e);
        }
    }
}