package mvc.database;

import java.sql.Connection;
import java.sql.SQLException;
import java.sql.DriverManager;
import java.sql.PreparedStatement;

public class HobbyDBConnection {
   
   public static Connection getConnection() throws SQLException, ClassNotFoundException  {      

      Connection conn = null;      
   
      String url = "jdbc:mysql://localhost:3306/HobbyMe";
      String user = "root";
      String password = "1234";

      Class.forName("com.mysql.cj.jdbc.Driver");
      conn = DriverManager.getConnection(url, user, password);      
      
      return conn;
   }

}